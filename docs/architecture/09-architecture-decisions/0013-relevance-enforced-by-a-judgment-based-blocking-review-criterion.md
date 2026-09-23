# ADR-0013: Relevance enforced by a judgment-based blocking review criterion

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

The review skill's `Focus: document` checklist blocks on structural defects (single-option records, unresolved §5 paths, map defects) and treats section-level ceremony as a finding but not a blocker (`heimdall-architecture-review/SKILL.md:135, 145`); no item reads a filled section for task-scoped content, and no item exists for either mode that names relevance at all. The ratified defaults require a checklist criterion that blocks, applied in both modes, and rule out a hard detail ceiling per section in favor of reviewer judgment. The review is the only compensating control the framework has for prose-enforced rules (§11 R4, R16). Subsystem goals affected: Durability (the gate), Consistency (both modes), Clarity.

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — One shared item under `Focus: document` (both modes) with the I-1 tell-tale list, a blocking condition for wholly task-scoped sections or paragraphs and for any workspace path / Workfile name / verdict / revision log, a note for a stray clause, and an explicit "never on length" clause; a note-level item under `Focus: context` | Blocks what the requirement asks it to block; the tell-tales make the frequent cases mechanical; one item serves both modes | Long-tail judgment (R11); one more item in an already long checklist | high | high | medium | high | high |
| B — Mechanical ceiling (documents per section, lines per document) as the blocking condition | Fully objective | Blocks long durable sections and passes short task-scoped ones; ruled out by the ratified default | low | low | high | high | low |
| C — Note-only relevance item, never blocking | No false blocks | Fails the requirement (the gate must block); a note is routinely accepted at the checkpoint and the clutter persists | low | medium | high | high | medium |

## Decision

We add one **Long-term relevance** item to the shared items of `Focus: document` with the contract of §5.2 I-4: blocking on a section or whole paragraph of only task-scoped content and on any workspace path, task directory, Workfile name, review verdict, or revision log in §1–§12; a located note on a single stray clause; never a finding on length or document count; in update-delta scope, a check of the report's `Refreshed:` list against the re-authored documents' persisted versions. `Focus: context` gains a note-level item for task-scoped facts in the context Workfile. The `BLOCKED on:` lists of both mode checklists name the new blocking condition. Rationale: only option A satisfies both ratified defaults at once — it blocks, and it does so by judgment anchored to named patterns rather than by a ceiling.

## Consequences

- **Positive:** the observed defect class (workspace paths, verdicts, run debts in persisted sections) becomes a blocking finding with a location; both modes are gated identically.
- **Negative:** reviewer judgment can vary (R11); the item lengthens the document review.
- **Becomes harder:** persisting a document with a long provenance narrative — the narrative must be reduced to repository paths and a date.

## Related

DOC-5 · §5.2 I-4 · ADR-0010, ADR-0011, ADR-0012 · WP-2.
