#!/usr/bin/env bash
#
# setup.sh — Yggdrasil setup script
#
# Copies agent and skill definitions from this repository into the
# OpenCode configuration directories (by default, ~/.config/opencode/agents/yggdrasil/
# and ~/.config/opencode/skills/yggdrasil/). The base path is configurable via
# the OPENCODE_CONFIG_BASE environment variable or the -c/--config-base CLI flag.
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

# CONFIG_BASE: the base directory for OpenCode config.
# Computed from: environment variable > default.
# Can be overridden by the CLI flag --config-base (which takes precedence).
CONFIG_BASE=""

usage() {
    cat <<'EOF'
Usage: setup.sh [OPTIONS]

Install Yggdrasil agent and skill definitions into your OpenCode
configuration (by default, ~/.config/opencode/{agents,skills}/yggdrasil/).

Options:
  -c PATH, --config-base PATH   Set the OpenCode config base directory.
                                Defaults to ~/.config/opencode.
                                May also be set via OPENCODE_CONFIG_BASE env var.
  -y, --yes, --force            Skip the confirmation prompt and proceed. Required for
                                non-interactive installs (CI, or `curl ... | bash`).
  -h, --help                    Show this help and exit.

By default, if the target directories already contain files, you will be
prompted (y/N, default No) before merging. New and same-named Yggdrasil
files are added or overwritten; files removed or renamed upstream are NOT
deleted (see the confirmation prompt for details).
EOF
}

# Parse arguments early so --help works before any pre-flight checks.
while [ "$#" -gt 0 ]; do
    case "$1" in
         -c)
             # -c PATH form: next arg is the path
             shift
             if [ "$#" -eq 0 ]; then
                 err "Option -c requires an argument."
                 usage >&2
                 exit 2
             fi
             # Reject if next arg looks like a flag (starts with -)
             if [ "${1:0:1}" = "-" ]; then
                 err "Option -c requires a path argument (expected after -c, got flag: $1)."
                 usage >&2
                 exit 2
             fi
             # Reject truly empty flag arguments at parse time for early feedback
             if [ -z "$1" ]; then
                 err "Option -c requires a non-empty path argument."
                 usage >&2
                 exit 2
             fi
             CONFIG_BASE="$1"
             ;;
         --config-base)
             # --config-base PATH form: next arg is the path
             shift
             if [ "$#" -eq 0 ]; then
                 err "Option --config-base requires an argument."
                 usage >&2
                 exit 2
             fi
             # Reject if next arg looks like a flag (starts with -)
             if [ "${1:0:1}" = "-" ]; then
                 err "Option --config-base requires a path argument (expected after --config-base, got flag: $1)."
                 usage >&2
                 exit 2
             fi
             # Reject truly empty flag arguments at parse time for early feedback
             if [ -z "$1" ]; then
                 err "Option --config-base requires a non-empty path argument."
                 usage >&2
                 exit 2
             fi
             CONFIG_BASE="$1"
             ;;
         --config-base=*)
             # --config-base=PATH form: extract the path after =
             CONFIG_BASE="${1#--config-base=}"
             # Reject truly empty flag arguments at parse time for early feedback
             if [ -z "$CONFIG_BASE" ]; then
                 err "Option --config-base= requires a non-empty path argument."
                 usage >&2
                 exit 2
             fi
             ;;
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

# ── Compute config base path ───────────────────────────────────────────────

# HOME must be non-empty before we build the destination paths: `set -u`
# catches an UNSET HOME, but an EMPTY HOME (HOME="") would make DST_BASE
# "/.config/opencode" and cause an install at the filesystem root.
if [ -z "${HOME:-}" ]; then
    err "Refusing to install: HOME is empty."
    err "Set HOME to your home directory and re-run."
    exit 1
fi

# Precedence: CLI flag (CONFIG_BASE, set above) > environment variable > default.
# If CONFIG_BASE is empty, check the environment variable.
if [ -z "$CONFIG_BASE" ]; then
    CONFIG_BASE="${OPENCODE_CONFIG_BASE:-}"
fi

# If still empty, use the default.
if [ -z "$CONFIG_BASE" ]; then
    CONFIG_BASE="${HOME}/.config/opencode"
fi

# Normalize the config base path:
# 1. Trim leading/trailing whitespace
# 2. Expand leading ~ or ~/ to $HOME
# 3. Strip trailing slashes
# 4. Reject empty or whitespace-only values

# Trim leading and trailing whitespace (POSIX-portable, bash-3.2-safe)
CONFIG_BASE="$(printf '%s\n' "$CONFIG_BASE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

# Expand ~ or ~/...
case "$CONFIG_BASE" in
    ~)
        # Bare tilde: expand to HOME
        CONFIG_BASE="$HOME"
        ;;
    ~*)
        # Tilde followed by path: strip tilde and prepend HOME
        CONFIG_BASE="${HOME}${CONFIG_BASE#\~}"
        ;;
esac

