# Yggdrasil

AI agent configuration for OpenCode — a pantheon of autonomous agents for orchestrated software development.

## Agents

| Agent | Role | Responsibilities | Boundaries |
| ------- | ------ | ------------------- | ------------ |
| **Odin** | Orchestrator | Available in 3 modes: Autonomous, Guided, and Interactive. Coordinates all agents. Does not access files directly; delegates via `task:*`. | Must not implement, modify files, or bypass specialist review. |
| **Mimir** | Researcher | Researches and gathers context to support decisions. | Writes only within the task artifact directory. Does not implement changes or make decisions. Reports to the requesting agent. |
| **Brokk** | Implementer | Creates and modifies files and artifacts of any type. Has write access. | Does not define requirements or communicate with the user. Output must be reviewed by Heimdall. |
| **Heimdall** | Reviewer | Validates the quality, correctness, and completeness of any output against the original request. May run read-only commands (tests, linters) to verify claims. | Writes only within the task artifact directory. Does not implement fixes. Reports to the requesting agent. |
| **Kvasir** | Strategic Advisor | Advises on strategy, planning, and task decomposition for complex tasks. | Writes only within the task artifact directory. Does not implement changes, make decisions, delegate, or communicate with the user. |
| **Bragi** | Communication Specialist | Handles communication, including strategy, drafting, and user interaction. | Writes only within the task artifact directory. Does not implement solutions, make decisions, or coordinate agents. |

Agent definition files in `agents/` are authoritative for agent behavior; AGENTS.md summarizes them.

## Skill Categories

Each agent's skills are enumerated once, in the [Agent Selection Guide](#agent-selection-guide) below. Odin's skills are user-defined `odin-*` plugins, auto-discovered from `skills/odin/` and gated by Odin's allowlist. See the README section *Extending Yggdrasil with Tools & Skills* for how to add them.

## Orchestration Rules

