---
name: odin-architecture-workflow
description: Orchestration doctrine for the Architecture workflow — arc42 architecture in two modes, recording an existing system as-is or deciding new structure, scaffolded then drafted, design-reviewed before persistence, and reusable by a composite caller through a one-line contract.
---

# Architecture Workflow

## Purpose

Define the orchestration doctrine for the Architecture workflow — a trigger-gated workflow that produces one arc42 architecture document in one of two modes, reviews it, and persists it into the target project. This skill is the single source of doctrine for architecture work: mode selection, the conditional context gate, the scaffold step, the drafting dispatch, the mandatory design-review gate, ratification, persistence, and the Response — plus the contract a composite caller uses to reuse all of it.

**The two modes are the whole shape of the workflow:**

- `document-existing` — reverse-engineer and record the current architecture as-is, proposing nothing.
- `decide-new` — decide forward-looking architecture for a bounded objective, with decision records at `Status: Proposed` and a work-package breakdown.

The workflow packages the pattern `Shape verdict → [Context → Review] → Scaffold → Review → Draft → Design Review → Checkpoint → Persist → Review → Response`. Two properties make it more than "Draft → Review → Persist": the **mode and its source are decided and recorded before any dispatch**, and **the arc42 Workfile is scaffolded by one role and filled by another** — mechanics and judgment have separate owners.

This skill is dispatch doctrine only. `mimir-codebase-context`, `brokk-arc42-template`, `kvasir-software-architecture`, `heimdall-architecture-review`, `heimdall-engineering-review`, and `brokk-architecture-persistence` are the per-step methodologies, loaded by the dispatched sessions themselves. Briefs name the skill, the inputs, and the Workfile to write — **never the method**. In particular, how a skeleton is instantiated, how document shape is classified, and how the next decision number is resolved are the scaffolding skill's rules, not yours.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (drafted by Bragi, step 8) and an Artifact (the persisted arc42 architecture directory — one file per section, one per decision record, plus its index). This fixes the Deliverable at Odin's top level:

```text
Deliverable: response=yes, artifact=yes — persisted arc42 directory (absent only when persistence=deferred to a caller or declined by the user in decide-new mode), source=workflow-fixed
```

`document-existing` mode always persists — the user may choose the location, not whether to record it. Appendices B and C of the arc42 Workfile are transient planning content and are never persisted.

**Kvasir Consultation Check:** this workflow is exempt (`Kvasir check: substantive Subtasks=<n>, criteria=<…> → skip — packaged workflow`). Its strategic consultation is internal — the drafting step (`kvasir-software-architecture`) — and its ratification checkpoint is the user's steering point. When this workflow is one stage of a larger composite plan, the composite is still evaluated by the Check as usual. Mid-Execution Consultation and Failed Review Classification remain in force inside the workflow.

**One review gate beyond the standing rules:** the drafted document is reviewed by a dedicated `heimdall-architecture-review` (`Focus: document`) dispatch before anything consumes it (step 5). The standing rules exempt Kvasir sessions from dedicated review; this workflow overrides that exemption for this one node, because the document is promoted to repo Artifacts *and*, in a composite run, is the shared contract N implementation sessions build against. Standing rules are a minimum, not a maximum.

## When to Use

- When the Architecture check verdict is **invoke** — via the `/yggdrasil/architect` command, explicit document-the-architecture, as-is, arc42, decision-record, or decide-the-architecture language **without implementation intent**, or a user-accepted suggestion, per the Trigger Thresholds in your Communication Policy.
- When a composite caller supplies an `Architecture request:` line (§ Caller Contract) and executes this workflow as a sub-procedure.
- **Not** when the same request carries implementation intent — "decide the architecture, then build it" belongs to the Engineering check, which owns architecture-before-implementation and reaches this workflow by delegation. A request to explain a codebase's structure where no architecture document exists is the *suggestion candidate*; a pure research request or a question is a **skip**.

**Decide-new firing criteria** — the criteria a caller (or your own shape verdict) uses to decide whether forward-looking architecture work is warranted at all. It fires when ANY: new components, modules, or services, or a change crossing module boundaries; a new integration, persistence mechanism, schema change, or dependency; multiple viable structural approaches with material trade-offs; non-functional requirements driving the design; two or more candidate packages whose shared contracts do not already exist; design, architecture, a decision record, or arc42 documentation asked for. Skip when the change fits the existing structure and local patterns and one package suffices, or the user declines. It **fires, without exception, whenever two or more work packages are expected** — the split is an architecture decision and the packages need the contracts §5 specifies.

**Document-existing firing criteria** — it fires on a request to record, describe, or reverse-engineer what a system *is*, independently of any change to it.

## Caller Contract

A composite caller states one line before executing the steps below; absent, standalone defaults apply.

