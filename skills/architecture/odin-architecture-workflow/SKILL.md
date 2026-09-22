---
name: odin-architecture-workflow
description: Orchestration doctrine for the Architecture workflow — arc42 architecture in two modes, recording an existing system as-is or deciding new structure, scaffolded then drafted, design-reviewed before persistence, and reusable by a composite caller through a one-line contract.
---

# Architecture Workflow

## Purpose

Define the orchestration doctrine for the Architecture workflow — a trigger-gated workflow that produces one arc42 architecture document in one of two modes, reviews it, and persists it into the target project. This skill is the single source of doctrine for architecture work: mode selection, the conditional context gate, the scaffold of the target directory, the drafting dispatch, the mandatory design-review gate, ratification, persistence, and the Response — plus the contract a composite caller uses to reuse all of it.

**The two modes are the whole shape of the workflow:**

- `document-existing` — reverse-engineer and record the current architecture as-is, proposing nothing.
- `decide-new` — decide forward-looking architecture for a bounded objective, with decision records at `Status: Proposed` and a work-package breakdown.

The workflow packages the pattern `Shape verdict → [Context → Review] → Scaffold → Review → Draft → Design Review → Checkpoint → Persist → Review → Response`. Two properties make it more than "Draft → Review → Persist": the **mode and its source are decided and recorded before any dispatch**, and **structure, document, and fill are three roles working in two media** — one session scaffolds the arc42 structure in the target project, a second authors the architecture Workfile in the workspace, a third fills the scaffold from that Workfile after ratification. Mechanics and judgment have separate owners, and no role writes in another's medium.

This skill is dispatch doctrine only. `mimir-architecture-context`, `brokk-arc42-template`, `kvasir-software-architecture`, `heimdall-architecture-review`, and `brokk-architecture-persistence` are the per-step methodologies, loaded by the dispatched sessions themselves. Briefs name the skill, the inputs, and the output to write — the Workfile for a workspace session, the target directory for a project session — **never the method**. In particular, what a scaffolded structure contains, how the target's shape is classified, how the next decision number is resolved, and how a reviewed document is laid out on disk are those skills' rules, not yours.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (drafted by Bragi, step 8) and an Artifact (the persisted arc42 architecture directory — a folder per section holding its documents and index, the decision records in their own folder, and the top index). This fixes the Deliverable at Odin's top level:

```text
Deliverable: response=yes, artifact=yes — persisted arc42 directory (absent only when persistence=deferred to a caller, declined by the user in decide-new mode, or refused by the persistence step pending a migration direction), source=workflow-fixed
```

`document-existing` mode always persists — the user may choose the location, not whether to record it, and the one exit that still leaves it unrecorded is the persistence step's own refusal (`persisted=refused`), never a choice anyone made. Appendices B, C, and D of the arc42 Workfile are transient planning content and are never persisted.

**Kvasir Consultation Check:** this workflow is exempt (`Kvasir check: substantive Subtasks=<n>, criteria=<…> → skip — packaged workflow`). Its strategic consultation is internal — the drafting step (`kvasir-software-architecture`) — and its ratification checkpoint is the user's steering point. When this workflow is one stage of a larger composite plan, the composite is still evaluated by the Check as usual. Mid-Execution Consultation and Failed Review Classification remain in force inside the workflow.

**One review gate beyond the standing rules:** the drafted document is reviewed by a dedicated `heimdall-architecture-review` (`Focus: document`) dispatch before anything consumes it (step 5). The standing rules exempt Kvasir sessions from dedicated review; this workflow overrides that exemption for this one node, because the document is promoted to repo Artifacts *and*, in a composite run, is the shared contract N implementation sessions build against. Standing rules are a minimum, not a maximum.

## When to Use

