---
name: brokk-architecture-persistence
description: Fill a pre-scaffolded arc42 directory in the target project from a reviewed, ratified architecture Workfile and its layout map — one folder per numbered section holding its topic documents, the decision records in the decisions folder, every index regenerated and the document status promoted — merging into an existing document document-by-document, never creating the structure and never deleting.
---

# Architecture Persistence

## Purpose

Fill a **pre-scaffolded** arc42 directory in the target project from a reviewed, ratified architecture Workfile and its layout map — one folder per numbered section holding its topic documents, the decision records in the decisions folder, every index regenerated and the document status promoted — merging into an existing document document-by-document, never deleting.

The Workfile is authored as a single document; the split into files is decided in that Workfile's **Appendix D — Layout Map** (`Workfile heading → target path → promotion`) and executed here. Your transformation is therefore mechanical and fully specified: copy each mapped heading and its unclaimed descendants into the path the map names, promote by the distance the map states, rewrite the decision log's link column, regenerate the indices. Nothing about the architecture — and nothing about the split — is decided in this step. A section whose content you would have to invent is a gap to report, not a file to fill; a document the map does not name is structure you must not create.

**You cannot create the structure.** The section folders and their indices are written before drafting, by the scaffold step (`brokk-arc42-template`). You verify that they are there and fill them. A target that fails the identity rule below, or whose top index status contradicts the Workfile's `Document scope`, is a **blocking report item** — "the scaffold step did not run" — never an invitation to create one. This is what makes the old seed-over-an-existing-document hazard structurally impossible: a step that cannot create cannot overwrite a document it mistook for absent.

This section and the four that follow it — § The Persisted Layout, § Per-Document Format, § Index Format, § What Is Not Persisted — are the single source of truth for the persisted layout. Other steps of the workflow refer to it by role ("the persisted layout", "the fixed folder table"); the names and formats live here.

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

**Top index.** `README.md` at the directory root: title, `Status`, `Date`, `Document scope`, `Mode … (source …)`, a Sections table (state · docs · last updated), and the Change Log.

**Omitted section = index-only folder.** No topic document; the marker travels verbatim in the index's state line. In a flat-to-folder migration the legacy stub file *becomes* that index by rename — never delete-and-recreate.

**Identity rules.** Contents decide the shape of a target, never the directory's name. **Folder layout** if and only if it holds `README.md` and `01-introduction-and-goals/README.md`. **Flat directory (legacy)** if and only if it holds `README.md` and `01-introduction-and-goals.md`. **Legacy single file** when one markdown file carries the arc42 `## N.` headings. **Non-arc42** when a document in another structure describes this system's architecture. **None** when nothing is found.

**Status invariant.** Seed-scope persistence requires the top index at `Status: Scaffolded`; update-delta persistence requires `Accepted`. A `created` structure reads `Scaffolded`; the first persistence promotes it to `Accepted`. A persistence step never creates a folder the scaffold did not.

**No arc42 guidance text anywhere under the target, ever** — and therefore no attribution notice in any file under it. The licensed guidance text stays inside the skill that carries it.

**This specification is duplicated verbatim.** The two skills that write the layout carry this section byte for byte: the scaffolding skill `brokk-arc42-template`, and `brokk-architecture-persistence`, whose copy is normative. A layout change is a two-file copy, never a re-derivation.

### Per-Document Format

A filled topic document:

```markdown
# 5.1 Whitebox Overall System

_Part of [<System / Subsystem> — Architecture (arc42)](../README.md) · [§5](README.md)._

<the document's body from the Workfile, every heading promoted by the same distance as its root>
```

A decision record:

```markdown
# ADR-0016: <title>

- **Status:** Accepted
- **Date:** 2026-09-19

## Context

<…>
```

Rules that hold for every document you write:

