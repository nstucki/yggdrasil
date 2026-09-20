# 5.1 Whitebox Overall System

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

The system decomposes along what OpenCode loads and what the repository ships: agent definitions (the orchestrator and the specialists), the skill library that carries workflow doctrine and specialist methods, the command definitions that route users into Odin, the two runtime stores in the target project, and the repository-side toolchain that generates, validates, and installs all of it. The decomposition motivation is the pair of goals 2 and 3: each block has exactly one kind of file, one owner role, and one enforcement mechanism (permission block, validator check, or installer rule).

```mermaid
flowchart TB
    subgraph Defs["Agent definitions — agents/ (generated)"]
        Odin["5.1.1 Odin Orchestrator<br/>odin-autonomous | odin-guided | odin-interactive"]
        Spec["5.1.2 Specialist Agents<br/>mimir · brokk · heimdall · bragi · kvasir"]
    end
    subgraph Lib["5.1.3 Skill Library — skills/"]
        WF["odin-* workflow skills"]
        SK["role-prefixed specialist skills"]
    end
    Cmd["5.1.4 Command Definitions<br/>commands/yggdrasil/"]
    subgraph Stores["Runtime stores — target project"]
        WS["5.1.5 Yggdrasil Workspace<br/>.yggdrasil-workspace/"]
        Mem["5.1.6 Yggdrasil Memory<br/>.yggdrasil-memory/"]
    end
    subgraph Tool["Repository toolchain"]
        Gen["5.1.7 Generator and Validation Toolchain<br/>scripts/"]
        Inst["5.1.8 Installation Payload<br/>setup.sh · config-home/"]
    end

    Cmd -- "agent: Odin (mode) + skill-load directive" --> Odin
    Odin -- "task dispatch (brief)" --> Spec
    Odin -- "skill: capability-inventory, odin-*" --> WF
    Spec -- "skill: <role>-*" --> SK
    Spec -- "edit (Mimir, Kvasir, Heimdall, Bragi)" --> WS
    Spec -- "read (all, incl. Brokk)" --> WS
    Spec -- "reviewed writes (Brokk) / recall (all)" --> Mem
    Gen -- "generates, validates" --> Defs
    Inst -- "copies at install" --> Defs
    Inst -- "copies at install" --> Lib
    Inst -- "copies at install" --> Cmd
```

| Building block | Responsibility | Code location | Evidence |
| --- | --- | --- | --- |
| 5.1.1 Odin Orchestrator | Receives the user request, determines the Deliverable, plans, dispatches specialists, enforces review gates, communicates per mode | `agents/odin-autonomous.md`, `agents/odin-guided.md`, `agents/odin-interactive.md` | `agents/odin-autonomous.md:1-302` |
| 5.1.2 Specialist Agents | Five role-bound subagents: Mimir (research), Brokk (implementation), Heimdall (review), Bragi (communication), Kvasir (strategy) | `agents/mimir.md`, `agents/brokk.md`, `agents/heimdall.md`, `agents/bragi.md`, `agents/kvasir.md` | context Workfile § Area Map row `agents/`; `agents/brokk.md:1-121` |
| 5.1.3 Skill Library | Workflow doctrine for Odin and method skills for each specialist, grouped by feature domain plus optional per-role bundles | `skills/{research,architecture,engineering,deliberation,memories}/`, `skills/{bragi,brokk,heimdall,kvasir,mimir}/` | directory listing of `skills/**`; `README.md:126-136` |
| 5.1.4 Command Definitions | Seven user-facing slash commands routing to a named Odin mode with a skill-load directive | `commands/yggdrasil/*.md` | `commands/yggdrasil/research.md:1-13`; directory listing |
| 5.1.5 Yggdrasil Workspace | Transient, gitignored, task-scoped Workfile exchange between specialists | `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/` in the target project | `agents/odin-autonomous.md:74-82` |
| 5.1.6 Yggdrasil Memory | Persistent, git-tracked, source-cited knowledge base with an `INDEX.md` manifest | `.yggdrasil-memory/` in the target project | `agents/odin-autonomous.md:84-90`; `skills/memories/brokk-memory-curation/SKILL.md:91-110` |
| 5.1.7 Generator and Validation Toolchain | Generates the eight agent files from templates and fragments; validates structure and parity | `scripts/` | `scripts/README.md:1-170`; `scripts/generate-subagents.sh` |
| 5.1.8 Installation Payload | Copies agents, commands, skills, and the capability generator into the OpenCode configuration home; seeds the custom-capabilities scaffold | `setup.sh`, `config-home/generate-capabilities.sh`, `config-home/custom-capabilities.yaml` | `README.md:100-136`; `scripts/README.md:162-166` |

**Important interfaces at this level** (each specified in the blackbox that provides it): the *brief / executive-summary* dispatch contract (5.1.1 ↔ 5.1.2); the *agent frontmatter permission contract* (5.1.2, enforced by OpenCode); the *skill frontmatter contract* (5.1.3); the *command definition contract* (5.1.4); the *Workfile naming and path contract* (5.1.5); the *Memory entry schema* (5.1.6); the *generator assembly order and validator checks* (5.1.7).
