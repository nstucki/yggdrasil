# ADR-0012: `mimir-codebase-context` split into `mimir-architecture-context` and `mimir-engineering-context`, one per family, discipline text duplicated

- **Status:** Accepted (user-directed, Revision 4)
- **Date:** 2026-09-19

## Context
The shipped `skills/architecture/mimir-codebase-context/SKILL.md` (145 lines) serves two consumers with one 12-step procedure and one 12-section contract: the Architecture workflow needs structure (steps 2, 3, 4, 6-as-concepts, 8, 9, 10) and the engineering workflow's TDD path needs behavior and tests (steps 3, 4, 5, 6-as-conventions, 7, 9). Every dispatch today pays for both halves — including an executed full-suite baseline on a document-existing run that will never write a test, and an arc42-shape inventory on an engineering run whose architecture step is delegated anyway. The user directs a split into two purpose-targeted skills. The design questions are the boundary, the naming, and where the shared discipline (Boundaries, proof rules, `[UNVERIFIED]`, self-validation — ~45 lines) lives. Constraints: `<agent>-<name>` slug convention; each mandatory skill self-contained (C-1); Mimir→Mimir references allowed (Check 5 self-reference); a shipped slug is being retired (R-17). Goals: Cost Proportionality, Clarity of Intent, Doctrine Minimization, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Cost Prop. | Clarity | Doctrine Min. | Backward Compat. |
| --- | --- | --- | --- | --- | --- | --- |
| A. Keep one skill; add a `Scope: architecture \| engineering` brief line selecting section subsets — **Rejected (user-directed)** | One file | Same mode-aware-single-skill pattern the user rejected twice (ADR-0010, ADR-0011 context); reviewer must branch | 0 | 0 | + | + |
| B. Two self-contained skills, discipline block duplicated verbatim; architecture one **renamed in place** (`mimir-architecture-context`), engineering one new (`mimir-engineering-context`) | Each file says exactly what its consumer reads; no runtime load between them; names state the family; matches the user's "two skills" | ~45 duplicated lines to keep in sync (Q-15); a shipped slug retires (cleanup, README, inventory) | + | + | 0 | 0 (rename ripples) |
| C. As B plus a third `mimir-context-convention` skill holding the discipline, loaded by both (precedent: `mimir-research-convention`) | No duplication | Three skills where two were asked for; a runtime skill load on every context dispatch; a placement question (which mandatory dir hosts a cross-family convention); more surface for the same behavior | 0 | + | + | 0 |
| D. As B but keep the old slug `mimir-codebase-context` for the architecture-scoped skill (content re-scoped only) | No rename, no cleanup | The name still promises behavior/tests it no longer delivers — the exact confusion the split removes; README/inventory descriptions would lie | + | − | 0 | + |

## Decision
We use **B**. Boundary (full statement in §5.1.8 and §5.1.12): **architecture** = scope · area map · entry points and call paths · **boundary** interfaces · cross-cutting concepts as embodied · existing architecture/decision-record *content* inventory (shape and `next-adr` remain the scaffold's authority) · dependencies · current-state view · not-examined; **engineering** = scope with touched-path list · entry points and call paths for touched paths · interfaces **under test** · current behavior · engineering conventions · test infrastructure with an **executed** baseline · test/runtime dependencies · not-examined. Common to both, duplicated verbatim: the Boundaries section, the proof/`[UNVERIFIED]`/≤ 25 % rules, the scope-declaration-first step, the self-validation step, the report skeleton. Names and locations: `skills/architecture/mimir-architecture-context/` (git rename of the shipped directory, then re-scope) and `skills/engineering/mimir-engineering-context/` (new). Option C is recorded as the natural follow-up if a third context consumer ever appears.

## Consequences
- **Positive:** a document-existing run no longer executes a test suite; an engineering run no longer inventories arc42 documents; each contract is short enough that its reviewer can check completeness item by item (ADR-0013); the skill names disambiguate at dispatch time.
- **Negative:** one duplicated discipline block (Q-15 guards drift); a retired slug requires a deployed-copy sweep under `architecture/` (R-17) and README/inventory updates; both workflow doctrine files change.
- **Becomes harder:** a single "tell me everything about this codebase" dispatch — a caller wanting both halves dispatches both skills.

## Related
AC-4, AC-7, AC-10 · §5.1.1 step 2, §5.1.6 step 4, §5.1.8, §5.1.9, §5.1.10, §5.1.12, §8.8 · ADR-0009, ADR-0013, ADR-0014, ADR-0015 · WP-R4-0 (rename + cleanup), WP-R4-1 (both skills).