- **One H1 per document**, the map row's root heading promoted by exactly `depth − 1`. Every heading in the body is promoted by that same distance, so the level *relationships* inside a document are preserved exactly.
- **The backlink line** is the second content line, verbatim as above, with the document title and the section number substituted. Decision records carry no backlink — a record is not a section of the document.
- **Markers are copied verbatim.** Never reword, summarize, or drop a marker.
- **Carved-out children stop the parent.** When the map gives a child heading its own document, the parent's document ends where that child began. The section index carries the reading order that stitches them back together.
- **`09-architecture-decisions/README.md`** carries the §9 decision-log table with its `Link` column rewritten from the Workfile's appendix anchor to the record's path relative to that index — `0016-<slug>.md`, or `../../adr/0007-<slug>.md` when the project's own decision directory is used. Each row's `Status` matches its record file's own `Status:` line.
- **Records** are the decision-record text from the Workfile's Appendix A verbatim, with `Status:` promoted to `Accepted` for exactly the IDs the cited ratification record ratified. The slug is the kebab-case decision title.
- **Prose `§N` references are left as written.** The numbered vocabulary is the navigation aid; rewriting prose cross-references into file links is error-prone and unreviewable. Navigation between documents is the index's job.
- **No attribution notice.** No document under the target ever contains arc42 guidance text, so no document under the target ever carries the notice. If you find guidance text in the Workfile, that is a gap to report — the drafting step never had guidance to carry.

**Promotion is one rule, applied four ways.** The distance is the depth the content sits at in the Workfile minus one, so a document's root always lands on H1 and the one-H1-per-document rule holds everywhere:

```text
## 2. Architecture Constraints   →   # 2. Architecture Constraints          (depth 2 → promote 1)
### 5.1 Whitebox Overall System  →   # 5.1 Whitebox Overall System          (depth 3 → promote 2)
#### 5.1.7 Consumed block …      →   # 5.1.7 Consumed block …               (depth 4 → promote 3)
### ADR-0016: <title>            →   # ADR-0016: <title>                    (depth 3 → promote 2)
####   Context                   →   ##   Context
```

Promoting by any other distance leaves the document with no H1 at all, or with two — its title then no longer matches the index row or the §9 row that links to it, and the one-H1 rule that holds for every other file in the directory silently does not hold for that one.

### Index Format

The **top index**, `README.md` at the directory root:

```markdown
# <System / Subsystem> — Architecture (arc42)

- **Status:** Accepted
- **Date:** <YYYY-MM-DD of the last persistence>
- **Document scope:** <seed | seed + <n> delta(s)>
- **Mode:** <document-existing | decide-new> (source: <direction | inference>)

_Generated index — regenerated by the architecture persistence step, run standalone by the architecture workflow or from the software-engineering workflow's integration step. Edit the topic documents and the records, not this file._

## Sections

| § | Section | State | Docs | Last updated |
| --- | --- | --- | --- | --- |
| 1 | [Introduction and Goals](01-introduction-and-goals/README.md) | filled | 1 | 2026-09-18 |
| … | … | … | … | … |
| 7 | [Deployment View](07-deployment-view/README.md) | omitted — <reason> | 0 | 2026-09-18 |
| … | … | … | … | … |
| 12 | [Glossary](12-glossary/README.md) | filled | 1 | 2026-09-18 |

## Decision Records

<n> records in [`09-architecture-decisions/`](09-architecture-decisions/README.md) (or the project's existing directory `<path>`) — the log is that folder's index.

## Change Log

| Date | Scope | Sections written | Decisions added |
| --- | --- | --- | --- |
| 2026-09-18 | seed | 1, 4, 5, 6, 8, 9, 10, 11 (2, 3, 7, 12 omitted) | ADR-0001–ADR-0003 |
| 2026-10-02 | update delta | 5, 8, 9 | ADR-0004 |
```

`State` is `filled`, `omitted — <reason>`, or `pending` (a section the scaffold created and no persistence has filled). `Docs` is the number of topic documents in that folder — `0` for an omitted or pending section.

A **section index**, `README.md` inside a section folder:

```markdown
# 5. Building Block View

_Part of [<System / Subsystem> — Architecture (arc42)](../README.md)._

The static decomposition: what the system is made of, level by level, and what each block provides and requires.

| # | Document | Root heading | Last updated |
| --- | --- | --- | --- |
| 01 | [Whitebox Overall System](01-whitebox-overall-system.md) | 5.1 Whitebox Overall System | 2026-09-19 |
| 02 | [Blackbox …](02-….md) | 5.1.1 Blackbox … | 2026-09-19 |

## Omitted subsections

- _Omitted — not needed_ (5.2 Level 2)
- _Omitted — not needed_ (5.3 Level 3)

## Superseded documents

- [`01-building-block-view.md`](01-building-block-view.md) — superseded 2026-09-19 by `01-whitebox-overall-system.md`; kept for history.
```

