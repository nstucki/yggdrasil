---
name: odin-engineering-workflow
description: Orchestration doctrine for the Software Engineering workflow — optional business analysis and arc42-structured architecture decision, then test-driven implementation across one or more reviewed work packages.
---

# Software Engineering Workflow

## Purpose

Define the orchestration doctrine for the Software Engineering workflow — a trigger-gated workflow that turns an engineering objective into working, tested code by way of an explicitly chosen shape: optional requirements analysis, optional architecture decision, then test-first implementation across one or more independently reviewed work packages.

The workflow packages the pattern `[Context] → [Analysis] → [Architecture → Design Review] → Package plan → Checkpoint → (Scaffold → Review) → (Package A → Review ∥ Package B → Review ∥ …) → Integrate → Review → Response`. Two properties make it more than "Implement → Review": the **shape is decided and recorded before any dispatch**, and the **plan checkpoint** surfaces the packages, the execution mode, and the architecture decisions awaiting ratification before implementation commits. Parallelism is an emergent property of the work-package breakdown, never a default — it fires only when the five criteria in step 6 all hold.

This skill is dispatch doctrine only. `mimir-codebase-context`, `bragi-business-analysis`, `kvasir-software-architecture`, `kvasir-arc42-template` (loaded by the architecture step), `brokk-test-driven-development`, and `heimdall-engineering-review` are the per-step methodologies, loaded by the dispatched sessions themselves. Briefs name the skill, the inputs, and the Workfile to write — never the method.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (drafted by Bragi, step 10) and an Artifact (code and tests in the target project; plus the persisted arc42 architecture document and ADR files whenever the architecture step fired). This fixes the Deliverable at Odin's top level:

```text
Deliverable: response=yes, artifact=yes — code and tests in the target project (plus the persisted arc42 architecture document and ADR files when the architecture step fired), source=workflow-fixed
```

The requirements Workfile is **not** persisted by default; persist it to `docs/requirements/<slug>.md` only on user direction. Appendices B and C of the architecture Workfile are transient planning content and are never persisted.

**Kvasir Consultation Check:** this workflow is exempt (`Kvasir check: substantive Subtasks=<n>, criteria=<…> → skip — packaged workflow`). Its strategic consultation is internal — the architecture step (`kvasir-software-architecture`), which is mandatory whenever the work splits into more than one package — and its checkpoint is the user's steering point. When this workflow is one stage of a larger composite plan, the composite is still evaluated by the Check as usual. Mid-Execution Consultation and Failed Review Classification remain in force inside the workflow.

**One review gate beyond the standing rules:** when the architecture step fires, its document is reviewed by a dedicated `heimdall-engineering-review` (`Focus: architecture`) dispatch before anything consumes it (step 5). The standing rules exempt Kvasir sessions from dedicated review; this workflow overrides that exemption for this one node, because the document is the shared contract N parallel implementation sessions build against *and* is promoted to repo Artifacts. Standing rules are a minimum, not a maximum.

## When to Use

- When the Engineering check verdict is **invoke** — via the `/yggdrasil/engineer` command, explicit language requesting the engineering workflow, test-driven development, or requirements/architecture work ahead of implementation, or a user-accepted suggestion, per the Trigger Thresholds in your Communication Policy.
- **Not** for an ordinary implementation request. A plain "implement X", "fix this bug", "add this field" without workflow language is not an invoke: a non-trivial implementation request (new component, multi-module feature, new integration) is the *suggestion candidate*; a simple implementation request, a pure research request, or a question is a **skip**. Invoking the heavy workflow on ordinary work is the failure mode this threshold exists to prevent.

## Workflow

