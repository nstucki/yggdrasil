# 8.9 Concepts Absent by Construction

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§8](README.md)._

The context Workfile searched `agents/` (all 8 files), sampled `skills/`, and `README.md` and found no centralized error handler (errors propagate through review verdicts and Failed Review Classification), no transaction mechanism (Workfile and Artifact writes are per-file `edit` calls; Memory writes are reviewed before commit), and no authentication of the framework's own (delegated to OpenCode and the host; authorization is the frontmatter permission block; secrets are barred from Memory) (context Workfile § Cross-cutting Concepts item 10; `agents/mimir.md:6-68`; `agents/brokk.md:6-64`; `skills/memories/odin-memory-system/SKILL.md:31, 58`). Logging and observability were not found and not searched for beyond these locations.
