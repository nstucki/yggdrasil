---
name: heimdall-architecture-review
description: Evaluate architectural decisions for quality, scalability, and maintainability.
---

# Architecture Review

## Purpose

Independently evaluate architectural decisions and system designs to identify risks, assess trade-offs, and ensure long-term quality.

## When to Use

- Before implementing a significant new feature or system.
- When reviewing proposed architectural changes.
- After a system design document or ADR has been drafted.
- When an independent assessment of architectural risks is needed.

## Workflow

1. **Understand the context and requirements.**
   - Review the goals, constraints, and success criteria.
   - Understand the existing architecture and how the change fits.

2. **Evaluate the proposed structure.**
   - Assess component boundaries, responsibilities, and coupling.
   - Verify that the design follows appropriate architectural patterns.
   - Check for consistency with the existing system's conventions.

3. **Identify risks and trade-offs.**
   - Evaluate scalability, maintainability, and extensibility.
   - Identify potential failure modes and single points of failure.
   - Assess operational complexity and deployment implications.

4. **Challenge assumptions.**
   - Identify unstated assumptions or hidden constraints.
   - Question whether the design solves the right problem.
   - Consider alternative approaches and why they were rejected.

5. **Document findings.**
   - Summarize the architecture and key decisions.
   - List risks by severity and provide recommendations.
   - Note areas where additional analysis is needed.

## Quality Criteria

- Architecture decisions are explicitly evaluated, not just described.
- Risks are identified with specific scenarios, not general concerns.
- Trade-offs are acknowledged, not glossed over.
- Recommendations are actionable and prioritized.

## Anti-Patterns

- **Rubber-stamping**: Approving an architecture without critical evaluation.
- **Ivory tower design**: Evaluating without considering practical implementation constraints.
- **Analysis paralysis**: Demanding perfect architecture instead of good-enough-for-now.
- **One-size-fits-all**: Applying the same patterns regardless of context.

## Related Skills

- `heimdall-api-contract-review` — when the architecture includes API boundaries
- `heimdall-code-review` — for reviewing the implementation of the architecture
- `heimdall-performance-review` — when performance is a key architectural concern
- `heimdall-security-review` — when security architecture needs evaluation
