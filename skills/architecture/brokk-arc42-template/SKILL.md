---
name: brokk-arc42-template
description: Own the arc42 structure reference and scaffold the arc42 folder layout into the target project — classify any existing architecture document's shape, resolve the next decision-record number, and create the index-only section folders at Status Scaffolded, writing no content, no guidance text, and no Workfile.
---

# arc42 Template — Architecture Document

<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: Gernot Starke and Peter Hruschka — arc42 template, https://arc42.org

SPDX has no per-region mechanism, so the tag above is declared for the whole file.
It is the arc42-derived guidance text in this file that carries CC BY-SA 4.0; the
content marked "Yggdrasil" is original to this repository. The exact scope and the full
legal code are in LICENSES/CC-BY-SA-4.0-arc42.txt in the Yggdrasil source repository
(not installed with this skill) and at https://creativecommons.org/licenses/by-sa/4.0/legalcode.
-->

> ## Attribution and license
>
> **The arc42 section guidance in this file is reproduced and adapted from the arc42 template for architecture communication and documentation**, created by **Gernot Starke** and **Peter Hruschka** — <https://arc42.org>. Source of the reproduced text: <https://github.com/arc42/arc42-template>, English AsciiDoc edition (`EN/adoc/01_…` through `EN/adoc/12_…`), template version **9.0 (July 2025)**, retrieved 2026-09-16.
>
> **License.** The arc42-derived content of this skill is licensed under the **Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)** — <https://creativecommons.org/licenses/by-sa/4.0/> (full legal code: <https://creativecommons.org/licenses/by-sa/4.0/legalcode>). A copy of the legal code, together with a statement of the precise scope of that license within the Yggdrasil repository, ships with the Yggdrasil **source** at `LICENSES/CC-BY-SA-4.0-arc42.txt`; that file is deliberately not installed alongside this skill, so if you are reading an installed copy, consult the source repository or the canonical URL above. The arc42-derived content is *not* covered by the license terms of the rest of this repository.
>
> **Changes made to the arc42 original** (disclosed as CC BY-SA 4.0 §3(a)(1)(B) requires):
>
> 1. **Converted from AsciiDoc to Markdown.** The AsciiDoc `ifdef::arc42help[]` / `[role="arc42help"]` wrappers and the `[[section-…]]` anchors were dropped, and each guidance block is presented in a fenced `text` block so that it renders literally.
> 2. **Only the arc42 guidance (`arc42help`) text of sections 1–12 and their subsections is reproduced.** arc42's own fill-in scaffolding — its placeholder tables, `_<white box template>_` markers, the black-box and white-box template help blocks, and the Infrastructure Level 1/2 help blocks — is not reproduced.
> 3. **Block labels re-rendered.** The AsciiDoc labels `.Contents`, `.Content`, `.Motivation`, `.Form`, `.Structure`, `.Examples`, and `.Further Information` are rendered as `Contents:`, `Content:`, `Motivation:`, `Form:`, `Structure:`, `Examples:`, and `Further Information:`.
> 4. **`Further Information` blocks trimmed.** The `.Further Information` blocks — which link into <https://docs.arc42.org> — are omitted throughout, except in section 10.2, where the `Examples` block and the `Further Information` block (the Bass/Clements/Kazman citation) are retained because they carry substantive content.
> 5. **Images not included.** AsciiDoc image macros are replaced by bracketed placeholders carrying the macro's alt text — `[image: Categories of Quality Requirements]`, `[image: Hierarchy of building blocks]`, `[image: Possible topics for crosscutting concepts]`. The image files themselves are not reproduced.
> 6. **AsciiDoc inline markup left as written.** Inline emphasis (`_floor plan_`, `*Level 1*`) and inline link syntax (`https://…[label]`) appear exactly as in the source, unconverted.
> 7. **Typographic punctuation normalized to ASCII** — for example `system’s` → `system's` and `“Risk management…”` → `"Risk management…"`.
> 8. **Heading numbers made explicit** (`1.`, `1.1`, `5.3`, …); the AsciiDoc original generates section numbers automatically.
> 9. **Paragraph line wrapping may differ** from the source files.
>
> **What is *not* arc42.** Everything marked **Yggdrasil** in this file is original content of this repository and is **no part of the arc42 template**: the five sections below (Purpose, When to Use, Workflow, Quality Criteria, and Anti-Patterns), the document header block, every `> **Yggdrasil:**` note, all fill-in tables and angle-bracket placeholders, the omission-marker convention, and Appendices A–C. arc42 does not endorse this repository or its use of the template.
>
> **Reading convention.** A fenced block introduced by **arc42 guidance §N** is arc42-original text under CC BY-SA 4.0. A blockquote introduced by `> **Yggdrasil:**` is this repository's own guidance.

## Purpose

Own the arc42 **structure reference** — the twelve numbered sections, their subsections, and a one-line description of each — **and scaffold that structure as a folder layout in the target project**. § Structure Reference below is the text the section indices are generated from. § Skeleton below it is the arc42 guidance payload, kept here as reference material for maintainers and reviewers; it is **never written anywhere**.

You are the **scaffolder**. You create the empty directory the drafting step will mirror and the persistence step will fill, and you resolve up front the mechanical facts both would otherwise have to look up: whether the project already has an architecture document, which of five shapes it has, and what the next free decision-record number is. You report those answers in one result line. The drafting step then authors its Workfile from that line, and the persistence step fills the folders you created.

**Your medium is the target project.** You write index files under `docs/architecture/` (or the briefed location) and nothing else, anywhere. You **never write a Workfile** — the task directory must gain no file from your session. An existing architecture document is input you read and classify, never a file you edit.

**You write structure, never content.** No topic document, no section body, no decision record, and not one byte of arc42 guidance text goes into the target. Every file you create is a generated index: an H1, a backlink, a one-line description, and a state line saying the section is not yet drafted. Content arrives later, after review and ratification, from the persistence step.

**Judgment is not yours.** Which sections an objective affects, what the quality goals are, which decisions are significant, how a section splits into topic documents, and what any of them says are the drafting step's calls. **Pruning in particular stays there:** a folder you omitted and a section the drafter deliberately omitted look identical to a reviewer, so you create all twelve and fill none.

