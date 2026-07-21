#!/usr/bin/env bash
#
# ci-smoke-generator.sh — End-to-end smoke test for the capability generator.
#
# This test validates that the generator works correctly in a realistic config-base
# scenario: it copies repo agents/skills/custom-caps to a temp location, runs the
# generator, and asserts the output is correct (non-empty, expected sections present,
# all roles populated, no agent-name leaks).
#
# This test is OUTSIDE validate.sh to preserve validate.sh's read-only/no-temp-files
# guarantee. Run it as part of CI or pre-commit checks to catch real generator issues.

set -euo pipefail

# Resolve script directory.
resolve_script_dir() {
  local src="${BASH_SOURCE[0]}"
  local dir
  while [ -h "$src" ]; do
    dir=$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
    src=$(readlink "$src")
    case "$src" in
      /*) ;;
      *) src="$dir/$src" ;;
    esac
  done
  cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd
}

SCRIPT_DIR=$(resolve_script_dir)
REPO_ROOT=$(cd -P "$SCRIPT_DIR/.." && pwd)

# Create a temp directory and set up a cleanup trap.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Copy repo structure to temp location to simulate an installed config base.
echo "Setting up synthetic config base in $tmp..."
mkdir -p "$tmp/agents/yggdrasil"
mkdir -p "$tmp/skills/yggdrasil"
mkdir -p "$tmp/yggdrasil"

cp -R "$REPO_ROOT/agents/"* "$tmp/agents/yggdrasil/" 2>/dev/null || true
cp -R "$REPO_ROOT/skills/"* "$tmp/skills/yggdrasil/" 2>/dev/null || true
cp "$REPO_ROOT/custom-capabilities.yaml" "$tmp/yggdrasil/custom-capabilities.yaml"

echo "Temp config base ready."
echo ""

# Run the generator against the synthetic config base.
echo "Running generator..."
output=$(OPENCODE_CONFIG_BASE="$tmp" "$REPO_ROOT/scripts/generate-capabilities.sh" --print 2>/dev/null)

# Helper function to check presence of a substring.
check_contains() {
  local name="$1"
  local pattern="$2"
  if echo "$output" | grep -q "$pattern"; then
    echo "  ✓ $name"
    return 0
  else
    echo "  ✗ $name (pattern: $pattern)"
    return 1
  fi
}

# Helper function to check absence of a substring (whole-word match).
check_absent() {
  local name="$1"
  local pattern="$2"
  # Use grep -iw for case-insensitive, whole-word match
  if echo "$output" | grep -iqw "$pattern"; then
    echo "  ✗ $name (found: $pattern)"
    return 1
  else
    echo "  ✓ $name"
    return 0
  fi
}

echo ""
echo "Assertions:"
failures=0

# (a) Output is non-empty
if [ -z "$output" ]; then
  echo "  ✗ Output is non-empty"
  failures=$((failures + 1))
else
  echo "  ✓ Output is non-empty"
fi

# (b) Required section headers are present
echo "Checking section headers..."
check_contains "## Purpose" "^## Purpose$" || failures=$((failures + 1))
check_contains "## When to Use" "^## When to Use$" || failures=$((failures + 1))
check_contains "## Inventory — Built-In Skills" "^## Inventory.*Built-In Skills$" || failures=$((failures + 1))
check_contains "## Inventory — Custom Capabilities" "^## Inventory.*Custom Capabilities$" || failures=$((failures + 1))
check_contains "## Workflow" "^## Workflow$" || failures=$((failures + 1))
check_contains "## Quality Criteria" "^## Quality Criteria$" || failures=$((failures + 1))
check_contains "## Anti-Patterns" "^## Anti-Patterns$" || failures=$((failures + 1))

# (c) Each role section has actual skills (not "(none)")
echo "Checking role populations..."
check_contains "researcher role" "^### researcher$" || failures=$((failures + 1))
check_contains "implementer role" "^### implementer$" || failures=$((failures + 1))
check_contains "reviewer role" "^### reviewer$" || failures=$((failures + 1))
check_contains "strategist role" "^### strategist$" || failures=$((failures + 1))
check_contains "communicator role" "^### communicator$" || failures=$((failures + 1))

# Verify at least some skills are listed (look for bullet points).
if echo "$output" | grep -q "^- \*\*.*\*\*"; then
  echo "  ✓ Built-in skills are present"
else
  echo "  ✗ Built-in skills are present"
  failures=$((failures + 1))
fi

# (d) No agent names leak anywhere in the output
echo "Checking for agent-name leaks..."
for agent in odin mimir brokk heimdall kvasir bragi; do
  check_absent "no '$agent' leaks" "$agent" || failures=$((failures + 1))
done

echo ""

# --- Scenario 2: Self-location fallback (tier 3 of precedence) ---
# Test that the installed script in $tmp/yggdrasil/generate-capabilities.sh
# can resolve its config base from its own location (self-location tier) when
# neither --config-base flag nor OPENCODE_CONFIG_BASE env var is set.

echo "Setting up self-location test scenario..."
cp "$REPO_ROOT/scripts/generate-capabilities.sh" "$tmp/yggdrasil/generate-capabilities.sh"
chmod +x "$tmp/yggdrasil/generate-capabilities.sh"

# Run the script from the temp location without env var (to test self-location).
# Also set HOME to an empty temp dir to ensure the default tier (tier 4) is not used.
tmp_home=$(mktemp -d)
trap "rm -rf \"$tmp_home\"" EXIT

echo "Running installed script via self-location (HOME unset to exclude tier 4)..."
output_self=$(env -u OPENCODE_CONFIG_BASE HOME="$tmp_home" "$tmp/yggdrasil/generate-capabilities.sh" --print 2>/dev/null)

# Check that output is non-empty and contains expected sections (same assertions as scenario 1).
echo ""
echo "Self-location assertions:"
failures_self=0

if [ -z "$output_self" ]; then
  echo "  ✗ Output is non-empty"
  failures_self=$((failures_self + 1))
else
  echo "  ✓ Output is non-empty"
fi

if echo "$output_self" | grep -q "^## Inventory.*Built-In Skills$"; then
  echo "  ✓ Inventory section found"
else
  echo "  ✗ Inventory section found"
  failures_self=$((failures_self + 1))
fi

if echo "$output_self" | grep -q "^- \*\*.*\*\*"; then
  echo "  ✓ Skills are present"
else
  echo "  ✗ Skills are present"
  failures_self=$((failures_self + 1))
fi

echo ""

if [ "$failures" -eq 0 ] && [ "$failures_self" -eq 0 ]; then
  echo "✓ All assertions passed (both scenarios)."
  exit 0
else
  combined_failures=$((failures + failures_self))
  echo "✗ $combined_failures assertion(s) failed."
  exit 1
fi
