# 5.1.1 Blackbox Odin Orchestrator

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Odin is the single primary agent (`mode: primary`). It determines the Deliverable at task start, loads the capability inventory, runs the Kvasir Consultation Check, forms a plan from the orchestration patterns or invokes a packaged workflow, dispatches specialists in dependency order, enforces Subtask Review and the Final Review Gate, classifies failed reviews, and communicates with the user according to its mode's Communication Policy (`agents/odin-autonomous.md:22-44, 104-302`). It never performs specialist work and never reads Workfiles or Artifacts (`agents/odin-autonomous.md:38-40, 81`).

**Provided interfaces.**

- *User entry.* Any prompt to an Odin mode, or a command whose `agent:` names the mode (`commands/yggdrasil/research.md:3`).
- *Recorded verdict lines* (forcing functions, stated before the branch they govern):
  - `Deliverable: response=<yes/no>, artifact=<yes/no — target or none>, source=<workflow-fixed / prompt-explicit / inferred / user-resolved>` (`agents/odin-autonomous.md:122`)
  - `Kvasir check: substantive Subtasks=<n>, criteria=<matched criteria | none> → <consult / skip — reason>` (`:160`); skip requires n=1 plus a one-sentence reason (`:170`)
  - `Deliberation check:` / `Research check:` / `Architecture check:` / `Engineering check:` — each `command=<yes/no>, explicit-request=<yes/no> → <invoke/skip/suggest>` (`:185, 195, 205, 215`)

**Required interfaces.**

- `task` → exactly `bragi`, `brokk`, `heimdall`, `kvasir`, `mimir` (`agents/odin-autonomous.md:12-18`); optional `task_id` to resume a prior session (`:94`).
- `skill` → `capability-inventory` and `odin-*` only (`:8-11`); loaded once per session before planning (`:68`).
- `todo` (`:19`). No `read`, `edit`, `bash`, `glob`, or `grep` — Odin has no file access (`:7`).

**Failure and error contract.** A Heimdall verdict line is authoritative; `PASS` or `PASS-WITH-NOTES` passes, `BLOCKED` fails, a missing verdict is re-tasked rather than inferred (`:245-248`). Failed Review Classification: (1) execution defect → direct fix loop with session reuse; (2) plan-level mismatch → mandatory Kvasir consultation; (3) max three fix rounds per producer session, Kvasir consult after two consecutive failures, third failure → unresolvable blocker; (4) disputed finding → verify (Kvasir or Mimir), one reconsideration; baseline error → correct baseline and reconsider (`:267-279`). Unresolvable blockers end in one of two terminal actions — best-effort delivery with prominent disclosure, or an explicit failure report (`:287-290`).

**Invariants callers may rely on.** No Deliverable reaches the user without passing the Final Review Gate (`:258`); the initial gate dispatch is a fresh Heimdall session (`:100`); consultation output (Kvasir, Bragi) receives no dedicated review and the gate is its backstop (`:152, 253`); mode-invariant orchestration markers are validated (`scripts/README.md:73`).

**Quality characteristics.** `temperature: 0.1` (`agents/odin-autonomous.md:5`).

**Open issues.** Guided and Interactive prompts were not read in full; their Communication Policy fragments are the only stated difference (`scripts/README.md:11-16`; context Workfile § Asked but Unconfirmed item 1).
