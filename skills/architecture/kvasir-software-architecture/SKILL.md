---
name: kvasir-software-architecture
description: Author an arc42 architecture Workfile in one of two modes, selected by a Mode line in the brief — deciding new architecture for a bounded objective, or recording an existing system as-is and proposing nothing — quality goals first, pruned to the affected sections, with separate architecture decision records logged in section 9, a layout map assigning every heading to its persisted document and, when deciding, a work-package breakdown for test-driven implementation.
---

# Software Architecture

## Purpose

Produce the architecture of one bounded objective as an arc42-structured Workfile — either by **deciding** it, or by **recording as-is** the architecture the system already has. In the deciding mode you fix structure and contracts and the test-first implementation phase decides the code inside them; in the recording mode you describe the structure and contracts that exist, from cited evidence, and propose nothing.

**You author the Workfile; you do not derive the target's mechanical facts.** The brief carries the scaffold step's `Scaffold result:` line and the path of the Workfile to **create**. That line gives you the target's path, the structure action, the shape, the document scope, the existing document's path, and the next decision-record number — the repository lookup that establishes all of it has already happened, and the target project already holds the scaffolded section folders your Appendix D maps onto. § Document Shape gives you the headings to write; § Layout Map gives you the projection onto those folders.

Your single Workfile carries five parts:

- **arc42 §1–§12**, scoped by workflow step 3 — to the sections this objective affects when deciding, to every section the evidence supports when recording — with every omitted section retained as a heading plus an omission marker.
- **Appendix A** — the full text of one architecture decision record (ADR) per architecturally significant decision, whether you decided it or recorded it as-is.
- **Appendix B** — the work-package breakdown plus the `Package check:` verdict, which determines whether implementation runs sequentially or in parallel; `_Not applicable — document-existing mode_` when recording.
- **Appendix C** — traceability: acceptance criterion → building block(s) → ADR(s) → work package; likewise not applicable when recording.
- **Appendix D** — the layout map: every heading → the persisted document that will carry it → its promotion distance. It is how the persistence step fills the scaffolded folders without judgment of its own.

**Two modes, selected by the brief's `Mode:` line. An absent line means `decide-new`.**

- **`Mode: decide-new`** — forward-looking. You choose between options, write one decision record per architecturally significant choice, and break the work into packages. Appendices A, B, and C are all yours; Appendix D is written in both modes.
- **`Mode: document-existing`** — as-is. You record what the system *is*, every claim citing a path from the context Workfile; existing decisions become decision records marked `Kind: as-is`; there are no work packages and no traceability appendix, and **you propose nothing**.

The mode is also a header field you write into the Workfile — `- **Mode:** <mode> (source: <direction | inference>)` — copied from the brief, never re-decided. Echo it in your report: if the mode looks wrong for the inputs you were given, say so to the requesting agent instead of switching.

**Two document scopes, read from the `Scaffold result:` line's `document-scope=` field, not decided by you:**

- **seed** — the project has no architecture document. You write the in-scope sections from scratch.
- **update delta** — one exists; its path and shape are in the result line's `existing=` and `shape=` fields. You write only the sections this objective changes, as a delta the persistence step merges document-by-document into the existing architecture directory (or section-by-section into a legacy single-file document). Update delta applies in both modes: a document-existing run over an existing arc42 directory is a refresh delta.

**Decisions are definite.** Each ADR names exactly one recommended option and states it in the indicative, not as a menu. You advise and the requesting agent ratifies, so every ADR and the document header ship with `Status: Proposed`; ratification happens at the requesting agent's ratification checkpoint and promotion to `Status: Accepted` happens only at the persistence step — neither is yours. A hedged recommendation forces the ratifier to redo your analysis.

## Boundaries

**The long-term-relevance test.** One rule decides what may stand in §1–§12, and it holds in both modes, in both document scopes, and in every one of the twelve sections. It is stated here once; the context-gathering step and the design-review gate apply this same test under this same name:

> A statement belongs in §1–§12 only if it would still be true and useful to a reader of the persisted document after the triggering task is complete: it describes a boundary, an interface, a decision and its rationale, a quality goal, a stable mechanism, or a risk to the system. A statement about how this run was performed, what one work package does inside a block, a temporary measure, or anything that resolves only inside the task's workspace is task-scoped: it belongs in Appendix B or C, in the report, or nowhere.

**Tell-tales of task-scoped content** — the patterns that fail the test. The design review reads the document against this same list, so a section you cleared against it is a section that clears the gate:

- workspace paths of the form `.yggdrasil-workspace/<yyyymmdd>-…`, task directory names, and Workfile filenames;
- a review verdict, or a reviewer, cited as provenance of this document — a verdict quoted as doctrine the system embodies is not a tell-tale;
- revision logs, contradiction logs, and inputs logs;
- run provenance phrased as time: "at the time of writing", "in this run";
- work-package names or sequencing;
- feature flags, rollout steps, temporary workarounds, and sprint- or task-specific test-harness setup;
- internal helper structure, local control flow, naming inside a block, test-case selection;
- run-local identifiers not defined in §1.1.

A statement that fails the test is not lost — it is **relocated**: into Appendix B or C, into the report, or, when it genuinely constrains future work, promoted into a decision (§9) or a risk (§11) stated in durable terms. Deciding to relocate is a judgment you record, not one you make silently: every omission and every deliberate thinning is named in the report's `Scope rationale:`.