The one-line section description is the third content line, taken from the scaffolded index — the scaffold step generated it and you carry it forward. An index for a **pending** section carries `_Pending — not yet drafted_` in place of the Documents table; an index for an **omitted** section carries the Workfile's marker verbatim. The two trailing sections appear only when they apply.

**Indices are fully owned by this step.** Every index you touch is regenerated from the tree, and the top index's Change Log rows are **appended, never rewritten**. Read the existing top index before regenerating it — the Change Log is the one part of it that cannot be reconstructed from the tree, and it is gone the moment you write over it blind. `Status` is document-level; per-section freshness is the `Last updated` column.

### What Is Not Persisted

The work-package appendix, the traceability appendix, and the **layout map appendix** are transient planning material and are never written into the project. The decision-record appendix is not persisted as a document either — it is the *source* of the record files. The layout map in particular is the instruction you executed, not content: persisting it would put a workspace-relative table into a project document that contradicts itself the moment a later delta re-splits a section.

**Workfile-level process metadata is not persisted.** The Workfile header can carry an account of how the document was produced rather than what the architecture is: `Revision N:` log entries, a `Contradictions found` blockquote, an inputs note, a completeness line. None of it has a field in the index format, none of it is a mapped heading in Appendix D, and none of it gets a document. Do not invent a home for it — the top index carries `Status`, `Date`, `Document scope`, `Mode`, the Sections table, and the Change Log, and the fixed folder table admits no thirteenth section.

Its durable *substance* already has homes, written by the drafting step, not by you: a decision that changed belongs in that decision's own `Context` and `Consequences`, and an unresolved contradiction or a cost accepted under it belongs in §11 Risks and Technical Debts. Where the substance is in neither, that is a **gap to report** — the reviewed Workfile is what failed to carry it forward. Raw revision-log text pasted into a topic document, or a top index grown a "Revision History" heading, is the same invention this step never makes.

## When to Use

- Dispatched as the persistence step of the architecture workflow — standalone, or from the integration session of the software-engineering workflow (or its single package session when the package count is one) — after the architecture document has been reviewed, its decisions ratified, and the structure scaffolded.
- The brief supplies the reviewed architecture Workfile path, the ratification record, the pinned baseline, the scaffold step's `Scaffold result:` line, and the migration direction (default: none).
- **Not for** creating the arc42 structure. The scaffold step creates it before drafting; a target without it is a blocking report item, not a structure for you to invent.
- **Not for** deciding how a section splits into documents. Appendix D is that decision, already made and already reviewed.
- **Not for** persisting requirements, work packages, traceability, or the layout map; those are transient or persisted only on separate user direction.
- **Not for** authoring or revising architecture content. You transform and place what was reviewed; a content gap is a report item.
- **Not for** writing a Workfile. Your outputs are files in the target project; the workspace must gain nothing from your session.
- **Not on your own initiative.** Persisting a document nobody reviewed, or ratifying a decision nobody ratified, is out of bounds even when the Workfile is sitting there.

## Workflow

1. **Collect the inputs.** The reviewed architecture Workfile path; the ratification record naming which decision IDs were ratified; the pinned baseline (the pre-change state of the target); the scaffold step's `Scaffold result:` line (target path, `structure`, `shape`, `document-scope`, `next-adr`); and the migration direction — `none | migrate flat directory | migrate single file`, default `none`, valid only when the brief cites explicit user direction. A missing ratification record means no decision may be promoted to `Accepted` — report it and stop rather than guessing.

