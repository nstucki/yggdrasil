#!/usr/bin/env bash
#
# verify.sh — Run the full CI check suite locally.
#
# This script mirrors .github/workflows/ci.yml. CI splits its work across three
# parallel jobs; that split exists for CI's runtime budget and per-step failure
# attribution in the GitHub UI, so it is deliberately NOT reproduced here — this
# script runs the same checks sequentially in one terminal:
#
#   structure job -> validate, smoke-odin, smoke-subagent, smoke-capability
#   lint job      -> shellcheck, markdownlint, yamllint
#   links job     -> links
#
# Each check runs in its own function, reports PASS / FAIL / SKIPPED, and the
# run ends with a summary table. The exit code is non-zero if any check failed
# or was skipped because its tool is not installed.
#
# Deliberate deviations from ci.yml, and why:
#
#   1. yamllint output format. CI passes `--format github`, which emits GitHub
#      Actions annotation syntax (::error file=...). That is noise in a local
#      terminal, so this script uses yamllint's default format. The files
#      scanned and the pass/fail outcome are identical.
#   2. File enumeration. CI enumerates with `find`, which is safe on a fresh
#      checkout because a checkout contains tracked files only. Locally a work
#      tree also holds untracked and gitignored paths (for example the
#      transient .yggdrasil-workspace/ scratch tree), so this script enumerates
#      with `git ls-files` for the shellcheck and links checks. That matches
#      what CI actually sees and avoids GNU/BSD `find` portability differences.
#      Caveat: a brand-new file is invisible to these two checks until it is
#      `git add`ed, because only then does it enter the index — which is also
#      exactly when CI would start seeing it.
#      The markdownlint check keeps CI's glob verbatim; its exclusions live in
#      .markdownlintignore.
#
# Usage:
#   verify.sh                      # run every check
#   verify.sh --skip links         # run every check except the link check
#   verify.sh --only markdownlint  # run a single check
#   verify.sh --help
#
# Portability: targets macOS bash 3.2 (the primary local environment) as well
# as modern bash, and avoids GNU-only flags. It requires no package.json, no
# Makefile, and no container runtime.

set -euo pipefail

# ---------------------------------------------------------------------------
# Pinned tool versions.
# keep in sync with .github/workflows/ci.yml env:
# ---------------------------------------------------------------------------
MARKDOWNLINT_VERSION="0.45.0"
MARKDOWN_LINK_CHECK_VERSION="3.12.2"
YAMLLINT_VERSION="1.37.1"

# ---------------------------------------------------------------------------
# Resolve the script's own directory portably, then the repository root, so the
# script runs correctly regardless of the caller's CWD.
# ---------------------------------------------------------------------------
resolve_script_dir() {
  # Resolve symlinks step-by-step without relying on GNU `readlink -f`.
  local src="${BASH_SOURCE[0]}"
  local dir
  while [ -h "$src" ]; do
    dir=$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
    src=$(readlink "$src")
    # If $src was a relative symlink, resolve it relative to $dir.
    case "$src" in
      /*) ;;
      *) src="$dir/$src" ;;
    esac
  done
  cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd
}

SCRIPT_DIR=$(resolve_script_dir)
# The repository root is the parent of scripts/.
REPO_ROOT=$(cd -P "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)

# ---------------------------------------------------------------------------
# Output helpers. Use color only when stdout is a TTY; otherwise emit plain
# text so piped/redirected output contains no raw escape codes.
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
  C_RESET=$'\033[0m'
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
  C_BOLD=$'\033[1m'
else
  C_RESET=""
  C_RED=""
  C_GREEN=""
  C_YELLOW=""
  C_BLUE=""
  C_BOLD=""
fi

heading()  { printf '%s\n' "${C_BOLD}${C_BLUE}==> $*${C_RESET}"; }
warn_msg() { printf '%s\n' "  ${C_YELLOW}WARN${C_RESET} $*"; }
info_msg() { printf '%s\n' "  $*"; }

# ---------------------------------------------------------------------------
# Check registry. Order matches ci.yml: structure job, lint job, links job.
# Kept as a whitespace-delimited string to avoid array-portability concerns.
# ---------------------------------------------------------------------------
ALL_CHECKS='validate smoke-odin smoke-subagent smoke-capability shellcheck markdownlint yamllint links'

# Human-readable one-liner per check, shown in --help and before each run.
describe() {
  case "$1" in
    validate)         printf '%s' 'structural validator (scripts/validate.sh)' ;;
    smoke-odin)       printf '%s' 'Odin agent generator parity smoke test' ;;
    smoke-subagent)   printf '%s' 'subagent generator parity smoke test' ;;
    smoke-capability) printf '%s' 'capability generator smoke test' ;;
    shellcheck)       printf '%s' 'shellcheck --severity=warning over tracked *.sh' ;;
    markdownlint)     printf '%s' "markdownlint-cli ${MARKDOWNLINT_VERSION} over **/*.md" ;;
    yamllint)         printf '%s' "yamllint ${YAMLLINT_VERSION} over the repository" ;;
    links)            printf '%s' "markdown-link-check ${MARKDOWN_LINK_CHECK_VERSION} (slow, network-bound)" ;;
    *)                printf '%s' 'unknown check' ;;
  esac
}