- When the Architecture check verdict is **invoke** — via the `/yggdrasil/architect` command, explicit document-the-architecture, as-is, arc42, decision-record, or decide-the-architecture language **without implementation intent**, or a user-accepted suggestion, per the Trigger Thresholds in your Communication Policy.
- When a composite caller supplies an `Architecture request:` line (§ Caller Contract) and executes this workflow as a sub-procedure.
- **Not** as a standalone invocation when the same request carries implementation intent — "decide the architecture, then build it" is owned by whichever broader workflow sequences architecture before implementation, and reaches this one by delegation as a sub-procedure. A request to explain a codebase's structure where no architecture document exists is the *suggestion candidate*; a pure research request or a question is a **skip**.

**Decide-new firing criteria** — the criteria a caller (or your own shape verdict) uses to decide whether forward-looking architecture work is warranted at all. It fires when ANY: new components, modules, or services, or a change crossing module boundaries; a new integration, persistence mechanism, schema change, or dependency; multiple viable structural approaches with material trade-offs; non-functional requirements driving the design; two or more candidate packages whose shared contracts do not already exist; design, architecture, a decision record, or arc42 documentation asked for. Skip when the change fits the existing structure and local patterns and one package suffices, or the user declines. It **fires, without exception, whenever two or more work packages are expected** — the split is an architecture decision and the packages need the contracts §5 specifies.

**Document-existing firing criteria** — it fires on a request to record, describe, or reverse-engineer what a system *is*, independently of any change to it.

## Caller Contract

A composite caller states one line before executing the steps below; absent, standalone defaults apply.

```text
Architecture request: mode=<document-existing | decide-new | infer>, objective=<text | none>, requirements=<Workfile path | none>, persistence=<inline | deferred>, location=<path | docs/architecture/>
```

- **The context gate (step 2) is yours alone** — no caller can pre-empt or skip it, because no caller produces the architecture-scoped context Workfile it exists to obtain. An unrecognized field in the request line — a legacy `context=<path>` among them — is a malformed brief: ask the caller what it means, never read it as a skip.
- `persistence=deferred` ⇒ steps 6, 7, and 8 are skipped; the caller owns ratification, persistence, and the Response, and invokes step 7 later with its own ratification record — in the grammar `brokk-architecture-persistence` § The Ratification Record fixes, echoed at step 6 — and the `Scaffold result` line it recorded from this run.
- `mode=infer` ⇒ apply the inference rule in step 1.
- The scaffold step (3) is **never** skipped — in either mode, on either invocation path.
- Standalone defaults when no line is supplied: `mode=infer`, `persistence=inline`, `location=docs/architecture/`, everything else `none`.

You return exactly one line to the caller or the user log:

```text
Architecture result: mode=<…>, source=<…>, workfile=<path>, review=<path> — <PASS | PASS-WITH-NOTES>, section-scope=<included=…, omitted=…>, package-check=<verdict | n/a>, shape=<directory | flat directory (legacy) | legacy single file | non-arc42 | none>, scaffold=<path> — <created | verified | extended>, persisted=<path | deferred | declined | not-reached | refused>, gaps=<n>
```

**Failure contract:** when a review is `BLOCKED` after § Failed Review Classification has exhausted the one permitted resume, return `review=<path> — BLOCKED` and **stop**. Never persist, and never draft a Response claiming success. The `persisted=` field then states which of two situations holds:

- **Composite call** — `persisted=deferred`, unchanged from the shape verdict. The caller already owns ratification and persistence timing, and a block does not take that ownership away.
- **Standalone run** — `persisted=not-reached`. Steps 6–8 were never entered, so nothing about persistence was decided by anyone; `deferred` would name a caller that does not exist, and `declined` would attribute a refusal the user never made.

`not-reached` appears on no other exit path: a completed standalone run reports the persisted path, `declined`, or `refused`.

**`persisted=refused` is a different exit — steps 6–8 all ran.** It is the value when the scaffold step classified the target as `flat directory (legacy)` or `legacy single file`, no migration direction was obtained, step 6 ratified as usual, step 7 was dispatched, and the persistence session refused on its own precondition and wrote nothing. Use it in **both modes**, and never substitute one of the other three: `not-reached` is defined for a run where steps 6–8 were never entered, `deferred` names a caller that owns persistence, and `declined` names a user refusal — here the user refused nothing and the precondition did the refusing, which is also why `refused` is reachable in `document-existing` mode where `declined` never applies. `refused` states exactly this: persistence was attempted, the persister refused it pending a user direction, nothing was written. Do not retry inside the run; a later run that cites the migration direction proceeds through migration to `persisted=<path>`.

