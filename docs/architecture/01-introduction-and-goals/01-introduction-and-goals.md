# 1. Introduction and Goals

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§1](README.md)._

## 1.1 Requirements Overview

This document records, as-is, the architecture of the Yggdrasil orchestration framework — the whole repository rooted at the project directory. Yggdrasil is not an application: it is a configuration layer for OpenCode that installs agent definitions, skills, and commands into the OpenCode configuration directory and encodes an orchestration doctrine — one orchestrator (Odin) delegating to five role-bound specialist subagents, exchanging transient Workfiles, gated by independent review, and backed by a persistent, reviewed knowledge base (`README.md:1-471`; `agents/odin-autonomous.md:22-44`).

**Documented scope.** The entire repository: `agents/` (8 generated agent definitions), `skills/` (10 feature directories of `SKILL.md` files), `commands/yggdrasil/` (7 command definitions), `scripts/` (generators, validator, smoke tests, template sources), `config-home/` (install-side payload), `setup.sh` (installer), `docs/architecture/` (this document's scaffold), and `README.md`. The OpenCode host framework, the internal workflow steps of individual skills beyond their boundary contracts, the install-side generated `capability-inventory` skill, and CI mechanics are out of scope (context Workfile `01-context-architecture-yggdrasil.md`, § Scope).

**Evidence base.** Every claim below cites a repository path taken from the reviewed context Workfile `.yggdrasil-workspace/20260920-doc-arch-x7f2/01-context-architecture-yggdrasil.md` (review verdict PASS-WITH-NOTES) or from a direct spot-check read performed while drafting: `agents/odin-autonomous.md` (full), `agents/brokk.md` (full), `scripts/README.md` (full), `scripts/generate-subagents.sh:1-145`, `README.md:90-179`, `docs/architecture/README.md`, and directory listings of `agents/`, `skills/**`, `commands/yggdrasil/`, `scripts/**`, `config-home/`. Two line citations in the context Workfile were approximate (`agents/odin-autonomous.md:200+` and `:150+`); the exact lines are `agents/odin-autonomous.md:267` (Failed Review Classification) and `:156` (Kvasir Consultation Check), and those are used here. There is no requirements Workfile and there are no acceptance criteria: the quality goals in §1.2 are inferred and marked as such.

**Functional overview — what the system does today** (each a documented capability, not a requirement):

| Capability | Evidence |
| --- | --- |
| Accepts a natural-language request or a `/yggdrasil/<command>` in one of three Odin modes and orchestrates specialist dispatches to produce a Deliverable (Response and/or Artifact) | `agents/odin-autonomous.md:30-34, 70-72`; `commands/yggdrasil/research.md:1-13` |
| Runs four packaged multi-specialist workflows — Research, Architecture, Software Engineering, Deliberation Council — invoked whole on a trigger verdict | `agents/odin-autonomous.md:172-219`; `skills/research/odin-research-workflow/SKILL.md:1-53`; `skills/architecture/odin-architecture-workflow/SKILL.md:1-184` |
| Enforces independent review of every Mimir/Brokk Subtask and a Final Review Gate on every Deliverable | `agents/odin-autonomous.md:237-265` |
| Maintains a persistent, source-cited knowledge base through three command-triggered pipelines (Remember, Dream, Forget) | `agents/odin-autonomous.md:84-90`; `skills/memories/odin-memory-system/SKILL.md:24-61` |
| Regenerates all agent definitions from templates and validates structural parity | `scripts/README.md:5-103`; `scripts/generate-subagents.sh:103-121` |
| Installs itself into an OpenCode configuration home and generates a capability inventory there | `README.md:100-136`; `scripts/README.md:162-166` |

## 1.2 Quality Goals

All five goals are **inferred** from what the structure, permission blocks, validators, and doctrine text are visibly optimized for. Derivation basis: each goal is named only where at least two independent mechanisms in the repository enforce it. Ranking reflects how much of the doctrine text and permission machinery is devoted to each.

| Rank | Quality goal | What it means here | Inferred from |
| --- | --- | --- | --- |
| 1 | **Independent verification** | No output reaches the user, the project, or Memory without a review by a reviewer that did not produce it, verified against ground truth rather than self-report | `agents/odin-autonomous.md:237-265` (Review Mechanics, Subtask Review, Final Review Gate); `agents/odin-autonomous.md:40` and `agents/brokk.md:88` (no self-review); `skills/memories/odin-memory-system/SKILL.md:57`; `skills/architecture/odin-architecture-workflow/SKILL.md:160` |
| 2 | **Role isolation and least privilege** | Each agent may do only what its role needs; boundaries are enforced by tool-permission blocks, skill-prefix allowlists, and a validator that forbids cross-agent references | `agents/odin-autonomous.md:6-19` (Odin: only `skill`, `task`, `todo`); `agents/mimir.md:6-68`; `agents/brokk.md:6-64`; `scripts/README.md:71` (Check 5, subagent isolation) |
| 3 | **Reproducibility of the definitions** | Agent files are derived artifacts; the committed state must be byte-identical to generator output | `scripts/README.md:70, 87-95, 105-107, 153-160`; `scripts/generate-subagents.sh:103-121` |
| 4 | **Traceability of claims** | Research, reviews, and Memories cite paths and lines; Memories carry a mandatory `sources` field and a confidence/status lifecycle | `skills/memories/brokk-memory-curation/SKILL.md:91-110`; `agents/odin-autonomous.md:246`; `agents/brokk.md:111-113` |
| 5 | **Extensibility at the install site** | Skills and custom tool grants are added in the installed configuration home without modifying the repository; the capability inventory is regenerated there | `README.md:106, 118, 122, 156`; `config-home/generate-capabilities.sh`; `config-home/custom-capabilities.yaml`; `scripts/README.md:162-166` |

## 1.3 Stakeholders

| Stakeholder | Interest in this architecture | Evidence |
| --- | --- | --- |
| **End user of OpenCode** | Issues requests and commands to Odin; receives Deliverables; steers at plan and ratification checkpoints in Guided/Interactive modes; is the sole authority for Forget | `agents/odin-autonomous.md:49-57, 280-302`; `skills/memories/odin-memory-system/SKILL.md:43-52` |
| **Framework maintainer** | Edits templates and fragments (never generated files), runs generators and `validate.sh`, keeps README and skills consistent | `scripts/README.md:105-151` |
| **Install-site operator / team** | Runs `setup.sh`, curates optional skills, grants custom capabilities in `custom-capabilities.yaml` | `README.md:100-156`; `config-home/custom-capabilities.yaml` |
| **OpenCode (host platform)** | Provides the agent runtime, tool surface (`task`, `skill`, `edit`, `read`, `bash`, …), permission enforcement, and command dispatch that the definitions target | `README.md:98`; `agents/odin-autonomous.md:6-19`; `agents/mimir.md:6-68` |
| **Target project** | The repository in whose working directory a session runs; receives Artifacts, hosts `.yggdrasil-workspace/` (gitignored) and `.yggdrasil-memory/` (git-tracked) | `agents/odin-autonomous.md:72, 78, 86`; `agents/brokk.md:75, 90` |
