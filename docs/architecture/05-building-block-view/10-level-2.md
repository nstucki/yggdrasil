# 5.2 Level 2

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

Two blocks have an internal structure the evidence supports describing.

**5.1.1 Odin Orchestrator — whitebox.** One generated file per mode, each composed of three parts in order (`scripts/README.md:13-16`): the *preamble* (frontmatter and title, mode-substituted), the *shared body* (Role, Responsibilities, Boundaries, Role Discipline, Agent Selection Guide, Conventions, Planning, Workflows, Execution, Review & Quality Gates — `agents/odin-autonomous.md:22-279`), and the *Communication Policy fragment* (`agents/odin-autonomous.md:280-302` for Autonomous: never ask, document assumptions, two terminal escalation actions, and the Trigger Thresholds that complete each workflow's trigger rules). The shared body is byte-identical across modes and carries the parity markers Check 7 validates (`scripts/README.md:73`).

**5.1.3 Skill Library — whitebox.** Two layers by loader: the *doctrine layer* (`odin-*` skills, one per packaged workflow plus `odin-memory-system`) that Odin loads on an `invoke` verdict and that defines the dispatch sequence, gates, cost model, and return-line grammar (`agents/odin-autonomous.md:179`; `skills/architecture/odin-architecture-workflow/SKILL.md:1-12`); and the *method layer* (role-prefixed skills) that a specialist loads to execute one step of that sequence — e.g., the Architecture workflow's steps map onto `mimir-architecture-context` → `brokk-arc42-template` → `kvasir-software-architecture` → `heimdall-architecture-review` → `brokk-architecture-persistence` (`README.md:131`; directory listing of `skills/architecture/`). The install-side `capability-inventory` skill is the generated index over both layers (`scripts/README.md:162-166`).
