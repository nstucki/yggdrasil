# 5.1.3 Blackbox Skill Library

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Carries every workflow's doctrine and every specialist's method as `SKILL.md` files, organized by feature domain — `research/`, `architecture/`, `engineering/`, `deliberation/`, `memories/` (mandatory, always installed) — and by optional per-role starter bundles `bragi/`, `brokk/`, `heimdall/`, `kvasir/`, `mimir/` (`README.md:126-136, 154-156`; directory listing of `skills/`). A skill's filename prefix is the role allowed to load it; `odin-*` skills are orchestration doctrine loaded by Odin, all others are loaded by the named specialist (`agents/odin-autonomous.md:8-11`; `agents/mimir.md:63-65`).

**Provided interface — the skill frontmatter and body contract.** Frontmatter `name:` (must equal the directory slug) and `description:` (must not name an agent); body with the five required sections in fixed order — Purpose, When to Use, Workflow, Quality Criteria, Anti-Patterns (`skills/research/odin-research-workflow/SKILL.md:1-4`; `scripts/README.md:67-72`; context Workfile § Skill Frontmatter Contract).

**Provided interface — workflow return-line grammars.** A workflow skill fixes the one-line contract a composite caller consumes; e.g., the Architecture workflow returns `Architecture result: mode=<…>, source=<…>, workfile=<path>, review=<path> — <PASS | PASS-WITH-NOTES>, section-scope=<…>, package-check=<verdict | n/a>, shape=<…>, scaffold=<path> — <created | verified | extended>, persisted=<path | deferred | declined | not-reached | refused>, gaps=<n>` and on a blocked review `review=<path> — BLOCKED` (`skills/architecture/odin-architecture-workflow/SKILL.md:60, 63`). The Research workflow states its cost as `2N + 6 + (R-1)*(2M + 1)` dispatches (`skills/research/odin-research-workflow/SKILL.md:37`).

**Contents by domain** (from the directory listing):

| Domain | Odin doctrine | Specialist skills |
| --- | --- | --- |
| research | `odin-research-workflow` | `kvasir-research-decomposition`, `mimir-research-convention`, `heimdall-research-review` |
| architecture | `odin-architecture-workflow` | `mimir-architecture-context`, `brokk-arc42-template`, `kvasir-software-architecture`, `heimdall-architecture-review`, `brokk-architecture-persistence` |
| engineering | `odin-engineering-workflow` | `bragi-business-analysis`, `mimir-engineering-context`, `brokk-test-driven-development`, `heimdall-engineering-review` |
| deliberation | `odin-deliberation-council` | `bragi-council-deliberation-{foundations,systems,adversary,pragmatist,humanist,herald}` |
| memories | `odin-memory-system` | `brokk-memory-curation` |
| optional bundles | — | `bragi/` (3), `brokk/` (4), `heimdall/` (4), `kvasir/` (3), `mimir/` (4) |

**Required interfaces.** The OpenCode `skill` tool; the install step that copies the tree to `~/.config/opencode/skills/yggdrasil/` (`README.md:128-136`); the install-side generator that harvests frontmatter into the `capability-inventory` skill (`scripts/README.md:162-166`).

**Open issues.** `odin-engineering-workflow` and `odin-deliberation-council` were not read in full by the context step; their internal steps are cited from `README.md:352-366, 416-433` (context Workfile § Asked but Unconfirmed items 3–4). Optional bundles were not examined beyond their listing (item 2).
