#!/usr/bin/env bash
#
# generate-capabilities.sh — Generate the capability-inventory skill from frontmatter + custom-capabilities.yaml
#
# This script runs against an installed or custom config base, harvesting built-in
# skills and custom capabilities to produce a single, shared capability inventory skill.
#
# Usage:
#   generate-capabilities.sh              # auto-resolve config base (env var, self-location, or default), write to destination
#   generate-capabilities.sh --print      # same resolution, print to stdout only
#   generate-capabilities.sh --config-base /custom/path --print
#
# Config base resolution precedence:
#   1. --config-base /path (CLI flag)
#   2. $OPENCODE_CONFIG_BASE (environment variable)
#   3. Self-location: the installed script lives at $CONFIG_BASE/yggdrasil/,
#      so its parent directory is used when it looks like a valid config base
#      (contains agents/yggdrasil/ and skills/yggdrasil/)
#   4. ~/.config/opencode (default)
#
# The generated file is deterministic (LC_ALL=C, sorted iteration) and read-only.
# Edit custom-capabilities.yaml and re-run this script to update capability knowledge.

set -euo pipefail

PRINT_ONLY=0
CONFIG_BASE=""

# Parse CLI flags.
while [ "${1:-}" != "" ]; do
  case "$1" in
    --config-base)
      shift
      if [ -z "${1:-}" ]; then
        echo "Error: --config-base requires an argument" >&2
        exit 1
      fi
      CONFIG_BASE="$1"
      shift
      ;;
    --print)
      PRINT_ONLY=1
      shift
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      exit 2
      ;;
  esac
done

# Resolution: flag > env > self-location > default.
if [ -z "$CONFIG_BASE" ]; then
  CONFIG_BASE="${OPENCODE_CONFIG_BASE:-}"
fi

