# 3. Context and Scope

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 3.1 Business Context

```mermaid
flowchart LR
  User([User]) -->|"/yggdrasil/architect · 'document the architecture' · 'decide the architecture'"| Odin["Odin: Architecture workflow"]
  Eng[Odin: Software Engineering workflow] -->|caller contract: mode=decide-new, requirements, reviewed context, persistence=deferred| Odin
  Odin -->|return block| Eng
  Odin -->|brief: scope| Mimir[Mimir · mimir-codebase-context]
  Odin -->|brief: Scaffold: mode, location| BrokkS[Brokk · brokk-arc42-template]
  BrokkS -->|scaffolded Workfile + Scaffold result line| Odin
  Odin -->|brief: Mode:, scaffold path, inputs| Kvasir[Kvasir · kvasir-software-architecture]
  Odin -->|brief: Focus: scaffold · Focus: document, Mode: · Focus: persistence| Heimdall[Heimdall · heimdall-architecture-review]
  Odin -->|brief: reviewed Workfile, ratification record| Brokk[Brokk · brokk-architecture-persistence]
  Odin -->|reviewed outputs| Bragi[Bragi · Response draft]
  Brokk -->|docs/architecture/ directory| Repo[(Target project)]
```

| Partner | Input to the workflow | Output from the workflow |
| --- | --- | --- |
| User | Command/trigger, optional mode direction, optional location | Response; persisted directory (Artifact) |
| Engineering workflow | Caller contract (§5.1.1 I-1) | Return block (§5.1.1 I-2) |
| Mimir / Brokk (scaffold) / Kvasir / Heimdall / Brokk (persistence) / Bragi | Briefs with the `Mode:` line; the scaffold path for Kvasir | Scaffold result line, Workfiles, verdicts, persistence manifest |

## 3.2 Technical Context

_Omitted — all exchanges are markdown briefs and Workfiles in `.yggdrasil-workspace/`; no channel changes._
