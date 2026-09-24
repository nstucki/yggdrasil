# 5.1.3 Blackbox Skill Library

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Carries every workflow's doctrine and every specialist's method as `SKILL.md` files, organized by feature domain — `research/`, `architecture/`, `engineering/`, `deliberation/`, `memories/` (mandatory, always installed) — and by optional per-role starter bundles `bragi/`, `brokk/`, `heimdall/`, `kvasir/`, `mimir/` (`README.md:126-136, 154-156`; directory listing of `skills/`). A skill's filename prefix is the role allowed to load it; `odin-*` skills are orchestration doctrine loaded by Odin, all others are loaded by the named specialist (`agents/odin-autonomous.md:8-11`; `agents/mimir.md:63-65`).

**Provided interface — the skill frontmatter and body contract.** Frontmatter `name:` (must equal the directory slug) and `description:` (must not name an agent); body with the five required sections in fixed order — Purpose, When to Use, Workflow, Quality Criteria, Anti-Patterns (`skills/research/odin-research-workflow/SKILL.md:1-4`; `scripts/README.md:67-72`, validator Checks 2, 3, and 6).

**Provided interface — workflow-fixed Deliverable lines.** A workflow skill fixes its own Deliverable as the one-line `Deliverable:` verdict Odin records at the top level; e.g., the Architecture workflow fixes `Deliverable: response=yes, artifact=yes — persisted arc42 directory (absent only when the user declined persistence or a review blocked the run), source=workflow-fixed` (`skills/architecture/odin-architecture-workflow/SKILL.md:18-22`), and the Software Engineering workflow fixes a Deliverable that includes the persisted arc42 directory whenever its architecture stage fired (`skills/engineering/odin-engineering-workflow/SKILL.md:16-19`). No workflow exposes a request line or a result line to another workflow: a workflow used inside a larger plan is loaded and run to completion as a stage, and its Response is folded into the enclosing one (`skills/architecture/odin-architecture-workflow/SKILL.md:29, 59`; `skills/engineering/odin-engineering-workflow/SKILL.md:26, 50-52`). A workflow skill also states its cost model — the Research workflow as `2N + 6 + (R-1)*(2M + 1)` dispatches (`skills/research/odin-research-workflow/SKILL.md:37`), the Architecture workflow as 4, 6, or 2 dispatches (`skills/architecture/odin-architecture-workflow/SKILL.md:81`).

**Contents by domain** (from the directory listing):

| Domain | Odin doctrine | Specialist skills |
| --- | --- | --- |
| research | `odin-research-workflow` | `kvasir-research-decomposition`, `mimir-research-convention`, `heimdall-research-review` |
| architecture | `odin-architecture-workflow` | `mimir-architecture-context`, `kvasir-software-architecture`, `heimdall-architecture-review`, `brokk-architecture-persistence` |
| engineering | `odin-engineering-workflow` | `bragi-business-analysis`, `mimir-engineering-context`, `brokk-test-driven-development`, `heimdall-engineering-review` |
| deliberation | `odin-deliberation-council` | `bragi-council-deliberation-{foundations,systems,adversary,pragmatist,humanist,herald}` |
| memories | `odin-memory-system` | `brokk-memory-curation` |
| optional bundles | — | `bragi/` (3), `brokk/` (4), `heimdall/` (4), `kvasir/` (3), `mimir/` (4) |

**Required interfaces.** The OpenCode `skill` tool; the install step that copies the tree to `~/.config/opencode/skills/yggdrasil/` (`README.md:128-136`); the install-side generator that harvests frontmatter into the `capability-inventory` skill (`scripts/README.md:162-166`).

**Open issues.** `odin-deliberation-council` and the optional bundles are described from `README.md:352-366, 416-433` and their directory listing rather than from full reads (§11 R8).