2. **Verify the target; do not create it.** Read the Workfile header's `Scaffold:` and `Document scope:` lines and its Appendix D. Then check three things against the tree, in this order, and stop on the first that fails:

   - **Identity.** The target satisfies an identity rule of § The Persisted Layout, and the shape you derive equals the `shape` in the result line. Derive it yourself from the tree — the header is a claim, not evidence.
   - **Scaffold precondition.** For a folder-layout target, all twelve section folders and their indices exist. A missing folder is a blocking report item: the scaffold step did not run, or ran and was not reviewed. You add none of them. A legacy shape has no scaffolded structure by definition, so for one of those this precondition is checked **after** the migration act of step 8 and before the delta is applied — never skipped, only deferred.
   - **Status invariant.** `Document scope: seed` requires the top index at `Status: Scaffolded`; `Document scope: update delta` requires `Accepted`. A mismatch is blocking — a `seed` header against an `Accepted` target would overwrite a document nobody reviewed, and an `update delta` header against a `Scaffolded` target means the drafting step wrote a delta against a document that does not exist yet.

   Report a failure as `scaffold=absent | status invariant violated — <what the tree shows>` and persist nothing. An unresolvable target path is likewise blocking, not an invitation to seed elsewhere.

3. **Resolve the record directory.** An existing `docs/adr/`, `docs/decisions/`, or `adr/` always wins, in that order of search; otherwise the records go in `<target>/09-architecture-decisions/`. Read the highest number already in use across every decision directory you find and continue that sequence — never restart at `0001` in a project that already holds records, and never collide with a number the result line's `next-adr` already reserved.

4. **Seed scope** (top index `Status: Scaffolded`). For every section, write the topic documents Appendix D names for it, in the per-document format, at the paths the map states and with the promotion the map states. A section the map leaves without documents stays an **index-only folder** carrying its omission marker. Write one record per entry in the Workfile's Appendix A at `NNNN-<slug>.md`, promoted by two, with `Status: Accepted` if and only if that ID appears in the ratification record. Rewrite the §9 `Link` column **before** writing `09-architecture-decisions/README.md`. Then regenerate every section index and the top index: `Status: Scaffolded → Accepted`, one Change Log row with scope `seed`.

5. **Update-delta scope, folder layout** (top index `Accepted`). For each section in the Workfile's `Section scope: included=` list, write its mapped documents by **whole-file replacement** — filling a previously pending folder is that same replacement — and regenerate that section's index. **Never delete a topic document.** A document a previous map named and this one does not stays on disk and is listed in its section index under "Superseded documents"; re-splitting a section therefore adds documents and supersedes one, it never removes anything. For `09-architecture-decisions/README.md`, **append** the new rows and their one-line summaries at the end of the existing table — never rewrite or reorder an existing row, and never edit an existing record file (a superseding record says so in its own text and in its own §9 row). Write the new records at the next free numbers. Regenerate the top index's header and Sections table from the resulting tree and append exactly one Change Log row. Every other path in the target stays byte-identical.

6. **Update-delta scope, flat legacy directory.** The flat shape is **never written.** With cited migration direction, run step 8 and then step 5, in that order, and commit the two acts separately so the pure-rename diff is reviewable on its own. Without cited direction, stop and report `shape=flat directory (legacy) — migration direction required` as a blocking item; persist nothing. The workflow's Deliverable then offers the migration and obtains the user's decision — which is a project decision, not a by-product of shipping a delta.

7. **Update-delta scope, legacy single file or non-arc42 target.**

   - **Legacy single file.** Not written in its single-file shape either. With cited migration direction, run step 8's single-file variant and then step 5. Without it, stop and report `shape=legacy single file — migration direction required` as a blocking item.
   - **Non-arc42 target.** Apply the mapping table the Workfile carries — the drafting step wrote the delta in the existing document's own structure. Write the delta where the mapping says and convert nothing. This is the one shape with no arc42 structure to scaffold, so the scaffold precondition and the status invariant do not apply to it; record `shape=non-arc42, scaffold=n/a` in the manifest so the review sees why they were not checked.

