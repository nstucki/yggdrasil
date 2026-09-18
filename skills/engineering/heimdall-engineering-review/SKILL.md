---
name: heimdall-engineering-review
description: Review the artifacts of the software engineering workflow — codebase-context findings, arc42 architecture documents with decision records, test-driven work packages, and integration results — selecting the checklist by a Focus line in the brief.
---

# Engineering Review

## Purpose

Independent verification at each gate of the software engineering workflow. Four artifact shapes pass through this skill, one per dispatch, selected by the brief's `Focus:` line:

| `Focus:` | Artifact under review | The gate it guards |
| --- | --- | --- |
| `context` | a codebase-context report | nothing downstream reasons from unproven structure |
| `architecture` | an arc42-structured architecture document and its accompanying architecture decision records | no implementation session receives an unreviewed contract |
| `package` | one work package's red-green-refactor evidence block, its diff, and its tests | no behavior is accepted without proof it was observed failing first |
| `integration` | a multi-package integration pass and the architecture directory and decision records it persisted | no red suite and no unreviewed design reach the repository |

**Ground truth, not self-report.** Every verdict rests on files you read at review time, commands you executed yourself, and paths you resolved. A producing session's claim about its own output is the thing under review, never evidence for it.

**Verdict grammar.** One line, the first line of the review Workfile:

```text
Verdict: <PASS | PASS-WITH-NOTES | BLOCKED> — focus=<context|architecture|package|integration>, artifact=<path>, <one-clause reason>
```

- **PASS** — the artifact meets its contract and the spot-checks this Focus names all resolved.
- **PASS-WITH-NOTES** — it meets its contract with non-blocking gaps, named and located; it may be consumed as it stands.
- **BLOCKED** — one of this Focus's blocking conditions holds. Name it, locate it, and state what re-establishes it.

The verdict is yours. What follows from it — resuming the session, re-dispatching it, or returning to the plan — belongs to the requesting agent.

## Boundaries

- Never edit the artifact under review, the code, or the tests. Findings go in the review Workfile; fixes belong to a producing session.
- Never fill in a missing evidence field, section, or test on the producer's behalf. An absent field is a finding, and supplying it destroys the very thing you were dispatched to check.
- Never re-do the producer's work: no re-investigating the codebase, no re-deciding the architecture, no re-implementing the package. You validate evidence and conformance.
- Never review from session memory. On a re-review after a fix, re-read every changed file live.
- Never apply more than the one Focus the brief names — and never fewer.
- Never soften a blocking finding to keep a wave moving, and never trade it for a promise to fix it afterwards.

## When to Use

- Dispatched by the requesting agent as a review gate of the software engineering workflow, with a `Focus:` line naming exactly one of `context`, `architecture`, `package`, `integration`.
- The brief also carries the originating session's brief or package contract, the paths of the artifacts to review, and the **pinned baseline** — the pre-change file state or the recorded test run this review measures against.
- When the reviewed session ran with `Phase:` and `Mode:` control lines, the brief echoes them: `Focus: package` covers a tests-only `Phase: red` session, a `Phase: green+refactor` session, and an integrated one alike.
- **Not for** deciding what should have been built, re-running the investigation, or pronouncing on a step whose artifact does not exist yet.

## Workflow

**Apply only the subsection the brief's Focus names.** Steps 0, 1, and 2 always run.

**Step 0 — Read the control line and pin the baseline.**

- `Focus: context | architecture | package | integration`. Missing or ambiguous → ask the requesting agent. Do not guess, and do not hedge by applying all four.
- Resolve every artifact path the brief names. A named path that does not exist is a blocking finding by itself.
- Pin the baseline: the pre-change file state, the recorded baseline test run, or `new file` for a creation. Every regression and every byte-identical claim is measured against it.
- Re-read the artifacts from disk now. Session memory of an earlier draft is not the artifact.

**Step 1 — Common checks (every Focus).**

- The named artifacts exist, are complete against their own declared output contract, and are the version the brief points at.
- The originating brief was honored: the inputs it named were used, its scope was not exceeded, and gaps were reported rather than invented.
- Every claim your verdict rests on is verified against ground truth — a resolved path, an executed command, or a line you quote from the live file.
- Every finding carries a location (`path:line`, section number, criterion ID) plus the evidence that establishes it and the change that would clear it.

