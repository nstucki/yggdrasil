# ADR-0010: One long-term-relevance test for persisted content in both modes and both scopes

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

The drafting skill already forbids "implementation minutiae the implementation phase owns" (`kvasir-software-architecture/SKILL.md` § Boundaries) and prunes sections by objective relevance; the context skill already declines runner commands and code conventions (`mimir-architecture-context/SKILL.md:43, 106`); the review skill already blocks section-level ceremony (`heimdall-architecture-review/SKILL.md:135`). Yet the persisted document produced under those rules carries a transient workspace path and a review verdict in §1.1 and a "Debt (of this document)" row in §11 (`docs/architecture/01-introduction-and-goals/01-introduction-and-goals.md:11`; `docs/architecture/11-risks-and-technical-debts/01-risks-and-technical-debts.md:16`). The gap is that "minutiae" is a subset of "task-scoped": run provenance, workspace references, temporary measures, and work-package sequencing are not minutiae and no rule excludes them, and the existing rules are stated per skill in different words. The ratified requirements fix the rule's reach — both modes, both document scopes, refreshing touched sections on update, and a context step narrowed to structural footprint. Subsystem goals affected: Durability (primary), Consistency, Usability, Maintainability.

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — One test stated once (drafting skill), referenced by name from the context and review skills, with one shared tell-tale list and per-section application notes | Single definition; judgment-based so it covers cases a list would miss; the tell-tales make the common cases mechanical | Relies on judgment for the long tail (R11) | high | high — one wording everywhere | high — one edit site | high | high |
| B — Per-section content whitelists ("§4 may contain: …; §5 may contain: …") in each skill | Fully explicit; easy to check line by line | Brittle — a legitimate statement outside the list is blocked, a task-scoped one phrased like an allowed item passes; twelve lists to keep aligned across three skills | medium | medium — twelve lists to learn | low — twelve lists to maintain | medium — lists drift | medium |
| C — Size ceilings per section (documents or lines) as the proxy for "too much detail" | Mechanical; trivially checkable | Measures the wrong thing — a long durable section is fine and a short task-scoped one is not; rejected by the ratified default (no hard ceiling) | low | low | medium | high | low |

## Decision

We state the long-term-relevance test once, verbatim as §5.2 I-1, in `kvasir-software-architecture` § Boundaries, and reference it by name from `mimir-architecture-context` § Boundaries and `heimdall-architecture-review` § Focus: document. It applies in `decide-new` and `document-existing`, in `seed` and `update delta`, to every section §1–§12. It carries one tell-tale list, identical in the drafting and review skills, and per-section application notes in the drafting skill's workflow steps 3 and 5–8. In update-delta scope the refresh rule applies to every document the delta re-authors. The context skill's existing exclusions are restated as a Boundary ("Never record a task-scoped fact — …") and a Quality Criterion, and its `## Scope` section names the excluded categories. Rationale: Durability and Consistency are served only by one rule with one wording; option B fails Maintainability and option C was ruled out by the ratified default.

## Consequences

- **Positive:** the same sentence governs gathering, drafting, and review; run provenance and workspace references have an explicit home (appendices and report) and an explicit prohibition (§1–§12); the refresh rule turns every re-authored document into a cleanup opportunity.
- **Negative:** the long tail is judgment (R11); the drafting skill grows by one boundary, one list, and several step-level clauses.
- **Becomes harder:** recording a genuinely useful task-scoped fact in the persisted document — the rule sends it to Appendix B or the report; if it constrains future work it must be promoted to a decision or a risk to stay.

## Related

DOC-1, DOC-2, DOC-3, DOC-4 · §5.2 I-1 · ADR-0012, ADR-0013 · WP-1.
