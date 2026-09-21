# 5.1.2 Blackbox Specialist Agents

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Six subagents (`mode: subagent`), each with one role, one skill prefix, and one permission profile. Each receives a brief from Odin, loads a matching skill when one exists, executes, and returns an executive summary plus Workfile or Artifact paths. None communicates with the user, none reviews its own output, and none may task another agent (`agents/brokk.md:84-91`; context Workfile § Boundary Interfaces).

| Agent | Role | Writes | Reads | Skill prefix | Permission evidence |
| --- | --- | --- | --- | --- | --- |
| **Mimir** | Researcher — research, codebase and context analysis | Workfiles (`.yggdrasil-workspace/**/*.md`) | Codebase, web (`webfetch`, `websearch`), Workfiles | `mimir-*` | `agents/mimir.md:6-68` (inspection-only `bash`, test runners allowed, release scripts denied) |
| **Brokk** | Implementer — Artifacts and Memory curation | Project files (`edit` everywhere except `.yggdrasil-workspace/**`), Memory only when dispatched for curation | Workfiles as inputs only | `brokk-*` | `agents/brokk.md:6-64` (broad `bash`; `git commit --amend`, `stash drop/clear`, chained git denied) |
| **Heimdall** | Reviewer — independent validation against ground truth | Review Workfiles `NN-review-<topic>.md` | Workfiles, Artifacts (including image files via `read`), project files | `heimdall-*` | `agents/heimdall.md:6-72`; `scripts/subagent-generator/heimdall.template.md:1-30` (inspection-only `bash`) |
| **Bragi** | Communicator — framing, drafting, deliberation lenses, business analysis | Communication Workfiles (e.g., `NN-response-draft.md`) | Workfiles | `bragi-*` | `scripts/subagent-generator/bragi.template.md:6-18` (no `bash`; `edit` workspace markdown only; `glob`, `grep`, `read`) |
| **Kvasir** | Strategist — planning, decomposition, architecture drafting | Planning Workfiles | Workfiles, codebase | `kvasir-*` | `agents/kvasir.md:6-56` |
| **Eitri** | Designer — image generation: illustrations, diagrams, icons, visual concepts from a written brief | **Image Artifacts** (`edit` on `**/*.svg`, `**/*.png`, `**/*.jpg`, `**/*.jpeg`, `**/*.webp`, `**/*.gif` at brief-named paths; `.yggdrasil-memory/**` denied) and **image manifest Workfiles** `NN-image-<topic>.md` | Workfiles; project reference assets, style guides, and design tokens (`read`, `glob`, `grep`) | `eitri-*` | `scripts/subagent-generator/eitri.template.md` (new — frontmatter fixed below; ADR-0010) |

**Provided interface — the dispatch contract.** Input: a brief authored by Odin naming the task directory once, the Workfile filenames to read and write, and any task-brief constraints, which narrow the specialist's standing responsibilities ("when the brief restricts your default outputs, the brief wins" — `agents/brokk.md:95`). Output: an executive summary in the return message plus paths; Odin acts on the summary, never on the file (`agents/odin-autonomous.md:80-81`). Review dispatches additionally receive the complete output paths and the exact originating brief text (`agents/odin-autonomous.md:254`).

**Provided interface — the image brief / image manifest contract (Eitri; new).** A failing test can be written against each clause without opening Eitri's prompt.

