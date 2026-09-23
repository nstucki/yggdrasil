# 1. Introduction and Goals

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§1](README.md)._

## 1.1 Requirements Overview

This document records the architecture of the Yggdrasil orchestration framework — the whole repository rooted at the project directory. Yggdrasil is not an application: it is a configuration layer for OpenCode that installs agent definitions, skills, and commands into the OpenCode configuration directory and encodes an orchestration doctrine — one orchestrator (Odin) delegating to five role-bound specialist subagents, exchanging transient Workfiles, gated by independent review, and backed by a persistent, reviewed knowledge base (`README.md:1-471`; `agents/odin-autonomous.md:22-44`).

**Documented scope.** The entire repository: `agents/` (8 generated agent definitions), `skills/` (10 feature directories of `SKILL.md` files), `commands/yggdrasil/` (7 command definitions), `scripts/` (generators, validator, smoke tests, template sources), `config-home/` (install-side payload), `setup.sh` (installer), `docs/architecture/` (this document), and `README.md`. The OpenCode host framework, the internal workflow steps of individual skills beyond their boundary contracts, the install-side generated `capability-inventory` skill, and CI mechanics are out of scope.

**Evidence base.** Every claim in this document cites a repository path. The as-is baseline (sections recorded 2026-09-20) was drafted from a reviewed structural survey of the whole repository plus direct reads of `agents/odin-autonomous.md`, `agents/brokk.md`, `scripts/README.md`, `scripts/generate-subagents.sh:1-145`, `README.md:90-179`, `docs/architecture/README.md`, and directory listings of `agents/`, `skills/**`, `commands/yggdrasil/`, `scripts/**`, `config-home/`. The architecture-documentation requirements below (added 2026-09-23) were drafted from a business analysis of the documentation objective and direct reads of the six `skills/architecture/*/SKILL.md` files, `setup.sh:345-394`, and `README.md:265-301`. The quality goals of the system in §1.2 are inferred and marked as such; the quality goals of the architecture-documentation subsystem are stated requirements.

**Functional overview — what the system does today** (each a documented capability, not a requirement):

| Capability | Evidence |
| --- | --- |
| Accepts a natural-language request or a `/yggdrasil/<command>` in one of three Odin modes and orchestrates specialist dispatches to produce a Deliverable (Response and/or Artifact) | `agents/odin-autonomous.md:30-34, 70-72`; `commands/yggdrasil/research.md:1-13` |
| Runs four packaged multi-specialist workflows — Research, Architecture, Software Engineering, Deliberation Council — invoked whole on a trigger verdict | `agents/odin-autonomous.md:172-219`; `skills/research/odin-research-workflow/SKILL.md:1-53`; `skills/architecture/odin-architecture-workflow/SKILL.md:1-184` |
| Enforces independent review of every Mimir/Brokk Subtask and a Final Review Gate on every Deliverable | `agents/odin-autonomous.md:237-265` |
| Maintains a persistent, source-cited knowledge base through three command-triggered pipelines (Remember, Dream, Forget) | `agents/odin-autonomous.md:84-90`; `skills/memories/odin-memory-system/SKILL.md:24-61` |
| Regenerates all agent definitions from templates and validates structural parity | `scripts/README.md:5-103`; `scripts/generate-subagents.sh:103-121` |
| Installs itself into an OpenCode configuration home and generates a capability inventory there | `README.md:100-136`; `scripts/README.md:162-166`; `setup.sh:349-393` |
| Authors, reviews, and persists an arc42 architecture document into a target project in two modes (`document-existing`, `decide-new`) through the Architecture workflow | `skills/architecture/odin-architecture-workflow/SKILL.md:76-142`; `skills/architecture/kvasir-software-architecture/SKILL.md`; `skills/architecture/brokk-architecture-persistence/SKILL.md` |

