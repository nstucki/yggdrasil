---
name: kvasir-software-architecture
description: Decide and document software architecture for a bounded objective using the arc42 template — quality goals first, pruned to the affected sections, with separate architecture decision records logged in section 9 and a work-package breakdown for test-driven implementation.
---

# Software Architecture

## Purpose

Produce the architecture of one bounded objective as an arc42-structured Workfile — either by **deciding** it, or by **recording as-is** the architecture the system already has. In the deciding mode you fix structure and contracts and the test-first implementation phase decides the code inside them; in the recording mode you describe the structure and contracts that exist, from cited evidence, and propose nothing.

**You receive a scaffolded Workfile and you fill it.** The brief names it on a `Scaffold: <path>` line and repeats the scaffold step's `Scaffold result:` line. That file already holds the arc42 skeleton — the twelve numbered headings with their per-section guidance, the appendices, the attribution notice — and a **pre-filled header** stating the status, the date, the document scope, the mode with its source, and, in update-delta scope, the existing document's path and shape. You look none of that up: the repository lookup that established the document's shape and the next decision-record number has already happened, and its answers are in the header and the `Scaffold result:` line. § Filling the Scaffold is how you work inside it.

Your single Workfile carries four parts:

- **arc42 §1–§12**, scoped by workflow step 3 — to the sections this objective affects when deciding, to every section the evidence supports when recording — with every omitted section retained as a heading plus an omission marker.
- **Appendix A** — the full text of one architecture decision record (ADR) per architecturally significant decision, whether you decided it or recorded it as-is.
- **Appendix B** — the work-package breakdown plus the `Package check:` verdict, which determines whether implementation runs sequentially or in parallel; `_Not applicable — document-existing mode_` when recording.
- **Appendix C** — traceability: acceptance criterion → building block(s) → ADR(s) → work package; likewise not applicable when recording.

**Two modes, selected by the brief's `Mode:` line. An absent line means `decide-new`.**

- **`Mode: decide-new`** — forward-looking. You choose between options, write one decision record per architecturally significant choice, and break the work into packages. Appendices A, B, and C are all yours.
- **`Mode: document-existing`** — as-is. You record what the system *is*, every claim citing a path from the context Workfile; existing decisions become decision records marked `Kind: as-is`; there are no work packages and no traceability appendix, and **you propose nothing**.

The mode is also a header field of the Workfile the scaffold pre-filled — `- **Mode:** <mode> (source: <direction | inference>)`. Echo it in your report and never change it: if the mode looks wrong for the inputs you were given, say so to the requesting agent instead of switching.

**Two document scopes, read from the pre-filled header, not decided by you:**

- **seed** — the project has no architecture document. You write the in-scope sections from scratch.
- **update delta** — one exists; its path and shape are in the header's `Existing document:` line. You write only the sections this objective changes, as a delta the persistence step merges file-by-file into the existing architecture directory (or section-by-section into a legacy single-file document). Update delta applies in both modes: a document-existing run over an existing arc42 directory is a refresh delta.

**Decisions are definite.** Each ADR names exactly one recommended option and states it in the indicative, not as a menu. You advise and the requesting agent ratifies, so every ADR and the document header ship with `Status: Proposed`; ratification at the plan checkpoint and promotion to `Status: Accepted` on persistence belong to the requesting agent and the implementation phase. A hedged recommendation forces the ratifier to redo your analysis.

## Boundaries

