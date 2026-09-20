# 5.1.6 Blackbox Yggdrasil Memory

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** The persistent, source-cited knowledge base at `.yggdrasil-memory/` in the target project, recommended to be git-tracked, with an `INDEX.md` manifest; modified only by the Remember/Dream/Forget pipelines; never an Artifact (`agents/odin-autonomous.md:86`).

**Provided interface — the Memory entry schema** (`skills/memories/brokk-memory-curation/SKILL.md:91-110`, quoted in the context Workfile): Markdown with YAML frontmatter fields `topic` (kebab-case, equals filename without `.md`), `created` and `updated` (ISO dates), `sources` (list of `<path>[:<line-range>]`, never empty), `confidence` (`high | medium | low`), `status` (`active | stale | superseded`).

**Provided interface — the recall contract.** Every subagent scans `INDEX.md` before work, skips `superseded`, treats `stale` or `low` as hypotheses, verifies a memory-derived claim against its cited live source before it influences output, cites the live source and never the entry, and reports contradictions to Odin as non-blocking flags (`agents/brokk.md:108-113`); Odin may then suggest `/yggdrasil/dream` (`agents/odin-autonomous.md:90`).

**Required interfaces — the write pipelines** (`skills/memories/odin-memory-system/SKILL.md:24-52`): Remember — user-triggered, Brokk distills reviewed research, Heimdall reviews; Dream — user-triggered, Mimir audits, Heimdall reviews, Brokk consolidates; Forget — explicit user instruction, scope confirmed, Brokk deletes, Heimdall reviews.

**Guardrails / failure contract.** Never promote secrets or credentials; every write reviewed; Forget always confirmed; deletions never committed by the pipeline; Dream never silently forgets (`skills/memories/odin-memory-system/SKILL.md:31, 57-61`). Odin never launches a pipeline itself; it may only point the user to `/yggdrasil/remember` in the final Deliverable (`agents/odin-autonomous.md:88`).
