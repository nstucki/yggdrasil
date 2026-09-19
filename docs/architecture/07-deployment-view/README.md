# 7. Deployment View

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md)._

The infrastructure the system runs on: the nodes and runtimes, and what is deployed where.

_Omitted — the installation mechanism is unchanged (`setup.sh` copies every listed mandatory directory and `commands/yggdrasil/`); the only deployment-relevant changes are the `MANDATORY_SKILL_DIRS` entry and the relocated-copy cleanup, both specified in §5.1.10 and ADR-0009. Deployed layout after install (R4): `~/.config/opencode/skills/yggdrasil/architecture/` holding six architecture skills (`odin-architecture-workflow`, `mimir-architecture-context`, `brokk-arc42-template`, `kvasir-software-architecture`, `heimdall-architecture-review`, `brokk-architecture-persistence`); `engineering/` holding five (`odin-engineering-workflow`, `mimir-engineering-context`, `bragi-business-analysis`, `brokk-test-driven-development`, `heimdall-engineering-review`); `setup.sh` removes a stale `architecture/mimir-codebase-context/` on upgrade._
