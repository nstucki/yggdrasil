# 6.4 Review-Gated Batched Commit in the TDD Workflow

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§6](README.md)._

The path by which code reaches a target project's history: one batch of the TDD plan, from the plan checkpoint to the reviewed commit. The flow is the same whether the workflow was entered by its own `TDD check` verdict or as the Software Engineering workflow's stage. Read from `skills/tdd/odin-tdd-workflow/SKILL.md:42-69` (§ Workflow steps 2–7 and failure handling), `skills/tdd/brokk-tdd-commit/SKILL.md:60-71`, and `skills/tdd/heimdall-tdd-review/SKILL.md:61, 103, 116-129`. Realizes system goals 1, 2, and 4 and TDD-3, TDD-5, TDD-6, TDD-7, TDD-9. The context gate (step 1) and the Response (step 7) are omitted; they follow 6.1's pattern. The standalone safety stop (§5.2 T-7) sits between the plan report and the plan checkpoint and is not drawn: when it fires there is no batch.

```mermaid
sequenceDiagram
    participant O as Odin (odin-tdd-workflow)
    participant K as Kvasir (kvasir-tdd-planning)
    participant B as Brokk (brokk-test-driven-development)
    participant H as Heimdall (heimdall-tdd-review)
    participant C as Brokk, fresh (brokk-tdd-commit)
    participant G as target repository

    O->>K: brief - objective, Workfile path to create, input Workfile paths
    K->>G: git branch --show-current / git status --porcelain (the two facts)
    K-->>O: report - TDD plan: line, Package check: line, commit plan per batch
    O->>O: plan checkpoint - record Plan amended: lines when steered
    loop each package of the batch, in plan order
        O->>B: brief - plan path + package, Phase:, Mode:, reviewed-but-uncommitted paths
        B->>G: edit working tree - red, green, refactor - no git commit
        B-->>O: evidence block with Commits: none
        O->>H: Focus: package - evidence, write set, pinned HEAD, uncommitted list
        H->>G: git log (HEAD unchanged), git diff HEAD within write set, run tests
        H-->>O: Verdict: PASS or PASS-WITH-NOTES or BLOCKED
    end
    opt a parallel wave ran
        O->>B: brief - integration package, Mode: solo, Phase: full, reported seams
        B-->>O: evidence block with Commits: none
        O->>H: Focus: integration
        H-->>O: Verdict
    end
    O->>C: brief - plan path + batch n, gating review paths, pinned HEAD
    C->>C: read first line of each gating review - PASS/PASS-WITH-NOTES or stop
    C->>G: git rev-parse HEAD equals pinned, then git switch -c when the row says create
    C->>G: git add one reviewed path per invocation, then git diff --cached --stat equals union
    C->>G: run the full suite on the staged tree
    alt green, or baseline failures unchanged
        C->>G: git commit -m "type: subject" (the plan row, verbatim)
        C-->>O: commit record - hash, parent, branch, staged = reviewed union
        O->>H: Focus: commit - plan row, commit record, gating reviews
        H->>G: git log pinned..HEAD is one commit, git show --stat equals union, suite green at HEAD
        H-->>O: Verdict
    else red at commit
        C->>C: commit nothing and leave the index staged as it stands
        C-->>O: stop string "red at commit" with the failing tests, plus the note that the index is left staged and no commit was made
        O->>O: Mid-Execution Consultation - re-dispatch the affected package
    end
```

**Error paths actually taken.** A `BLOCKED` package or integration review follows Failed Review Classification: the producing session is resumed once for an execution defect; a plan-level mismatch or a second `BLOCKED` ends the run with that batch uncommitted, the work left in the tree and disclosed — the workflow never reverts, stashes, or deletes working-tree changes (`odin-tdd-workflow/SKILL.md:67`, § Workflow "Failure handling"). A `BLOCKED` commit review is the one case where the artifact is already history: the commit session is resumed once to land a corrective commit for a staging omission and both commits are disclosed; anything else ends the run with the review path named; history is never rewritten (`:69`; `heimdall-tdd-review/SKILL.md:129`). A red suite at commit time is not a review failure: the commit session commits nothing, leaves the index staged exactly as it stands — the staged set is the evidence the next session inspects, and undoing the staging is not this step's call — and reports `red at commit — <failing tests>` with `index left staged for inspection; no commit made`; Odin re-dispatches the affected package under Mid-Execution Consultation (`brokk-tdd-commit/SKILL.md:66`; `odin-tdd-workflow/SKILL.md:63, 69`). Every git command the commit session runs — `rev-parse`, `switch -c`, `add`, `rm`, `mv`, `diff --cached`, `commit -m`, `show`, `status` — is in the Brokk permission block's allow list (`agents/brokk.md:10-29`). A `HEAD` that moved between the pinned reference and the commit session, or a tree path outside the reviewed union and the baseline-dirty list, stops the commit session before staging (`brokk-tdd-commit/SKILL.md:61, 63`).
