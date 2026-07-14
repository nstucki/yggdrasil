---
name: heimdall-performance-review
description: Review implementations for efficiency, scalability, and resource usage.
---

# Performance Review

## Purpose

Independently review implementations for performance characteristics, identify inefficient patterns, and verify that performance requirements are met. This is a validation skill: it reviews delivered work and changes against performance requirements and prior analysis findings — open-ended bottleneck investigation of a running system belongs to a prior performance analysis.

## When to Use

- Before deploying code that handles significant load or data volume.
- When reviewing changes to critical paths, database queries, or network calls.
- After a prior performance analysis, to validate that identified bottlenecks were addressed in the implementation.
- To confirm performance requirements are satisfied before sign-off.

## Workflow

1. **Understand performance requirements.**
   - Review expected load, latency targets, and resource constraints.
   - Identify performance-critical code paths and data flows.

2. **Review resource usage patterns.**
   - Analyze algorithms for time and space complexity.
   - Check for inefficient data structures, unnecessary allocations, or repeated work.
   - Review database queries for missing indexes, N+1 patterns, or inefficient joins.

3. **Evaluate concurrency and scaling.**
   - Review locking, contention points, and parallelism strategies.
   - Check for thread safety, connection pooling, and resource limits.
   - Assess how the system behaves under load.

4. **Identify optimization opportunities.**
   - Detect patterns that are known to cause performance issues (caching misses, large payloads, synchronous blocking).
   - Suggest improvements with expected impact estimates.
   - Distinguish between quick wins and deeper architectural changes.

5. **Document findings.**
   - Report issues by impact severity.
   - Provide specific, testable recommendations.
   - Flag areas where performance profiling or load testing is needed.

## Quality Criteria

- Performance concerns are backed by evidence (metrics, profiling, reasoning), not intuition.
- Recommendations include expected impact, not just "this should be faster."
- Trade-offs between performance and other qualities (readability, maintainability) are acknowledged.
- Critical paths are reviewed, not just hot spots.

## Anti-Patterns

- **Premature criticism**: Flagging performance concerns without understanding the actual usage patterns.
- **Micro-optimization focus**: Worrying about minor inefficiencies while ignoring systemic issues.
- **Ignoring the bottleneck principle**: Optimizing parts of the system that aren't the bottleneck.
- **One-dimensional metrics**: Focusing on a single metric without considering overall system behavior.
