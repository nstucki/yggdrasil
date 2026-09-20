# ADR-0001: Single orchestrator with hub-and-spoke dispatch to five role-bound specialists

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:4, 12-18, 26-44, 50-56`; `agents/mimir.md:6-68`; `agents/brokk.md:6-64, 84-91`; `scripts/README.md:71`)

## Context

The framework coordinates several AI agents on one user request. The forces the evidence shows: the user must have a single point of contact and a single Deliverable; specialist work must be kept inside role boundaries (goal 2); every specialist output must be reviewable by someone who did not produce it (goal 1); and the plan must be inspectable in one place. The host offers a `task` tool that any agent could in principle be granted.

## Decision

The system has exactly one primary agent, Odin (`mode: primary`), and five subagents (`mode: subagent`). Only Odin holds the `task` permission, restricted to the five specialists by name; no subagent frontmatter grants `task`, so specialists cannot dispatch one another. Odin plans, briefs, sequences, and evaluates but never performs specialist work, never reads artifact files, and never bypasses a specialist; specialists never communicate with the user and never reason about what the user should receive. Subagent isolation is additionally enforced statically: validator Check 5 fails if a subagent prompt or skill names another agent.

## Consequences

- **Positive:** One inspectable plan and one recorded verdict trail per task; role boundaries hold mechanically for dispatch; a specialist can be replaced or re-briefed without other specialists knowing.
- **Negative:** Every hop passes through Odin, so multi-step work costs one dispatch per step plus one per review (see the Research cost formula, `skills/research/odin-research-workflow/SKILL.md:37`); Odin's shared body is large (`agents/odin-autonomous.md`, 302 lines) because it carries all routing doctrine.
- **Becomes harder:** Direct specialist collaboration or peer review among specialists; any pattern that needs a subagent to spawn work.

## Related

§5.1.1, §5.1.2, §8.2 · ADR-0002, ADR-0003 · `agents/odin-autonomous.md:12-18`
