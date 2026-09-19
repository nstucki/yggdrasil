# ADR-0001: `kvasir-software-architecture` extended in place with a `Mode:` brief line

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
The skill is decision-oriented (context research §3: "does NOT currently support pure document-as-is mode"). Document mode needs the same arc42 skeleton, section-scope discipline, attribution rule, ADR format, and `Status: Proposed` lifecycle, but no options tables, no Appendix B/C, and a "no proposals" boundary. The brief settles *extend in place*; this ADR fixes the mechanism. Goals: Doctrine Minimization, Reusability, Backward Compatibility, Clarity of Intent.

## Options Considered
| Option | Pros | Cons | Doctrine Min. | Reusability | Backward Compat. | Clarity |
| --- | --- | --- | --- | --- | --- | --- |
| A. `Mode:` brief line; default `decide-new`; branch steps 1/3/4–5/10 and Output Contract | One skill, shared 80%; absent line = today's behavior | Skill grows; two code paths in one file | + | + | + | + (header field) |
| B. Sibling skill `kvasir-architecture-documentation` | Clean separation | Duplicates the fill-in rules, mode rules, attribution handling, report contract; two places to fix | − | − | + | 0 |
| C. Mode-agnostic skill; workflow strips B/C after the fact | No skill change | Kvasir would still invent options/packages for as-is systems; review cannot distinguish | 0 | − | + | − |

## Decision
We use **A**. `Mode: document-existing | decide-new` in the brief; absent ⇒ `decide-new`. Document mode: inputs are the reviewed system-scoped context Workfile; §1.2 goals inferred and flagged; every block cites evidence; existing decisions become ADRs with `Kind: as-is (inferred from <paths>)` at `Status: Proposed`; Appendices B/C carry `_Not applicable — document-existing mode_`; new boundary "never propose a change in document-existing mode." Workfile header gains `- **Mode:** … (source: …)`.

## Consequences
- **Positive:** single owner of arc42 drafting; Brokk unchanged (same statuses, same appendices rule); Q-6 holds.
- **Negative:** longer skill; When to Use gains a second trigger family.
- **Becomes harder:** evolving one mode without re-reading the other's branches.

## Related
AC-4, AC-6, AC-7, AC-13 · §5.1.4 · ADR-0010 · WP-3.
