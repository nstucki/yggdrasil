#!/usr/bin/env bash
#
# validate.sh — Read-only structural validator for the Yggdrasil project.
#
# This script performs five structural checks against the agent and skill
# definitions and reports a per-check summary plus a final PASS/FAIL verdict.
#
#   1. Frontmatter parse check — every agents/*.md and skills/**/SKILL.md has a
#      well-formed YAML frontmatter block (--- ... ---) containing the two
#      required top-level keys `name` and `description`.
#   2. Required skill sections — every SKILL.md contains the 5 required section
#      headers in the correct order.
#   3. Slug / name-field match — each skill's `name:` frontmatter value equals
#      its containing directory (the skill slug).
#   4. Odin shared-block sync — the three Odin agent files (odin-autonomous,
#      odin-guided, odin-interactive) contain a byte-identical body block from
#      the "## Responsibilities" line up to (not including) the
#      "## Communication Policy" line, compared by checksum (shasum -a 256,
#      falling back to cksum if shasum is unavailable).
#   5. Subagent isolation — subagent prompts (agents/<name>.md for mimir,
#      brokk, heimdall, kvasir, bragi) and their skills
#      (skills/<name>/*/SKILL.md) must not reference any other agent by name
#      (case-insensitive, word-boundary match). Self-references are allowed;
#      Odin's files and skills are exempt from this scan.
#
# GUARANTEE: This script is strictly READ-ONLY. It never creates, modifies, or
# deletes any project file, and performs no git write operations. It only reads
# and reports.
#
# Portability: targets both macOS bash 3.2 and modern bash. It intentionally
# avoids bash-4-only features (associative arrays, `mapfile`, `${var,,}`, etc.).
#
# Exit code: 0 if every check passes, non-zero if any check fails (CI gate).

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve the script's own directory portably, then the repository root.
# This lets the script run correctly regardless of the caller's CWD.
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

AGENTS_DIR="$REPO_ROOT/agents"
SKILLS_DIR="$REPO_ROOT/skills"

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
pass_msg() { printf '%s\n' "  ${C_GREEN}PASS${C_RESET} $*"; }
fail_msg() { printf '%s\n' "  ${C_RED}FAIL${C_RESET} $*"; }
warn_msg() { printf '%s\n' "  ${C_YELLOW}WARN${C_RESET} $*"; }
info_msg() { printf '%s\n' "  $*"; }