- Never write `Status: Accepted` on the document or on any ADR. `Proposed` is the only status you author, for a new decision and for an as-is one alike.
- **Never propose a change in `Mode: document-existing`.** An improvement idea goes to §11 as technical debt with its evidence — never into §4, never into §9, never into an ADR. A document that mixes the architecture that exists with the architecture someone would prefer is unusable as a baseline, and the reviewer blocks on it.
- **Never create or modify a project file.** Your only written output is the single Workfile the brief names, in the workspace. The scaffolded section folders, the topic documents, and the decision-record files are written into the project by the persistence step, not by you — you read the target, you never touch it.
- Never overwrite a file that already exists at the Workfile path. Ask the requesting agent for the path to use and write nothing until it answers.
- Never re-derive what the `Scaffold result:` line already resolved — the target path, the structure action, the shape, the document scope, or `next-adr`. A field that contradicts what you read is a report item, not a correction.
- Never renumber, rename, or delete a heading § Document Shape fixes. A section this objective does not reach keeps its heading and gets a marker.
- Never run a substantive investigation to close a knowledge gap. Spot-check the codebase to confirm structure you were given, then **report the gap** — an unreported gap becomes an invented building block.
- Never put a building block, an interface, or a file path in §5 that you did not verify against the codebase or against an input Workfile. Cite the path.
- Never present a decision with one option in `Mode: decide-new`. If no second option survives a sentence of analysis, the decision is a constraint — record it in §2 and say so. In `Mode: document-existing` there are no options at all: an as-is record states the decision in force and cites its evidence.
- Never decide implementation minutiae the implementation phase owns: internal helper structure, local control flow, naming inside a building block, test case selection.
- **Never put a run-local reference in §1–§12.** A persisted section cites only **document-stable references**: repository paths (with optional `:line` ranges), section and subsection numbers of this document, decision-record IDs, and requirement IDs that §1.1 of this document defines. Workspace paths, task directories, Workfile names, review verdicts, and revision entries belong in Appendices B–D and in the report, and nowhere else. The Workfile's acceptance-criterion IDs (`AC-n`) never appear in §1–§12 either: they resolve only against one task's inputs, and a later objective's `AC-3` is a different criterion.
- Never fill an arc42 section because § Document Shape lists it. The inclusion criterion is relevance to *this* objective in `Mode: decide-new`, and cited evidence in `Mode: document-existing`; a section that meets neither gets its marker, not filler.

## When to Use

- Dispatched as the drafting step of the architecture workflow, after the scaffold step has acted on the target project, with that step's `Scaffold result:` line and the path of the Workfile to create in the brief.

**`Mode: decide-new` fires when:**

- The objective introduces components, modules, or services, or changes something that crosses an existing module boundary.
- The objective adds an integration, a persistence mechanism, a schema change, or an external dependency.
- Two or more viable structural approaches exist with material trade-offs between them.
- Quality goals or non-functional requirements drive the design rather than following it.
- Two or more candidate work packages need shared contracts that do not already exist in the codebase — the split itself is an architecture decision.
- Design, architecture, an ADR, or arc42 documentation was explicitly asked for.

**`Mode: document-existing` fires when:**

- An as-is record of the architecture was asked for — "document the architecture", "how is this system structured", an arc42 document of what exists.
- A reviewed, system-scoped context Workfile exists to cite from, with or without a user focus narrowing it to a subsystem.
- No change is proposed by the objective. A request that names a change belongs in `decide-new`, whichever words it uses.

**Boundaries of the dispatch:**

- **Not for** a change that fits the existing structure and local patterns and that one work package covers; say so in one line rather than producing a document.
- **Not without a `Scaffold result:` line.** If the brief carries none, or it is missing `document-scope=`, `shape=`, or `next-adr=`, report it and stop — re-deriving those facts here would duplicate the scaffold step and diverge from it.
- **Not for** classifying the target's shape, resolving the target location, or finding the next decision-record number. Those answers are in the `Scaffold result:` line.
- **Not for** writing anything into the target project. You mirror the scaffolded folders in Appendix D; the persistence step is what fills them.

## Document Shape

The Workfile's headings are fixed. You write them all, at these levels, in this order, whichever mode you are in — you decide what goes under a heading, never whether the heading exists.

The title is `# <System / Subsystem> — Architecture (arc42)`, followed by the header block:

```text
- **Status:** Proposed
- **Date:** <YYYY-MM-DD>
- **Document scope:** <seed | update delta>
- **Mode:** <document-existing | decide-new> (source: <direction | inference>)
- **Scaffold:** <target path> (structure: <created | verified | extended>)
- **Existing document:** <path> (<shape>)
- **Section scope:** included=<§N[, §N …]>, omitted=<§N (scope | evidence | unaffected)[, §N (…) …]>
```

Each field has exactly one source: `Status` is always `Proposed`; `Date` is today; `Document scope`, `Scaffold`, and `Existing document` are copied from the `Scaffold result:` line's `document-scope=`, `target=`/`structure=`, and `existing=`/`shape=` fields; `Mode` is copied from the brief's `Mode:` line with the source the brief states; `Section scope` is your own verdict from workflow step 3. **`Existing document` appears if and only if the document scope is update delta.** Copy, never re-derive — the review blocks on a header that disagrees with the result line, and the persistence step trusts this header to find its target.

Then the twelve sections and the appendices:

| § | Section heading | Subsection headings | Section folder |
| --- | --- | --- | --- |
| 1 | `## 1. Introduction and Goals` | `### 1.1 Requirements Overview`, `### 1.2 Quality Goals`, `### 1.3 Stakeholders` | `01-introduction-and-goals/` |
| 2 | `## 2. Architecture Constraints` | — | `02-architecture-constraints/` |
| 3 | `## 3. Context and Scope` | `### 3.1 Business Context`, `### 3.2 Technical Context` | `03-context-and-scope/` |
| 4 | `## 4. Solution Strategy` | — | `04-solution-strategy/` |
| 5 | `## 5. Building Block View` | `### 5.1 Whitebox Overall System`, then one `#### 5.1.<n> Blackbox <Building Block>` per block, `### 5.2 Level 2`, `### 5.3 Level 3` | `05-building-block-view/` |
| 6 | `## 6. Runtime View` | one `### 6.<n> <Scenario name>` per scenario | `06-runtime-view/` |
| 7 | `## 7. Deployment View` | — | `07-deployment-view/` |
| 8 | `## 8. Cross-cutting Concepts` | one `### 8.<n> <Concept name>` per concept | `08-crosscutting-concepts/` |
| 9 | `## 9. Architecture Decisions` | — (the decision log table) | `09-architecture-decisions/` |
| 10 | `## 10. Quality Requirements` | `### 10.1 Quality Requirements Overview`, `### 10.2 Quality Scenarios` | `10-quality-requirements/` |
| 11 | `## 11. Risks and Technical Debts` | — | `11-risks-and-technical-debts/` |
| 12 | `## 12. Glossary` | — | `12-glossary/` |

| Appendix heading | Contents |
| --- | --- |
| `## Appendix A — Architecture Decision Records` | one `### ADR-NNNN: <title>` per decision, full text |
| `## Appendix B — Work Packages` | the package table and the `Package check:` verdict |
| `## Appendix C — Traceability` | the AC → §1.1 requirement ID → block → ADR → package table |
| `## Appendix D — Layout Map` | the map of § Layout Map |

Four mechanical rules govern the shape; everything else in this skill is judgment.

