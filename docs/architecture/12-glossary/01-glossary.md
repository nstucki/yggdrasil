# 12. Glossary

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§12](README.md)._

Terms as the doctrine defines them; definitions are quoted or closely paraphrased from the cited source. Rows that define a term of this document cite the section that defines it.

| Term | Definition | Evidence |
| --- | --- | --- |
| **Orchestration Task** | The complete orchestration process for one user request — from receipt of the prompt to handover of its Deliverable | `agents/odin-autonomous.md:64` |
| **Subtask** | A single-agent dispatch: the unit of work a subagent performs between receiving a brief and returning its output | `agents/odin-autonomous.md:64` |
| **Deliverable** | Whatever ultimately reaches the user: a Response and/or an Artifact; a packaged workflow fixes its own in a `Deliverable:` line | `agents/odin-autonomous.md:72`; `skills/architecture/odin-architecture-workflow/SKILL.md:18-22` |
| **Response** | The direct answer carried in Odin's final message to the user | `agents/odin-autonomous.md:72` |
| **Artifact** | A file, outside Yggdrasil Workspace and Yggdrasil Memory, that the task's implementation work creates or changes | `agents/brokk.md:75` |
| **Workfile** | A transient, gitignored markdown file specialists exchange during the task in the Yggdrasil Workspace; never itself the Deliverable unless promoted | `agents/odin-autonomous.md:76` |
| **Yggdrasil Workspace** | `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`, rooted at the session working directory | `agents/odin-autonomous.md:78` |
| **Memory** | A distilled, source-cited entry (markdown + YAML frontmatter) in Yggdrasil Memory | `agents/odin-autonomous.md:86` |
| **Yggdrasil Memory** | The persistent knowledge base at `.yggdrasil-memory/`, with an `INDEX.md` manifest, modified only by the Remember/Dream/Forget pipelines | `agents/odin-autonomous.md:86` |
| **Remember / Dream / Forget** | Command-triggered pipelines for Memory promotion, consolidation, and deletion | `agents/odin-autonomous.md:88` |
| **Recall** | Consultation of Memories as leads, not ground truth | `agents/odin-autonomous.md:90` |
| **Brief** | The exact text Odin passes to a Subtask at dispatch, including Artifact or Workfile references; retained for review dispatch | `agents/odin-autonomous.md:254` |
| **Promotion** | Transformation of Workfile content into a Response, an Artifact, or both | `agents/odin-autonomous.md:82` |
| **Review verdict** | `PASS`, `PASS-WITH-NOTES` (both pass), or `BLOCKED` (failed) | `agents/odin-autonomous.md:248` |
| **Final Review Gate** | Heimdall's validation of the complete assembled Deliverable against the user's original request; mandatory before delivery | `agents/odin-autonomous.md:256-265` |
| **Failed Review Classification** | The four-way rule for acting on a `BLOCKED` verdict | `agents/odin-autonomous.md:267-279` |
| **Consultation Layer** | The advisory layer (Kvasir strategy, Bragi framing) orthogonal to the execution graph; receives no independent review | `agents/odin-autonomous.md:150-154` |
| **Kvasir Consultation Check** | The recorded verdict deciding whether Kvasir is consulted before execution | `agents/odin-autonomous.md:156-170` |
| **Packaged workflow** | A trigger-gated, multi-dispatch pattern invoked whole via an `odin-*` skill: Research, Architecture, Software Engineering, Deliberation Council | `agents/odin-autonomous.md:172-219` |
| **Stage (of a workflow)** | A packaged workflow run to completion — with its own gates and checkpoint — as one step of an enclosing workflow, its Response folded into the enclosing one; no request or result line passes between them | §8.5; `skills/architecture/odin-architecture-workflow/SKILL.md:29`; `skills/engineering/odin-engineering-workflow/SKILL.md:26` |
| **Communication Policy** | The mode-specific section governing user contact, thresholds, and escalation | `agents/odin-autonomous.md:280-302` |
| **Session reuse** | Resuming a subagent's prior session by `task_id` | `agents/odin-autonomous.md:92-102` |
| **Capability inventory** | The generated skill listing built-in skills by role plus custom-granted tools, loaded once per session by Odin | `agents/odin-autonomous.md:68`; `README.md:122` |
| **Skill** | A `SKILL.md` with frontmatter (`name`, `description`) and five required sections, loadable by the role its prefix names | `scripts/README.md:67-69`; `skills/research/odin-research-workflow/SKILL.md:1-4` |
| **The Pantheon** | Odin plus the five specialists: Mimir (Researcher), Brokk (Implementer), Heimdall (Reviewer), Bragi (Communicator), Kvasir (Strategist) | `agents/odin-autonomous.md:50-56`; `README.md:92` |
| **Document scope** | `seed` — no folder layout exists at the target and every in-scope section is written from scratch; `update delta` — one exists and only the sections the objective changes are written, merged document-by-document. Derived by the drafter from the identity rule, never chosen | §5.2 I-7; `skills/architecture/kvasir-software-architecture/SKILL.md` § Purpose |
| **Identity rule** | The folder layout exists if and only if `README.md` and `01-introduction-and-goals/README.md` are both present at the target | §5.2 I-7; `skills/architecture/heimdall-architecture-review/SKILL.md:88` |
| **Two-fact target check** | The drafter's only filesystem derivation about the target: the identity rule and the highest decision-record number in use | §5.2 I-7; `skills/architecture/kvasir-software-architecture/SKILL.md` § Workflow step 1 |
| **Ratification record** | The one-line `Ratification: ratified=<…>, withheld=<…>, by=<user \| adoption>` grammar the persistence skill defines and the orchestrator writes at the checkpoint | `skills/architecture/brokk-architecture-persistence/SKILL.md:105`; `skills/architecture/odin-architecture-workflow/SKILL.md:49-51` |
| **Persistence manifest** | The persistence session's return: the actions taken per path, in the vocabulary `created`, `replaced`, `regenerated`, `index regenerated`, `appended <n> rows`, `superseded (kept)`, `carried forward`, `untouched` | `skills/architecture/heimdall-architecture-review/SKILL.md:95` |
| **Long-term relevant content** | Content that passes the test of §5.2 I-1: it stays true and useful to a reader of the persisted document after the triggering task completes — boundaries, interfaces, decisions with rationale, quality goals, stable mechanisms, risks | §5.2 I-1; ADR-0010 |
| **Task-scoped content** | Content relevant only to the triggering task: run provenance, workspace references, work-package internals, temporary measures, implementation minutiae; excluded from §1–§12 and confined to Appendix B and the report | §5.2 I-1 tell-tale list; ADR-0010 |
| **Implementation minutiae** | Internal details of a building block that cross no module boundary — helper structure, local control flow, naming inside a block, test-case selection | `skills/architecture/kvasir-software-architecture/SKILL.md` § Boundaries |
| **Structural footprint** | The modules, entry points, and boundary interfaces an objective reaches or changes; the declared scope of a context step briefed for a change | `skills/architecture/odin-architecture-workflow/SKILL.md:39`; `skills/architecture/mimir-architecture-context/SKILL.md:25` |
| **Omission marker (typed)** | One of three fixed strings naming why a section or subsection is empty: scope, evidence, or unaffected by this update | §5.2 I-2; ADR-0011 |
| **Refresh rule** | When a delta re-authors a persisted document it carries forward every durable statement and drops every task-scoped one | §5.2 I-1; ADR-0010 |
| **Carried-forward document** | A topic document of an included section that an update delta neither re-authors nor supersedes; persisted byte-identical and listed in the regenerated index at its existing ordinal | §5.2 I-5; ADR-0014 |
| **Superseded document** | A previously persisted topic document a later layout map explicitly retires with a `→ superseded — <reason>` row; kept on disk and listed under "Superseded documents" in its section index | §5.2 I-5; ADR-0014; `skills/architecture/brokk-architecture-persistence/SKILL.md:80` |
| **Document-stable reference** | A citation that resolves inside the persisted document or the repository: a repository path, a section number, a decision-record ID, or a requirement ID defined in §1.1 | §5.2 I-3; ADR-0012 |