# Strip trailing slashes
while [ "${CONFIG_BASE%/}" != "$CONFIG_BASE" ]; do
    CONFIG_BASE="${CONFIG_BASE%/}"
done

# After normalization, verify it's not empty or whitespace-only
if [ -z "$CONFIG_BASE" ]; then
    err "Refusing to install: config base path is empty or whitespace-only after normalization."
    err "Check your OPENCODE_CONFIG_BASE setting or --config-base flag."
    exit 2
fi

# ── Configuration ──────────────────────────────────────────────────────────

SRC_AGENTS="${SCRIPT_DIR}/agents"
SRC_SKILLS="${SCRIPT_DIR}/skills"
SRC_GENERATOR="${SCRIPT_DIR}/scripts/generate-capabilities.sh"

DST_BASE="$CONFIG_BASE"
DST_AGENTS="${DST_BASE}/agents/yggdrasil"
DST_SKILLS="${DST_BASE}/skills/yggdrasil"
DST_CONFIG_HOME="${DST_BASE}/yggdrasil"
DST_CUSTOM_CAPS="${DST_CONFIG_HOME}/custom-capabilities.yaml"
DST_GENERATOR="${DST_CONFIG_HOME}/generate-capabilities.sh"

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

# ── Prompt to copy default skills ──────────────────────────────────────────

# Resolve the skills prompt BEFORE the merge warning and any file writes, so
# that:
#  - The merge warning below only mentions the skills destination if the user
#    actually opted in to copying skills (otherwise the warning would be
#    misleading).
#  - On a fresh non-interactive install (e.g. `curl ... | bash` without --yes)
#    the script aborts here rather than after agents have already been copied
#    (which would leave a partial install: agents present, no skills).
#
# Default to copying skills. Under --yes/-y (ASSUME_YES) the prompt is skipped
# and skills are installed unconditionally (current behaviour). In interactive
# mode, the user may decline to install the default skills.
COPY_SKILLS=true
if [ "$ASSUME_YES" != true ]; then
    if ! [ -t 0 ]; then
        err "Cannot prompt for skills: stdin is not a terminal (non-interactive run)."
        err "Re-run with --yes (or -y/--force) to install non-interactively."
        exit 1
    fi

    printf "${YELLOW}⚠️   Copy default skills?${NC} [Y/n] "
    read -r REPLY
    case "$REPLY" in
        n|N)
            COPY_SKILLS=false
            ;;
        *)
            ;;
    esac
fi

if [ "$COPY_SKILLS" != true ]; then
    info "Skipping skills installation."
fi

# ── Check for existing files and prompt ─────────────────────────────────────

# Agents are always copied, so a non-empty agents dir always triggers the
# warning. Skills are only mentioned when the user opted in (COPY_SKILLS=true);
# a non-empty skills dir does NOT trigger the warning if skills were declined.
needs_prompt=false
if [ -d "$DST_AGENTS" ] && [ -n "$(ls -A "$DST_AGENTS" 2>/dev/null)" ]; then
    needs_prompt=true
fi
if [ "$COPY_SKILLS" = true ] && [ -d "$DST_SKILLS" ] && [ -n "$(ls -A "$DST_SKILLS" 2>/dev/null)" ]; then
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
    if [ "$COPY_SKILLS" = true ]; then
        printf "      %s\n" "$DST_SKILLS"
    fi
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

# ── Safety guard: ensure we only write into the yggdrasil namespace ──────────
# Assert the destination paths are non-empty and end in the expected
# `/yggdrasil` namespace under the config base. Logical paths are compared
# (symlinks are NOT resolved), so stow/yadm-managed config dirs are accepted.
# Also permit the new config-home directory (DST_CONFIG_HOME) which is directly
# under DST_BASE and contains custom capabilities and installed tools.
if [ -z "$DST_BASE" ] || [ -z "$DST_AGENTS" ] || [ -z "$DST_SKILLS" ] || [ -z "$DST_CONFIG_HOME" ]; then
    err "Refusing to install: computed destination paths are empty."
    err "Check that HOME is set correctly (HOME=\"${HOME:-}\")."
    exit 1
fi

case "$DST_AGENTS" in
    "${DST_BASE}"/*/yggdrasil) ;;
    *)
        err "Refusing to install outside the yggdrasil namespace: ${DST_AGENTS}"
        exit 1
        ;;
esac

case "$DST_SKILLS" in
    "${DST_BASE}"/*/yggdrasil) ;;
    *)
        err "Refusing to install outside the yggdrasil namespace: ${DST_SKILLS}"
        exit 1
        ;;
esac

case "$DST_CONFIG_HOME" in
    "${DST_BASE}"/yggdrasil) ;;
    *)
        err "Refusing to install outside the yggdrasil namespace: ${DST_CONFIG_HOME}"
        exit 1
        ;;
esac

