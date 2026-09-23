# ADR-0011: Closed set of three typed omission markers

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

Today the drafting skill fixes `_Omitted — <reason>_` with a free reason in seed scope and `_Not affected by this change_` in update-delta scope (`kvasir-software-architecture/SKILL.md` § Document Shape rule 2), and the `document-existing` branch names `_Omitted — no evidence in context Workfile_`; the review skill treats a wording mismatch as a note (`heimdall-architecture-review/SKILL.md:135`); the persistence step copies a seed marker verbatim into the section index and never writes the unaffected one (`brokk-architecture-persistence/SKILL.md:67, 325`). A reader of a persisted index therefore sees a free-form reason and cannot tell a scope judgment from missing evidence, and the author's report states the scope as two lists with no reasons. The ratified default asks for typed markers distinguishing scope, evidence, and unaffected-by-update, and for a report that gives a reason per omission. Subsystem goals affected: Clarity (primary), Consistency.

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Closed set of three fixed strings, selected by a scope × mode table; reasons travel in the report | Mechanically checkable by the reviewer; a reader learns three strings; nothing to copy wrongly | The reason for a scope omission is not in the persisted index (it is in the report and, when material, in §11) | high | high | high | high | medium |
| B — Status quo: free-form `_Omitted — <reason>_` plus `_Not affected by this change_` | Maximally expressive | Unclassifiable; every drafter words it differently; reviewer cannot check without reading the reason | medium | low | medium | low | medium |
| C — Type tag plus free reason: `_Omitted (scope) — <reason>_` | Classifiable and expressive | Two things to check; reasons in a persisted index are the kind of run-local prose I-1 excludes ("not needed for the flag rollout"); more to get wrong | medium | high | medium | medium | medium |

## Decision

We use exactly three marker strings — `_Omitted — not architecturally significant for this objective_` (scope), `_Omitted — no evidence in context Workfile_` (evidence), `_Not affected by this change_` (unaffected) — selected by the table in §5.2 I-2, and extend the `Section scope:` line with a mandatory type tag per omitted section: `omitted=<§N (scope | evidence | unaffected)[, …]>`. The report adds `Scope rationale:` (one clause per omitted section and per minimized included section) and, in update-delta scope, `Refreshed:` / `Carried forward:`. The drafting skill's Document Shape rule 2 and Output Contract, and the review skill's marker and header items, are rewritten against the closed set. The persistence step is unchanged. Rationale: Clarity is served by a set a reader can learn and a reviewer can check; option C would put run-local reasons into persisted indices, against I-1.

## Consequences

- **Positive:** a persisted index tells a reader why a section is empty in one of three ways; the reviewer's marker check becomes a string comparison; the ratifier sees reasons at the checkpoint.
- **Negative:** a nuance ("omitted because the subsystem in focus has no deployment of its own") cannot be expressed in the marker — it goes to the report, or to §11 if it matters.
- **Becomes harder:** inventing a fourth omission kind — it requires changing this decision and three skills.

## Related

DOC-6, DOC-7 · §5.2 I-2 · ADR-0010 · WP-1 (author), WP-2 (reviewer).