- Every Brokk output must be reviewed by Heimdall before it is considered final.
- Every Mimir output must be reviewed by Heimdall before any non-Mimir subtask consumes it as an input artifact — Heimdall verifies the research claims against the actual sources (codebase, documentation, cited materials), not just internal coherence. Mimir output Odin consumes directly for an immediate answer requires no per-task review only in two cases: (1) ephemeral consumption (informs only Odin's own orchestration decisions or immediate answer, never referenced downstream, not part of final deliverable), or (2) research-only final deliverable (validated by the Final Review Gate single-artifact case). The moment a Mimir artifact is referenced as an input to any downstream subtask, the dispatch-time review requirement applies unchanged.
- **No agent may review its own output** — independent review always required.
- Reviewers receive artifact path(s) constituting the complete output (which they read directly) plus the task description — review validates fulfillment of the request, not just generic quality. **Never paraphrase artifact contents**; always reference required artifacts by path.
- Heimdall reviews open with a single-line verdict (`PASS` / `PASS-WITH-NOTES` / `BLOCKED`); `PASS-WITH-NOTES` counts as passing.
- The three Odin agent files are generated from a single source (template + mode-specific fragments) by `scripts/generate-odin-agents.sh`; the committed files are byte-identical to regenerated output, enforced by `scripts/validate.sh` check 4. Rule-bearing details shared between AGENTS.md and the Odin files are tripwired by parity markers in `scripts/validate.sh`; update both sources and the marker list together.
- Odin consults Kvasir proactively for tasks needing planning, decomposition, or strategy — when in doubt, consult rather than skip.
- Only tasks with a **single substantive subtask** (mandatory review gates excluded) and an obvious approach skip Kvasir, with a stated one-sentence reason why the approach is obvious. A user-supplied step list or decomposition in the prompt does not reduce the subtask count or establish an obvious approach — the count is of subtasks Odin will dispatch, and user-provided decomposition is input to strategy, not a substitute for it. The Odin agent files define the concrete triggers.
- **Session reuse**: Resume a subagent's prior session when same agent, same workstream, prior context is useful. Always use a fresh Heimdall session for the Final Review Gate (merged single-artifact fix rounds resume the same session); reviews of distinct parallel artifacts each use a fresh Heimdall session (different workstreams, prior-review context is anchoring risk). Session reuse reduces re-briefing overhead within one agent's work; it is not a substitute for the artifact-handoff mechanism and cannot move context between different agents.
- **Artifact workspace convention**: Research, advisory, and review subagents write complete outputs to a task-scoped directory `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/` **rooted at the current working directory of the session** (the project being worked on) — never a global, home, or configuration location, and never another project's directory. The pattern is: `<yyyymmdd>` = today's date, `<task-slug>` = short kebab-case task summary, `<xx>` = 2–4 character suffix Odin invents at task start and reuses for that task's lifetime (provides collision-avoidance when multiple concurrent sessions work in the same repo). The implementer's persistent output is file/code changes in the target project itself. This directory is gitignored and **must never be committed**. On host/target projects, establish and ignore a similar workspace. **Never deliver a bare workspace path as the final deliverable**; promote content into the final response or, on request, to a persistent location.
- **Capability awareness**: Both Odin and Kvasir independently load the reserved `capability-inventory` skill at the start of task execution/planning, accessing the complete inventory of specialist capabilities (built-in skills by role + custom-granted tools) from `$CONFIG_BASE/skills/yggdrasil/shared/capability-inventory/SKILL.md`. No relay, curation, or copying needed — both agents load the same source directly via name-based discovery. Custom tool grants are managed post-install in `$CONFIG_BASE/yggdrasil/custom-capabilities.yaml` and `$CONFIG_BASE/agents/yggdrasil/`, never in the repo.
- **Memory system convention**: Yggdrasil maintains a persistent knowledge base at `.yggdrasil-memory/` **rooted at the current working directory of the session** (per project/repo) — never a global or configuration location — recommended to be git-tracked — distinct from the transient, gitignored `.yggdrasil-workspace/` task artifact workspace. Memory contains distilled, source-cited entries (markdown + YAML frontmatter) plus an `INDEX.md` manifest. The promotion pipeline (Heimdall-reviewed research → Brokk distills → Heimdall reviews write) ensures only vetted findings enter memory; promotion is initiated only on user request (e.g., via `/yggdrasil/remember`), not automatically at task wrap-up. The dream consolidation operation (Mimir audits → Heimdall reviews audit → Brokk consolidates → Heimdall reviews diff) maintains memory hygiene; every Brokk output is reviewed, no exception. The forget deletion operation (explicit user-named scope, Odin restates exact entry list and obtains confirmation, Brokk deletes, Heimdall reviews diff) is never autonomous and never commits — git provides the recovery net. Subagents consult the persistent knowledge base autonomously under their standing convention (Recall) — memory entries are leads, not ground truth, reviewed at write time but not guaranteed current. When `.yggdrasil-memory/` exists, Odin includes a memory-consultation pointer in task dispatches; contradiction reports from subagents (live sources contradicting `active` entries) should prompt Odin to consider suggesting a Dream consolidation. Recall requires no dedicated review round (it is contextual input, not output) — existing per-output review disciplines catch stale-memory-derived errors. A slash-command is a macro for a user request to Odin — any command whose `agent` targets a specialist is a review-bypass backdoor and forbidden.

## Orchestration Patterns

These patterns are defaults, not an exhaustive menu. Combine, repeat, or reorder them as the task demands — e.g., multiple research → implement → review rounds within one task.

| Pattern | When to Use |
| ------- | ----------- |
| Prompt Council → any pattern below | Ambiguous or high-stakes prompt (mode-specific threshold — see Prompt Council below) |
| Research → Report | Research-only deliverable |
| Research → Implement → Review | Standard pattern |
| Implement → Review | Context is clear |
| Research → Advise → Implement → Review | Any Kvasir consultation criterion met (see Agent Selection Guide) — complex, multi-workstream, or high-stakes work |
| Advise → Research → Implement → Review | Kvasir consultation criteria met and decomposition/sequencing is the primary challenge |

The Prompt Council row is a planning-stage front-end, not an alternative pattern: when its trigger threshold is met, run the council first and feed the synthesized prompt into whichever pattern the task needs (see the Prompt Council documented-decision sections below). The Advise stage is likewise composable: the Kvasir check applies to every plan regardless of the row chosen, and Advise is inserted into any pattern (e.g., Advise → Research → Report) when the check verdicts consult — the two Advise-inclusive rows are the common shapes, not an exhaustive list. When both front-ends fire, the council runs first and Kvasir strategizes over the synthesized prompt.

Every plan — including Research → Report — ends at the Final Review Gate (see below).

## Final Review Gate

Before Odin delivers any final response, Heimdall must validate the assembled deliverable against the user's original request — confirming quality, correctness, and completeness, and that every requested item is addressed.

- **Mandatory and universal**: the gate applies to every orchestration pattern, including research-only tasks (Research → Report). **No deliverable reaches the user without passing it.** The gate applies to the deliverable regardless of delivery channel — user-facing content delivered via Bragi is part of the assembled deliverable and must pass the gate before delivery; mid-task interaction (clarifying questions, status updates, requirement gathering) is not a deliverable and is exempt.
- **Mechanics**: Odin tasks Heimdall with the user's original request in full and the complete assembled deliverable. If Heimdall reports gaps, Odin resolves them via delegation and repeats the validation before delivering. A documented blocker produced by the escalation path is not an "unresolved gap" — when tasking the gate, Odin declares the documented blocker(s), and Heimdall validates the deliverable with those gaps disclosed, confirming the disclosure is accurate and prominent and that nothing else is missing. Repeated gate failures follow the failed-review escalation ladder defined in the Odin files.
- **Single-artifact case**: when one Brokk artifact or one Mimir artifact is the entire deliverable, a single Heimdall review serves as both artifact review and final gate — provided it includes the user's original request. When the artifact is Mimir, that review also inherits the research-verification obligation: verify the research claims against the actual sources (codebase, documentation, cited materials), not just validate against the user's request.

This gate exists because per-subtask reviews validate pieces, not the whole: only a final validation against the original request catches missed items, lost context, and partial assembly.

## Agent Selection Guide

| Task Type | Agent | Skills |
| --------- | ----- | ------ |
| Orchestration & coordination | **Odin** | `odin-*` (user-defined, see `skills/odin/README.md`) |
| Communication | **Bragi** | `bragi-*` (presentation-structuring, question-formulation, tradeoff-communication, council-clarifier, council-completer, council-empath, council-adversary, council-constraint) |
| Research & analysis | **Mimir** | `mimir-*` (codebase-exploration, data-analysis, debugging-analysis, dependency-analysis, impact-analysis, performance-analysis, security-analysis, web-research) |
| Implementation & artifact creation | **Brokk** | `brokk-*` (api-design, backend-development, database-development, devops, documentation-writing, frontend-development, git, memory-curation, refactoring, testing) |
| Review & validation | **Heimdall** | `heimdall-*` (accessibility-review, api-contract-review, architecture-review, code-review, dependency-review, documentation-review, performance-review, security-review, test-review) |
| Strategic planning & decomposition | **Kvasir** | `kvasir-*` (approach-evaluation, research-decomposition, risk-assessment, task-decomposition) |

## Boundaries (Hard Rules)

These hard rules fall into two scopes: guardrails on target/host projects (the software the pantheon operates on), and rules about the Yggdrasil repo itself. Yggdrasil is not a Node/JS project; paths like `node_modules/`, `dist/`, `.next/`, and `.env.local` are generic examples for target projects agents build, not directories in this repo.

### On target/host projects (the software agents operate on)

- **Never commit secrets**: Env vars, API keys, passwords — use `.env.local` (gitignored)
- **No modifications to vendor/build directories**: e.g. `node_modules/`, `dist/`, `.next/` are off-limits

### On the Yggdrasil repo itself and all work

- **No bypassing specialist agents** — Odin must not implement or review directly
- **Frontmatter governance — protected vs. tunable fields**:
  - **Protected (do not modify):** `name` and `mode` are configuration consumed by OpenCode and must not be changed.
  - **Governed (scope changes require a documented decision):** `permission` blocks define each agent's allowed tools and paths. Adding, removing, or widening a grant — changing *what* is allowed — requires a documented decision, following the same governance model as `temperature` below. Updating an existing allow-list entry's literal value (e.g., a path glob) to track an unrelated, repo-wide convention change — such as a directory rename — without altering what is granted, is ordinary maintenance and does not require a separate governance decision, provided the edit still goes through normal review.
  - **Updatable:** `description` may be updated to match role changes.
  - **Deliberately tunable:** `temperature` is tunable configuration that controls model variance; change it only via documented decision with observed cause/rationale, never as a side effect of other edits. Adjust at most one role's `temperature` at a time to enable clear observation of behavioral impact.
- **Subagent isolation**: subagent prompts (`agents/*.md` except `odin-*`) and their skills (`skills/<subagent>/**`) must never reference other agents by name or presume the multi-agent pantheon — subagents do not know about each other; use "the requesting agent". Name references are enforced by `scripts/validate.sh`; nameless role-presumption is reviewed manually.
- **Task artifact workspace is gitignored and transient**: The `.yggdrasil-workspace/` directory and its contents must never be committed. It exists only for the duration of a task lifecycle and is automatically ignored by git. The workspace is rooted at the current working directory of the session — never a global or configuration location.

## Odin Agent Generation (Documented Decision)

**What changed:** The three Odin agent files (`agents/odin-autonomous.md`, `agents/odin-guided.md`, `agents/odin-interactive.md`) are now generated from a single source of truth rather than hand-maintained with manual synchronization.

**Why:** The three files share an identical body block (Responsibilities → Review & Quality Gates) with only the frontmatter and Communication Policy section differing by mode. Maintaining three copies required careful hand-editing to keep them in sync, enforced by a checksum-based validation check. Generating them from a shared template + mode-specific fragments reduces maintenance friction while preserving the identical-body governance guarantee.

**How it works:**

- **Source files** live in `scripts/odin-generator/`:
  - `preamble.template` — frontmatter and title (with placeholders for mode-specific fields)
  - `shared-body.template` — the byte-identical block (Responsibilities through Review & Quality Gates)
  - `communication-policy-<mode>.fragment` — mode-specific Communication Policy sections (one per mode)
- **Generator** (`scripts/generate-odin-agents.sh`) assembles each mode's file by substituting placeholders and concatenating the parts.
- **Validation** (`scripts/validate.sh` check 4) regenerates the files and diffs against committed versions; any drift (hand-edits or un-regenerated source changes) fails validation.
- **Smoke test** (`scripts/ci-smoke-odin-generator.sh`) provides an end-to-end test of the generator for CI/pre-commit use.

**Governance impact:** The parity-marker mechanism (check 7) is unchanged — markers continue to pin rule text across AGENTS.md and the Odin files. The committed Odin files remain the runtime artifacts; `setup.sh` installs them unchanged. Future edits to the shared body or mode-specific sections happen in the template/fragment source files, then regenerated.

## Prompt Council (Documented Decision)

**What changed:** Added an optional, trigger-gated Prompt Council pattern to Odin's shared body, plus five committed `bragi-council-*` persona skills. When invoked, N (default 5) persona-framed communication-specialist instances reformulate an ambiguous or high-stakes user prompt in parallel, a fresh-session synthesizer merges them into one enriched prompt, and Heimdall gates the synthesis before any downstream subtask consumes it. The five personas — Clarifier (precision), Completer (coverage), Empath (user intent), Adversary (risk/failure modes), Constraint (boundaries/scope) — each address a distinct axis of the prompt; their outputs are complementary, not convergent.

**Why:** The user requested a multi-persona prompt-reformulation council. Research into multi-agent debate showed the pattern is effective at small N for high-stakes decisions, and that *synthesis* (merging complementary lenses) avoids the consensus-deadlock problem that *convergence* (forcing agreement) creates. Committed persona skill files ensure persona consistency across invocations, which a runtime-dispatch-prompt framing could not guarantee. Embedding the process in Odin's generated shared body makes the pattern canonical rather than opt-in-discoverable.

**How it works:**

- **Persona skills:** `skills/bragi/bragi-council-<persona>/SKILL.md` (5 files). Each is a *stance-guidance* skill (which lens to adopt) — a new sub-kind of Bragi skill, structurally identical to the existing *process-guidance* skills. Each skill's "When to Use" section explicitly restricts application to council dispatch, preventing persona over-application to routine communication.
- **Process:** `scripts/odin-generator/shared-body.template` gains a `### Prompt Council` subsection under `## Planning` (mode-agnostic mechanism) and a scoped exception in `### Review Rules` for council-synthesis gating. The three Odin agent files are regenerated by `scripts/generate-odin-agents.sh`; check 4 enforces byte-identical freshness.
- **Mechanism:** Dispatch N persona Bragis in parallel → collect artifacts → dispatch one fresh-session synthesizer Bragi → task Heimdall to review the synthesis → on high/medium confidence, feed the synthesized prompt to the normal pipeline; on low confidence, escalate per the mode's Communication Policy (the prompt is genuinely ambiguous and needs user direction, not re-debate).
- **Fallback:** Mode-dependent. The shared-body mechanism references the existing Communication Policy escalation rule; the per-mode fragments' existing escalation clauses already cover the low-confidence case (autonomous: pick + disclose; guided: one permitted mid-execution contact; interactive: surface as decision point). No fragment changes for v1.
- **Constraints:** K=1 (one round, no iterative revision); N=5 (all personas fire); artifacts written to the task workspace as `NN-council-round1-<persona>.md` and `NN-council-synthesis.md`.

**Governance impact:**

- **Shared body edited** (Review Rules scoped exception + new Prompt Council subsection) — byte-identical across all three Odin files, enforced by check 4. This is a governed edit to the shared body, following the same documented-decision model as `temperature` changes.
- **Review scope widened (scoped to council syntheses only):** advisory outputs remain unreviewed except for the council-synthesis exception. Routine Kvasir advisories and non-council communication outputs are unchanged. The exception is explicitly scoped in the Review Rules wording to prevent creep.
- **New Bragi skills are first-class communicator capabilities:** the five `bragi-council-*` skills are harvested by `generate-capabilities.sh` into the `capability-inventory` under `### communicator`, visible to every planning session. The `council-` naming prefix and the "When to Use → only when dispatched as a council persona" wording are the safeguards against indiscriminate application.
- **No permission block changes:** Heimdall is already in Odin's `task:` allowlist; the gating uses an existing grant, not a widened one.
- **No `validate.sh` logic changes:** the 5 new skills pass checks 1, 2, 3, 5, 6 automatically; check 4 catches any failure to regenerate Odin files; check 7 is unchanged — the Prompt Council mechanism is Odin-local (not mirrored into AGENTS.md's Orchestration Rules), and the Review Rules exception line is not a parity-marked string, so no marker addition is needed for v1. Deferring mirroring to AGENTS.md's Orchestration Rules until usage evidence accumulates follows the same Option-α deferral the prior advisory recommended.
- **Persona skills are always-installed (not optional/default):** the five `bragi-council-*` skills are installed unconditionally by `setup.sh`, alongside `brokk-memory-curation`, regardless of the user's answer to the "Copy default skills?" prompt. Odin's shared body embeds the Prompt Council process that dispatches persona-framed instances expecting these skills to be present; without them, a high-stakes ambiguous prompt would trigger a council dispatch that fails to find the persona skills, and the council mechanism has no fail-safe fallback. The always-install block lives in `setup.sh` near the `brokk-memory-curation` block and is not gated by `COPY_SKILLS`.

## Prompt Council Mode-Sensitive Triggers (Documented Decision)

**What changed:** The council's "when to invoke" rule is split into mode-agnostic *trigger signals* (ambiguity, stakes) defined in the shared body, and a mode-owned **Council trigger threshold** defined in each Communication Policy fragment: low bar in Autonomous (ambiguity alone suffices), medium bar in Guided (ambiguity surviving requirements-gathering + stakes), high bar in Interactive (both signals strong AND a direct question unlikely to resolve). Also: an ambiguity tiebreaker ("when in doubt, treat the prompt as ambiguous"), removal of the v1 deterrent framing, and the Autonomous interpretation-picking instruction now defers to the council. This supersedes v1's mode-agnostic "both required" trigger and its "No fragment changes for v1" note.

**Why:** Observed under-use of the council; the fixed conjunctive trigger ignored the mode-asymmetric cost of the alternative. Interactive can ask the user at near-zero cost, so a 7-dispatch council is rarely the cheapest disambiguator there; Autonomous can never ask, so the council is its only substitute for a clarifying question and must fire much more readily; Guided sits between. The v1 wording also primed skipping (three deterrent clauses) and let "genuinely ambiguous" be self-assessed away, especially in Autonomous mode where interpretation-picking is the standing instruction.

**How it works:** Shared body defines the two signals and delegates the firing threshold to the Communication Policy (same delegation pattern as the low-confidence escalation rule); each fragment carries its threshold bullet; the mechanism (dispatch → synthesize → Heimdall gate), K=1, N=5, persona skills, and the Review Rules scoped exception are unchanged. Regeneration via `scripts/generate-odin-agents.sh`; check 4 enforces freshness/byte-identity.

**Governance impact:** Shared-body edit is a governed documented-decision change (this section is that decision). Fragments gain one bullet each (plus the Autonomous interpretation-picking amendment). One new parity marker — `"Council trigger threshold"` — added to `validate.sh` check 7 (count message updated 14 → 15), pinning the rule's label across AGENTS.md and the Odin files. No permission changes; no skill changes; no changes to checks 1–3, 5, 6, 8.

## Prompt Council Adoption v3 (Documented Decision)

**What changed:** Three coordinated remedies to address persistent under-use of the Prompt Council despite the July 27 mode-sensitive trigger fix. The diagnosis: zero recorded council invocations across 23 tasks (July 22–29) persisting after the threshold fix indicates the bottleneck is upstream of the thresholds — in ambiguity *detection* (self-graded with no external check), salience (the council is absent from the primary Orchestration Patterns table), and residual conditionality in the Autonomous mode's escape hatch. The v1 documented decision deferred table inclusion "until usage evidence accumulates"; that condition is now met by evidence of non-use partly attributable to low salience. The three changes: (1) **R1 — Mandatory recorded signal assessment:** for every prompt, the plan must state an explicit one-line council-trigger verdict (`Council check: ambiguity=<yes/no — reason>, stakes=<yes/no — reason> → <invoke / skip>`), with 2–3 concrete ambiguity examples to anchor calibration; (2) **R2 — Invert the Autonomous escape hatch:** rework the threshold so skipping, not invoking, carries the burden of proof — invoke whenever ambiguity is present, with the only exception being a trivially low-stakes task where you can state a one-sentence reason why redoing the task costs less than a council run; also reframe the shared body's Cost bullet to weigh the 7-dispatch cost against the cost of redoing the full pipeline on a mis-picked interpretation; (3) **R3 — Add to Orchestration Patterns table:** add a prefix row (`Prompt Council → any pattern above`) plus a clarifying note to both AGENTS.md and `shared-body.template`, making the council visible in the primary planning reference.

**Why:** The research identified four structural barriers to council adoption, weighted by causal priority: (1) self-graded ambiguity detection with no forcing or recording mechanism (upstream of all thresholds, and the one driver the July 27 fix did not touch); (2) salience gap — the council is absent from the Orchestration Patterns table, the first artifact Odin's planning consults; (3) residual conditionality and cost-salient framing in the Autonomous "low bar," which hands Odin a rational-sounding, self-graded justification to skip; (4) no feedback loop or persistent memory (amplifier, not root cause). R1 attacks driver 1 directly by externalizing the assessment and making skip decisions visible. R2 attacks driver 3 by inverting the burden of proof and reframing cost against the rework it prevents. R3 attacks driver 2 by making the council visible in the primary planning reference. Together, these address the plausible causal chain behind zero invocations. The deferral's own condition ("until usage evidence accumulates") has been met; the correct response to evidence of non-use is to end the deferral via a superseding documented decision, not to keep waiting.

**How it works:** (1) **R1:** Shared-body template gains a requirement that every plan includes a one-line council-trigger verdict, plus 2–3 concrete ambiguity examples ("improve the error handling" — vague verb + unspecified scope; "make the system more robust" — abstract goal; "refactor the codebase" — no specification). (2) **R2:** `communication-policy-autonomous.fragment` threshold bullet is reworded so invoking is the default and skipping requires a stated one-sentence justification; the shared-body Cost bullet is reframed to pair the 7-dispatch cost against the cost of redoing the full pipeline on a mis-picked interpretation. (3) **R3:** One row is added to the Orchestration Patterns table in both AGENTS.md and `shared-body.template` (`Prompt Council → any pattern above | Ambiguous or high-stakes prompt (mode-specific threshold — see Prompt Council below)`), plus a clarifying note directly below the table explaining the council is a planning-stage front-end, not an alternative pattern. Guided and Interactive fragments' threshold bullets are unchanged. Regeneration via `scripts/generate-odin-agents.sh`; check 4 enforces byte-identity.

**Governance impact:** Shared-body and fragment edits are governed documented-decision changes. The existing `"Council trigger threshold"` parity marker (check 7, count 15) is preserved — R2 keeps the label intact. No new parity markers are added (the "Council check" recording requirement is a procedural rule, not a mirrored rule label). No permission, frontmatter, or skill changes. Regeneration via `scripts/generate-odin-agents.sh` + check 4 byte-identity enforcement as always. **Explicitly deferred:** council-lite (N<5) — defer until post-Phase 1 evidence shows Odin detecting ambiguity and still explicitly skipping on cost grounds; durable invocation logging — route through `.yggdrasil-memory/` when it exists (user-initiated promotion only, per memory convention); any change targeting synthesizer confidence bias — defer until at least a handful of real council runs exist to observe.

## Git Workflow

### Commit Messages

Conventional commits, lowercase, no period, ~50 chars:
`feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `release:`

### Branching

- `main`: Production-ready (protected)
- `develop`: Integration branch
- `feature/<name>`: Feature development
- `fix/<name>`: Bug fixes

## Kvasir Consultation Trigger v2 (Documented Decision)

**What changed:** Three coordinated remedies to address a gap in Odin's Kvasir consultation trigger: the decision to consult or skip is currently self-graded and unrecorded, causing Odin to skip Kvasir on tasks that should have triggered it. The diagnosis: a multi-workstream KT-prep task with ≥4 substantive subtasks and three affirmative trigger criteria (multi-workstream dependencies, multiple viable approaches, unclear execution order) slipped through because (1) the check is self-graded with no forcing function, (2) a user-supplied step list masqueraded as strategy via the skip clause's "obvious approach" gloss, and (3) Orchestration Patterns table labels ("complex or high-stakes") were narrower than the consultation rule, actively routing eligible tasks to "Standard pattern." The three changes: (1) **K1 — Mandatory recorded Kvasir check:** for every plan, state an explicit one-line verdict (`Kvasir check: substantive subtasks=<n>, criteria=<…> → <consult/skip — reason>`), with the falsifiable subtask count as the forcing function and a KT-shaped calibration example; (2) **K2 — Invert the skip burden and neutralize the "obvious approach" hatch:** reword the skip clause so skipping requires n=1 and a stated one-sentence reason, and add an explicit guard that user-supplied decomposition neither reduces the count nor makes the approach obvious (preserving the `single substantive subtask` parity marker verbatim); (3) **K3 — Realign table labels:** update the two Advise-row "When to Use" labels in both AGENTS.md and the template to match the consultation criteria rather than the narrower "complex or high-stakes" framing.

**Why:** The parallel to Prompt Council Adoption v3 holds for the primary root cause (self-graded, unrecorded detection) and, in mutated form, for the escape-hatch problem — but the Kvasir case adds one cause with no Council analogue: a user-supplied step list masquerading as strategy. The Kvasir trigger has an objective forcing function available (subtask count) that ambiguity lacks, making the fix stronger: a recorded verdict whose central field is falsifiable arithmetic. The table-label mismatch is a distinct problem: Kvasir appears in the Orchestration Patterns table twice, but under labels narrower than the rule, so the table contradicts rather than reinforces the consultation criteria.

**How it works:** (1) **K1:** Shared-body template gains a new `### Kvasir Consultation Check` subsection under `## Planning` (after Prompt Council, before Decomposition & Dependency Rules), with the mandatory recorded-verdict requirement, the five affirmative trigger criteria, and two calibration examples (one KT-shaped: a multi-research-stream prompt with a user-supplied step list; one simple lookup: n=1, skip). (2) **K2:** The Kvasir bullet's skip clause is reworded to require n=1 and a stated reason, with an explicit guard against the pre-decomposed-prompt failure; the parity-marker string `single substantive subtask` is preserved verbatim. (3) **K3:** The two Advise-row labels in the Orchestration Patterns table are updated in both AGENTS.md and `shared-body.template` (kept identical) to reference the consultation criteria. Regeneration via `scripts/generate-odin-agents.sh`; check 4 enforces byte-identity.

**Governance impact:** Shared-body and AGENTS.md edits are governed documented-decision changes. No new parity markers are added (the `Kvasir check:` verdict format is a procedural rule, not a mirrored rule label, following the Council v3 precedent of not marking the "Council check" requirement). The existing `"single substantive subtask"` parity marker (check 7, count 15) is preserved — K2 keeps the label intact. No permission, frontmatter, or skill changes. Regeneration via `scripts/generate-odin-agents.sh` + check 4 byte-identity enforcement as always.

## Kvasir Composability Note (Documented Decision)

**What changed:** Rejected a proposal to add Kvasir as its own prefix-pattern row (analogous to Prompt Council's `Prompt Council → any pattern below` row) and instead extended the composition clarifying note in both `AGENTS.md` and `scripts/odin-generator/shared-body.template` to state explicitly that Advise composes into **any** pattern whenever the Kvasir check verdicts consult. Also pinned a new sequencing rule: when both Prompt Council and Kvasir fire on the same task, Prompt Council runs first — Kvasir strategizes over the synthesized prompt, never the ambiguous original.

**Why:** The proposal was structurally sound in substance — Kvasir *is* a universal planning front-end, and the table's Advise-in-2-of-6-rows presentation mildly understates that — but the prefix-row form is the wrong shape for Kvasir. The Council is position-fixed (always first, operates on the raw prompt, and had zero table representation before v3); Kvasir is position-flexible (the two existing rows encode real ordering doctrine: `Research → Advise` vs. `Advise → Research`). A prefix row would trade a mild inaccuracy (apparent pattern-specificity) for a real one (apparent position-fixity) and discard the just-shipped K3 labels. The substantive routing problem is already solved by today's K1 recorded check — stronger than the Council's own forcing function because it is falsifiable arithmetic — so a table change now would be salience-only atop an untested fix. The Council v3 precedent itself says: defer table restructuring until usage evidence accumulates; that evidence will now be visible in recorded `Kvasir check` verdicts (K1 makes every skip decision legible, unlike the Council's pre-v3 silent zero-invocation gap).

**How it works:** (1) Extend the composition paragraph in `shared-body.template` (line 100) to state that Advise composes into **any** pattern — including Research → Report and Implement → Review — whenever the Kvasir check verdicts consult, and add the Council-first ordering rule. (2) Append a parallel clarification to the Prompt Council note in AGENTS.md (after line 50) explaining that Advise is likewise composable and pinning the Council-first rule. (3) Add this documented-decision section to record the rejection rationale and the reopen trigger. (4) Regenerate the three Odin agent files via `scripts/generate-odin-agents.sh` to propagate the shared-body change.

**Governance impact:** Edits to `shared-body.template` (one paragraph) and AGENTS.md (table note + decision record). No parity markers are touched — the composition paragraph and table note are not among the 15 pinned markers (verified against `validate.sh` check 7). No fragment changes — the Council-first ordering rule is mode-agnostic mechanism, so it belongs in the shared body, not fragments. No permission, frontmatter, temperature, or skill changes. Regeneration via `scripts/generate-odin-agents.sh`; check 4 enforces byte-identity.

**Reopen trigger:** If recorded `Kvasir check` verdicts accumulate evidence of consult-routing failures into non-Advise-shaped patterns (e.g., a pattern like Research → Report where the check verdict says n≥2 and consult, but the plan was routed to a non-Advise shape), that is the evidence trigger to revisit the prefix-row option. This mirrors the Council v3 precedent: defer table restructuring until usage evidence shows the current approach failing.

## Kvasir Volumetric Research Scaling (Documented Decision)

**What changed:** Added a volumetric-batching dimension to `skills/kvasir/kvasir-research-decomposition/SKILL.md` — a mandatory recorded scaling verdict (`Scaling check: independent units=<N>, … → <single cluster — reason | K batches of ~M units>`), a default-to-fan-out rule with inverted skip burden for large homogeneous target sets (guideline N > ~20 at per-unit rigor), batch-sizing/grouping heuristics, a map-reduce plan shape with uniform per-unit output schema, large-N and small-N calibration examples, and a counterweight "Volume collapse" anti-pattern. Deliberately **rejected** a companion change to `shared-body.template`'s Decomposition & Dependency Rules.

**Why:** An observed incident: a research task spanning 770 independent repositories produced a decomposition plan with a single research subtask. Diagnosis (Heimdall-reviewed research): the skill's clustering model was purely topical — 770 homogeneous repos present no topical seams, so the workflow correctly produced one cluster; the anti-pattern list penalized only over-fragmentation, never under-parallelization; and the scaling decision was self-graded and unrecorded. The remedy set follows the Council v3 / Kvasir Trigger v2 template: recorded forcing function, burden inversion, calibration examples.

**How it works:** Skill-only edit — the scaling decision is specialist decomposition methodology, not a universal orchestration mechanism. The existing Kvasir Consultation Check already routes large-N research tasks to consultation; the broken link was inside the skill.

**Governance impact:** Kvasir skill files are not Odin-generated: no regeneration via `scripts/generate-odin-agents.sh`, no check 4 exposure, no parity-marker changes (count remains 15), no Orchestration Patterns table changes, no permission/frontmatter/temperature changes. Skill passes normal validation (frontmatter + required sections) and normal review.

**Reopen trigger:** If a recorded incident shows the *requesting-agent-side* failure mode — a large-N research scope dispatched as a single research subtask without Kvasir consultation, or with the skill's verdict recorded and then ignored at dispatch — that is the evidence to revisit adding a scaling rule to shared-body's Decomposition & Dependency Rules (governed documented-decision change, regeneration + check 4).

## Parallel Research Review Isolation (Documented Decision)

**What changed:** Added explicit clarification to the Session Reuse and Review Rules sections of the shared body, plus a parity clause in AGENTS.md, establishing that (a) reviews of distinct parallel Mimir research artifacts each use a fresh Heimdall session, and (b) each such review evaluates the artifact against its own per-subtask research brief, not the top-level user request.

**Why:** The documented convention was silent on both questions, creating ambiguity that could lead to anchored reviews (one Heimdall session reviewing multiple parallel artifacts sequentially, importing consistency pressure and topic contamination) and wrong-benchmark reviews (evaluating a parallel research artifact against the top-level user request rather than its specific subtask brief). The failure modes are silent — a biased or wrong-benchmark review does not fail loudly — so incident-based deferral cannot reliably fire. Exposure is growing: the Volumetric Research Scaling decision (this month) institutionalizes K-batch parallel research dispatch as the default for large homogeneous scopes, multiplying the number of parallel Mimir artifacts requiring review. The cost of the fix is minimal: two sentences in the template, one clause in AGENTS.md, codifying the reading the existing Session Reuse and Final Review Gate doctrine already implies.

**How it works:** (1) **A1 — Session Reuse:** Added one sentence to the Session Reuse section establishing that reviews of distinct parallel artifacts (separate subtask briefs from the same dispatch round) each use a fresh Heimdall session, anchored to the existing same-workstream criterion and the existing "independent judgment" tiebreaker rationale. (2) **A2 — Review Rules:** Added one clause to the Review Rules section defining "originating task description" as the per-subtask brief for parallel research artifacts, with the top-level request positioned as optional context and scope mismatches routed to Failed Review Classification as plan-level signals. (3) **A3 — AGENTS.md parity:** Added a summarized clause to the Session Reuse bullet in AGENTS.md, plus this documented-decision section. (4) **Regeneration:** The three Odin agent files are regenerated via `scripts/generate-odin-agents.sh`; check 4 enforces byte-identity.

**Governance impact:** Shared-body and AGENTS.md edits are governed documented-decision changes. **No new parity markers are added** — the clarifications are procedural (extending existing doctrine to the parallel case), not new pinned rule labels, following the precedent set by Council v3 and Kvasir Trigger v2 (count remains 15). No fragment changes (mode-agnostic mechanism), no skill changes, no permission/frontmatter/temperature changes, no Orchestration Patterns table changes. Regeneration via `scripts/generate-odin-agents.sh`; check 4 enforces byte-identity.

**Scoping note:** Whether same-brief batch outputs from a single volumetric fan-out (K batches, one brief template, uniform schema) may share a review session is deliberately left to the existing Session Reuse tiebreaker — the new sentence targets distinct-brief parallel artifacts, where the anchoring risk is unambiguous and the useful-context claim is clearly false. If batched-review practice later shows either anchoring problems or excessive fresh-session overhead, that is the natural amendment point.

**Reopen trigger:** If post-fix evidence shows the fresh-session requirement imposing material overhead on large-K batched research reviews (each fresh Heimdall re-establishing source context), revisit with a scoped batch carve-out — a governed shared-body amendment, not a rollback of the isolation principle.

## Definition of Done

1. All agent definitions valid (YAML frontmatter parses correctly)
2. All skill definitions valid (YAML frontmatter + required sections present)
3. `setup.sh` installs correctly (idempotent)
4. Documentation updated (README, AGENTS.md) if applicable
5. No secrets or sensitive data committed
6. No `.DS_Store` or other junk files tracked

Items 1–2 are verified by running `scripts/validate.sh`.
