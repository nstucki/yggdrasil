---
name: brokk-testing
description: Create and maintain automated tests for software quality and reliability.
---

# Testing

## Purpose

Create and maintain automated tests that verify correctness, prevent regressions, and give confidence in the codebase.

## When to Use

- Before or alongside implementing new features (test-driven or test-after).
- When fixing bugs — add a test that reproduces the bug before fixing.
- When refactoring — add characterization tests to capture existing behavior.
- When code is being modified that lacks test coverage.

## Workflow

1. **Analyze what to test.**
   - Identify the behavior to verify: happy path, error cases, edge cases, boundary conditions.
   - Determine the appropriate test level (unit, integration, end-to-end).
   - Consider what could break and write tests that guard against regressions.

2. **Structure the tests.**
   - Follow the project's test conventions (naming, file structure, helpers).
   - Use Arrange-Act-Assert or Given-When-Then patterns.
   - Keep tests independent — no shared mutable state.

3. **Write the tests.**
   - Test one behavior per test case.
   - Use descriptive names that explain the scenario and expected outcome.
   - Cover edge cases: empty inputs, null values, large data, concurrency.

4. **Run and verify.**
   - Run the full test suite to confirm nothing is broken.
   - Verify that tests are deterministic (same result every run).
   - Check that tests fail meaningfully when the code breaks.

5. **Maintain tests.**
   - Keep tests in sync with implementation changes.
   - Remove or update tests when behavior intentionally changes.
   - Flag flaky tests for investigation.

6. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- Tests are deterministic and isolated from each other.
- Each test verifies a single behavior or scenario.
- Tests fail with clear, descriptive messages.
- Coverage includes happy path, error cases, and edge cases.

## Anti-Patterns

- **Testing implementation details**: Writing tests that break when the code is refactored without changing behavior.
- **Over-mocking**: Mocking everything so the test doesn't actually test real interactions.
- **Coverage theater**: Aiming for a coverage percentage instead of meaningful assertions.
- **Flaky tests**: Tests that pass or fail nondeterministically, eroding trust in the suite.
