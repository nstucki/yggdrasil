# ADR-0013: `Focus: context` split by family: `heimdall-architecture-review` gains it for the architecture shape; `heimdall-engineering-review` keeps it for the engineering shape only

- **Status:** Accepted (Revision 4)
- **Date:** 2026-09-19

## Context
`heimdall-engineering-review` § Focus: context (live lines 69–81) checks completeness against the single 12-part contract and BLOCKs on missing test-infrastructure facts for any code-touching objective (C-15). After ADR-0012 the architecture-context Workfile has no test-infrastructure section by design, so the unchanged checklist would BLOCK every architecture-context review; conversely, "documentation facts resolve" has no object in an engineering-context Workfile. Both workflows currently name `heimdall-engineering-review` for this review; the Architecture workflow's only remaining dependency on an `engineering/` skill is exactly this dispatch (live `odin-architecture-workflow/SKILL.md:19, 88, 134`). ADR-0010 already established that architecture-family artifacts are reviewed by the architecture review skill. Goals: Doctrine Minimization, Reusability, Clarity of Intent, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Doctrine Min. | Reusability | Clarity | Backward Compat. |
| --- | --- | --- | --- | --- | --- | --- |
| A. One `Focus: context` in `heimdall-engineering-review`, made shape-aware by reading the producing skill's name from the brief | One checklist location | The mode-aware-single-skill pattern the user rejected in ADR-0010; the Architecture workflow keeps a cross-family review dependency; two BLOCKED rule sets in one section | 0 | − | 0 | + |
| B. `heimdall-architecture-review` gains `Focus: context` (architecture shape, §5.1.5); `heimdall-engineering-review` `Focus: context` narrowed to the engineering shape; each workflow dispatches its own family's reviewer | Mirrors ADR-0010 exactly; the Architecture workflow becomes self-contained within `architecture/`; each checklist is short and unconditional | Verdict grammar of the architecture skill gains a fourth value; two files edited; two review Workfile names | + | + | + | 0 |
| C. A new dedicated `heimdall-context-review` skill with both shapes | Symmetric to the Mimir split | Third review skill; it would itself branch on shape (the rejected pattern) and needs a placement decision | − | 0 | 0 | 0 |

## Decision
We use **B**. `heimdall-architecture-review` accepts `Focus: context | scaffold | document | persistence`; its `Focus: context` items are in §5.1.5, including the cross-check that the documentation inventory agrees with the scaffold's `Scaffold result` when both exist. `heimdall-engineering-review` § Focus: context lists the engineering-context contract, keeps "run the recorded test command" and the test-infrastructure BLOCKED rule, drops the documentation item, and gains a `Not for` line. Review Workfile names: `NN-review-context-architecture-<area>.md` / `NN-review-context-engineering-<area>.md`. `odin-architecture-workflow` drops `heimdall-engineering-review` from its Purpose enumeration and step 2.

## Consequences
- **Positive:** each family's review skill owns every checklist for that family's artifacts; the Architecture workflow references no `engineering/` skill at all; each `Focus: context` is unconditional.
- **Negative:** the architecture review skill's verdict grammar changes (a fourth `focus=` value); one more review Workfile name in NF-8's family.
- **Becomes harder:** nothing material.

## Related
AC-11, AC-14 · §5.1.1 step 2, §5.1.5, §5.1.6 step 4 · ADR-0010, ADR-0012 · WP-R4-2.
