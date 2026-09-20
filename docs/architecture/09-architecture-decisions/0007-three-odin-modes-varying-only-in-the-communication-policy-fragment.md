# ADR-0007: Three Odin modes varying only in the Communication Policy fragment

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `scripts/README.md:9-16, 73`; `agents/odin-autonomous.md:2-3, 22, 176, 280-302`; `commands/yggdrasil/research.md:3`; context Workfile § Cross-cutting Concepts item 7)

## Context

Users differ in how much they want to steer: some want hands-off execution, some want to shape requirements first, some want to be involved in decisions. The forces: keeping the orchestration doctrine identical across all three (goal 3) so that review gates and workflow rules never vary by mode, while letting user-contact behavior vary.

## Decision

The system ships three Odin agents — Autonomous, Guided, Interactive — generated from one shared body plus one mode-specific Communication Policy fragment. The policy alone decides whether Odin asks or assumes, whether commands are routed to that mode, how each workflow's suggestion candidate and checkpoint behave, and which terminal escalation actions exist. Autonomous never asks, routes no commands, skips suggestion candidates, auto-proceeds at checkpoints, and escalates only via disclosed best-effort delivery or an explicit failure report. Commands name the mode they target in their `agent:` field. Validator Check 7 asserts the invariant orchestration markers are present in all three files.

## Consequences

- **Positive:** Exactly one axis of variation; review and workflow doctrine cannot diverge between modes; the mode is chosen once by agent selection.
- **Negative:** Every workflow that introduces a checkpoint or suggestion must add a threshold line to all three fragments.
- **Becomes harder:** Mode switching mid-task — the mode is the agent, so it is fixed for the session.

## Related

§5.1.1, §5.2, §8.7 · ADR-0004, ADR-0006 · `agents/odin-autonomous.md:280-302`