1. **Write or mark every heading — never drop one.** The twelve section headings, their fixed subsection headings, and the four appendix headings all appear, at the levels above. The variable subsections (`5.1.<n>`, `6.<n>`, `8.<n>`, `ADR-NNNN`) appear as many times as your content needs and no more.
2. **Mark every omitted heading with one of three fixed markers — the set is closed.** No other wording, no free-form reason, no marker of your own invention. The marker names the *type* of the omission; the reason for it travels in the report. Pick by document scope and mode:

   | Marker | Type | Used for |
   | --- | --- | --- |
   | `_Omitted — not architecturally significant for this objective_` | scope | seed scope, either mode: a section or subsection the objective's durable content does not reach; in update-delta scope: a subsection of an included section that the re-authored section leaves empty |
   | `_Omitted — no evidence in context Workfile_` | evidence | seed scope, `document-existing`: a section the evidence base does not cover; also for a subsection of an included section in an update-delta refresh |
   | `_Not affected by this change_` | unaffected | update-delta scope, either mode: a whole section the delta does not write — the persisted section stands as it is |

   The three types are what a later reader uses to tell a judgment ("considered, not architecturally significant") from a gap ("nobody had the evidence") from a no-op ("this delta did not touch it"), so a scope omission wearing the evidence marker misinforms exactly the reader the document exists for. The persistence step copies a **scope** or **evidence** marker verbatim into the section's index, and never writes the **unaffected** marker into the project tree — in update-delta scope the persisted section simply stands as it is.
3. **Write no template guidance and no attribution notice.** Every word in the Workfile is yours: no licensed template text ever enters it, so there is nothing to delete and no notice to keep. A notice in a document that carries no licensed text claims a share-alike license over your own prose.
4. **Resolve every placeholder.** Angle brackets (`<…>`) above mark fill-ins; a table row shown here is an example of shape, not a required count.

## Layout Map

Appendix D is the projection of your Workfile onto the section folders the scaffold step created. The persistence step copies by it without judgment, so the judgment — how many documents a section gets — is yours, made here, and reviewable before anything is written into the project.

**Split rule.** One document per section by default, named `01-<section-slug>.md`. Split a section only when it holds **three or more** units of its natural grain that a reader would consult independently *and* each is more than a short paragraph. Two units are one document; a section whose grain is one long narrative is one document.

| § | Natural grain when split | Default |
| --- | --- | --- |
| 5 | the whitebox overview, plus one document per building-block group a reader navigates to separately — a subsystem, a Level-2 whitebox, a family of related blackboxes | one document |
| 6 | one per scenario | one document |
| 8 | one per concept | one document |
| 9 | **always one record per decision** — fixed by the record format, never subject to the threshold | per record |
| 10 | overview versus scenarios | one document |
| 1, 2, 3, 4, 7, 11, 12 | one document unless the grain rule clearly applies | one document |

**Map format.** One row per document, in reading order, under the heading `## Appendix D — Layout Map`:

```markdown
| Workfile heading | Target path | Promotion |
| --- | --- | --- |
| `## 2. Architecture Constraints` (whole section) | `02-architecture-constraints/01-architecture-constraints.md` | 1 |
| `### 5.1 Whitebox Overall System` (own body) | `05-building-block-view/01-whitebox-overall-system.md` | 2 |
| `#### 5.1.1 Blackbox <Building Block>` | `05-building-block-view/02-<building-block>.md` | 3 |
| `### 5.2 Level 2`, `### 5.3 Level 3` | `→ index (omitted)` | — |
| `## 9. Architecture Decisions` (log table) | `09-architecture-decisions/README.md` (rows appended) | — |
| `### ADR-0016: <title>` | `09-architecture-decisions/0016-<slug>.md` | 2 |
```

Six rules make the map mechanical:

1. **One root per document.** A row maps exactly one heading plus every descendant of it that no other row maps. So `### 5.1`'s own body — intro, diagram, block table — can be one document while its `#### 5.1.<n>` children are carved out into theirs; the parent document then ends where the first carved-out child begins. **Never group siblings into one document**: two roots would mean two H1s. A drafter who wants "all the specialist blocks in one document" introduces a real intermediate heading in the Workfile, and that heading becomes the document's root.
2. **Totality — every heading exactly once.** Every heading below an included `## N.` is covered exactly once: by its own row, or by its nearest mapped ancestor. A heading in two rows and a heading in none are both defects the review blocks on. Walk each included section's headings in document order against the map once the last section is drafted; a section re-drafted after the map was written is re-walked.
3. **Paths — three row patterns, no others.** Every row that names a path uses exactly one of these; a path outside the three is a defect the review blocks on.
   - **(i) Topic document** — `<section folder>/NN-<slug>.md`: the folder from § Document Shape, `NN` two-digit and contiguous from `01` within that folder in map order, the slug the kebab-case of the row's root heading title. A section with one document uses the section slug: `01-<section-slug>.md`.
   - **(ii) Decision record** — `09-architecture-decisions/NNNN-<slug>.md`: four-digit, continuing from the `next-adr` value in the `Scaffold result:` line.
   - **(iii) The `## 9.` heading itself** — `09-architecture-decisions/README.md`, the one named exception. §9's body *is* the generated decision log, and your rows are appended into it; it is not a topic document and §9's folder never holds one.

   Two further row forms name **no** path and take no part in rule 2's totality walk, because neither produces a document: `→ index (omitted)` (rule 5), and — in update-delta scope only — the supersession row `| <existing document heading> | → superseded — <reason> | — |`, which retires a document already persisted in an included section. Its first column is that document's **existing** root heading, not a heading of this Workfile; the reason is one clause saying why the document is retired, and it is the only thing that authorizes the persistence step to list the file under "Superseded documents".
4. **Promotion matches the row pattern.** For a **topic document** it is the root heading's depth − 1: a `## N.` root promotes by 1, a `### N.m` root by 2, a `#### N.m.k` root by 3. For a **decision record** it is always `2` (an `### ADR-NNNN` under `## Appendix A`, which the depth rule also yields). For the **`## 9.` row** it is `—`: nothing is promoted, because nothing becomes a document — the log rows are appended into an index the persistence step generates. In the first two patterns the root becomes the document's H1 and its body moves the same distance. Write the number, not the resulting level.
5. **Omission has two forms, and silence has a third meaning.** A subsection carrying only an omission marker inside a **split** section gets the row `→ index (omitted)` and no document — the marker travels to the section index. In a **single-document** section the marker simply travels inside that one document and needs no row of its own. A whole section you marked omitted gets no rows at all; its folder stays index-only. Because `→ index (omitted)` rows produce no document, several such subsections may share one row — the one-root rule binds only rows that name a path.

   **Carry-forward (update-delta scope).** In update-delta scope the map is **document-granular**: it names only the documents this delta writes. A document already persisted in an **included** section that you give neither a path row nor a `→ superseded — <reason>` row is **carried forward byte-identical**: the persistence step does not open it, and it keeps its ordinal and its row in the regenerated section index. So every existing document of an included section is accounted for exactly one of three ways — re-authored by a path row, retired by a supersession row, or carried forward by having no row — and you list the carried-forward ones in the report's `Carried forward:` item so the reviewer can check that account against the section's folder. Read that folder's index before you map: you cannot retire, or knowingly carry forward, a document you never looked at. In **seed** scope there is nothing to carry forward, and a supersession row is a defect.
