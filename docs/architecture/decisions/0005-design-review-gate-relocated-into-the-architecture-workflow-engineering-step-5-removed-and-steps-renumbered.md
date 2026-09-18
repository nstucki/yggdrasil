# ADR-0005: Design review gate relocated into the Architecture workflow; engineering step 5 removed and steps renumbered

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
Settled: the gate lives in the new workflow and engineering step 5 goes. Remaining choices: how steps 1, 4, 9 change and whether to renumber. Goals: Doctrine Minimization, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Doctrine Min. | Backward Compat. |
| --- | --- | --- | --- | --- |
| A. Remove step 5, renumber 6–10 → 5–9, update the three internal cross-references; step 1 keeps only the ≥2-packages invariant; step 4 = caller contract; old step 9 references the callee's persistence step (step 7 after ADR-0011) | Clean, readable doctrine | One-time cross-reference churn (R-4) | + | + (behavior unchanged) |
| B. Leave "5. *(folded into step 4)*" tombstone | No renumbering | Permanent ceremony; reads as a gap | 0 | + |
| C. Keep engineering's own review in addition | Belt and braces | Double review; fails Doctrine Minimization and NF-3 | − | 0 |

## Decision
We use **A**. Edits as itemized in §5.1.6. The Review-skill assignment table's architecture row states the review occurs inside the Architecture workflow; the Purpose paragraph about "one review gate beyond the standing rules" moves to the new skill's Purpose.

## Consequences
- **Positive:** engineering architecture doctrine ≥50% smaller (Q-1); single review.
- **Negative:** step numbers in older transcripts/docs shift; README section for the engineering workflow needs a check.
- **Becomes harder:** reviewing the architecture with engineering-specific extras — none exist today.

## Related
AC-5, AC-8, AC-9, AC-10, AC-11, AC-12 · §5.1.6 · ADR-0003, ADR-0006, ADR-0010.
