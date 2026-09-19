# ADR-0015: Engineering context step runs after the architecture delegation, scoped to the ratified write sets, with behavior/test-infrastructure firing criteria only

- **Status:** Accepted (Revision 4; the "not before business analysis" constraint is user-directed, C-13)
- **Date:** 2026-09-19

## Context
The delivered engineering workflow runs its context gate second, before business analysis and architecture, because one shared Workfile had to feed all three. C-13 settles that it need not precede analysis; ADR-0012 makes its output engineering-only; ADR-0014 removes its role as the architecture gate's skip. Its remaining consumers are the TDD plan (test command, baseline, packages' test seams) and the implementation sessions. Its old firing criteria (live line 42) include two triggers that now belong to the Architecture workflow ("structure … not established"; "the architecture step fires on a brownfield codebase (err toward context)"). Goals: Cost Proportionality, Clarity of Intent, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Cost Prop. | Clarity | Backward Compat. |
| --- | --- | --- | --- | --- | --- |
| A. After business analysis, before the architecture delegation (step 3) | Earliest legal position under C-13; ACs available for scoping | Runs before the architecture document exists, so it cannot scope to write sets and may investigate paths the design later leaves untouched; Kvasir would receive a Workfile it does not consume | 0 | 0 | + |
| B. **After the architecture delegation, immediately before the TDD plan (step 4)** | Scopes to Appendix B write sets and consumed contracts when architecture fired — exactly the paths TDD touches; first consumer (TDD plan) is the very next step; the plan checkpoint sees behavior/AC contradictions before implementation | The shape verdict's `context=` is recorded at step 1 but executed three steps later — the reason may need refinement at step 4 | + | + | + |
| C. Fold it into each TDD package session (Brokk gathers its own facts) | No separate dispatch | Baseline executed N times; behavior facts never reviewed as a unit; violates the "establish the test infrastructure once" rationale the delivered skill states | − | − | − |

## Decision
We use **B**. Order: 1 shape → 2 analysis → 3 architecture → **4 engineering context** → 5 TDD plan → 6 checkpoint → 7 TDD → 8 integration → 9 Response. Firing criteria (replacing live line 42): fires when ANY — the objective changes behavior whose current form must be characterized before it is altered; the test infrastructure for the affected area is not established and a TDD session will need it; the engineering conventions the new code sits beside are not established. Skip when greenfield, when the change is localized to files in view and the test command is known, or when the user supplied behavior and test facts. The two structural triggers are dropped. Scope at dispatch: Appendix B write sets + consumed contracts + owned ACs when architecture fired; else the objective's touched paths. The step-1 verdict may be amended at step 4 with a stated reason (recorded, visible at the checkpoint).

## Consequences
- **Positive:** the engineering-context investigation is bounded by the ratified design; business analysis proceeds from the objective as directed; no Workfile is produced for a consumer that will not read it.
- **Negative:** acceptance criteria are written without behavior facts (R-18); a verdict field recorded at step 1 executes at step 4.
- **Becomes harder:** using current-behavior facts to *shape* acceptance criteria — by user direction, that is not this step's job.

## Related
AC-8, AC-10, AC-19 · §5.1.6, §5.1.12, §6.2, §8.8 · ADR-0012, ADR-0014 · C-13 · WP-R4-3.