*Image brief (input, carried in Odin's brief text).* Required fields: `asset path` (relative to the session working directory; one per requested image), `format` (one of `svg | png | jpg | webp | gif`), `subject` (what to depict), and the manifest Workfile name (`NN-image-<topic>.md`). Optional fields: `dimensions` (`<w>x<h>` px for raster, or a viewBox for SVG), `style`, `palette / design tokens` (values or a project path to read them from), `reference assets` (project paths), `constraints` (text, licensing, accessibility such as `<title>`/`<desc>` in SVG), `revision of` (a prior asset path). A brief missing `asset path`, `format`, or `subject` is answered with `Image: blocked — brief incomplete: <missing fields>` and no file is written (AC-1).

*Image Artifact (output).* Exactly the file(s) at the brief's `asset path`(s), in the brief's `format`. When `format` is `svg`, Eitri authors the file directly with `edit`; when `format` is raster (`png | jpg | webp | gif`) and no raster-capable tool has been granted post-install (C15, C16), Eitri writes no raster file and reports `Image: blocked — raster output requires a granted image tool; SVG offered: <yes/no per brief>` (AC-2).

*Image manifest Workfile (output, markdown, in the task directory).* Title `# Image Manifest — <topic>`, then one table per asset with exactly these rows, in this order: `Asset` (relative path), `Format`, `Dimensions` (`<w>x<h> px` or `viewBox <minx> <miny> <w> <h>`), `Model` (the model identifier as known to the session, or the literal `unknown`), `Generation parameters` (prompt as used, style, seed or `n/a`), `Revision` (integer, `1` for a first version), `Brief compliance` (one line per brief constraint: `met | partially met — <why> | not met — <why>`), `Open gaps`. A manifest is written for blocked outcomes too, with `Asset` set to the intended path and a `Status: blocked — <reason>` line above the table (AC-2, AC-3).

*Return message (output).* First line, fixed grammar: `Image: asset=<path>, format=<fmt>, dimensions=<d>, model=<id|unknown>, manifest=<workfile>` — or `Image: blocked — <reason>, manifest=<workfile>`. Then at most five lines of executive summary. Odin and Heimdall act on this line (AC-3).

*Invariants callers may rely on.* Eitri never writes outside the `edit` globs of ADR-0010 (host-enforced); never writes a Workfile that is not markdown; never creates or modifies a Memory entry — no `*.md` allow reaches `.yggdrasil-memory/` (by construction, as for every markdown-writing peer; the prose boundary additionally forbids any write there — ADR-0010 amendment); never invents an asset path — a path absent from the brief is a gap reported, not chosen; never names another agent (C6, validator Check 5).

**Provided interface — the agent frontmatter contract.** `name`, `description`, `mode: subagent`, `temperature`, and a `permission:` block beginning `"*": deny` with per-tool allows; `edit` and `bash` use glob patterns; `skill` allows only the role prefix (`agents/mimir.md:1-69`; `agents/brokk.md:1-65`). Eitri carries **no additional key**: the `model:` field ADR-0009 originally placed here was withdrawn by user direction after implementation (ADR-0009 amendment; R21) — model selection is install-site only. The frontmatter as shipped (`scripts/subagent-generator/eitri.template.md:1-25`, live after commits `e166fe5`, `793a5ca`, `755d6bb`) is:

```yaml
---
name: eitri
description: Creates and revises image assets — illustrations, diagrams, icons, and visual concepts — from a written brief.
mode: subagent
temperature: 0.7
permission:
  "*": deny
  edit:
    "*": deny
    ".yggdrasil-workspace/**/*.md": allow
    "**/.yggdrasil-workspace/**/*.md": allow
    "**/*.svg": allow
    "**/*.png": allow
    "**/*.jpg": allow
    "**/*.jpeg": allow
    "**/*.webp": allow
    "**/*.gif": allow
  glob: allow
  grep: allow
  read: allow
  skill:
    "*": deny
    "eitri-*": allow
  todo: allow
---
```

The body sections follow the Bragi template's shape exactly (`scripts/subagent-generator/bragi.template.md:21-46`): `# Eitri — Designer`, `## Role`, `## Responsibilities`, `## Boundaries`, `## Role Discipline`; then the generator appends `workspace.fragment.md`, `tooling.fragment.md` (Eitri is a Workfile author), `memory.fragment.md`, and `eitri.workflow.template.md` (`## Workflow`: receive brief → read references → author asset(s) → write manifest → report `Image:` line). Boundaries state: no file outside the image globs and workspace markdown; no implementation, research, review, or user contact; Memory read-only; raster output only through a granted tool. Description phrasing is role-phrased and nameless so the inventory can harvest it (`config-home/generate-capabilities.sh:245-270`). Prose must not contain the names Odin, Mimir, Brokk, Heimdall, Kvasir, or Bragi (`scripts/validate.sh:450-451` after WP-1 adds `eitri`).

**Required interfaces.** OpenCode tools as allowed per row above; the Yggdrasil Workspace and Memory sections that every subagent carries (`agents/brokk.md:97-113`), including the Memory trust rules. Eitri additionally requires OpenCode to honor the `model:` field (ADR-0009 open question) and, for raster output, a post-install tool grant registered per `README.md:310-340`.

**Failure contract.** A specialist reports gaps rather than filling them (`agents/brokk.md:95`); Heimdall returns a verdict line `PASS | PASS-WITH-NOTES | BLOCKED` (`agents/odin-autonomous.md:248`); Brokk's standing duty before any commit is to verify the target `.gitignore` covers the workspace (`agents/brokk.md:90`); Eitri's blocked outcomes are the two `Image: blocked` forms above plus a host permission denial, which Eitri reports verbatim with the denied path.

**Quality characteristics.** Temperatures: Mimir 0.3, Brokk 0.2, Heimdall 0.1, Bragi 0.5, Kvasir 0.4 (`agents/*.md:5`), Eitri 0.7 (requirements Workfile § Open Questions item 2 default; a value, not a mechanism — Appendix A item 3).

**Fulfilled acceptance criteria.** AC-2, AC-3, AC-4, AC-5, AC-6, AC-7 (field present and honored), plus the manifest half of AC-1.

**Open issues.** Whether OpenCode's `read` tool returns image content to Heimdall for visual inspection is assumed from host behavior, not evidenced in the repository; visual-fitness review criteria are deferred (requirements § Deferred item 2).
