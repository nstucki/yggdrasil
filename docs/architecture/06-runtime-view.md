# 6. Runtime View

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 6.1 Standalone document-existing (AC-1, AC-3, AC-4, AC-5, AC-11, AC-12, AC-13, AC-18)

```mermaid
sequenceDiagram
  participant U as User
  participant O as Odin (Architecture workflow)
  participant M as Mimir
  participant K as Kvasir
  participant H as Heimdall
  participant B as Brokk
  participant G as Bragi
  U->>O: /yggdrasil/architect "document the architecture of this repo"
  O->>O: Architecture check → invoke — Architecture shape: mode=document-existing, source=direction, context=yes, persistence=inline
  O->>M: mimir-architecture-context (scope: whole system)
  M-->>O: NN-context-architecture-system.md
  O->>H: heimdall-architecture-review — Focus: context (standing review)
  H-->>O: PASS
  O->>B: brokk-arc42-template — Scaffold: mode=document-existing, source=direction, workfile, location
  B-->>O: skeleton Workfile — Scaffold result: document-scope=seed, existing=none, next-adr=0001
  O->>H: heimdall-architecture-review — Focus: scaffold (standing review)
  H-->>O: PASS
  O->>K: kvasir-software-architecture, Mode: document-existing, Scaffold: path, architecture-context Workfile
  K-->>O: NN-architecture-arc42.md filled (Mode header, as-is ADRs, B/C n/a)
  O->>H: heimdall-architecture-review — Focus: document, Mode: document-existing
  alt BLOCKED
    H-->>O: BLOCKED
    O->>K: resume (execution defect) — once
    K-->>O: revised Workfile
    O->>H: re-review
  end
  H-->>O: PASS / PASS-WITH-NOTES
  O->>U: ratification checkpoint (pause or auto per Communication Policy)
  O->>B: brokk-architecture-persistence (docs/architecture/, ratification record)
  B-->>O: persistence manifest
  O->>H: heimdall-architecture-review — Focus: persistence (standing review)
  O->>G: draft Response
  O-->>U: Response + Artifact — Architecture result line
```

Error path: a second `BLOCKED` or a plan-level mismatch stops before persistence and surfaces the review — the run returns `review=<path> — BLOCKED` with `persisted=not-reached`, steps 6–8 never having been entered and no caller waiting to own the persistence decision (AC-12).

## 6.2 Delegation from the engineering workflow (AC-8, AC-9, AC-10, AC-12, AC-19, AC-20)

```mermaid
sequenceDiagram
  participant E as Odin (Engineering workflow)
  participant A as Odin (Architecture workflow, loaded as sub-procedure)
  participant K as Kvasir
  participant H as Heimdall
  participant M as Mimir (architecture-context · engineering-context)
  participant B as Brokk (scaffold session · integration session)
  participant G as Bragi
  E->>E: Engineering shape: context=yes — behavior to characterize, analysis=yes, architecture=yes
  E->>G: bragi-business-analysis (objective only — C-13)
  G-->>E: NN-requirements.md
  E->>A: Architecture request: mode=decide-new, objective, requirements=NN-requirements.md, persistence=deferred
  A->>A: shape: mode=decide-new, source=direction, context=yes — structure not established, persistence=deferred
  A->>M: mimir-architecture-context (scope: objective's structural footprint)
  M-->>A: NN-context-architecture-<area>.md
  A->>H: heimdall-architecture-review — Focus: context (standing review)
  H-->>A: PASS
  A->>B: brokk-arc42-template — Scaffold: mode=decide-new, source=direction, workfile, location
  B-->>A: skeleton Workfile — Scaffold result (document-scope, existing, next-adr)
  A->>H: heimdall-architecture-review — Focus: scaffold (standing review)
  H-->>A: PASS
  A->>K: kvasir-software-architecture, Mode: decide-new, Scaffold: path, architecture-context Workfile
  K-->>A: NN-architecture-arc42.md filled (A, B, C — Package check)
  A->>H: heimdall-architecture-review — Focus: document, Mode: decide-new
  alt review PASS (first attempt)
    H-->>A: PASS
  else review BLOCKED (execution defect)
    H-->>A: BLOCKED
    A->>K: resume Kvasir session — once
    K-->>A: revised Workfile
    A->>H: re-review
    alt re-review PASS
      H-->>A: PASS
    else still BLOCKED, or plan-level mismatch
      H-->>A: BLOCKED
      A-->>E: Architecture result: … review=<path> — BLOCKED, persisted=deferred
      E->>E: § Failed Review Classification — return to analysis step or shape verdict, no TDD plan formed (terminal for this scenario)
    end
  end
  Note over A,E: Continuation below occurs only on a PASS branch
  A-->>E: Architecture result: … persisted=deferred
  E->>M: step 4 — mimir-engineering-context (scope: Appendix B write sets + owned ACs)
  M-->>E: NN-context-engineering-<area>.md (behavior, conventions, test infra, baseline run)
  E->>H: heimdall-engineering-review — Focus: context (standing review, engineering shape)
  H-->>E: PASS
  E->>E: TDD plan from Appendix B + test command/baseline from the engineering context — plan checkpoint ratifies ADRs
  E->>B: integration + Architecture workflow step 7 (persistence) with ratification record
  B-->>E: manifest — ADRs Accepted
  E->>H: heimdall-engineering-review — Focus: integration (loads heimdall-architecture-review Focus: persistence by name)
  H-->>E: PASS
```

Dispatch count versus the delivered (R3) design, architecture firing on a brownfield repo: R3 ran one shared context gate (Mimir + review = 2) before analysis and skipped the architecture gate on the reviewed Workfile. R4 always runs the architecture-context pair inside the delegation (2) and runs the engineering-context pair (2) **only** when behavior or test infrastructure must be characterized — so **Δ = 0** when the engineering step is skipped and **Δ = +2** when both fire (Q-5, R-15). Order change: business analysis now precedes any context gathering (C-13); the engineering context step scopes itself to the ratified write sets, which the old pre-analysis position could not do (ADR-0015). The integration review still checks the persisted architecture; the checklist text lives once, in `heimdall-architecture-review`, and is loaded by name (ADR-0010).

Error path (AC-12, AC-9): a `BLOCKED` review inside the callee is handled there first (one Kvasir resume for an execution defect). If it stays BLOCKED, or the reviewer classifies a plan-level mismatch, the callee returns `review=<path> — BLOCKED` with `persisted=deferred` and stops; the engineering workflow receives the review path in the return block and routes it through its own § Failed Review Classification exactly as today's step 5 did — back to the analysis step or the shape verdict — and never forms a TDD plan from an unreviewed Appendix B.
