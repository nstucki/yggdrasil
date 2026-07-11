---
name: kvasir-task-decomposition
description: Break complex objectives into single-agent subtasks with explicit dependencies and execution order.
---

# Task Decomposition

## Purpose

Transform complex objectives into well-defined, single-agent subtasks with clear dependencies, inputs, and outputs. Ensure each subtask maps to exactly one agent with one deliverable.

## When to Use

- When a task spans multiple agents or requires multi-step orchestration.
- When dependencies between subtasks are non-trivial.
- When the execution order matters and blocking relationships exist.
- When a task is large enough that decomposition reduces risk and improves clarity.

## Workflow

1. **Analyze the objective.** Identify the end goal, constraints, and available agents.
2. **Identify atomic subtasks.** Break the objective into the smallest meaningful units of work that each produce a single deliverable.
3. **Map dependencies.** Determine which subtasks depend on outputs of others. Identify parallelizable work.
4. **Assign agents.** Map each subtask to the correct specialist agent based on task type.
5. **Define execution order.** Sequence subtasks respecting dependencies. Identify parallel opportunities.
6. **Document the plan.** Produce a clear decomposition with subtask IDs, descriptions, agent assignments, dependencies, and expected outputs.

## Quality Criteria

- Every subtask has a single deliverable and a single responsible agent.
- All dependencies are explicitly stated, not implied.
- Parallelizable subtasks are identified.
- The plan covers the full objective with no gaps.
- Each subtask is small enough to be unambiguous.

## Anti-Patterns

- **Mixed deliverables**: A subtask that asks one agent to both research and implement.
- **Implicit dependencies**: Assuming a subtask can start without checking its inputs are ready.
- **Over-decomposition**: Splitting work so finely that orchestration overhead exceeds the work itself.
- **Missing agent mapping**: A subtask without a clear agent assignment.

## Related Skills

- `kvasir-risk-assessment` — for evaluating risks in the decomposition plan.
- `kvasir-approach-evaluation` — for comparing decomposition strategies before committing.
