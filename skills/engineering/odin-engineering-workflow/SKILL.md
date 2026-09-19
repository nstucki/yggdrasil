---
name: odin-engineering-workflow
description: Orchestration doctrine for the Software Engineering workflow — optional business analysis and arc42-structured architecture decision, then test-driven implementation across one or more reviewed work packages.
---

# Software Engineering Workflow

## Purpose

Define the orchestration doctrine for the Software Engineering workflow — a trigger-gated workflow that turns an engineering objective into working, tested code by way of an explicitly chosen shape: optional requirements analysis, optional architecture decision, then test-first implementation across one or more independently reviewed work packages.

The workflow packages the pattern `[Analysis] → [Architecture] → [Context] → Package plan → Checkpoint → (Scaffold → Review) → (Package A → Review ∥ Package B → Review ∥ …) → Integrate → Review → Response`. Two properties make it more than "Implement → Review": the **shape is decided and recorded before any dispatch**, and the **plan checkpoint** surfaces the packages, the execution mode, and the architecture decisions awaiting ratification before implementation commits. Parallelism is an emergent property of the work-package breakdown, never a default — it fires only when the five criteria in step 5 all hold.

This skill is dispatch doctrine only. `mimir-engineering-context`, `bragi-business-analysis`, `brokk-test-driven-development`, `heimdall-engineering-review`, and the Architecture workflow's skills (loaded by `odin-architecture-workflow`) are the per-step methodologies, loaded by the dispatched sessions themselves. Briefs name the skill, the inputs, and the Workfile to write — never the method.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (drafted by Bragi, step 9) and an Artifact (code and tests in the target project; plus the persisted arc42 architecture directory — a folder per section holding its generated index and topic documents, the decision records in `09-architecture-decisions/`, and the top index — whenever the architecture step fired). This fixes the Deliverable at Odin's top level:

```text
Deliverable: response=yes, artifact=yes — code and tests in the target project (plus the persisted arc42 architecture directory: a folder per section holding its index and documents, the decision records in their own folder, and the top index, when the architecture step fired), source=workflow-fixed
```

The requirements Workfile is **not** persisted by default; persist it to `docs/requirements/<slug>.md` only on user direction. Appendices B, C, and D of the architecture Workfile are transient planning content and are never persisted.

**Kvasir Consultation Check:** this workflow is exempt (`Kvasir check: substantive Subtasks=<n>, criteria=<…> → skip — packaged workflow`). Its strategic consultation is internal — the architecture step (step 3, delegated to the Architecture workflow), which is mandatory whenever the work splits into more than one package — and its checkpoint is the user's steering point. When this workflow is one stage of a larger composite plan, the composite is still evaluated by the Check as usual. Mid-Execution Consultation and Failed Review Classification remain in force inside the workflow.

**The architecture step is a delegation:** it loads and executes the Architecture workflow (`odin-architecture-workflow`), which carries its own mandatory design review of the architecture document before anything consumes it.

## When to Use

- When the Engineering check verdict is **invoke** — via the `/yggdrasil/engineer` command, explicit language requesting the engineering workflow, test-driven development, or requirements/architecture work ahead of implementation, or a user-accepted suggestion, per the Trigger Thresholds in your Communication Policy.
- **Not** for an ordinary implementation request. A plain "implement X", "fix this bug", "add this field" without workflow language is not an invoke: a non-trivial implementation request (new component, multi-module feature, new integration) is the *suggestion candidate*; a simple implementation request, a pure research request, or a question is a **skip**. Invoking the heavy workflow on ordinary work is the failure mode this threshold exists to prevent.

## Workflow

