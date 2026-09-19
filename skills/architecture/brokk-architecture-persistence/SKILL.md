---
name: brokk-architecture-persistence
description: Persist a reviewed, ratified arc42 architecture Workfile into the target project as a directory document — one file per numbered section, one file per decision record, plus a generated index — merging into an existing document file-by-file and never overwriting it.
---

# Architecture Persistence

## Purpose

Persist a reviewed, ratified arc42 architecture Workfile into the target project as a **directory document** — one file per numbered section, one file per decision record, plus a generated index — merging into an existing one file-by-file, never overwriting.

The Workfile is authored as a single document; the split into files happens here, on persistence. The transformation is mechanical and fully specified below: split by numbered section, promote each section's headings one level, rewrite the §9 link column to relative decision-file paths, generate the index. Nothing about the architecture is decided in this step; a section whose content you would have to invent is a gap to report, not a file to fill.

This section and the two that follow it — § The Persisted Layout, § Per-File Format, § Index Format — are the single source of truth for the persisted layout. Other steps of the workflow refer to it by role ("the persisted layout", "the fixed filename table"); the names and formats live here.

### The Persisted Layout

```text
docs/architecture/
├── README.md                          # generated index: title, status, date, scope, section table, change log
├── 01-introduction-and-goals.md       # §1 (1.1, 1.2, 1.3 inside)
├── 02-architecture-constraints.md     # §2
├── 03-context-and-scope.md            # §3 (3.1, 3.2 inside)
├── 04-solution-strategy.md            # §4
├── 05-building-block-view.md          # §5 (5.1, 5.2, 5.3 inside)
├── 06-runtime-view.md                 # §6
├── 07-deployment-view.md              # §7
├── 08-crosscutting-concepts.md        # §8 (8.<n> inside)
├── 09-architecture-decisions.md       # §9 decision log; Link column → decisions/
├── 10-quality-requirements.md         # §10 (10.1, 10.2 inside)
├── 11-risks-and-technical-debts.md    # §11
├── 12-glossary.md                     # §12
└── decisions/
    ├── 0001-<slug>.md                 # full decision-record text
    └── 0002-<slug>.md
```

**Fixed filename table.** These twelve names are the shared vocabulary. Every file you write uses exactly the name in this table — no variants, no renumbering, no extra section files.

| § | File | Workfile heading it carries |
| --- | --- | --- |
| 1 | `01-introduction-and-goals.md` | `## 1. Introduction and Goals` |
| 2 | `02-architecture-constraints.md` | `## 2. Architecture Constraints` |
| 3 | `03-context-and-scope.md` | `## 3. Context and Scope` |
| 4 | `04-solution-strategy.md` | `## 4. Solution Strategy` |
| 5 | `05-building-block-view.md` | `## 5. Building Block View` |
| 6 | `06-runtime-view.md` | `## 6. Runtime View` |
| 7 | `07-deployment-view.md` | `## 7. Deployment View` |
| 8 | `08-crosscutting-concepts.md` | `## 8. Cross-cutting Concepts` |
| 9 | `09-architecture-decisions.md` | `## 9. Architecture Decisions` |
| 10 | `10-quality-requirements.md` | `## 10. Quality Requirements` |
| 11 | `11-risks-and-technical-debts.md` | `## 11. Risks and Technical Debts` |
| 12 | `12-glossary.md` | `## 12. Glossary` |

**One file per top-level section; subsections stay inside their section file.** §5.1–5.3 are levels of one view and §10.1–10.2 are overview and detail of one concern — they are never split into files of their own. The section number is the merge unit, the scope unit, and the unit the reviewer diffs.

**All twelve section files always exist.** A section the Workfile marked omitted becomes a **stub** carrying the marker verbatim, not a missing file: a missing file cannot be told apart from "never seeded", "deleted by accident", or "deleted by someone who disagreed", and the whole point of the marker convention is telling considered-and-excluded from forgotten. A fixed file set also makes completeness a listing check, and makes a later delta that fills a previously omitted section the same whole-file replacement as any other.

**Directory identity rule.** A directory is an *arc42 directory document* if and only if it contains both `README.md` and `01-introduction-and-goals.md`. Use this rule, not the directory's name, wherever the shape of a target has to be classified.

**What is not persisted.** The work-package appendix and the traceability appendix are transient planning material and are never written into the project. The decision-record appendix is not persisted as a file either — it is the *source* of the files under the decision directory.

**Workfile-level process metadata is not persisted as a section.** The Workfile header can carry an account of how the document was produced rather than what the architecture is: `Revision N:` log entries, a `Contradictions found` blockquote, an inputs note, a completeness line. None of it has a field in the index format, and none of it gets a section file. Do not invent a home for it — the index carries `Status`, `Date`, `Document scope`, the Sections table, and the Change Log, and the fixed filename table admits no thirteenth section.

