# ADR-0003: Composite invocation by skill load with a one-line caller contract and return block

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
The engineering workflow must "delegate instead of duplicating." Odin cannot dispatch Odin (capability inventory: specialists only), so delegation must be an in-session mechanism. Goals: Doctrine Minimization, Reusability, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Doctrine Min. | Reusability | Backward Compat. |
| --- | --- | --- | --- | --- | --- |
| A. Load `odin-architecture-workflow` as a sub-procedure; couple only via `Architecture request:` / `Architecture result:` lines | Zero duplicated steps; auditable coupling; same session state | Relies on faithful nested execution (R-6) | + | + | + |
| B. Engineering references the callee's steps by number ("do steps 3–4 of …") without a contract | Short | Brittle to renumbering; inputs/outputs implicit | 0 | − | 0 |
| C. Keep inline steps, add a "see also" | No behavior change | Duplication remains — fails the objective | − | − | + |

## Decision
We use **A**. Contract I-1 and return block I-3 as specified in §5.1.1; the callee records skipped steps in its own shape verdict; the caller's Quality Criteria require the return block before forming the TDD plan.

## Consequences
- **Positive:** one owner of doctrine; both paths measurably identical (Q-4).
- **Negative:** a second verdict line in engineering transcripts.
- **Becomes harder:** changing I-1/I-3 fields requires touching both skills.

## Related
AC-8, AC-9, AC-19, AC-20 · §5.1.1, §5.1.6 · ADR-0004, ADR-0005, ADR-0006.
