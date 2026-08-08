#!/usr/bin/env bash
#
# generate-subagents.sh — Generate the five subagent files from templates
#
# This script assembles the five subagent files (bragi, brokk, heimdall, kvasir,
# mimir) from per-agent templates and shared fragments. Output is deterministic
# (LC_ALL=C) and byte-identical to the committed files.
#
# Usage:
#   generate-subagents.sh              # regenerate all five files in agents/
#   generate-subagents.sh --print       # print all five to stdout (for testing)
#   generate-subagents.sh --agent mimir --print  # print one agent to stdout
#
# The generator resolves the template directory relative to this script's location.
# Output files are written to agents/ (relative to the repo root) unless --print is used.

set -euo pipefail

# Deterministic output (sorted iteration, consistent locale)
export LC_ALL=C

# Parse CLI flags
PRINT_ONLY=0
AGENT=""  # empty = all agents; specific name = one agent

while [ "${1:-}" != "" ]; do
  case "$1" in
    --print)
      PRINT_ONLY=1
      shift
      ;;
    --agent)
      shift
      if [ -z "${1:-}" ]; then
        echo "Error: --agent requires an argument (bragi, brokk, heimdall, kvasir, or mimir)" >&2
        exit 1
      fi
      AGENT="$1"
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
TEMPLATE_DIR="$SCRIPT_DIR/subagent-generator"

# Output directory (agents/ in repo root)
OUTPUT_DIR="$REPO_ROOT/agents"

# All subagent names
SUBAGENTS="bragi brokk heimdall kvasir mimir"

# Verify template files exist
if [ ! -f "$TEMPLATE_DIR/knowledge-base.fragment" ]; then
  echo "Error: shared fragment not found: $TEMPLATE_DIR/knowledge-base.fragment" >&2
  exit 1
fi
if [ ! -f "$TEMPLATE_DIR/workspace-convention.fragment" ]; then
  echo "Error: shared fragment not found: $TEMPLATE_DIR/workspace-convention.fragment" >&2
  exit 1
fi

# Helper: generate one subagent file
generate_subagent_file() {
  local agent="$1"

  local template="$TEMPLATE_DIR/$agent.template"
  if [ ! -f "$template" ]; then
    echo "Error: agent template not found: $template" >&2
    return 1
  fi

  local output_file="$OUTPUT_DIR/$agent.md"

  # Brokk does not get the workspace convention fragment (it has its own
  # workspace note inline in its template). All other agents get both
  # shared fragments appended: workspace-convention.fragment first, then knowledge-base.fragment.

  if [ "$PRINT_ONLY" -eq 1 ]; then
    cat "$template"
    printf '\n'
    if [ "$agent" != "brokk" ]; then
      cat "$TEMPLATE_DIR/workspace-convention.fragment"
      printf '\n'
    fi
    cat "$TEMPLATE_DIR/knowledge-base.fragment"
  else
    {
      cat "$template"
      printf '\n'
      if [ "$agent" != "brokk" ]; then
        cat "$TEMPLATE_DIR/workspace-convention.fragment"
        printf '\n'
      fi
      cat "$TEMPLATE_DIR/knowledge-base.fragment"
    } > "$output_file"
  fi
}

# Generate requested agent(s)
if [ -z "$AGENT" ]; then
  # Generate all five agents
  for agent in $SUBAGENTS; do
    if ! generate_subagent_file "$agent"; then
      exit 1
    fi
  done
else
  # Validate agent name
  found=0
  for a in $SUBAGENTS; do
    if [ "$a" = "$AGENT" ]; then
      found=1
      break
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "Error: unknown agent '$AGENT' (valid: $SUBAGENTS)" >&2
    exit 1
  fi
  if ! generate_subagent_file "$AGENT"; then
    exit 1
  fi
fi

exit 0
