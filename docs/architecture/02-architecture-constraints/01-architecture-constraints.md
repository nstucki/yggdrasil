# 2. Architecture Constraints

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§2](README.md)._

Constraints the system is built under today, each evidenced. None of them is a choice this document weighs; they are the fixed frame.

| # | Constraint | Kind | Evidence |
| --- | --- | --- | --- |
| C1 | **OpenCode is the only runtime.** Yggdrasil has no executable of its own; every behavior is a system prompt, a skill, or a command interpreted by OpenCode, and installation requires `~/.config/opencode/` | Technical | `README.md:98`; `README.md:108-136`; context Workfile § Dependencies |
| C2 | **Pure Markdown / YAML / Bash.** No compiled code and no package manager; generators are `cat` and `sed` concatenation | Technical | `scripts/README.md:153-160`; context Workfile § Dependencies ("No external package dependencies found") |
| C3 | **Authorization is the agent frontmatter permission block.** The framework has no authentication of its own; every capability boundary is expressed as OpenCode `permission:` rules (`"*": deny` then explicit allows) | Technical / security | `agents/odin-autonomous.md:6-19`; `agents/mimir.md:6-68`; `agents/brokk.md:6-64` |
| C4 | **All files under `agents/` are generated and never edited directly.** Validator Check 4 fails on any byte difference from generator output | Organizational | `scripts/README.md:70, 105-107` |
| C5 | **Skills must carry the five required sections in fixed order and a `name:` matching their directory slug**; skill descriptions may not name agents | Convention (validated) | `scripts/README.md:67-72` (Checks 1–3, 6) |
| C6 | **Subagent prompts and skills may not reference other agents by name** (subagent isolation) | Convention (validated) | `scripts/README.md:71` (Check 5) |
| C7 | **Workfiles live only under `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`, rooted at the session working directory, gitignored, referenced by relative paths** | Convention | `agents/odin-autonomous.md:78-80`; `agents/brokk.md:90` |
| C8 | **Workfiles are created and extended with the `edit` tool; the `write` tool is not used** because it is documented to hang in this environment | Environmental (asserted in prompts, unverified by execution) | `agents/bragi.md:59-63`; context Workfile § Unverified Findings item 3 |
| C9 | **Yggdrasil Memory is written only by the Remember/Dream/Forget pipelines**, never as an Artifact, never containing secrets | Governance | `agents/odin-autonomous.md:86-88`; `skills/memories/odin-memory-system/SKILL.md:31, 57-61` |
| C10 | **The architecture document lives at `docs/architecture/` in arc42 directory shape**, scaffolded index-only at the time of writing | Documentation | `docs/architecture/README.md:1-31` |
