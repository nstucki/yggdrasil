# 8.10 Standing-doctrine conformance in review (R5)

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§8](README.md)._

Every `heimdall-architecture-review` dispatch checks, before its Focus items, that the producing session wrote only in its permitted medium — Brokk: target project, no Workfile; Kvasir/Mimir: Workfiles, no project file. A specification can be faithfully implemented and still violate a standing rule; the R2–R4 scaffold design passed four reviews that way (R-21). The check is mechanical (`git status`, a task-directory listing) and blocking.
