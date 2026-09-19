---
name: heimdall-architecture-review
description: Review the artifacts of the architecture workflow — the structural context findings an arc42 document is grounded in, the scaffolded arc42 skeleton, the filled arc42 document with its decision records in either mode, and the persisted architecture directory — selecting the checklist by a Focus line in the brief.
---

# Architecture Review

## Purpose

Independent verification of every architecture artifact. Four artifact shapes pass through this skill, one per dispatch, selected by the brief's `Focus:` line:

| `Focus:` | Artifact under review | The gate it guards |
| --- | --- | --- |
| `context` | an architecture-context report — the structural evidence base the document is written from | nothing is documented or decided from unproven structure |
| `scaffold` | the scaffolded arc42 Workfile — headings, pre-filled header, appendix treatment, attribution, no content | nothing is drafted into a skeleton whose header or shape classification is wrong |
| `document` | the filled arc42 document and its decision records, in `decide-new` or `document-existing` mode | no consumer receives an unreviewed contract, and no as-is record smuggles in a proposal |
| `persistence` | the persisted architecture directory and the decision records it wrote, against the persistence manifest | no unreviewed content and no unratified status reach the repository |

**Every checklist for an architecture artifact lives here.** A review of one of these four artifacts is this skill's dispatch — not an adjacent review skill's — and this skill carries the complete method for all four. A gap in it is a report item to the requesting agent, not license to improvise from another checklist.

**Ground truth, not self-report.** Every verdict rests on files you read at review time, commands you executed yourself, and paths you resolved. A producing session's claim about its own output is the thing under review, never evidence for it.

**Verdict grammar.** One line, the first line of the review Workfile:

```text
Verdict: <PASS | PASS-WITH-NOTES | BLOCKED> — focus=<context|scaffold|document|persistence>, mode=<decide-new|document-existing|n/a>, artifact=<path>, <one-clause reason>
```

- **PASS** — the artifact meets its contract and the spot-checks this Focus names all resolved.
- **PASS-WITH-NOTES** — it meets its contract with non-blocking gaps, named and located; it may be consumed as it stands.
- **BLOCKED** — one of this Focus's blocking conditions holds. Name it, locate it, and state what re-establishes it.

`mode=` carries the document mode under `Focus: document` and `n/a` under the other three.

The verdict is yours. What follows from it — resuming the session, re-dispatching it, or returning to the shape verdict — belongs to the requesting agent.

## Boundaries

- Never edit the artifact under review — not the Workfile, not the scaffold, not a persisted file. Findings go in the review Workfile; fixes belong to a producing session.
- Never fill in a missing section, header field, marker, or manifest row on the producer's behalf. An absent field is a finding, and supplying it destroys the very thing you were dispatched to check.
- Never re-do the producer's work: no re-deciding the architecture, no re-scoping the document, no re-classifying a decision as significant or not, no re-persisting a file. You validate evidence and conformance.
- Never review from session memory. On a re-review after a fix, re-read every changed file live.
- Never apply more than the one Focus the brief names — and never fewer.
- Never soften a blocking finding to keep a workflow moving, and never trade it for a promise to fix it afterwards.
- Never grant ratification. `Status: Proposed` on an authored document is correct; promotion is the requesting agent's act and the persistence step's write, and your job is to check it happened in that order.

## When to Use

- Dispatched as a review gate of the architecture workflow, with a `Focus:` line naming exactly one of `context`, `scaffold`, `document`, `persistence`.
- Dispatched as the standing review of an architecture-context session (`Focus: context`), a scaffold session (`Focus: scaffold`), or a persistence session (`Focus: persistence`), standalone or inside a composite run.
- Loaded by name from another review skill that needs the `Focus: persistence` checklist for an architecture directory its own session persisted. Apply that Focus exactly as written here, including its blocking conditions.
- With `Focus: document`, the brief also carries `Mode: decide-new | document-existing`. An absent `Mode:` line means `decide-new`.
- The brief also carries the producing session's brief, the paths of the artifacts to review, and the **pinned baseline** — the pre-change file state, or `new file` for a creation.
- **Not for** an engineering-context Workfile — the behavior, engineering-convention, and test-infrastructure report a test-first session is briefed from. It has a different contract and a different reviewer; route it to the engineering-review skill and say so.
- **Not for** deciding what the architecture should have been, re-running the context investigation, reviewing code or tests, or pronouncing on a step whose artifact does not exist yet.