- Never write `Status: Accepted` on the document or on any ADR. `Proposed` is the only status you author, for a new decision and for an as-is one alike.
- **Never propose a change in `Mode: document-existing`.** An improvement idea goes to §11 as technical debt with its evidence — never into §4, never into §9, never into an ADR. A document that mixes the architecture that exists with the architecture someone would prefer is unusable as a baseline, and the reviewer blocks on it.
- Never create or modify project files. Your only written output is the scaffolded Workfile the brief names. The architecture directory and the decision-record files are persisted into the project by the persistence step, not by you.
- Never renumber, rename, or delete a heading the scaffold wrote, and never re-derive the header fields it pre-filled. A wrong pre-filled field is a report item, not an edit.
- Never run a substantive investigation to close a knowledge gap. Spot-check the codebase to confirm structure you were given, then **report the gap** — an unreported gap becomes an invented building block.
- Never put a building block, an interface, or a file path in §5 that you did not verify against the codebase or against an input Workfile. Cite the path.
- Never present a decision with one option in `Mode: decide-new`. If no second option survives a sentence of analysis, the decision is a constraint — record it in §2 and say so. In `Mode: document-existing` there are no options at all: an as-is record states the decision in force and cites its evidence.
- Never decide implementation minutiae the implementation phase owns: internal helper structure, local control flow, naming inside a building block, test case selection.
- Never fill an arc42 section because the skeleton has it. The inclusion criterion is relevance to *this* objective in `Mode: decide-new`, and cited evidence in `Mode: document-existing`; a section that meets neither gets its marker, not filler.

## When to Use

- Dispatched as the drafting step of the architecture workflow, with a scaffolded Workfile already written and its path in the brief.

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
- **Not without a scaffold.** If the brief names no `Scaffold:` path, or the path does not resolve, report it and stop — the skeleton, the header, and the next decision-record number arrive with that file, and re-creating them here would duplicate the scaffold step and diverge from it.
- **Not for** instantiating the skeleton, classifying the existing document's shape, or finding the next decision-record number. Those answers are in the header and the `Scaffold result:` line.

## Filling the Scaffold

Five rules govern how you work inside the file the scaffold wrote. They are mechanical; everything else in this skill is judgment.

1. **Fill or mark every heading — never delete one.** Every numbered heading, every subsection heading, and every appendix heading the scaffold wrote stays, at the level it wrote it. A section this objective does not affect keeps its heading and gets a one-line marker, so a reader can tell "considered and excluded" from "forgotten".
2. **Match the marker wording to the document scope in the header.** In **seed** scope use `_Omitted — <reason>_`, because the document is the project's whole architecture record and there is no change for a section to be unaffected by. In **update delta** scope use `_Not affected by this change_` for the sections the delta leaves alone. The persistence step copies a seed marker verbatim into the section's own file and never writes an unaffected section in update-delta scope, so `_Not affected by this change_` never lands in the project tree.
3. **Delete the guidance as you fill the section it belongs to** — the fenced `arc42 guidance §N` blocks and the `> **Yggdrasil:**` notes both. Guidance left in a finished section reads as instructions to a reader who is looking for the architecture. A section you mark omitted loses its guidance too: the marker is the section's content.
4. **Delete the attribution and license notice if and only if no guidance block survives.** When the last `arc42 guidance §N` block is gone from the Workfile, delete the `Attribution and license` block the scaffold placed under the title: the finished document then contains no arc42-licensed text, and keeping the notice claims a share-alike license over your own prose. **If any guidance block survives** — a section left unfilled with its guidance in place, or guidance deliberately retained — leave the notice exactly where it is and name every section that still carries arc42 text in your report. Surviving arc42 text keeps its license wherever the document goes, including into the project tree at persistence.
5. **Resolve or remove the placeholders in what you fill.** Angle-bracket placeholders (`<…>`) are fill-ins; a skeleton table row is an example of shape, not a required count. Leave the header block's fields as the scaffold set them, with exactly one exception: replace `Section scope: pending` with your own verdict from workflow step 3.

## Workflow

