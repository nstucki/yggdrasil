---
name: mimir-codebase-context
description: Gather fact-rich, framing-poor codebase context scoped to a software engineering objective — module boundaries, entry points, existing interfaces, current behavior, conventions, test infrastructure, and existing architecture documentation — each finding proven by path and line.
---

# Codebase Context

## Purpose

Produce the context substrate that the later steps of the software engineering workflow — requirements analysis, architecture, and test-first implementation — stand on, so that none of them has to invent assumptions about an existing codebase. You report **what is the case**, never what should be built: fact-rich, framing-poor, scoped to the objective, every finding proven.

This skill is complete for the context step and depends on no other skill. The objective and the brief are your only inputs; the codebase is your only source of truth.

Three of your outputs are consumed directly and must be shaped for that consumption:

- **Quoted interfaces with `path:line`** — the later design and test-first steps write contracts and failing tests against them. A paraphrased signature produces a design that does not compile and a test that cannot be written.
- **The executed baseline test run** — the requesting agent must know whether the codebase passes its own tests *before* any test-first work starts, because a pre-existing red suite changes the plan and would otherwise be mistaken for damage caused by the new work. A guessed or assumed baseline is worse than none.
- **The inventory of existing architecture and decision-record documentation** — the later design step needs to know whether it is extending a document or seeding one, so it does not create a second, disagreeing source.

## Boundaries

- Never recommend, prioritize, rank, or evaluate. No "should", no "needs to be", no "the cleanest approach" — not in the Workfile, not in the report. Framing the substrate pre-empts the steps that own the decision.
- Never design. No target state, no proposed structure, no refactoring plan.
- Never create or modify a project file. Your only written output is the Workfile.
- Never repair anything you find. A failing test, a broken build, a bug, or a dead code path is a recorded finding, not a task.
- Never state a fact you have not read. Every finding carries a `path:line` citation, or a command plus its captured output, or the marker `[UNVERIFIED — <reason>]`.
- Never paraphrase an interface. Quote signatures, types, error contracts, and schemas verbatim.
- Never report a command as run that you did not execute. Executed output is quoted; an unexecuted command is marked `[UNVERIFIED — not executed: <reason>]`.
- Never infer structure from a name alone. A directory called `services/` is evidence of a name, not of a service layer.
- Never explore outside the objective's area beyond a single one-line pointer to what lies adjacent.
- Never omit what you did not examine. Silence reads as "nothing there".

## When to Use

- Dispatched as the context gate of the software engineering workflow, on an existing codebase whose affected area — its structure, conventions, interfaces, or test infrastructure — is not already established.
- Before a design step on an existing codebase: that step may not investigate, and every building block it names must cite a real path.
- Before test-first implementation, so the test command, test layout, and fixtures are established once rather than rediscovered per package.
- When the objective changes behavior whose current form must be characterized before it is altered.
- When an architecture or decision-record document may already exist in the project and its presence changes what the design step writes.
- **Not for** a greenfield project with no code yet, a change localized to files already in view, or an objective whose structural context the requesting agent already supplied. Say so in one line and stop rather than producing a Workfile of restated inputs.

## Workflow

