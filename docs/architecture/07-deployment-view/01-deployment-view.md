# 7. Deployment View

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§7](README.md)._

Yggdrasil has two deployment sites: the **repository** (source of truth, where generators run) and the **OpenCode configuration home** (where the definitions execute), plus the **target project** where a session runs and the runtime stores live. Evidence: `README.md:100-152`, `scripts/README.md:162-166`, `agents/odin-autonomous.md:78, 86`.

```mermaid
flowchart LR
    subgraph Repo["Repository (source)"]
        A["agents/ (generated)"]
        S["skills/"]
        Cm["commands/yggdrasil/"]
        CH["config-home/<br/>generate-capabilities.sh<br/>custom-capabilities.yaml"]
        SU["setup.sh"]
        SC["scripts/ (generators, validate.sh)"]
        SC -- "generate + validate" --> A
    end
    subgraph Home["OpenCode configuration home<br/>~/.config/opencode/ or $OPENCODE_CONFIG_BASE"]
        HA["agents/yggdrasil/"]
        HC["commands/yggdrasil/"]
        HS["skills/yggdrasil/{research,architecture,engineering,deliberation,memories}/"]
        HO["skills/yggdrasil/<agent>/ (optional)"]
        HY["yggdrasil/generate-capabilities.sh<br/>yggdrasil/custom-capabilities.yaml (seeded once)"]
        HI["skills/yggdrasil/shared/capability-inventory/SKILL.md (generated)"]
        HY -- "runs at install" --> HI
    end
    subgraph Proj["Target project (session working directory)"]
        PF["project files"]
        PW[".yggdrasil-workspace/ (gitignored)"]
        PM[".yggdrasil-memory/ (git-tracked)"]
    end
    OCR["OpenCode runtime"]

    SU -- "copy" --> HA
    SU -- "copy" --> HC
    SU -- "copy" --> HS
    SU -- "copy if accepted" --> HO
    SU -- "copy / seed" --> HY
    A --> SU
    S --> SU
    Cm --> SU
    CH --> SU
    Home -- "loaded by" --> OCR
    OCR -- "session in" --> Proj
```

| Node | Contents | Lifecycle | Evidence |
| --- | --- | --- | --- |
| Repository | Templates, generated agents, skills, commands, installer, install payload, this architecture document | Edited by maintainers; `validate.sh` gates commits of generated files | `scripts/README.md:105-151` |
| Configuration home | Installed copies; the generated capability inventory; the operator-owned `custom-capabilities.yaml` | Overwritten per Yggdrasil file on upgrade, unrelated files preserved, `custom-capabilities.yaml` never overwritten; inventory regenerated on every install | `README.md:106, 118, 122` |
| Target project | Artifacts, transient Workspace, persistent Memory | Workspace never committed; Memory recommended git-tracked and modified only by pipelines | `agents/odin-autonomous.md:78, 86` |

**Not evidenced.** Runtime infrastructure of OpenCode itself (model endpoints, tool execution sandbox) and any CI pipeline that runs the smoke tests — out of the context Workfile's scope.
