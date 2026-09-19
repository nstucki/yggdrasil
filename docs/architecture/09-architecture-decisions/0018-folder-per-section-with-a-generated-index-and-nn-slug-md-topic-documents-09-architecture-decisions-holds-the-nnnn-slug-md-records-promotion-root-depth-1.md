# ADR-0018: Folder per section with a generated index and `NN-<slug>.md` topic documents; `09-architecture-decisions/` holds the `NNNN-<slug>.md` records; promotion = root depth − 1

- **Status:** Accepted (Revision 5, user-directed layout)
- **Date:** 2026-09-19

## Context
The delivered layout is flat (twelve `NN-<section>.md` + `decisions/NNNN-<slug>.md` + `README.md`) and forbids splitting a section ("subsections stay inside their section file"). The user directs that every section follow the `decisions/` pattern — a folder that may hold several per-topic documents (a concept, a scenario, a building-block group). Open sub-questions: naming, one-vs-many rule, index structure, omission representation, promotion mechanics, and whether `decisions/` is renamed. Constraints: C-17; the persistence rules "append-only §9, never delete, whole-file replacement per unit"; the reviewer must be able to check completeness by listing. Goals: Clarity of Intent, Doctrine Minimization, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Clarity | Doctrine Min. | Backward Compat. |
| --- | --- | --- | --- | --- | --- |
| A. Flat layout (status quo) — **Rejected (user-directed)** | Simple; shipped | Monolithic §5/§8 files; §9 a special case | 0 | 0 | + |
| B. Folders only for sections that split; single-document sections stay flat files | Fewer folders | Two shapes in one directory; identity rule and index generation branch on it; a later split moves a file | − | − | 0 |
| C. **Uniform folder per section; generated `README.md` index per folder; topic documents `NN-<slug>.md` (two-digit ordinals, folder-local); `09-architecture-decisions/` holds `NNNN-<slug>.md` records (four-digit, global, append-only) and its index is the log; omitted section = index-only folder; promotion = root depth − 1** | One rule for twelve sections; §9 stops being special; identity rule is `README.md` + `01-introduction-and-goals/README.md`; listing-checkable; git-tracked | Deeper tree; index regeneration per touched section; a migration for existing flat documents | + | + | 0 |
| D. As C but topic documents also `NNNN-<slug>.md` | Visually uniform with records | Implies a global identity/sequence that topic documents do not have — they are folder-local ordering units that a later delta may re-split, whereas records are never renumbered; the width difference signals the lifecycle difference | 0 | 0 | 0 |
| E. As C but keep `decisions/` as the folder name | No rename of a shipped folder | §9 remains the one section whose folder does not match its number; two naming rules | − | − | + |

## Decision
We use **C** (rejecting D's uniform width and E's exception). Specification in §5.1.13: fixed folder table; topic naming and slug rule; single-document default `01-<section-slug>.md`; per-document format with uniform promotion; section-index and top-index formats (top index gains `Mode`, a `Docs` column, and the `Scaffolded` status); identity rules for `directory`, `flat directory (legacy)`, `legacy single file`, `non-arc42`, `none`; status invariant; no guidance text under the target. The **one-vs-many rule** is Kvasir's (ADR-0019): split only at three or more independently consulted units. **Persistence never deletes a topic document**; a re-split lists the superseded file in the section index. Records keep their directory-precedence rule (a project's own `docs/adr/` still wins).

## Consequences
- **Positive:** a reader lands on one concept or one scenario; §5 of a large system becomes navigable; the decision log is the §9 index like every other section's; completeness is a folder listing.
- **Negative:** more files and generated indices; the existing flat document needs migration to benefit (D-1); Brokk's index regeneration touches one more file per delta.
- **Becomes harder:** reading a whole section top to bottom — the section index is the reading order.

## Related
AC-5, AC-18 · §5.1.7, §5.1.11, §5.1.13, §8.9 · ADR-0016, ADR-0019, ADR-0020 · D-1 · WP-R5-1, WP-R5-2, WP-R5-5.