# Print a path relative to the repo root for tidy output; fall back to abs path.
rel() {
  case "$1" in
    "$REPO_ROOT"/*) printf '%s' "${1#$REPO_ROOT/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

# ---------------------------------------------------------------------------
# Global failure counters (one per check) and a running total.
# ---------------------------------------------------------------------------
FAIL_FRONTMATTER=0
FAIL_SECTIONS=0
FAIL_SLUG=0
FAIL_ODIN_SYNC=0
FAIL_ISOLATION=0

# The 5 required skill section headers, in their mandated order.
# Kept as a newline-delimited string to avoid array-portability concerns.
REQUIRED_SECTIONS='Purpose
When to Use
Workflow
Quality Criteria
Anti-Patterns'

# ---------------------------------------------------------------------------
# Helper: extract the frontmatter block (content between the first two `---`
# delimiter lines). Prints nothing and returns non-zero if the block is
# malformed (missing opening or closing delimiter).
# ---------------------------------------------------------------------------
extract_frontmatter() {
  local file="$1"
  awk '
    NR == 1 {
      if ($0 != "---") { exit 2 }   # must open with --- on line 1
      opened = 1
      next
    }
    opened && $0 == "---" {          # closing delimiter
      closed = 1
      exit 0
    }
    opened { print }                 # frontmatter body lines
    END {
      if (!closed) { exit 3 }        # never found a closing ---
    }
  ' "$file"
}

# Helper: read the value of a top-level frontmatter key. Only considers
# non-indented `key: value` lines so nested YAML (e.g. agent permission blocks)
# is ignored. Prints the trimmed value; empty if the key is absent.
frontmatter_value() {
  local file="$1" key="$2"
  extract_frontmatter "$file" 2>/dev/null | awk -v k="$key" '
    # Match a non-indented key at column 1, e.g. "name: foo".
    $0 ~ ("^" k ":") {
      sub("^" k ":[[:space:]]*", "")
      # Strip surrounding single/double quotes if present.
      gsub(/^["'\'']|["'\'']$/, "")
      # Trim trailing whitespace.
      sub(/[[:space:]]+$/, "")
      print
      exit
    }
  '
}

# Helper: does the frontmatter contain a given top-level key?
frontmatter_has_key() {
  local file="$1" key="$2"
  extract_frontmatter "$file" 2>/dev/null \
    | grep -Eq "^${key}:" && return 0
  return 1
}

# ---------------------------------------------------------------------------
# CHECK 1 — Frontmatter parse check.
# ---------------------------------------------------------------------------
check_frontmatter() {
  heading "Check 1: Frontmatter parse (agents + skills)"

  local file err

  # Agents: require a well-formed block containing at least `name` and `description`.
  for file in "$AGENTS_DIR"/*.md; do
    [ -e "$file" ] || continue
    if ! extract_frontmatter "$file" >/dev/null 2>&1; then
      err=$?
      fail_msg "$(rel "$file"): malformed frontmatter (missing opening/closing '---')"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
      continue
    fi
    if ! frontmatter_has_key "$file" "name"; then
      fail_msg "$(rel "$file"): frontmatter missing required key 'name'"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
    fi
    if ! frontmatter_has_key "$file" "description"; then
      fail_msg "$(rel "$file"): frontmatter missing required key 'description'"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
    fi
  done

  # Skills: require a well-formed block containing `name` and `description`.
  for file in $(find "$SKILLS_DIR" -name SKILL.md | sort); do
    if ! extract_frontmatter "$file" >/dev/null 2>&1; then
      fail_msg "$(rel "$file"): malformed frontmatter (missing opening/closing '---')"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
      continue
    fi
    if ! frontmatter_has_key "$file" "name"; then
      fail_msg "$(rel "$file"): frontmatter missing required key 'name'"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
    fi
    if ! frontmatter_has_key "$file" "description"; then
      fail_msg "$(rel "$file"): frontmatter missing required key 'description'"
      FAIL_FRONTMATTER=$((FAIL_FRONTMATTER + 1))
    fi
  done

  if [ "$FAIL_FRONTMATTER" -eq 0 ]; then
    pass_msg "all agent and skill files have well-formed frontmatter"
  else
    info_msg "${C_RED}${FAIL_FRONTMATTER} frontmatter failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 2 — Required skill sections present and in order.
#
# We collect the sequence of "## " headers from each SKILL.md, then check that
# the 5 required headers all appear and do so in the mandated relative order.
# ---------------------------------------------------------------------------
check_sections() {
  heading "Check 2: Required skill sections present & ordered"

  local file
  for file in $(find "$SKILLS_DIR" -name SKILL.md | sort); do
    # The ordered list of level-2 headers in this file, one per line.
    # Strip the leading "## " and any trailing whitespace.
    local headers
    headers=$(grep -E '^## ' "$file" | sed -E 's/^##[[:space:]]+//; s/[[:space:]]+$//' || true)

    local missing="" out_of_order=0
    local expected_idx=0   # index into REQUIRED_SECTIONS we expect to see next
    local req last_seen_pos=-1

    # First pass: report any missing required section.
    while IFS= read -r req; do
      [ -n "$req" ] || continue
      if ! printf '%s\n' "$headers" | grep -Fxq "$req"; then
        missing="${missing:+$missing, }$req"
      fi
    done <<EOF
$REQUIRED_SECTIONS
EOF

    # Second pass: verify order. Walk the file's headers; each time we hit a
    # required header it must not appear before one required earlier.
    # We compute the position of each required header within the file and
    # confirm the positions are strictly increasing in required order.
    if [ -z "$missing" ]; then
      local prev_pos=-1
      while IFS= read -r req; do
        [ -n "$req" ] || continue
        # Position (1-based line index within $headers) of this required header.
        local pos
        pos=$(printf '%s\n' "$headers" | grep -Fxn "$req" | head -1 | cut -d: -f1)
        if [ -n "$pos" ] && [ "$pos" -le "$prev_pos" ]; then
          out_of_order=1
        fi
        prev_pos="$pos"
      done <<EOF
$REQUIRED_SECTIONS
EOF
    fi

    if [ -n "$missing" ]; then
      fail_msg "$(rel "$file"): missing section(s): $missing"
      FAIL_SECTIONS=$((FAIL_SECTIONS + 1))
    elif [ "$out_of_order" -eq 1 ]; then
      fail_msg "$(rel "$file"): required sections present but out of order"
      info_msg "    expected order: Purpose, When to Use, Workflow, Quality Criteria, Anti-Patterns"
      info_msg "    found order:    $(printf '%s' "$headers" | tr '\n' '|' | sed 's/|/, /g; s/, $//')"
      FAIL_SECTIONS=$((FAIL_SECTIONS + 1))
    fi
  done

  if [ "$FAIL_SECTIONS" -eq 0 ]; then
    pass_msg "all skills contain the 5 required sections in the correct order"
  else
    info_msg "${C_RED}${FAIL_SECTIONS} section failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 3 — Slug / name-field match.
# The `name:` frontmatter value must equal the containing directory slug.
# ---------------------------------------------------------------------------
check_slug_match() {
  heading "Check 3: Skill name-field matches directory slug"

  local file slug name
  for file in $(find "$SKILLS_DIR" -name SKILL.md | sort); do
    slug=$(basename "$(dirname "$file")")
    name=$(frontmatter_value "$file" "name")
    if [ -z "$name" ]; then
      fail_msg "$(rel "$file"): could not read 'name' from frontmatter"
      FAIL_SLUG=$((FAIL_SLUG + 1))
    elif [ "$name" != "$slug" ]; then
      fail_msg "$(rel "$file"): name '$name' != directory slug '$slug'"
      FAIL_SLUG=$((FAIL_SLUG + 1))
    fi
  done

  if [ "$FAIL_SLUG" -eq 0 ]; then
    pass_msg "every skill's name field matches its directory slug"
  else
    info_msg "${C_RED}${FAIL_SLUG} slug mismatch(es)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 4 — Odin shared-block sync.
#
# The three Odin agent files must share a byte-identical body block starting
# at the line "## Responsibilities" and ending just before the line
# "## Communication Policy" (the start heading is included in the block, the
# end heading is not). We extract the block with awk and compare checksums.
#
# Checksum tool: prefers `shasum -a 256` (present on stock macOS and most
# Linux distros via perl); falls back to POSIX `cksum` if shasum is absent.
# ---------------------------------------------------------------------------
ODIN_SHARED_START='## Responsibilities'
ODIN_SHARED_END='## Communication Policy'
ODIN_FILES='odin-autonomous.md odin-guided.md odin-interactive.md'

# Read stdin, print a checksum token (read-only; no temp files).
block_checksum() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 | awk '{print $1}'
  else
    cksum | awk '{print $1 "-" $2}'
  fi
}

# Print the shared block of an Odin file: from the start heading (inclusive)
# up to the end heading (exclusive).
extract_odin_block() {
  awk -v start="$ODIN_SHARED_START" -v end="$ODIN_SHARED_END" '
    $0 == end   { exit }
    $0 == start { inblock = 1 }
    inblock     { print }
  ' "$1"
}

check_odin_sync() {
  heading "Check 4: Odin shared-block sync (agents/odin-*.md)"

  local f path sum ref_sum="" ref_name=""
  for f in $ODIN_FILES; do
    path="$AGENTS_DIR/$f"
    if [ ! -f "$path" ]; then
      fail_msg "agents/$f: file not found"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
      continue
    fi
    if ! grep -Fxq "$ODIN_SHARED_START" "$path"; then
      fail_msg "agents/$f: missing '$ODIN_SHARED_START' heading (cannot extract shared block)"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
      continue
    fi
    if ! grep -Fxq "$ODIN_SHARED_END" "$path"; then
      fail_msg "agents/$f: missing '$ODIN_SHARED_END' heading (cannot extract shared block)"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
      continue
    fi
    # Guard against empty extraction BEFORE checksumming: the checksum of
    # empty input is a valid non-empty string, so checking the checksum alone
    # would let all-empty extractions falsely compare equal (false PASS).
    # `wc -c` output is used unquoted: on macOS it carries leading spaces,
    # which word-splitting removes.
    if [ $(extract_odin_block "$path" | wc -c) -eq 0 ]; then
      fail_msg "agents/$f: shared block extraction produced no content"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
      continue
    fi
    sum=$(extract_odin_block "$path" | block_checksum)
    if [ -z "$sum" ]; then
      fail_msg "agents/$f: checksum tool produced no output (shasum/cksum failure)"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
      continue
    fi
    if [ -z "$ref_sum" ]; then
      ref_sum="$sum"
      ref_name="$f"
    elif [ "$sum" != "$ref_sum" ]; then
      fail_msg "agents/$f: shared block differs from agents/$ref_name"
      FAIL_ODIN_SYNC=$((FAIL_ODIN_SYNC + 1))
    fi
  done

  if [ "$FAIL_ODIN_SYNC" -eq 0 ]; then
    pass_msg "all 3 Odin agents share an identical Responsibilities → Communication Policy block"
  else
    info_msg "${C_RED}${FAIL_ODIN_SYNC} shared-block failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 5 — Subagent isolation.
#
# Subagents do not know about each other: each subagent's prompt
# (agents/<name>.md) and skills (skills/<name>/*/SKILL.md) must not mention
# any OTHER agent by name. Matching is case-insensitive with word boundaries
# (grep -iw), so word-internal occurrences such as "encoding", "Hardcoding",
# or "eroding" do not falsely match "odin". An agent's own name is allowed
# (self-references). Odin's files and skills are exempt (the orchestrator
# knows the full pantheon).
# ---------------------------------------------------------------------------
SUBAGENT_NAMES='mimir brokk heimdall kvasir bragi'
ALL_AGENT_NAMES='odin mimir brokk heimdall kvasir bragi'