1. **Shape verdict (no dispatch).** Before dispatching anything, record:

    ```text
    Engineering shape: context=<yes/no — reason>, analysis=<yes/no — reason>, architecture=<yes/no — reason>
    ```

    All four `{analysis, architecture}` combinations are valid; the two steps are independent. Explicit user direction overrides inference in that direction and is recorded as the reason. Firing criteria:
    - **Context** fires when ANY: an existing non-trivial codebase whose structure, conventions, or test infrastructure for the affected area are not already established in the conversation; the architecture step fires on a brownfield codebase (err toward context — the architecture step may not investigate, and its building-block view must be grounded in real structure); the objective changes behavior whose current form must be characterized first. Skip when greenfield, when the change is localized to files already in view, or when the user supplied sufficient structural context.
    - **Analysis** fires when ANY: outcome-phrased objective; acceptance criteria absent or ambiguous; multiple actors or stakeholders implied; user-facing behavior with unclear edge cases; requirements, a spec, stories, or acceptance criteria asked for; a natural-language request rather than a concrete change. Skip when the change is already testable (bug with a reproduction, small feature with stated behavior, behavior-preserving refactor) or the user declines.
    - **Architecture** fires when ANY: new components, modules, or services, or a change crossing module boundaries; a new integration, persistence mechanism, schema change, or dependency; multiple viable structural approaches with material trade-offs; non-functional requirements driving the design; two or more candidate packages whose shared contracts do not already exist; design, architecture, an ADR, or arc42 documentation asked for. Skip when the change fits the existing structure and local patterns and one package suffices, or the user declines. It **fires, without exception, whenever two or more work packages are expected** — the split is an architecture decision and the packages need the contracts §5 specifies.

2. **Context gate (conditional).** Dispatch Mimir with `mimir-codebase-context` and the objective. Require the output to be **fact-rich and framing-poor** — what is the case, not what should be built — with a scope-declaration preamble, proofs per finding, and the test command. It may include *current-state* views; *target-state* views come from the architecture step's own document. Writes `NN-context-<area>.md`.

3. **Business Analysis (optional).** Dispatch Bragi with `bragi-business-analysis`, the objective, and the reviewed context Workfile when one exists. Writes `NN-requirements.md`: acceptance criteria with stable IDs, ranked quality goals, non-functional targets, assumptions, capped open questions with proposed defaults, glossary. Relay the open questions per your Communication Policy — as ordinary clarifications before the architecture step proceeds under Interactive, or by adopting the proposed defaults as documented assumptions under Guided and Autonomous. No dedicated review.

4. **Software Architecture (optional).** Dispatch Kvasir with `kvasir-software-architecture`, the objective, the requirements Workfile, and the context Workfile. Writes one Workfile, `NN-architecture-arc42.md`: arc42 §1–§12 pruned to the affected sections with omission markers on the rest, Appendix A (full ADR text, one per decision, `Status: Proposed`), Appendix B (work packages plus the `Package check:` verdict), Appendix C (traceability). Record the returned `Section scope:` and `Package check:` lines and the investigation gaps. **Each ADR carries one definite recommended decision at `Status: Proposed`; ratification is yours** — the user ratifies at the checkpoint under Interactive, you ratify by adoption under Guided and Autonomous — and promotion to `Status: Accepted` happens only on persistence (step 9).

5. **Design review gate (fires iff step 4 fired).** Dispatch a fresh Heimdall session with `heimdall-engineering-review`, `Focus: architecture`, the architecture Workfile path, and the requirements and context Workfile paths. This precedes the checkpoint so the user ratifies a reviewed document. Writes `NN-review-architecture.md`. A `BLOCKED` verdict goes through § Failed Review Classification — resume the Kvasir session for an execution defect; a plan-level mismatch returns to the analysis step or the shape verdict.

