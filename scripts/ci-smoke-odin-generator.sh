#!/usr/bin/env bash
#
# ci-smoke-odin-generator.sh — End-to-end smoke test for the Odin agent generator.
#
# This test validates that the generator works correctly: it regenerates all three
# Odin agent files and asserts they match the committed versions (byte-identical).
#
# This test is OUTSIDE validate.sh to preserve validate.sh's read-only/no-temp-files
# guarantee. Run it as part of CI or pre-commit checks to catch real generator issues.

set -euo pipefail

# Resolve script directory and repo root
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

# Create a temp directory and set up a cleanup trap
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Testing Odin agent generator..."
echo ""

# Run the generator into the temp directory
echo "Regenerating Odin agents into temp directory..."
for mode in autonomous guided interactive; do
  "$REPO_ROOT/scripts/generate-odin-agents.sh" --mode "$mode" --print > "$tmp/odin-$mode.md"
done

echo "Temp files generated."
echo ""

# Helper function to check if two files are identical
check_identical() {
  local name="$1"
  local committed="$2"
  local generated="$3"
  
  if diff -q "$committed" "$generated" >/dev/null 2>&1; then
    echo "  ✓ $name (byte-identical)"
    return 0
  else
    echo "  ✗ $name (differs from committed)"
    echo "    Diff:"
    diff -u "$committed" "$generated" | head -20 | sed 's/^/      /'
    return 1
  fi
}

echo "Assertions:"
failures=0

# Check each file
check_identical "odin-autonomous.md" "$REPO_ROOT/agents/odin-autonomous.md" "$tmp/odin-autonomous.md" || failures=$((failures + 1))
check_identical "odin-guided.md" "$REPO_ROOT/agents/odin-guided.md" "$tmp/odin-guided.md" || failures=$((failures + 1))
check_identical "odin-interactive.md" "$REPO_ROOT/agents/odin-interactive.md" "$tmp/odin-interactive.md" || failures=$((failures + 1))

echo ""

if [ "$failures" -eq 0 ]; then
  echo "✅ All Odin agents are byte-identical to regenerated output"
  exit 0
else
  echo "❌ $failures file(s) differ from regenerated output"
  exit 1
fi
