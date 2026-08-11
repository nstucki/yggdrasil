---
name: mimir-diagnostic-analysis
description: Investigate errors, performance issues, and data patterns to diagnose problems and inform decisions.
---

# Diagnostic Analysis

## Purpose

Investigate errors, failures, performance issues, and data patterns to identify root causes, bottlenecks, and insights that inform decisions. This is an investigative skill: it examines the existing state before or independent of implementation, producing findings that inform decisions — validating that delivered changes address those findings is the concern of a subsequent review.

## When to Use

- When an error, crash, or unexpected behavior is reported (Debugging).
- When a test fails and the cause is not immediately obvious (Debugging).
- When investigating regression or flaky behavior (Debugging).
- When a system is slower than expected or has regressed (Performance).
- Before scaling or deploying to production (Performance).
- When designing new features that may have performance impact (Performance).
- When data-driven recommendations for optimization are needed (Performance).
- When investigating performance issues or system behavior (Data).
- When analyzing error logs or crash reports to find root causes (Data).
- When extracting usage patterns or trends from telemetry data (Data).
- When data-driven answers are needed rather than speculation (Data).

## Workflow

1. **Identify which sub-domain(s) the brief invokes; apply only those subsections.**

### Debugging

2. **Gather error information.**
   - Collect error messages, stack traces, logs, and reproduction steps.
   - Determine the environment, inputs, and conditions that trigger the issue.

3. **Trace execution paths.**
   - Follow the code path from entry point to failure point.
   - Identify the relevant components, data, and state involved.
   - Note any assumptions that may be violated.

4. **Compare expected and actual behavior.**
   - Determine what should have happened versus what actually happened.
   - Identify where the divergence occurs.
   - Check for recent changes that may have introduced the issue.

5. **Identify root causes.**
   - Distinguish between symptoms and underlying causes.
   - Consider multiple possible causes and rule them out systematically.
   - Identify contributing factors (environment, timing, data, concurrency).

6. **Suggest next steps.**
   - Recommend specific fixes or further investigation.
   - Note any additional data or tests that would help confirm the diagnosis.
   - Flag related areas that may be affected by the same root cause.

### Performance

7. **Establish baseline and performance expectations.**
   - Identify the critical paths and expected performance characteristics.
   - Define what "good enough" looks like (latency, throughput, resource usage).
   - Gather performance data: collect metrics, traces, logs, and profiling data.
   - Establish a baseline for comparison.
   - Note the environment and load conditions.

8. **Identify bottlenecks.**
   - Analyze where time is spent, resources are consumed, or contention occurs.
   - Look for common patterns: N+1 queries, memory leaks, CPU hotspots, I/O waits.
   - Distinguish between systemic issues and isolated incidents.

9. **Evaluate optimization trade-offs.**
   - Consider the cost, complexity, and risk of each potential improvement.
   - Estimate the expected impact and confidence level.
   - Identify quick wins versus deeper architectural changes.

10. **Recommend improvements.**
    - Present findings ranked by impact and effort.
    - Provide specific, actionable recommendations.
    - Suggest how to verify the improvement after implementation.

### Data

11. **Understand the question and gather data.**
    - What specific question or hypothesis is being investigated?
    - What data would provide the answer?
    - What is the expected baseline or normal behavior?
    - Identify relevant data sources (log files, metrics endpoints, databases, analytics).
    - Collect a representative sample or time range.
    - Note any data quality issues or gaps.

12. **Analyze the data.**
    - Look for patterns, anomalies, correlations, and trends.
    - Aggregate and summarize where appropriate (counts, rates, distributions).
    - Compare against expected baselines or historical data.

13. **Draw conclusions and report findings.**
    - Determine what the data indicates and with what level of confidence.
    - Identify actionable insights or recommendations.
    - Note any caveats, limitations, or confounding factors.
    - Present the analysis clearly: what was found, how it was found, and what it means.
    - Include relevant visualizations or summaries where helpful.

## Quality Criteria

- **Shared**: Conclusions are supported by evidence, not intuition or assumptions.
- The root cause is identified, not just the symptom (Debugging).
- Reproduction steps or conditions are documented (Debugging).
- The investigation is systematic, not anecdotal (Debugging).
- Recommendations are specific enough to act on (Debugging).
- Performance data is collected, not assumed (Performance).
- Bottlenecks are identified with supporting evidence (Performance).
- Recommendations are prioritized and include effort estimates (Performance).
- Trade-offs are stated — performance vs. complexity, cost, maintainability (Performance).
- The analysis answers the original question or explains why it cannot be answered (Data).
- Data sources and time ranges are documented (Data).
- Limitations and uncertainties are disclosed (Data).

## Anti-Patterns

- **Shared**: Applying subsections the brief does not invoke.
- **Surface-level fix**: Treating the symptom rather than finding the root cause (Debugging).
- **Confirmation bias**: Focusing on evidence that supports one theory while ignoring contradictory data (Debugging).
- **Shotgun debugging**: Making random changes to see if the problem goes away (Debugging).
- **Blame-shifting**: Attributing the issue to external factors without verification (Debugging).
- **Premature optimization**: Recommending optimizations without data (Performance).
- **Micro-benchmarking**: Optimizing isolated operations that don't matter in the overall system (Performance).
- **Ignoring the baseline**: Not knowing whether the system is actually slow before optimizing (Performance).
- **One-dimensional focus**: Only optimizing one metric (e.g., latency) while ignoring others (e.g., memory) (Performance).
- **Cherry-picking**: Selecting data that supports a desired conclusion while ignoring contrary data (Data).
- **Over-interpretation**: Drawing strong conclusions from insufficient or noisy data (Data).
- **Correlation as causation**: Assuming a relationship is causal without evidence (Data).