1. **Shape verdict (no dispatch).** Before dispatching anything, record:

    ```text
    Engineering shape: context=<yes/no — reason>, analysis=<yes/no — reason>, architecture=<yes/no — reason>
    ```

    All four `{analysis, architecture}` combinations are valid; the two steps are independent. Explicit user direction overrides inference in that direction and is recorded as the reason. Firing criteria:
    - **Context** (the engineering-context step, executed fourth) fires when ANY: the objective changes behavior whose current form must be characterized before it is altered — the tests pinning it, its edge cases, its defaults; the test infrastructure for the affected area (runner, exact commands, layout, fixtures, baseline result) is not already established in the conversation and a TDD session will need it; the engineering conventions the new code will sit next to are not established. Skip when greenfield, when the change is localized to files already in view *and* the test command is known, or when the user supplied the behavior and test facts. Structure is **not** a trigger here — module boundaries and interfaces are the Architecture workflow's own context gate.

      **Amendment at step 4.** This verdict is recorded now but executed after the architecture step, so it may be amended when step 4 is reached — restate the `Engineering shape:` line with the amended value and the reason that changed it (for example `context=yes — 3 packages touch paths whose tests are unknown`, from Appendix B). An amendment is always recorded, never silent, and the plan checkpoint (step 6) surfaces it beside the original verdict.
    - **Analysis** fires when ANY: outcome-phrased objective; acceptance criteria absent or ambiguous; multiple actors or stakeholders implied; user-facing behavior with unclear edge cases; requirements, a spec, stories, or acceptance criteria asked for; a natural-language request rather than a concrete change. Skip when the change is already testable (bug with a reproduction, small feature with stated behavior, behavior-preserving refactor) or the user declines.
    - **Architecture** fires per the decide-new firing criteria in `odin-architecture-workflow` § When to Use, and **without exception whenever two or more work packages are expected** — the split is itself an architecture decision.

2. **Business Analysis (optional).** Dispatch Bragi with `bragi-business-analysis` and the objective. Writes `NN-requirements.md`: acceptance criteria with stable IDs, ranked quality goals, non-functional targets, assumptions, capped open questions with proposed defaults, glossary. Relay the open questions per your Communication Policy — as ordinary clarifications before the architecture step proceeds under Interactive, or by adopting the proposed defaults as documented assumptions under Guided and Autonomous. No dedicated review.

3. **Architecture (optional).** Load `odin-architecture-workflow` and execute it as a sub-procedure with:

    ```text
    Architecture request: mode=decide-new, objective=<text>, requirements=<Workfile path | none>, persistence=deferred, location=docs/architecture/
    ```

    Pass no context: that workflow gathers its own structural evidence through its own gate, and the engineering-context Workfile is not produced until step 4. Record its returned `Architecture result:` block in full, including the review verdict and `Package check:`. **Ratification is yours** — the user ratifies at the checkpoint under Interactive, you ratify by adoption under Guided and Autonomous — and promotion to `Status: Accepted` happens at persistence. A `BLOCKED` review in that block goes through § Failed Review Classification — that workflow has spent its one resume, so return to the analysis step or the shape verdict; never plan from an unreviewed Appendix B.

4. **Engineering context (conditional).** Dispatch Mimir with `mimir-engineering-context`. Scope: when the architecture step fired, the write sets and consumed contracts of Appendix B's packages plus the acceptance criteria they own; otherwise the objective's touched paths. Require the output to be **fact-rich and framing-poor** — what is the case, not what should be built — with proofs per finding: the current behavior of each touched path, the engineering conventions the new code must follow, and the test infrastructure with an **executed** baseline run. Writes `NN-context-engineering-<area>.md`; its standing review is `heimdall-engineering-review` with `Focus: context`. Amend the step-1 `context=` verdict here if the architecture result changed it, stating the reason.

5. **Work-package plan and execution-mode verdict (no dispatch).** Record:

    ```text
    TDD plan: packages=<n>, shape=<single | sequential | scaffold→parallel(<k>)→integrate>, mode=<integrated | split-phase>, source=<architecture-doc | odin-single>
    ```

    **Package plan source:** Appendix B of the architecture Workfile named in step 3's return block — reviewed inside the Architecture workflow — when the architecture step fired; else `packages=1` with no dispatch. No plan is formed before that return block exists. Two or more candidate packages without a fired architecture step means the shape verdict was wrong — revise it so architecture fires.

    **Test command and baseline source:** the engineering-context Workfile from step 4 when that step fired; otherwise state each package's test command and baseline in its brief from what the conversation established. A plan that can name neither is a plan whose packages have no test seam — fire step 4 instead of guessing.

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