On either exit, `scaffold=` reads `<path> — created (unfilled)` when step 3 created the structure: a `Status: Scaffolded` skeleton with no content is now in the target project and no session filled it. **Never delete it** — this workflow does not remove project files it created; removal is the user's direction. Name that path wherever you surface the failure, so nothing is left behind undisclosed.

These two lines are the only coupling surface. A caller may reference them; it may never restate the steps below.

## Workflow

1. **Shape verdict (no dispatch).** Before dispatching anything, record:

    ```text
    Architecture shape: mode=<document-existing | decide-new>, source=<direction | inference>, context=<yes/no — reason>, persistence=<inline | deferred | declined>
    ```

    **Mode.** User direction or a caller's `mode=` value sets the mode and `source=direction`. Otherwise apply the **inference rule**: an objective naming a change (add/replace/migrate/introduce/split …) → `decide-new`; document/describe/as-is/"how is it structured" language, or no change objective at all → `document-existing`; ambiguous → resolve per your Communication Policy — **Interactive asks** the user which mode is wanted; **Guided and Autonomous** take `document-existing` and record `source=inference`. The mode chosen here is echoed verbatim in the drafting and review briefs, in the Workfile header, in the return block, and in the Response; it is never re-decided later.

    **Context.** Record `context=no` with the reason only when the conversation has already established the module boundaries, entry points, boundary interfaces, and existing architecture documentation of the system in scope — the user supplied them, or an earlier architecture run in this session produced a reviewed `NN-context-architecture-<area>.md` — or when the objective is greenfield with no code yet. Otherwise `context=yes`. An engineering-context Workfile is **not** a skip reason: it records behavior, conventions, and test infrastructure, none of which grounds a §5 blackbox.

    **Persistence.** `inline` standalone, `deferred` when the caller said so. `declined` is recorded only after step 6, and only in `decide-new` mode.

    Every skipped step is recorded here with its reason — never silently.

2. **Architecture-context gate (conditional; skipped per the verdict).** Dispatch Mimir with `mimir-architecture-context`. Scope the brief by mode: in `document-existing` mode the scope is **the system as a whole** (or the named subsystem); in `decide-new` mode it is the objective's structural footprint. Require the output to be **fact-rich and framing-poor** — what is the case, not what should be built — with proofs per finding. Writes `NN-context-architecture-<area>.md`. Its standing review is a fresh Heimdall session with `heimdall-architecture-review` and `Focus: context`, writing `NN-review-context-architecture-<area>.md`.

3. **Scaffold (always — both modes, both invocation paths).** Dispatch Brokk with `brokk-arc42-template` and:

    ```text
    Scaffold: location=<docs/architecture/ | path>
    ```

    The brief carries **no `workfile=` field**: this session writes Artifacts into the target project and never a Workfile.

    The session acts on the target project and returns:

    ```text
    Scaffold result: target=<path>, structure=<created | verified | extended>, shape=<directory | flat directory (legacy) | legacy single file | non-arc42 | none>, document-scope=<seed | update delta>, existing=<path (README.md index) | none>, next-adr=<NNNN>
    ```

    Expect changes to the target project and to nothing else: an empty structure at `Status: Scaffolded` when `structure=created`, only the missing folders when `extended`, no change at all when `verified` — **no section content, no decision record, and no Workfile**; what a scaffolded structure holds is the scaffolding skill's rule. A legacy shape (`flat directory (legacy)`, `legacy single file`) is reported with `migration required` and is never written to: obtain the user's migration direction before step 7, because persistence refuses that target without it. Record the returned line verbatim — it is an input to steps 4 and 7, `target` and `structure` are the return block's `scaffold=` field, and `shape` is its `shape=` field.

    Its standing review is a fresh Heimdall session with `heimdall-architecture-review` and `Focus: scaffold`, writing `NN-review-architecture-scaffold.md`; it reviews the target project's tree against the pinned baseline. A `BLOCKED` verdict here goes through § Failed Review Classification — resume the Brokk session once for an execution defect (wrong shape, wrong next decision number, a missing section folder, content where an empty structure was due, or any Workfile written); if it stays BLOCKED, stop and return the failure contract — `persisted=not-reached` on a standalone run, `persisted=deferred` on a composite call. **Never dispatch step 4 against an unreviewed or blocked scaffold** — the drafting session mirrors the target's structure, so an unchecked tree becomes a wrong document.

