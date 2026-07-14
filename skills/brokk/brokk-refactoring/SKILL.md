---
name: brokk-refactoring
description: Improve code structure while preserving existing behavior.
---

# Refactoring

## Purpose

Improve the structure, readability, and maintainability of existing code without changing its observable behavior.

## When to Use

- When code is difficult to understand, modify, or extend.
- When preparing to add a feature to a complex or unmaintained area.
- When reducing duplication or simplifying overly complex logic.
- When structural issues have been identified that need improvement.

## Workflow

1. **Understand the existing behavior.**
   - Read and understand what the code does, including edge cases.
   - Identify existing tests or create characterization tests to capture current behavior.

2. **Identify what to improve.**
   - Look for code smells: duplication, long methods, deep nesting, poor naming.
   - Prioritize changes by impact and risk.
   - Plan the refactoring in small, reversible steps.

3. **Make targeted changes.**
   - Change one thing at a time — keep each commit or change focused.
   - Preserve existing interfaces and behavior.
   - Improve naming, extract methods, simplify conditionals, reduce duplication.

4. **Verify behavior is preserved.**
   - Run existing tests to confirm nothing is broken.
   - Add tests if coverage is missing.
   - Check edge cases and error paths.

5. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- All existing tests pass after the refactoring.
- The observable behavior is unchanged.
- Each change is small enough to be reviewed and understood.
- The code is measurably cleaner (less duplication, better naming, simpler structure).

## Anti-Patterns

- **Big bang refactoring**: Trying to rewrite everything at once instead of incremental changes.
- **Refactoring without tests**: Making structural changes without a safety net.
- **Gold-plating**: Over-engineering the solution beyond what is needed.
- **Changing behavior**: Fixing bugs or adding features during a refactoring (mix concerns).
