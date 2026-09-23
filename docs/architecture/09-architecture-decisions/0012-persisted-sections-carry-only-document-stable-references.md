# ADR-0012: Persisted sections carry only document-stable references

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

The drafting skill tells the author to reference "the AC IDs in scope" in §1.1, to list "fulfilled AC IDs" per §5 blackbox, to name "the AC IDs it realizes" per §6 scenario, and — in `document-existing` mode — to state "the evidence base it was written from" in §1.1. Following those instructions produced `docs/architecture/01-introduction-and-goals/01-introduction-and-goals.md:11`, which cites a gitignored workspace path and a review verdict, and would, in a `decide-new` run, persist `AC-3` tokens that resolve only against a Workfile of one task and that a later task's `AC-3` would collide with. The review skill checks for "the criterion IDs it fulfills" in §5 entries. Traceability from criterion to block and package is needed for implementation (Appendix C, not persisted); a persisted reference needs to resolve for a reader years later. Subsystem goals affected: Durability (primary), Clarity, Usability.

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Persisted sections cite repository paths, section numbers, ADR IDs, and requirement IDs that §1.1 defines under a document-unique prefix; Appendix C maps `AC-n` → document ID | References resolve inside the document or the repository; traceability survives in §1.1/§5/§10; collision-free across deltas by construction | One translation step for the drafter; a prefix to choose and check against the existing §1.1 | high | high | medium | high | high |
| B — Ban requirement IDs from §1–§12 altogether; §1.1 states requirements as prose; traceability lives only in Appendix C | Simplest rule; nothing to translate | A reader of §5 cannot see which requirement a block realizes; §10 scenarios lose their driver column; the review skill's "criterion IDs" item is removed rather than adapted | high | medium | high | high | low |
| C — Status quo: bare `AC-n` tokens and Workfile paths allowed | No skill change | Tokens collide across deltas; paths dead once the workspace is gone — the observed defect | low | low | low | medium | medium |

## Decision

We allow only document-stable references in §1–§12: repository paths (with `:line` ranges), section and subsection numbers, decision-record IDs, and requirement IDs that §1.1 of the same document defines. The drafter defines those IDs under a prefix not already present in the persisted §1.1, restates each realized criterion under one, and cites them from §5, §6, and §10; Appendix C maps the Workfile's `AC-n` onto them. The `document-existing` evidence-base statement names repository paths and a date, never a Workfile path or a review verdict. The review skill's §5 and §6 items are reworded from "criterion IDs" to "requirement IDs defined in §1.1", and the long-term-relevance item (ADR-0013) blocks on workspace paths, Workfile names, and review verdicts in §1–§12. Rationale: Durability requires every persisted reference to resolve after the workspace is gone; option A keeps the traceability Usability wants, which option B discards.

## Consequences

- **Positive:** no persisted document cites a file that will be deleted; requirement IDs are unique across the document's whole history; a reader follows every reference without the task's Workfiles.
- **Negative:** one more table in §1.1 per delta that introduces requirements; the drafter must read the existing §1.1 to avoid a prefix collision.
- **Becomes harder:** quoting a Workfile finding directly in a persisted section — it must be re-cited to its repository source.

## Related

DOC-1, DOC-8 · §5.2 I-3 · ADR-0010, ADR-0013 · WP-1 (author), WP-2 (reviewer).