### Focus: context

- **Scope declaration.** A preamble restates the objective and names what was investigated, what was deliberately excluded, and why. Without it, you cannot distinguish a thin report from a narrow one.
- **Output contract complete.** Area map; entry points and call paths; interfaces and types the objective touches; current behavior of those paths; conventions; test infrastructure; existing architecture documentation and decision records; relevant dependency facts; and an explicit not-examined list. A missing part is a finding; a missing test-infrastructure part on a code-touching objective is blocking.
- **Every finding proven.** `path:line`, or a command plus its captured output. "The service layer", "tests live under `test/`", "validation happens somewhere in the handler" are vague citations, not proofs.
- **Fact-rich, framing-poor.** No recommendation, no prioritization, no "should", no proposed design. Framing content is blocking: downstream steps must inherit facts to decide from, not conclusions already drawn for them.
- **Resolve at least two proofs yourself**, chosen from the most load-bearing findings — module boundaries, the interfaces the objective touches, the test command. The path exists, the line numbers are accurate, and a quoted signature matches the live file character for character.
- **Run the recorded test command.** It exists, it executes, and the recorded baseline result reproduces — or the difference is explained. A baseline reported as executed that does not reproduce is fabricated evidence, not a stale note.
- **Signatures quoted, not summarized.** A paraphrased signature cannot be tested against.
- **`[UNVERIFIED]` discipline.** Each carries the reason verification was not possible, and they are at most a quarter of the findings.
- **Documentation facts resolve.** Named architecture-document and decision-record paths exist, and the highest existing record number is right — the architecture step numbers its own records from it.
- **Diagrams.** Every element traces to a stated finding. A proposed or target-state element inside a current-state view is framing.
- **BLOCKED on:** a proof that does not resolve or names a nonexistent path; a recorded baseline run that does not reproduce; recommendation or prioritization content; absent test-infrastructure facts for a code-touching objective; unverified findings above a quarter of the total.

### Focus: architecture

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

### Focus: package

**(a) Evidence block.** The central claim is that every behavior was observed failing before it was implemented, and that claim is worth exactly as much as the captured output supports.

- **Complete before assessed.** Session header (package, phase, mode, criterion IDs, write set, test command); the baseline run; the red run; the green run; the final run; the criterion-to-test coverage table; files changed with any write-set deviation and its reason; the would-fail check; commits; and the gaps or concerns reported. A missing field is a finding — never fill it in for the author.
- **Verbatim or absent.** Real output names the runner, the test, and the failing assertion. "Tests failed as expected" is prose, and prose is not evidence: treat a paraphrased phase as a missing phase.
- **Red plausibility, per unit.** The failing test names appear in the diff; the output matches the project's real runner format; the failure is the assertion that was written, not a missing import, a syntax error, or a misconfigured harness. Infrastructure noise is not red evidence.
- **Resolve the coverage table, do not read it.** Open each cited `file:line`, confirm the test exists there, and confirm it asserts the criterion it is mapped to. An entry naming a test absent from the diff, or pointing at a test that already existed, voids red-before-green for that criterion.
- **Verify the would-fail check.** Its claim is that reverting the implementation alone would make the new tests fail again. Confirm it by reverting or stubbing the implementation and re-running when that is cheap; otherwise read each new test against the implementation and name the assertion that would break. State which method you used.
- **Distrust a frictionless narrative.** No red phase at all; every unit green on the first attempt; red captures identical in shape across distinct units; a red output that never mentions the behavior under test; a would-fail check described in generalities. Each signal is a reason to resolve *more* of the coverage table, not fewer.
- **Immediately-green tests** are legitimate only when the report says so and classifies them — already-implemented behavior, or a weak assertion that was then strengthened. An unclassified one is a finding.
- **Baseline honesty.** Failures already present at the pinned baseline are reported unchanged, neither quietly repaired nor hidden.