Its durable *substance* already has homes, written by the drafting step, not by you: a decision that changed belongs in that decision's own `Context` and `Consequences`, and an unresolved contradiction or a cost accepted under it belongs in §11 Risks and Technical Debts. Where the substance is in neither, that is a **gap to report** — the reviewed Workfile is what failed to carry it forward. Raw revision-log text pasted into a section file, or a `README.md` grown a "Revision History" heading, is the same invention this step never makes.

### Per-File Format

A filled section file:

```markdown
# 5. Building Block View

_Part of [<System / Subsystem> — Architecture (arc42)](README.md)._

<the section body from the Workfile, every heading promoted one level: `### 5.1 …` becomes `## 5.1 …`>
```

A stub for an omitted section:

```markdown
# 7. Deployment View

_Part of [<System / Subsystem> — Architecture (arc42)](README.md)._

_Omitted — <reason>_
```

Rules that hold for every section file:

- **One H1 per file**, `# N. <Title>`, taken from the fixed filename table's Workfile heading with the leading `##` promoted to `#`. Every heading inside the body is promoted by exactly one level with it.
- **The backlink line** is the second content line, verbatim as above, with the document title substituted.
- **Markers are copied verbatim.** Never reword, summarize, or drop a marker.
- **Per-file attribution.** If a section file still contains an `arc42 guidance §N` block, copy the Workfile's `Attribution and license` block directly under that file's H1 — in that file only. The if-and-only-if rule is per file: no surviving guidance in a file means no notice in it. Record which files carry it in the index.
- **`09-architecture-decisions.md`** carries the §9 decision-log table with its `Link` column rewritten from the Workfile's appendix anchor to the relative decision-file path — `decisions/0004-<slug>.md`, or `../adr/0007-<slug>.md` when the project's own decision directory is used. Each row's `Status` matches its decision file's own `Status:` line.
- **`decisions/NNNN-<slug>.md`** is the decision-record text from the Workfile's appendix verbatim, with every heading promoted by **two** levels — not one — and `Status:` promoted to `Accepted` for decisions the cited ratification record actually ratified. The slug is the kebab-case decision title. A decision file carries no backlink line; it is not a section of the document.
- **Prose `§N` references are left as written.** The numbered vocabulary is the navigation aid; rewriting prose cross-references into file links is error-prone and unreviewable. Navigation between files is the index's job.

**Heading promotion: one level for section files, two for decision records.** The promotion distance is the depth the content sits at in the Workfile, and the two shapes do not sit at the same depth.

- A **section** is a `## N. <Title>` heading, so its file's headings all move up exactly one level: `## 5. Building Block View` becomes the H1 `# 5. Building Block View`, and `### 5.1 …` inside it becomes `## 5.1 …`.
- A **decision record** is nested two levels deeper: `### ADR-NNNN: <title>` under the `## Appendix A` heading, with its `#### Context`, `#### Options Considered`, `#### Decision`, `#### Consequences`, and `#### Related` parts beneath it. Every heading in the record therefore moves up exactly **two** levels:

    ```text
    ### ADR-0004: <title>   →   # ADR-0004: <title>
    #### Context            →   ## Context
    #### Options Considered →   ## Options Considered
    #### Decision           →   ## Decision
    #### Consequences       →   ## Consequences
    #### Related            →   ## Related
    ```

Promoting a record by one level leaves the file with no H1 at all and its parts stranded at `###` — the file's title no longer matches the §9 row that links to it, and the one-H1-per-file rule that holds for every other file in the directory silently does not hold for the decision records.

### Index Format

`README.md` in the architecture directory:

```markdown
# <System / Subsystem> — Architecture (arc42)

- **Status:** Accepted
- **Date:** <YYYY-MM-DD of the last persistence>
- **Document scope:** <seed | seed + <n> delta(s)>

_Generated index — regenerated by the architecture persistence step, run standalone by the Architecture workflow or from the Software Engineering workflow's integration step. Edit the section files and decision records, not this file._

## Sections

| § | Section | State | Last updated |
| --- | --- | --- | --- |
| 1 | [Introduction and Goals](01-introduction-and-goals.md) | filled | 2026-09-18 |
| 2 | [Architecture Constraints](02-architecture-constraints.md) | omitted — <reason> | 2026-09-18 |
| … | … | … | … |
| 12 | [Glossary](12-glossary.md) | filled | 2026-09-18 |

Files carrying the arc42 attribution notice: <comma-separated list, or `none`>.

## Decision Records

<n> records in [`decisions/`](decisions/) (or the project's existing directory `<path>`) — log in [§9](09-architecture-decisions.md).

## Change Log

| Date | Scope | Sections written | Decisions added |
| --- | --- | --- | --- |
| 2026-09-18 | seed | 1, 4, 5, 6, 8, 9, 10, 11 (2, 3, 7, 12 omitted) | ADR-0001–ADR-0003 |
| 2026-10-02 | update delta | 5, 8, 9 | ADR-0004 |
```

