#!/usr/bin/env bash
#
# setup.sh — Install Yggdrasil agent, skill, and command definitions into the
# OpenCode config directories (default base: ~/.config/opencode; override via
# OPENCODE_CONFIG_BASE or -c/--config-base).
#
# Idempotent. Merges by add/overwrite only — NEVER deletes anything from the
# destination; stale files from renamed or retired upstream content must be
# removed manually (see README, "Upgrades").

set -o errexit
set -o nounset
set -o pipefail

# ── Output helpers ──────────────────────────────────────────────────────────

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

info()  { printf "${BOLD}📁  %s${NC}\n" "$*"; }
ok()    { printf "${GREEN}✅  %s${NC}\n" "$*"; }
warn()  { printf "${YELLOW}⚠️   %s${NC}\n" "$*"; }
err()   { printf "${RED}❌  %s${NC}\n" "$*" >&2; }

# ── Command-line arguments ──────────────────────────────────────────────────

ASSUME_YES=false   # -y/--yes/--force: skip prompts (CI / curl-pipe installs)
CONFIG_BASE=""     # precedence: CLI flag > OPENCODE_CONFIG_BASE > default

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

while [ "$#" -gt 0 ]; do
    case "$1" in
        -c|--config-base)
            OPT="$1"
            shift
            if [ "$#" -eq 0 ] || [ -z "$1" ] || [ "${1:0:1}" = "-" ]; then
                err "Option ${OPT} requires a non-empty path argument."
                usage >&2
                exit 2
            fi
            CONFIG_BASE="$1"
            ;;
        --config-base=*)
            CONFIG_BASE="${1#--config-base=}"
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

# No positional operands, including after `--`.
if [ "$#" -gt 0 ]; then
    err "Unexpected argument: $1"
    usage >&2
    exit 2
fi

# ── Resolve script location (symlink-safe, macOS/Linux portable) ────────────

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="${SCRIPT_DIR}/${SCRIPT_SOURCE}"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

# ── Compute config base path ────────────────────────────────────────────────

# An EMPTY (not just unset) HOME would make DST_BASE resolve to "/.config/…".
if [ -z "${HOME:-}" ]; then
    err "Refusing to install: HOME is empty."
    err "Set HOME to your home directory and re-run."
    exit 1
fi

if [ -z "$CONFIG_BASE" ]; then
    CONFIG_BASE="${OPENCODE_CONFIG_BASE:-}"
fi
if [ -z "$CONFIG_BASE" ]; then
    CONFIG_BASE="${HOME}/.config/opencode"
fi

# Normalize: trim whitespace, expand leading ~, strip trailing slashes.
CONFIG_BASE="$(printf '%s\n' "$CONFIG_BASE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
case "$CONFIG_BASE" in
    ~)  CONFIG_BASE="$HOME" ;;
    ~*) CONFIG_BASE="${HOME}${CONFIG_BASE#\~}" ;;
esac
while [ "${CONFIG_BASE%/}" != "$CONFIG_BASE" ]; do
    CONFIG_BASE="${CONFIG_BASE%/}"
done
if [ -z "$CONFIG_BASE" ]; then
    err "Refusing to install: config base path is empty after normalization."
    err "Check your OPENCODE_CONFIG_BASE setting or --config-base flag."
    exit 2
fi

# ── Configuration ───────────────────────────────────────────────────────────

SRC_AGENTS="${SCRIPT_DIR}/agents"
SRC_SKILLS="${SCRIPT_DIR}/skills"
SRC_COMMANDS="${SCRIPT_DIR}/commands/yggdrasil"
SRC_GENERATOR="${SCRIPT_DIR}/config-home/generate-capabilities.sh"

DST_BASE="$CONFIG_BASE"
DST_AGENTS="${DST_BASE}/agents/yggdrasil"
DST_SKILLS="${DST_BASE}/skills/yggdrasil"
DST_COMMANDS="${DST_BASE}/commands/yggdrasil"
DST_CONFIG_HOME="${DST_BASE}/yggdrasil"
DST_CUSTOM_CAPS="${DST_CONFIG_HOME}/custom-capabilities.yaml"
DST_GENERATOR="${DST_CONFIG_HOME}/generate-capabilities.sh"

# Mandatory skill folders: everything inside installs unconditionally — the
# always-installed commands and Odin's workflow/memory mechanisms depend on
# these skills with no fallback (see README). Every other skills/ subdirectory
# holds optional skills, gated by the prompt below.
MANDATORY_SKILL_DIRS="research memories deliberation"

# ── Pre-flight checks ───────────────────────────────────────────────────────

for dir in "$SRC_AGENTS" "$SRC_SKILLS" "$SRC_COMMANDS"; do
    if [ ! -d "$dir" ]; then
        err "Source directory not found: ${dir}"
        err "Run this script from the Yggdrasil repository root."
        exit 1
    fi
done
for feature in $MANDATORY_SKILL_DIRS; do
    if [ ! -d "${SRC_SKILLS}/${feature}" ]; then
        err "Mandatory skill folder not found: ${SRC_SKILLS}/${feature}"
        err "The checkout looks incomplete or corrupted."
        exit 1
    fi
