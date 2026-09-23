# 12. Glossary

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§12](README.md)._

Terms as the doctrine defines them; definitions are quoted or closely paraphrased from the cited source. Rows added by this delta cite the section of this document that defines them.

| Term | Definition | Evidence |
| --- | --- | --- |
| **Orchestration Task** | The complete orchestration process for one user request — from receipt of the prompt to handover of its Deliverable | `agents/odin-autonomous.md:64` |
| **Subtask** | A single-agent dispatch: the unit of work a subagent performs between receiving a brief and returning its output | `agents/odin-autonomous.md:64` |
| **Deliverable** | Whatever ultimately reaches the user: a Response and/or an Artifact | `agents/odin-autonomous.md:72` |
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
| **Communication Policy** | The mode-specific section governing user contact, thresholds, and escalation | `agents/odin-autonomous.md:280-302` |
| **Session reuse** | Resuming a subagent's prior session by `task_id` | `agents/odin-autonomous.md:92-102` |
| **Capability inventory** | The generated skill listing built-in skills by role plus custom-granted tools, loaded once per session by Odin | `agents/odin-autonomous.md:68`; `README.md:122` |
| **Skill** | A `SKILL.md` with frontmatter (`name`, `description`) and five required sections, loadable by the role its prefix names | `scripts/README.md:67-69`; `skills/research/odin-research-workflow/SKILL.md:1-4` |
| **The Pantheon** | Odin plus the five specialists: Mimir (Researcher), Brokk (Implementer), Heimdall (Reviewer), Bragi (Communicator), Kvasir (Strategist) | `agents/odin-autonomous.md:50-56`; `README.md:92` |
| **Mode (architecture document)** | `document-existing` — an as-is record of the system, proposing nothing; `decide-new` — forward-looking decisions for a bounded objective with records at `Status: Proposed` | `skills/architecture/odin-architecture-workflow/SKILL.md:12-15` |
| **Document scope** | `seed` — the target has no architecture document and every in-scope section is written from scratch; `update delta` — one exists and only the sections the objective changes are written | `skills/architecture/kvasir-software-architecture/SKILL.md` § Purpose ("Two document scopes") |
| **Long-term relevant content** | Content that passes the test of §5.2 I-1: it stays true and useful to a reader of the persisted document after the triggering task completes — boundaries, interfaces, decisions with rationale, quality goals, stable mechanisms, risks | §5.2 I-1; ADR-0010 |
| **Task-scoped content** | Content relevant only to the triggering task: run provenance, workspace references, work-package internals, temporary measures, implementation minutiae; excluded from §1–§12 and confined to Appendices B–D and the report | §5.2 I-1 tell-tale list; ADR-0010 |
| **Implementation minutiae** | Internal details of a building block that cross no module boundary — helper structure, local control flow, naming inside a block, test-case selection | `skills/architecture/kvasir-software-architecture/SKILL.md` § Boundaries |
| **Structural footprint** | The modules, entry points, and boundary interfaces an objective reaches or changes; the declared scope of a forward-looking context step | `skills/architecture/odin-architecture-workflow/SKILL.md:92`; `skills/architecture/mimir-architecture-context/SKILL.md:40` |
| **Omission marker (typed)** | One of three fixed strings naming why a section or subsection is empty: scope, evidence, or unaffected by this update | §5.2 I-2; ADR-0011 |
| **Refresh rule** | When a delta re-authors a persisted document it carries forward every durable statement and drops every task-scoped one, listing each drop in the report | §5.2 I-1; ADR-0010 |
| **Carried-forward document** | A topic document of an included section that an update delta neither re-authors nor supersedes; persisted byte-identical and listed in the regenerated index | §5.2 I-5; ADR-0014 |
| **Superseded document** | A previously persisted topic document a later layout map explicitly retires with a `→ superseded — <reason>` row; kept on disk and listed under "Superseded documents" in its section index | §5.2 I-5; ADR-0014; `skills/architecture/brokk-architecture-persistence/SKILL.md:67` |
| **Document-stable reference** | A citation that resolves inside the persisted document or the repository: a repository path, a section number, a decision-record ID, or a requirement ID defined in §1.1 | §5.2 I-3; ADR-0012 |