6. **Work-package plan and execution-mode verdict (no dispatch).** Record:

    ```text
    TDD plan: packages=<n>, shape=<single | sequential | scaffold→parallel(<k>)→integrate>, mode=<integrated | split-phase>, source=<architecture-doc | odin-single>
    ```

    **Package plan source:** Appendix B of the reviewed architecture document when the architecture step fired; else `packages=1` with no dispatch. Two or more candidate packages without a fired architecture step means the shape verdict was wrong — revise it so architecture fires.

    **Where each package's contents come from, by shape:**
    - **Architecture fired** — take the packages verbatim from Appendix B, and pass the §5 blackbox interfaces as the contracts and Appendix C as the acceptance-criterion ownership. Never re-derive a package that the reviewed document already specified.
    - **Architecture skipped, analysis fired** — acceptance criteria, quality goals, and glossary come from the requirements Workfile by ID; the contracts are whatever already exists in the codebase, named by path in the brief. If a package needs a contract that does not yet exist, that is the signal the architecture step should have fired — return to the shape verdict so the architecture step fires, rather than letting the implementation session invent the contract.
    - **Both skipped** — derive the single package's acceptance criteria and write set directly from the request, and **state the derived list explicitly in the brief** so the implementation session can correct it and the reviewer can check it. A derived list that needs more than one package returns, again, to the shape verdict; the architecture step fires.

    **A work package is** a named vertical slice carrying: a **write set** (paths), **owned acceptance criteria** (IDs), **contracts provided and consumed**, a **test seam and test command**, **dependencies**, and a **done criterion**. Slice vertically; a package named for a layer owns no acceptance criterion and cannot be tested alone.

    **Parallel dispatch is permitted only when ALL five hold** — one `no` means sequential:
    1. **Disjoint write sets** — parallel sessions share one working tree, so overlap is corruption, not a merge conflict.
    2. **Contracts fixed upfront** — in §5 blackbox interfaces or §8 concepts of the reviewed architecture document, or already present in the codebase.
    3. **Independently testable** — each package's tests pass without the others' real implementations.
    4. **Shared-surface churn isolated** — dependency-injection registration, route tables, migrations, dependency manifests and lockfiles, generated code, and shared fixtures belong to a **sequential scaffold package** that completes and passes review before any parallel package starts, or to the integration session.
    5. **Bounded fan-out** — two to four concurrent packages per wave; split the remainder into later waves.

    **Sequential when ANY:** a single slice; shared files; a dependency on another package's real implementation; global generated state; a bug fix; or the user asked for small steps.

7. **Plan checkpoint (always recorded).** Surface a readable summary: the shape taken and why, the packages and their owned acceptance criteria, the execution shape and mode, the architecture decisions awaiting ratification with their one-line rationales, the open risks, and the dispatch cost. Whether to pause for steering or auto-proceed is governed by your Communication Policy; when pausing, the user may toggle the optional steps, adjust the packages or the mode, ratify or overturn the architecture decisions, or redirect. When auto-proceeding, continue unless the plan is obviously defective and let the summary ride the Deliverable disclosure.

8. **Test-driven execution.** Dispatch Brokk per package with `brokk-test-driven-development`, the package contract from step 6, the reviewed architecture and requirements Workfile paths, and the control lines `Phase:` and `Mode:`. State in the brief whether commits are permitted; the skill carries its own commit rules. Each session returns an evidence block; Brokk writes no Workfiles.
    - **Integrated mode (default):** one session per package runs red → green → refactor. Two dispatches per package.
    - **Split-phase mode (opt-in):** a `Phase: red` session, its review, then a **fresh** `Phase: green+refactor` session and its review. Four dispatches per package. Use it for security- or contract-critical work, on user request, or after a review found tests fitted to the implementation.
    - **Parallel operating rules:** scaffold first and freeze it; `Mode: parallel` sessions run their own test subset only, never edit outside their write set, take no tree-wide side effects, and make **no commits** during a wave.

9. **Integration (fires iff packages ≥ 2).** Dispatch one Brokk session to run the full suite, resolve the seams the parallel sessions reported, and commit if commits were permitted. When the architecture step fired, this session also **persists the architecture document and the ADRs**: the document goes to the project's existing architecture-document location if one exists, else to `docs/architecture/arc42.md`; for an existing arc42 document it is **merged section-by-section** — replace the affected sections, append the §9 log rows, leave unaffected sections untouched. ADRs go to the project's existing ADR directory if one exists, else `docs/adr/NNNN-<slug>.md` at the next free number. All persisted statuses become `Accepted`, and §9 links resolve to the final relative paths. Appendices B and C are not persisted. When packages = 1, fold these duties into that single session's brief.

10. **Deliverable (Response).** Dispatch Bragi to draft the user-facing response from the reviewed outputs: the shape taken and why, acceptance criteria covered and not covered, the architecture summary (§4 Solution Strategy in a paragraph) with the document and ADR paths, the packages and their test evidence, the assumptions adopted, the open risks from §11, and what the user should verify. Writes `NN-response-draft.md`.

**Review-skill assignment:** every review gate of this workflow dispatches a fresh Heimdall session with `heimdall-engineering-review` and exactly one `Focus:` line. The standing reviews (per § Review & Quality Gates in your system prompt — one per Mimir or Brokk session, plus the Final Review Gate) are not numbered above, except the added design review in step 5.