**You never delete or modify what you did not create.** A structure that already exists is verified, or extended with only the folders it lacks. A legacy shape — a flat directory, a single file, a non-arc42 document — is classified and reported with `migration required`, never rewritten: migrating a shipped document is a project decision the user makes, executed later by the persistence step under cited direction.

**Attribution stays with the licensed text, and the licensed text never leaves this skill.** The `Attribution and license` block above is skill-level content, and the reading convention is its last paragraph: a fenced **arc42 guidance §N** block is arc42-original text under CC BY-SA 4.0, and a `> **Yggdrasil:**` blockquote is this repository's own guidance. Because nothing you write into a target project contains a guidance block, no file you write carries the notice — the review of your session greps the target for guidance text and expects zero hits. The conditional attribution rule that governed the old guidance-carrying scaffold is therefore dormant by construction, not by discipline.

**This skill is loaded by name with the `skill` tool, never read as a file.** The structure reference and the skeleton live in this `SKILL.md` because a skill's own body is inlined when the skill is loaded, whereas companion files sitting beside a `SKILL.md` are not reliably readable at runtime — a file-based template is unreachable. Every future change to either belongs inside this file.

The shape you create is specified next, and it is the same specification the drafting step maps its Workfile onto and the persistence step fills.

### The Persisted Layout

A persisted arc42 document is a **directory of section folders**. Each of the twelve numbered sections is a folder holding a generated `README.md` index and zero or more `NN-<slug>.md` topic documents. Section 9's folder holds the decision records, and its index is the decision log.

```text
docs/architecture/
├── README.md                                  # top index (generated)
├── 01-introduction-and-goals/
│   ├── README.md                              # section index (generated)
│   └── 01-introduction-and-goals.md           # single topic document (default name = section slug)
├── 05-building-block-view/
│   ├── README.md
│   ├── 01-whitebox-overall-system.md          # topic documents: NN-<slug>.md, NN contiguous from 01 in map order
│   ├── 02-<building-block-group>.md
│   └── …
├── 07-deployment-view/
│   └── README.md                              # omitted section: index only, marker verbatim in the state line
├── 09-architecture-decisions/
│   ├── README.md                              # the decision log
│   ├── 0001-<slug>.md                         # records keep NNNN — global identifiers, append-only
│   └── 0016-<slug>.md
└── 12-glossary/
    ├── README.md
    └── 01-glossary.md
```

**Fixed folder table.** These twelve folder names are the shared vocabulary. No variants, no renumbering, no thirteenth section.

| § | Folder | Section heading it carries |
| --- | --- | --- |
| 1 | `01-introduction-and-goals/` | `## 1. Introduction and Goals` |
| 2 | `02-architecture-constraints/` | `## 2. Architecture Constraints` |
| 3 | `03-context-and-scope/` | `## 3. Context and Scope` |
| 4 | `04-solution-strategy/` | `## 4. Solution Strategy` |
| 5 | `05-building-block-view/` | `## 5. Building Block View` |
| 6 | `06-runtime-view/` | `## 6. Runtime View` |
| 7 | `07-deployment-view/` | `## 7. Deployment View` |
| 8 | `08-crosscutting-concepts/` | `## 8. Cross-cutting Concepts` |
| 9 | `09-architecture-decisions/` | `## 9. Architecture Decisions` |
| 10 | `10-quality-requirements/` | `## 10. Quality Requirements` |
| 11 | `11-risks-and-technical-debts/` | `## 11. Risks and Technical Debts` |
| 12 | `12-glossary/` | `## 12. Glossary` |

**All twelve folders always exist**, each holding at least its index. Git tracks no empty directory, so a structure committed as bare folders vanishes; and a missing folder cannot be told apart from "never scaffolded", "deleted by accident", or "deleted by someone who disagreed". A fixed folder set makes completeness a listing check.

**Topic document.** `NN-<slug>.md`: `NN` is two digits, contiguous from `01`, in layout-map order; `<slug>` is the kebab-case of the document's root heading title. A section with one document names it `01-<section-slug>.md`. Decision records are `NNNN-<slug>.md`, four digits, continuing the project's record sequence — records are global identifiers and append-only, whereas topic ordinals are folder-local ordering that a later delta may re-assign when it re-splits a section.

**Per-document format.** A document is one root heading plus those of its descendants that no other map row claims. Its H1 is the root heading promoted by `depth − 1` — a `## N.` root by 1, a `### N.m` root by 2, a `#### N.m.k` root by 3, a decision record's `### ADR-NNNN` under `## Appendix A` by 2 — and its body is promoted by that same distance. The backlink line is the second content line, `_Part of [<Title>](../README.md) · [§N](README.md)._`; records carry no backlink. Where children are carved out into their own documents, the parent document ends where the first carved-out child began, and the section index carries the reading order.

**Section index (generated).** `# N. <Title>`, the backlink to the top index, the one-line section description, then a state line — `_Pending — not yet drafted_` before first fill, `_Omitted — <reason>_` for an omitted section, or a Documents table (`# · Document · Root heading · Last updated`). "Omitted subsections" (markers verbatim) and "Superseded documents" (files a later map no longer names) follow when either applies. `09-architecture-decisions/README.md` is that section's index and the decision log in one file.

**Top index.** `README.md` at the directory root: title, `Last updated`, `Status`, a Sections table (state · docs · last updated), and the Change Log.

**Omitted section = index-only folder.** No topic document; the marker travels verbatim in the index's state line. In a flat-to-folder migration the legacy stub file *becomes* that index by rename — never delete-and-recreate.

**Identity rules.** Contents decide the shape of a target, never the directory's name. **Folder layout** if and only if it holds `README.md` and `01-introduction-and-goals/README.md`. **Flat directory (legacy)** if and only if it holds `README.md` and `01-introduction-and-goals.md`. **Legacy single file** when one markdown file carries the arc42 `## N.` headings. **Non-arc42** when a document in another structure describes this system's architecture. **None** when nothing is found.

**Status invariant.** Seed-scope persistence requires the top index at `Status: Scaffolded`; update-delta persistence requires `Accepted`. A `created` structure reads `Scaffolded`; the first persistence promotes it to `Accepted`. A persistence step never creates a folder the scaffold did not.

**No arc42 guidance text anywhere under the target, ever** — and therefore no attribution notice in any file under it. The licensed guidance text stays inside the skill that carries it.

