# ADR-0006: Decide-mode persistence inline when standalone, deferred to the caller inside a composite

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
Document mode always persists (settled). Decide mode standalone was an open question; inside engineering, ratification happens at the plan checkpoint *after* the architecture step, and persistence today rides the integration session so ADRs are promoted only once ratified. Goals: Reusability, Backward Compatibility, Cost Proportionality.

## Options Considered
| Option | Pros | Cons | Reusability | Backward Compat. | Cost Prop. |
| --- | --- | --- | --- | --- | --- |
| A. Standalone: ratification checkpoint then persist by default (user may decline); composite: `persistence=deferred`, caller runs the callee's persistence step (step 7) later | Standalone output survives the transient workspace; engineering timing unchanged | Two persistence timings to describe | + | + | + |
| B. Never persist decide-mode standalone | Cheapest | Decision lost when the workspace is cleaned; inconsistent with document mode | − | + | + |
| C. Always persist inline, also from engineering | One timing | Promotes ADRs before the engineering checkpoint ratifies them — breaks today's lifecycle | 0 | − | 0 |

## Decision
We use **A**. I-1 `persistence=inline | deferred`; `deferred` skips steps 6–8 (ratification, persistence, Response — numbering after ADR-0011's scaffold step) and returns `persisted=deferred`; the caller invokes callee step 7 with its own ratification record. Standalone, the user may decline at the checkpoint → `persisted=declined`, Artifact absent.

## Consequences
- **Positive:** engineering behavior identical; standalone decisions are durable by default.
- **Negative:** Fixed Deliverable carries a conditional clause.
- **Becomes harder:** none material.

## Related
AC-3, AC-5, AC-9, AC-18, AC-20 · §5.1.1 · ADR-0003, ADR-0005.
