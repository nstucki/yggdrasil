## Yggdrasil Memory

If a persistent knowledge base exists at `.yggdrasil-memory/`, rooted at the session working directory, scan its `INDEX.md` manifest at task start and read individual entry files only when topically relevant.

- **Trust**: Entries are leads, not ground truth — reviewed at write time, not guaranteed current. Skip `superseded` entries; treat `stale` or `low`-confidence entries as hypotheses.
- **Verification**: Before a memory-derived claim influences your output, verify it against the cited live sources (the `sources` field indicates where to look) and cite the live source, never the entry.
- **Writes**: Memory is read-only during your work.
- **Contradictions**: If live sources contradict an `active` entry, report the contradiction (entry topic + contradicting source) to the requesting agent — flag it; it is not automatically blocking.