## Workflow

**Apply only the subsection the brief's Focus names.** Steps 0, 1, and 2 always run.

**Step 0 — Read the control lines and pin the baseline.**

- `Focus: context | scaffold | document | persistence`. Missing or ambiguous → ask the requesting agent. Do not guess, and do not hedge by applying all four.
- Under `Focus: document`, read `Mode: decide-new | document-existing`; an absent line means `decide-new`. A `Mode:` line under `Focus: context`, `Focus: scaffold`, or `Focus: persistence` is context for the mode-driven items there, not a second checklist selector.
- Resolve every artifact path the brief names. A named path that does not exist is a blocking finding by itself.
- Pin the baseline: the pre-change file state, or `new file` for a creation. Every byte-identical claim and every diff is measured against it.
- Re-read the artifacts from disk now. Session memory of an earlier draft is not the artifact.

**Step 1 — Common checks (every Focus).**

- The named artifacts exist, are complete against their own declared output contract, and are the version the brief points at.
- The originating brief was honored: the inputs it named were used, its scope was not exceeded, and gaps were reported rather than invented.
- Every claim your verdict rests on is verified against ground truth — a resolved path, an executed command, or a line you quote from the live file.
- Every finding carries a location (`path:line`, section number, criterion ID) plus the evidence that establishes it and the change that would clear it.

### Focus: context

The artifact is the architecture-context Workfile: the structural evidence base the arc42 document is written from — module boundaries, entry points, boundary interfaces, the concepts the system already embodies, and what is already documented. Judge it as evidence. Whether the structure it reports is *good* structure is not this review's question.

- **Scope declaration.** A preamble names what was investigated — the whole system, a named subsystem, or the objective's structural footprint — and what was deliberately excluded, with a reason per exclusion. Without it you cannot distinguish a thin report from a narrow one, so its absence is blocking rather than a finding.
- **Output contract complete.** Scope; area map; entry points and call paths; boundary interfaces; cross-cutting concepts as embodied; existing architecture and decision records; dependencies; a current-state view or the explicit line saying why none was earned; and a not-examined list. A missing part is a finding.
- **Boundary interfaces quoted, not summarized.** Each provided and required surface of a module the document will describe is reproduced verbatim in a fenced block with its `path:line`. A paraphrase cannot be copied into a building-block entry and cannot be written against, so a summarized load-bearing interface is blocking.
- **Every finding proven.** `path:line`, or a command plus its captured output. "The service layer", "the modules talk over HTTP", "errors bubble up somewhere" are vague citations, not proofs.
- **Fact-rich, framing-poor.** No recommendation, no prioritization, no "should", no target-state description. Framing content is blocking: the drafting step must inherit facts to decide from, not conclusions already drawn for it.
- **Resolve at least two proofs yourself**, chosen from the module boundaries and the boundary interfaces — the two findings the building-block view rests on. The path exists, the line numbers are accurate, and a quoted interface matches the live file character for character.
- **Documentation facts resolve.** Every named architecture-document and decision-record path exists. When the scaffold step's `Scaffold result` line is also available, the reported document shape and highest record number must agree with it. **Resolve the target yourself and decide which side is wrong** — the finding goes against that side, never against whichever report you read second, and never split as a note on both.
- **`[UNVERIFIED]` discipline.** Each carries the reason verification was not possible, and they are at most a quarter of the findings.
- **Diagrams.** Every element of a current-state view traces to a stated finding. A proposed or target-state element inside it is framing.
- **Not checked here:** test infrastructure, a baseline test run, and current-behavior characterization. This shape carries none of them by contract. Their absence is never a finding and never blocking — they belong to the engineering-context shape and to the engineering-review skill that owns it.
- **BLOCKED on:** a proof that does not resolve or names a nonexistent path; recommendation, prioritization, or target-state content; a missing scope declaration; a load-bearing boundary interface summarized rather than quoted; unverified findings above a quarter of the total.

