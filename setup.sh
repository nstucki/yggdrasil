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
SRC_COMMANDS="${SCRIPT_DIR}/commands/yggdrasil"
SRC_GENERATOR="${SCRIPT_DIR}/scripts/generate-capabilities.sh"

DST_BASE="$CONFIG_BASE"
DST_AGENTS="${DST_BASE}/agents/yggdrasil"
DST_SKILLS="${DST_BASE}/skills/yggdrasil"
DST_COMMANDS="${DST_BASE}/commands/yggdrasil"
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

if [ ! -d "$SRC_COMMANDS" ]; then
    err "Source directory not found: ${SRC_COMMANDS}"
    err "Make sure you are running this script from the Yggdrasil repository root and that commands/yggdrasil/ exists."
    exit 1
fi

# ── Prompt to copy optional skills ──────────────────────────────────────────

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
# mode, the user may decline to install the optional skills.
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

# Agents and commands are always copied, so non-empty dirs always trigger the
# warning. The always-on skills (brokk-memory-curation, odin-memory-system, odin-deliberation-council, odin-research-workflow, and the five bragi-council-deliberation-* skills)
# are also always copied to feature subdirectories under DST_SKILLS (see the
# "Install always-on skills" section below), so DST_SKILLS is now checked
# unconditionally too — even if the user declines the skills prompt, those
# skills still land there and pre-existing content deserves the same warning.
needs_prompt=false
if [ -d "$DST_AGENTS" ] && [ -n "$(ls -A "$DST_AGENTS" 2>/dev/null)" ]; then
    needs_prompt=true
fi
if [ -d "$DST_COMMANDS" ] && [ -n "$(ls -A "$DST_COMMANDS" 2>/dev/null)" ]; then
    needs_prompt=true
fi
if [ -d "$DST_SKILLS" ] && [ -n "$(ls -A "$DST_SKILLS" 2>/dev/null)" ]; then
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
    printf "      %s\n" "$DST_COMMANDS"
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

# ── Safety guard: ensure we only write into the yggdrasil namespace ──────────
# Assert the destination paths are non-empty and end in the expected
# `/yggdrasil` namespace under the config base. Logical paths are compared
# (symlinks are NOT resolved), so stow/yadm-managed config dirs are accepted.
# Also permit the new config-home directory (DST_CONFIG_HOME) which is directly
# under DST_BASE and contains custom capabilities and installed tools.
# Commands are installed to the global commands directory (not namespaced).
if [ -z "$DST_BASE" ] || [ -z "$DST_AGENTS" ] || [ -z "$DST_SKILLS" ] || [ -z "$DST_COMMANDS" ] || [ -z "$DST_CONFIG_HOME" ]; then
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

case "$DST_COMMANDS" in
    "${DST_BASE}"/commands/yggdrasil) ;;
    *)
        err "Refusing to install commands outside the expected location: ${DST_COMMANDS}"
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

# ── Feature-subdir routing for always-on skills (single source of truth) ────

# Return the feature subdirectory for an always-on skill, or fail (return 1)
# if the skill is not one of the 9 always-on nested skills.
#
# This is the SINGLE source of truth consumed by:
#   - the always-on install blocks (target path construction),
#   - the orphan cleanup loop (which flat dirs to remove),
#   - the bulk copy skip check (which skills to exclude from flat copy).
#
# Agent is the first path component under skills/ (e.g. "bragi", "brokk",
# "odin"). Skill name is the directory basename (e.g. "bragi-council-prompt-empath").
#
# Bash 3.2-safe: only `case` + `printf` + `return`. No associative arrays.
# Patterns are exact `agent/skill_name` literals (not prefix globs), so a
# future `bragi-council-observer` would NOT accidentally route to
# `council-deliberation/`.
nested_subdir_for() {
    case "$1/$2" in
        bragi/bragi-council-deliberation-foundations|bragi/bragi-council-deliberation-systems|\
        bragi/bragi-council-deliberation-adversary|bragi/bragi-council-deliberation-pragmatist|\
        bragi/bragi-council-deliberation-humanist)
            printf 'council-deliberation\n' ;;
        brokk/brokk-memory-curation)
            printf 'memory\n' ;;
        odin/odin-memory-system)
            printf 'memory\n' ;;
        odin/odin-deliberation-council|odin/odin-research-workflow)
            printf 'workflows\n' ;;
        *)
            return 1 ;;
    esac
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