# Status strings recorded in the summary table.
S_PASS='PASS'
S_FAIL='FAIL'
S_MISSING='SKIPPED (missing tool)'
S_SKIPPED='SKIPPED (--skip)'
S_NOTSEL='SKIPPED (not selected)'

# ---------------------------------------------------------------------------
# CLI parsing.
# ---------------------------------------------------------------------------
SKIP_LIST=''
ONLY_LIST=''

usage() {
  local name
  cat <<EOF
verify.sh — run every .github/workflows/ci.yml check locally.

Usage:
  verify.sh [--skip <check>]... [--only <check>]... [--help]

Options:
  --skip <check>   Do not run <check>. Repeatable. A check skipped this way
                   does not make the run fail. Typical use: --skip links,
                   because the link check is slow and needs network access.
  --only <check>   Run only <check>. Repeatable. Mutually exclusive with --skip.
  -h, --help       Show this message and exit.

Checks (in run order):
EOF
  for name in $ALL_CHECKS; do
    printf '  %-17s %s\n' "$name" "$(describe "$name")"
  done
  cat <<EOF

Exit code:
  0  every selected check passed
  1  a check failed, or a check was skipped because its tool is not installed
  2  bad usage (unknown option or unknown check name)

Tool versions are pinned to match .github/workflows/ci.yml. When a required
tool is missing, the check is reported as SKIPPED (missing tool) and the exact
install command is printed instead of aborting the whole run.
EOF
}

# Is <name> a known check?
is_known_check() {
  local candidate="$1" name
  for name in $ALL_CHECKS; do
    if [ "$name" = "$candidate" ]; then
      return 0
    fi
  done
  return 1
}

# Is <name> present in the whitespace-delimited list <list>?
in_list() {
  local candidate="$1" list="$2" name
  for name in $list; do
    if [ "$name" = "$candidate" ]; then
      return 0
    fi
  done
  return 1
}

parse_args() {
  while [ "${1:-}" != "" ]; do
    case "$1" in
      --skip)
        shift
        if [ -z "${1:-}" ]; then
          printf '%s\n' "Error: --skip requires a check name" >&2
          exit 2
        fi
        SKIP_LIST="$SKIP_LIST $1"
        shift
        ;;
      --only)
        shift
        if [ -z "${1:-}" ]; then
          printf '%s\n' "Error: --only requires a check name" >&2
          exit 2
        fi
        ONLY_LIST="$ONLY_LIST $1"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        printf '%s\n' "Error: unknown option: $1" >&2
        printf '%s\n' "Run 'verify.sh --help' for usage." >&2
        exit 2
        ;;
    esac
  done

  if [ -n "$SKIP_LIST" ] && [ -n "$ONLY_LIST" ]; then
    printf '%s\n' "Error: --skip and --only are mutually exclusive" >&2
    exit 2
  fi

  local name
  for name in $SKIP_LIST $ONLY_LIST; do
    if ! is_known_check "$name"; then
      printf '%s\n' "Error: unknown check: $name" >&2
      printf '%s\n' "Known checks: $ALL_CHECKS" >&2
      exit 2
    fi
  done
}

# ---------------------------------------------------------------------------
# Tool preflight. A missing tool downgrades one check to SKIPPED instead of
# crashing the run, and prints the exact command that installs it.
# ---------------------------------------------------------------------------

# require_tool <command> <install command>
require_tool() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  fi
  warn_msg "$1 is not installed. Install it with:"
  info_msg "  $2"
  return 1
}

# require_git — the shellcheck and links checks enumerate tracked files.
require_git() {
  if ! command -v git >/dev/null 2>&1; then
    warn_msg "git is not installed. Install it with:"
    info_msg "  brew install git"
    return 1
  fi
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warn_msg "not inside a git work tree, cannot enumerate tracked files"
    return 1
  fi
  return 0
}