```text
Architecture request: mode=<document-existing | decide-new | infer>, objective=<text | none>, requirements=<Workfile path | none>, context=<Workfile path (reviewed) | none>, persistence=<inline | deferred>, location=<path | docs/architecture/>
```

- `context=<path> (reviewed)` ⇒ the context gate (step 2) is skipped. An **unreviewed** Workfile is treated as absent.
- `persistence=deferred` ⇒ steps 6, 7, and 8 are skipped; the caller owns ratification, persistence, and the Response, and invokes step 7 later with its own ratification record.
- `mode=infer` ⇒ apply the inference rule in step 1.
- The scaffold step (3) is **never** skipped — in either mode, on either invocation path.
- Standalone defaults when no line is supplied: `mode=infer`, `persistence=inline`, `location=docs/architecture/`, everything else `none`.

You return exactly one line to the caller or the user log:

```text
Architecture result: mode=<…>, source=<…>, workfile=<path>, review=<path> — <PASS | PASS-WITH-NOTES>, section-scope=<included=…, omitted=…>, package-check=<verdict | n/a>, shape=<directory | legacy single file | non-arc42 | none>, persisted=<path | deferred | declined | not-reached>, gaps=<n>
```

**Failure contract:** when a review is `BLOCKED` after § Failed Review Classification has exhausted the one permitted resume, return `review=<path> — BLOCKED` and **stop**. Never persist, and never draft a Response claiming success. The `persisted=` field then states which of two situations holds:

- **Composite call** — `persisted=deferred`, unchanged from the shape verdict. The caller already owns ratification and persistence timing, and a block does not take that ownership away.
- **Standalone run** — `persisted=not-reached`. Steps 6–8 were never entered, so nothing about persistence was decided by anyone; `deferred` would name a caller that does not exist, and `declined` would attribute a refusal the user never made.

`not-reached` appears on no other exit path: a completed standalone run reports the persisted path or `declined`.

These two lines are the only coupling surface. A caller may reference them; it may never restate the steps below.

## Workflow

1. **Shape verdict (no dispatch).** Before dispatching anything, record:

    ```text
    Architecture shape: mode=<document-existing | decide-new>, source=<direction | inference>, context=<yes/no — reason>, persistence=<inline | deferred | declined>
    ```

    **Mode.** User direction or a caller's `mode=` value sets the mode and `source=direction`. Otherwise apply the **inference rule**: an objective naming a change (add/replace/migrate/introduce/split …) → `decide-new`; document/describe/as-is/"how is it structured" language, or no change objective at all → `document-existing`; ambiguous → resolve per your Communication Policy — **Interactive asks** the user which mode is wanted; **Guided and Autonomous** take `document-existing` and record `source=inference`. The mode chosen here is echoed verbatim in every brief, in the Workfile header, in the return block, and in the Response; it is never re-decided later.

    **Context.** Record `context=no` with the reason when a reviewed context Workfile was supplied in the caller contract, or when the conversation already established the structure, conventions, and existing documentation of the system in scope. Otherwise `context=yes`.

    **Persistence.** `inline` standalone, `deferred` when the caller said so. `declined` is recorded only after step 6, and only in `decide-new` mode.

    Every skipped step is recorded here with its reason — never silently.

2. **Context gate (conditional; skipped per the verdict).** Dispatch Mimir with `mimir-codebase-context`. Scope the brief by mode: in `document-existing` mode the scope is **the system as a whole** (or the named subsystem); in `decide-new` mode it is the objective. Require the output to be **fact-rich and framing-poor** — what is the case, not what should be built — with proofs per finding. Writes `NN-context-<area>.md`. Its standing review is a fresh Heimdall session with `heimdall-engineering-review` and `Focus: context`.

3. **Scaffold (always — both modes, both invocation paths).** Dispatch Brokk with `brokk-arc42-template` and:

    ```text
    Scaffold: mode=<document-existing | decide-new>, source=<direction | inference>, workfile=<NN-architecture-arc42.md path>, location=<docs/architecture/ | path>, objective=<text | none>
    ```

    **Carry `mode` and `source` forward verbatim from the shape verdict recorded in step 1 — never re-derive either here.** The scaffolded header's `Mode … (source …)` line is written from this brief and checked against it at the scaffold review, so a value invented at dispatch time surfaces as a BLOCKED review rather than a wrong document.

    The session writes the arc42 skeleton into that Workfile and returns:

    ```text
    Scaffold result: workfile=<path>, document-scope=<seed | update delta>, existing=<path (directory index README.md | legacy single file | non-arc42) | none>, next-adr=<NNNN>, attribution=present
    ```

    Expect a skeleton only: a pre-filled header, all twelve headings with their guidance, mode-driven appendix treatment, and the attribution notice — **no section content and no pruned sections**; pruning is the drafter's judgment. Record the returned line; `document-scope`, `existing`, and `next-adr` are inputs to later steps and to the return block's `shape=` field.

    Its standing review is a fresh Heimdall session with `heimdall-architecture-review` and `Focus: scaffold`, writing `NN-review-architecture-scaffold.md`. A `BLOCKED` verdict here goes through § Failed Review Classification — resume the Brokk session once for an execution defect (wrong shape, wrong next number, a filled or missing heading); if it stays BLOCKED, stop and return the failure contract — `persisted=not-reached` on a standalone run, `persisted=deferred` on a composite call. **Never dispatch step 4 against an unreviewed or blocked skeleton.**

