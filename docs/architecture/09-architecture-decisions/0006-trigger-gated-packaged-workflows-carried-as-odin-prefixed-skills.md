# ADR-0006: Trigger-gated packaged workflows carried as Odin-prefixed skills

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:8-11, 114, 172-219`; `skills/architecture/odin-architecture-workflow/SKILL.md:1-12, 60-63`; `skills/research/odin-research-workflow/SKILL.md:1-53`; `commands/yggdrasil/research.md:1-13`)

## Context

Some multi-specialist patterns recur with fixed shape, fixed Deliverable, and fixed gates — research, architecture, engineering, deliberation. Composing them from the generic planning defaults each time would be slow and inconsistent, and the full mechanism is too long for Odin's shared body. The forces: goal 1 (fixed gates), goal 5 (workflows extendable without regenerating Odin), and the need for a composite caller to reuse a workflow through a contract.

## Decision

Each packaged workflow is split in two: invariant trigger rules and a one-line triggering verdict in Odin's shared body, and the full mechanism — dispatch sequence, constraints, cost model, Deliverable, return-line grammar — in a dedicated `odin-*` skill that Odin loads only on an `invoke` verdict. Commands set `command=yes`; explicit language sets `explicit-request=yes`; a named suggestion candidate is resolved by the Communication Policy. A packaged workflow records `Kvasir check: skip — packaged workflow`, states its own fixed Deliverable (`source=workflow-fixed`), and inherits the standing review rules. Workflows compose: Software Engineering delegates architecture to the Architecture workflow.

## Consequences

- **Positive:** Consistent shape and gates per workflow; workflow doctrine evolves in its skill without touching the agent files; a composite caller consumes a one-line result.
- **Negative:** Two places to keep aligned per workflow (trigger rules in Odin, mechanism in the skill); the trigger vocabulary must be kept disjoint across workflows (e.g., architecture-with-implementation-intent is routed to Engineering).
- **Becomes harder:** Ad-hoc variation of a workflow's steps at runtime.

## Related

§5.1.1, §5.1.3, §5.1.4, §5.2, §6.2, §8.5 · ADR-0001, ADR-0002, ADR-0007 · `agents/odin-autonomous.md:172-219`