4. **Drafting.** Dispatch Kvasir with `kvasir-software-architecture`, the control line `Mode: <mode>`, the `Scaffold result` line from step 3 verbatim, the path of the Workfile to **create** (`NN-architecture-arc42.md`), the objective, and the requirements and architecture-context Workfile paths when they exist. The result line is the hand-off: it carries the target, the structure, the document scope, and the next decision number, so the session never re-derives them. The session authors that one Workfile — header, the twelve sections, the appendices its mode requires, and the **Appendix D layout map** that assigns every heading to one document of the scaffolded structure. Record the returned `Section scope:` and `Package check:` lines (`Package check: n/a` in `document-existing` mode) and the investigation gaps.

    **Each decision record carries one definite decision at `Status: Proposed`; ratification is not the author's to grant** — the user ratifies at step 6 under Interactive, you ratify by adoption under Guided and Autonomous, and promotion to `Status: Accepted` happens only at persistence. This session receives no dedicated review; step 5 is its gate.

5. **Design review gate (mandatory — never skipped, in either mode, on either path).** Dispatch a fresh Heimdall session with `heimdall-architecture-review`, `Focus: document`, the `Mode:` line echoed from the shape verdict, the architecture Workfile path, the requirements and architecture-context Workfile paths, and the pinned baseline. Writes `NN-review-architecture.md`. This precedes the checkpoint so the user ratifies a reviewed document, and precedes any hand-off so no caller consumes an unreviewed contract.

    A `BLOCKED` verdict goes through § Failed Review Classification: resume the Kvasir session **once** for an execution defect; a plan-level mismatch, or a second `BLOCKED`, ends the run under the failure contract — return `review=<path> — BLOCKED` with `persisted=not-reached` on a standalone run or `persisted=deferred` on a composite call, and stop. No persistence, no Response claiming success.

6. **Ratification checkpoint (skipped when `persistence=deferred`).** Surface a readable summary: the mode and its source, the section scope, the decisions awaiting ratification with their one-line rationales, the review verdict and any non-blocking notes, the open risks, the persistence location, and the remaining dispatch cost. Whether to pause for steering or auto-proceed is governed by your Communication Policy; when auto-proceeding, ratify by adoption and let the summary ride the Deliverable disclosure.

    Record the outcome as the **ratification record**, one line, in the grammar `brokk-architecture-persistence` § The Ratification Record defines — echoed here so you can write it; that section, not this echo, is normative:

    ```text
    Ratification: workfile=<path>, review=<path>, ratified=<ADR-NNNN[, ADR-NNNN …] | none>, withheld=<ADR-NNNN[, ADR-NNNN …] | none>, by=<user | adoption>
    ```

    Every decision in the Workfile's Appendix A appears in exactly one of the two lists; `by=user` when the user ratified, `by=adoption` when you ratified by adoption. This line is the input to step 7 and to its standing review.

    In `decide-new` mode the user may decline persistence — record `persistence=declined`, skip step 7, and return `persisted=declined`. In `document-existing` mode the document is always persisted; the user may redirect the location, not decline the Artifact — the one way such a run still ends without an Artifact is the persister's refusal at step 7 (`persisted=refused`), which is its precondition talking, not the user's choice.

