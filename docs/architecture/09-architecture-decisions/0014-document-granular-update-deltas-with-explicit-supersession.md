# ADR-0014: Document-granular update deltas with explicit supersession

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

In update-delta scope the persistence step writes, for each included section, "its mapped documents by whole-file replacement" and lists "a document a previous map named and this one does not" under "Superseded documents" (`brokk-architecture-persistence/SKILL.md:253`; § The Persisted Layout at `:67`, duplicated in `brokk-arc42-template`). The unit of a delta is therefore the section: to change one blackbox of §5 (ten documents) the drafter must map — and so reproduce — all ten, or see nine listed as superseded. This delta does exactly that (Appendix D carries nine carried-forward §5 documents). The ratified default that touched sections be refreshed on update presupposes re-authoring, and re-authoring nine documents to change one is the mechanism most likely to introduce transcription errors and to make drafters avoid §5 and §8 altogether. Subsystem goals affected: Maintainability (primary), Durability, Consistency. This decision is driven by the quality goal, not by a stated requirement; it can be withheld on its own.

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Status quo (section-granular): the drafter carries every document of an included section forward in the Workfile | No skill change; the Workfile is a complete picture of the section | Ten documents copied to change one; copy errors; reviewer re-opens every carried document; disincentive to touch §5/§8 | medium | medium | low | high | medium |
| B — Document-granular: the map names only documents the delta writes; unnamed documents of an included section are carried forward byte-identical; retirement requires an explicit `→ superseded — <reason>` row; ordinals fixed for existing documents, new ones continue the sequence | One document re-authored to change one block; supersession is a reviewed act with a reason; carried-forward documents are provably unchanged | Changes the persistence step, the duplicated layout specification (two files), the drafting skill's layout-map rules, and two review items; a drafter must know the section's existing documents to name what they retire | high | high | high | high | high |
| C — Sub-section-granular deltas: allow a Workfile to replace individual headings inside a persisted document | Finest control | Requires a merge inside a Markdown file — the persistence step would need judgment it is designed not to have; conflicts with the one-root-per-document rule | medium | low | medium | low | medium |

## Decision

We make the topic document the unit of an update delta (§5.2 I-5): Appendix D names only the documents the delta writes; a fourth row form `| <existing document heading> | → superseded — <reason> | — |` retires an existing document; an unnamed document of an included section is carried forward byte-identical and listed in the regenerated index at its existing ordinal. `brokk-architecture-persistence` § Workflow step 5 replaces exactly the named documents, supersedes exactly the `→ superseded` rows, and regenerates the index from carried-forward + re-authored + new documents; "Superseded documents" in § The Persisted Layout is redefined as "files a later map explicitly supersedes" and the section is copied byte-for-byte into `brokk-arc42-template`. `kvasir-software-architecture` § Layout Map gains the row form and the carry-forward rule, and its report lists `Carried forward:`. `heimdall-architecture-review` checks the three-way accounting (mapped / superseded / carried forward) under `Focus: document` and byte-identity of carried-forward documents plus row-backed supersession under `Focus: persistence` (b). Rationale: Maintainability (goal 3) is unreachable at section granularity; option B is the smallest change that reaches it without giving the persistence step judgment (option C).

## Consequences

- **Positive:** a one-block change is a one-document delta; supersession is explicit and reviewed; carried-forward documents cannot drift because they are not rewritten.
- **Negative:** four skills change (two of them a synchronized copy — R14); the drafter must read the target section's index to know what exists.
- **Becomes harder:** re-splitting a section wholesale — every retired document now needs its own superseded row with a reason, which is the point.

## Related

DOC-4 · §5.2 I-5 · QS-11 · ADR-0010 (refresh rule) · R13, R14 · WP-3.