### Focus: scaffold

This is a short, mechanical review of a skeleton — eight items, a review Workfile of at most a page, and **no re-derivation beyond resolving paths and reading the highest existing decision number**. The scaffold contains no judgment to weigh; anything that needs weighing belongs to `Focus: document`.

1. **Headings complete and empty.** All twelve numbered arc42 headings, their subsection headings, and the appendix headings are present at the levels the skeleton sets — none renamed, renumbered, reordered, or missing — and **no section carries content**: the fenced `arc42 guidance §N` blocks and the `> **Yggdrasil:**` notes are intact, with no prose, no added table row, and no resolved placeholder in any section body.
2. **Header fields.** The header carries `Status: Proposed`, a `Date`, `Document scope: <seed | update delta>`, `Mode: <mode> (source: <direction | inference>)`, and `Section scope: pending`. A `Section scope:` already listing sections means scope was decided in the scaffold; a `Status` other than `Proposed` is authored ratification.
3. **`Mode` matches the brief.** The header's mode *and* its source equal what the scaffold brief stated, character for character.
4. **`Existing document` line iff update delta.** Present, with a resolvable path and a shape, when `Document scope: update delta`; absent when `seed`. That path is where the persistence step will later write, so resolve it.
5. **Shape re-derived.** Resolve the target yourself and confirm the classification: a directory is an arc42 directory only if it holds both `README.md` and `01-introduction-and-goals.md`; a single markdown file carrying the arc42 `## N.` headings is `legacy single file`; anything else describing the architecture is `non-arc42`; nothing found is `none` and therefore `seed`.
6. **`next-adr` re-derived.** Read the highest decision-record number in use in the project's decision directories. The reported `next-adr` is one above it, or `0001` when no record exists.
7. **Appendix treatment matches the mode.** `decide-new` → Appendices A, B, and C as the skeleton has them. `document-existing` → the Appendix A heading, and Appendices B and C each carrying only `_Not applicable — document-existing mode_`.
8. **Attribution present, nothing else written.** The `Attribution and license` block sits directly under the title — unconditionally, because the scaffold carries every guidance block. Confirm the session wrote only the briefed Workfile: no project file created, moved, or edited.

- **BLOCKED on:** a missing, renamed, or renumbered heading; a wrong shape or a wrong `next-adr`; any filled section content; the attribution block absent; the `Mode` header missing or mismatching the brief.

### Focus: document

Two checklists, selected by the brief's `Mode:` line; an absent line means `decide-new`. One item precedes both and applies whichever is selected:

- **`Mode:` header.** The document header carries `- **Mode:** <mode> (source: <direction | inference>)`, and both the mode and its source match the brief. **Absent or mismatched is blocking in either mode** — that line is what tells every later reader, and the persistence step, whether the document is a forward-looking proposal or a record of what already exists.

#### Mode: decide-new

