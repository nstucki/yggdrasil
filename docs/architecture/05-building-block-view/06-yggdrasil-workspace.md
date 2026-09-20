# 5.1.5 Blackbox Yggdrasil Workspace

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** The transient exchange medium between specialists within one Orchestration Task. Workfiles are never the Deliverable; content reaches the user only by promotion into a Response or an Artifact (`agents/odin-autonomous.md:72, 76, 82`).

**Provided interface — the Workfile contract.**

- Directory `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`, rooted at the session working directory, never a global or home location; `<xx>` is a 2–4 character collision suffix Odin invents at task start; the directory is gitignored and never committed (`agents/odin-autonomous.md:78`).
- Filenames sequenced and self-describing: `01-research-<topic>.md`, `02-plan.md`, `NN-review-<topic>.md`, `NN-response-draft.md` (`:79`; context Workfile § Workfile Convention).
- Paths always relative (`:80`).
- Writers: Mimir, Kvasir, Heimdall, Bragi (`edit` allowed on `.yggdrasil-workspace/**/*.md`); reader-only: Brokk (`edit` denied on `.yggdrasil-workspace/**`); no access: Odin (`agents/mimir.md:55-58`; `agents/brokk.md:53-56`; `agents/odin-autonomous.md:7`).
- Tooling: created and extended with `edit`, built incrementally; `write` is not used (`agents/bragi.md:59-63`).

**Required interfaces.** OpenCode `edit`/`read` tools; the target project's `.gitignore` (Brokk adds the entry if missing — `agents/brokk.md:90`).

**Invariants.** Odin never reads a Workfile — it acts on executive summaries and routes paths (`agents/odin-autonomous.md:81`); after an interruption Odin re-derives state from the Workspace and the project, never assuming prior progress (`:102`).