check_isolation() {
  heading "Check 5: Subagent isolation (no cross-agent references)"

  local agent other file hit
  for agent in $SUBAGENT_NAMES; do
    for file in "$AGENTS_DIR/$agent.md" "$SKILLS_DIR/$agent"/*/SKILL.md; do
      [ -f "$file" ] || continue
      for other in $ALL_AGENT_NAMES; do
        [ "$other" = "$agent" ] && continue
        # -i: case-insensitive; -w: whole-word match; -n: line numbers.
        while IFS= read -r hit; do
          [ -n "$hit" ] || continue
          fail_msg "$(rel "$file"): line ${hit%%:*}: references other agent '$other'"
          FAIL_ISOLATION=$((FAIL_ISOLATION + 1))
        done <<EOF
$(grep -iwn "$other" "$file" 2>/dev/null || true)
EOF
      done
    done
  done

  if [ "$FAIL_ISOLATION" -eq 0 ]; then
    pass_msg "no subagent prompt or skill references another agent by name"
  else
    info_msg "${C_RED}${FAIL_ISOLATION} isolation violation(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# Main.
# ---------------------------------------------------------------------------
main() {
  printf '%s\n' "${C_BOLD}Yggdrasil validation — read-only structural checks${C_RESET}"
  printf '%s\n' "repository root: $(rel "$REPO_ROOT") ($REPO_ROOT)"
  printf '\n'

  # Guard: required directories must exist.
  if [ ! -d "$AGENTS_DIR" ]; then
    fail_msg "agents directory not found: $AGENTS_DIR"
    exit 2
  fi
  if [ ! -d "$SKILLS_DIR" ]; then
    fail_msg "skills directory not found: $SKILLS_DIR"
    exit 2
  fi

  check_frontmatter
  printf '\n'
  check_sections
  printf '\n'
  check_slug_match
  printf '\n'
  check_odin_sync
  printf '\n'
  check_isolation
  printf '\n'

  # ---- Final summary -------------------------------------------------------
  local total=$((FAIL_FRONTMATTER + FAIL_SECTIONS + FAIL_SLUG + FAIL_ODIN_SYNC + FAIL_ISOLATION))

  heading "Summary"
  printf '  %-34s %s\n' "Frontmatter parse:"        "$(fmt_count "$FAIL_FRONTMATTER")"
  printf '  %-34s %s\n' "Required sections/order:"  "$(fmt_count "$FAIL_SECTIONS")"
  printf '  %-34s %s\n' "Slug/name match:"          "$(fmt_count "$FAIL_SLUG")"
  printf '  %-34s %s\n' "Odin shared-block sync:"   "$(fmt_count "$FAIL_ODIN_SYNC")"
  printf '  %-34s %s\n' "Subagent isolation:"       "$(fmt_count "$FAIL_ISOLATION")"
  printf '  %s\n' "----------------------------------------------------"
  printf '  %-34s %s\n' "Total failures:" "$total"
  printf '\n'

  if [ "$total" -eq 0 ]; then
    printf '%s\n' "${C_BOLD}${C_GREEN}RESULT: PASS${C_RESET}"
    exit 0
  else
    printf '%s\n' "${C_BOLD}${C_RED}RESULT: FAIL (${total} failure(s))${C_RESET}"
    exit 1
  fi
}

# Format a per-check count with color: green "OK" for zero, red count otherwise.
fmt_count() {
  if [ "$1" -eq 0 ]; then
    printf '%s' "${C_GREEN}0 (OK)${C_RESET}"
  else
    printf '%s' "${C_RED}$1 failure(s)${C_RESET}"
  fi
}

main "$@"
