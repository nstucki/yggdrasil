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

if [ "$needs_prompt" = true ]; then
    printf "${YELLOW}⚠️   Target directories already contain files. Yggdrasil definitions will be merged in; existing files NOT part of this project will be preserved (only same-named Yggdrasil files are updated). Continue?${NC} [y/N] "
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
# Compare logical paths (do NOT resolve symlinks, so symlinked config dirs
# managed by dotfile tools like stow/yadm are not falsely rejected).
EXPECTED_AGENTS="${DST_BASE}/agents/Yggdrasil"
EXPECTED_SKILLS="${DST_BASE}/skills/Yggdrasil"

if [[ "$DST_AGENTS" != "$EXPECTED_AGENTS" ]]; then
    err "Refusing to install outside the Yggdrasil namespace: ${DST_AGENTS}"
    exit 1
fi

if [[ "$DST_SKILLS" != "$EXPECTED_SKILLS" ]]; then
    err "Refusing to install outside the Yggdrasil namespace: ${DST_SKILLS}"
    exit 1
fi

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