**(b) Code correctness.** Every owned criterion is implemented and behaves as the criterion states. Contracts conform exactly — signatures, types, error and status contracts match the specified blackbox interface or the codebase's existing signature, because a silent divergence breaks a sibling package that was built against the same contract. The edge, error, boundary, and permission cases the criteria name are handled. The code runs: run it. Nothing exists that no test demanded — no speculative abstraction, no unused configuration knob.

**(c) Test quality.** One behavior per test. Assertions on observable behavior, not internals. Deterministic and order-independent, with time, randomness, and network controlled. Assertion strength — would this fail on a plausible regression, or would it pass either way? No mocking so heavy that the test verifies its own fakes. Negative and boundary criteria have their own tests rather than a branch inside the happy-path test. Test structure that mirrors the implementation's structure is a sign of tests fitted to the code.

**(d) Discipline.** Files changed are a subset of the declared write set, with any deviation named and reasoned — compare the diff's path list against the write set yourself. In `Phase: green+refactor`, the handed-over tests are unchanged; a reviewed test edited by the implementing session is blocking. In `Mode: parallel`, verify against the diff and the version-control history rather than the report: no edits outside the write set including the shared scaffold, own test subset only, **no commits during the wave**, no tree-wide side effects (dependency installs, lockfile regeneration, repository-wide codegen or formatting), and no sibling failure skip-marked, disabled, or deleted to reach a clean run.

**(e) `Phase: red` sessions only.** No production code beyond the scaffolding the tests need to compile and execute; stubs may exist but must not satisfy an assertion; each test fails for its intended reason; and the handover states which units are covered and which remain.

**BLOCKED on:** a fabricated, paraphrased, or unresolvable red; tests back-filled after the implementation; a reviewed test modified in a `green+refactor` session; a write-set breach or a commit in `Mode: parallel`; an owned criterion with no test that was observed failing first. A broken cycle cannot be reconstructed after the fact, so the remedy is re-establishing it from a reverted state, not a note in the review.

### Focus: integration

- **Run the full suite yourself**, never a package subset, from the live tree. It is green, and no test that passed at the pinned baseline now fails. Baseline failures still present are reported unchanged.
- **Seams resolved.** Every seam the concurrent sessions reported is closed: no shared surface duplicated into two packages' local copies, no dangling stub the scaffold left behind, no consumed contract still unimplemented.
- **Write sets and history.** Against the wave's cumulative diff: no file was touched by two packages, and nothing landed outside the union of the declared write sets. The version-control history shows **no commit during the parallel wave**; where commits were permitted afterwards, each is phase-typed (`test:`, `feat:`, `fix:`, `refactor:`), atomic, and sits at a state whose tests were run. No transient workspace content is staged or committed.
- **Persisted architecture — merged, never overwritten.** The persisted form is a directory: one file per numbered arc42 section under the fixed filename table (`01-introduction-and-goals.md` … `12-glossary.md`), a generated `README.md` index, and one file per decision record. Apply the case the persistence manifest declares:
  - **(a) Seed.** The target holds `README.md`, all twelve `NN-*.md` files from the fixed filename table, and the decision directory. Open **at least two filled section files** and confirm each equals its Workfile section modulo the one-level heading promotion and the backlink line. Every omitted section is present as a stub carrying the Workfile's marker verbatim. The `README.md` Sections table matches the tree, state per file.
  - **(b) Update delta, directory target.** Run `git diff --name-status <baseline>` yourself: it lists **exactly** the `included=` section files, `09-architecture-decisions.md`, `README.md`, and the new decision files. `09-architecture-decisions.md` differs from the baseline only by appended rows — additions at the end of the table, no deletions. `README.md` differs only in its header, the Sections rows of the written files, and one appended Change Log row. Every other file is byte-identical.
  - **(c) Update delta, legacy single file.** The existing rule: diff the persisted file against the pinned baseline and confirm the changed hunks are exactly the named sections, with the §9 rows appended rather than rewritten.
  - **(d) Migration.** If the old single file was deleted and a directory created, the brief must cite explicit user direction for it. Migration without that citation is blocking, as an overwrite.
  - **(e) Per-file attribution.** For each section file: an `arc42 guidance §N` block is present if and only if the attribution and license block is present under that file's H1.
  - **(f) Manifest ⇔ diff.** The persistence manifest matches the observed diff action for action — `created`, `replaced`, `stub`, `appended <n> rows`, `regenerated`, `untouched`, `migrated`, `deleted (migration)`. A file the manifest calls `untouched` that the diff shows changed, or the reverse, is a finding on the manifest and a reason to widen the diff read.

  Overwriting a pre-existing document with a delta is blocking — it deletes content whose removal nobody reviewed.
