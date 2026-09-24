---
name: odin-engineering-workflow
description: Orchestration doctrine for the Software Engineering workflow — optional business analysis and arc42-structured architecture decision, then the TDD workflow run to completion as a stage — reviewed test-driven work packages and review-gated commits.
---

# Software Engineering Workflow

## Purpose

Define the orchestration doctrine for the Software Engineering workflow — a trigger-gated workflow that turns an engineering objective into working, tested code by way of an explicitly chosen shape: optional requirements analysis, optional architecture decision, then the TDD workflow run to completion as a stage.

The workflow packages the pattern `[Analysis] → [Architecture stage] → TDD stage → Response`. Two properties make it more than "Implement → Review": the **shape is decided and recorded before any dispatch**, and **each stage carries its own checkpoint** — the Architecture stage's ratification checkpoint and the TDD stage's plan checkpoint — so nothing is implemented against a decision the user has not seen.

This skill is dispatch doctrine only. `bragi-business-analysis`, the Architecture workflow's skills (loaded by `odin-architecture-workflow`), and the TDD workflow's skills (loaded by `odin-tdd-workflow`) are the per-step methodologies, loaded by the dispatched sessions themselves. Briefs name the skill, the inputs, and the Workfile to write — never the method.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (drafted by Bragi, step 5) and an Artifact (code and tests committed in the target project; plus the persisted arc42 architecture directory — a folder per section holding its generated index and topic documents, the decision records in `09-architecture-decisions/`, and the top index — whenever the architecture step fired). This fixes the Deliverable at Odin's top level:

```text
Deliverable: response=yes, artifact=yes — code and tests committed in the target project (plus the persisted arc42 architecture directory: a folder per section holding its index and documents, the decision records in their own folder, and the top index, when the architecture step fired), source=workflow-fixed
```

The requirements Workfile is **not** persisted by default; persist it to `docs/requirements/<slug>.md` only on user direction. Appendices B and C of the architecture Workfile are transient planning content and are never persisted.

**Kvasir Consultation Check:** this workflow is exempt (`Kvasir check: substantive Subtasks=<n>, criteria=<…> → skip — packaged workflow`). Its strategic consultation is internal — the architecture step (step 3, which runs the Architecture workflow to completion as a stage), which is mandatory whenever the work splits into more than one package — and the TDD stage's plan step, and its stages' checkpoints are the user's steering points. Each stage's own exemption covers the sessions inside it. When this workflow is one stage of a larger composite plan, the composite is still evaluated by the Check as usual. Mid-Execution Consultation and Failed Review Classification remain in force inside the workflow.

**The architecture step is a stage:** it runs the Architecture workflow (`odin-architecture-workflow`) to completion — context, drafting, ratification, persistence, with the standing reviews of its context and persistence sessions — before the TDD stage begins. **The TDD step is a stage too:** it runs the TDD workflow (`odin-tdd-workflow`) to completion — its own context gate, plan, plan checkpoint, reviewed packages, integration, and review-gated commits.

## When to Use

- When the Engineering check verdict is **invoke** — via the `/yggdrasil/engineer` command, explicit language requesting the engineering workflow, test-driven development, or requirements/architecture work ahead of implementation, or a user-accepted suggestion, per the Trigger Thresholds in your Communication Policy.
- **Not** for an ordinary implementation request. A plain "implement X", "fix this bug", "add this field" without workflow language is not an invoke: a non-trivial implementation request (new component, multi-module feature, new integration) is the *suggestion candidate*; a simple implementation request, a pure research request, or a question is a **skip**. Invoking the heavy workflow on ordinary work is the failure mode this threshold exists to prevent.

## Workflow

1. **Shape verdict (no dispatch).** Before dispatching anything, record:

    ```text
    Engineering shape: analysis=<yes/no — reason>, architecture=<yes/no — reason>
    ```

    All four `{analysis, architecture}` combinations are valid; the two steps are independent. Explicit user direction overrides inference in that direction and is recorded as the reason. Firing criteria:
    - **Analysis** fires when ANY: outcome-phrased objective; acceptance criteria absent or ambiguous; multiple actors or stakeholders implied; user-facing behavior with unclear edge cases; requirements, a spec, stories, or acceptance criteria asked for; a natural-language request rather than a concrete change. Skip when the change is already testable (bug with a reproduction, small feature with stated behavior, behavior-preserving refactor) or the user declines.
    - **Architecture** fires per the firing criteria in `odin-architecture-workflow` § When to Use, and **without exception whenever two or more work packages are expected** — the split is itself an architecture decision.

2. **Business Analysis (optional).** Dispatch Bragi with `bragi-business-analysis` and the objective. Writes `NN-requirements.md`: acceptance criteria with stable IDs, ranked quality goals, non-functional targets, assumptions, capped open questions with proposed defaults, glossary. Relay the open questions per your Communication Policy — as ordinary clarifications before the architecture step proceeds under Interactive, or by adopting the proposed defaults as documented assumptions under Guided and Autonomous. No dedicated review.

