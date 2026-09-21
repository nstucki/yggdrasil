# 5.1.1 Blackbox Odin Orchestrator

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Odin is the single primary agent (`mode: primary`). It determines the Deliverable at task start, loads the capability inventory, runs the Kvasir Consultation Check, forms a plan from the orchestration patterns or invokes a packaged workflow, dispatches specialists in dependency order, enforces Subtask Review and the Final Review Gate, classifies failed reviews, and communicates with the user according to its mode's Communication Policy (`agents/odin-autonomous.md:22-44, 104-302`). It never performs specialist work and never reads Workfiles or Artifacts (`agents/odin-autonomous.md:38-40, 81`) — for image Artifacts this means Odin acts on Eitri's `Image:` summary line and Heimdall's verdict, never on the image.

**Provided interfaces.**

- *User entry.* Any prompt to an Odin mode, or a command whose `agent:` names the mode (`commands/yggdrasil/research.md:3`).
- *Recorded verdict lines* (forcing functions, stated before the branch they govern): `Deliverable: …` (`agents/odin-autonomous.md:122`); `Kvasir check: …` (`:160`); `Deliberation check:` / `Research check:` / `Architecture check:` / `Engineering check:` (`:185, 195, 205, 215`). Unchanged by this revision.
- *Agent Selection Guide* — routing doctrine, one row per specialist, role names matching the inventory's sections (`scripts/odin-generator/shared-body.template.md:19-29`). This revision adds the row `| **Eitri** | Designer | Creates and revises image assets from a written brief. | When the Deliverable includes a visual asset — an illustration, diagram, icon, or concept image — at a path the user or plan names. |`. Deeper routing logic (when an image request warrants Eitri versus a textual description) is out of scope (C15).

**Required interfaces.**

- `task` → exactly `bragi`, `brokk`, `eitri`, `heimdall`, `kvasir`, `mimir` (`scripts/odin-generator/preamble.template.md:12-18`, revised: one line `eitri: allow` inserted in alphabetical position); optional `task_id` to resume a prior session (`agents/odin-autonomous.md:94`).
- `skill` → `capability-inventory` and `odin-*` only (`:8-11`); loaded once per session before planning (`:68`).
- `todo` (`:19`). No `read`, `edit`, `bash`, `glob`, or `grep` — Odin has no file access (`:7`).

**Failure and error contract.** Unchanged: a Heimdall verdict line is authoritative; `PASS` or `PASS-WITH-NOTES` passes, `BLOCKED` fails, a missing verdict is re-tasked (`:245-248`). Failed Review Classification (`:267-279`) applies to Eitri sessions exactly as to Brokk and Mimir sessions.

**Invariants callers may rely on.** No Deliverable reaches the user without passing the Final Review Gate (`:258`); the initial gate dispatch is a fresh Heimdall session (`:100`); consultation output (Kvasir, Bragi) receives no dedicated review (`:152, 253`); **every execution-chain Subtask — Mimir, Brokk, Eitri — receives a dedicated review** (`shared-body.template.md:225`, revised); the 15 mode-invariant orchestration markers are validated and none is reworded by this revision (`scripts/validate.sh:598-625`; the revised line 225 keeps the marker `receives a dedicated Heimdall review` intact).

**Quality characteristics.** `temperature: 0.1` (`agents/odin-autonomous.md:5`).

**Fulfilled acceptance criteria.** AC-1 (dispatchability and routing row).

**Open issues.** Guided and Interactive prompts were not read in full in the seed run; their Communication Policy fragments are the only stated difference (`scripts/README.md:11-16`).