`README.md` is **fully owned by this step**: the header and the Sections table are regenerated from the tree at every persistence, and Change Log rows are **appended, never rewritten**. Read the existing `README.md` before regenerating it — the Change Log is the one part of it that cannot be reconstructed from the tree. `Status` is `Accepted` at document level; per-section freshness is the `Last updated` column.

## When to Use

- Dispatched as the persistence step of the Architecture workflow — standalone, or from the integration session of the Software Engineering workflow (or its single package session when the package count is one) — after the architecture document has been reviewed and its decisions ratified.
- The brief supplies the reviewed architecture Workfile path, the ratification record, the pinned baseline, the default location, and whether the user explicitly directed migration of a legacy single-file document.
- **Not for** persisting requirements, work packages, or traceability; those are transient or persisted only on separate user direction.
- **Not for** authoring or revising architecture content. You transform and place what was reviewed; a content gap is a report item.
- **Not on your own initiative.** Persisting a document nobody reviewed, or ratifying a decision nobody ratified, is out of bounds even when the Workfile is sitting there.

## Workflow

1. **Collect the inputs.** The reviewed architecture Workfile path; the ratification record naming which decision IDs were ratified; the pinned baseline (the pre-change state of the target, or `new file`); the brief's default location (`docs/architecture/`); and whether the brief cites explicit user direction to migrate a legacy document (default: no). A missing ratification record means no decision may be promoted to `Accepted` — report it and stop rather than guessing.

2. **Resolve the target and classify its shape.** Read the Workfile header.
   - `Document scope: seed` → the default location.
   - `Document scope: update delta` → the `Existing document:` header line names the target. Verify the path exists; an unresolvable target is a blocking report item, not an invitation to seed.
   - Classify the target as **directory** (holds `README.md` and `01-introduction-and-goals.md`), **legacy single file** (one markdown file carrying the arc42 `## N.` headings), or **non-arc42** (anything else the architecture step mapped its delta onto).
   - **Seed collision rule.** If the default directory already exists and holds a `README.md` whose H1 does not end with `— Architecture (arc42)`, seed into `docs/architecture/arc42/` instead and report the fallback. Never overwrite a `README.md` that is not this document's index.

3. **Resolve the decision-record directory.** An existing `docs/adr/`, `docs/decisions/`, `adr/`, or `<target>/decisions/` always wins, in that order of search; otherwise create `<target>/decisions/`. Read the highest number already in use and continue that sequence — never restart at `0001` in a directory that already holds records.

4. **Seed mode.** For each of §1–§12, write the file the fixed filename table names, in the per-file format: H1, backlink line, then either the promoted section body or the omission marker verbatim for a stub. Insert the attribution block under the H1 of any file in which an `arc42 guidance §N` block survives. Write one decision file per record in the Workfile's decision appendix, every heading in it promoted by two levels (`### ADR-NNNN: …` → `# ADR-NNNN: …`, `#### Decision` → `## Decision`), and `Status: Accepted` if and only if that ID appears in the ratification record. Rewrite the §9 `Link` column to the relative decision-file paths **before** writing `09-architecture-decisions.md`. Generate `README.md` with one Change Log row, scope `seed`.

5. **Update-delta mode, directory target.** Write exactly the section files named in the Workfile's `Section scope: included=` list, by **whole-file replacement** in the same per-file format; filling a previous stub is that same replacement. One exception: for `09-architecture-decisions.md`, **append** the new rows and their one-line summaries at the end of the existing table — never rewrite or reorder an existing row, and never edit an existing decision file (a superseding record says so in its own text and in its own §9 row). Write the new decision files at the next free numbers. Regenerate the `README.md` header and Sections table from the resulting tree and append exactly one Change Log row. Every other file in the directory stays byte-identical.

6. **Update-delta mode, legacy single-file target.** Merge section-by-section into that one file: replace the affected `## N.` sections in place, append the §9 rows, leave everything else untouched. Decision files go to the project's existing decision directory, else `docs/adr/`. Do **not** convert the file to a directory. Report the shape as `legacy single file` so the workflow's deliverable can offer migration.

7. **Update-delta mode, non-arc42 target.** Apply the mapping table the Workfile carries — the architecture step wrote the delta in the existing document's own structure. Behavior here is unchanged by the directory layout: write the delta where the mapping says, convert nothing.