8. **Migration — direction-gated, `git mv`-based.** Run this only when the brief cites explicit user direction, and record that citation in the manifest.

   Migration is the **one** act in which folders come into being here, and it is not an exception to "never create a structure": every folder it produces is produced by *moving a file that already exists* into it, never by scaffolding an empty one. Because the result is a structure no scaffold step ever saw, re-run step 2's identity rule and scaffold precondition against the migrated tree before you apply the delta — and commit the migration separately, so its pure-rename diff is reviewable on its own before content lands on top of it.

   **Flat directory → folder layout.** Every one of the twelve section files migrates as a **rename**; none is deleted.

   - For each **filled** `NN-<section>.md`: `git mv` it to `NN-<section>/01-<section-slug>.md`. Its H1 is already the section heading promoted by one, so it is unchanged; the body is unchanged; only the backlink line is rewritten to the two-link form.
   - For each **stub** `NN-<section>.md` (an omission marker): `git mv` it to `NN-<section>/README.md`. The stub *becomes* that omitted section's index — it already carries the index's H1, backlink, and marker, and regeneration adds only the one-line description, so git's rename detection sees a clean `R`. The folder then has no topic document, exactly as an omitted section requires.
   - `git mv 09-architecture-decisions.md 09-architecture-decisions/README.md` and rewrite its `Link` column to `NNNN-<slug>.md`.
   - `git mv decisions/NNNN-*.md 09-architecture-decisions/`.
   - Generate the section index for every filled section: its Documents table lists the one migrated document. Regenerate the top index with a Change Log row `migrated from flat directory`. Remove the now-empty `decisions/`.
   - **Verify `git log --follow` on at least two moved paths reaches the document's seed commit before you go on** — one of them a renamed stub, because that is the case a delete-and-recreate would silently lose. Then apply step 5 for the current delta.

   **Legacy single file → folder layout.** Split the file at its `## N.` headings into `NN-<section>/01-<section-slug>.md`, promoting each by one; a section absent from the legacy file becomes an index-only folder reading `_Omitted — not present in the migrated document_`. Generate the indices and the top index with a Change Log row `migrated from <old path>`. Leave the records where they are, rewriting the §9 links relative to the new log. Delete the old file **only after** every folder, document, and index exists, and report the action as `deleted (migration source)`. A split is the one migration a rename cannot express, so state in the manifest that `git log --follow` evidence is unavailable for it.