7. **Persistence (skipped when `persistence=deferred` or `declined`).** Dispatch Brokk with `brokk-architecture-persistence` and the brief: the reviewed architecture Workfile path, the ratification record from step 6, the pinned baseline, the `Scaffold result` line recorded at step 3, and the migration direction (`none | migrate flat directory | migrate single file`; `none` unless the user directed otherwise). The result line's `target=` is the location — the session fills that already-scaffolded structure from the Workfile's Appendix D and creates no structure of its own. In `document-existing` mode the record's `ratified=` list names the as-is decision IDs ratified. The session returns the persistence manifest.

    **The session checks its own preconditions and writes nothing when they fail** — a target that was never scaffolded, or a legacy shape (`flat directory (legacy)`, `legacy single file`) with no migration direction cited. Never re-brief it to create or migrate what it was not directed to, and never retry it inside this run. Carry the refusal into step 8, and return `persisted=refused`.

    Its standing review is a fresh Heimdall session with `heimdall-architecture-review` and `Focus: persistence`, receiving the manifest, the reviewed Workfile, the ratification record, and the pinned baseline, and writing `NN-review-architecture-persistence.md`.

    **A composite caller running this step later supplies its own ratification record in that same grammar, the same `Scaffold result` line it recorded from the delegated run, and runs the same standing review** — the step is defined here and nowhere else.

8. **Deliverable (Response; skipped when `persistence=deferred`).** Dispatch Bragi to draft the user-facing response from the reviewed outputs: the **mode and its source stated explicitly**, what the document covers and what it omits and why, the architecture summary (§4 Solution Strategy in a paragraph), the persisted directory's top index path and the decision-record paths, the open risks from §11, the investigation gaps, and what the user should verify. **When the persistence step refused pending a migration direction, the Response states the refusal, says that nothing was written, and puts the decision now owed by the user — direct the migration, or leave the legacy document as it stands — in front of them.** When the user declined persistence instead, the Response says so; in either case it names the structure step 3 created and left unfilled, when it created one. Writes `NN-response-draft.md`.

Finally, state the return block. On `persistence=deferred`, steps 6–8 are skipped and the block reads `persisted=deferred`.

**Review-skill assignment:** every review gate of this workflow dispatches a fresh Heimdall session with exactly one `Focus:` line. The standing reviews (per § Review & Quality Gates in your system prompt — one per Mimir or Brokk session, plus the Final Review Gate) are not numbered above, except the added design review in step 5.

| Reviewed node | Review skill | Brief line | Workfile |
| --- | --- | --- | --- |
| Architecture-context gate (step 2) | `heimdall-architecture-review` | `Focus: context` | `NN-review-context-architecture-<area>.md` |
| Scaffold session (step 3) | `heimdall-architecture-review` | `Focus: scaffold` | `NN-review-architecture-scaffold.md` |
| Architecture document (step 5) | `heimdall-architecture-review` | `Focus: document`, `Mode:` echoed | `NN-review-architecture.md` |
| Persistence session (step 7) | `heimdall-architecture-review` | `Focus: persistence` | `NN-review-architecture-persistence.md` |

Supply the originating brief, the artifact paths, and the pinned baseline with every dispatch. The checklists live in the review skills. The Kvasir and Bragi sessions receive no dedicated review beyond step 5's gate.

## Quality Criteria