- **Header.** `Status: Proposed`, the document scope (`seed` or `update delta`), and the `Section scope: included=…, omitted=…` line. A document or record authored at `Status: Accepted` is blocking — ratification is not the author's to grant, and a self-ratified decision bypasses the checkpoint entirely. In update-delta mode the header also carries `Existing document: <path> (<shape>)`: an absent line is a finding, and a path that does not resolve is blocking, because that path is where the persistence step will write.
- **Quality goals drive the document; they do not decorate it.** §1.2 is present, ranked, and holds three to five goals. Then verify they are *used*: §4 names a tactic per goal; every decision record's options table scores its options against the goals by name; §10 carries at least one scenario per goal whose measure has a number and a unit. A goal that appears in §1.2 and nowhere else was written after the design instead of driving it.
- **Pruning is explicit and honest.** Every arc42 section §1–§12 is present as a heading, and each is either filled because this objective affects it or marked omitted with a reason. Two symmetric failures: a section filled because the template has it rather than because the objective touches it — ceremony that buries the signal the implementation sessions need — and a genuinely inapplicable section given filler prose or silently deleted, leaving no way to tell considered-and-excluded from forgotten. Marker wording matches the mode — `_Omitted — <reason>_` in seed, `_Not affected by this change_` in update delta — because only the seed form is copied into the persisted section file; a mismatch is a note, not a blocker.
- **Attribution matches surviving template text.** The arc42 attribution and license notice sits at the top of the document **if and only if** at least one `arc42 guidance §N` block survived unfilled or undeleted somewhere in it. Search the document for both and compare the two answers. Surviving guidance text with no notice is a licensing gap that travels with the document when it is persisted into the repository or published — blocking. A notice over a document with zero remaining guidance text is attribution by reflex: it claims a share-alike license over the author's own prose and burdens the document with a constraint it does not carry — a note. The producing session only self-reports this; yours is the one independent read of it.
- **Decision records.** Each evaluates **at least two genuinely distinct options** — a straw man is one option wearing two hats — and states exactly one decision in the indicative, not a menu. Rationale ties to a named quality goal, constraint, or acceptance criterion. Consequences split positive and negative and say what **becomes harder**. Status is `Proposed`. Titles name the choice made, not the question asked.
- **Decision log ↔ records.** §9 lists every record with ID, title, status, date, and an appendix-anchor link (the persistence step rewrites it to a file path), and corresponds one-to-one with the record appendix — nothing in one and absent from the other. Records are linked from the log, not duplicated inside it; a full record body pasted into §9 creates a second copy that will drift. Conversely, a trade-off argued in a §4 paragraph with no record has no ID, no status, and no way to be superseded: a finding.
- **Building blocks (§5).** Each touched block has a blackbox entry with purpose and responsibility, provided and required interfaces, a real code location, and the criterion IDs it fulfills. **Open the cited paths** — at minimum the load-bearing ones. A path that does not exist, or a signature that contradicts the live code, is blocking. Then apply the writable-test standard to each interface: *could you write a failing test from this entry alone, without opening the implementation?* That needs signatures, parameter and return types, error and failure contracts, schema or migration changes, and the invariants a caller may rely on. Prose responsibilities with no signature fail it.
- **Behavior (§6).** Each scenario names the criterion IDs it realizes and walks an error path, not only the happy one. Diagram markup is well-formed enough to render.
- **Work-package breakdown.** Per package: write set as paths, owned criterion IDs, contracts provided and consumed by name, test seam and test command, dependencies, done criterion. A package missing any of these cannot be briefed or reviewed. Slices are vertical — a package named for a layer ("backend", "database") owns no criterion and cannot be tested alone. Shared-surface churn (dependency-injection registration, route tables, migrations, manifests and lockfiles, generated code, shared fixtures) sits in a single sequential scaffold package that runs before any parallel wave. The `Package check:` verdict must match what the table actually says: a parallel shape requires every check to read `yes` **and** you to confirm disjointness yourself by comparing the write-set path lists. Parallel by optimism — overlapping write sets, or contracts that do not exist yet — is blocking, because the tree corruption it causes cannot be recovered by a later review.
- **Traceability.** Every in-scope acceptance criterion appears exactly once, mapped to building block(s), decision record(s), and exactly one owning package. Zero packages is a coverage hole; two is a write-set collision waiting to happen. Both blocking.
- **Update-delta mode.** The document names, in its header line, the existing directory index or legacy file it deltas and states which sections it replaces; for a directory target, its §1.2 and §5 are consistent with the existing `01-` and `05-` section files or say explicitly what they change. It neither restates unaffected sections nor stands up a second, parallel document that disagrees with the first.
- **Gaps reported, not papered over.** Investigation gaps belong in the report. An unreported gap surfaces as an invented building block — which is why the §5 path spot-check carries more weight in this Focus than any other check.
- **BLOCKED on:** a single-option decision record; `Status: Accepted` authored anywhere in the document or its records; a §5 path or signature that does not resolve against the codebase; a parallel verdict over overlapping write sets or contracts that do not yet exist; an in-scope criterion with zero or two owning packages; a decision log and record set that disagree; `arc42 guidance §N` text surviving in the document with no attribution and license notice.

