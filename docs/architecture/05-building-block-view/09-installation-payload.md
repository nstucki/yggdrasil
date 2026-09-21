# 5.1.8 Blackbox Installation Payload

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** `setup.sh` copies the repository's agents, commands, and skills into the OpenCode configuration home, copies the capability generator, seeds a custom-capabilities scaffold once, and generates the capability inventory (`README.md:99-141`; `setup.sh:150-156, 339-348`). Agents are copied as a directory, so `agents/eitri.md` is installed without any installer change (`setup.sh:150, 156`; `scripts/ci-smoke-generator.sh:43` shows the same wholesale copy).

**Provided interface — install layout** (`README.md:113-141`): agents → `~/.config/opencode/agents/yggdrasil/`; commands → `~/.config/opencode/commands/yggdrasil/`; capability generator → `~/.config/opencode/yggdrasil/generate-capabilities.sh`; `custom-capabilities.yaml` → `~/.config/opencode/yggdrasil/` (first install only, never overwritten); mandatory skills → `~/.config/opencode/skills/yggdrasil/{memories,deliberation,research,architecture,engineering}/`; optional skills → `~/.config/opencode/skills/yggdrasil/<agent>/` if accepted; generated inventory → `~/.config/opencode/skills/yggdrasil/shared/capability-inventory/SKILL.md`, regenerated on every install. **Upgrade semantics matter for ADR-0009:** same-named Yggdrasil files are overwritten on upgrade (`README.md:111`), so an edit to the installed `eitri.md` is volatile; `opencode.json` is never touched by `setup.sh` and is therefore the durable override site.

**Provided interface — capability inventory role vocabulary** (`config-home/generate-capabilities.sh`, revised): skill-prefix → role map `mimir→researcher`, `brokk→implementer`, `heimdall→reviewer`, `kvasir→strategist`, `bragi→communicator`, **`eitri→designer`** (`:180-189`); per-role skill accumulators including `designer_skills` (`:146-150, 201-242`); Step 1.5 harvests each role's description from the agent file's `description:` — the loop and `case` include `eitri → designer_desc` (`:256-270`); the render emits `### Designer` after `### Communicator`, with the description and `(none)` when no `eitri-*` skill is installed (`:323-433`). The `custom-capabilities.yaml` schema comment lists `designer` among the `role:` values (`config-home/custom-capabilities.yaml:15`; `README.md:329`). The custom-capabilities parser (`:272-321`) is unchanged — a `role: designer` entry is carried through as text.

**Provided interface — CLI.** Two prompts (copy optional skills, default yes; merge into existing directories, default skip); `-y` skips both; `-c`/`--config-base <path>` or `OPENCODE_CONFIG_BASE` relocates the configuration home (`README.md:111, 145-157`).

**Required interfaces.** OpenCode installed with a configuration home (`README.md:103`); `config-home/generate-capabilities.sh` runs against the installed layout, not the repository (`scripts/README.md:164-166`).

**Fulfilled acceptance criteria.** AC-11 (derived).

**Open issues.** `setup.sh` lines 157–338 were sampled, not read in full; the wholesale copy of `agents/` is evidenced by `setup.sh:150, 156, 339-348` and the smoke test's identical layout.