**Requirements on the architecture-documentation subsystem.** The Architecture workflow must produce persisted documents that stay useful after the triggering task is complete. The requirements below are the durable statement of that obligation; they are the criteria the decisions ADR-0009 – ADR-0014 realize and the §10.2 scenarios QS-9 – QS-15 measure.

| ID | Requirement | Realized by |
| --- | --- | --- |
| DOC-1 | Every persisted section §1–§12, in both modes and both document scopes, contains only content that passes the long-term-relevance test of §5.2 (architecture-workflow family, invariant I-1): boundaries, interfaces, decisions with rationale, quality goals, stable mechanisms, and risks to the system — never how the run was performed, what one work package does inside a block, temporary measures, or references that resolve only inside the task's workspace | ADR-0010, ADR-0012 |
| DOC-2 | §4 names the stable structural decisions and their rationale; §5 describes module boundaries, provided and required interfaces, and quality-relevant characteristics; §6 traces only architecturally significant flows; §8 describes only stable mechanisms; §9 records only decisions that are expensive to reverse — implementation-phase choices are excluded from all five | ADR-0010 |
| DOC-3 | The context-gathering step scopes a forward-looking run to the objective's structural footprint — module boundaries, entry points, boundary interfaces, existing documentation, dependencies — and records no task-scoped facts (runner commands, conventions for new code, test infrastructure, current behavior of touched paths) | ADR-0010 |
| DOC-4 | A document re-authored as an update delta carries forward the durable content of the documents it replaces and drops task-scoped content left by earlier runs; every removal is named in the author's report | ADR-0010, ADR-0014 |
| DOC-5 | The design-review gate carries one explicit long-term-relevance criterion, applied in both modes, that blocks a document on task-scoped content in §1–§12 with a finding naming its location; no size or document-count ceiling is enforced | ADR-0013 |
| DOC-6 | The author's report states, for every omitted section, its omission type and a one-clause reason, and names every included section whose content was deliberately minimized | ADR-0011 |
| DOC-7 | An omitted section or subsection carries exactly one of three fixed markers, each naming why it was omitted — scope, evidence, or unaffected by the update | ADR-0011 |
| DOC-8 | Persisted sections cite repository paths, section numbers, decision-record IDs, and requirement IDs defined in §1.1 — never workspace paths, task directories, Workfile names, review verdicts, or drafting-run provenance | ADR-0012 |
| DOC-9 | Changes to the behavior of the six Architecture-workflow skills are made in the repository's `skills/architecture/` tree and reach the runtime through `setup.sh`; the installed copy is byte-identical to the repository after installation | ADR-0009 |

## 1.2 Quality Goals

**Quality goals of the system.** All five are **inferred** from what the structure, permission blocks, validators, and doctrine text are visibly optimized for. Derivation basis: each goal is named only where at least two independent mechanisms in the repository enforce it. Ranking reflects how much of the doctrine text and permission machinery is devoted to each.

| Rank | Quality goal | What it means here | Inferred from |
| --- | --- | --- | --- |
| 1 | **Independent verification** | No output reaches the user, the project, or Memory without a review by a reviewer that did not produce it, verified against ground truth rather than self-report | `agents/odin-autonomous.md:237-265` (Review Mechanics, Subtask Review, Final Review Gate); `agents/odin-autonomous.md:40` and `agents/brokk.md:88` (no self-review); `skills/memories/odin-memory-system/SKILL.md:57`; `skills/architecture/odin-architecture-workflow/SKILL.md:160` |
| 2 | **Role isolation and least privilege** | Each agent may do only what its role needs; boundaries are enforced by tool-permission blocks, skill-prefix allowlists, and a validator that forbids cross-agent references | `agents/odin-autonomous.md:6-19` (Odin: only `skill`, `task`, `todo`); `agents/mimir.md:6-68`; `agents/brokk.md:6-64`; `scripts/README.md:71` (Check 5, subagent isolation) |
| 3 | **Reproducibility of the definitions** | Agent files are derived artifacts; the committed state must be byte-identical to generator output | `scripts/README.md:70, 87-95, 105-107, 153-160`; `scripts/generate-subagents.sh:103-121` |
| 4 | **Traceability of claims** | Research, reviews, and Memories cite paths and lines; Memories carry a mandatory `sources` field and a confidence/status lifecycle | `skills/memories/brokk-memory-curation/SKILL.md:91-110`; `agents/odin-autonomous.md:246`; `agents/brokk.md:111-113` |
| 5 | **Extensibility at the install site** | Skills and custom tool grants are added in the installed configuration home without modifying the repository; the capability inventory is regenerated there | `README.md:106, 118, 122, 156`; `config-home/generate-capabilities.sh`; `config-home/custom-capabilities.yaml`; `scripts/README.md:162-166` |