6. **Appendix D is Workfile content and is never persisted** — neither are Appendices B and C. Only §1–§12 and the Appendix A records reach the project tree.

## Workflow

1. **Read the brief, the result line, and the inputs; then open the Workfile.**
   - Read the brief's `Mode:` line — absent means `decide-new` — its `Scaffold result:` line, and the path of the Workfile to create. A file already at that path → ask the requesting agent and write nothing (§ Failure handling).
   - Read the `Scaffold result:` line field by field. It is ground truth: `target=` and `structure=` become the header's `Scaffold:` line, `document-scope=` the document scope, `shape=` and `existing=` the `Existing document:` line in update-delta scope, and `next-adr=` the number your records continue from. Do not re-derive any of it, and do not go looking for an architecture document or a decision-record directory yourself.
   - Read every input Workfile the brief names. In `decide-new` that is typically a requirements Workfile (acceptance criteria, ranked quality goals, non-functional targets, glossary) plus a context Workfile describing the current codebase. In `document-existing` it is a reviewed, **system-scoped** context Workfile plus any user focus narrowing it to a subsystem; that Workfile is the evidence base every block you write must cite.
   - In update-delta scope, read the existing document the result line names: its index (`README.md`), then always the §1, §4, §5, and §9 material, plus whatever this objective touches — not necessarily all twelve sections. Those are folders of topic documents in the current layout and single files in a flat legacy directory; a legacy single file or a non-arc42 document is read whole. A non-arc42 target also needs § Failure handling.
   - In update-delta scope the **refresh rule** governs every document you re-author: `A document this delta re-authors carries forward every durable statement of its persisted version and drops every task-scoped statement; each dropped statement is listed in the report under "Refreshed".` Read the persisted version against the long-term-relevance test as you go: a durable statement you fail to carry forward is content this delta destroys, and a task-scoped statement you copy forward is clutter this delta endorses. A document you do **not** re-author is carried forward untouched, is listed in the report under `Carried forward:`, and is not refreshed — you never edit a document this delta does not write.
   - Spot-check the codebase to confirm the structural claims you intend to build on: module boundaries, entry points, existing interfaces, test layout. Confirming is reading a handful of named files; investigating is not your task. Read the target only to understand it — never write there.
   - Record every structural question you could not answer by reading your inputs and spot-checking as an **investigation gap**, and carry it into the report. Add a gap for any `Scaffold result:` field that contradicts what you read — report the contradiction; copy the field as given.

2. **Establish the quality goals first.** Adopt the ranked top 3–5 quality goals from the requirements Workfile verbatim into §1.2. If no requirements Workfile exists, derive 3–5 from the objective, rank them, and state the derivation basis in one line so the ratifier can challenge it. These goals are not decoration: they are the evaluation columns of every options table in step 4, the tactics §4 must name, and the source of the §10 quality scenarios. Everything you write in §4, §9, and §10 points back to §1.2.
   - In `Mode: document-existing` there is no requirements Workfile to adopt from. **Infer** 3–5 ranked goals from the evidence — what the existing structure, its tests, its error handling, and its dependencies were evidently optimized for — and mark each one inferred, citing the paths that suggest it. §1.1 then states the **documented scope** (the system, or the subsystem the focus names) and the evidence base it was written from, in place of the acceptance criteria a decide-new run references. **The evidence-base statement names repository paths and a date — never a Workfile path, a task directory, or a review verdict.** The long-term-relevance test applies here exactly as it does in `decide-new`: an as-is record accumulates run provenance faster than a forward-looking one, because the temptation is to write down how the description was produced rather than what the system is.

3. **Choose the section scope, then record it.**
   - In `Mode: decide-new`, include a section only when this objective affects it **and** what you would write in it passes the long-term-relevance test. A section the objective touches only with task-scoped content is an omitted section, not a thin one. Default minimum for a bounded change: **§1** (1.1 stating the requirements this objective places on the system, 1.2 quality goals, 1.3 stakeholders only if they changed), **§4**, **§5**, **§6** (at least the one critical flow), **§8** (only the concepts touched), **§9**, **§10**, **§11**. Add **§2**, **§3**, **§7**, or **§12** only when constraints, system boundaries, deployment, or vocabulary actually change.
   - **Define the document-stable requirement IDs in §1.1, and cite those.** The acceptance criteria you were given are Workfile-scoped: restate each criterion this objective realizes as a durable requirement in a §1.1 table, under an ID prefix that does not collide with any ID already present in the persisted §1.1 (read it before you choose — `DOC-n`, `REQ-n`, and a subsystem-specific prefix are all fine, a second meaning for an existing prefix is not). §5, §6, and §10 then cite those IDs. Appendix C — which is never persisted — maps each `AC-n` onto the document ID that carries it, so traceability to this task survives without a token that resolves only against this task.
   - In `Mode: document-existing` the scope **defaults to all twelve sections**: the document's job is to describe the whole system, so the inclusion test is evidence, not relevance. Fill each section from cited evidence, and mark a section you cannot fill `_Omitted — no evidence in context Workfile_` rather than inventing it or leaving it blank.
   - Keep every omitted section as its heading with a one-line marker, using the closed set of § Document Shape rule 2 and the type that matches the reason. Never delete a section silently; the marker is how a reviewer knows you considered it.
   - Write the verdict into the header's `Section scope:` line, and repeat it in your report. **The type tag in parentheses after each omitted section is mandatory** — an untagged omission is an unfinished verdict:

     ```text
     Section scope: included=<§N[, §N …]>, omitted=<§N (scope | evidence | unaffected)[, §N (…) …]>
     ```

   - Directly after that line, the report carries `Scope rationale:` — **one clause per omitted section** saying why it is omitted, **and one clause per included section whose content you deliberately minimized** under the long-term-relevance test. The marker states the type; this states the reason, and it is what the ratifier steers against at the checkpoint. A section you thinned without saying so reads to every later reader as a section with nothing more to say.

   - In update-delta scope the header's `- **Existing document:** <path> (<shape>)` line carries the result line's `existing=` and `shape=` values; the persistence step reads it to find its target. State in your report which sections your delta replaces.

