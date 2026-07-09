---
name: mimir-performance-analysis
description: Identify performance bottlenecks, inefficiencies, and optimization opportunities.
---

# Performance Analysis

## Purpose

Analyze systems for performance issues, identify bottlenecks, and recommend measurable improvements.

## When to Use

- When a system is slower than expected or has regressed.
- Before scaling or deploying to production.
- When designing new features that may have performance impact.
- When data-driven recommendations for optimization are needed.

## Workflow

1. **Understand the system and performance expectations.**
   - Identify the critical paths and expected performance characteristics.
   - Define what "good enough" looks like (latency, throughput, resource usage).

2. **Gather performance data.**
   - Collect metrics, traces, logs, and profiling data.
   - Establish a baseline for comparison.
   - Note the environment and load conditions.

3. **Identify bottlenecks.**
   - Analyze where time is spent, resources are consumed, or contention occurs.
   - Look for common patterns: N+1 queries, memory leaks, CPU hotspots, I/O waits.
   - Distinguish between systemic issues and isolated incidents.

4. **Evaluate optimization trade-offs.**
   - Consider the cost, complexity, and risk of each potential improvement.
   - Estimate the expected impact and confidence level.
   - Identify quick wins versus deeper architectural changes.

5. **Recommend improvements.**
   - Present findings ranked by impact and effort.
   - Provide specific, actionable recommendations.
   - Suggest how to verify the improvement after implementation.

## Quality Criteria

- Performance data is collected, not assumed.
- Bottlenecks are identified with supporting evidence.
- Recommendations are prioritized and include effort estimates.
- Trade-offs are stated (performance vs. complexity, cost, maintainability).

## Anti-Patterns

- **Premature optimization**: Recommending optimizations without data.
- **Micro-benchmarking**: Optimizing isolated operations that don't matter in the overall system.
- **Ignoring the baseline**: Not knowing whether the system is actually slow before optimizing.
- **One-dimensional focus**: Only optimizing one metric (e.g., latency) while ignoring others (e.g., memory).

## Related Skills

- `mimir-codebase-exploration` — for understanding the code paths involved
- `mimir-data-analysis` — for deeper analysis of performance metrics and logs
- `mimir-debugging-analysis` — when performance issues are causing errors or timeouts