# ── Install always-on skills (unconditional) ──────────────────────────────

# A small, explicitly-justified set of skills installs unconditionally —
# regardless of the answer to the "Copy optional skills?" prompt above —
# folded into the same unconditional footing as agents and commands. There
# are three categories of always-installed skills, each justified by a hard
# runtime dependency on something that always installs itself:
#
#   1. The memory-commands dependency category — two skills backing the
#      three memory commands (/yggdrasil/remember, /yggdrasil/dream,
#      /yggdrasil/forget), which always install (see "Install commands"
#      below):
#        a. brokk-memory-curation — governs the write-side implementation
#           (canonical entry frontmatter schema, INDEX.md format, README
#           template) used by the implementer dispatched on each command.
#           Installs to brokk/memory/brokk-memory-curation/.
#        b. odin-memory-system — the orchestration doctrine (which agents
#           to dispatch, review gates, guardrails) for the same three
#           command-triggered memory operations. The commands are inert
#           without it. Installs to odin/memory/odin-memory-system/.
#
#   2. The five bragi-council-deliberation-* perspective skills — Odin's
#      Deliberation Council workflow (odin-deliberation-council skill) dispatches perspective-framed communication-specialist instances
#      expecting these skills to be present. Without them, a triggered
#      deliberation dispatch would fail to find the perspective skills.
#      The deliberation mechanism has no fail-safe fallback, so the
#      skills must be present on every install. Installs to
#      bragi/council-deliberation/bragi-council-deliberation-*/.
#
#   3. The two workflow-doctrine skills — odin-deliberation-council and
#      odin-research-workflow — backing the two trigger-gated workflows in
#      Odin's shared body and their commands (/yggdrasil/deliberate,
#      /yggdrasil/research), which always install. The lean Workflows
#      section instructs Odin to load these skills on invoke; the
#      workflows (and both commands) are inert without them. Install to
#      odin/workflows/<skill-name>/.
#
# These 9 always-on skills install to feature subdirectories
# (bragi/council-deliberation/, brokk/memory/, odin/memory/, odin/workflows/) — a target-only nesting; the source repo stays flat.
# The routing is governed by nested_subdir_for() above (single source of
# truth), which the bulk copy below also consults to SKIP these 9 skills
# (they are written exclusively by the always-on blocks here, never by the
# bulk copy — restoring the single-write-path invariant).
#
# This is a narrow set of hard-dependency exceptions, NOT a general
# core/optional skill tier — every other skill remains gated behind
# COPY_SKILLS exactly as before.

# ── Orphan cleanup: remove legacy flat-layout always-on skills ──
# All 9 always-on skills now install to feature subdirectories (see above).
# On upgrade from a prior flat layout, the old flat copies at
# <agent>/<skill_name>/ would remain (the merge copy never deletes),
# causing silent duplication: generate-capabilities.sh's recursive find
# discovers both copies and the capability inventory lists each skill
# twice, and OpenCode registers duplicate skills. Remove the old flat
# directories for exactly the skills known to nested_subdir_for, scoped
# to the flat <agent>/<skill_name> location only — never the new nested
# location, never user content (case patterns are exact literals).
# Runs BEFORE the new install so the sequence is remove-old-flat →
# install-new-nested (idempotent). On a fresh install, the flat dirs
# don't exist, so this is a no-op.
if [ -d "$DST_SKILLS" ]; then
    info "Checking for legacy flat-layout always-on skills to migrate…"
    for agent_dir in "${DST_SKILLS}"/*/; do
        [ -d "$agent_dir" ] || continue
        agent_name=$(basename "$agent_dir")
        for skill_dir in "${agent_dir}"*/; do
            [ -d "$skill_dir" ] || continue
            skill_name=$(basename "$skill_dir")
            # If this skill is a nested always-on skill, its flat copy is an orphan.
            if nested_subdir_for "$agent_name" "$skill_name" >/dev/null; then
                info "Removing legacy flat copy of ${agent_name}/${skill_name} (migrated to feature subdir)…"
                rm -rf "$skill_dir"
            fi
     done
 done