# Self-location fallback — derive CONFIG_BASE from the script's own
# resolved location ($CONFIG_BASE/yggdrasil/generate-capabilities.sh when
# installed). Applies only when neither --config-base nor
# $OPENCODE_CONFIG_BASE is set, and only if the derived path looks like a
# real config base; otherwise fall through to the default below.
if [ -z "$CONFIG_BASE" ]; then
  SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
  while [ -h "$SCRIPT_SOURCE" ]; do
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
    SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
    case "$SCRIPT_SOURCE" in
      /*) ;;
      *) SCRIPT_SOURCE="${SCRIPT_DIR}/${SCRIPT_SOURCE}" ;;
    esac
  done
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" >/dev/null 2>&1 && pwd)"
  SELF_CANDIDATE="$(dirname "$SCRIPT_DIR")"
  if [ -d "${SELF_CANDIDATE}/agents/yggdrasil" ] && [ -d "${SELF_CANDIDATE}/skills/yggdrasil" ]; then
    CONFIG_BASE="$SELF_CANDIDATE"
  fi
fi

if [ -z "$CONFIG_BASE" ]; then
  CONFIG_BASE="${HOME}/.config/opencode"
fi

# Normalize CONFIG_BASE (match setup.sh's exact normalization logic).
# Expand ~ or ~/ to $HOME
case "$CONFIG_BASE" in
  ~)
    CONFIG_BASE="$HOME"
    ;;
  ~*)
    CONFIG_BASE="${HOME}${CONFIG_BASE#\~}"
    ;;
esac
# Strip trailing slashes
while [ "${CONFIG_BASE%/}" != "$CONFIG_BASE" ]; do
  CONFIG_BASE="${CONFIG_BASE%/}"
done
# Trim leading/trailing whitespace (defensive)
CONFIG_BASE=$(echo "$CONFIG_BASE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

# Reject empty (should not happen, but be safe)
if [ -z "$CONFIG_BASE" ]; then
  echo "Error: CONFIG_BASE resolved to empty" >&2
  exit 1
fi

# Set paths (single mode: always use installed layout).
AGENTS_DIR="${CONFIG_BASE}/agents/yggdrasil"
SKILLS_DIR="${CONFIG_BASE}/skills/yggdrasil"
CUSTOM_CAPS_FILE="${CONFIG_BASE}/yggdrasil/custom-capabilities.yaml"
OUTPUT_FILE="${CONFIG_BASE}/skills/yggdrasil/shared/capability-inventory/SKILL.md"

# Verify harvest directories exist.
if [ ! -d "$AGENTS_DIR" ]; then
  echo "Error: agents directory not found: $AGENTS_DIR" >&2
  echo "       Run setup.sh first, or set OPENCODE_CONFIG_BASE / pass --config-base if your config base is non-default." >&2
  exit 1
fi
if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: skills directory not found: $SKILLS_DIR" >&2
  echo "       Run setup.sh first, or set OPENCODE_CONFIG_BASE / pass --config-base if your config base is non-default." >&2
  exit 1
fi

# Helper: extract frontmatter value (matching validate.sh pattern).
frontmatter_value() {
  local file="$1" key="$2"
  awk -v k="$key" '
    NR == 1 { if ($0 != "---") exit 2; opened = 1; next }
    opened && $0 == "---" { closed = 1; exit 0 }
    opened { print }
    END { if (!closed) exit 3 }
  ' "$file" 2>/dev/null | awk -v k="$key" '
    $0 ~ ("^" k ":") {
      sub("^" k ":[[:space:]]*", "")
      gsub(/^["'"'"']|["'"'"']$/, "")
      sub(/[[:space:]]+$/, "")
      print
      exit
    }
  '
}

# --- Step 1: Harvest built-in capabilities from agent/skill frontmatter ---

# Harvest skills organized by role (using separate variables for each role).
researcher_skills=""
implementer_skills=""
reviewer_skills=""
strategist_skills=""
communicator_skills=""

# Iterate sorted skill directories under skills/
# Extract agent as the first path component after SKILLS_DIR:
# E.g.: $SKILLS_DIR/mimir/mimir-web-research/SKILL.md → agent is "mimir"
export LC_ALL=C
while IFS= read -r -d '' skill_file; do
  skill_name=$(frontmatter_value "$skill_file" "name" 2>/dev/null || true)
  skill_desc=$(frontmatter_value "$skill_file" "description" 2>/dev/null || true)
  
  if [ -z "$skill_name" ] || [ -z "$skill_desc" ]; then
    continue
  fi
  
  # Extract agent from path relative to SKILLS_DIR.
  # Remove the SKILLS_DIR prefix, then take the first remaining path component.
  relative_path="${skill_file#${SKILLS_DIR}/}"
  agent=$(echo "$relative_path" | cut -d'/' -f1)
  
  if [ -z "$agent" ]; then
    continue
  fi
  
  # Map agent to role.
  role=""
  case "$agent" in
    mimir) role="researcher" ;;
    brokk) role="implementer" ;;
    heimdall) role="reviewer" ;;
    kvasir) role="strategist" ;;
    bragi) role="communicator" ;;
  esac
  
  if [ -z "$role" ]; then
    continue
  fi
  
  # Strip <agent>- prefix from skill name.
  stripped_name="${skill_name#${agent}-}"
  
  # Append to role inventory.
  entry="- **$stripped_name** — $skill_desc"
  case "$role" in
    researcher)
      if [ -n "$researcher_skills" ]; then
        researcher_skills="${researcher_skills}
${entry}"
      else
        researcher_skills="$entry"
      fi
      ;;
    implementer)
      if [ -n "$implementer_skills" ]; then
        implementer_skills="${implementer_skills}
${entry}"
      else
        implementer_skills="$entry"
      fi
      ;;
    reviewer)
      if [ -n "$reviewer_skills" ]; then
        reviewer_skills="${reviewer_skills}
${entry}"
      else
        reviewer_skills="$entry"
      fi
      ;;
    strategist)
      if [ -n "$strategist_skills" ]; then
        strategist_skills="${strategist_skills}
${entry}"
      else
        strategist_skills="$entry"
      fi
      ;;
    communicator)
      if [ -n "$communicator_skills" ]; then
        communicator_skills="${communicator_skills}
${entry}"
      else
        communicator_skills="$entry"
      fi
      ;;
  esac
done < <(find "$SKILLS_DIR" -name SKILL.md -print0 | sort -z)

# --- Step 2: Harvest custom capabilities from custom-capabilities.yaml ---

custom_inventory=""

if [ -f "$CUSTOM_CAPS_FILE" ]; then
  # Parse custom_capabilities list with basic YAML handling.
  in_custom=0
  current_name=""
  current_role=""
  current_summary=""
  
  while IFS= read -r line || [ -n "$line" ]; do
    # Detect start of custom_capabilities list.
    if echo "$line" | grep -q "^custom_capabilities:"; then
      in_custom=1
      continue
    fi
    
    # If in custom list and line starts with "  - name:", parse entry.
    if [ "$in_custom" = 1 ]; then
      if echo "$line" | grep -q "^  - name:"; then
        current_name=$(echo "$line" | sed 's/.*- name:[[:space:]]*//' | sed 's/^ *//; s/ *$//' | tr -d '"'\''')
      elif echo "$line" | grep -q "^    role:"; then
        current_role=$(echo "$line" | sed 's/^[[:space:]]*role:[[:space:]]*//' | sed 's/ *$//' | tr -d '"'\''')
      elif echo "$line" | grep -q "^    summary:"; then
        current_summary=$(echo "$line" | sed 's/^[[:space:]]*summary:[[:space:]]*//' | sed 's/ *$//' | tr -d '"'\''')
        
        # Emit the entry.
        if [ -n "$current_name" ] && [ -n "$current_role" ] && [ -n "$current_summary" ]; then
          entry="- **$current_name** — role: $current_role — $current_summary"
          if [ -n "$custom_inventory" ]; then
            custom_inventory="${custom_inventory}
${entry}"
          else
            custom_inventory="$entry"
          fi
        fi
        
        current_name=""
        current_role=""
        current_summary=""
      fi
    fi
  done < "$CUSTOM_CAPS_FILE"
fi

# Custom inventory: either the entries or "None granted."
if [ -z "$custom_inventory" ]; then
  custom_inventory="None granted."
fi

# --- Step 3: Render the capability-inventory skill file ---

render_skill() {
  cat <<'EOF'
---
name: capability-inventory
description: Generated inventory of all specialist capabilities — built-in skills by role plus custom-granted tools. Load at the start of planning or orchestration.
---

<!-- GENERATED FILE — do not edit directly. Edit $CONFIG_BASE/yggdrasil/custom-capabilities.yaml and run $CONFIG_BASE/yggdrasil/generate-capabilities.sh to regenerate. -->

# Skill: capability-inventory

## Purpose

The single generated source of capability knowledge for planning and routing.
Combines the built-in skill set (harvested from agent and skill frontmatter)
with any custom capabilities manually granted to specialists, so work can be
routed to the right role without blind spots.

## When to Use

- Load at the start of planning or orchestration (once per session).
- Consult the Inventory sections when deciding which role can handle a task.
- Do not assume capabilities beyond what is listed in the Inventory sections.

## Inventory — Built-In Skills

### researcher
EOF

  if [ -n "$researcher_skills" ]; then
    echo "$researcher_skills"
  else
    echo "(none)"
  fi

  cat <<'EOF'

### implementer
EOF

  if [ -n "$implementer_skills" ]; then
    echo "$implementer_skills"
  else
    echo "(none)"
  fi

  cat <<'EOF'

### reviewer
EOF

  if [ -n "$reviewer_skills" ]; then
    echo "$reviewer_skills"
  else
    echo "(none)"
  fi

  cat <<'EOF'

### strategist
EOF

  if [ -n "$strategist_skills" ]; then
    echo "$strategist_skills"
  else
    echo "(none)"
  fi

  cat <<'EOF'

### communicator
EOF

  if [ -n "$communicator_skills" ]; then
    echo "$communicator_skills"
  else
    echo "(none)"
  fi

  cat <<'EOF'

## Inventory — Custom Capabilities

EOF
  echo "$custom_inventory"

  cat <<'EOF'

## Workflow

1. Load this skill at the start of planning or orchestration (once per session — do not re-load).
2. Scan both Inventory sections and note which roles have relevant capabilities.
3. Route work to the role holding the capability when it applies.
4. Treat the Inventory sections as the authoritative list — do not assume capabilities beyond what is listed.

## Quality Criteria

- Built-in entries are harvested mechanically from frontmatter — never hand-edited.
- Custom entries (in `custom-capabilities.yaml`) are role-phrased, nameless, and self-contained.
- The file is regenerated (never hand-edited) whenever agent/skill frontmatter or `custom-capabilities.yaml` changes.

## Anti-Patterns

- Hand-editing this file directly instead of editing `custom-capabilities.yaml` and regenerating.
- Assuming capabilities exist without consulting the Inventory sections.
- Naming agents instead of roles in custom entries.
- Leaving this file stale after a capability is added, changed, or removed.
EOF
}

# --- Output or write ---

if [ "$PRINT_ONLY" = 1 ]; then
  render_skill
else
  # Ensure directory exists.
  mkdir -p "$(dirname "$OUTPUT_FILE")"
  
  # Write the skill file.
  render_skill > "$OUTPUT_FILE"
  
  echo "Generated: $OUTPUT_FILE" >&2
fi