| Reviewed node | Brief line | Workfile |
| --- | --- | --- |
| Context gate (step 2) | `Focus: context` | `NN-review-context-<area>.md` |
| Architecture document (step 5) | `Focus: architecture` | `NN-review-architecture.md` |
| Each package or phase session (step 8) | `Focus: package`, echoing that session's `Phase:` and `Mode:` lines | `NN-review-package-<name>.md` |
| Integration session (step 9) | `Focus: integration` | `NN-review-integration.md` |

Supply the originating brief, the artifact paths, and the pinned baseline with every dispatch — for a package review the evidence block and the diff, for the integration review the checkpoint's ratification record. The checklists live in the review skill. The Bragi and Kvasir sessions receive no dedicated review beyond step 5's gate.

## Quality Criteria

- **Both verdicts are recorded before their dispatches** — the shape verdict before any dispatch, the TDD plan verdict before any implementation dispatch. The `shape=` field is a forcing function against the five criteria: a `Package check:` verdict carrying a `no` next to a `parallel` shape is visibly self-contradictory.
- **The plan checkpoint always happens**; only whether it pauses is policy-governed.
- **Parallel only under all five criteria**, with the scaffold completed and reviewed before fan-out and the wave capped at four.
- **The architecture document is reviewed before any package consumes it** — no implementation session receives an unreviewed contract, and no unreviewed architecture reaches the repo.
- **arc42 pruning is explicit** — the `Section scope:` line is recorded and every omitted section carries a marker.
- **Every acceptance criterion traces to at least one test** at a named location, and every implementation session returns red evidence captured before the implementation existed.
- **Ratification is explicit** — every persisted ADR was ratified at the checkpoint or by recorded adoption, and only then promoted to `Accepted`.
- **Cost (total dispatches, including the standing reviews and the Final Review Gate, which are not numbered steps):** `2C + A + 2R + 2N·(1+S) + 2I + 2`, where C, A, R, I are 1 when the context, analysis, architecture, and integration steps fire (0 otherwise), N is the package count including any scaffold, and S is 1 in split-phase mode. Minimum 4; a medium run (A=1, R=1, N=2, I=1) is 11; a full run (C=1, A=1, R=1, N=3, I=1) is 15; the same run in split-phase mode is 21. Disclose the cost qualitatively at the checkpoint and quantitatively on request.
- **The Deliverable discloses** the shape taken, the assumptions adopted, acceptance-criterion coverage, and the document and ADR locations.

## Anti-Patterns

- **Silent shape inference.** Dispatching without the recorded `Engineering shape:` verdict, or skipping analysis and architecture by omission rather than by a stated reason — the reason is what the user steers against at the checkpoint.
- **Trigger creep.** Invoking the full workflow on ordinary implementation work. A plain "implement X" is a skip or a suggestion candidate, never an invoke.
- **Overlapping write sets in parallel.** Two concurrent sessions sharing a file in one working tree is corruption, not a merge conflict — and no review catches it reliably after the fact.
- **Fan-out before the scaffold is fixed.** Starting parallel packages while shared contracts, registrations, or fixtures are still in motion.
- **Commits during a parallel wave.** The tree holds other sessions' partial work; committing belongs to the integration session.
- **Layer-split packages.** "Backend", "frontend", "database" — none owns an acceptance criterion, none is independently testable, all collide on the shared surface.
- **Skipping the design review when the architecture step fired.** One dispatch guards a document that 2N+ dispatches build against; the standing Kvasir exemption is overridden here deliberately.
- **Unreviewed architecture reaching the repo.** The persisted document and ADR files are user-facing Artifacts, not internal notes.
- **Accepting a package with no red evidence.** A passing suite proves nothing about whether the tests could ever have failed.
- **Persisting `Accepted` without ratification**, or persisting a delta over an existing document by overwriting it instead of merging section-by-section.
- **Template worship.** Letting all twelve arc42 sections be filled for a change that touches three, or briefing for a complete document instead of a pruned one — the ceremony buries the signal the implementation sessions need.
- **Restating specialist methodology in briefs.** Name the skill, the inputs, and the Workfile; the dispatched session loads its own method.
- **Re-architecting mid-flight.** If execution shows the design is wrong, that is Mid-Execution Consultation territory, not a second run of the architecture step.
- **Skipping the Final Review Gate.** The Deliverable — code, tests, and the persisted architecture documentation — is user-facing output and must pass the gate like any other.
