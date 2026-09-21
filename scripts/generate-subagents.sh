#!/usr/bin/env bash
#
# generate-subagents.sh — Generate the five subagent files from templates
#
# This script assembles the five subagent files (bragi, brokk, heimdall, kvasir,
# mimir) from per-agent template heads, shared fragments, and per-agent workflow
# tails. Output is deterministic (LC_ALL=C) and byte-identical to the committed files.
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

# Subagents that author Workfiles, and therefore receive tooling.fragment.md.
# Brokk is deliberately excluded: it writes project Artifacts rather than
# Workfiles, and its Boundaries section disables workspace writes outright, so
# Workfile tooling doctrine would contradict its own prompt.
WORKFILE_AUTHORS="bragi heimdall kvasir mimir"

# Verify template files exist
if [ ! -f "$TEMPLATE_DIR/memory.fragment.md" ]; then
  echo "Error: shared fragment not found: $TEMPLATE_DIR/memory.fragment.md" >&2
  exit 1
fi
if [ ! -f "$TEMPLATE_DIR/workspace.fragment.md" ]; then
  echo "Error: shared fragment not found: $TEMPLATE_DIR/workspace.fragment.md" >&2
  exit 1
fi
if [ ! -f "$TEMPLATE_DIR/tooling.fragment.md" ]; then
  echo "Error: shared fragment not found: $TEMPLATE_DIR/tooling.fragment.md" >&2
  exit 1
fi

# Helper: does this agent author Workfiles?
authors_workfiles() {
  local agent="$1" candidate
  for candidate in $WORKFILE_AUTHORS; do
    if [ "$candidate" = "$agent" ]; then
      return 0
    fi
  done
  return 1
}

# Helper: emit one assembled subagent document to stdout.
#
# Assembly order: template head → workspace fragment → [tooling fragment] →
# memory fragment → workflow tail. Every agent receives the workspace and
# memory fragments; only Workfile-authoring agents receive the tooling
# fragment, which lands immediately after the Yggdrasil Workspace section
# whose subject it extends.
emit_subagent() {
  local agent="$1" template="$2" workflow="$3"

  cat "$template"
  printf '\n'
  cat "$TEMPLATE_DIR/workspace.fragment.md"
  printf '\n'
  if authors_workfiles "$agent"; then
    cat "$TEMPLATE_DIR/tooling.fragment.md"
    printf '\n'
  fi
  cat "$TEMPLATE_DIR/memory.fragment.md"
  printf '\n'
  cat "$workflow"
}

# Helper: generate one subagent file
generate_subagent_file() {
  local agent="$1"

  local template="$TEMPLATE_DIR/$agent.template.md"
  if [ ! -f "$template" ]; then
    echo "Error: agent template not found: $template" >&2
    return 1
  fi

  local workflow="$TEMPLATE_DIR/$agent.workflow.template.md"
  if [ ! -f "$workflow" ]; then
    echo "Error: workflow template not found: $workflow" >&2
    return 1
  fi

  local output_file="$OUTPUT_DIR/$agent.md"

  if [ "$PRINT_ONLY" -eq 1 ]; then
    emit_subagent "$agent" "$template" "$workflow"
  else
    emit_subagent "$agent" "$template" "$workflow" > "$output_file"
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