# ── Backup/warn for agent file diffs (U1 mitigation) ───────────────────────
# Before overwriting agent files, check if any existing file differs from the
# incoming version. If so, back it up and warn the user (to help recover
# manually-edited permission grants that would otherwise be lost on upgrade).
backup_differing_agents() {
    local differing_count=0
    local differing_files=""
    
    for src_file in "${SRC_AGENTS}"/*.md; do
        [ -f "$src_file" ] || continue
        filename=$(basename "$src_file")
        dst_file="${DST_AGENTS}/${filename}"
        
        # Only check if destination exists (not the first install).
        if [ -f "$dst_file" ]; then
            if ! diff -q "$src_file" "$dst_file" >/dev/null 2>&1; then
                # Files differ. Back up the destination file with timestamp.
                timestamp=$(date +%s)
                backup_file="${dst_file}.bak.${timestamp}"
                cp "$dst_file" "$backup_file"
                differing_count=$((differing_count + 1))
                differing_files="${differing_files}
    - $filename (backed up to $backup_file)"
            fi
        fi
    done
    
    if [ "$differing_count" -gt 0 ]; then
        warn "Agent definition files were modified locally and have been backed up."
        printf "    Modified files:%s\n" "$differing_files"
        printf "    \n"
        printf "    If you made custom permission edits (e.g., granting custom tools),\n"
        printf "    review the backups and re-apply your changes to the new versions.\n"
    fi
}

# ── Install agents ─────────────────────────────────────────────────────────

info "Creating agents directory…"
mkdir -p "$DST_AGENTS"

# Back up any locally-modified agent files before overwriting (U1 mitigation).
if [ -d "$DST_AGENTS" ] && [ -n "$(ls -A "$DST_AGENTS" 2>/dev/null)" ]; then
    backup_differing_agents
fi

info "Copying agents to ${DST_AGENTS}…"
# Merge copy: copies Yggdrasil agent definitions into the destination.
# Pre-existing files in the destination that are NOT part of this project are preserved.
cp -R "${SRC_AGENTS}/." "$DST_AGENTS/"
ok "Agents installed."

# ── Install skills ─────────────────────────────────────────────────────────

if [ "$COPY_SKILLS" = true ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_SKILLS"

    info "Copying skills to ${DST_SKILLS}…"
    # Merge copy: copies Yggdrasil skill definitions into the destination.
    # Pre-existing files in the destination that are NOT part of this project are preserved.
    cp -R "${SRC_SKILLS}/." "$DST_SKILLS/"
    ok "Skills installed."
fi

# ── Install generator and custom-capabilities scaffold ─────────────────────

info "Creating config home directory…"
mkdir -p "$DST_CONFIG_HOME"

info "Installing capability generator…"
cp "$SRC_GENERATOR" "$DST_GENERATOR"
chmod +x "$DST_GENERATOR"
ok "Generator installed to ${DST_GENERATOR}."

# Scaffold custom-capabilities.yaml: only install on first setup, never overwrite
# (to preserve user's custom tool grants across upgrades).
if [ ! -f "$DST_CUSTOM_CAPS" ]; then
    info "Creating custom-capabilities scaffold…"
    cp "${SCRIPT_DIR}/custom-capabilities.yaml" "$DST_CUSTOM_CAPS"
    ok "Custom capabilities scaffold created at ${DST_CUSTOM_CAPS}."
else
    ok "Custom capabilities file already exists (preserved: ${DST_CUSTOM_CAPS})."
fi

# ── Regenerate the capability mirror ─────────────────────────────────────────

# After agents and skills have been copied (and custom-caps scaffold is in place),
# regenerate the capability inventory. This ensures the installed capability inventory
# is always current after install/upgrade, applying any framework updates to the
# built-in skills and custom capabilities (if the user edited the scaffold).
# NOTE: The generated file is no longer committed to the repo; it's created fresh
# at install time. If skills were installed and regeneration fails, this is FATAL
# (a silent failure would leave no capability inventory at all, invisibly).
if [ "$COPY_SKILLS" = true ] && [ -d "$DST_SKILLS" ]; then
    info "Regenerating capability mirror…"
    if "$DST_GENERATOR" --config-base "$DST_BASE" >/dev/null 2>&1; then
        ok "Capability mirror regenerated."
    else
        err "Failed to regenerate capability mirror (skills were installed but inventory could not be created)."
        err "This is a fatal condition — the capability inventory is required for Odin and Kvasir to function."
        err "Run manually to diagnose: ${DST_GENERATOR} --config-base ${DST_BASE}"
        exit 1
    fi
else
    if [ "$COPY_SKILLS" != true ]; then
        info "Skipping capability mirror regeneration (skills not installed)."
    fi
fi

# ── Summary ────────────────────────────────────────────────────────────────

printf "\n"
ok "Yggdrasil setup complete!"
printf "    Agents → %s\n" "$DST_AGENTS"
if [ "$COPY_SKILLS" = true ]; then
    printf "    Skills → %s\n" "$DST_SKILLS"
else
    printf "    Skills → (skipped)\n"
fi
printf "    Config home → %s\n" "$DST_CONFIG_HOME"
printf "    Generator → ${DST_GENERATOR}\n"