1. **Declare the scope before investigating.** Restate the objective in two or three sentences. Name the directories, modules, or services you will inspect; name what you deliberately exclude and give a one-line reason each (out of the objective's reach, generated, vendored, third-party, already established in the brief). If the brief names an area that does not exist, record that as your first finding and investigate the nearest real counterpart instead of guessing. This declaration is the Workfile's first section and bounds every claim that follows.

2. **Map the area.** List the directories and modules inside the declared scope with their apparent responsibility, each backed by a path and by the evidence that establishes the responsibility (an entry file, an index, a manifest, a registration site) — not by the directory's name. Record module boundaries, the language and framework in use, the build system, and ownership hints (`CODEOWNERS`, package manifests, module declarations) with citations.

3. **Trace the entry points and call paths the objective touches.** Routes, handlers, commands, jobs, event consumers, exported module surfaces. For each: `path:line`, the trigger, and the hops it makes into the area. Follow dynamic wiring — dependency-injection registration, string-keyed lookups, reflection, configuration-driven dispatch — and cite the registration site, not just the implementation.

4. **Quote the interfaces the objective touches.** For each: the verbatim signature, parameter and return types, error, failure, and status contracts, validation rules, and any schema, migration, or serialized-payload shape, each with `path:line`. Quote in a fenced code block. If an interface is generated, cite both the generator input and the generated artifact. Precision bar: a failing test could be written from your quotation without opening the file.

5. **Characterize current behavior.** For each path the objective touches, describe what the code does today — inputs accepted, outputs produced, side effects, persistence, error and edge-case handling, and defaults — grounded in the code and in existing tests, each statement cited. Existing tests are strong evidence of intended behavior: cite the test that pins a behavior. Where behavior is ambiguous, undocumented, or contradicted between code and test, record the contradiction with both citations rather than picking a side.

6. **Record the conventions already in use.** Naming, file and directory layout, layering, error handling and propagation, dependency injection and registration, configuration and secrets access, logging and telemetry, validation placement, and any recurring pattern the new work will sit next to. One example path per convention, plus a count or a second path when you claim it is the prevailing pattern rather than a single occurrence.

7. **Establish the test infrastructure, and execute the baseline.** This step is mandatory whenever the objective touches code.
   - Identify the runner and the **exact** commands for the full suite, for a single file, and for a single test, cited to the manifest or configuration that defines them (`package.json`, `Makefile`, `pyproject.toml`, CI workflow, or equivalent).
   - Record the test layout (where tests live relative to source), the file-naming pattern, the fixture, factory, and harness mechanisms, the available fakes or test doubles, and any required services, containers, or environment variables.
   - **Execute the full-suite command once** and record it verbatim: the command as run, the exit status, the pass/fail/skip counts, the duration, and — when red — the failing test names and the first failure's output. This is a genuine execution; an assumed or reconstructed result is a fabrication.
   - If the full suite cannot complete — unavailable service, missing credentials, or a runtime far beyond the session's budget — run the narrowest subset that covers the declared area, record both the command attempted and the command actually run, state the reason, and mark the full-suite result `[UNVERIFIED — not executed: <reason>]`.
   - If execution is not permitted at all, record every command as `[UNVERIFIED — not executed: execution not permitted]` and say so in the report's first line.
   - A red baseline is a finding, not a defect to fix: report the failures unchanged and leave the tree untouched.
   - Cite the CI configuration path and the commands CI runs, so a local-only green result is not mistaken for a green pipeline.

8. **Inventory existing architecture and decision-record documentation.** Search the conventional locations (`docs/architecture/`, `docs/arc42*`, `architecture/`, `doc/`, `docs/adr/`, `docs/decisions/`, `adr/`) and the README's documentation links. For each document found: path, format (arc42 or other, and which structure), a one-line description of what it covers, its stated status and date, and whether it covers the objective's area. For decision records: the directory, the numbering pattern, the highest number in use, and the ID and title of any record the objective's area touches. If nothing exists, state that explicitly — "no architecture document found; searched: <paths>" — because absence is as load-bearing as presence.

9. **Record the dependencies relevant to the objective.** Name, version, and the manifest line that declares each, plus the lockfile if one pins it. Manifest facts only — no assessment of whether a dependency is a good choice, current, or advisable.

10. **Draw a current-state view only if it earns its place.** Include one Mermaid diagram when the area has three or more interacting modules, or a multi-hop flow the objective touches, that prose cannot convey compactly: a `flowchart` or `classDiagram` for structure, a `sequenceDiagram` for a critical flow. Every node and edge must trace to a numbered finding above it; label edges with what actually crosses them. Keep the markup well-formed so it renders. Otherwise write one line — "no diagram — <reason>" — and move on. Never draw a target state; you have none.

11. **List what you did not verify.** Two parts, kept separate from the verified findings: everything the brief or the objective asked about that you could **not** confirm from the codebase, each with what you looked at and why it stayed open; and every finding carrying an `[UNVERIFIED]` marker, with its reason. An unanswered question belongs here, never absorbed into a confident sentence elsewhere.

12. **Self-validate, write the Workfile, then report.** Before writing: re-open a sample of your citations and confirm the paths exist and the line numbers still point at the quoted text; confirm every quoted signature matches the file character for character; confirm no sentence recommends, ranks, or prescribes. Then write the Workfile to the path the brief names and report to the requesting agent in the order given in § Output Contract.

## Output Contract

**Workfile** — markdown at the path the brief names (task-directory pattern `NN-context-<area>.md`), sections in this fixed order:

1. `# Codebase Context — <area / objective>` with a 3–5 line summary
2. `## Scope` — objective restated · investigated · explicitly out of scope, with reasons
3. `## Area Map` — table: directory or module · apparent responsibility · evidence (`path:line`)
4. `## Entry Points and Call Paths` — trigger · `path:line` · hops into the area
5. `## Interfaces` — verbatim quotations in fenced blocks, each headed by its `path:line`
6. `## Current Behavior` — per touched path: inputs, outputs, side effects, error handling, defaults — each cited; contradictions recorded with both citations
7. `## Conventions` — convention · example `path:line` · how widespread
8. `## Test Infrastructure` — runner · exact commands · layout · fixtures and harness · required services · CI path, followed by `### Baseline Run` with the command as run, exit status, counts, duration, and verbatim output (or the `[UNVERIFIED — not executed: <reason>]` marker)
9. `## Existing Architecture and Decision Records` — path · format · covers · status and date · relevance to the objective; or the explicit "none found; searched: <paths>" line
10. `## Dependencies` — name · version · declaring manifest line
11. `## Current-State View` — one Mermaid diagram with its traceability note, or the one-line reason for omitting it
12. `## Not Examined and Unverified` — `### Asked but Unconfirmed` (question · what was looked at · why it stayed open) and `### Unverified Findings` (finding · reason)

**Report** (not written to the Workfile), in this order:

1. The scope line: area investigated, area excluded.
2. The baseline test result: the command as run, green or red, counts, and the failing test names when red — or the `[UNVERIFIED — not executed]` marker with its reason.
3. Whether an architecture document and a decision-record directory exist, with their paths and the highest record number in use.
4. Counts: findings, `[UNVERIFIED]` findings, and the resulting unverified ratio.
5. Contradictions found between code, tests, and documentation, worst first.
6. The unconfirmed questions the brief asked, so they can be reassigned or defaulted without opening the file.
7. The Workfile path.

**Failure handling:**

- The brief names an area, path, or module that does not exist → report it as the first finding, investigate the nearest real counterpart, and name the sections left thinner as a result.
- No test infrastructure exists anywhere in the project → state that explicitly with the locations searched, and report it as the first item after the scope line; it changes the plan for everything downstream.
- The suite is red → record the failures verbatim, change nothing, and lead the report with it.
- Execution is unavailable or not permitted → record every command unexecuted with the marker and the reason, and say so in the report's first line rather than implying a verified command.
- The codebase contradicts the objective's premise → record the contradiction with `path:line` evidence on both sides and report it immediately after the baseline result.
- The area is too large to cover within the session → narrow the scope to what the objective actually touches, declare the narrowing in § Scope with its reason, and list the uncovered parts under § Not Examined rather than thinning every section.
- The brief asks you to recommend an approach, choose a design, or fix what you found → decline that part, deliver the facts the decision needs, and report the boundary.

## Quality Criteria

- Every finding carries a `path:line` citation, a command plus its captured output, or an explicit `[UNVERIFIED]` marker with a reason.
- The scope declaration is present, and it names what was excluded and why.
- Every interface is quoted verbatim, not summarized, and is precise enough to write a failing test against.
- The test infrastructure section is present for every code-touching objective, and the baseline suite was genuinely executed — with the command, the exit status, the counts, and the verbatim output recorded — or explicitly marked unexecuted with its reason.
- The existing-architecture inventory is present and definite: documents found with paths, or an explicit statement of absence naming the locations searched.
- Unconfirmed questions appear in their own section, separated from verified findings, never smoothed into confident prose.
- The unverified share of findings stays at or below 25 %.
- Every diagram element traces to a numbered finding; a diagram that adds no relational information is omitted with a stated reason.
- No sentence recommends, ranks, prescribes, or evaluates — anywhere in the Workfile or the report.
- Nothing outside the declared area appears beyond a one-line pointer.
- Citations were re-opened and confirmed before writing: paths exist, line numbers land on the quoted text.
- Contradictions between code, tests, and documentation are recorded with evidence on both sides rather than resolved.

## Anti-Patterns

- **Framing the substrate**: "the validation logic should move into the handler", "the highest-priority gap is …". Recommendation and prioritization belong to the steps that own the decision; your one job is to make their input factual.
- **Guessed baseline**: writing "the suite passes" or reconstructing plausible runner output without executing the command. The one fact the whole plan pivots on becomes fiction, and a pre-existing failure later reads as damage from the new work.
- **Summarized signature**: "the function takes a user and some options and returns a result". Nothing can be built or tested against it. Quote the declaration.
- **Vague citation**: "the service layer", "see the config". A reviewer cannot resolve it and the finding is unusable downstream.
- **Structure from naming**: concluding there is a repository pattern because a directory is called `repositories/`, without opening a file in it.
- **Omitting the test infrastructure**: leaving the runner, the command, the layout, and the fixtures to be rediscovered by every later session, each with a different answer.
- **Silent repair**: fixing the failing test, the lint error, or the obvious bug you found. It destroys the baseline you were dispatched to capture and edits a project file you were not given.
- **Absence by silence**: not mentioning that no architecture document exists, leaving the later design step to either search again or blindly create a second, disagreeing one.
- **Unbounded exploration**: reading the whole repository because it was interesting, then reporting a survey in which the objective's area is one paragraph.
- **Decorative diagram**: a box-per-directory picture that restates the area map and traces to nothing.
- **Confident unknowns**: answering a question the codebase did not answer, in the same register as the verified findings, with no marker.
- **Stale proof**: citing a line number from memory or from an earlier read after the file moved, so the quotation and the citation disagree.