# How to invoke yamllint. A pip *user* install on macOS puts the console
# script in ~/Library/Python/X.Y/bin, which is not on PATH by default, so
# yamllint is frequently installed yet invisible to `command -v`. Fall back to
# the module form rather than reporting an installed tool as missing.
YAMLLINT_CMD=(yamllint)

resolve_yamllint() {
  if command -v yamllint >/dev/null 2>&1; then
    YAMLLINT_CMD=(yamllint)
    return 0
  fi
  if python3 -c 'import yamllint' >/dev/null 2>&1; then
    YAMLLINT_CMD=(python3 -m yamllint)
    info_msg "no yamllint on PATH, using 'python3 -m yamllint'"
    return 0
  fi
  warn_msg "yamllint is not installed. Install it with:"
  info_msg "  python3 -m pip install yamllint==${YAMLLINT_VERSION}"
  return 1
}

# warn_version <tool> <pinned version> <reported version string>
# Non-fatal: a near-enough version still runs, it is only flagged.
warn_version() {
  case "$3" in
    *"$2"*) return 0 ;;
  esac
  warn_msg "$1 version differs from the CI pin $2 (reported: ${3:-unknown})"
  info_msg "  results may not match CI exactly"
  return 0
}

preflight() {
  local reported
  case "$1" in
    validate|smoke-odin|smoke-subagent|smoke-capability)
      # Repository-owned bash scripts; no external tooling required.
      return 0
      ;;
    shellcheck)
      # CI uses the shellcheck preinstalled on ubuntu-latest and pins no
      # version, so only presence is checked here.
      require_tool shellcheck 'brew install shellcheck' || return 1
      require_git || return 1
      ;;
    markdownlint)
      require_tool markdownlint "npm i -g markdownlint-cli@${MARKDOWNLINT_VERSION}" || return 1
      reported=$(markdownlint --version 2>/dev/null || true)
      warn_version markdownlint "$MARKDOWNLINT_VERSION" "$reported"
      ;;
    yamllint)
      resolve_yamllint || return 1
      reported=$("${YAMLLINT_CMD[@]}" --version 2>/dev/null || true)
      warn_version yamllint "$YAMLLINT_VERSION" "$reported"
      ;;
    links)
      require_tool markdown-link-check "npm i -g markdown-link-check@${MARKDOWN_LINK_CHECK_VERSION}" || return 1
      require_git || return 1
      reported=$(markdown-link-check --version 2>/dev/null || true)
      warn_version markdown-link-check "$MARKDOWN_LINK_CHECK_VERSION" "$reported"
      ;;
  esac
  return 0
}

# ---------------------------------------------------------------------------
# The checks themselves. One function per check; each returns 0 on pass and
# non-zero on fail. All of them run with the repository root as CWD.
# ---------------------------------------------------------------------------

check_validate() {
  bash "$REPO_ROOT/scripts/validate.sh"
}

check_smoke_odin() {
  bash "$REPO_ROOT/scripts/ci-smoke-odin-generator.sh"
}

check_smoke_subagent() {
  bash "$REPO_ROOT/scripts/ci-smoke-subagent-generator.sh"
}

check_smoke_capability() {
  bash "$REPO_ROOT/scripts/ci-smoke-generator.sh"
}

# ci.yml: shellcheck --severity=warning --format=gcc over every *.sh.
# Enumerated from the git index rather than with `find` (see header note 2).
check_shellcheck() {
  local file
  local files=()
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(git ls-files -z -- '*.sh')

  if [ "${#files[@]}" -eq 0 ]; then
    warn_msg "no tracked *.sh files found"
    return 0
  fi

  info_msg "linting ${#files[@]} tracked shell script(s)"
  shellcheck --severity=warning --format=gcc "${files[@]}"
}

# ci.yml: markdownlint --ignore node_modules '**/*.md'. The glob is CI's
# verbatim; path exclusions (docs/, .yggdrasil-workspace/, node_modules/) come
# from .markdownlintignore, which markdownlint-cli loads from the CWD.
check_markdownlint() {
  markdownlint --ignore node_modules '**/*.md'
}

# ci.yml: yamllint --format github . — the local run uses the default output
# format instead, because GitHub annotation syntax is terminal noise. Scope and
# pass/fail behaviour are unchanged (see header note 1).
check_yamllint() {
  "${YAMLLINT_CMD[@]}" .
}

