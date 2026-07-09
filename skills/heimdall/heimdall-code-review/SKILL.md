---
name: heimdall-code-review
description: Review code changes and verify implementations for correctness, requirements fulfillment, and quality.
---

# Code Review

## Purpose

Evaluate code changes independently and ensure delivered work meets expectations.

## When to Use

- When an independent assessment of correctness and quality is needed.
- When requirements fulfillment needs to be validated against implementation.
- When the implementation involves complex logic, error handling, or state management.
- When changes touch critical paths, security boundaries, or public APIs.

## Workflow

1. **Understand the requirements.**
   - Review what the change was meant to accomplish.
   - Identify the acceptance criteria and expected behavior.

2. **Inspect the implementation.**
   - Read the modified or created files.
   - Trace the logic and verify it aligns with requirements.
   - Check for edge cases that are or are not handled.

3. **Evaluate quality.**
   - Assess readability, maintainability, and adherence to project conventions.
   - Identify bugs, potential issues, and code smells.
   - Check for missing functionality or incomplete work.

4. **Document findings.**
   - List issues found, categorized by severity (blocking, major, minor).
   - Provide actionable feedback — what to fix and how.
   - Highlight what was done well.

## Quality Criteria

- Every requirement has been traced to an implementation and verified.
- All identified issues are documented with clear reproduction or explanation.
- Feedback is actionable — the implementer knows exactly what to change.
- The review covers correctness, not just style.

## Anti-Patterns

- **Rubber-stamping**: Approving without thorough inspection.
- **Nitpicking only**: Focusing on trivial style issues while missing functional problems.
- **Assuming correctness**: Not verifying that the code actually runs or behaves as expected.
- **Insufficient depth**: Skipping deeper analysis when the change is complex or critical.

## Related Skills

- `heimdall-architecture-review` — when the change affects system structure
- `heimdall-documentation-review` — when documentation accompanies the code changes
- `heimdall-performance-review` — when performance impact is a concern
- `heimdall-security-review` — when security-sensitive code is involved
- `heimdall-test-review` — for reviewing test quality alongside implementation