#### Mode: document-existing

Apply the shared items from the `decide-new` checklist — header and status, pruning and marker wording, attribution against surviving guidance, decision log ↔ records one-to-one, §5 paths opened, §6 scenarios and their error paths, gaps reported, update-delta consistency — then these, which replace the rest:

- **`Mode:` header present and matching.** `- **Mode:** document-existing (source: <direction | inference>)`. Absent or mismatched against the brief is **blocking**: an as-is record that does not say it is one will be read as a proposal.
- **Nothing is proposed.** §4 describes the strategy the system follows; §9 logs only decisions already in force; §11 is where improvement ideas live. A §9 row, a §4 tactic, or a decision record that proposes a change is **blocking** — read them in the indicative and check the tense and the modality, not the topic.
- **Every §5 block cites evidence that exists in the context Workfile.** Open the context Workfile and confirm the path is in it, then confirm the path resolves in the tree. A block whose evidence path is absent from the context Workfile is blocking: it was inferred, not observed.
- **Decision records are marked as-is.** Each carries `- **Kind:** as-is (inferred from <paths>)` with resolvable paths, has **no** `Options Considered` table, reads in the present indicative, and stands at `Status: Proposed`. A missing `Kind:` line is blocking; a reconstructed options table is blocking, because it presents a deliberation that never happened.
- **Quality goals are marked inferred.** §1.2 holds three to five ranked goals, each explicitly marked as inferred from evidence and carrying the paths it was inferred from. An unmarked goal reads as a requirement the system was built to, which nobody verified.
- **Section scope defaults to all twelve.** The inclusion test in this mode is evidence, not relevance: a section is filled from cited evidence or marked `_Omitted — no evidence in context Workfile_`, and every such marker appears in the report's gap list. A thin document whose gaps are all declared passes; one that quietly skips sections does not.
- **Appendices B and C carry `_Not applicable — document-existing mode_`** and nothing else. A populated work-package or traceability appendix in this mode is blocking — it is proposal content by another route.
- **Not applicable in this mode:** the ≥2-options item, the work-package breakdown item, the traceability item, and the quality-goal-to-§10-scenario item in its decide-new form (§10 scenarios here describe observed or explicitly unverified behavior). Do not block on them, and do not note their absence as a gap.
- **BLOCKED on:** a missing or mismatched `Mode:` header; proposal language in §4, §9, or a decision record; a §5 block whose evidence path is absent from the context Workfile; a decision record without its `Kind: as-is` line, or with an options table; a populated Appendix B or C; `Status: Accepted` authored anywhere; `arc42 guidance §N` text surviving with no attribution and license notice; a decision log and record set that disagree.

### Focus: persistence

Inputs are the persistence manifest, the reviewed architecture Workfile, the ratification record the brief cites, and the pinned baseline. There is no test-suite item here: a standalone architecture run has no suite to green.