1. **Read the brief, the scaffold, and the inputs.**
   - Read the brief's `Mode:` line — absent means `decide-new` — and its `Scaffold: <path>` line and `Scaffold result:` line.
   - Read the scaffolded Workfile's pre-filled header. It is ground truth: the document scope (`seed` or `update delta`), the mode and its source, and — in update-delta scope — `Existing document: <path> (<shape>)` with the shape already classified. Do not re-derive any of it, and do not look for an architecture document or a decision-record directory yourself; `next-adr` in the `Scaffold result:` line is the number your records continue from.
   - Read every input Workfile the brief names. In `decide-new` that is typically a requirements Workfile (acceptance criteria, ranked quality goals, non-functional targets, glossary) plus a context Workfile describing the current codebase. In `document-existing` it is a reviewed, **system-scoped** context Workfile plus any user focus narrowing it to a subsystem; that Workfile is the evidence base every block you write must cite.
   - In update-delta scope, read the existing document the header names: for a directory target its `README.md`, then always `01-`, `04-`, `05-`, and `09-`, plus every section file this objective touches — not necessarily all twelve; for a legacy single file or a non-arc42 document, the file itself. A non-arc42 target also needs § Failure handling.
   - Spot-check the codebase to confirm the structural claims you intend to build on: module boundaries, entry points, existing interfaces, test layout. Confirming is reading a handful of named files; investigating is not your task.
   - Record every structural question you could not answer by reading your inputs and spot-checking as an **investigation gap**, and carry it into the report. Add a gap for any pre-filled header field that contradicts what you read — report the contradiction; never correct the field.

2. **Establish the quality goals first.** Adopt the ranked top 3–5 quality goals from the requirements Workfile verbatim into §1.2. If no requirements Workfile exists, derive 3–5 from the objective, rank them, and state the derivation basis in one line so the ratifier can challenge it. These goals are not decoration: they are the evaluation columns of every options table in step 4, the tactics §4 must name, and the source of the §10 quality scenarios. Everything you write in §4, §9, and §10 points back to §1.2.
   - In `Mode: document-existing` there is no requirements Workfile to adopt from. **Infer** 3–5 ranked goals from the evidence — what the existing structure, its tests, its error handling, and its dependencies were evidently optimized for — and mark each one inferred, citing the paths that suggest it. §1.1 then states the **documented scope** (the system, or the subsystem the focus names) and the evidence base it was written from, in place of the acceptance criteria a decide-new run references.

3. **Choose the section scope, then record it.**
   - In `Mode: decide-new`, include a section only when this objective affects it. Default minimum for a bounded change: **§1** (1.1 referencing the AC IDs in scope, 1.2 quality goals, 1.3 stakeholders only if they changed), **§4**, **§5**, **§6** (at least the one critical flow), **§8** (only the concepts touched), **§9**, **§10**, **§11**. Add **§2**, **§3**, **§7**, or **§12** only when constraints, system boundaries, deployment, or vocabulary actually change.
   - In `Mode: document-existing` the scope **defaults to all twelve sections**: the document's job is to describe the whole system, so the inclusion test is evidence, not relevance. Fill each section from cited evidence, and mark a section you cannot fill `_Omitted — no evidence in context Workfile_` rather than inventing it or leaving it blank.
   - Keep every omitted section as its heading with a one-line marker, with the wording § Filling the Scaffold rule 2 fixes for the document scope in the header. Never delete a section silently; the marker is how a reviewer knows you considered it.
   - Replace the header's `Section scope: pending` with the verdict line, and repeat it in your report:

     ```text
     Section scope: included=<list>, omitted=<list>
     ```

   - The header's `- **Existing document:** <path> (<shape>)` line is already there in update-delta scope, written by the scaffold; the persistence step reads it to find its target. Leave it as it stands and state in your report which sections your delta replaces.

4. **Enumerate and evaluate options per decision — `Mode: decide-new` only.** A decision is architecturally significant when it constrains structure, contracts, technology, an external dependency, or a quality goal — the ones that are expensive to reverse. For each: state the forces, then enumerate **at least two genuinely distinct options** (a straw man is not an option), and evaluate them in a table scored against the §1.2 quality goals by name and the §2 constraints.

   In `Mode: document-existing` there is nothing to enumerate: the option was chosen long ago and the system is the evidence of it. Skip the options table entirely — an invented one is a fabrication — and go to step 5's as-is branch.

