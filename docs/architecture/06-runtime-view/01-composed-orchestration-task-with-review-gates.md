# 6.1 Composed Orchestration Task with Review Gates

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§6](README.md)._

The default path for a natural-language request that no packaged workflow claims. Read from `agents/odin-autonomous.md:66-68, 108-170, 221-279` and `agents/brokk.md:84-91`. Realizes goals 1 and 2.

```mermaid
sequenceDiagram
    actor U as User
    participant O as Odin
    participant K as Kvasir
    participant M as Mimir
    participant B as Brokk
    participant H as Heimdall
    participant W as .yggdrasil-workspace/

    U->>O: request
    O->>O: load capability-inventory (once per session)
    O->>O: record "Deliverable: …" verdict
    O->>O: record "Kvasir check: n=…" verdict
    opt consult (n ≥ 2 or a criterion matched)
        O->>K: brief (plan / decomposition)
        K->>W: NN-plan.md (edit)
        K-->>O: executive summary + path
    end
    O->>M: brief (research), task dir + filenames
    M->>W: 01-research-<topic>.md (edit)
    M-->>O: executive summary + path
    O->>H: Subtask Review — full Workfile path + exact brief
    H->>W: 02-review-<topic>.md
    H-->>O: verdict line PASS | PASS-WITH-NOTES | BLOCKED
    alt BLOCKED — execution defect
        O->>M: resume (task_id) with review path — max 3 rounds
        M-->>O: fixed
        O->>H: re-review (resumed session, re-read changed files)
    else BLOCKED — plan-level mismatch
        O->>K: mandatory consultation before any fix
    end
    O->>B: brief (implement), reads Workfiles as input
    B->>B: edit project files; ensure .gitignore covers workspace
    B-->>O: summary + Artifact paths
    O->>H: Subtask Review (Artifact, pinned baseline)
    H-->>O: verdict
    O->>H: Final Review Gate — fresh session, original request + assembled Deliverable
    H-->>O: verdict
    O-->>U: Response (+ disclosure of assumptions / blockers)
```

**Error path actually taken.** A third consecutive `BLOCKED` on one producer session is an unresolvable blocker; Autonomous mode then either delivers best-effort with a prominent blocker disclosure or issues an explicit failure report — both still pass through the Final Review Gate, which confirms the disclosure is accurate (`agents/odin-autonomous.md:261, 275, 287-290`). A disputed finding is verified via Kvasir or Mimir and sent back to Heimdall for one reconsideration; a baseline error skips the consult and re-tasks Heimdall with the corrected baseline (`:277-278`).