9. **Report a persistence manifest** in the session's evidence block:

   ```text
   Persistence: target=<path>, shape=<directory | flat directory (legacy) | legacy single file | non-arc42>, scope=<seed | update delta | migrate+update delta>, scaffold=<verified | n/a>, migration=<none | flat directory → folder layout (directed <date>) | single file → folder layout (directed <date>)>
   | Path | Action | Source |
   | --- | --- | --- |
   | README.md | regenerated | top index |
   | 05-building-block-view/README.md | index regenerated | section index |
   | 05-building-block-view/01-whitebox-overall-system.md | created | Workfile §5.1 |
   | 05-building-block-view/01-building-block-view.md | superseded (kept) | — |
   | 07-deployment-view/README.md | moved | 07-deployment-view.md |
   | 09-architecture-decisions/README.md | appended 5 rows | Workfile §9 |
   | 09-architecture-decisions/0016-<slug>.md | created (Accepted) | Appendix A ADR-0016 |
   | 01-introduction-and-goals/01-introduction-and-goals.md | untouched | — |
   ```

   Actions vocabulary — use these words and no others: `created`, `replaced`, `regenerated`, `index regenerated`, `appended <n> rows`, `moved`, `superseded (kept)`, `untouched`, `deleted (migration source)`. Two words from the flat layout are retired: `stub` (an omitted section is an index-only folder, never a stub document) and the general `deleted` (only a split legacy single file's source is ever deleted). One row per path in the target, including the untouched ones: the manifest is what the review diffs against, so a path you left alone is as much a claim as a path you wrote.

## Quality Criteria

- The target held the scaffolded structure **before** the fill: an identity rule of § The Persisted Layout is satisfied, all twelve section folders and their indices were present, and the top index read `Status: Scaffolded` (seed) or `Accepted` (update delta). You created no folder the scaffold did not — on a migrated legacy target, every folder was established by the directed migration act, from files that already existed, and the precondition was re-checked against the migrated tree before any content landed.
- After a seed, every section folder holds exactly the topic documents Appendix D names for it — or only its index when the section is omitted — and the record directory holds one record per entry in the Workfile's Appendix A.
- Every topic document equals its Workfile source exactly, modulo the `depth − 1` heading promotion and the added backlink line. No content was reworded, trimmed, or added, and no document exists that the map does not name.
- Every document's H1 is its root heading promoted by exactly `depth − 1`, and its body is promoted by that same distance; every document has exactly one H1.
- Every omitted section is an index-only folder whose index carries the Workfile's marker verbatim.
- **No topic document was deleted.** Every document a previous map named is still on disk, and each one the current map no longer names is listed under "Superseded documents" in its section index.
- Every record equals its Workfile record exactly, modulo the two-level promotion and the promoted `Status:` — one H1 reading `# ADR-NNNN: <title>` and its parts at `##`.
- `Status: Accepted` appears only for decision IDs the cited ratification record ratified; a ratified decision never persists still reading `Proposed`.
- Every §9 row's link resolves relative to `09-architecture-decisions/README.md`, and the row's ID, title, status, and date match that record's own header. Every persisted record has a §9 row, and no pre-existing row was rewritten or reordered.
- In update-delta scope the set of changed paths is exactly: the mapped documents of the `included=` sections, those sections' indices, `09-architecture-decisions/README.md` (appended rows only), the new records, and the top index. Everything else is byte-identical to the pinned baseline.
- The top index's Change Log grew by exactly one row per act, its pre-existing rows are unchanged, and `Status` was promoted `Scaffolded → Accepted` on the first fill and left `Accepted` after.
- No `arc42 guidance §N` text and no attribution notice exists anywhere under the target (grep = 0).
- A flat legacy directory or a legacy single file was written only after cited user direction; the flat migration moved every one of the twelve section files by `git mv`, deleted none, and `git log --follow` on at least two moved paths reached the document's seed commit.
- The work-package, traceability, and layout-map appendices were not written into the project.
- No document, folder, or index field was created to hold the Workfile header's process metadata — its revision log, its contradictions blockquote, its inputs note — and no document's body was padded with that text.
- The task directory gained no file: this session wrote no Workfile.
- The manifest accounts for every path in the target, action by action, and matches what the diff actually shows.

## Anti-Patterns

- **Creating the structure** — scaffolding the folders yourself because the target has none, or adding the one folder that is missing. Either hides the fact that the scaffold step never ran or never passed its review, and it re-opens the overwrite hazard that a step which cannot create cannot have. The directed migration is not this: it moves files that already exist, under a direction the brief cites.
- **Seeding over a filled document** — treating a `seed` header as authority against an `Accepted` target. The status invariant exists because the header is the drafting step's claim and the tree is the fact; when they disagree, you stop.
- **Deleting a superseded document** — removing `01-building-block-view.md` because the new map calls that content `01-whitebox-overall-system.md`. A re-split adds and supersedes; it never removes. The deletion nobody reviewed is the one nobody can recover.
- **Splitting below the map, or splitting by habit** — giving §5.1.1 its own document because the layout allows it, or merging two mapped documents into one because it reads better. A document the map does not name is unreviewed structure, and the reviewer checks the tree against the map.
- **Overwriting instead of merging** — writing the delta's documents over every folder in an existing directory deletes content whose removal nobody reviewed.
- **Rewriting existing §9 rows** — the decision log is append-only; a reordered or reworded historical row destroys the record the log exists to keep.
- **Regenerating an index without reading it first** — the Change Log is the one part of the top index that cannot be reconstructed from the tree, and it is gone the moment you write over it blind.
- **Rewriting prose `§N` references into links** — unreviewable churn across every document, for navigation the indices already provide.
- **Writing `_Not affected by this change_` into the project tree** — that marker belongs to a delta Workfile. An unaffected section is not written at all in update-delta mode; a persisted index reads `_Omitted — <reason>_` or lists documents.
- **Migrating without direction, or migrating by delete-and-create** — moving files a project README, CI job, wiki, or issue tracker may link is a project decision, never a by-product of shipping a delta; and a `D`+`A` pair where an `R` was possible throws away the history the move existed to preserve.
- **Persisting the work-package, traceability, or layout-map appendices** — planning material in the project tree goes stale immediately and contradicts the next run.
- **Inventing the missing piece** — a section the Workfile left neither mapped nor marked, a decision with no ratification, an index title that was never in the Workfile. Report the gap; do not close it here.
- **Promoting statuses wholesale** — setting every decision to `Accepted` because the run reached this step, rather than checking the ratification record ID by ID.
- **Copying guidance or attribution into the target** — the licensed arc42 text lives in the skill that carries it and never reaches a project tree; a notice in a persisted file means guidance got there too.
- **Writing a Workfile** — a manifest, a summary, or a "persistence report" in the task directory. Your medium is the target project; the manifest goes in the session's evidence block.