5. **Decide, or record the decision already in force.**
   - **`Mode: decide-new`.** Pick one option per decision. Write the rationale, the consequences split into positive and negative, what becomes *harder* as a result, and the risks with their mitigations. Write each as an ADR in Appendix A using the format below, `Status: Proposed`. Summarize the set in §4 Solution Strategy and log every one in the §9 table.
   - **`Mode: document-existing`.** Record each **existing** decision the evidence lets you infer — one the codebase visibly embodies and that would be expensive to reverse — as an ADR in Appendix A with the extra line `- **Kind:** as-is (inferred from <paths>)` directly under `Date`, no `Options Considered` table, a `Context` stating the forces the evidence shows, a `Decision` in the present indicative ("The system uses X"), and consequences as they have actually played out. `Status:` is `Proposed` here too: what you are proposing is the *description*, and the requesting agent ratifies that description exactly as it ratifies a forward-looking decision. Log every one in §9 and summarize the set in §4 as the strategy the system **follows** — never as a strategy it should adopt. A decision you cannot evidence is not an ADR; it is an investigation gap.

6. **Specify the structure — §5 and §8.**
   - §5 Level 1: a whitebox of the system, or of the affected subsystem when the objective is local, as a Mermaid diagram plus a contained-blackboxes table and the motivation for the decomposition.
   - One **blackbox entry per building block the objective touches**: purpose and responsibility, provided and required interfaces, quality characteristics when relevant, code location, fulfilled AC IDs, open issues.
   - Interfaces must be precise enough that a failing test can be written from them without opening the implementation: signatures, parameter and return types, error and failure contracts, schema or migration changes, and the invariants the caller may rely on.
   - Go to Level 2 only for building blocks the objective changes internally.
   - §8: only the cross-cutting concepts this change introduces or alters — error handling, persistence, security, validation, logging, transactions, the testing approach. An unchanged concept is not your material.
   - In `Mode: document-existing`, §5 and §8 **describe what exists**: one blackbox per building block the system actually has, in the present tense, and every block, interface, and concept carrying a path from the context Workfile as its evidence. A block you cannot cite is an investigation gap, not a block. §8 covers the cross-cutting concepts the system embodies, not the ones it ought to.

7. **Specify behavior (§6) and deployment (§7).** §6: one `sequenceDiagram` per critical or quality-goal-relevant scenario, typically one to three, each naming the AC IDs it realizes and the error path it takes. §7 only when infrastructure, topology, or deployment changes; otherwise an omission marker.
   - In `Mode: document-existing`, §6 traces the flows the system runs today — each naming the evidence paths it was read from instead of AC IDs, and each walking the error path the code actually takes; §7 describes the deployment that exists, or carries an omission marker when the context Workfile holds no deployment evidence.

8. **Write quality requirements (§10) and risks (§11).** §10: turn each §1.2 quality goal into one to three concrete quality scenarios — stimulus → response → measure, with a number and a unit in the measure. These are the candidate non-functional tests the implementation phase can write. §11: the risks and technical debt this change introduces or retires, each with an impact, a likelihood, and either a mitigation or an explicit acceptance.
   - In `Mode: document-existing`, §10 states the scenarios the system's inferred goals imply and marks each measure as observed or unverified; §11 is where every improvement idea you had while reading belongs — as a risk or a technical debt with its evidence, never as a proposal in §4 or §9.