# ci.yml: one markdown-link-check invocation per Markdown file, so a single
# dead link does not stop the remaining files from being checked. Slow and
# network-bound; skip it with --skip links when offline.
check_links() {
  local rc=0
  local file
  local files=()
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(git ls-files -z -- '*.md')

  if [ "${#files[@]}" -eq 0 ]; then
    warn_msg "no tracked *.md files found"
    return 0
  fi

  info_msg "checking links in ${#files[@]} tracked Markdown file(s)"
  for file in "${files[@]}"; do
    markdown-link-check --quiet --config .markdown-link-check.json "$file" || rc=1
  done
  return "$rc"
}

# Dispatch a check by its registry name.
run_check() {
  case "$1" in
    validate)         check_validate ;;
    smoke-odin)       check_smoke_odin ;;
    smoke-subagent)   check_smoke_subagent ;;
    smoke-capability) check_smoke_capability ;;
    shellcheck)       check_shellcheck ;;
    markdownlint)     check_markdownlint ;;
    yamllint)         check_yamllint ;;
    links)            check_links ;;
    *)
      printf '%s\n' "Error: no runner for check: $1" >&2
      return 2
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Result bookkeeping. Results accumulate as "name|status" lines (bash 3.2 has
# no associative arrays).
# ---------------------------------------------------------------------------
RESULTS=''
FAILURES=0
MISSING_TOOLS=0

record() {
  RESULTS="${RESULTS}${1}|${2}
"
}

colorize_status() {
  case "$1" in
    "$S_PASS") printf '%s' "${C_GREEN}$1${C_RESET}" ;;
    "$S_FAIL") printf '%s' "${C_RED}$1${C_RESET}" ;;
    "$S_MISSING") printf '%s' "${C_YELLOW}$1${C_RESET}" ;;
    *) printf '%s' "$1" ;;
  esac
}

summary() {
  local line name status

  heading "Summary"
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    name="${line%%|*}"
    status="${line#*|}"
    printf '  %-17s %s\n' "$name" "$(colorize_status "$status")"
  done <<EOF
$RESULTS
EOF
  printf '  %s\n' "-------------------------------------------"
  printf '  %-17s %s\n' "failed:" "$FAILURES"
  printf '  %-17s %s\n' "missing tools:" "$MISSING_TOOLS"
  printf '\n'

  if [ "$FAILURES" -eq 0 ] && [ "$MISSING_TOOLS" -eq 0 ]; then
    printf '%s\n' "${C_BOLD}${C_GREEN}RESULT: PASS${C_RESET}"
    return 0
  fi
  if [ "$FAILURES" -gt 0 ]; then
    printf '%s\n' "${C_BOLD}${C_RED}RESULT: FAIL (${FAILURES} check(s) failed, ${MISSING_TOOLS} skipped for missing tools)${C_RESET}"
  else
    printf '%s\n' "${C_BOLD}${C_RED}RESULT: INCOMPLETE (${MISSING_TOOLS} check(s) skipped for missing tools)${C_RESET}"
  fi
  return 1
}

# ---------------------------------------------------------------------------
# Main.
# ---------------------------------------------------------------------------
main() {
  parse_args "$@"

  # Every check is defined relative to the repository root: markdownlint reads
  # .markdownlintignore from the CWD, yamllint scans '.', and git ls-files
  # pathspecs resolve against it.
  cd "$REPO_ROOT"

  printf '%s\n' "${C_BOLD}Yggdrasil verify — local mirror of .github/workflows/ci.yml${C_RESET}"
  printf '%s\n' "repository root: $REPO_ROOT"
  printf '\n'

  local name
  for name in $ALL_CHECKS; do
    if [ -n "$ONLY_LIST" ] && ! in_list "$name" "$ONLY_LIST"; then
      record "$name" "$S_NOTSEL"
      continue
    fi
    if in_list "$name" "$SKIP_LIST"; then
      record "$name" "$S_SKIPPED"
      continue
    fi

    heading "$name — $(describe "$name")"
    if ! preflight "$name"; then
      record "$name" "$S_MISSING"
      MISSING_TOOLS=$((MISSING_TOOLS + 1))
      printf '\n'
      continue
    fi
    if run_check "$name"; then
      record "$name" "$S_PASS"
    else
      record "$name" "$S_FAIL"
      FAILURES=$((FAILURES + 1))
    fi
    printf '\n'
  done

  if summary; then
    exit 0
  fi
  exit 1
}

main "$@"