6. **Plan checkpoint (always recorded).** Surface a readable summary: the shape taken and why — including any step-4 amendment of the `context=` verdict and its reason — the packages and their owned acceptance criteria, the execution shape and mode, the architecture decisions awaiting ratification with their one-line rationales, the open risks, and the dispatch cost. Whether to pause for steering or auto-proceed is governed by your Communication Policy; when pausing, the user may toggle the optional steps, adjust the packages or the mode, ratify or overturn the architecture decisions, or redirect. When auto-proceeding, continue unless the plan is obviously defective and let the summary ride the Deliverable disclosure.

7. **Test-driven execution.** Dispatch Brokk per package with `brokk-test-driven-development`, the package contract from step 5, the reviewed architecture and requirements Workfile paths, and the control lines `Phase:` and `Mode:`. State in the brief whether commits are permitted; the skill carries its own commit rules. Each session returns an evidence block; Brokk writes no Workfiles.
    - **Integrated mode (default):** one session per package runs red → green → refactor. Two dispatches per package.
    - **Split-phase mode (opt-in):** a `Phase: red` session, its review, then a **fresh** `Phase: green+refactor` session and its review. Four dispatches per package. Use it for security- or contract-critical work, on user request, or after a review found tests fitted to the implementation.
    - **Parallel operating rules:** scaffold first and freeze it; `Mode: parallel` sessions run their own test subset only, never edit outside their write set, take no tree-wide side effects, and make **no commits** during a wave.

8. **Integration (fires iff packages ≥ 2).** Dispatch one Brokk session to run the full suite, resolve the seams the parallel sessions reported, and commit if commits were permitted. When the architecture step fired, this session also runs the Architecture workflow's persistence step (`odin-architecture-workflow` step 7) with the ratification record from the checkpoint; its brief contents are defined there. The session returns the persistence manifest in its evidence block. When packages = 1, fold these duties into that single session's brief.

9. **Deliverable (Response).** Dispatch Bragi to draft the user-facing response from the reviewed outputs: the shape taken and why, acceptance criteria covered and not covered, the architecture summary (§4 Solution Strategy in a paragraph) with the architecture directory path (its `README.md`) and the decision-record paths — and, when the persistence step refused a legacy target pending a migration direction, one line stating that nothing was written and putting the migration decision to the user — the packages and their test evidence, the assumptions adopted, the open risks from §11, and what the user should verify. Writes `NN-response-draft.md`.

**Review-skill assignment:** every review gate of this workflow dispatches a fresh Heimdall session with `heimdall-engineering-review` and exactly one `Focus:` line. The standing reviews (per § Review & Quality Gates in your system prompt — one per Mimir or Brokk session, plus the Final Review Gate) are not numbered above.

| Reviewed node | Brief line | Workfile |
| --- | --- | --- |
| Architecture document (step 3) | not yours — reviewed inside the Architecture workflow by `heimdall-architecture-review` | `NN-review-architecture.md` |
| Engineering context (step 4) | `Focus: context` | `NN-review-context-engineering-<area>.md` |
| Each package or phase session (step 7) | `Focus: package`, echoing that session's `Phase:` and `Mode:` lines | `NN-review-package-<name>.md` |
| Integration session (step 8) | `Focus: integration` | `NN-review-integration.md` |

Supply the originating brief, the artifact paths, and the pinned baseline with every dispatch — for a package review the evidence block and the diff, for the integration review the checkpoint's ratification record and the persistence manifest. The checklists live in the review skill. The Bragi session receives no dedicated review.

## Quality Criteria