4. **Enumerate and evaluate options per decision — `Mode: decide-new` only.** A decision is architecturally significant when it constrains structure, contracts, technology, an external dependency, or a quality goal — the ones that are expensive to reverse. For each: state the forces, then enumerate **at least two genuinely distinct options** (a straw man is not an option), and evaluate them in a table scored against the §1.2 quality goals by name and the §2 constraints.

   In `Mode: document-existing` there is nothing to enumerate: the option was chosen long ago and the system is the evidence of it. Skip the options table entirely — an invented one is a fabrication — and go to step 5's as-is branch.

5. **Decide, or record the decision already in force.**
   - **`Mode: decide-new`.** Pick one option per decision. Write the rationale, the consequences split into positive and negative, what becomes *harder* as a result, and the risks with their mitigations. Write each as an ADR in Appendix A using the format below, `Status: Proposed`. Summarize the set in §4 Solution Strategy and log every one in the §9 table.
   - **What §4 and §9 may hold.** §4 names the stable structural decisions and their rationale — never the rollout, the sequencing, the temporary measures, or the work-package plan, all of which live in Appendix B. §9 logs only decisions that are **expensive to reverse** and that constrain future work; an implementation-phase choice the ratifier wants written down — an internal refactoring, a naming convention, a test structure — belongs in the owning package's done criterion in Appendix B, not in §9 and not in an ADR. A choice that fails this filter but still matters to a later reader is a risk or a debt in §11, stated in durable terms.
   - **`Mode: document-existing`.** Record each **existing** decision the evidence lets you infer — one the codebase visibly embodies and that would be expensive to reverse — as an ADR in Appendix A with the extra line `- **Kind:** as-is (inferred from <paths>)` directly under `Date`, no `Options Considered` table, a `Context` stating the forces the evidence shows, a `Decision` in the present indicative ("The system uses X"), and consequences as they have actually played out. `Status:` is `Proposed` here too: what you are proposing is the *description*, and the requesting agent ratifies that description exactly as it ratifies a forward-looking decision. Log every one in §9 and summarize the set in §4 as the strategy the system **follows** — never as a strategy it should adopt. A decision you cannot evidence is not an ADR; it is an investigation gap.

6. **Specify the structure — §5 and §8.**
   - §5 Level 1: a whitebox of the system, or of the affected subsystem when the objective is local, as a Mermaid diagram plus a contained-blackboxes table and the motivation for the decomposition.
   - One **blackbox entry per building block the objective touches**: purpose and responsibility, provided and required interfaces, quality characteristics when relevant, code location, the §1.1 requirement IDs it realizes, open issues.
   - **What §5 and §8 may hold.** §5 carries boundaries, interfaces, invariants a caller may rely on, quality characteristics, and code locations — never internal helper structure, never local control flow, never naming inside a block, never test-case selection. Those are the implementation phase's to decide, and a §5 that prescribes them is read as a contract its owner never agreed to. §8 carries only the mechanisms that persist after this objective is finished — never a workaround introduced for it, never a task-scoped variation of an existing mechanism. A temporary measure that must be recorded is a risk in §11 with its retirement condition, not a concept in §8.
   - Interfaces must be precise enough that a failing test can be written from them without opening the implementation: signatures, parameter and return types, error and failure contracts, schema or migration changes, and the invariants the caller may rely on.
   - Go to Level 2 only for building blocks the objective changes internally.
   - §8: only the cross-cutting concepts this change introduces or alters — error handling, persistence, security, validation, logging, transactions, the testing approach. An unchanged concept is not your material.
   - In `Mode: document-existing`, §5 and §8 **describe what exists**: one blackbox per building block the system actually has, in the present tense, and every block, interface, and concept carrying a path from the context Workfile as its evidence. A block you cannot cite is an investigation gap, not a block. §8 covers the cross-cutting concepts the system embodies, not the ones it ought to.

7. **Specify behavior (§6) and deployment (§7).** §6: one `sequenceDiagram` per critical or quality-goal-relevant scenario, typically one to three, each naming the §1.1 requirement IDs it realizes and the error path it takes. §7 only when infrastructure, topology, or deployment changes; otherwise an omission marker.
   - **What §6 may hold.** Trace only flows that **cross a module boundary or realize a quality goal**. A flow local to one work package, a sequence that exists only while this objective is in flight, or a walkthrough of how the change will be rolled out is task-scoped: it belongs in the owning package in Appendix B. The measure is whether a reader who never heard of this task would still need the flow to understand the system.
   - In `Mode: document-existing`, §6 traces the flows the system runs today — each naming the evidence paths it was read from instead of AC IDs, and each walking the error path the code actually takes; §7 describes the deployment that exists, or carries an omission marker when the context Workfile holds no deployment evidence.

8. **Write quality requirements (§10) and risks (§11).** §10: turn each §1.2 quality goal into one to three concrete quality scenarios — stimulus → response → measure, with a number and a unit in the measure. These are the candidate non-functional tests the implementation phase can write. §11: the risks and technical debt this change introduces or retires, each with an impact, a likelihood, and either a mitigation or an explicit acceptance.
   - **What §10 and §11 may hold.** A §10 scenario names the §1.1 requirement or the quality goal it measures, never an `AC-n` token. A §11 entry is a risk or a debt **of the system** — something a future maintainer inherits — never a limitation of this drafting run: what you could not confirm in this session is an investigation gap in the report, and what this run did to the workspace is not recorded anywhere in §1–§12. A debt that is genuinely durable is stated in durable terms: what is wrong in the system, its evidence, and what would clear it, with no reference to the run that noticed it.
   - In `Mode: document-existing`, §10 states the scenarios the system's inferred goals imply and marks each measure as observed or unverified; §11 is where every improvement idea you had while reading belongs — as a risk or a technical debt with its evidence, never as a proposal in §4 or §9.