9. **Draw the diagrams.** Mermaid, in fenced ` ```mermaid ` blocks, placed adjacent to the prose they illustrate. `flowchart` with subgraphs for §3 context and §7 deployment; `classDiagram` or `flowchart` for §5; `sequenceDiagram` for §6; `stateDiagram` for a stateful building block when its states drive the design. Every element must trace to your specification or to an input Workfile, and the markup must be well-formed so it renders rather than degrading to raw text. One good diagram per view beats three partial ones; a diagram that adds no relational information is noise.

10. **Break the work into packages (Appendix B) and trace them (Appendix C) — `Mode: decide-new` only.**
    - In `Mode: document-existing` there is no work to package and no acceptance criterion to trace. Both appendix headings keep the marker the scaffold wrote — `_Not applicable — document-existing mode_` — and nothing else; there is no `Package check:` verdict, and item 3 of your report reads `Package check: n/a`. Inventing packages for a system that already exists is the one failure this mode makes easiest.
    - Per package: name, **write set** (paths), **owned AC IDs**, contracts **provided** and **consumed** (referencing the §5 blackbox interfaces by name), **test seam**, **dependencies**, **done criterion**.
    - Put shared-surface churn — dependency-injection registration, route tables, migrations, lockfiles, generated code, shared fixtures — into a single sequential **scaffold package** that runs before any parallel wave.
    - Record the verdict line:

      ```text
      Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
      ```

    - Parallel requires **all four** checks to be `yes`; one `no` means `sequential`. Cap a parallel wave at four packages and split the rest into later waves.
    - Slice vertically — each package delivers observable behavior end to end. A package that is "the data layer" owns no acceptance criterion and cannot be tested alone.
    - Appendix C: one row per AC — AC → building block(s) → ADR(s) → package. Every AC in scope appears exactly once with exactly one owning package; an AC with no package is a coverage hole, and one with two packages is a write-set collision waiting to happen.

11. **Finish the Workfile, then report.** Fill the scaffolded Workfile at the `Scaffold:` path in place — § Filling the Scaffold governs the mechanics, including whether the attribution notice survives — then report to the requesting agent in the order given in § Output Contract. Section scope first, investigation gaps last but never omitted.

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
<AC IDs · building blocks (§5) · other ADR IDs · the work package that implements it>
```

In `Mode: document-existing` the same format applies with three differences: a `- **Kind:** as-is (inferred from <paths>)` line sits directly under `- **Date:**`; the `Options Considered` table is **dropped**, because no option was weighed in this session and a reconstructed one is fiction; and `Decision` states what the system does, in the present indicative ("The system stores order history as an append-only event log"), followed by the evidence that establishes it. `Status:` stays `Proposed`, `Consequences` records the consequences that have actually materialized, and `Related` names the §5 blocks and the evidence paths instead of a work package.

Title ADRs by the choice made ("Event-sourced order history"), not by the question asked ("Order history storage"), so the §9 log reads as a list of positions. Number them from the `next-adr` value in the brief's `Scaffold result:` line, which already continues the project's existing sequence — never re-derive it. Link each ADR from the §9 table by its appendix anchor; the persistence step rewrites the link to the decision file's relative path. A decision that supersedes an existing project ADR names it in `Related` and says so in §9 — you do not edit the superseded file.

## Output Contract

**Workfile** — the scaffolded markdown file at the brief's `Scaffold:` path (task-directory pattern `NN-architecture-arc42.md`), filled in place, in this order:

1. `# <System / Subsystem> — Architecture (arc42)` with the pre-filled header lines `Status: Proposed`, `Date`, `Document scope: <seed | update delta>`, `Mode: <mode> (source: <direction | inference>)`, the `Section scope:` verdict you wrote over `pending`, and — when the scope is update delta — `Existing document: <path> (<shape>)`. The `Attribution and license` block sits between the title and the header lines, and survives if and only if a guidance block does.
2. arc42 `## 1.` through `## 12.`, every heading present, each either filled or carrying its omission marker.
3. `## Appendix A — Architecture Decision Records` — full ADR text, one per decision; in `Mode: document-existing` each carrying its `Kind: as-is (inferred from <paths>)` line.
4. `## Appendix B — Work Packages` — the package table plus the `Package check:` verdict in `Mode: decide-new`; the single line `_Not applicable — document-existing mode_` in `Mode: document-existing`.
5. `## Appendix C — Traceability` — AC → building block(s) → ADR(s) → package in `Mode: decide-new`; the same `_Not applicable — document-existing mode_` marker in `Mode: document-existing`.

Appendices A–C are Workfile content. On persistence, §1–§12 become one file per section and Appendix A becomes one decision-record file per ADR; Appendices B and C are not persisted.