- **Persisted architecture — merged, never overwritten.** The persisted form is a directory: one file per numbered arc42 section under the fixed filename table (`01-introduction-and-goals.md` … `12-glossary.md`), a generated `README.md` index, and one file per decision record. Apply the case the persistence manifest declares:
  - **(a) Seed.** The target holds `README.md`, all twelve `NN-*.md` files from the fixed filename table, and the decision directory. Open **at least two filled section files** and confirm each equals its Workfile section modulo the one-level heading promotion and the backlink line. Every omitted section is present as a stub carrying the Workfile's marker verbatim. The `README.md` Sections table matches the tree, state per file.
  - **(b) Update delta, directory target.** Run `git diff --name-status <baseline>` yourself: it lists **exactly** the `included=` section files, `09-architecture-decisions.md`, `README.md`, and the new decision files. `09-architecture-decisions.md` differs from the baseline only by appended rows — additions at the end of the table, no deletions. `README.md` differs only in its header, the Sections rows of the written files, and one appended Change Log row. Every other file is byte-identical.
  - **(c) Update delta, legacy single file.** The existing rule: diff the persisted file against the pinned baseline and confirm the changed hunks are exactly the named sections, with the §9 rows appended rather than rewritten.
  - **(d) Migration.** If the old single file was deleted and a directory created, the brief must cite explicit user direction for it. Migration without that citation is blocking, as an overwrite.
  - **(e) Per-file attribution.** For each section file: an `arc42 guidance §N` block is present if and only if the attribution and license block is present under that file's H1.
  - **(f) Manifest ⇔ diff.** The persistence manifest matches the observed diff action for action — `created`, `replaced`, `stub`, `appended <n> rows`, `regenerated`, `untouched`, `migrated`, `deleted (migration)`. A file the manifest calls `untouched` that the diff shows changed, or the reverse, is a finding on the manifest and a reason to widen the diff read.

  Overwriting a pre-existing document with a delta is blocking — it deletes content whose removal nobody reviewed.
- **Decision records promoted correctly.** Each persisted record matches the reviewed record text, is numbered continuing the project's existing sequence, and sits in the project's existing decision-record directory when one exists, else in `decisions/` inside the architecture directory. `Status: Accepted` appears only for decisions the ratification record the brief cites actually ratified — check it decision by decision. An unratified `Accepted` is blocking; so is a ratified decision persisted still reading `Proposed`.
- **Decision-record heading levels promoted by two, not one.** Open at least one persisted record beside its Workfile appendix entry and compare heading levels directly. A record sits two levels deeper in the Workfile than an ordinary section — `### ADR-NNNN: <title>` under `## Appendix A`, its parts at `#### Context`, `#### Options Considered`, `#### Decision`, `#### Consequences`, `#### Related` — so the file must read `# ADR-NNNN: <title>` with its parts at `##`. Section files promote by one level; decision records promote by two, and applying the section rule to a record is the defect this item exists to catch. A record file left with no H1, or with its parts still at `###`, also fails the log-to-file item, because the §9 row's title then matches no heading in the file it links to.
- **Log-to-file consistency both ways.** Every row of `09-architecture-decisions.md` resolves **relative to that file**: its link points at a file that exists, and its ID, title, status, and date match that file's own header. Every persisted record file has a row in the log. A mismatch in either direction is blocking.
- **Planning material stays transient.** The work-package breakdown and the traceability appendix are not persisted into the project.
- **Process metadata not promoted to a section; its substance survives elsewhere.** The Workfile header's `Revision N:` entries, `Contradictions found` blockquote, and inputs note are process metadata with no field in the index format. Check both directions, and check *substance*, not form:
  - **Nothing invented.** No file outside the fixed filename table was created to hold them, `README.md` grew no "Revision History" heading, and no section file's body was padded with raw revision-log text. In update-delta mode an extra path is already blocking as a changed path outside the permitted set.
  - **Nothing lost.** For each revision entry or contradiction that actually changed the architecture, confirm its substance is traceable to a decision record's `Context` or `Consequences`, or to §11 Risks and Technical Debts. Where it is in neither, the finding is against the reviewed Workfile, reported here and not fixed here — the persister was correct to invent no home for it. **Do not report the absence of a literal revision-history section as a gap**; its absence is the contract.
- **BLOCKED on:** an overwritten pre-existing document; a legacy single-file document converted without cited user direction; a changed path outside the permitted set in update-delta mode; a missing section file or index after a seed; `Accepted` without a cited ratification; a decision log and record files that disagree.

**Step 2 — Write the review Workfile.**

Write to the path the brief names, following the pattern for this Focus — `NN-review-context-architecture-<area>.md` for `context`, `NN-review-architecture-scaffold.md` for `scaffold`, `NN-review-architecture.md` for `document`, `NN-review-architecture-persistence.md` for `persistence` — in this order:

1. The verdict line.
2. **Blocking findings**, worst first: location, the evidence that establishes each, and the change that clears it.
3. **Notes** — non-blocking gaps, explicitly marked as not blocking consumption.
4. **Verification method** — what you checked by execution (the commands and their results), what you checked by reading, and what you could not verify and why. Under `Focus: scaffold`, this is the list of paths you resolved and the decision numbers you read.

Then report the Workfile path and the verdict line to the requesting agent.

## Quality Criteria

- Exactly one Focus was applied, and the verdict line names it — with the document mode under `Focus: document` and `n/a` otherwise.
- Every finding has a location and the evidence that establishes it, and states what would clear it — the producing session knows precisely what to change.
- Ground truth beat self-report: at least the spot-checks this Focus names were actually executed, and the review distinguishes what was verified by execution from what was verified by reading.
- The mode-specific items were applied and the inapplicable ones were not: a `document-existing` document was never blocked for a missing options table, work-package appendix, or traceability row.
- `Focus: scaffold` stayed mechanical — at most eight items, at most a page, and no re-derivation beyond path resolution and the highest-record lookup.
- The joint to the previous stage was checked rather than assumed: the context report against its scope declaration and the live tree, the scaffold against its brief, the document against the scaffold's header and its input Workfiles, the persisted directory against the reviewed Workfile and the ratification record.
- Blocking findings are separated from notes, so the requesting agent can tell a re-dispatch from a nicety.
- The producer's work was validated, not repeated: no re-deciding, no re-scoping, no re-persisting appears in the review.
- An artifact that could not be verified is reported as unverifiable with the reason. An unresolved check is never rounded up to PASS.

## Anti-Patterns

- **Rubber-stamping**: passing because the artifact looks complete and the session sounded confident.
- **Applying the wrong mode's checklist**: blocking an as-is document for a single-option decision record, or waving a decide-new document through because "it describes what exists". The `Mode:` line selects the checklist; read it first.
- **Blocking on absent ceremony**: reporting the missing Appendix B of a `document-existing` document as a coverage hole. The mode removes those items; treating their absence as a gap makes the mode unusable.
- **Reviewing the scaffold as a document**: weighing quality goals, decisions, or pruning in a file that by contract has no content. The scaffold review has eight mechanical items, and inventing more of them just delays the drafting step.
- **Trusting the reported shape**: accepting `document-scope=seed` or `existing=none` without resolving the paths yourself. A wrong classification silently turns a merge into an overwrite two steps later.
- **Trusting the reported `next-adr`**: accepting the number without reading the project's highest record, which is the one defect that corrupts a decision log irreversibly.
- **Passing a proposal as a record**: letting a §11 improvement migrate into §4 or §9 in document mode because it is a good idea. Whether it is a good idea is not this review's question.
- **Format-only attribution check**: confirming a notice exists without searching the document for surviving guidance blocks, or the reverse. The rule is an if-and-only-if and needs both answers.
- **Promoting statuses by inference**: accepting `Accepted` because the run reached persistence, instead of checking the cited ratification record decision by decision.
- **Reviewing from session memory**: re-reviewing a corrected artifact against what you remember of it instead of the file as it now stands.
- **Applying every checklist at once**: four Focus passes crammed into one dispatch produce a long review that verifies none of them properly.
- **Blocking a context report for engineering facts**: reporting a missing test command, baseline run, or behavior characterization in an architecture-context Workfile. The contract excludes them; demanding them makes the split pointless and forces a dispatch that gathers facts nobody downstream will read.
- **Re-doing the producer's work**: re-deciding the architecture, re-scoping the sections, or fixing the manifest you were dispatched to review.
- **Filling the gap you found**: writing the missing header field, marker, or section, and then passing the artifact that lacked it.
- **Nitpicking as a verdict**: a page of style notes with the overwritten document or the single-option decision unmentioned.
- **Negotiating a blocker**: downgrading BLOCKED to a note because the run is nearly finished — the cost of an overwritten document or an unratified promotion lands later and larger.