9. **Draw the diagrams.** Mermaid, in fenced ` ```mermaid ` blocks, placed adjacent to the prose they illustrate. `flowchart` with subgraphs for §3 context and §7 deployment; `classDiagram` or `flowchart` for §5; `sequenceDiagram` for §6; `stateDiagram` for a stateful building block when its states drive the design. Every element must trace to your specification or to an input Workfile, and the markup must be well-formed so it renders rather than degrading to raw text. One good diagram per view beats three partial ones; a diagram that adds no relational information is noise.

10. **Break the work into packages (Appendix B) and trace them (Appendix C) — `Mode: decide-new` only.**
    - In `Mode: document-existing` there is no work to package and no acceptance criterion to trace. Both appendix headings carry the single marker `_Not applicable — document-existing mode_` and nothing else; there is no `Package check:` verdict, and your report's `Package check:` item reads `Package check: n/a`. Inventing packages for a system that already exists is the one failure this mode makes easiest.
    - Per package: name, **write set** (paths), **owned AC IDs**, contracts **provided** and **consumed** (referencing the §5 blackbox interfaces by name), **test seam**, **dependencies**, **done criterion**.
    - Put shared-surface churn — dependency-injection registration, route tables, migrations, lockfiles, generated code, shared fixtures — into a single sequential **scaffold package** that runs before any parallel wave.
    - Record the verdict line:

      ```text
      Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
      ```

    - Parallel requires **all four** checks to be `yes`; one `no` means `sequential`. Cap a parallel wave at four packages and split the rest into later waves.
    - Slice vertically — each package delivers observable behavior end to end. A package that is "the data layer" owns no acceptance criterion and cannot be tested alone.
    - Appendix C: one row per AC — AC → the §1.1 requirement ID that carries it → building block(s) → ADR(s) → package. This is where an `AC-n` token is allowed to live, because Appendix C is never persisted; it is the bridge between the task's criteria and the document-stable IDs §1–§12 cites. Every AC in scope appears exactly once with exactly one owning package; an AC with no package is a coverage hole, and one with two packages is a write-set collision waiting to happen.

11. **Map the layout (Appendix D), then create the Workfile and report.**
    - Decide the split section by section under § Layout Map's split rule. Default to one document; count the units of the section's natural grain, and split only at three or more independently consulted units. Record the count in one clause per split section in your report, so the ratifier can see the judgment rather than infer it.
    - Write one row per document — `| Workfile heading | Target path | Promotion |` — in reading order, then walk every heading under every included `## N.` and confirm it is covered exactly once, by its own row or its nearest mapped ancestor. The map is the last thing you write and the first thing the review checks.
    - **In update-delta scope, map only what this delta writes.** Read each included section's existing index first, so you know what is already in its folder. Give a path row to every document you re-author or add; give the row `| <existing document heading> | → superseded — <reason> | — |` to every document this delta retires; and give **no row at all** to a document you are carrying forward byte-identical. Existing documents keep their ordinals and new ones continue the folder's sequence, so a delta never renumbers a folder. Then account for the folder: every document in it is re-authored, superseded, or carried forward, and the carried-forward ones go into the report's `Carried forward:` item.
    - **Create** the Workfile at the path the brief names, with § Document Shape's title, header, sections, and appendices. If a file already exists there, ask instead — never overwrite.
    - Report to the requesting agent in the order given in § Output Contract. Section scope first, investigation gaps last but never omitted.

## Architecture Decision Record Format

One ADR per architecturally significant decision, in Appendix A, in this structure:

```markdown
# ADR-NNNN: <decision title, naming the choice, not the topic>

- **Status:** Proposed
- **Date:** <YYYY-MM-DD>

## Context
<The situation and the forces in tension — technical, operational, organizational.
Name the affected quality goals from §1.2 explicitly.>

## Options Considered
| Option | Pros | Cons | <quality goal 1> | <quality goal 2> | … |
| --- | --- | --- | --- | --- | --- |

## Decision
<One option, stated in the indicative: "We use X." Then the rationale, tied to the
ranked quality goals and the §2 constraints.>

## Consequences
- **Positive:** …
- **Negative:** …
- **Becomes harder:** …

## Related
<§1.1 requirement IDs · building blocks (§5) · other ADR IDs · the work package that implements it>
```

In `Mode: document-existing` the same format applies with three differences: a `- **Kind:** as-is (inferred from <paths>)` line sits directly under `- **Date:**`; the `Options Considered` table is **dropped**, because no option was weighed in this session and a reconstructed one is fiction; and `Decision` states what the system does, in the present indicative ("The system stores order history as an append-only event log"), followed by the evidence that establishes it. `Status:` stays `Proposed`, `Consequences` records the consequences that have actually materialized, and `Related` names the §5 blocks and the evidence paths instead of a work package.

Title ADRs by the choice made ("Event-sourced order history"), not by the question asked ("Order history storage"), so the §9 log reads as a list of positions. Number them from the `next-adr` value in the brief's `Scaffold result:` line, which already continues the project's existing sequence — never re-derive it. Link each ADR from the §9 table by its appendix anchor; the persistence step rewrites the link to the decision file's relative path. A decision that supersedes an existing project ADR names it in `Related` and says so in §9 — you do not edit the superseded file.

## Output Contract

**Workfile** — the one markdown file you create, at the path the brief names (task-directory pattern `NN-architecture-arc42.md`), in this order:

1. `# <System / Subsystem> — Architecture (arc42)` with the header block of § Document Shape: `Status: Proposed`, `Date`, `Document scope: <seed | update delta>`, `Mode: <mode> (source: <direction | inference>)`, `Scaffold: <target> (structure: <created | verified | extended>)`, the `Section scope:` verdict, and — when and only when the scope is update delta — `Existing document: <path> (<shape>)`. No attribution notice: the document carries no licensed text.
2. arc42 `## 1.` through `## 12.`, every heading present, each either filled or carrying its omission marker.
3. `## Appendix A — Architecture Decision Records` — full ADR text, one per decision; in `Mode: document-existing` each carrying its `Kind: as-is (inferred from <paths>)` line.
4. `## Appendix B — Work Packages` — the package table plus the `Package check:` verdict in `Mode: decide-new`; the single line `_Not applicable — document-existing mode_` in `Mode: document-existing`.
5. `## Appendix C — Traceability` — AC → §1.1 requirement ID → building block(s) → ADR(s) → package in `Mode: decide-new`; the same `_Not applicable — document-existing mode_` marker in `Mode: document-existing`.
6. `## Appendix D — Layout Map` — the `| Workfile heading | Target path | Promotion |` table of § Layout Map, total over every heading under every included section. Both modes: the persisted layout does not vary by mode.

Appendices A–D are Workfile content. On persistence, §1–§12 become topic documents inside the scaffolded section folders exactly as Appendix D maps them, and Appendix A becomes one decision-record file per ADR; Appendices B, C, and D are not persisted.

**Report** (not written to the Workfile), in this order:

1. The `Section scope:` line, in the grammar § Document Shape fixes — every omitted section carrying its `(scope | evidence | unaffected)` type tag.
2. `Scope rationale:` — one clause per omitted section saying why it is omitted, and one clause per included section whose content you deliberately minimized under the long-term-relevance test. This is the item the ratifier steers against: it is where a scope judgment becomes visible instead of looking like an oversight.
3. In update-delta scope only: `Refreshed:` — every task-scoped statement you dropped from a document you re-authored, per the refresh rule — and `Carried forward:` — every document of an included section you did not re-author and left untouched. In seed scope, omit this item.
4. The decision list: ADR ID, title, and one line of rationale each — in `Mode: document-existing`, each marked `as-is` with its evidence paths.
5. The `Package check:` verdict line, with the resulting shape — or exactly `Package check: n/a` in `Mode: document-existing`.
6. Open risks from §11, worst first.
7. **Investigation gaps** — what you could not confirm, what you assumed instead, and which section is weakest as a result. In `Mode: document-existing` this includes every section you marked `_Omitted — no evidence in context Workfile_`.
8. The Workfile path, the `Mode:` line with its source, the document scope, the document status (`Proposed`), and the target's shape as the result line stated it — `directory | flat directory (legacy) | legacy single file | non-arc42 | none`.
9. The layout-map summary: documents per included section, every section you split with the unit count that cleared the three-unit threshold, and the record paths `next-adr` produced. In update-delta scope, give each included section its three-way account of the documents already in its folder — re-authored, superseded (with the reason from the row), and carried forward — so the ratifier sees what this delta leaves alone as plainly as what it rewrites.

**Failure handling:**

- The brief carries no `Scaffold result:` line, or it is missing `document-scope=`, `shape=`, or `next-adr=` → report it and stop. Do not resolve those facts yourself: an answer derived here diverges from the one the scaffold step produced and the review passed.
- A file already exists at the Workfile path the brief names → ask the requesting agent which path to use and write nothing. Overwriting destroys a peer step's output, and appending produces a two-document file no reviewer can read.
- The `Scaffold result:` line contradicts the target you read — a shape that is not what is on disk, a `next-adr` below a record that exists → write the header from the line as given, report the contradiction immediately after the section scope and ahead of any codebase contradiction, and let the requesting agent resolve it. Correcting the field here would leave the header disagreeing with the result line the review compares it against.
- A named input Workfile is missing or unreadable → report it, name the sections thinned by its absence, and do not fabricate its content.
- No requirements Workfile and no acceptance criteria exist → derive the quality goals from the objective, mark them an assumption, and state in the report that Appendix C traceability is incomplete because there are no AC IDs to trace. In `Mode: document-existing` this is the normal case, not a failure: the goals are inferred and marked, and Appendix C is `_Not applicable — document-existing mode_`.
- The codebase contradicts an input Workfile → record the contradiction with the file path as evidence, design against what you read in the codebase, and report it as the first item after the section scope.
- A decision needs evidence you would have to investigate to obtain → write the ADR with the options you can evaluate, mark the decision `Status: Proposed` with an explicit `Open question` line naming the missing evidence, and raise it as an investigation gap rather than researching it.
- In `Mode: document-existing`, the context Workfile holds no evidence for a section → mark it `_Omitted — no evidence in context Workfile_` and list it as an investigation gap. Never fill it from the objective, from convention, or from what a system like this usually does.
- In `Mode: document-existing`, you conclude the architecture should change → put it in §11 with its evidence and say so in the report. Do not write it into §4, §9, or an ADR, and do not switch modes.
- An existing architecture document uses a non-arc42 structure → do not convert it. Write the delta in that document's structure, map each of your sections to its nearest counterpart in a short mapping table, and report the mismatch.
- The brief asks for the document to be written into the project tree → decline, deliver the Workfile, and report the boundary.

## Quality Criteria

**Both modes:**

- One Workfile exists, created at the path the brief named, and no file under the target project changed — check with a status listing of the project before you report.
- Every heading § Document Shape fixes is present at its level, and every header field carries the value its source gives it: `Document scope`, `Scaffold`, and `Existing document` equal to the `Scaffold result:` line, `Mode` equal to the brief.
- The quality goals appear in §1.2 before any decision, are ranked, and number three to five.
- Every included section is there for the mode's stated reason — the objective affects it (`decide-new`) or the evidence supports it (`document-existing`) — and every excluded one carries an explicit omission marker from the closed set of § Document Shape rule 2.
- **Every statement in §1–§12 passes the long-term-relevance test.** Re-read the filled sections against the tell-tale list before you report: no workspace path, task directory, or Workfile name; no review verdict or reviewer cited as this document's provenance; no revision or inputs log; no "at the time of writing"; no work-package name or sequencing; no feature flag, rollout step, or temporary workaround; no helper structure, local control flow, naming inside a block, or test-case selection; and no `AC-n` token anywhere in §1–§12.
- Every omitted section's marker is one of the three fixed strings, and its type matches the reason — a scope judgment never wears the evidence marker, and an unaffected section never wears either of the other two.
- The `Section scope:` line carries a `(scope | evidence | unaffected)` type tag on every omitted section, in the header and in the report alike.
- The report's `Scope rationale:` carries one clause per omitted section and one per deliberately minimized included section; in update-delta scope `Refreshed:` and `Carried forward:` are both present, and every re-authored document appears in exactly one of them or in neither because it is new.
- Every reference in §1–§12 is document-stable: a repository path, a section number, a decision-record ID, or a requirement ID §1.1 defines. Requirement IDs use a prefix that collides with nothing already in the persisted §1.1, and Appendix C maps each `AC-n` onto one of them.
- The Workfile carries no template guidance text and no attribution notice — every word in it is yours.
- Appendix D is total: every heading under every included `## N.` appears in exactly one row, by its own row or its nearest mapped ancestor.
- Every Appendix D row matches one of the three path patterns and carries that pattern's promotion: a **topic document** at `<section folder>/NN-<slug>.md` with `NN` contiguous from `01` per folder (a single-document section named `01-<section-slug>.md`), promoted by its root heading's depth minus one; a **decision record** at `09-architecture-decisions/NNNN-<slug>.md` continuing from `next-adr`, promoted by `2`; and the `## 9.` heading itself at `09-architecture-decisions/README.md`, promotion `—`. No other path appears, and `→ index (omitted)` and `→ superseded — <reason>` rows name no path at all.
- Every split section names three or more independently consulted units of its grain; no section is split below that threshold.
- Every §5 blackbox names a real code location, and its interfaces are precise enough to write a failing test against without reading the implementation.
- Every diagram element traces to the specification or to an input Workfile, and the Mermaid markup is well-formed.
- §4 summarizes the decisions and cross-references the ADR IDs; §9 logs every ADR with ID, title, status, date, and link, one-to-one with Appendix A.
- Every ADR and the document header read `Status: Proposed`.
- ADR numbering starts at the `next-adr` value the brief supplied.
- In update-delta scope, sections outside the delta get no Appendix D rows and the report says which sections the delta replaces.
- The `Mode:` header field and the mode in the report match the brief.