- **Decision records promoted correctly.** Each persisted record matches the reviewed record text, is numbered continuing the project's existing sequence, and sits in the project's existing decision-record directory when one exists, else in `decisions/` inside the architecture directory. `Status: Accepted` appears only for decisions the ratification record the brief cites actually ratified — check it decision by decision. An unratified `Accepted` is blocking; so is a ratified decision persisted still reading `Proposed`.
- **Log-to-file consistency both ways.** Every row of `09-architecture-decisions.md` resolves **relative to that file**: its link points at a file that exists, and its ID, title, status, and date match that file's own header. Every persisted record file has a row in the log. A mismatch in either direction is blocking.
- **Planning material stays transient.** The work-package breakdown and the traceability appendix are not persisted into the project.
- **BLOCKED on:** an overwritten pre-existing document; a legacy single-file document converted without cited user direction; a changed path outside the permitted set in update-delta mode; a missing section file or index after a seed; `Accepted` without a cited ratification; a decision log and record files that disagree; a red suite or any regression against the baseline; a cross-package write-set violation.

**Step 2 — Write the review Workfile.**

Write to the path the brief names, following the pattern `NN-review-<focus>-<name>.md` — `NN-review-context-<area>.md`, `NN-review-architecture.md`, `NN-review-package-<name>.md`, `NN-review-integration.md` — in this order:

1. The verdict line.
2. **Blocking findings**, worst first: location, the evidence that establishes each, and the change that clears it.
3. **Notes** — non-blocking gaps, explicitly marked as not blocking consumption.
4. **Verification method** — what you checked by execution (the commands and their results), what you checked by reading, and what you could not verify and why.

Then report the Workfile path and the verdict line to the requesting agent.

## Quality Criteria

- Exactly one Focus was applied, and the verdict line names it.
- Every finding has a location and the evidence that establishes it, and states what would clear it — the producing session knows precisely what to change.
- Ground truth beat self-report: at least the spot-checks this Focus names were actually executed, and the review distinguishes what was verified by execution from what was verified by reading.
- The joint to the previous stage was checked rather than assumed. The workflow is one traceability chain — context facts → acceptance criteria → building blocks and decision records → work packages → tests → the integrated suite — and each Focus owns one link plus the seam behind it.
- Blocking findings are separated from notes, so the requesting agent can tell a re-dispatch from a nicety.
- The producer's work was validated, not repeated: no re-investigation, no re-design, and no re-implementation appears in the review.
- An artifact that could not be verified is reported as unverifiable with the reason. An unresolved check is never rounded up to PASS.

## Anti-Patterns

- **Rubber-stamping**: passing because the artifact looks complete and the session sounded confident.
- **Format-only evidence review**: confirming an evidence block has all its fields without resolving a single test location or running a single command.
- **Trusting paraphrase**: accepting "all tests pass" or "failed as expected" in place of captured run output.
- **Reviewing from session memory**: re-reviewing a corrected artifact against what you remember of it instead of the file as it now stands.
- **Applying every checklist at once**: four Focus passes crammed into one dispatch produce a long review that verifies none of them properly.
- **Re-doing the producer's work**: investigating the codebase yourself, redesigning the architecture, or fixing the code you were dispatched to review.
- **Filling the gap you found**: writing the missing evidence field, section, or test, and then passing the artifact that lacked it.
- **Nitpicking as a verdict**: a page of style notes with the write-set breach or the single-option decision unmentioned.
- **Negotiating a blocker**: downgrading BLOCKED to a note because the wave is nearly finished — the cost of a broken cycle or a corrupted tree lands later and larger.
- **Deferring to method that lives elsewhere**: this skill is the complete review method for these four gates. A gap in it is a report item to the requesting agent, not license to improvise from an unrelated checklist.