4. **Drafting.** Dispatch Kvasir with `kvasir-software-architecture`, the control line `Mode: <mode>`, `Scaffold: <path>`, the `Scaffold result` line from step 3, the objective, and the requirements and context Workfile paths when they exist. The session fills `NN-architecture-arc42.md` **in place** — the scaffold is the hand-off, and no second Workfile is created. Record the returned `Section scope:` and `Package check:` lines (`Package check: n/a` in `document-existing` mode) and the investigation gaps.

    **Each decision record carries one definite decision at `Status: Proposed`; ratification is not the author's to grant** — the user ratifies at step 6 under Interactive, you ratify by adoption under Guided and Autonomous, and promotion to `Status: Accepted` happens only at persistence. This session receives no dedicated review; step 5 is its gate.

5. **Design review gate (mandatory — never skipped, in either mode, on either path).** Dispatch a fresh Heimdall session with `heimdall-architecture-review`, `Focus: document`, the `Mode:` line echoed from the shape verdict, the architecture Workfile path, the requirements and context Workfile paths, and the pinned baseline. Writes `NN-review-architecture.md`. This precedes the checkpoint so the user ratifies a reviewed document, and precedes any hand-off so no caller consumes an unreviewed contract.

    A `BLOCKED` verdict goes through § Failed Review Classification: resume the Kvasir session **once** for an execution defect; a plan-level mismatch, or a second `BLOCKED`, ends the run under the failure contract — return `review=<path> — BLOCKED` with `persisted=not-reached` on a standalone run or `persisted=deferred` on a composite call, and stop. No persistence, no Response claiming success.

6. **Ratification checkpoint (skipped when `persistence=deferred`).** Surface a readable summary: the mode and its source, the section scope, the decisions awaiting ratification with their one-line rationales, the review verdict and any non-blocking notes, the open risks, the persistence location, and the remaining dispatch cost. Whether to pause for steering or auto-proceed is governed by your Communication Policy; when auto-proceeding, ratify by adoption and let the summary ride the Deliverable disclosure.

    In `decide-new` mode the user may decline persistence — record `persistence=declined`, skip step 7, and return `persisted=declined`. In `document-existing` mode the document is always persisted; the user may redirect the location, not decline the Artifact.