**This specification is duplicated verbatim.** The two skills that write the layout carry this section byte for byte: the scaffolding skill `brokk-arc42-template`, and `brokk-architecture-persistence`, whose copy is normative. A layout change is a two-file copy, never a re-derivation.

## When to Use

- Dispatched as the **scaffold step of the architecture workflow** — in both document modes, on both the standalone and the delegated path, before anything is drafted. The step is never skipped, so a run over an already-scaffolded project is the normal case, not the exception.
- Dispatched over an existing target: a complete folder-layout directory is **verified** and nothing is written; one that lacks section folders is **extended** with only those folders' indices.
- Loaded by the review of this session, or by the requesting agent, to check a scaffolded structure or a drafted document against the arc42 structure reference.
- **Not for** filling, revising, or reviewing an architecture document — the drafting step fills it, the review step judges it, and the persistence step places it.
- **Not for** writing a Workfile, and **not for** deciding what the document should say. This skill carries a structure reference, a layout specification, and the procedure for instantiating them — no architecture method, no review rubric, and no project-specific content.
- **Not for** migrating a legacy document. You classify and report; the user directs, and the persistence step moves.

## Workflow

**Input.** The brief carries one control line:

```text
Scaffold: location=<docs/architecture/ | path>
```

**Output.** The scaffolded structure in the target project — thirteen files on `created`, the missing folders' indices on `extended`, nothing at all on `verified` — plus the `Scaffold result:` line of step 5. No Workfile, ever.

1. **Read the brief.** `location` is the starting point for step 2 and the write location for step 4.

2. **Resolve the target and classify its shape.** Search in this order: the brief's `location`, then `docs/architecture/`, `docs/arc42*`, `architecture/`, `doc/`, and the README's documentation links. Classify the first architecture document you find by the **identity rules** of § The Persisted Layout — `directory` (the folder layout), `flat directory (legacy)`, `legacy single file`, `non-arc42`, or `none`. The contents decide, never the directory's name.

   For a `directory` target, read its top index and the indices of §1, §4, §5, and §9 — far enough to state the path, confirm the shape, and list which folders are present, never far enough to summarize the architecture. `document-scope` is **update delta** for all four found shapes and **seed** only for `none`. Record the target path for the result line's `existing=` field.

   **Seed collision rule.** If the resolved location already exists and holds a `README.md` whose H1 does not end with `— Architecture (arc42)`, scaffold into `docs/architecture/arc42/` instead and report the fallback. Never write over a `README.md` that is not this document's index.

3. **Resolve the decision records and the next number.** Look in `<target>/09-architecture-decisions/`, `<target>/decisions/`, `docs/architecture/decisions/`, `docs/adr/`, `docs/decisions/`, and `adr/`. Read the highest record number in use **across every directory you find**, and set `next-adr` to that number plus one, zero-padded to four digits; the next record must not collide with an existing one whichever directory the persistence step later writes to. No record anywhere → `next-adr=0001`. Report every decision directory you found, not just the winner.

4. **Act on the target — one action per shape, and only one.**

   | Shape found | Action | `structure=` |
   | --- | --- | --- |
   | `none` | Create the full structure: the top index, the twelve section folders, and their indices. | `created` |
   | `directory`, all twelve folders present | Write nothing. | `verified` |
   | `directory`, some folders missing | Add only the missing folders and their indices; touch no existing file. | `extended` |
   | `flat directory (legacy)` | Write nothing. Append `— migration required` to the result line. | `verified` |
   | `legacy single file` | Write nothing. Append `— migration required` to the result line. | `verified` |
   | `non-arc42` | Write nothing. | `verified` |

   **`created` writes exactly thirteen files** — one top index and twelve section indices, §9's being the decision log. Nothing else: no topic document, no `.gitkeep`, no placeholder.

   The **top index**, `<target>/README.md`:

   ```markdown
   # <System / Subsystem> — Architecture (arc42)

   - **Last updated:** <today, YYYY-MM-DD>
   - **Status:** Scaffolded

   _Generated index — regenerated by the architecture persistence step. Edit the topic documents and the records, not this file._

   ## Sections

   | § | Section | State | Docs | Last updated |
   | --- | --- | --- | --- | --- |
   | 1 | [Introduction and Goals](01-introduction-and-goals/README.md) | pending | 0 | — |
   | … one row per section, all twelve, every row `pending` … |
   | 12 | [Glossary](12-glossary/README.md) | pending | 0 | — |

   ## Change Log

   | Date | Scope | Sections written | Decisions added |
   | --- | --- | --- | --- |
   | <today> | scaffolded | — | — |
   ```

   `Status: Scaffolded` is the invariant that tells the persistence step this structure has never been filled; only that step promotes it to `Accepted`. The system or subsystem name comes from an existing document's H1 when one was found, otherwise from the repository or project directory name.

   Each **section index**, `<target>/NN-<section-slug>/README.md`:

   ```markdown
   # N. <Title>

   _Part of [<System / Subsystem> — Architecture (arc42)](../README.md)._

   <the section's one-line description, verbatim from § Structure Reference>

   _Pending — not yet drafted_
   ```

   Folder names, section titles, and descriptions come from § Structure Reference and the fixed folder table; nothing is renamed, renumbered, or dropped. `09-architecture-decisions/README.md` is the one variant: it carries the same four parts and then the **empty decision-log table**, because that index is the log.

   ```markdown
   # 9. Architecture Decisions

   _Part of [<System / Subsystem> — Architecture (arc42)](../README.md)._

   The decision log — one row per architecturally significant decision, with its full record beside it in this folder.

   _Pending — not yet drafted_

   | ID | Title | Status | Date | Link |
   | --- | --- | --- | --- | --- |
   ```

   On `extended`, generate only the indices of the folders you added, and change no byte of any file that was already there — regenerating an existing index is the persistence step's act, not yours.

5. **Report the result line** to the requesting agent, followed by anything you could not resolve:

   ```text
   Scaffold result: target=<path>, structure=<created | verified | extended>, shape=<directory | flat directory (legacy) | legacy single file | non-arc42 | none>, document-scope=<seed | update delta>, existing=<path (README.md index) | none>, next-adr=<NNNN>
   ```

   Append ` — migration required` to the end of the line for a `flat directory (legacy)` or a `legacy single file`, so the requesting agent obtains the user's direction before persistence: the persistence step refuses to write either shape without it.

   Then list, in one line each: every candidate architecture document you rejected and why; every decision directory you found; the fallback path if the seed collision rule fired; and any path the brief named that did not resolve. The review of this session re-derives the shape and `next-adr` from the same paths, so state the paths you used.

