#!/usr/bin/env bash
#
# generate-odin-agents.sh — Generate the three Odin agent files from a single source
#
# This script assembles the three Odin agent files (autonomous, guided, interactive)
# from a shared template body and mode-specific fragments. Output is deterministic
# (LC_ALL=C) and byte-identical to the committed files.
#
# Usage:
#   generate-odin-agents.sh              # regenerate all three files in agents/
#   generate-odin-agents.sh --print      # print all three to stdout (for testing)
#   generate-odin-agents.sh --mode autonomous --print  # print one mode to stdout
#
# The generator resolves the template directory relative to this script's location.
# Output files are written to agents/ (relative to the repo root) unless --print is used.

set -euo pipefail

# Deterministic output (sorted iteration, consistent locale)
export LC_ALL=C

# Parse CLI flags
PRINT_ONLY=0
MODE=""  # empty = all modes; "autonomous", "guided", or "interactive" = one mode

while [ "${1:-}" != "" ]; do
  case "$1" in
    --print)
      PRINT_ONLY=1
      shift
      ;;
    --mode)
      shift
      if [ -z "${1:-}" ]; then
        echo "Error: --mode requires an argument (autonomous, guided, or interactive)" >&2
        exit 1
      fi
      MODE="$1"
      shift
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      exit 2
      ;;
  esac
done

# Resolve script directory and repo root
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  case "$SCRIPT_SOURCE" in
    /*) ;;
    *) SCRIPT_SOURCE="${SCRIPT_DIR}/${SCRIPT_SOURCE}" ;;
  esac
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd -P "$SCRIPT_DIR/.." && pwd)"

# Template directory
TEMPLATE_DIR="$SCRIPT_DIR/odin-generator"

# Output directory (agents/ in repo root)
OUTPUT_DIR="$REPO_ROOT/agents"

# Verify template files exist
if [ ! -f "$TEMPLATE_DIR/preamble.template.md" ]; then
  echo "Error: preamble template not found: $TEMPLATE_DIR/preamble.template.md" >&2
  exit 1
fi
if [ ! -f "$TEMPLATE_DIR/shared-body.template.md" ]; then
  echo "Error: shared body template not found: $TEMPLATE_DIR/shared-body.template.md" >&2
  exit 1
fi

# Helper: get mode title
get_mode_title() {
  local mode="$1"
  case "$mode" in
    autonomous) echo "Autonomous" ;;
    guided) echo "Guided" ;;
    interactive) echo "Interactive" ;;
    *) echo ""; return 1 ;;
  esac
}

# Helper: get mode description
get_mode_desc() {
  local mode="$1"
  case "$mode" in
    autonomous) echo "Orchestrates specialist agents autonomously, executing tasks without user interaction." ;;
    guided) echo "Orchestrates specialist agents, gathering requirements then executing autonomously." ;;
    interactive) echo "Orchestrates specialist agents with user collaboration throughout." ;;
    *) echo ""; return 1 ;;
  esac
}

# Helper: generate one Odin agent file
generate_odin_file() {
  local mode="$1"
  local mode_title description
  
  mode_title=$(get_mode_title "$mode") || return 1
  description=$(get_mode_desc "$mode") || return 1
  
  # Verify fragment exists
  local fragment="$TEMPLATE_DIR/communication-policy-${mode}.fragment.md"
  if [ ! -f "$fragment" ]; then
    echo "Error: communication policy fragment not found: $fragment" >&2
    return 1
  fi
  
  # Read template parts and assemble directly to preserve newlines
  # We'll use cat to output directly, with substitution done via sed
  local output_file="$OUTPUT_DIR/odin-${mode}.md"
  
  if [ "$PRINT_ONLY" -eq 1 ]; then
    # Print to stdout
    cat "$TEMPLATE_DIR/preamble.template.md" | sed "s/{{MODE_TITLE}}/$mode_title/g; s/{{DESCRIPTION}}/$description/g"
    printf '\n'
    cat "$TEMPLATE_DIR/shared-body.template.md"
    printf '\n'
    cat "$fragment"
  else
    # Write to file
    {
      cat "$TEMPLATE_DIR/preamble.template.md" | sed "s/{{MODE_TITLE}}/$mode_title/g; s/{{DESCRIPTION}}/$description/g"
      printf '\n'
      cat "$TEMPLATE_DIR/shared-body.template.md"
      printf '\n'
      cat "$fragment"
    } > "$output_file"
  fi
}

# Generate requested mode(s)
if [ -z "$MODE" ]; then
  # Generate all three modes
  for mode in autonomous guided interactive; do
    if ! generate_odin_file "$mode"; then
      exit 1
    fi
  done
else
  # Generate one mode
  if ! generate_odin_file "$MODE"; then
    exit 1
  fi
fi

exit 0