**`Mode: decide-new` only:**

- Every ADR evaluates at least two genuinely distinct options against the §1.2 quality goals by name.
- Every decision traces to a driver — a quality goal, a constraint, or an acceptance criterion — not to preference.
- Every §10 quality scenario has a measure with a number and a unit.
- Every acceptance criterion in scope maps to at least one building block and exactly one work package.
- Packages marked parallel have provably disjoint write sets and consume only contracts fixed in §5 or already present in the codebase.
- A single-package outcome states its one-line reason instead of being left implicit.

**`Mode: document-existing` only:**

- Nothing in the document proposes a change: §4 describes the strategy the system follows, §9 logs only decisions already in force, and every improvement idea sits in §11 as a risk or a debt.
- Every §5 block, every §6 flow, and every §8 concept cites a path that is present in the context Workfile.
- Every §1.2 quality goal is marked as inferred and carries the evidence it was inferred from.
- Every ADR carries `Kind: as-is (inferred from <paths>)`, has no options table, and reads in the present indicative.
- Appendices B and C carry `_Not applicable — document-existing mode_` and nothing else, and the report's `Package check:` item reads `Package check: n/a`. Appendix D is written in full — the layout does not vary by mode.
- §1.1's evidence-base statement names repository paths and a date only — no Workfile path, no task directory, no review verdict. The long-term-relevance test applies to an as-is record exactly as it does to a forward-looking one.

## Anti-Patterns

- **Template worship**: in `decide-new`, filling all twelve sections for a change that touches three, producing a document whose signal is buried in ceremony. Prune, and mark what you pruned.
- **Silent deletion**: dropping an irrelevant section instead of marking it omitted, leaving a reviewer unable to tell considered-and-excluded from forgotten.
- **Re-deriving the target's shape or `next-adr`**: searching for the architecture directory, re-classifying the existing document, recomputing the document scope, or renumbering the ADRs from `0001` — work that already happened, whose answers are in the `Scaffold result:` line. A field you disagree with is a report item, not a correction.
- **Splitting by habit**: one document per subsection because the layout allows it. A §6 with two scenarios, a §8 with two concepts, a §5 with one blackbox — each is one document. The threshold is three independently consulted units, and a reader forced to open five files for one argument is worse off than one who scrolls.
- **A map that is not total**: a heading in two rows, or in none, because the section was re-drafted after the map was written. Write Appendix D last and walk the headings against it; the persistence step copies what the map says and silently loses whatever it omits.
- **Single-option decisions**: in `decide-new`, an ADR whose options table has one row plus a straw man. That is a rationalization, not a decision.
- **Proposing in document mode**: a §4 tactic, a §9 row, or an ADR that recommends a change to a system you were asked to describe. The document stops being a baseline the moment it mixes what is with what should be; §11 is where the idea belongs.
- **Reconstructed options**: an as-is ADR with an invented `Options Considered` table, presenting a choice nobody in this session weighed as if it had been.
- **Uncited as-is claims**: a §5 block, a §6 flow, or an inferred quality goal in document mode with no evidence path. Without the citation a reader cannot tell the architecture that exists from the one you assumed.
- **Run provenance in the document**: a workspace path, a task directory, a Workfile name, a review verdict, a revision log, or "at the time of writing" inside §1–§12. Every one of them resolves against a workspace that is deleted when the task ends, leaving a persisted section that cites nothing a reader can open.
- **Task-scoped content in a durable section**: a §4 paragraph on rollout sequencing, a §5 entry prescribing helper structure or test selection, a §6 flow local to one work package, a §8 concept that is a workaround for this objective, a §9 record of an implementation-phase choice. Each is stale the moment the task closes, and each crowds out the content the section exists to carry.
- **A §11 entry about the run rather than the system**: "this document was drafted without access to X". That is an investigation gap for the report; a risk is something a future maintainer inherits.
- **Free-form omission markers**: inventing a fourth wording, or writing the reason into the marker instead of the report. Three strings exist so a reader learns them once and a reviewer checks them by comparison; the reason belongs in `Scope rationale:`.
- **Untagged omissions**: a `Section scope:` line whose omitted list names sections without their `(scope | evidence | unaffected)` type, leaving a reader unable to tell a judgment from a gap.
- **Persisting the task's criterion IDs**: citing `AC-n` in §5, §6, or §10 instead of defining a requirement ID in §1.1 and citing that. The token resolves only against this task's inputs, and the next objective's `AC-3` means something else entirely.
- **Architecture astronautics**: introducing a pattern, a layer, or a message bus that no §1.2 quality goal asks for. Every structural move needs a named driver.
- **Design detached from codebase reality**: building blocks that do not exist, interfaces that contradict the current signatures, file paths never opened.
- **Quality goals as afterthought**: writing §10 at the end without having used the goals as the evaluation criteria in §4 and §9 — the goals then describe the design instead of driving it.
- **Prose-only building blocks**: a §5 that describes responsibilities but gives no signatures, types, or error contracts, so no test can be written until the implementation exists.
- **Layer-split packages**: packages named "backend", "frontend", "database". None owns an acceptance criterion, none is independently testable, and all of them collide on the shared surface.
- **Packaging a system that exists**: an Appendix B in document mode, inventing work nobody asked for out of the gaps you noticed while reading.
- **Decisions buried in prose**: an important trade-off explained in a §4 paragraph with no ADR, so it has no ID, no status, and no way to be superseded later.
- **Duplicating an existing architecture document**: writing a fresh parallel document when one exists, leaving the project with two disagreeing sources.
- **Researching instead of reporting gaps**: spending the session investigating the codebase rather than naming what is unknown and deciding around it.
- **Deciding implementation minutiae**: specifying internal helpers, local control flow, or naming inside a building block, which pre-empts the implementation phase and inflates the document.
- **Hedged recommendations**: "either A or B would work" — a decision the ratifier has to make themselves is not a decision.
- **Parallel by optimism**: marking packages parallel with overlapping write sets or contracts that do not exist yet, which corrupts the shared working tree.
