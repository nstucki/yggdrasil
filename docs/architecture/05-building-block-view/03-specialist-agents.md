# 5.1.2 Blackbox Specialist Agents

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Five subagents (`mode: subagent`), each with one role, one skill prefix, and one permission profile. Each receives a brief from Odin, loads a matching skill, executes, and returns an executive summary plus Workfile or Artifact paths. None communicates with the user, none reviews its own output, and none may task another agent (`agents/brokk.md:84-91`; context Workfile § Boundary Interfaces, "Provided/Required surfaces").

| Agent | Role | Writes | Reads | Skill prefix | Permission evidence |
| --- | --- | --- | --- | --- | --- |
| **Mimir** | Researcher — research, codebase and context analysis | Workfiles (`.yggdrasil-workspace/**/*.md`) | Codebase, web (`webfetch`, `websearch`), Workfiles | `mimir-*` | `agents/mimir.md:6-68` (inspection-only `bash`, test runners allowed, release scripts denied) |
| **Brokk** | Implementer — Artifacts and Memory curation | Project files (`edit` everywhere except `.yggdrasil-workspace/**`), Memory only when dispatched for curation | Workfiles as inputs only | `brokk-*` | `agents/brokk.md:6-64` (broad `bash`; `git commit --amend`, `stash drop/clear`, chained git denied) |
| **Heimdall** | Reviewer — independent validation against ground truth | Review Workfiles `NN-review-<topic>.md` | Workfiles, Artifacts, project files | `heimdall-*` | `agents/heimdall.md:6-72` (context Workfile) |
| **Bragi** | Communicator — framing, drafting, deliberation lenses, business analysis | Communication Workfiles (e.g., `NN-response-draft.md`) | Workfiles | `bragi-*` | `agents/bragi.md:6-18` (context Workfile) |
| **Kvasir** | Strategist — planning, decomposition, architecture drafting | Planning Workfiles | Workfiles, codebase | `kvasir-*` | `agents/kvasir.md:6-56` (context Workfile) |

**Provided interface — the dispatch contract.** Input: a brief authored by Odin naming the task directory once, the Workfile filenames to read and write, and any task-brief constraints, which narrow the specialist's standing responsibilities ("when the brief restricts your default outputs, the brief wins" — `agents/brokk.md:95`). Output: an executive summary in the return message plus paths; Odin acts on the summary, never on the file (`agents/odin-autonomous.md:80-81`). Review dispatches additionally receive the complete output paths and the exact originating brief text (`agents/odin-autonomous.md:254`).

**Provided interface — the agent frontmatter contract.** `name`, `description`, `mode: subagent`, `temperature`, and a `permission:` block beginning `"*": deny` with per-tool allows; `edit` and `bash` use glob patterns; `skill` allows only the role prefix (`agents/mimir.md:1-69` quoted verbatim in the context Workfile; `agents/brokk.md:1-65`).

**Required interfaces.** OpenCode tools as allowed per row above; the Yggdrasil Workspace and Memory sections that every subagent carries (`agents/brokk.md:97-113`), including the Memory trust rules — skip `superseded`, treat `stale`/`low` as hypotheses, verify against the cited live source, report contradictions (`agents/brokk.md:110-113`).

**Failure contract.** A specialist reports gaps rather than filling them (`agents/brokk.md:95`); Heimdall returns a verdict line `PASS | PASS-WITH-NOTES | BLOCKED` (`agents/odin-autonomous.md:248`); Brokk's standing duty before any commit is to verify the target `.gitignore` covers the workspace (`agents/brokk.md:90`).

**Quality characteristics.** Temperatures: Mimir 0.3, Brokk 0.2 (`agents/mimir.md:5` via context Workfile; `agents/brokk.md:5`).

**Open issues.** Heimdall, Bragi, and Kvasir permission blocks were sampled, not quoted, in the context Workfile (§ Asked but Unconfirmed item 5).