fi

# ── Orphan cleanup: remove retired Prompt Council skills ──
# The Prompt Council mechanism was removed from Odin's shared body, and its
# five bragi-council-prompt-* persona skills no longer exist in the source
# repo. On upgrade, previously installed copies under bragi/council-prompt/
# would linger (the merge copy never deletes) and generate-capabilities.sh's
# recursive find would re-list the retired skills in the capability
# inventory. Remove the entire retired feature subdirectory — it was written
# exclusively by the (now removed) always-on install block, never by users.
# On a fresh install the directory doesn't exist, so this is a no-op.
if [ -d "${DST_SKILLS}/bragi/council-prompt" ]; then
    info "Removing retired Prompt Council skills (bragi/council-prompt/)…"
    rm -rf "${DST_SKILLS}/bragi/council-prompt"
fi

SRC_MEMORY_SKILL="${SRC_SKILLS}/brokk/brokk-memory-curation"
DST_MEMORY_SKILL="${DST_SKILLS}/brokk/memory/brokk-memory-curation"

if [ -d "$SRC_MEMORY_SKILL" ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_MEMORY_SKILL"

    info "Copying brokk-memory-curation to ${DST_MEMORY_SKILL}…"
    # Merge copy: copies just this one skill directory unconditionally to its
    # feature subdirectory (brokk/memory/). The bulk copy below SKIPS this
    # skill via nested_subdir_for, so there is no redundant overwrite —
    # single write path (the nested location).
    cp -R "${SRC_MEMORY_SKILL}/." "$DST_MEMORY_SKILL/"
    ok "brokk-memory-curation installed."
fi

SRC_ODIN_MEMORY_SKILL="${SRC_SKILLS}/odin/odin-memory-system"
DST_ODIN_MEMORY_SKILL="${DST_SKILLS}/odin/memory/odin-memory-system"

if [ -d "$SRC_ODIN_MEMORY_SKILL" ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_ODIN_MEMORY_SKILL"

    info "Copying odin-memory-system to ${DST_ODIN_MEMORY_SKILL}…"
    # Merge copy: copies just this one skill directory unconditionally to its
    # feature subdirectory (odin/memory/). The bulk copy below SKIPS this
    # skill via nested_subdir_for, so there is no redundant overwrite —
    # single write path (the nested location).
    cp -R "${SRC_ODIN_MEMORY_SKILL}/." "$DST_ODIN_MEMORY_SKILL/"
    ok "odin-memory-system installed."
fi

# Workflow-doctrine skills → odin/workflows/
# Always installed so the two trigger-gated workflows in Odin's shared body
# (and the /yggdrasil/deliberate and /yggdrasil/research commands) work on
# every install. See category 3 in the rationale block above.
SRC_ODIN_DELIBERATION_SKILL="${SRC_SKILLS}/odin/odin-deliberation-council"
DST_ODIN_DELIBERATION_SKILL="${DST_SKILLS}/odin/workflows/odin-deliberation-council"

if [ -d "$SRC_ODIN_DELIBERATION_SKILL" ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_ODIN_DELIBERATION_SKILL"

    info "Copying odin-deliberation-council to ${DST_ODIN_DELIBERATION_SKILL}…"
    # Merge copy: copies just this one skill directory unconditionally to its
    # feature subdirectory (odin/workflows/). The bulk copy below SKIPS this
    # skill via nested_subdir_for, so there is no redundant overwrite —
    # single write path (the nested location).
    cp -R "${SRC_ODIN_DELIBERATION_SKILL}/." "$DST_ODIN_DELIBERATION_SKILL/"
    ok "odin-deliberation-council installed."
fi

SRC_ODIN_RESEARCH_WF_SKILL="${SRC_SKILLS}/odin/odin-research-workflow"
DST_ODIN_RESEARCH_WF_SKILL="${DST_SKILLS}/odin/workflows/odin-research-workflow"

if [ -d "$SRC_ODIN_RESEARCH_WF_SKILL" ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_ODIN_RESEARCH_WF_SKILL"

    info "Copying odin-research-workflow to ${DST_ODIN_RESEARCH_WF_SKILL}…"
    # Merge copy: copies just this one skill directory unconditionally to its
    # feature subdirectory (odin/workflows/). The bulk copy below SKIPS this
    # skill via nested_subdir_for, so there is no redundant overwrite —
    # single write path (the nested location).
    cp -R "${SRC_ODIN_RESEARCH_WF_SKILL}/." "$DST_ODIN_RESEARCH_WF_SKILL/"
    ok "odin-research-workflow installed."
fi

# Deliberation Council skills → bragi/council-deliberation/
# Always installed so Odin's embedded Deliberation Council mechanism works on
# every install. See the rationale in the block comment above.
COUNCIL_DELIBERATION_SKILLS="
bragi-council-deliberation-foundations
bragi-council-deliberation-systems
bragi-council-deliberation-adversary
bragi-council-deliberation-pragmatist
bragi-council-deliberation-humanist
"
for skill_name in $COUNCIL_DELIBERATION_SKILLS; do
    SRC_COUNCIL_SKILL="${SRC_SKILLS}/bragi/${skill_name}"
    DST_COUNCIL_SKILL="${DST_SKILLS}/bragi/council-deliberation/${skill_name}"
    if [ -d "$SRC_COUNCIL_SKILL" ]; then
        info "Creating skills directory…"
        mkdir -p "$DST_COUNCIL_SKILL"
        info "Copying ${skill_name} to ${DST_COUNCIL_SKILL}…"
        # Merge copy to the council-deliberation feature subdirectory. The bulk
        # copy below SKIPS this skill via nested_subdir_for — single write path.
        cp -R "${SRC_COUNCIL_SKILL}/." "$DST_COUNCIL_SKILL/"
        ok "${skill_name} installed."
    fi
done

# Only surface this note when it contradicts the user's own answer above
# (i.e., they declined the skills prompt but got the always-on skills
# anyway). If they accepted, all skills install per their own answer and
# the note is redundant noise.
if [ "$COPY_SKILLS" != true ]; then
    warn "Note: brokk-memory-curation, odin-memory-system, odin-deliberation-council,"
    warn "odin-research-workflow, and the five bragi-council-deliberation-* skills install"
    warn "unconditionally — the memory commands and Odin's Deliberation Council and"
    warn "Research workflows depend on them regardless of your answer above."
fi

# ── Install skills ─────────────────────────────────────────────────────────

if [ "$COPY_SKILLS" = true ]; then
    info "Creating skills directory…"
    mkdir -p "$DST_SKILLS"

    info "Copying skills to ${DST_SKILLS}…"
    # Per-skill merge copy (replaces the former bulk `cp -R`).
    #
    # The 9 always-on skills are SKIPPED here: they are installed
    # unconditionally to feature subdirectories (bragi/council-deliberation/,
    # brokk/memory/, odin/memory/, odin/workflows/) by the
    # always-on blocks above. Copying them here too would land them flat
    # at <agent>/<skill_name>/ — a second, duplicate copy that fractures
    # the single-write-path invariant and corrupts the capability
    # inventory (recursive find discovers both). The skip restores
    # single-path convergence: each always-on skill is written to exactly
    # one location.
    #
    # All other skills copy flat, preserving the source repo's flat layout
    # in the target (unchanged behavior for the 36 optional skills).
    for agent_dir in "${SRC_SKILLS}"/*/; do
        [ -d "$agent_dir" ] || continue
        agent_name=$(basename "$agent_dir")
        for skill_dir in "${agent_dir}"*/; do
            [ -d "$skill_dir" ] || continue
            skill_name=$(basename "$skill_dir")

            # Skip always-on nested skills — already installed to their
            # feature subdirectory by the always-on blocks above.
            if nested_subdir_for "$agent_name" "$skill_name" >/dev/null; then
                continue
            fi

            DST_SKILL="${DST_SKILLS}/${agent_name}/${skill_name}"
            mkdir -p "$DST_SKILL"
            cp -R "${skill_dir}." "$DST_SKILL/"
        done
    done
    ok "Skills installed."
fi

# ── Install commands ───────────────────────────────────────────────────────

# Back up any locally-modified command files before overwriting (similar to agents).
backup_differing_commands() {
    local differing_count=0
    local differing_files=""
    
    # Recursively find all .md files under SRC_COMMANDS, preserving relative paths.
    while IFS= read -r -d '' src_file; do
        [ -f "$src_file" ] || continue
        # Get the relative path from SRC_COMMANDS to this file.
        rel_path="${src_file#${SRC_COMMANDS}/}"
        dst_file="${DST_COMMANDS}/${rel_path}"
        
        # Only check if destination exists (not the first install).
        if [ -f "$dst_file" ]; then
            if ! diff -q "$src_file" "$dst_file" >/dev/null 2>&1; then
                # Files differ. Back up the destination file with timestamp.
                timestamp=$(date +%s)
                backup_file="${dst_file}.bak.${timestamp}"
                cp "$dst_file" "$backup_file"
                differing_count=$((differing_count + 1))
                differing_files="${differing_files}
    - $rel_path (backed up to $backup_file)"
            fi
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

info "Creating commands directory…"
mkdir -p "$DST_COMMANDS"

# Back up any locally-modified command files before overwriting.
if [ -d "$DST_COMMANDS" ] && [ -n "$(ls -A "$DST_COMMANDS" 2>/dev/null)" ]; then
    backup_differing_commands
fi

info "Copying commands to ${DST_COMMANDS}…"
# Merge copy: copies Yggdrasil command definitions into the destination.
# Pre-existing files in the destination that are NOT part of this project are preserved.
cp -R "${SRC_COMMANDS}/." "$DST_COMMANDS/"
ok "Commands installed."

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
# at install time. Run unconditionally on every install: the always-on skills
# (brokk-memory-curation, odin-memory-system, odin-deliberation-council, odin-research-workflow, and the five
# bragi-council-deliberation-* skills) always
# install to feature subdirectories (see "Install always-on skills" above), so
# DST_SKILLS is populated on every normal install, even when the user declines
# the skills prompt.
# If regeneration fails — including the abnormal case of a corrupted checkout
# missing the skills directory entirely — this is FATAL (a silent failure would
# leave no capability inventory at all, invisibly).
info "Regenerating capability mirror…"
if "$DST_GENERATOR" --config-base "$DST_BASE" >/dev/null 2>&1; then
    ok "Capability mirror regenerated."
else
    err "Failed to regenerate capability mirror (skills were installed but inventory could not be created)."
    err "This is a fatal condition — the capability inventory is required for Odin and Kvasir to function."
    err "Run manually to diagnose: ${DST_GENERATOR} --config-base ${DST_BASE}"
    exit 1
fi

# ── Summary ────────────────────────────────────────────────────────────────

printf "\n"
ok "Yggdrasil setup complete!"
printf "    Agents → %s\n" "$DST_AGENTS"
printf "    Commands → %s\n" "$DST_COMMANDS"
if [ "$COPY_SKILLS" = true ]; then
    printf "    Skills → %s\n" "$DST_SKILLS"
else
    printf "    Skills → %s (always-on only; rest skipped)\n" "$DST_SKILLS"
fi
printf "    Config home → %s\n" "$DST_CONFIG_HOME"
printf "    Generator → ${DST_GENERATOR}\n"
