#!/usr/bin/env bash
#
# setup.sh — Yggdrasil setup script
#
# Copies agent and skill definitions from this repository into the
# OpenCode configuration directories (~/.config/opencode/agents/Yggdrasil/
# and ~/.config/opencode/skills/Yggdrasil/).
#
# Idempotent: safe to run multiple times.

set -o errexit
set -o nounset
set -o pipefail

# ── Colours & helpers ──────────────────────────────────────────────────────

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"   # No Colour

info()  { printf "${BOLD}📁  %s${NC}\n" "$*"; }
ok()    { printf "${GREEN}✅  %s${NC}\n" "$*"; }
warn()  { printf "${YELLOW}⚠️   %s${NC}\n" "$*"; }
err()   { printf "${RED}❌  %s${NC}\n" "$*" >&2; }

# ── Command-line arguments ─────────────────────────────────────────────────

# ASSUME_YES: when true, skip the interactive confirmation prompt entirely.
# This enables non-interactive/CI installs and closed-stdin invocations
# (e.g. `curl ... | bash`) without aborting.
ASSUME_YES=false

usage() {
    cat <<'EOF'
Usage: setup.sh [OPTIONS]

Install Yggdrasil agent and skill definitions into your OpenCode
configuration (~/.config/opencode/{agents,skills}/Yggdrasil/).

Options:
  -y, --yes, --force   Skip the confirmation prompt and proceed. Required for
                       non-interactive installs (CI, or `curl ... | bash`).
  -h, --help           Show this help and exit.

By default, if the target directories already contain files, you will be
prompted (y/N, default No) before merging. New and same-named Yggdrasil
files are added or overwritten; files removed or renamed upstream are NOT
deleted (see the confirmation prompt for details).
EOF
}

# Parse arguments early so --help works before any pre-flight checks.
while [ "$#" -gt 0 ]; do
    case "$1" in
        -y|--yes|--force)
            ASSUME_YES=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            err "Unknown option: $1"
            usage >&2
            exit 2
            ;;
        *)
            err "Unexpected argument: $1"
            usage >&2
            exit 2
            ;;
    esac
    shift
done

# The script takes NO positional operands. A bare positional is already
# rejected in the loop above (exit 2); reject any that survive `--` too, so
# `./setup.sh -- foo` behaves like `./setup.sh foo` (both rejected).
if [ "$#" -gt 0 ]; then
    err "Unexpected argument: $1"
    usage >&2
    exit 2
fi

# ── Resolve script location ───────────────────────────────────────────────

# Resolve the absolute directory of this script in a portable way.
# Works on both macOS (BSD) and Linux (GNU).
SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="${SCRIPT_DIR}/${SCRIPT_SOURCE}"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

# ── Configuration ──────────────────────────────────────────────────────────

SRC_AGENTS="${SCRIPT_DIR}/agents"
SRC_SKILLS="${SCRIPT_DIR}/skills"

# HOME must be non-empty before we build the destination paths: `set -u`
# catches an UNSET HOME, but an EMPTY HOME (HOME="") would make DST_BASE
# "/.config/opencode" and cause an install at the filesystem root.
if [ -z "${HOME:-}" ]; then
    err "Refusing to install: HOME is empty."
    err "Set HOME to your home directory and re-run."
    exit 1
fi

DST_BASE="${HOME}/.config/opencode"
DST_AGENTS="${DST_BASE}/agents/Yggdrasil"
DST_SKILLS="${DST_BASE}/skills/Yggdrasil"

# ── Pre-flight checks ──────────────────────────────────────────────────────

if [ ! -d "$SRC_AGENTS" ]; then
    err "Source directory not found: ${SRC_AGENTS}"
    err "Make sure you are running this script from the Yggdrasil repository root."
    exit 1
fi

if [ ! -d "$SRC_SKILLS" ]; then
    err "Source directory not found: ${SRC_SKILLS}"
    err "Make sure you are running this script from the Yggdrasil repository root."
    exit 1
fi