3. **Architecture (optional).** Load `odin-architecture-workflow` and run the Architecture workflow **to completion as a stage of this run** — its own structural-context gate, drafting, ratification checkpoint, persistence, and their reviews — on the objective, naming the requirements Workfile from step 2 as an input when it exists, at `docs/architecture/` unless the user directed another location. Pass no behavioral context: that workflow gathers its own structural evidence, and behavioral context is the TDD stage's own gate. Its Response is folded into step 5's.

    When the stage completes, the following steps use what it left in the conversation: the architecture Workfile `NN-architecture-arc42.md` — its §5 interfaces are the contracts and its Appendix B is the package plan — and the persisted architecture directory. Ratification and persistence already happened inside the stage; nothing here re-ratifies or persists. A stage that stopped on a `BLOCKED` review stops this run under § Failed Review Classification; a stage whose persistence the user declined proceeds — the Workfile remains the implementation contract, and the Response says the architecture was not persisted.

4. **TDD (stage).** Load `odin-tdd-workflow` and run the TDD workflow **to completion as a stage of this run** — its own context gate, plan, plan checkpoint, reviewed work packages, integration, and review-gated commits — on the objective, naming the requirements Workfile from step 2 and the architecture Workfile from step 3 as inputs when they exist. A stage that stopped on a `BLOCKED` review stops this run under § Failed Review Classification. Its Response is folded into step 5's.

    When the stage completes, its commits, evidence, and leftovers are what step 5 reports; nothing here re-plans, re-reviews, or re-commits.

5. **Deliverable (Response).** Dispatch Bragi to draft the user-facing response from the reviewed outputs: the shape taken and why, acceptance criteria covered and not covered, the architecture summary (§4 Solution Strategy in a paragraph) with the architecture directory path (its `README.md`) and the decision-record paths, the TDD stage's packages, test evidence, and commits (hash, type, subject, branch), the assumptions adopted, the open risks from §11, and what the user should verify. Writes `NN-response-draft.md`.

**Review-skill assignment:** every review gate of this workflow runs inside its stages, each with its own review skill; this workflow adds none.

| Reviewed node | Brief line | Workfile |
| --- | --- | --- |
| Architecture stage (step 3) | not reviewed here — its own reviews (context, persistence) run inside it | — |
| TDD stage (step 4) | not reviewed here — its own reviews (context, package, integration, commit) run inside it | — |

The Bragi session receives no dedicated review.

## Quality Criteria

- **The shape verdict is recorded before any dispatch.**
- **The architecture is ratified and persisted before any package consumes it** — no implementation session builds against decisions the checkpoint has not ratified.
- **arc42 pruning is explicit** — the `Section scope:` line is recorded and every omitted section carries a marker.
- **Ratification is explicit** — every persisted ADR was ratified at the checkpoint or by recorded adoption, and only then promoted to `Accepted`.
- **Cost (total dispatches, including the standing reviews and the Final Review Gate, which are not numbered steps):** `A + R·D + T + 2`, where A and R are 1 when the analysis and architecture steps fire (0 otherwise), **D is the Architecture workflow's own dispatch count — 4 when its context gate is skipped, 6 when it fires**, **T is the TDD workflow's own dispatch count** (`2C + 1 + 2N·(1+S) + 2W + 2K`, minimum 5 — see `odin-tdd-workflow` § Quality Criteria), and the trailing 2 is the Response plus the Final Review Gate. Minimum 7; a medium run (A=1, D=4, T=9) is 16. Disclose the cost qualitatively at the checkpoints and quantitatively on request.
- **The Deliverable discloses** the shape taken, the assumptions adopted, acceptance-criterion coverage, the commits landed, and the architecture directory and decision-record locations.

## Anti-Patterns

- **Silent shape inference.** Dispatching without the recorded `Engineering shape:` verdict, or skipping analysis and architecture by omission rather than by a stated reason — the reason is what the user steers against at the checkpoint.
- **Trigger creep.** Invoking the full workflow on ordinary implementation work. A plain "implement X" is a skip or a suggestion candidate, never an invoke.
- **Steering the TDD stage from outside.** Passing packages, modes, batches, or commit instructions into the stage in the brief — its plan step and plan checkpoint own those; the enclosing run supplies only the objective and the Workfiles it produced.
- **Forming a plan from an unratified architecture document** — the stage's checkpoint is the gate; a `BLOCKED` stage routes through § Failed Review Classification instead of feeding Appendix B to the TDD stage.
- **Architecture reaching the repo without the stage's persistence review.** The persisted document and its decision records are user-facing Artifacts, not internal notes.
- **Persisting `Accepted` without ratification**, or persisting a delta over an existing document by overwriting it instead of merging document-by-document.
- **Template worship.** Letting all twelve arc42 sections be filled for a change that touches three, or briefing for a complete document instead of a pruned one — the ceremony buries the signal the implementation sessions need.
- **Restating specialist methodology in briefs.** Name the skill, the inputs, and the Workfile; the dispatched session loads its own method.
- **Re-architecting mid-flight.** If execution shows the design is wrong, that is Mid-Execution Consultation territory, not a second run of the architecture step.
- **Skipping the Final Review Gate.** The Deliverable — code, tests, and the persisted architecture documentation — is user-facing output and must pass the gate like any other.
