# ADR-0014: Caller contract drops `context=`; each workflow gathers its own context — supersedes ADR-0004

- **Status:** Accepted (Revision 4) — **supersedes ADR-0004** (`Accepted`, persisted; file left unedited, C-14)
- **Date:** 2026-09-19

## Context
ADR-0004 let the engineering workflow pass its reviewed context Workfile so the Architecture workflow could skip its own gate, saving one Mimir pair on the delegation path. That premise — one Workfile serves both consumers — is exactly what ADR-0012 removes: the engineering-context Workfile holds behavior, conventions, and a baseline run, none of which grounds a §5 blackbox; and after ADR-0015 it is produced *after* the architecture delegation anyway, so it could not be passed even if it were suitable. The only caller that exists is the engineering workflow. Goals: Reusability, Clarity of Intent, Cost Proportionality, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Reusability | Clarity | Cost Prop. | Backward Compat. |
| --- | --- | --- | --- | --- | --- | --- |
| A. Keep `context=` with the old semantics (any reviewed context Workfile skips the gate) | No grammar change | Would let an engineering-context Workfile blind Kvasir on §5 — the skip's premise is false; after ADR-0015 the field is always `none` from the only caller | − | − | + | + |
| B. Keep `context=` but redefine it as "reviewed **architecture**-context Workfile" | Grammar-stable; a hypothetical future caller could reuse a prior architecture run's Workfile | Dead field for the only real caller (always `none`); two semantics of "context" in one contract line; the "already established in conversation" reason in I-2 already covers the reuse case without a field | 0 | − | + | + |
| C. **Remove `context=` from I-1**; the Architecture workflow's gate is decided solely by its own I-2 rule (skip only when structure is already established in conversation, or greenfield) | Contract says only what callers can truthfully supply; one owner of the structural evidence; I-2's reason covers reuse of a prior run in the same session | I-1 grammar change ripples to §5.1.1, the live workflow skill (line 48, 51, 82), the engineering skill (lines 53, 56), the persisted 05/09 files; the delegation path always pays the architecture pair on brownfield repos | + | + | 0 | 0 |

## Decision
We use **C**. I-1 becomes `Architecture request: mode=…, objective=…, requirements=…, persistence=…, location=…`. I-2's `context=` rule: `no` only when the conversation already established boundaries, entry points, boundary interfaces, and documentation for the system in scope (including a reviewed `NN-context-architecture-*.md` from an earlier run in the same session), or the objective is greenfield; an engineering-context Workfile is explicitly not a skip reason. The engineering workflow passes no context and its step 3 paragraph about `context=` is deleted. ADR-0004 is superseded: its row and file stay `Accepted`; this record's §9 row and this line state the supersession.

## Consequences
- **Positive:** the contract cannot carry a misleading skip; Kvasir's §5 evidence always comes from an architecture-shaped, architecture-reviewed Workfile; the engineering workflow no longer needs to track another workflow's review status.
- **Negative:** on a brownfield delegation the architecture pair always runs (R-15); the persisted ADR-0004 file now reads `Accepted` while superseded — readers must follow §9 (accepted consequence of the never-overwrite discipline; a one-line status amendment to the persisted file would be a deliberate edit needing your direction).
- **Becomes harder:** a composite caller that *has* architecture-scoped context cannot hand it over except through the "established in conversation" reason — acceptable while no such caller exists.

## Related
AC-9, AC-19, AC-20 · §5.1.1 I-1/I-2, §5.1.6 step 3, §8.2 · ADR-0003, ADR-0004 (superseded), ADR-0012, ADR-0015 · WP-R4-3.