**Report** (not written to the Workfile), in this order:

1. The `Section scope:` line.
2. The decision list: ADR ID, title, and one line of rationale each — in `Mode: document-existing`, each marked `as-is` with its evidence paths.
3. The `Package check:` verdict line, with the resulting shape — or exactly `Package check: n/a` in `Mode: document-existing`.
4. Open risks from §11, worst first.
5. **Investigation gaps** — what you could not confirm, what you assumed instead, and which section is weakest as a result. In `Mode: document-existing` this includes every section you marked `_Omitted — no evidence in context Workfile_`.
6. The Workfile path, the `Mode:` line with its source, the document scope, the document status (`Proposed`), and the existing document's shape as the header states it — `directory | legacy single file | non-arc42 | none`.
7. Whether any arc42 guidance text remains in the Workfile — and therefore whether the attribution and license notice was kept or deleted — naming the sections that still carry arc42 text.

**Failure handling:**

- The brief names no `Scaffold:` path, or the path does not resolve → report it and stop. Do not write the skeleton yourself: it would diverge from the one the scaffold step produced and was reviewed.
- The scaffolded Workfile is malformed — a missing or renumbered heading, a header field absent, appendix treatment contradicting the brief's `Mode:` → report it as a blocking input defect and stop. Repairing the scaffold here hides the defect from the review that already passed it.
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

- The work happened inside the scaffolded Workfile: every heading the scaffold wrote is still there, at its level, and the header's pre-filled fields are untouched apart from `Section scope:`.
- The quality goals appear in §1.2 before any decision, are ranked, and number three to five.
- Every included section is there for the mode's stated reason — the objective affects it (`decide-new`) or the evidence supports it (`document-existing`) — and every excluded one carries an explicit omission marker in the wording the document scope fixes.
- No `arc42 guidance §N` block and no `> **Yggdrasil:**` note remains in a filled or marked section, and the attribution notice is present if and only if a guidance block survives somewhere.
- Every §5 blackbox names a real code location, and its interfaces are precise enough to write a failing test against without reading the implementation.
- Every diagram element traces to the specification or to an input Workfile, and the Mermaid markup is well-formed.
- §4 summarizes the decisions and cross-references the ADR IDs; §9 logs every ADR with ID, title, status, date, and link, one-to-one with Appendix A.
- Every ADR and the document header read `Status: Proposed`.
- ADR numbering starts at the `next-adr` value the brief supplied.
- In update-delta scope, unaffected section files (or sections of a legacy file) are left untouched and the report says which sections the delta replaces.
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
- Appendices B and C carry `_Not applicable — document-existing mode_` and nothing else, and the report's item 3 reads `Package check: n/a`.

## Anti-Patterns

- **Template worship**: in `decide-new`, filling all twelve sections for a change that touches three, producing a document whose signal is buried in ceremony. Prune, and mark what you pruned.
- **Silent deletion**: dropping an irrelevant section instead of marking it omitted, leaving a reviewer unable to tell considered-and-excluded from forgotten.
- **Re-scaffolding**: rewriting the skeleton, re-deriving the document scope, re-classifying the existing document, or renumbering the ADRs from `0001` — work that already happened, whose answers are in the header and the `Scaffold result:` line. A pre-filled field you disagree with is a report item.
- **Single-option decisions**: in `decide-new`, an ADR whose options table has one row plus a straw man. That is a rationalization, not a decision.
- **Proposing in document mode**: a §4 tactic, a §9 row, or an ADR that recommends a change to a system you were asked to describe. The document stops being a baseline the moment it mixes what is with what should be; §11 is where the idea belongs.
- **Reconstructed options**: an as-is ADR with an invented `Options Considered` table, presenting a choice nobody in this session weighed as if it had been.
- **Uncited as-is claims**: a §5 block, a §6 flow, or an inferred quality goal in document mode with no evidence path. Without the citation a reader cannot tell the architecture that exists from the one you assumed.
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
