# ADR-0015: One mode-less Architecture workflow — the objective fixes the content, the target's state fixes the document scope

- **Status:** Accepted
- **Date:** 2026-09-24
- **Kind:** recorded (evidence: `skills/architecture/odin-architecture-workflow/SKILL.md:3, 10-16, 29, 41, 86`; `skills/architecture/kvasir-software-architecture/SKILL.md` § Purpose, § Workflow step 1; `README.md:384-386`; `skills/architecture/heimdall-architecture-review/SKILL.md:54`)

## Context

The Architecture workflow serves two kinds of objective: recording the architecture a codebase already has, and deciding it for a bounded objective. The earlier form of the workflow made that distinction a **mode** — a `Mode:` line briefed to every step, with mode-specific marker rules, a mode-specific evidence-base statement, and two review checklists — while a second, orthogonal distinction (whether an architecture document already exists at the target) was a document scope the drafter derived from the target. Two axes carried by two different mechanisms produced four combinations for every rule, and the persisted document of this repository showed the cost: mode vocabulary in requirements, glossary, quality scenarios, and decision records that had to be kept aligned across five skills. Subsystem goals affected: Consistency (primary), Clarity, Maintainability.

## Decision

The Architecture workflow has one form and no mode. **What the document holds follows from the objective**: the drafting skill assesses what the architecture *is* and what the objective *changes* — nothing, when the objective records the system — and includes the sections that hold durable content for it (`kvasir-software-architecture/SKILL.md` § Purpose, § Workflow step 3). **Whether the layout is created or merged into follows from the target's state**, derived by the drafter's two-fact check and written into the header as `Document scope: seed | update delta` (§5.2 I-7). No brief, header, or report carries a `Mode:` line; the workflow skill lists a mode line among the things a caller must not re-introduce (`odin-architecture-workflow/SKILL.md:86`), and the user documentation states "there is one workflow and no mode to choose or state" (`README.md:384`). The review skill selects its checklist by the reviewed *node* — `Focus: context | persistence` — not by mode (`heimdall-architecture-review/SKILL.md:54`). The long-term-relevance test, the three omission markers, and the document-stable-reference rule apply identically in both document scopes and need no mode column.

## Consequences

- **Positive:** every rule of the family is stated once per document scope, not once per mode × scope; the ratification checkpoint surfaces `Document scope:` read out as *the layout will be created* or *merged into the existing document* and nothing else about form (`odin-architecture-workflow/SKILL.md:45`); the persisted §1.1 evidence-base statement is one rule — repository paths and a date — for every run.
- **Negative:** a reader of a persisted document cannot tell from a header whether the run recorded or decided; the §9 log's `Kind` column (`as-is` / `recorded` versus `decided`) is the only durable trace of that difference.
- **Becomes harder:** giving the two kinds of objective different rules later — any such rule would have to be keyed to the objective's wording, not to a mode line.

## Related

DOC-10, DOC-13 · §5.2 I-1, I-2, I-7 · §12 "Document scope" · supersedes the mode clauses of ADR-0010 (title and Decision), ADR-0011 (Context), and ADR-0012 (Context and Decision); their substance — one test in both scopes, three markers, document-stable references — stands · ADR-0016, ADR-0018.
