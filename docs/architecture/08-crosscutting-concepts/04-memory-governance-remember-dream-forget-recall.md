# 8.4 Memory Governance — Remember, Dream, Forget, Recall

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§8](README.md)._

Memories are distilled, source-cited entries with a fixed frontmatter schema and a `status`/`confidence` lifecycle (`skills/memories/brokk-memory-curation/SKILL.md:91-110`). Writes occur only through three command-triggered pipelines, each reviewed, with Forget additionally user-confirmed; secrets are never promoted; Dream never silently forgets (`skills/memories/odin-memory-system/SKILL.md:24-61`). Recall is a standing duty in every subagent's shared Memory section: scan `INDEX.md`, treat entries as leads, verify against live sources, cite the live source, report contradictions (`agents/brokk.md:106-113`; `scripts/subagent-generator/memory.fragment.md` per the listing). Odin never launches a pipeline itself (`agents/odin-autonomous.md:88`).
