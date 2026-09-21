# 5.1.8 Blackbox Installation Payload

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** `setup.sh` copies the repository's agents, commands, and skills into the OpenCode configuration home, copies the capability generator, seeds a custom-capabilities scaffold once, and generates the capability inventory (`README.md:100-136`; `setup.sh` present at the repository root).

**Provided interface — install layout** (`README.md:108-136`): agents → `~/.config/opencode/agents/yggdrasil/`; commands → `~/.config/opencode/commands/yggdrasil/`; capability generator → `~/.config/opencode/yggdrasil/generate-capabilities.sh`; `custom-capabilities.yaml` → `~/.config/opencode/yggdrasil/` (first install only, never overwritten); mandatory skills → `~/.config/opencode/skills/yggdrasil/{memories,deliberation,research,architecture,engineering}/`; optional skills → `~/.config/opencode/skills/yggdrasil/<agent>/` if accepted; generated inventory → `~/.config/opencode/skills/yggdrasil/shared/capability-inventory/SKILL.md`, regenerated on every install.

**Provided interface — CLI.** Two prompts (copy optional skills, default yes; merge into existing directories, default skip); `-y` skips both; `-c`/`--config-base <path>` or `OPENCODE_CONFIG_BASE` relocates the configuration home, with `~` expansion; merge semantics: same-named Yggdrasil files overwritten, new files added, unrelated files preserved, nothing deleted (`README.md:106, 140-152`).

**Required interfaces.** OpenCode installed with a configuration home (`README.md:98`); `config-home/generate-capabilities.sh` runs against the installed layout, not the repository (`scripts/README.md:164-166`).

**Open issues.** `setup.sh` itself was not read by the context step; its behavior is cited from `README.md` (context Workfile § Unverified Findings item 1 for the inventory generation).
