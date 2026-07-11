---
name: kvasir-risk-assessment
description: Identify, evaluate, and mitigate technical, operational, and strategic risks in proposed plans.
---

# Risk Assessment

## Purpose

Identify potential failure modes in a proposed plan or approach, evaluate their likelihood and impact, and recommend mitigation strategies. Ensure that risks are surfaced before execution begins, not discovered mid-flight.

## When to Use

- Before committing to an execution plan.
- When a task involves unfamiliar technology, breaking changes, or security-sensitive areas.
- When multiple approaches exist and risk is a deciding factor.
- When a plan has long dependency chains where early failures cascade.

## Workflow

1. **Enumerate risks.** Identify technical, operational, security, and strategic risks across the plan.
2. **Evaluate impact and likelihood.** Assess each risk's severity and probability.
3. **Identify cascade effects.** Determine which risks could block downstream subtasks.
4. **Recommend mitigations.** For each significant risk, propose a concrete mitigation or contingency.
5. **Prioritize.** Rank risks by combined impact and likelihood to guide attention.

## Quality Criteria

- Risks are specific and actionable, not vague.
- Each significant risk has a mitigation or contingency.
- Cascade effects on downstream work are identified.
- Risk prioritization is clear and justified.

## Anti-Patterns

- **Vague risks**: "This might break" without specifying what, how, or why.
- **No mitigations**: Listing risks without proposing how to handle them.
- **Ignoring cascades**: Failing to identify how a failure in one subtask affects others.
- **Paralysis**: Over-analyzing low-impact risks at the expense of progress.

## Related Skills

- `kvasir-task-decomposition` — for structuring plans that account for identified risks.
- `kvasir-approach-evaluation` — for comparing risk profiles across approaches.