- **Both verdicts are recorded before their dispatches** — the shape verdict before any dispatch, the TDD plan verdict before any implementation dispatch. The `shape=` field is a forcing function against the five criteria: a `Package check:` verdict carrying a `no` next to a `parallel` shape is visibly self-contradictory.
- **The plan checkpoint always happens**; only whether it pauses is policy-governed.
- **Parallel only under all five criteria**, with the scaffold completed and reviewed before fan-out and the wave capped at four.
- **The architecture document is reviewed before any package consumes it** — no implementation session receives an unreviewed contract, and no unreviewed architecture reaches the repo.
- **arc42 pruning is explicit** — the `Section scope:` line is recorded and every omitted section carries a marker.
- **Every acceptance criterion traces to at least one test** at a named location, and every implementation session returns red evidence captured before the implementation existed.
- **Ratification is explicit** — every persisted ADR was ratified at the checkpoint or by recorded adoption, and only then promoted to `Accepted`.
- **Cost (total dispatches, including the standing reviews and the Final Review Gate, which are not numbered steps):** `2C + A + 4R + 2X + 2N·(1+S) + 2I + 2`, where C, A, R, I are 1 when the context, analysis, architecture, and integration steps fire (0 otherwise), and **X is 1 when the architecture step fires *and* its own architecture-context gate fires inside the delegation** (0 otherwise, and always 0 when R=0) — the delegated workflow costs **4** of its own dispatches under `persistence=deferred` when that gate is skipped and **6** when its context pair runs, which is the usual case on a brownfield objective. N is the package count including any scaffold, and S is 1 in split-phase mode. Minimum 4; a medium run (A=1, R=1, N=2, I=1) is 13, or 15 with the delegated context pair; a full run (C=1, A=1, R=1, N=3, I=1) is 17, or 19 with it; the same full run in split-phase mode is 23, or 25. Disclose the cost qualitatively at the checkpoint and quantitatively on request.
- **The Deliverable discloses** the shape taken, the assumptions adopted, acceptance-criterion coverage, and the architecture directory and decision-record locations.

## Anti-Patterns

- **Silent shape inference.** Dispatching without the recorded `Engineering shape:` verdict, or skipping analysis and architecture by omission rather than by a stated reason — the reason is what the user steers against at the checkpoint.
- **Trigger creep.** Invoking the full workflow on ordinary implementation work. A plain "implement X" is a skip or a suggestion candidate, never an invoke.
- **Context before analysis by habit.** Running the engineering context step ahead of business analysis because the old order did — its consumers are the TDD plan and the implementation sessions, and analysis proceeds from the objective. Gathering behavior and test facts before the design exists also scopes the investigation to paths the packages may never touch.
- **Overlapping write sets in parallel.** Two concurrent sessions sharing a file in one working tree is corruption, not a merge conflict — and no review catches it reliably after the fact.
- **Fan-out before the scaffold is fixed.** Starting parallel packages while shared contracts, registrations, or fixtures are still in motion.
- **Commits during a parallel wave.** The tree holds other sessions' partial work; committing belongs to the integration session.
- **Layer-split packages.** "Backend", "frontend", "database" — none owns an acceptance criterion, none is independently testable, all collide on the shared surface.
- **Forming a plan from an unreviewed architecture document.** The return block's review verdict is the gate; a `BLOCKED` result routes through § Failed Review Classification instead of feeding Appendix B to 2N+ implementation dispatches.
- **Unreviewed architecture reaching the repo.** The persisted document and ADR files are user-facing Artifacts, not internal notes.
- **Accepting a package with no red evidence.** A passing suite proves nothing about whether the tests could ever have failed.
- **Persisting `Accepted` without ratification**, or persisting a delta over an existing document by overwriting it instead of merging document-by-document.
- **Migrating a legacy document as a side effect.** Conversion of a legacy arc42 document — a flat directory or a single file — into the folder-per-section layout happens only on explicit user direction; without it the persistence step refuses the target and writes nothing.
- **Template worship.** Letting all twelve arc42 sections be filled for a change that touches three, or briefing for a complete document instead of a pruned one — the ceremony buries the signal the implementation sessions need.
- **Restating specialist methodology in briefs.** Name the skill, the inputs, and the Workfile; the dispatched session loads its own method.
- **Re-architecting mid-flight.** If execution shows the design is wrong, that is Mid-Execution Consultation territory, not a second run of the architecture step.
- **Skipping the Final Review Gate.** The Deliverable — code, tests, and the persisted architecture documentation — is user-facing output and must pass the gate like any other.
