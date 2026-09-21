#!/usr/bin/env bash
#
# validate.sh — Read-only structural validator for the Yggdrasil project.
#
# This script performs ten structural checks against the agent, skill, and
# command definitions and reports a per-check summary plus a final PASS/FAIL verdict.
#
#   1. Frontmatter parse check — every agents/*.md and skills/**/SKILL.md has a
#      well-formed YAML frontmatter block (--- ... ---) containing the two
#      required top-level keys `name` and `description`.
#   2. Required skill sections — every SKILL.md contains the 5 required section
#      headers in the correct order.
#   3. Slug / name-field match — each skill's `name:` frontmatter value equals
#      its containing directory (the skill slug).
#   4. Agent freshness — the three Odin agent files (odin-autonomous,
#      odin-guided, odin-interactive) and the six subagent files (bragi,
#      brokk, eitri, heimdall, kvasir, mimir) are regenerated from their
#      templates via scripts/generate-odin-agents.sh and
#      scripts/generate-subagents.sh into a temp directory, then diffed
#      byte-for-byte against the committed files in agents/. Any drift fails —
#      whether from hand-editing a generated file or from editing a template
#      without regenerating.
#   5. Subagent isolation — subagent prompts (agents/<name>.md for mimir,
#      brokk, heimdall, kvasir, bragi, eitri) and their skills (matched by slug
#      prefix anywhere under skills/) must not reference any other agent by name
#      (case-insensitive, word-boundary match). Self-references are allowed;
#      Odin's files and skills are exempt from this scan.
#   6. Skill description namelessness + repo scaffold emptiness — every skills/**/SKILL.md's
#      `description:` frontmatter field must not leak any agent name (odin, mimir, brokk,
#      heimdall, kvasir, bragi, eitri — case-insensitive, whole-word match). Also verifies the
#      repo's config-home/custom-capabilities.yaml and skills/shared/ remain empty (no custom tool
#      grants or generated files in the repo).
#   7. Odin agent invariant markers (rule strings present in generated agent) —
#      a curated list of distinctive strings (invariant markers) must appear in
#      agents/odin-autonomous.md to guard invariant orchestration rules against
#      accidental drops during template edits.
#   8. Command file validation — every commands/*.md has required frontmatter
#      (`description`), valid `agent` field (if present, must be an Odin variant),
#      valid `subtask` field (if present, must be `false`), and non-empty template body.
#   9. Mandatory-skill isolation from optional skills — no .md file under a
#      mandatory feature directory (research/, memories/, deliberation/,
#      engineering/, architecture/) may reference the slug of a skill that
#      ships only with an optional agent bundle (skills/<agent>/), so mandatory
#      skills keep working on a mandatory-only install. Both slug lists are
#      derived at check time.
#  10. No license texts under skills/ — no entry matching LICENSE*
#      (case-insensitive) may exist anywhere in the skills/ tree, because
#      setup.sh copies that tree wholesale into the user's config home, which
#      would install licensing/legal files onto every machine. Third-party
#      license texts belong in the repo-root LICENSES/ directory, which
#      setup.sh never copies.
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
FAIL_ODIN_FRESHNESS=0
FAIL_ISOLATION=0
FAIL_CAPABILITIES=0
FAIL_PARITY_MARKERS=0

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

  local file

  # Agents: require a well-formed block containing at least `name` and `description`.
  for file in "$AGENTS_DIR"/*.md; do
    [ -e "$file" ] || continue
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

  # Skills: require a well-formed block containing `name` and `description`.
  while IFS= read -r -d '' file; do
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
  done < <(find "$SKILLS_DIR" -name SKILL.md -print0 | sort -z)

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
  while IFS= read -r -d '' file; do
    # The ordered list of level-2 headers in this file, one per line.
    # Strip the leading "## " and any trailing whitespace.
    local headers
    headers=$(grep -E '^## ' "$file" | sed -E 's/^##[[:space:]]+//; s/[[:space:]]+$//' || true)

    local missing="" out_of_order=0
    local req

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
  done < <(find "$SKILLS_DIR" -name SKILL.md -print0 | sort -z)

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
  while IFS= read -r -d '' file; do
    slug=$(basename "$(dirname "$file")")
    name=$(frontmatter_value "$file" "name")
    if [ -z "$name" ]; then
      fail_msg "$(rel "$file"): could not read 'name' from frontmatter"
      FAIL_SLUG=$((FAIL_SLUG + 1))
    elif [ "$name" != "$slug" ]; then
      fail_msg "$(rel "$file"): name '$name' != directory slug '$slug'"
      FAIL_SLUG=$((FAIL_SLUG + 1))
    fi
  done < <(find "$SKILLS_DIR" -name SKILL.md -print0 | sort -z)

  if [ "$FAIL_SLUG" -eq 0 ]; then
    pass_msg "every skill's name field matches its directory slug"
  else
    info_msg "${C_RED}${FAIL_SLUG} slug mismatch(es)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 4 — Agent freshness (Odin + subagents).
#
# The three Odin agent files are generated from templates in scripts/odin-generator/
# by scripts/generate-odin-agents.sh. The six subagent files are generated from
# templates in scripts/subagent-generator/ by scripts/generate-subagents.sh.
# This check regenerates all nine files and verifies they match the committed
# versions byte-for-byte. Any drift — whether from hand-editing a generated file
# or failing to regenerate after editing the source — is caught.
# ---------------------------------------------------------------------------
ODIN_FILES='odin-autonomous.md odin-guided.md odin-interactive.md'
ODIN_GENERATOR="$REPO_ROOT/scripts/generate-odin-agents.sh"
SUBAGENT_GENERATOR="$REPO_ROOT/scripts/generate-subagents.sh"
SUBAGENT_NAMES='bragi brokk eitri heimdall kvasir mimir'

check_agent_freshness() {
  heading "Check 4: Agent freshness (regenerate and diff)"

  # Verify generator exists
  if [ ! -f "$ODIN_GENERATOR" ]; then
    fail_msg "Odin generator not found: $ODIN_GENERATOR"
    FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
    return
  fi

  # Create temp directory for regenerated files
  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' RETURN

  # Regenerate all three files
  local mode
  for mode in autonomous guided interactive; do
    if ! "$ODIN_GENERATOR" --mode "$mode" --print > "$tmp/odin-$mode.md" 2>/dev/null; then
      fail_msg "agents/odin-$mode.md: generator failed"
      FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
      continue
    fi
  done

  # Compare each file against committed version
  local f
  for f in $ODIN_FILES; do
    local committed="$AGENTS_DIR/$f"
    local generated="$tmp/$f"

    if [ ! -f "$committed" ]; then
      fail_msg "agents/$f: file not found"
      FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
      continue
    fi

    if ! diff -q "$committed" "$generated" >/dev/null 2>&1; then
      fail_msg "agents/$f: stale (regenerate with: scripts/generate-odin-agents.sh)"
      FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
    fi
  done

  # --- Subagent freshness ---
  if [ ! -f "$SUBAGENT_GENERATOR" ]; then
    fail_msg "subagent generator not found: $SUBAGENT_GENERATOR"
    FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
  else
    local subagent
    for subagent in $SUBAGENT_NAMES; do
      local f="$subagent.md"
      local committed="$AGENTS_DIR/$f"
      local generated="$tmp/$f"

      if ! "$SUBAGENT_GENERATOR" --agent "$subagent" --print > "$generated" 2>/dev/null; then
        fail_msg "agents/$f: subagent generator failed"
        FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
        continue
      fi

      if [ ! -f "$committed" ]; then
        fail_msg "agents/$f: file not found"
        FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
        continue
      fi

      if ! diff -q "$committed" "$generated" >/dev/null 2>&1; then
        fail_msg "agents/$f: stale (regenerate with: scripts/generate-subagents.sh)"
        FAIL_ODIN_FRESHNESS=$((FAIL_ODIN_FRESHNESS + 1))
      fi
    done
  fi

  if [ "$FAIL_ODIN_FRESHNESS" -eq 0 ]; then
    pass_msg "all 3 Odin agents and 6 subagents match regenerated output (byte-identical)"
  else
    info_msg "${C_RED}${FAIL_ODIN_FRESHNESS} freshness failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 5 — Subagent isolation.
#
# Subagents do not know about each other: each subagent's prompt
# (agents/<name>.md) and each subagent-owned skill must not mention any OTHER
# agent by name. Skill ownership is derived from the skill slug's <agent>-
# prefix (frontmatter name == directory slug, enforced by Check 3), NOT from
# the directory layout — so mandatory skills in the feature directories
# (research/, memories/, deliberation/, engineering/, architecture/) are
# scanned identically to optional skills under skills/<agent>/. A skill's
# owner therefore changes with a slug rename, not with a directory move.
# Matching is case-insensitive with word boundaries (grep -iw), so
# word-internal occurrences such as "encoding" or "Hardcoding" do not falsely
# match "odin". Self-references are allowed.
# odin-* skills are exempt (the orchestrator knows the full pantheon);
# non-agent slugs (e.g. shared skills) are not scanned.
# ---------------------------------------------------------------------------
SUBAGENT_NAMES='mimir brokk heimdall kvasir bragi eitri'
ALL_AGENT_NAMES='odin mimir brokk heimdall kvasir bragi eitri'

# Scan one file owned by agent $2 for references to any other agent name.
scan_isolation() {
  local file="$1" agent="$2" other hit
  for other in $ALL_AGENT_NAMES; do
    [ "$other" = "$agent" ] && continue
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      fail_msg "$(rel "$file"): line ${hit%%:*}: references other agent '$other'"
      FAIL_ISOLATION=$((FAIL_ISOLATION + 1))
    done <<EOF
$(grep -iwn "$other" "$file" 2>/dev/null || true)
EOF
  done
}

check_isolation() {
  heading "Check 5: Subagent isolation (no cross-agent references)"

  local agent file slug owner

  # Subagent prompt files.
  for agent in $SUBAGENT_NAMES; do
    file="$AGENTS_DIR/$agent.md"
    [ -f "$file" ] || continue
    scan_isolation "$file" "$agent"
  done

  # Skill files — owner derived from the slug prefix (layout-independent).
  while IFS= read -r -d '' file; do
    slug=$(basename "$(dirname "$file")")
    owner="${slug%%-*}"
    case "$owner" in
      odin) continue ;;
      mimir|brokk|heimdall|kvasir|bragi|eitri) scan_isolation "$file" "$owner" ;;
      *) continue ;;
    esac
  done < <(find "$SKILLS_DIR" -name SKILL.md -print0 | sort -z)

  if [ "$FAIL_ISOLATION" -eq 0 ]; then
    pass_msg "no subagent prompt or skill references another agent by name"
  else
    info_msg "${C_RED}${FAIL_ISOLATION} isolation violation(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 6 — Skill description namelessness (6b) + repo scaffold emptiness (6c).
# ---------------------------------------------------------------------------
check_capabilities() {
  heading "Check 6: Skill description namelessness + repo scaffold emptiness"

  # Check 6b: Lint — scan every skill's description frontmatter field for agent-name
  # leaks (no agent names should appear in descriptions, as these appear in the
  # dynamically-generated capability-inventory skill).
  local name_leaks=0
  while IFS= read -r -d '' skill_file; do
    local description
    description=$(frontmatter_value "$skill_file" "description" 2>/dev/null || true)
    if [ -z "$description" ]; then
      continue
    fi
    
    local line_num=0
    while IFS= read -r line || [ -n "$line" ]; do
      line_num=$((line_num + 1))
      
      # Check for agent names (case-insensitive, whole-word) in the description.
      for agent in odin mimir brokk heimdall kvasir bragi eitri; do
        if echo "$line" | grep -iqw "$agent"; then
          fail_msg "$(rel "$skill_file"): description contains agent name '$agent' (must be agent-neutral)"
          name_leaks=$((name_leaks + 1))
        fi
      done
    done <<< "$description"
  done < <(find "$SKILLS_DIR" -name "SKILL.md" -print0 | sort -z)
  
  if [ "$name_leaks" -gt 0 ]; then
    FAIL_CAPABILITIES=$((FAIL_CAPABILITIES + 1))
  fi
  
  # Check 6c: Scaffold emptiness — the repo's config-home/custom-capabilities.yaml must be
  # empty (no real custom tool grants). This prevents accidentally committing
  # user-specific custom capabilities into the shared framework. Real custom
  # grants live in the INSTALLED copy ($CONFIG_BASE/yggdrasil/custom-capabilities.yaml).
  local custom_caps_file="$REPO_ROOT/config-home/custom-capabilities.yaml"
  if [ -f "$custom_caps_file" ]; then
    # Check if any non-comment, non-empty lines exist under custom_capabilities:.
    # Look for "  - name:" entries (the start of a custom capability list item).
    if grep -q "^  - name:" "$custom_caps_file"; then
      fail_msg "$(rel "$custom_caps_file"): repo scaffold must remain empty (no custom entries)"
      fail_msg "  Custom tool grants belong in the installed copy: \$CONFIG_BASE/yggdrasil/custom-capabilities.yaml"
      FAIL_CAPABILITIES=$((FAIL_CAPABILITIES + 1))
    fi
  fi
  
  # Check 6d: skills/shared/ must remain empty in the repo. Generated files like
  # capability-inventory belong in the installed copy only ($CONFIG_BASE/skills/yggdrasil/shared/).
  # The repo's skills/shared/ directory should contain no SKILL.md files.
  # `|| true` keeps this exit-status neutral under `set -euo pipefail`: the
  # directory is absent in a clean checkout, so `find` exits non-zero and
  # pipefail would otherwise abort the script. `wc -l` still reports 0.
  local shared_skills_count
  shared_skills_count=$(find "$SKILLS_DIR/shared" -name "SKILL.md" 2>/dev/null | wc -l || true)
  if [ "$shared_skills_count" -gt 0 ]; then
    fail_msg "$(rel "$SKILLS_DIR/shared"): must remain empty (no generated skills in repo)"
    fail_msg "  Generated files like capability-inventory belong in the installed copy: \$CONFIG_BASE/skills/yggdrasil/shared/"
    FAIL_CAPABILITIES=$((FAIL_CAPABILITIES + 1))
  fi
  
  if [ "$FAIL_CAPABILITIES" -eq 0 ]; then
    pass_msg "skill descriptions are nameless; repo scaffold is empty"
  else
    info_msg "${C_RED}${FAIL_CAPABILITIES} capability issue(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 7 — Odin agent invariant markers.
#
# Verifies that a curated list of distinctive, fixed strings (invariant markers)
# appear in agents/odin-autonomous.md (the other two Odin files are covered
# transitively by check 4). These markers guard invariant orchestration rules
# against accidental drops during template edits — the generated file is
# byte-identical to the source template, so a missing marker indicates the
# template's rule wording changed without a corresponding marker-list update.
# ---------------------------------------------------------------------------
check_parity_markers() {
  heading "Check 7: Odin agent invariant markers"

  local odin_file="$AGENTS_DIR/odin-autonomous.md"
  
  if [ ! -f "$odin_file" ]; then
    fail_msg "odin-autonomous.md not found: $odin_file"
    FAIL_PARITY_MARKERS=$((FAIL_PARITY_MARKERS + 1))
    return
  fi

  # Invariant marker list: each marker must appear (case-insensitive fixed-string
  # match) in odin-autonomous.md.
  #
  # Selection principle: markers are stable tokens (path templates, verdict
  # grammar, named hard-rule identifiers) that are never legitimately reworded —
  # not doctrinal prose, which changes as the prompts evolve. Any deliberate
  # edit to marked content must update this list in the same commit.
  # Listed in document order of agents/odin-autonomous.md.
  local markers=(
    # Boundaries — artifact-routing discipline
    "read artifact files or paraphrase their contents"
    # Workspace / memory canonical path templates
    ".yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/"
    ".yggdrasil-memory/"
    # Memory trust discipline
    "leads, not ground truth"
    # Session-reuse: Final Review Gate independence
    "fresh Heimdall session"
     # Kvasir Consultation Check verdict grammar
     "substantive Subtasks="
     # Review Mechanics — mandatory producer review, self-review ban,
     # baseline pinning, verdict grammar
    "receives a dedicated Heimdall review"
    "never itself re-reviewed"
    "Pin the review baseline"
    "PASS-WITH-NOTES"
    # Failed Review Classification — disputed-findings hard rule,
    # baseline-error doctrine
    "no bypassing specialist review"
    "Baseline error"
     # Final Review Gate — delivery hard rule, ground-truth verification
     "No Deliverable reaches the user without passing"
     "verify claims against verifiable ground truth"
    # Communication Policy — no silent degradation
    "undocumented abandonment"
  )

  local marker
  for marker in "${markers[@]}"; do
    # Check odin-autonomous.md (case-insensitive, fixed-string match)
    if ! grep -iF "$marker" "$odin_file" >/dev/null 2>&1; then
      fail_msg "odin-autonomous.md: missing invariant marker: '$marker'"
      FAIL_PARITY_MARKERS=$((FAIL_PARITY_MARKERS + 1))
    fi
  done

  if [ "$FAIL_PARITY_MARKERS" -eq 0 ]; then
    pass_msg "all ${#markers[@]} invariant markers present in odin-autonomous.md"
  else
    info_msg "${C_RED}${FAIL_PARITY_MARKERS} invariant marker failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 8 — Command file validation.
#
# Verifies that command files in commands/*.md have:
# (a) Required frontmatter present (`description` at minimum).
# (b) If an `agent` field is present, its value must exactly match one of the
#     three Odin variants' display names (Odin (Autonomous), Odin (Guided),
#     Odin (Interactive)) — this tripwire prevents specialist-targeted commands.
# (c) `subtask` if present must be `false` (not `true`).
# (d) Template body is non-empty (references $ARGUMENTS or contains instructions).
# ---------------------------------------------------------------------------
FAIL_COMMANDS=0
COMMANDS_DIR="$REPO_ROOT/commands"

check_commands() {
  heading "Check 8: Command file validation (commands/*.md)"

  # If commands directory doesn't exist, that's OK (not an error).
  if [ ! -d "$COMMANDS_DIR" ]; then
    pass_msg "commands directory does not exist (optional)"
    return
  fi

  local file agent subtask
  while IFS= read -r -d '' file; do
    # Check frontmatter parses and has required fields.
    if ! extract_frontmatter "$file" >/dev/null 2>&1; then
      fail_msg "$(rel "$file"): malformed frontmatter (missing opening/closing '---')"
      FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
      continue
    fi
    if ! frontmatter_has_key "$file" "description"; then
      fail_msg "$(rel "$file"): frontmatter missing required key 'description'"
      FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
    fi

    # Check agent field if present: must be an Odin variant.
    if frontmatter_has_key "$file" "agent"; then
      agent=$(frontmatter_value "$file" "agent")
      case "$agent" in
        "Odin (Autonomous)"|"Odin (Guided)"|"Odin (Interactive)")
          # Valid Odin variant.
          ;;
        *)
          fail_msg "$(rel "$file"): agent field '$agent' is not an Odin variant (must be 'Odin (Autonomous)', 'Odin (Guided)', or 'Odin (Interactive)')"
          FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
          ;;
      esac
    fi

    # Check subtask field if present: must be false (not true).
    if frontmatter_has_key "$file" "subtask"; then
      subtask=$(frontmatter_value "$file" "subtask")
      case "$subtask" in
        false)
          # Valid.
          ;;
        true)
          fail_msg "$(rel "$file"): subtask must be 'false' or omitted (not 'true')"
          FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
          ;;
        *)
          fail_msg "$(rel "$file"): subtask field has invalid value '$subtask' (must be 'true' or 'false')"
          FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
          ;;
      esac
    fi

    # Check template body is non-empty (everything after frontmatter).
    # Extract the body: skip frontmatter, then check if anything remains.
    local body
    body=$(awk '
      NR == 1 { if ($0 != "---") exit 2; opened = 1; next }
      opened && $0 == "---" { closed = 1; next }
      closed { print }
    ' "$file" 2>/dev/null || true)
    
    # Trim leading/trailing whitespace from body.
    body=$(printf '%s\n' "$body" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    if [ -z "$body" ]; then
      fail_msg "$(rel "$file"): template body is empty (must contain instructions)"
      FAIL_COMMANDS=$((FAIL_COMMANDS + 1))
    fi
  done < <(find "$COMMANDS_DIR" -name "*.md" -print0 2>/dev/null | sort -z)

  if [ "$FAIL_COMMANDS" -eq 0 ]; then
    pass_msg "all command files have valid frontmatter and templates"
  else
    info_msg "${C_RED}${FAIL_COMMANDS} command file failure(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 9 — Mandatory-skill isolation from optional skills.
#
# Skills in the mandatory feature directories are installed unconditionally, so
# they must be complete on a mandatory-only install. Referencing a skill that
# ships only with an optional agent bundle is therefore a hidden dependency:
# the reference silently dangles for a user who declined the optional skills.
# For every .md file under a mandatory feature directory, this check fails if
# the file names the slug of any skill directory under an OPTIONAL root.
#
# Neither slug list is hardcoded — both are derived from the tree at check time
# so new, renamed, or removed skills are picked up automatically:
#   * mandatory feature directories come from MANDATORY_SKILL_DIRS (mirroring
#     setup.sh);
#   * optional roots are every skills/*/ directory that is neither a mandatory
#     feature directory nor the shared/ scaffold, and the optional slugs are
#     the skill directories inside them.
#
# Allowed by construction: a mandatory skill's own slug and any mandatory ->
# mandatory cross-reference, because only optional slugs are ever searched for.
# A slug that exists under BOTH an optional root and a mandatory feature
# directory is dropped from the search list for the same reason.
#
# Matching uses hyphen-aware word boundaries so a shorter optional slug cannot
# match inside a longer mandatory one (e.g. optional `a-b` inside `a-b-c`).
# ---------------------------------------------------------------------------
FAIL_MANDATORY_ISOLATION=0

