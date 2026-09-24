# ADR-0016: The drafting step is permanently unreviewed; the ratification checkpoint and the persistence review are its gates

- **Status:** Accepted
- **Date:** 2026-09-24
- **Kind:** recorded (evidence: `skills/architecture/odin-architecture-workflow/SKILL.md:14, 41-45, 55-57, 63-70, 79, 86`; `skills/architecture/heimdall-architecture-review/SKILL.md:54, 64, 80, 84-97`; `skills/architecture/kvasir-software-architecture/SKILL.md` § Purpose ("Your step receives no review"); `skills/engineering/odin-engineering-workflow/SKILL.md:97`)

## Context

The framework's standing rule is that Mimir and Brokk Subtasks are reviewed and Kvasir and Bragi consultations are not (ADR-0002). The Architecture workflow's drafting step is a Kvasir consultation whose output becomes a project Artifact, and the earlier form of the workflow made it the one exception: a dedicated design review under `Focus: document`, carrying a judgment-based long-term-relevance criterion (ADR-0013) and the update-delta accounting checks (ADR-0014). That review cost a dispatch on every run, duplicated the drafting skill's own boundary as a checklist, and — because it ran before ratification — reviewed a document whose decisions the user had not yet accepted. Subsystem goals affected: Consistency (the standing rule holds without exception), Maintainability (one fewer dispatch and one fewer checklist to keep aligned), Durability (relevance still needs a gate).

## Decision

The drafting step receives no review — permanently, for this one step (`odin-architecture-workflow/SKILL.md:14`). Its gates are two: the **ratification checkpoint**, where the user or adoption ratifies each decision from the ID, title, kind, and one-line rationale the drafter reported (`:41-45`), and the **persistence review**, which checks the persisted form mechanically — the identity rule and the record numbering re-derived at baseline, map ⇔ tree in both directions, promotion distances, every new record opened, three greps for run-local references under the target, and every persisted Mermaid block cleared by a named method (`heimdall-architecture-review/SKILL.md:64, 84-97`). The persistence session verifies the header against the tree before writing and writes nothing on disagreement; a failed precondition is a drafting-side defect corrected by resuming the drafter once (`odin-architecture-workflow/SKILL.md:55-57`). The review skill has exactly two Focus values, `context` and `persistence` (`heimdall-architecture-review/SKILL.md:54`); the relevance test lives in the drafting skill as a boundary the author owns, and its pattern-matchable subset is enforced by the persistence greps (§5.2 I-4). Re-introducing a review of the drafting step "to be safe" is named an anti-pattern (`odin-architecture-workflow/SKILL.md:86`).

## Consequences

- **Positive:** the standing review rule has no exception; the run costs 4 dispatches with context established, 6 when it is gathered, 2 when persistence is declined (`:81`); the ratifier sees decisions before any file is written; the persistence review catches what the earlier design review could not — the target's actual state and the persisted form.
- **Negative:** judgment-level defects in the draft — a single-option `decided` record, an unverified §5 path, a task-scoped paragraph without a tell-tale pattern — have no gate that reads for them (§11 R3, R11); the quality of the Workfile rests on the drafting skill's text and the author session; the mechanical greps have no judgment either, so a document that legitimately describes the workspace path trips them (§11 R20).
- **Becomes harder:** blocking a persisted document on content grounds — the persistence review's blocking conditions are mechanical, so a content defect is corrected by a later delta, not caught at the gate.

## Related

DOC-5, DOC-6, DOC-11 · §5.2 I-4, I-7 · §11 R3, R11, R16, R19, R20 · **supersedes ADR-0013** (the `Focus: document` review criterion and its blocking condition no longer exist) and the review clauses of ADR-0014 (`Focus: document` accounting check) · ADR-0002 (the standing rule this decision restores without exception) · ADR-0015, ADR-0017.