7. **Persistence (skipped when `persistence=deferred` or `declined`).** Dispatch Brokk with `brokk-architecture-persistence` and the brief: the reviewed architecture Workfile path, the ratification record from step 6, the pinned baseline, the location (default `docs/architecture/`, or the caller's `location=`), and whether the user explicitly directed migration of a legacy single-file document (default: no). In `document-existing` mode the ratification record lists the as-is decision IDs ratified. The session returns the persistence manifest.

    Its standing review is a fresh Heimdall session with `heimdall-architecture-review` and `Focus: persistence`, receiving the manifest, the reviewed Workfile, the ratification record, and the pinned baseline, and writing `NN-review-architecture-persistence.md`.

    **A composite caller running this step later supplies its own ratification record and runs the same standing review** — the step is defined here and nowhere else.

8. **Deliverable (Response; skipped when `persistence=deferred`).** Dispatch Bragi to draft the user-facing response from the reviewed outputs: the **mode and its source stated explicitly**, what the document covers and what it omits and why, the architecture summary (§4 Solution Strategy in a paragraph), the persisted directory path (its `README.md`) and the decision-record paths — and, when a legacy single-file document was updated in place, one line noting that directory migration is available on request — the open risks from §11, the investigation gaps, and what the user should verify. Writes `NN-response-draft.md`.

Finally, state the return block. On `persistence=deferred`, steps 6–8 are skipped and the block reads `persisted=deferred`.

**Review-skill assignment:** every review gate of this workflow dispatches a fresh Heimdall session with exactly one `Focus:` line. The standing reviews (per § Review & Quality Gates in your system prompt — one per Mimir or Brokk session, plus the Final Review Gate) are not numbered above, except the added design review in step 5.

| Reviewed node | Review skill | Brief line | Workfile |
| --- | --- | --- | --- |
| Context gate (step 2) | `heimdall-engineering-review` | `Focus: context` | `NN-review-context-<area>.md` |
| Scaffold session (step 3) | `heimdall-architecture-review` | `Focus: scaffold` | `NN-review-architecture-scaffold.md` |
| Architecture document (step 5) | `heimdall-architecture-review` | `Focus: document`, `Mode:` echoed | `NN-review-architecture.md` |
| Persistence session (step 7) | `heimdall-architecture-review` | `Focus: persistence` | `NN-review-architecture-persistence.md` |

Supply the originating brief, the artifact paths, and the pinned baseline with every dispatch. The checklists live in the review skills. The Kvasir and Bragi sessions receive no dedicated review beyond step 5's gate.

## Quality Criteria

- **The shape verdict is recorded before any dispatch**, and every skipped step carries its reason in that line — the reason is what the user steers against at the checkpoint and what a caller audits in the return block.
- **Mode is set once and echoed everywhere** — shape verdict, every brief, the Workfile header, the return block, the Response. The reviewer BLOCKs on a missing or mismatched `Mode:` header, so a drifted echo fails the gate rather than reaching the repo.
- **The scaffold is reviewed before it is filled.** Judgment never starts on a skeleton whose shape, heading set, or next decision number is wrong.
- **The document is reviewed before anything consumes it** — before ratification, before persistence, before a caller forms a plan from it. No unreviewed architecture reaches the repo or an implementation session.
- **`document-existing` output always persists.** Persistence is conditional only on a caller deferring it or, in `decide-new` mode, the user declining it.
- **Ratification is explicit** — every persisted decision was ratified at the checkpoint or by recorded adoption, and only then promoted to `Accepted`.
- **Both invocation paths are identical** up to the skipped steps: same scaffold, same drafting brief shape, same review gate, same Workfile names. A standalone run and a delegated run of the same objective differ only in steps 2 and 6–8.
- **The return block is stated on every exit path**, success or `BLOCKED`. A caller that receives no return block must treat the run as failed.
- **Cost (dispatches inside the workflow; the Final Review Gate is a standing rule on top).** Scaffold and its review, drafting, the design review, persistence and its review, the Response — **7** for a standalone run with context already established; **9** when the context gate fires (Mimir plus its review); **5** for `decide-new` standalone with persistence declined; **4** when a caller defers persistence (steps 2 and 6–8 skipped). Disclose the cost qualitatively at the checkpoint and quantitatively on request.
- **The Deliverable discloses** the mode and its source, the section scope, the decisions ratified, the persisted location, and the investigation gaps.

## Anti-Patterns

- **Silent mode selection.** Dispatching without the recorded `Architecture shape:` verdict, or inferring a mode without recording `source=inference` — a reader who cannot tell as-is from forward-looking cannot use the document safely.
- **Asking which mode under the wrong policy.** Interactive asks on genuine ambiguity; Guided and Autonomous take `document-existing` and record the inference. Blocking an Autonomous run on a mode question is a policy violation, and guessing silently in Interactive is the mirror failure.
- **Proposals in `document-existing` mode.** An as-is record that suggests a change is two documents wearing one header. Improvement ideas belong in §11 as technical debt.
- **Skipping the scaffold step.** It is unconditional by design. Letting the drafting session instantiate its own skeleton returns skeleton mechanics and repository look-up to the one session whose boundary forbids substantive investigation.
- **Dispatching the drafting step against an unreviewed skeleton.** The scaffold review is cheap and mechanical precisely so that a wrong shape or a wrong next decision number is caught before the expensive session runs.
- **Restating the scaffolding method in a brief.** Name the skill, the `Scaffold:` line, and the Workfile; shape classification, header pre-fill, and attribution placement are the scaffolding skill's rules and exist in exactly one file.
- **Skipping the design review gate.** One dispatch guards a document that becomes a repo Artifact and, in a composite run, the contract every implementation session builds against.
- **Persisting after a `BLOCKED` verdict**, or drafting a Response that reports success over a blocked review. The failure contract returns the review path and stops.
- **More than one resume per blocked node.** One resume for an execution defect; a plan-level mismatch or a second `BLOCKED` ends the run and surfaces the review.
- **Re-running the context gate a caller already ran.** A reviewed context Workfile in the caller contract is the skip condition; a duplicate Mimir dispatch is pure cost. Conversely, treating an *unreviewed* Workfile as sufficient imports unvalidated facts into the document.
- **Persisting on a deferred contract.** `persistence=deferred` means the caller owns ratification timing; persisting early promotes decisions the caller has not ratified.
- **Restating this workflow's steps in a caller's doctrine.** The caller states the request line and consumes the result line — nothing else.
- **Creating a second architecture Workfile.** The scaffolded file is filled in place; a parallel draft guarantees two documents that disagree.
- **Skipping the Final Review Gate.** The Deliverable — the Response and the persisted architecture directory — is user-facing output and must pass the gate like any other.