**Failure handling:**

- A candidate target exists but cannot be read → report it and stop. Classifying a document you could not open as `none` would silently turn an update delta into a seed and scaffold a second structure beside a real one.
- Two candidate documents resolve — a folder layout and a legacy file, say → take the folder layout as the target, report the other as an ambiguity finding with both paths, and let the requesting agent settle it before drafting.
- The resolved location holds a partial structure you cannot classify — a `README.md` with this document's H1 but no `01-introduction-and-goals/` and no `01-introduction-and-goals.md` → report it as an unclassifiable target and stop. Do not "repair" it into either shape.
- The project's decision numbering is inconsistent — gaps, duplicates, or non-numeric names → use the highest number you can parse, and report the inconsistency with the directory path.
- A later step of the workflow is blocked and the structure you created is never filled → it **stays**. You created project files; removing them is a user direction, not a cleanup. The workflow discloses the unfilled structure in its result and its response.

## Quality Criteria

- On `created`, exactly thirteen files exist under the target and nothing else: the top index and the twelve section indices, §9's being the decision log. `git status --short` for the target shows additions only.
- On `verified`, not one byte was written: `git status --short` for the target is empty.
- On `extended`, only the missing section folders' indices were added, and every file that was already present is byte-identical to its prior state.
- The top index reads `Status: Scaffolded`, carries today's date as `Last updated`, a Sections table with all twelve rows and every state `pending`, and a Change Log with exactly one `scaffolded` row.
- Every section index carries its H1 `# N. <Title>`, the backlink to the top index, its one-line description verbatim from § Structure Reference, and the `_Pending — not yet drafted_` state line; `09-architecture-decisions/README.md` additionally carries the empty decision-log table and nothing more.
- No topic document, no section body, no decision record, no table row of content, and no `arc42 guidance §N` text exists anywhere under the target (grep = 0) — and therefore no attribution notice in any file under it either.
- The twelve folder names are exactly the fixed folder table's, none renamed, renumbered, or dropped, and all twelve exist after `created`.
- The shape is re-derivable by a reviewer from the same paths you searched, using the identity rules rather than the directory's name; `document-scope` follows from it — `seed` for `none`, `update delta` for every found shape.
- `next-adr` is one above the highest record number in use anywhere in the project's decision directories, and `0001` only when no record exists.
- No pre-existing project file was modified, moved, or deleted, and a `README.md` that is not this document's index was never written over.
- The task directory gained no file: this session wrote no Workfile.
- The `Scaffold result:` line is complete, every field in it matches the tree and the paths actually searched, and ` — migration required` is appended for a flat legacy directory or a legacy single file.

## Anti-Patterns

- **Writing a Workfile** — a skeleton, a shape report, or a summary in the task directory. Your medium is the target project; the result line goes to the requesting agent, not into a file.
- **Writing arc42 guidance into the project** — copying § Skeleton's guidance blocks into an index "so the drafter can read them". The licensed text stays in this skill; a target that carries it would also have to carry the notice, and an aborted run would leave licensed text in the user's tree.
- **Filling while scaffolding** — a sentence of §1.1, a first risk row, or an `01-<section-slug>.md` created empty "so the folder is not lonely". The drafter cannot tell your prose from its own, and a topic document you invent is structure nobody reviewed.
- **Pruning by anticipation** — skipping `07-deployment-view/` because the project "obviously" has nothing to deploy. Omission is a judgment recorded in an index's state line; a missing folder is a defect nobody can distinguish from an accident.
- **Scaffolding over a legacy shape** — creating folders beside a flat directory's section files, or "upgrading" a single file in place. A legacy target is classified and reported with `migration required`; the move happens later, under cited user direction.
- **Regenerating an index you did not create** — refreshing an existing section index on `verified` or `extended`. Index regeneration belongs to the persistence step, which knows what the folder now holds; yours would erase it.
- **Classifying by directory name** — calling `docs/architecture/` the folder layout without confirming `README.md` and `01-introduction-and-goals/README.md`, or calling a directory `none` because it is named something else.
- **Restarting the record sequence** — reporting `next-adr=0001` in a project that already holds `0007`, which collides at persistence and corrupts the decision log.
- **Deleting the structure on failure** — removing the folders you created because a later step blocked. The workflow discloses an unfilled structure and leaves it; deletion is a user direction.
- **Reading the existing document as research** — summarizing a found architecture document instead of classifying it. You need its path, its shape, and its record numbering; its content is the drafter's input, not your finding.
- **Renumbering or renaming the arc42 sections** — the numbering is the shared vocabulary; a §5 that is not the building block view breaks every cross-reference, every index link, and every reader's expectation.
- **Editing the reference instead of the target** — § Structure Reference and § Skeleton are the payload; generate from them and leave them intact.
- **Splitting this content into a companion file** — reference material a skill needs must live in the skill's own `SKILL.md` or in another skill loaded by name; a companion file beside a `SKILL.md` is not reliably readable at runtime — this concerns the skill's own reference material; the *persisted* architecture document is deliberately multi-file.

## Structure Reference

> **Yggdrasil:** this table is original content of this repository. The arc42 section numbers and titles are arc42's vocabulary; the subsection inventory, the one-line descriptions, and this table's form are not part of the arc42 template, and the descriptions reproduce none of its guidance text.

The section indices are generated from this table: the H1 from the section heading, the one-line description verbatim from the last column. The subsection column is the structure the drafting step is expected to use inside a section; it is reference only — you never write a subsection heading anywhere.