done
for f in "$SRC_GENERATOR" "${SCRIPT_DIR}/config-home/custom-capabilities.yaml"; do
    if [ ! -f "$f" ]; then
        err "Source file not found: ${f}"
        err "Run this script from the Yggdrasil repository root."
        exit 1
    fi
done

# ── Prompt to copy optional skills ──────────────────────────────────────────

# Resolved BEFORE the merge warning and any writes, so a declined or failed
# prompt never leaves a partial install and the warning reflects the answer.
COPY_SKILLS=true
if [ "$ASSUME_YES" != true ]; then
    if ! [ -t 0 ]; then
        err "Cannot prompt for skills: stdin is not a terminal (non-interactive run)."
        err "Re-run with --yes (or -y/--force) to install non-interactively."
        exit 1
    fi
    printf "${YELLOW}⚠️   Copy optional skills?${NC} [Y/n] "
    read -r REPLY
    case "$REPLY" in
        n|N) COPY_SKILLS=false ;;
        *) ;;
    esac
fi

if [ "$COPY_SKILLS" != true ]; then
    info "Skipping optional skills installation."
fi

# ── Check for existing files and prompt ─────────────────────────────────────

# DST_SKILLS is checked unconditionally: mandatory skills install there even
# when the optional-skills prompt is declined.
needs_prompt=false
for dir in "$DST_AGENTS" "$DST_COMMANDS" "$DST_SKILLS"; do
    if [ -d "$dir" ] && [ -n "$(ls -A "$dir" 2>/dev/null)" ]; then
        needs_prompt=true
    fi
done

if [ "$needs_prompt" = true ] && [ "$ASSUME_YES" != true ]; then
    warn "Target directories already contain files."
    printf "    Yggdrasil definitions will be merged in: same-named files are\n"
    printf "    updated (overwritten), new files are added, and files unrelated to\n"
    printf "    this project are preserved. Note: files removed or renamed upstream\n"
    printf "    are NOT deleted and may remain as orphans in:\n"
    printf "      %s\n" "$DST_AGENTS"
    printf "      %s\n" "$DST_COMMANDS"
    printf "      %s\n" "$DST_SKILLS"
    printf "${YELLOW}⚠️   Continue?${NC} [y/N] "

    # A bare `read` on closed stdin would abort abruptly under `set -e`.
    if ! [ -t 0 ]; then
        printf "\n"
        err "Cannot prompt: stdin is not a terminal (non-interactive run)."
        err "Re-run with --yes (or -y/--force) to install non-interactively."
        exit 1
    fi

    read -r REPLY
    case "$REPLY" in
        y|Y) ;;
        *)
            echo "Skipping installation."
            exit 0
            ;;
    esac
fi

# ── Safety guard: only write inside the yggdrasil namespace ─────────────────

# Logical paths are compared (symlinks not resolved), so stow/yadm-managed
# config dirs are accepted.
if [ -z "$DST_BASE" ] || [ -z "$DST_AGENTS" ] || [ -z "$DST_SKILLS" ] || [ -z "$DST_COMMANDS" ] || [ -z "$DST_CONFIG_HOME" ]; then
    err "Refusing to install: computed destination paths are empty."
    err "Check that HOME is set correctly (HOME=\"${HOME:-}\")."
    exit 1
fi

case "$DST_AGENTS" in
    "${DST_BASE}"/*/yggdrasil) ;;
    *) err "Refusing to install outside the yggdrasil namespace: ${DST_AGENTS}"; exit 1 ;;
esac
case "$DST_SKILLS" in
    "${DST_BASE}"/*/yggdrasil) ;;
    *) err "Refusing to install outside the yggdrasil namespace: ${DST_SKILLS}"; exit 1 ;;
esac
case "$DST_COMMANDS" in
    "${DST_BASE}"/commands/yggdrasil) ;;
    *) err "Refusing to install commands outside the expected location: ${DST_COMMANDS}"; exit 1 ;;
esac
case "$DST_CONFIG_HOME" in
    "${DST_BASE}"/yggdrasil) ;;
    *) err "Refusing to install outside the yggdrasil namespace: ${DST_CONFIG_HOME}"; exit 1 ;;
esac

# ── Backups for locally-modified agent/command files ────────────────────────

