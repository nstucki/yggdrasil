#!/usr/bin/env bash
#
# ci-smoke-subagent-generator.sh — End-to-end smoke test for the subagent generator.
#
# This test validates that the generator works correctly: it regenerates all five
# subagent files and asserts they match the committed versions (byte-identical).
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

echo "Testing subagent generator..."
echo ""

# Run the generator into the temp directory
echo "Regenerating subagent files into temp directory..."
for agent in bragi brokk heimdall kvasir mimir; do
  "$REPO_ROOT/scripts/generate-subagents.sh" --agent "$agent" --print > "$tmp/$agent.md"
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
check_identical "bragi.md" "$REPO_ROOT/agents/bragi.md" "$tmp/bragi.md" || failures=$((failures + 1))
check_identical "brokk.md" "$REPO_ROOT/agents/brokk.md" "$tmp/brokk.md" || failures=$((failures + 1))
check_identical "heimdall.md" "$REPO_ROOT/agents/heimdall.md" "$tmp/heimdall.md" || failures=$((failures + 1))
check_identical "kvasir.md" "$REPO_ROOT/agents/kvasir.md" "$tmp/kvasir.md" || failures=$((failures + 1))
check_identical "mimir.md" "$REPO_ROOT/agents/mimir.md" "$tmp/mimir.md" || failures=$((failures + 1))

echo ""

if [ "$failures" -eq 0 ]; then
  echo "✅ All subagent files are byte-identical to regenerated output"
  exit 0
else
  echo "❌ $failures file(s) differ from regenerated output"
  exit 1
fi
