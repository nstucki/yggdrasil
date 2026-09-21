# 6.2 Slash Command into the Packaged Research Workflow

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§6](README.md)._

The command path, using `/yggdrasil/research` as the instance. Read from `commands/yggdrasil/research.md:1-13`, `agents/odin-autonomous.md:172-199, 298`, and `skills/research/odin-research-workflow/SKILL.md:22-39` (via the context Workfile). Realizes goals 1 and 4.

```mermaid
sequenceDiagram
    actor U as User
    participant C as commands/yggdrasil/research.md
    participant O as Odin (Interactive)
    participant K as Kvasir
    participant M as Mimir (∥ per cluster)
    participant H as Heimdall
    participant Bg as Bragi
    participant B as Brokk

    U->>C: /yggdrasil/research "topic"
    C->>O: agent: Odin (Interactive) — Topic: $ARGUMENTS — load odin-research-workflow
    O->>O: "Research check: command=yes → invoke" — "Kvasir check: skip — packaged workflow"
    O->>O: load odin-research-workflow skill
    O->>K: step 1 — decompose into parallel clusters
    K-->>O: cluster plan
    O->>U: step 2 — plan checkpoint (Interactive pauses — Autonomous auto-proceeds)
    U-->>O: steer / confirm
    par one stream per cluster
        O->>M: step 3 — research cluster i
        M-->>O: Workfile
        O->>H: stream review
        H-->>O: verdict
    end
    O->>M: step 4 — synthesis over reviewed streams
    M-->>O: synthesis Workfile
    O->>H: review
    H-->>O: verdict
    O->>Bg: step 5 — draft Deliverable
    Bg-->>O: draft Workfile
    opt artifact requested
        O->>B: step 6 — persist Artifact
        B-->>O: path
        O->>H: review
    end
    O->>H: Final Review Gate (fresh session)
    H-->>O: verdict
    O-->>U: Deliverable
```

**Error path actually taken.** A `BLOCKED` stream review resumes the Mimir session once; if it stays blocked, the workflow stops and surfaces the failure rather than proceeding to synthesis on unreviewed material (context Workfile § Cross-cutting Concepts item 8; `agents/odin-autonomous.md:267-279`). The plan checkpoint's pause behavior is a Communication Policy threshold: Autonomous auto-proceeds and rides the summary on the final disclosure (`agents/odin-autonomous.md:298`).