# Destination files that differ from the incoming version are backed up with a
# timestamp suffix, so local edits (e.g. permission grants) can be recovered.
backup_differing_agents() {
    local differing_count=0
    local differing_files=""

    for src_file in "${SRC_AGENTS}"/*.md; do
        [ -f "$src_file" ] || continue
        filename=$(basename "$src_file")
        dst_file="${DST_AGENTS}/${filename}"
        if [ -f "$dst_file" ] && ! diff -q "$src_file" "$dst_file" >/dev/null 2>&1; then
            backup_file="${dst_file}.bak.$(date +%s)"
            cp "$dst_file" "$backup_file"
            differing_count=$((differing_count + 1))
            differing_files="${differing_files}
    - $filename (backed up to $backup_file)"
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

backup_differing_commands() {
    local differing_count=0
    local differing_files=""

    while IFS= read -r -d '' src_file; do
        [ -f "$src_file" ] || continue
        rel_path="${src_file#${SRC_COMMANDS}/}"
        dst_file="${DST_COMMANDS}/${rel_path}"
        if [ -f "$dst_file" ] && ! diff -q "$src_file" "$dst_file" >/dev/null 2>&1; then
            backup_file="${dst_file}.bak.$(date +%s)"
            cp "$dst_file" "$backup_file"
            differing_count=$((differing_count + 1))
            differing_files="${differing_files}
    - $rel_path (backed up to $backup_file)"
        fi
    done < <(find "${SRC_COMMANDS}" -name "*.md" -print0 | sort -z)

    if [ "$differing_count" -gt 0 ]; then
        warn "Command definition files were modified locally and have been backed up."
        printf "    Modified files:%s\n" "$differing_files"
        printf "    \n"
        printf "    If you made custom edits to command templates, review the backups\n"
        printf "    and re-apply your changes to the new versions.\n"
    fi
}

# ── Install agents ──────────────────────────────────────────────────────────

info "Creating agents directory…"
mkdir -p "$DST_AGENTS"

if [ -n "$(ls -A "$DST_AGENTS" 2>/dev/null)" ]; then
    backup_differing_agents
fi

info "Copying agents to ${DST_AGENTS}…"
cp -R "${SRC_AGENTS}/." "$DST_AGENTS/"
ok "Agents installed."

# ── Install mandatory skills (unconditional) ────────────────────────────────

info "Copying mandatory skills to ${DST_SKILLS}…"
for feature in $MANDATORY_SKILL_DIRS; do
    mkdir -p "${DST_SKILLS}/${feature}"
    cp -R "${SRC_SKILLS}/${feature}/." "${DST_SKILLS}/${feature}/"
done
ok "Mandatory skills installed."

if [ "$COPY_SKILLS" != true ]; then
    warn "Note: the mandatory skills (research/, memories/, deliberation/) install"
    warn "regardless of your answer — Odin's workflows and the commands depend on them."
fi

# ── Install optional skills ─────────────────────────────────────────────────

if [ "$COPY_SKILLS" = true ]; then
    info "Copying optional skills to ${DST_SKILLS}…"
    for src_dir in "${SRC_SKILLS}"/*/; do
        [ -d "$src_dir" ] || continue
        name=$(basename "$src_dir")
        case " $MANDATORY_SKILL_DIRS " in
            *" $name "*) continue ;;   # already installed above
        esac
        mkdir -p "${DST_SKILLS}/${name}"
        cp -R "${src_dir}." "${DST_SKILLS}/${name}/"
    done
    ok "Optional skills installed."
fi

# ── Install commands ────────────────────────────────────────────────────────

info "Creating commands directory…"
mkdir -p "$DST_COMMANDS"

if [ -n "$(ls -A "$DST_COMMANDS" 2>/dev/null)" ]; then
    backup_differing_commands
fi

info "Copying commands to ${DST_COMMANDS}…"
cp -R "${SRC_COMMANDS}/." "$DST_COMMANDS/"
ok "Commands installed."

# ── Install generator and custom-capabilities scaffold ──────────────────────

info "Creating config home directory…"
mkdir -p "$DST_CONFIG_HOME"

info "Installing capability generator…"
cp "$SRC_GENERATOR" "$DST_GENERATOR"
chmod +x "$DST_GENERATOR"
ok "Generator installed to ${DST_GENERATOR}."

# First install only — never overwrite the user's custom tool grants.
if [ ! -f "$DST_CUSTOM_CAPS" ]; then
    info "Creating custom-capabilities scaffold…"
    cp "${SCRIPT_DIR}/config-home/custom-capabilities.yaml" "$DST_CUSTOM_CAPS"
    ok "Custom capabilities scaffold created at ${DST_CUSTOM_CAPS}."
else
    ok "Custom capabilities file already exists (preserved: ${DST_CUSTOM_CAPS})."
fi

# ── Regenerate the capability mirror ────────────────────────────────────────

# Runs on every install so the inventory reflects this upgrade and any custom
# capabilities. Failure is fatal — a missing inventory silently breaks planning.
info "Regenerating capability mirror…"
if "$DST_GENERATOR" --config-base "$DST_BASE" >/dev/null 2>&1; then
    ok "Capability mirror regenerated."
else
    err "Failed to regenerate capability mirror (skills were installed but inventory could not be created)."
    err "Run manually to diagnose: ${DST_GENERATOR} --config-base ${DST_BASE}"
    exit 1
fi

# ── Summary ─────────────────────────────────────────────────────────────────

printf "\n"
ok "Yggdrasil setup complete!"
printf "    Agents → %s\n" "$DST_AGENTS"
printf "    Commands → %s\n" "$DST_COMMANDS"
if [ "$COPY_SKILLS" = true ]; then
    printf "    Skills → %s\n" "$DST_SKILLS"
else
    printf "    Skills → %s (mandatory only; optional skipped)\n" "$DST_SKILLS"
fi
printf "    Config home → %s\n" "$DST_CONFIG_HOME"
printf "    Generator → ${DST_GENERATOR}\n"
