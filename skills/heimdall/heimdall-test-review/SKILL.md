---
name: heimdall-test-review
description: Review test quality, coverage adequacy, and testing strategy.
---

# Test Review

## Purpose

Evaluate the quality and effectiveness of tests — not just whether they pass, but whether they actually validate correctness, cover edge cases, and are maintainable.

## When to Use

- When reviewing a new test suite or significant test additions.
- When evaluating whether existing tests provide adequate coverage.
- When assessing test maintainability and strategy.
- When validating that tests properly cover a recent implementation.

## Workflow

1. Understand the testing context.
   - Identify what functionality the tests are meant to verify.
   - Determine the testing strategy (unit, integration, end-to-end).
   - Review the test framework and tooling choices.
2. Evaluate coverage adequacy.
   - Identify which code paths are tested and which are not.
   - Check for edge case coverage: boundary values, empty inputs, error paths.
   - Flag critical paths that lack test coverage.
3. Assess test quality.
   - Check that tests verify behavior, not implementation details.
   - Identify flaky tests or tests with hidden dependencies.
   - Look for over-mocking that makes tests tautological.
   - Evaluate assertion quality — are they specific enough to catch regressions?
4. Review maintainability.
   - Check for test duplication and excessive setup boilerplate.
   - Assess naming clarity and test organization.
   - Identify tests that would break on harmless refactors.
5. Report findings.
   - List coverage gaps by severity.
   - Identify tests that need rewriting or removal.
   - Recommend specific improvements to test strategy.

## Quality Criteria

- Coverage assessment includes edge cases and error paths, not just happy paths.
- Tests are evaluated for whether they catch real regressions, not just pass.
- Flaky or fragile tests are identified.
- Recommendations are specific and prioritized.

## Anti-Patterns

- **Coverage theater**: Measuring line coverage without assessing whether tests assert meaningful behavior.
- **Over-mocking**: Mocking so much that tests verify mocks, not real behavior.
- **Happy-path bias**: Testing only the expected flow, ignoring error and edge cases.
- **Implementation coupling**: Tests so tied to implementation details that they break on harmless refactors.

## Related Skills

- `heimdall-code-review` — for reviewing the implementation code being tested.