**Quality goals of the architecture-documentation subsystem.** These five are **stated requirements** (not inferred) on the Architecture workflow's output. They drive ADR-0009 – ADR-0014: every options table in those records scores its options against these goals by name, §4 names a tactic per goal, and §10.2 carries a scenario per goal. They refine, and do not re-rank, the system goals above; the subsystem block exists because none of the five system goals speaks to what a persisted document should contain.

| Rank | Quality goal | What it means here | Measurable target |
| --- | --- | --- | --- |
| 1 | **Durability** | A persisted architecture document remains a valid reference across the tasks that follow the one that triggered it, without edits to remove that task's details | A document authored for task T1 remains valid for T2, T3, … with zero removals of T1-specific content |
| 2 | **Clarity** | A reader distinguishes stable architectural facts from task-scoped detail, and knows why a section is empty, without re-reading the triggering objective | Every omitted section names its omission type; no persisted section mixes run provenance with architecture |
| 3 | **Maintainability** | Updating the document for a new objective touches only what the objective changes and carries the rest forward | A delta that changes one building block re-authors one topic document, not its whole section |
| 4 | **Consistency** | One relevance rule applies in both modes, both document scopes, and all twelve sections | One test, stated once, referenced by the author, the gatherer, and the reviewer; zero mode-specific exemptions |
| 5 | **Usability** | Implementation sessions read §5 and §9 as the contract they must respect and find no implementation-phase guidance that belongs in their own work package | §5 blackbox entries carry interfaces and invariants; zero helper-structure, naming, or test-selection statements |

## 1.3 Stakeholders

| Stakeholder | Interest in this architecture | Evidence |
| --- | --- | --- |
| **End user of OpenCode** | Issues requests and commands to Odin; receives Deliverables; steers at plan and ratification checkpoints in Guided/Interactive modes; is the sole authority for Forget | `agents/odin-autonomous.md:49-57, 280-302`; `skills/memories/odin-memory-system/SKILL.md:43-52` |
| **Framework maintainer** | Edits templates, fragments, and skills in the repository (never generated files), runs generators and `validate.sh`, re-runs `setup.sh` to propagate, keeps README and skills consistent | `scripts/README.md:105-151`; `setup.sh:349-393` |
| **Install-site operator / team** | Runs `setup.sh`, curates optional skills, grants custom capabilities in `custom-capabilities.yaml` — extends in the configuration home, never in the repository | `README.md:100-156, 265-301`; `config-home/custom-capabilities.yaml` |
| **OpenCode (host platform)** | Provides the agent runtime, tool surface (`task`, `skill`, `edit`, `read`, `bash`, …), permission enforcement, and command dispatch that the definitions target | `README.md:98`; `agents/odin-autonomous.md:6-19`; `agents/mimir.md:6-68` |
| **Target project** | The repository in whose working directory a session runs; receives Artifacts — among them the persisted arc42 directory — hosts `.yggdrasil-workspace/` (gitignored) and `.yggdrasil-memory/` (git-tracked) | `agents/odin-autonomous.md:72, 78, 86`; `agents/brokk.md:75, 90` |
| **Future reader of a persisted architecture document** | Finds the target system's stable structure and key decisions, not the record of one task's implementation | §1.1 DOC-1, DOC-8 |
