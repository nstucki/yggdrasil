---
name: kvasir-approach-evaluation
description: Compare multiple approaches to a problem, evaluating trade-offs, feasibility, and alignment with constraints.
---

# Approach Evaluation

## Purpose

Systematically compare multiple candidate approaches to a problem, evaluating each against trade-offs, feasibility, constraints, and project goals. Recommend the approach best suited to the situation.

## When to Use

- When multiple valid approaches exist and a decision must be made.
- When trade-offs between speed, quality, cost, or risk need to be weighed.
- When constraints (time, team skill, tooling, architecture) eliminate some approaches.
- Before committing to an implementation strategy.

## Workflow

1. **Enumerate approaches.** Identify all viable candidate approaches.
2. **Define evaluation criteria.** Establish the dimensions of comparison (e.g., effort, risk, maintainability, scalability, alignment with existing patterns).
3. **Score each approach.** Evaluate each candidate against the criteria.
4. **Identify trade-offs.** Make explicit what each approach gains and sacrifices.
5. **Recommend.** Select the approach best aligned with constraints and goals. Justify the recommendation.

## Quality Criteria

- All viable approaches are considered, not just the first that comes to mind.
- Evaluation criteria are explicit and relevant to the task.
- Trade-offs are concrete and specific.
- The recommendation is justified, not asserted.

## Anti-Patterns

- **False dichotomy**: Presenting only two options when more exist.
- **Criteria mismatch**: Evaluating against criteria irrelevant to the actual task.
- **Unjustified recommendation**: Picking an approach without explaining why.
- **Ignoring constraints**: Recommending an approach that violates known constraints.

## Related Skills

- `kvasir-task-decomposition` — for decomposing the chosen approach into subtasks.
- `kvasir-risk-assessment` — for evaluating risks in the recommended approach.