8. **Migration — opt-in only.** Run this only when the brief cites explicit user direction. Split the legacy file at its `## N.` headings into the twelve files, promoting headings as usual; a section absent from the legacy file becomes a stub `_Omitted — not present in the migrated document_`. Generate `README.md` with a Change Log row `migrated from <old path>`. Delete the old file **only after** the twelve files and the index exist. Leave the decision files where they are, rewriting the §9 links relative to the new `09-architecture-decisions.md`. Then apply step 5 for the current delta.

9. **Report a persistence manifest** in the session's evidence block:

   ```text
   Persistence: target=<path>, shape=<directory | legacy single file | non-arc42>, mode=<seed | update delta | migrate+update delta>, fallback=<none | docs/architecture/arc42/>
   | File | Action | Source |
   | --- | --- | --- |
   | README.md | created | index |
   | 05-building-block-view.md | replaced | Workfile §5 |
   | 07-deployment-view.md | stub | Workfile §7 marker |
   | 09-architecture-decisions.md | appended 1 row | Workfile §9 |
   | decisions/0004-<slug>.md | created (Accepted) | Appendix A ADR-0004 |
   | 01-introduction-and-goals.md | untouched | — |
   ```

   Actions vocabulary — use these words and no others: `created`, `replaced`, `stub`, `appended <n> rows`, `regenerated`, `untouched`, `migrated`, `deleted (migration)`. One row per file in the target, including the untouched ones: the manifest is what the review diffs against, so a file you left alone is as much a claim as a file you wrote.

## Quality Criteria

- After a seed, all twelve section files from the fixed filename table plus `README.md` exist, and the decision directory holds one file per record in the Workfile's decision appendix.
- Every filled section file equals its Workfile section exactly, modulo the one-level heading promotion and the added backlink line. No content was reworded, trimmed, or added.
- Every stub carries the Workfile's marker verbatim, under the same H1 and backlink line as a filled file.
- The attribution block appears in a section file if and only if that file still contains an `arc42 guidance §N` block, and the index lists exactly those files.
- Every decision file equals its Workfile record exactly, modulo the two-level heading promotion and the promoted `Status:` — one H1 reading `# ADR-NNNN: <title>` and its `Context`, `Options Considered`, `Decision`, `Consequences`, and `Related` parts at `##`.
- `Status: Accepted` appears only for decision IDs the cited ratification record ratified; a ratified decision never persists still reading `Proposed`.
- Every §9 row's link resolves relative to `09-architecture-decisions.md`, and the row's ID, title, status, and date match that file's own header. Every persisted decision file has a §9 row.
- In update-delta mode the set of changed paths is exactly: the `included=` section files, `09-architecture-decisions.md` (appended rows only), `README.md`, and the new decision files. Everything else is byte-identical to the pinned baseline.
- `README.md`'s Change Log grew by exactly one row, and the pre-existing rows are unchanged.
- A legacy single-file document was converted only when the brief cited explicit user direction; otherwise it was updated in place and reported as `legacy single file`.
- The work-package and traceability appendices were not written into the project.
- No file, section, or index field was created to hold the Workfile header's process metadata — its revision log, its contradictions blockquote, its inputs note — and no section file's body was padded with that text.
- The manifest accounts for every file in the target, action by action, and matches what the diff actually shows.

## Anti-Patterns

- **Overwriting instead of merging** — writing the delta's twelve files over an existing directory, or the delta document over an existing file, deletes content whose removal nobody reviewed.
- **Rewriting existing §9 rows** — the decision log is append-only; a reordered or reworded historical row destroys the record the log exists to keep.
- **Regenerating the index without reading it first** — the Change Log is the one part of `README.md` that cannot be reconstructed from the tree, and it is gone the moment you write over it blind.
- **Rewriting prose `§N` references into links** — unreviewable churn across every file, for navigation the index already provides.
- **Writing `_Not affected by this change_` into the project tree** — that marker belongs to a delta Workfile. An unaffected section is not written at all in update-delta mode; a persisted stub always reads `_Omitted — <reason>_`.
- **Converting a legacy document as a side effect** — moving a file that a project README, CI job, wiki, or issue tracker may link is a project decision, never a by-product of shipping a feature.
- **Splitting subsections into their own files** — §5.1 in its own file cannot stand alone, doubles the file count, and breaks the one-file-per-section merge unit.
- **Persisting the work-package or traceability appendices** — planning material in the project tree goes stale immediately and contradicts the next run.
- **Inventing the missing piece** — a section the Workfile left neither filled nor marked, a decision with no ratification, an index title that was never in the Workfile. Report the gap; do not close it here.
- **Promoting statuses wholesale** — setting every decision to `Accepted` because the run reached this step, rather than checking the ratification record ID by ID.