- **The shape verdict is recorded before any dispatch**, and every skipped step carries its reason in that line — the reason is what the user steers against at the checkpoint and what a caller audits in the return block.
- **Mode is set once and echoed everywhere it is consumed** — shape verdict, the drafting and review briefs, the Workfile header, the return block, the Response. The reviewer BLOCKs on a missing or mismatched `Mode:` header, so a drifted echo fails the gate rather than reaching the repo.
- **The scaffold is reviewed before drafting starts.** Judgment never starts against a target whose shape, structure, or next decision number is wrong.
- **The document is reviewed before anything consumes it** — before ratification, before persistence, before a caller forms a plan from it. No unreviewed architecture reaches the repo or an implementation session.
- **`document-existing` output always persists.** Persistence is conditional only on a caller deferring it, on the user declining it in `decide-new` mode, or on the persister refusing a legacy target that carries no migration direction (`persisted=refused`, both modes).
- **Ratification is explicit** — every persisted decision was ratified at the checkpoint or by recorded adoption, and only then promoted to `Accepted`.
- **Both invocation paths are identical** up to the skipped steps: same scaffold, same drafting brief shape, same review gate, same Workfile names. A standalone run and a delegated run of the same objective differ only in steps 6–8 — the context gate is decided by the same rule on both paths, never by the caller.
- **The return block is stated on every exit path**, success or `BLOCKED`. A caller that receives no return block must treat the run as failed.
- **Cost (dispatches inside the workflow; the Final Review Gate is a standing rule on top).** Scaffold and its review, drafting, the design review, persistence and its review, the Response — **7** for a standalone run with context already established; **9** when the context gate fires (Mimir plus its review); **5** for `decide-new` standalone with persistence declined; **4** when a caller defers persistence (steps 2 and 6–8 skipped). Disclose the cost qualitatively at the checkpoint and quantitatively on request.
- **The Deliverable discloses** the mode and its source, the section scope, the decisions ratified, the persisted location, and the investigation gaps.

## Anti-Patterns

- **Silent mode selection.** Dispatching without the recorded `Architecture shape:` verdict, or inferring a mode without recording `source=inference` — a reader who cannot tell as-is from forward-looking cannot use the document safely.
- **Asking which mode under the wrong policy.** Interactive asks on genuine ambiguity; Guided and Autonomous take `document-existing` and record the inference. Blocking an Autonomous run on a mode question is a policy violation, and guessing silently in Interactive is the mirror failure.
- **Proposals in `document-existing` mode.** An as-is record that suggests a change is two documents wearing one header. Improvement ideas belong in §11 as technical debt.
- **Skipping the scaffold step.** It is unconditional by design. Letting the drafting session derive the target's shape and next decision number itself returns repository look-up to the one session whose boundary forbids substantive investigation — and leaves persistence with no structure to fill.
- **Dispatching the drafting step against an unreviewed scaffold.** The scaffold review is cheap and mechanical precisely so that a wrong shape, a wrong next decision number, or stray content in the project tree is caught before the expensive session runs.
- **Restating the scaffolding or layout method in a brief.** Name the skill, the `Scaffold:` line, and the inputs; shape classification, what a scaffolded structure holds, and how a reviewed document is laid out on disk are the dispatched skills' rules and exist in exactly one file each.
- **Skipping the design review gate.** One dispatch guards a document that becomes a repo Artifact and, in a composite run, the contract every implementation session builds against.
- **Persisting after a `BLOCKED` verdict**, or drafting a Response that reports success over a blocked review. The failure contract returns the review path and stops.
- **More than one resume per blocked node.** One resume for an execution defect; a plan-level mismatch or a second `BLOCKED` ends the run and surfaces the review.
- **Deleting the scaffold on abort.** A run that stops at a blocked review leaves a `Status: Scaffolded` structure in the project. Disclose it — `scaffold=<path> — created (unfilled)` in the return block, named again wherever the failure reaches the user — and leave it in place. Removal is the user's direction: a workflow that tidies up after itself destroys a structure the next run would have reused and hides what it did to the project.
- **Treating an engineering-context Workfile as structural evidence.** Behavior, conventions, and a baseline test run do not establish module boundaries, entry points, or boundary interfaces, so skipping the gate on such a Workfile leaves §5 ungrounded and makes the recorded skip reason false. Skip step 2 only for the reasons the shape verdict admits — structure already established in the conversation, or a greenfield objective.
- **Persisting on a deferred contract.** `persistence=deferred` means the caller owns ratification timing; persisting early promotes decisions the caller has not ratified.
- **Restating this workflow's steps in a caller's doctrine.** The caller states the request line and consumes the result line — nothing else.
- **Creating a second architecture Workfile.** One run, one Workfile: the drafting session creates `NN-architecture-arc42.md` and every later step reads that same file. A parallel draft guarantees two documents that disagree.
- **Skipping the Final Review Gate.** The Deliverable — the Response and the persisted architecture directory — is user-facing output and must pass the gate like any other.
