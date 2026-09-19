# ADR-0020: Scaffolder and persister stay distinct Brokk skills sharing a verbatim-duplicated layout spec; persistence fills only a scaffolded structure under a status invariant

- **Status:** Accepted (Revision 5)
- **Date:** 2026-09-19

## Context
Both Brokk skills now write to the target project and both need the layout specification. Merging them is tempting; so is having one load the other by name (Brokk→Brokk is allowed under Check 5). The persistence skill is the layout's "single source of truth" today; `brokk-arc42-template` carries a 600-line CC BY-SA skeleton the persister does not need in its session. Separately: does scaffolding collapse seed vs update delta? Goals: Doctrine Minimization, Cost Proportionality, Clarity of Intent, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Doctrine Min. | Cost Prop. | Clarity | Backward Compat. |
| --- | --- | --- | --- | --- | --- | --- |
| A. Merge into one `brokk-architecture-…` skill with a `Phase: scaffold \| persist` line | One layout copy | The mode-aware-single-skill pattern the user rejected in ADR-0010/0011/0012; the CC BY-SA skeleton loaded on every persistence; two lifecycle moments with different inputs in one Workflow | + | − | − | − (rename) |
| B. Distinct skills; the scaffolder **loads** the persistence skill by name for the layout (or vice versa) | One copy | A runtime skill load on every scaffold; the persister's merge mechanics or the scaffolder's skeleton loaded where not needed | + | − | 0 | + |
| C. **Distinct skills; the compact layout spec (§5.1.13, ~40 lines) duplicated verbatim in both, normative copy in the persistence skill, guarded by Q-23; persistence requires a pre-scaffolded target and the status invariant; seed vs update delta remains a content distinction** | Each dispatch single-load and self-contained; precedent ADR-0012; the scaffold/fill boundary is enforceable (status invariant) | One duplicated block to keep in sync | 0 | + | + | + |

## Decision
We use **C**. `brokk-arc42-template` = scaffolder (creates/verifies/extends structure, classifies, resolves `next-adr`); `brokk-architecture-persistence` = persister (fills per Appendix D, regenerates indices, promotes status, migrates on direction). Both carry § The Persisted Layout verbatim. **Seed vs update delta does not collapse**: it still decides whether all sections or only `included=` ones are written and whether §9 is created or appended — but *structure creation* leaves persistence entirely; persistence verifies the scaffold's identity rule and the status invariant (`Scaffolded` ⇔ seed, `Accepted` ⇔ update delta) and refuses otherwise. The seed-collision rule moves to the scaffolder.

## Consequences
- **Positive:** the header-driven seed-overwrite hazard Heimdall found in R4 (`Document scope: seed` on an existing target) is structurally closed — persistence cannot create, and a `seed` header against an `Accepted` target is refused; each Brokk session loads one skill.
- **Negative:** ~40 duplicated lines (Q-23); the persistence skill's Purpose ("single source of truth") now names its mirror.
- **Becomes harder:** changing the layout — two files, but a copy, not a re-derivation.

## Related
AC-5, AC-18 · §5.1.7, §5.1.11, §5.1.13, §8.3 · ADR-0016, ADR-0018 · WP-R5-1, WP-R5-2.
