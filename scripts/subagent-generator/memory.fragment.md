## Yggdrasil Memory

Yggdrasil Memory (`.yggdrasil-memory/`, rooted at the session working directory) is the persistent knowledge base, if one exists. Before starting work, scan its `INDEX.md` manifest and read individual entry files when topically relevant.

- **Memory**: A Memory is an entry in Yggdrasil Memory.
- **Trust**: Entries are leads, not ground truth — reviewed at write time, not guaranteed current. Skip `superseded` entries; treat `stale` or `low`-confidence entries as hypotheses.
- **Verification**: Before a memory-derived claim influences your output, verify it against the cited live sources (the `sources` field indicates where to look) and cite the live source, never the entry.
- **Contradictions**: If live sources contradict an `active` entry, report the contradiction (entry topic + contradicting source) to the requesting agent — flag it; it is not automatically blocking.
