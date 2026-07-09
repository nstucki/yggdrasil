---
name: mimir-debugging-analysis
description: Investigate errors, failures, and unexpected system behavior to determine root causes.
---

# Debugging Analysis

## Purpose

Investigate errors, failures, and unexpected behavior to identify root causes and suggest remediation steps.

## When to Use

- When an error, crash, or unexpected behavior is reported.
- When a test fails and the cause is not immediately obvious.
- When investigating regression or flaky behavior.
- Before implementing a fix — to ensure the root cause is understood.

## Workflow

1. **Gather error information.**
   - Collect error messages, stack traces, logs, and reproduction steps.
   - Determine the environment, inputs, and conditions that trigger the issue.

2. **Trace execution paths.**
   - Follow the code path from entry point to failure point.
   - Identify the relevant components, data, and state involved.
   - Note any assumptions that may be violated.

3. **Compare expected and actual behavior.**
   - Determine what should have happened versus what actually happened.
   - Identify where the divergence occurs.
   - Check for recent changes that may have introduced the issue.

4. **Identify root causes.**
   - Distinguish between symptoms and underlying causes.
   - Consider multiple possible causes and rule them out systematically.
   - Identify contributing factors (environment, timing, data, concurrency).

5. **Suggest next steps.**
   - Recommend specific fixes or further investigation.
   - Note any additional data or tests that would help confirm the diagnosis.
   - Flag related areas that may be affected by the same root cause.

## Quality Criteria

- The root cause is identified, not just the symptom.
- Reproduction steps or conditions are documented.
- The investigation is systematic, not anecdotal.
- Recommendations are specific enough to act on.

## Anti-Patterns

- **Surface-level fix**: Treating the symptom rather than finding the root cause.
- **Confirmation bias**: Focusing on evidence that supports one theory while ignoring contradictory data.
- **Shotgun debugging**: Making random changes to see if the problem goes away.
- **Blame-shifting**: Attributing the issue to external factors without verification.

## Related Skills

- `mimir-codebase-exploration` — for understanding the relevant code paths
- `mimir-data-analysis` — for analyzing logs and telemetry during investigation
- `mimir-performance-analysis` — when the error is related to performance or resource exhaustion
- `mimir-web-research` — for searching solutions to known error patterns