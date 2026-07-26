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
- Only tasks with a **single substantive subtask** (mandatory review gates excluded) and an obvious approach skip Kvasir; the Odin agent files define the concrete triggers.
- **Session reuse**: Resume a subagent's prior session when same agent, same workstream, prior context is useful. Always use a fresh Heimdall session for the Final Review Gate (merged single-artifact fix rounds resume the same session). Session reuse reduces re-briefing overhead within one agent's work; it is not a substitute for the artifact-handoff mechanism and cannot move context between different agents.
- **Artifact workspace convention**: Research, advisory, and review subagents write complete outputs to a task-scoped directory `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/` **rooted at the current working directory of the session** (the project being worked on) — never a global, home, or configuration location, and never another project's directory. The pattern is: `<yyyymmdd>` = today's date, `<task-slug>` = short kebab-case task summary, `<xx>` = 2–4 character suffix Odin invents at task start and reuses for that task's lifetime (provides collision-avoidance when multiple concurrent sessions work in the same repo). The implementer's persistent output is file/code changes in the target project itself. This directory is gitignored and **must never be committed**. On host/target projects, establish and ignore a similar workspace. **Never deliver a bare workspace path as the final deliverable**; promote content into the final response or, on request, to a persistent location.
- **Capability awareness**: Both Odin and Kvasir independently load the reserved `capability-inventory` skill at the start of task execution/planning, accessing the complete inventory of specialist capabilities (built-in skills by role + custom-granted tools) from `$CONFIG_BASE/skills/yggdrasil/shared/capability-inventory/SKILL.md`. No relay, curation, or copying needed — both agents load the same source directly via name-based discovery. Custom tool grants are managed post-install in `$CONFIG_BASE/yggdrasil/custom-capabilities.yaml` and `$CONFIG_BASE/agents/yggdrasil/`, never in the repo.
- **Memory system convention**: Yggdrasil maintains a persistent knowledge base at `.yggdrasil-memory/` **rooted at the current working directory of the session** (per project/repo) — never a global or configuration location — recommended to be git-tracked — distinct from the transient, gitignored `.yggdrasil-workspace/` task artifact workspace. Memory contains distilled, source-cited entries (markdown + YAML frontmatter) plus an `INDEX.md` manifest. The promotion pipeline (Heimdall-reviewed research → Brokk distills → Heimdall reviews write) ensures only vetted findings enter memory; promotion is initiated only on user request (e.g., via `/yggdrasil/remember`), not automatically at task wrap-up. The dream consolidation operation (Mimir audits → Heimdall reviews audit → Brokk consolidates → Heimdall reviews diff) maintains memory hygiene; every Brokk output is reviewed, no exception. The forget deletion operation (explicit user-named scope, Odin restates exact entry list and obtains confirmation, Brokk deletes, Heimdall reviews diff) is never autonomous and never commits — git provides the recovery net. Subagents consult the persistent knowledge base autonomously under their standing convention (Recall) — memory entries are leads, not ground truth, reviewed at write time but not guaranteed current. When `.yggdrasil-memory/` exists, Odin includes a memory-consultation pointer in task dispatches; contradiction reports from subagents (live sources contradicting `active` entries) should prompt Odin to consider suggesting a Dream consolidation. Recall requires no dedicated review round (it is contextual input, not output) — existing per-output review disciplines catch stale-memory-derived errors. A slash-command is a macro for a user request to Odin — any command whose `agent` targets a specialist is a review-bypass backdoor and forbidden.

## Orchestration Patterns

These patterns are defaults, not an exhaustive menu. Combine, repeat, or reorder them as the task demands — e.g., multiple research → implement → review rounds within one task.

| Pattern | When to Use |
| ------- | ----------- |
| Research → Report | Research-only deliverable |
| Research → Implement → Review | Standard pattern |
| Implement → Review | Context is clear |
| Research → Advise → Implement → Review | Complex or high-stakes work |
| Advise → Research → Implement → Review | Decomposition is the primary challenge |

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

## Git Workflow

### Commit Messages

Conventional commits, lowercase, no period, ~50 chars:
`feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `release:`

### Branching

- `main`: Production-ready (protected)
- `develop`: Integration branch
- `feature/<name>`: Feature development
- `fix/<name>`: Bug fixes

## Definition of Done

1. All agent definitions valid (YAML frontmatter parses correctly)
2. All skill definitions valid (YAML frontmatter + required sections present)
3. `setup.sh` installs correctly (idempotent)
4. Documentation updated (README, AGENTS.md) if applicable
5. No secrets or sensitive data committed
6. No `.DS_Store` or other junk files tracked

Items 1–2 are verified by running `scripts/validate.sh`.
