# ADR-0019: Kvasir keeps one Workfile and adds an Appendix D layout map under a three-unit split rule; persistence is map-driven

- **Status:** Accepted (Revision 5)
- **Date:** 2026-09-19

## Context
The scaffold gives Kvasir the shape (folders exist) but not the topic documents — those are drafting judgment. Persistence must be "a mechanical copy-in rather than requiring Brokk to re-derive shape." Kvasir's reasoning (quality goals driving §4/§9/§10, one ADR set, one traceability table) and Heimdall's `Focus: document` both operate on one document today. Goals: Clarity of Intent, Doctrine Minimization, Reusability.

## Options Considered
| Option | Pros | Cons | Clarity | Doctrine Min. | Reusability |
| --- | --- | --- | --- | --- | --- |
| A. One Workfile per topic document, in a workspace tree mirroring the target (`NN-architecture/05-…/01-….md`) | Most literal mirror; persistence = copy | Fragments the single reasoning document; the ADR appendix, §9 log, and traceability span files; `Focus: document` becomes a multi-file review; cross-references break during drafting | 0 | − | − |
| B. **One Workfile as today plus Appendix D — `Workfile heading → target path → promotion`, one row per heading, decided by Kvasir under the split rule; persistence follows the map; `Focus: document` checks totality, conformance, and the rule** | One reviewable document; the split is an explicit, reviewable decision; persistence needs no judgment; the Workfile's headings *are* the shape, the map is its projection | The map must be kept total when sections are re-drafted; a new appendix to check | + | + | + |
| C. Persistence decides the split (e.g., one document per `###`) | No new appendix | Structural judgment in a mechanical step; "split by habit" everywhere; unreviewable before persistence | − | 0 | 0 |

## Decision
We use **B**. Appendix D format: `| Workfile heading | Target path | Promotion |`; a row maps one heading and its un-mapped descendants (never a group of siblings — one root, one H1); every heading below a `## N.` is covered exactly once, by its own row or its nearest mapped ancestor; omitted-only subsections in split sections map to `→ index (omitted)`; records map to `09-architecture-decisions/NNNN-<slug>.md` from `next-adr`; and the `## 9.` heading itself maps to `09-architecture-decisions/README.md` with promotion `—` — the decision log is appended into §9's generated index, never persisted as a topic document (the third, named row pattern beside topic documents and records). **Split rule** (in Kvasir's skill): one document per section by default (`01-<section-slug>.md`); split only when the section holds three or more units of its natural grain that a reader consults independently and each exceeds a short paragraph — §5 by whitebox overview and building-block groups, §6 by scenario, §8 by concept, §10 overview vs scenarios; never below the rule. Appendix D is Workfile content and is not persisted.

## Consequences
- **Positive:** persistence is literally mechanical; the reviewer sees the split decision before anything is written; one document keeps Kvasir's quality-goal discipline intact.
- **Negative:** one more appendix to author and check (Q-20); a re-drafted section requires its map rows to be re-checked.
- **Becomes harder:** nothing material; option A remains available if the review skill ever becomes multi-file native.

## Related
AC-5, AC-6, AC-14 · §5.1.4, §5.1.5 `Focus: document`, §8.9, Appendix D · ADR-0016, ADR-0018 · WP-R5-3, WP-R5-4.