| § | Section heading | Subsections | One-line description (the section index's third line) |
| --- | --- | --- | --- |
| 1 | `1. Introduction and Goals` | 1.1 Requirements Overview · 1.2 Quality Goals · 1.3 Stakeholders | What this system must achieve, the ranked quality goals every decision is judged against, and who cares about the outcome. |
| 2 | `2. Architecture Constraints` | — | What the architecture is not free to choose: technology mandates, platform floors, regulatory rules, team conventions, existing contracts. |
| 3 | `3. Context and Scope` | 3.1 Business Context · 3.2 Technical Context | The system's boundary: the external actors and neighbouring systems it exchanges information with, and the channels that carry it. |
| 4 | `4. Solution Strategy` | — | The shape of the solution in half a page: the technology choices, the decomposition approach, and the tactic adopted per quality goal. |
| 5 | `5. Building Block View` | 5.1 Whitebox Overall System (with 5.1.\<n\> Blackbox \<Building Block\>) · 5.2 Level 2 · 5.3 Level 3 | The static decomposition: what the system is made of, level by level, and what each block provides and requires. |
| 6 | `6. Runtime View` | 6.\<n\> \<Scenario name\> | How the building blocks collaborate at runtime, one scenario per flow that matters, including its error path. |
| 7 | `7. Deployment View` | — | The infrastructure the system runs on: the nodes and runtimes, and what is deployed where. |
| 8 | `8. Cross-cutting Concepts` | 8.\<n\> \<Concept name\> | The concepts that cut across building blocks: error handling, persistence, security, validation, logging, transactions, testing. |
| 9 | `9. Architecture Decisions` | — | The decision log — one row per architecturally significant decision, with its full record beside it in this folder. |
| 10 | `10. Quality Requirements` | 10.1 Quality Requirements Overview · 10.2 Quality Scenarios | The quality goals made measurable: scenarios with a stimulus, a response, and a measure carrying a number and a unit. |
| 11 | `11. Risks and Technical Debts` | — | The risks this system carries and the debts it has taken on, each with a mitigation or an explicit acceptance. |
| 12 | `12. Glossary` | — | The terms this document uses, and the ones the project and its requirements use differently. |

Appendix headings the drafting step adds to its Workfile — `Appendix A — Architecture Decision Records`, `Appendix B — Work Packages`, `Appendix C — Traceability`, `Appendix D — Layout Map` — have **no folder and no index**. Appendix A is the source of the records in `09-architecture-decisions/`; B, C, and D are never persisted.

## Skeleton

**Reference material — never output.** Everything below the horizontal rule — the twelve sections, their subsections, and arc42's own guidance for each — is **never copied anywhere**: not into a Workfile, not into the target project. Read it when a reviewer or a maintainer asks what arc42's guidance for a section says; generate everything you write from § Structure Reference and § The Persisted Layout above.

---

> **Yggdrasil:** heading-level convention, for anyone consulting this reference. The heading immediately below is the architecture document's own title: it belongs at top-level `#`, and appears as `##` here only because this file nests it under its own top-level title. Every other heading — sections 1–12, their subsections, and Appendices A–C — is already at the level a produced document requires. An agent authoring an architecture Workfile applies that single promotion when it builds the document's structure from § Structure Reference; this block itself is not copied there.

## \<System / Subsystem\> — Architecture (arc42)

- **Status:** Proposed
- **Date:** \<YYYY-MM-DD\>
- **Document scope:** \<seed | update delta\>
- **Section scope:** included=\<…\>, omitted=\<…\>

> **Yggdrasil:** in *update delta* mode, add the header line `- **Existing document:** <path> (<directory index README.md | legacy single file | non-arc42>)` naming what this delta merges into, and list the sections it replaces.

## 1. Introduction and Goals

**arc42 guidance §1** — arc42-original text, CC BY-SA 4.0:

```text
Describes the relevant requirements and the driving forces that software 
architects and development team must consider. These include

* underlying business goals, 
* essential features, 
* essential functional requirements, 
* quality goals for the architecture and
* relevant stakeholders and their expectations
```

### 1.1 Requirements Overview

**arc42 guidance §1.1** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Short description of the functional requirements, driving forces, extract (or abstract)
of requirements. Link to (hopefully existing) requirements documents
(with version number and information where to find it).

Motivation:
From the point of view of the end users a system is created or modified to
improve support of a business activity and/or improve the quality.

Form:
Short textual description, probably in tabular use-case format.
If requirements documents exist this overview should refer to these documents.

Keep these excerpts as short as possible. Balance readability of this document with potential redundancy w.r.t to requirements documents.
```

> **Yggdrasil:** the objective in three to five lines — what changes and for whom. List the acceptance criterion IDs in scope; do not restate the requirements themselves.

### 1.2 Quality Goals

**arc42 guidance §1.2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The top three (max five) quality goals for the architecture whose fulfillment is of highest importance to the major stakeholders. 
We really mean quality goals for the architecture. Don't confuse them with project goals.
They are not necessarily identical.

Consider this overview of potential topics (based upon the ISO 25010 standard):

[image: Categories of Quality Requirements]

Motivation:
You should know the quality goals of your most important stakeholders, since they will influence fundamental architectural decisions. 
Make sure to be very concrete about these qualities, avoid buzzwords.
If you as an architect do not know how the quality of your work will be judged...

Form:
A table with quality goals and concrete scenarios, ordered by priorities
```

> **Yggdrasil:** the top three to five quality goals, ranked. These are the evaluation criteria for every decision in §9 and the source of the scenarios in §10. Motivate each from this objective, not from generic virtue.

| Rank | Quality goal | Motivation for this change | Scenario hint |
| --- | --- | --- | --- |

### 1.3 Stakeholders

**arc42 guidance §1.3** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Explicit overview of stakeholders of the system, i.e. all person, roles or organizations that

* should know the architecture
* have to be convinced of the architecture
* have to work with the architecture or with code
* need the documentation of the architecture for their work
* have to come up with decisions about the system or its development

Motivation:
You should know all parties involved in development of the system or affected by the system.
Otherwise, you may get nasty surprises later in the development process.
These stakeholders determine the extent and the level of detail of your work and its results.

Form:
Table with role names, person names, and their expectations with respect to the architecture and its documentation.
```

> **Yggdrasil:** include only when this change alters who is affected or what they expect. Otherwise mark it omitted.

| Role | Expectations of this change |
| --- | --- |

## 2. Architecture Constraints

**arc42 guidance §2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Any requirement that constraints software architects in their freedom of design and implementation decisions or decision about the development process. These constraints sometimes go beyond individual systems and are valid for whole organizations and companies.

Motivation:
Architects should know exactly where they are free in their design decisions and where they must adhere to constraints.
Constraints must always be dealt with; they may be negotiable, though.

Form:
Simple tables of constraints with explanations.
If needed you can subdivide them into
technical constraints, organizational and political constraints and
conventions (e.g. programming or versioning guidelines, documentation or naming conventions)
```

> **Yggdrasil:** what you are not free to choose — technology mandates, platform and version floors, regulatory rules, team conventions, existing contracts you must honor. Constraints bound the options tables in §9. One line each; omit the section if nothing constrains this change.

## 3. Context and Scope

**arc42 guidance §3** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Context and scope - as the name suggests - delimits your system (i.e. your scope) from all its communication partners
(neighboring systems and users, i.e. the context of your system). It thereby specifies the external interfaces.

If necessary, differentiate the business context (domain specific inputs and outputs) from the technical context (channels, protocols, hardware).

Motivation:
The domain interfaces and technical interfaces to communication partners are among your system's most critical aspects. Make sure that you completely understand them.

Form:
Various options:

* Context diagrams
* Lists of communication partners and their interfaces.
```

### 3.1 Business Context

**arc42 guidance §3.1** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Specification of *all* communication partners (users, IT-systems, ...) with explanations of domain specific inputs and outputs or interfaces.
Optionally you can add domain specific formats or communication protocols.

Motivation:
All stakeholders should understand which data are exchanged with the environment of the system.

Form:
All kinds of diagrams that show the system as a black box and specify the domain interfaces to communication partners.

Alternatively (or additionally) you can use a table.
The title of the table is the name of your system, the three columns contain the name of the communication partner, the inputs, and the outputs.
```

> **Yggdrasil:** the external actors and neighboring systems this change touches, and the information exchanged with each. A `flowchart` with the system as one box and the actors around it is usually enough.

### 3.2 Technical Context

**arc42 guidance §3.2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Technical interfaces (channels and transmission media) linking your system to its environment. In addition a mapping of domain specific input/output to the channels, i.e. an explanation which I/O uses which channel.

Motivation:
Many stakeholders make architectural decision based on the technical interfaces between the system and its context. Especially infrastructure or hardware designers decide these technical interfaces.

Form:
E.g. UML deployment diagram describing channels to neighboring systems,
together with a mapping table showing the relationships between channels and input/output.
```

> **Yggdrasil:** the channels, protocols, and formats behind §3.1 — map each business exchange to its technical carrier. Omit when no external interface changes.

## 4. Solution Strategy

**arc42 guidance §4** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
A short summary and explanation of the fundamental decisions and solution strategies, that shape system architecture. It includes

* technology decisions
* decisions about the top-level decomposition of the system, e.g. usage of an architectural pattern or design pattern
* decisions on how to achieve key quality goals
* relevant organizational decisions, e.g. selecting a development process or delegating certain tasks to third parties.

Motivation:
These decisions form the cornerstones for your architecture. They are the foundation for many other detailed decisions or implementation rules.

Form:
Keep the explanations of such key decisions short.

Motivate what was decided and why it was decided that way,
based upon problem statement, quality goals and key constraints.
Refer to details in the following sections.
```

> **Yggdrasil:** the shape of the solution in half a page — the technology choices, the decomposition approach, and the tactic adopted for each §1.2 quality goal. Summarize decisions and cross-reference their ADR IDs; the reasoning lives in the ADRs, not here.

## 5. Building Block View

**arc42 guidance §5** — arc42-original text, CC BY-SA 4.0:

```text
Content:
The building block view shows the static decomposition of the system into building blocks (modules, components, subsystems, classes, interfaces, packages, libraries, frameworks, layers, partitions, tiers, functions, macros, operations, data structures, ...) as well as their dependencies (relationships, associations, ...)

This view is mandatory for every architecture documentation.
In analogy to a house this is the _floor plan_.

Motivation:
Maintain an overview of your source code by making its structure understandable through
abstraction.

This allows you to communicate with your stakeholder on an abstract level without disclosing implementation details.

Form:
The building block view is a hierarchical collection of black boxes and white boxes
(see figure below) and their descriptions.

[image: Hierarchy of building blocks]

*Level 1* is the white box description of the overall system together with black
box descriptions of all contained building blocks.

*Level 2* zooms into some building blocks of level 1.
Thus it contains the white box description of selected building blocks of level 1, together with black box descriptions of their internal building blocks.

*Level 3* zooms into selected building blocks of level 2, and so on.
```

### 5.1 Whitebox Overall System

**arc42 guidance §5.1** — arc42-original text, CC BY-SA 4.0:

```text
Here you describe the decomposition of the overall system using the following white box template. It contains

 * an overview diagram
 * a motivation for the decomposition
 * black box descriptions of the contained building blocks. For these we offer you alternatives:

   ** use _one_ table for a short and pragmatic overview of all contained building blocks and their interfaces
   ** use a list of black box descriptions of the building blocks according to the black box template (see below).
   Depending on your choice of tool this list could be sub-chapters (in text files), sub-pages (in a Wiki) or nested elements (in a modeling tool).


 * (optional:) important interfaces, that are not explained in the black box templates of a building block, but are very important for understanding the white box.
Since there are so many ways to specify interfaces why do not provide a specific template for them.
 In the worst case you have to specify and describe syntax, semantics, protocols, error handling,
 restrictions, versions, qualities, necessary compatibilities and many things more.
In the best case you will get away with examples or simple signatures.
```

> **Yggdrasil:** one Mermaid diagram of the system, or of the affected subsystem when the change is local, plus the motivation for this decomposition and a table of the blocks it contains.

| Building block | Responsibility | Changed by this objective? |
| --- | --- | --- |

#### 5.1.\<n\> Blackbox \<Building Block\>

> **Yggdrasil:** one blackbox entry per building block this change touches. Interfaces must carry signatures, parameter and return types, error and failure contracts, and schema or migration changes — enough to write a failing test without opening the implementation.

- **Purpose / responsibility:** …
- **Provided interfaces:** …
- **Required interfaces:** …
- **Quality characteristics:** … (only when a §1.2 goal depends on this block)
- **Location:** \<path in the repository\>
- **Fulfilled acceptance criteria:** \<AC IDs\>
- **Open issues:** …

### 5.2 Level 2

**arc42 guidance §5.2** — arc42-original text, CC BY-SA 4.0:

```text
Here you can specify the inner structure of (some) building blocks from level 1 as white boxes.

You have to decide which building blocks of your system are important enough to justify such a detailed description.
Please prefer relevance over completeness. Specify important, surprising, risky, complex or volatile building blocks.
Leave out normal, simple, boring or standardized parts of your system
```

> **Yggdrasil:** refine only the blocks this change alters internally. Depth is earned by change, not by symmetry — do not decompose a block you are not touching.

### 5.3 Level 3

**arc42 guidance §5.3** — arc42-original text, CC BY-SA 4.0:

```text
Here you can specify the inner structure of (some) building blocks from level 2 as white boxes.

When you need more detailed levels of your architecture please copy this
part of arc42 for additional levels.
```

## 6. Runtime View

**arc42 guidance §6** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The runtime view describes concrete behavior and interactions of the system's building blocks in form of scenarios from the following areas:

* important use cases or features: how do building blocks execute them?
* interactions at critical external interfaces: how do building blocks cooperate with users and neighboring systems?
* operation and administration: launch, start-up, stop
* error and exception scenarios

Remark: The main criterion for the choice of possible scenarios (sequences, workflows) is their *architectural relevance*. It is *not* important to describe a large number of scenarios. You should rather document a representative selection.

Motivation:
You should understand how (instances of) building blocks of your system perform their job and communicate at runtime.
You will mainly capture scenarios in your documentation to communicate your architecture to stakeholders that are less willing or able to read and understand the static models (building block view, deployment view).

Form:
There are many notations for describing scenarios, e.g.

* numbered list of steps (in natural language)
* activity diagrams or flow charts
* sequence diagrams
* BPMN or EPCs (event process chains)
* state machines
* ...
```

> **Yggdrasil:** one subsection per scenario, typically one to three: the critical flow, plus any scenario a §1.2 quality goal hinges on. A `sequenceDiagram` and a few lines of notes, naming the acceptance criterion IDs realized and the error path taken.

### 6.\<n\> \<Scenario name\>

## 7. Deployment View

**arc42 guidance §7** — arc42-original text, CC BY-SA 4.0:

```text
Content:
The deployment view describes:

 1. technical infrastructure used to execute your system, with infrastructure elements like geographical locations, environments, computers, processors, channels and net topologies as well as other infrastructure elements and

2. mapping of (software) building blocks to that infrastructure elements.

Often systems are executed in different environments, e.g. development environment, test environment, production environment. In such cases you should document all relevant environments.

Especially document a deployment view if your software is executed as distributed system with more than one computer, processor, server or container or when you design and construct your own hardware processors and chips.

From a software perspective it is sufficient to capture only those elements of an infrastructure that are needed to show a deployment of your building blocks. Hardware architects can go beyond that and describe an infrastructure to any level of detail they need to capture.

Motivation:
Software does not run without hardware.
This underlying infrastructure can and will influence a system and/or some
cross-cutting concepts. Therefore, there is a need to know the infrastructure.

Form:
Maybe a highest level deployment diagram is already contained in section 3.2. as
technical context with your own infrastructure as ONE black box. In this section one can
zoom into this black box using additional deployment diagrams:

* UML offers deployment diagrams to express that view. Use it, probably with nested diagrams,
when your infrastructure is more complex.
* When your (hardware) stakeholders prefer other kinds of diagrams rather than a deployment diagram, let them use any kind that is able to show nodes and channels of the infrastructure.
```

> **Yggdrasil:** infrastructure level 1 — nodes, runtimes, and what is deployed where — as a `flowchart` with subgraphs. Include only when infrastructure, topology, or the deployment procedure changes; otherwise mark it omitted.

## 8. Cross-cutting Concepts

**arc42 guidance §8** — arc42-original text, CC BY-SA 4.0:

```text
Content:
This section describes crosscutting concepts (practices, patterns, regulations or solution ideas).
Such concepts are often related to multiple building blocks. 
They may include many different topics, such as the topics shown in the following diagram:

[image: Possible topics for crosscutting concepts]

Motivation:
Concepts form the basis for _conceptual integrity_ (consistency, homogeneity) of the architecture. 
Thus, they are an important contribution to achieve inner qualities of your system.

This is the place in the template that we provided for a cohesive specification of such concepts.

Many of these concepts relate to or influence several of your building blocks. 

Form:
The form can be varied:

* concept papers with any kind of structure
* example implementations,especially for technical concepts
* cross-cutting model excerpts or scenarios using notations of the architecture views

Structure:
Pick **only** the most-needed topics for your system and assign each a level-2 heading in this section (e.g. 8.1, 8.2 etc).

DO NOT ATTEMPT to cover all of the topics of the aforementioned diagram.
```

> **Yggdrasil:** one subsection per concept this change introduces or alters — error handling, persistence, security, validation, logging, transactions, testing approach. An unchanged concept belongs in the existing document, not in this delta.

### 8.\<n\> \<Concept name\>

## 9. Architecture Decisions

**arc42 guidance §9** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Important, expensive, large scale or risky architecture decisions including rationales.
With "decisions" we mean selecting one alternative based on given criteria.

Please use your judgement to decide whether an architectural decision should be documented
here in this central section or whether you better document it locally
(e.g. within the white box template of one building block).

Avoid redundancy. 
Refer to section 4, where you already captured the most important decisions of your architecture.

Motivation:
Stakeholders of your system should be able to comprehend and retrace your decisions.

Form:
Various options:

* ADR (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions[Documenting Architecture Decisions]) for every important decision
* List or table, ordered by importance and consequences or:
* more detailed in form of separate sections per decision
```

> **Yggdrasil:** in the AsciiDoc original, `ADR` above is followed by a hyperlink whose label is "Documenting Architecture Decisions" — Michael Nygard's blog post. The acronym is not expanded in the arc42 source.
>
> **Yggdrasil:** the decision log. One row per architecturally significant decision, with a one-line summary beneath each row. Full reasoning lives in the ADR itself — link, do not duplicate. New decisions are `Proposed` until ratified. The `Link` column carries the ADR's appendix anchor in the Workfile (`#adr-nnnn-…`); the persistence step rewrites it to the decision file's relative path.

| ID | Title | Status | Date | Link |
| --- | --- | --- | --- | --- |
| ADR-\<NNNN\> | \<decision title\> | Proposed | \<YYYY-MM-DD\> | \<appendix anchor\> |

## 10. Quality Requirements

**arc42 guidance §10** — arc42-original text, CC BY-SA 4.0:

```text
Content:
This section contains all relevant quality requirements. 

The most important of these requirements  have already been described in section 1.2. (quality goals), therefore they should only be referenced here.
In this section 10 you should also capture quality requirements with lesser importance, which will not create high risks when they are not fully achieved (but might be _nice-to-have_).

Motivation:
Since quality requirements will have a lot of influence on architectural decisions you should know  what qualities are really important for your stakeholders, in a specific and measurable way.
```

### 10.1 Quality Requirements Overview

**arc42 guidance §10.1** — arc42-original text, CC BY-SA 4.0:

```text
Content:
An overview or summary of quality requirements. 

Motivation:
Often we encounter dozens (or even hundreds) of detailed quality requirements. 
In this overview section you should try to summarize, e.g. by describing categories or topics (as suggested by https://www.iso.org/obp/ui/#iso:std:iso-iec:25010:ed-2:v1:en[ISO 25010:2023] or https://quality.arc42.org[Q42])

If these summary descriptions are already precise, specific enough and measurable, you may skip section 10.2.

Form:
Use a simple table in which each line contains a category or topic and a short description of the quality requirement.
Alternatively, you may use a mindmap to structure these quality requirements.
In literature, the idea of a _quality attribute tree_ has also been described, which puts the generic term "quality" as the root and uses a tree-like refinement of the term "quality". 
[Bass+21] introduced the term "Quality Attribute Utility Tree" for this purpose.
```

> **Yggdrasil:** optional. Useful when more than five scenarios need organizing; for a bounded change, mark it omitted and go straight to §10.2.

### 10.2 Quality Scenarios

**arc42 guidance §10.2** — arc42-original text, CC BY-SA 4.0:

```text
Content:
Quality scenarios make quality requirements concrete and allow to decide whether they are fulfilled (in the sense of acceptance criteria).
Ensure that your scenarios are specific and measurable.

Two kinds of scenarios are especially useful:

* _Usage scenarios_ (also called application scenarios or use case scenarios) describe the system's runtime reaction to a certain stimulus. 
This also includes scenarios that describe the system's efficiency or performance. 
Example: The system reacts to a user's request within one second.
* _Change scenarios_ describe the desired effect of a modification or extension of the system or of its immediate environment. 
Example: Additional functionality is implemented or requirements for a quality attribute change, and the effort or duration of the change is measured.

Form:

Typical information for detailed scenarios include the following:

In short form (favoured in the Q42 model):

* **Context/Background**: What kind of system or component, what is the envirionment or situation?
* **Source/Stimulus**: Who or what initiates or triggers a behaviour, reaction or action.
* **Metric/Acceptance Criteria**: A response including a _measure_ or _metric_

The long form of scenarios (favoured by the SEI and [Bass+21]) is more detailed and includes the following information:

* **Scenario ID**: A unique identifier for the scenario.
* **Scenario Name**: A short, descriptive name for the scenario.
* **Source**: The entity (user, system, or event) that initiates the scenario.
* **Stimulus**: The triggering event or condition the system must address.
* **Environment**: The operational context or condition under which the system experiences the stimulus.
* **Artifact**: The building-blocks or other elements of the system affected by the stimulus.
* **Response**: The outcome or behavior the system exhibits in reaction to the stimulus.
* **Response Measure**: The criteria or metric by which the system's response is evaluated.

Examples:
See https://quality.arc42.org[the Q42 quality model website] for detailed examples of quality requirements.

Further Information:

* Len Bass, Paul Clements, Rick Kazman: "Software Architecture in Practice", 4th Edition, Addison-Wesley, 2021.
```

> **Yggdrasil:** one to three scenarios per §1.2 quality goal. The measure carries a number and a unit — these become the candidate non-functional tests.

| ID | Quality goal | Stimulus | Response | Measure |
| --- | --- | --- | --- | --- |

## 11. Risks and Technical Debts

**arc42 guidance §11** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
A list of identified technical risks or technical debts, ordered by priority

Motivation:
"Risk management is project management for grown-ups" (Tim Lister, Atlantic Systems Guild.) 

This should be your motto for systematic detection and evaluation of risks and technical debts in the architecture, which will be needed by management stakeholders (e.g. project managers, product owners) as part of the overall risk analysis and measurement planning.

Form:
List of risks and/or technical debts, probably including suggested measures to minimize, mitigate or avoid risks or reduce technical debts.
```

> **Yggdrasil:** what this change introduces or retires. Each entry gets either a mitigation or an explicit acceptance — "known and accepted" is a valid outcome; silence is not.

| Risk / debt | Impact | Likelihood | Mitigation or acceptance |
| --- | --- | --- | --- |

## 12. Glossary

**arc42 guidance §12** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The most important domain and technical terms that your stakeholders use when discussing the system.

You can also see the glossary as source for translations if you work in multi-language teams.

Motivation:
You should clearly define your terms, so that all stakeholders

* have an identical understanding of these terms
* do not use synonyms and homonyms

Form:

A table with columns <Term> and <Definition>.

Potentially more columns in case you need translations.
```

> **Yggdrasil:** only terms this change introduces or redefines. Mark a term the codebase and the requirements use differently — that disagreement is a defect to surface.

| Term | Definition |
| --- | --- |

---

*Appendices A–C are original content of this repository. arc42 has no appendices; these are not part of the arc42 template.*

## Appendix A — Architecture Decision Records

> **Yggdrasil:** full ADR text, one per decision logged in §9, in the format the skill defines (Title · Status · Date · Context · Options Considered · Decision · Consequences · Related). At least two genuinely distinct options per decision, scored against the §1.2 quality goals. *Workfile content — split into separate decision-record files under the project's decision directory on persistence.*

## Appendix B — Work Packages

> **Yggdrasil:** one row per package, each a vertical slice that delivers observable behavior. Shared-surface churn (dependency-injection registration, route tables, migrations, lockfiles, generated code, shared fixtures) belongs to a single sequential scaffold package that runs before any parallel wave. *Workfile content — not persisted.*

| Package | Write set | Owned ACs | Contracts provided | Contracts consumed | Test seam | Depends on | Done criterion |
| --- | --- | --- | --- | --- | --- | --- | --- |

```text
Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
```

## Appendix C — Traceability

> **Yggdrasil:** one row per acceptance criterion in scope — exactly one owning package each. A missing row is a coverage hole; two packages on one row is a write-set collision. *Workfile content — not persisted.*

| AC | Building block(s) | ADR(s) | Package |
| --- | --- | --- | --- |