# The mandatory feature directories — mirrors MANDATORY_SKILL_DIRS in setup.sh.
# Keep the two in sync. Every other skills/*/ root is optional: an agent bundle
# (skills/<agent>/) the user may decline, or the shared/ scaffold.
MANDATORY_SKILL_DIRS='research memories deliberation engineering architecture'

# Is $1 the name of a mandatory feature directory?
is_mandatory_skill_dir() {
  case " $MANDATORY_SKILL_DIRS " in
    *" $1 "*) return 0 ;;
  esac
  return 1
}

# Print the slug of every skill directory under a mandatory feature directory.
mandatory_skill_slugs() {
  local feature dir
  for feature in $MANDATORY_SKILL_DIRS; do
    [ -d "$SKILLS_DIR/$feature" ] || continue
    for dir in "$SKILLS_DIR/$feature"/*/; do
      [ -d "$dir" ] || continue
      basename "$dir"
    done
  done
}

# Print the slug of every skill directory under an optional root — any
# skills/*/ that is neither a mandatory feature directory nor shared/.
optional_skill_slugs() {
  local root rootname dir
  for root in "$SKILLS_DIR"/*/; do
    [ -d "$root" ] || continue
    rootname=$(basename "$root")
    [ "$rootname" = "shared" ] && continue
    is_mandatory_skill_dir "$rootname" && continue
    for dir in "$root"*/; do
      [ -d "$dir" ] || continue
      basename "$dir"
    done
  done
}

# NUL-delimited, sorted list of every .md file under a mandatory feature
# directory (SKILL.md plus companion files such as templates).
mandatory_skill_md_files() {
  local feature
  for feature in $MANDATORY_SKILL_DIRS; do
    [ -d "$SKILLS_DIR/$feature" ] || continue
    find "$SKILLS_DIR/$feature" -name '*.md' -print0
  done | sort -z
}

check_mandatory_isolation() {
  heading "Check 9: Mandatory-skill isolation from optional skills"

  local mandatory_slugs optional_slugs search_slugs slug
  mandatory_slugs=$(mandatory_skill_slugs)
  optional_slugs=$(optional_skill_slugs)

  # Build the search list: optional slugs minus any that also exist as a
  # mandatory skill (a name collision there means the reference is
  # mandatory -> mandatory, which is allowed).
  search_slugs=""
  while IFS= read -r slug; do
    [ -n "$slug" ] || continue
    if printf '%s\n' "$mandatory_slugs" | grep -Fxq "$slug"; then
      continue
    fi
    search_slugs="${search_slugs}${slug}
"
  done <<EOF
$optional_slugs
EOF

  if [ -z "$search_slugs" ]; then
    pass_msg "no optional skill directories present; nothing to isolate against"
    return
  fi

  local file pattern hit
  while IFS= read -r -d '' file; do
    while IFS= read -r slug; do
      [ -n "$slug" ] || continue
      pattern='(^|[^A-Za-z0-9_-])'"$slug"'([^A-Za-z0-9_-]|$)'
      while IFS= read -r hit; do
        [ -n "$hit" ] || continue
        fail_msg "$(rel "$file"): line ${hit%%:*}: references optional skill '$slug'"
        FAIL_MANDATORY_ISOLATION=$((FAIL_MANDATORY_ISOLATION + 1))
      done <<EOF
$(grep -nE "$pattern" "$file" 2>/dev/null || true)
EOF
    done <<EOF
$search_slugs
EOF
  done < <(mandatory_skill_md_files)

  if [ "$FAIL_MANDATORY_ISOLATION" -eq 0 ]; then
    pass_msg "no mandatory-directory skill references an optional skill"
  else
    info_msg "${C_RED}${FAIL_MANDATORY_ISOLATION} mandatory-isolation violation(s)${C_RESET}"
  fi
}

# ---------------------------------------------------------------------------
# CHECK 10 — No license texts under skills/.
#
# setup.sh copies the whole skills/ tree into the user's config home with no
# filename filtering, so any LICENSE file placed there is installed onto every
# user's machine — licensing/legal texts must never ship that way. This check
# is a repo-wide sweep: it fails on any entry matching LICENSE* (case-
# insensitive: LICENSE, LICENSE.txt, license.md, ...) anywhere under skills/,
# regardless of whether the containing directory is mandatory or optional.
# Third-party license texts belong in the repo-root LICENSES/ directory, which
# setup.sh never copies.
# ---------------------------------------------------------------------------
FAIL_SKILLS_LICENSE=0

check_skills_license() {
  heading "Check 10: No license texts under skills/"

  local file
  while IFS= read -r -d '' file; do
    fail_msg "$(rel "$file"): license texts under skills/ are installed wholesale by setup.sh; move it to LICENSES/"
    FAIL_SKILLS_LICENSE=$((FAIL_SKILLS_LICENSE + 1))
  done < <(find "$SKILLS_DIR" -iname 'LICENSE*' -print0 | sort -z)

  if [ "$FAIL_SKILLS_LICENSE" -eq 0 ]; then
    pass_msg "no LICENSE* entry anywhere under skills/"
  else
    info_msg "${C_RED}${FAIL_SKILLS_LICENSE} license-placement violation(s)${C_RESET}"
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
  check_agent_freshness
  printf '\n'
  check_isolation
  printf '\n'
  check_capabilities
  printf '\n'
  check_parity_markers
  printf '\n'
  check_commands
  printf '\n'
  check_mandatory_isolation
  printf '\n'
  check_skills_license
  printf '\n'

  # ---- Final summary -------------------------------------------------------
  local total=$((FAIL_FRONTMATTER + FAIL_SECTIONS + FAIL_SLUG + FAIL_ODIN_FRESHNESS + FAIL_ISOLATION + FAIL_CAPABILITIES + FAIL_PARITY_MARKERS + FAIL_COMMANDS + FAIL_MANDATORY_ISOLATION + FAIL_SKILLS_LICENSE))

  heading "Summary"
  printf '  %-34s %s\n' "Frontmatter parse:"        "$(fmt_count "$FAIL_FRONTMATTER")"
  printf '  %-34s %s\n' "Required sections/order:"  "$(fmt_count "$FAIL_SECTIONS")"
  printf '  %-34s %s\n' "Slug/name match:"          "$(fmt_count "$FAIL_SLUG")"
  printf '  %-34s %s\n' "Agent freshness:"          "$(fmt_count "$FAIL_ODIN_FRESHNESS")"
  printf '  %-34s %s\n' "Subagent isolation:"       "$(fmt_count "$FAIL_ISOLATION")"
  printf '  %-34s %s\n' "Capability mirror:"        "$(fmt_count "$FAIL_CAPABILITIES")"
  printf '  %-34s %s\n' "Parity markers:"           "$(fmt_count "$FAIL_PARITY_MARKERS")"
  printf '  %-34s %s\n' "Command files:"            "$(fmt_count "$FAIL_COMMANDS")"
  printf '  %-34s %s\n' "Mandatory-skill isolation:" "$(fmt_count "$FAIL_MANDATORY_ISOLATION")"
  printf '  %-34s %s\n' "License texts under skills/:" "$(fmt_count "$FAIL_SKILLS_LICENSE")"
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