# ── Check for existing files and prompt ─────────────────────────────────────

needs_prompt=false
if [ -d "$DST_AGENTS" ] && [ -n "$(ls -A "$DST_AGENTS" 2>/dev/null)" ]; then
    needs_prompt=true
elif [ -d "$DST_SKILLS" ] && [ -n "$(ls -A "$DST_SKILLS" 2>/dev/null)" ]; then
    needs_prompt=true
fi

if [ "$needs_prompt" = true ] && [ "$ASSUME_YES" != true ]; then
    # Merge semantics (add/overwrite, never delete) are described in the
    # prompt below and in usage().
    warn "Target directories already contain files."
    printf "    Yggdrasil definitions will be merged in: same-named files are\n"
    printf "    updated (overwritten), new files are added, and files unrelated to\n"
    printf "    this project are preserved. Note: files removed or renamed upstream\n"
    printf "    are NOT deleted and may remain as orphans in:\n"
    printf "      %s\n" "$DST_AGENTS"
    printf "      %s\n" "$DST_SKILLS"
    printf "${YELLOW}⚠️   Continue?${NC} [y/N] "

    # Under `set -e`, a bare `read` on closed/non-terminal stdin (e.g.
    # `curl ... | bash`) returns non-zero and would abort abruptly. Detect a
    # non-terminal stdin and abort SAFELY with a clear message instead. When
    # --yes/-y is given we never reach this block (skipped above).
    if ! [ -t 0 ]; then
        printf "\n"
        err "Cannot prompt: stdin is not a terminal (non-interactive run)."
        err "Re-run with --yes (or -y/--force) to install non-interactively."
        exit 1
    fi

    read -r REPLY
    case "$REPLY" in
        y|Y)
            ;;
        *)
            echo "Skipping installation."
            exit 0
            ;;
    esac
fi

# ── Safety guard: ensure we only write into the Yggdrasil namespace ──────────
# Assert the destination paths are non-empty and end in the expected
# `/Yggdrasil` namespace under the config base. Logical paths are compared
# (symlinks are NOT resolved), so stow/yadm-managed config dirs are accepted.
if [ -z "$DST_BASE" ] || [ -z "$DST_AGENTS" ] || [ -z "$DST_SKILLS" ]; then
    err "Refusing to install: computed destination paths are empty."
    err "Check that HOME is set correctly (HOME=\"${HOME:-}\")."
    exit 1
fi

case "$DST_AGENTS" in
    "${DST_BASE}"/*/Yggdrasil) ;;
    *)
        err "Refusing to install outside the Yggdrasil namespace: ${DST_AGENTS}"
        exit 1
        ;;
esac

case "$DST_SKILLS" in
    "${DST_BASE}"/*/Yggdrasil) ;;
    *)
        err "Refusing to install outside the Yggdrasil namespace: ${DST_SKILLS}"
        exit 1
        ;;
esac

# ── Install agents ─────────────────────────────────────────────────────────

info "Creating agents directory…"
mkdir -p "$DST_AGENTS"

info "Copying agents to ${DST_AGENTS}…"
# Merge copy: copies Yggdrasil agent definitions into the destination.
# Pre-existing files in the destination that are NOT part of this project are preserved.
cp -R "${SRC_AGENTS}/." "$DST_AGENTS/"
ok "Agents installed."

# ── Install skills ─────────────────────────────────────────────────────────

info "Creating skills directory…"
mkdir -p "$DST_SKILLS"

info "Copying skills to ${DST_SKILLS}…"
# Merge copy: copies Yggdrasil skill definitions into the destination.
# Pre-existing files in the destination that are NOT part of this project are preserved.
cp -R "${SRC_SKILLS}/." "$DST_SKILLS/"
ok "Skills installed."

# ── Summary ────────────────────────────────────────────────────────────────

printf "\n"
ok "Yggdrasil setup complete!"
printf "    Agents → %s\n" "$DST_AGENTS"
printf "    Skills → %s\n" "$DST_SKILLS"
