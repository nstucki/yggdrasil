# ADR-0008: Memory written only through command-triggered, reviewed pipelines

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:86-90`; `agents/brokk.md:91, 106-113`; `skills/memories/odin-memory-system/SKILL.md:24-61`; `skills/memories/brokk-memory-curation/SKILL.md:91-110`)

## Context

A persistent knowledge base is only useful if its entries are trustworthy and only safe if it never accumulates secrets or silently loses content. The forces: goal 4 (every entry cites sources and carries confidence and status), goal 1 (every write reviewed), and the user's authority over what is remembered and forgotten.

## Decision

Yggdrasil Memory is modified only by three command-triggered pipelines: Remember (user-triggered promotion of Heimdall-passed research — Brokk distills, Heimdall reviews), Dream (user-triggered consolidation — Mimir audits for duplicates, contradictions, and staleness, Heimdall reviews, Brokk consolidates), and Forget (explicit user instruction with confirmed scope — Brokk deletes, Heimdall reviews, deletions never committed by the pipeline). Odin never launches a pipeline itself; it may only point the user to `/yggdrasil/remember`. Every entry carries the fixed frontmatter schema with a non-empty `sources` list. Secrets are never promoted. On the read side, every subagent treats Memories as leads, verifies against the cited live source, cites the live source, and reports contradictions, which may prompt Odin to suggest a Dream.

## Consequences

- **Positive:** Provenance for every retained claim; no automatic or accidental writes; a staleness signal (`status`, `confidence`) flows back into curation through contradiction reports.
- **Negative:** Retention is manual — durable findings are lost unless the user runs Remember; each pipeline costs several reviewed dispatches.
- **Becomes harder:** Any form of automatic learning or background consolidation.

## Related

§5.1.6, §6.3, §8.4 · ADR-0002, ADR-0005 · `skills/memories/odin-memory-system/SKILL.md:24-61`
