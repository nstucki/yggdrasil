# ADR-0017: Scaffold content is index-only section folders at `Status: Scaffolded` with Yggdrasil descriptions and no arc42 guidance; an aborted run's skeleton is disclosed, never deleted

- **Status:** Accepted (Revision 5)
- **Date:** 2026-09-19

## Context
"Scaffold the target project when nothing has been decided" needs a definition. Constraints: git tracks no empty directories (C-17); the scaffold precedes review and ratification, so anything it writes may be committed by the user or left behind on abort; arc42 guidance text is CC BY-SA 4.0 and today enters a document only through the skeleton Workfile, whence Kvasir deletes it (attribution iff-rule); Kvasir cannot load the Brokk template (C-3), so if it needs guidance it must read it from the project. Goals: Clarity of Intent, Doctrine Minimization, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Clarity | Doctrine Min. | Backward Compat. |
| --- | --- | --- | --- | --- | --- |
| A. Empty directories only | Minimal | Untracked by git — vanishes on commit; indistinguishable from "forgotten" | − | + | − |
| B. Section folders each holding a stub carrying the **arc42 guidance blocks** plus the attribution notice; Kvasir reads guidance from the project | Kvasir keeps arc42's own prose while drafting; iff-rule mechanics unchanged | CC BY-SA text written into the project before any review; an aborted run leaves licensed text in the user's tree; per-file attribution bookkeeping persists through scaffold, draft, and persistence | 0 | − | 0 |
| C. **Section folders each holding a generated index stub — H1, backlink, one-line Yggdrasil description, `_Pending — not yet drafted_` — a `09-architecture-decisions/` log stub, and a top index at `Status: Scaffolded`; no guidance text anywhere in the project** | Git-tracked; listing-checkable; the indices are the same files persistence regenerates later, so nothing is thrown away; the target never contains licensed text, so the attribution machinery goes dormant; `Status: Scaffolded` is a machine-checkable invariant | Kvasir drafts without arc42's guidance prose (its own Workflow is the method); a skeleton may be left on abort | + | + | + |
| D. Full skeleton files with every heading in the project | Mirrors the old Workfile | Same licensing exposure as B; content-shaped files that hold no content; persistence would have to overwrite them wholesale | − | − | − |

## Decision
We use **C**. Content of `created`: top `README.md` (`Status: Scaffolded`, `Date`, `Document scope: seed`, `Mode … (source …)`, Sections table all `pending`, Change Log row `scaffolded`); the twelve `NN-<section>/README.md` index stubs, of which `09-architecture-decisions/README.md` is the decision-log variant (an empty log table) — **thirteen files**, §9's index being one of the twelve, not a fourteenth. `verified` writes nothing; `extended` adds only missing folders' stubs. **On abort** (BLOCKED before persistence) the skeleton stays: the workflow never deletes project files it created; I-3 reports `scaffold=… — created (unfilled)`, the Response says so, and removal — or a later run over it, which the status invariant admits — is the user's call. The CC BY-SA skeleton stays inside `brokk-arc42-template` as reference material; Kvasir carries a structure-only shape table (names and numbers are not the Licensed Material).

## Consequences
- **Positive:** no licensed text ever reaches a target project; the attribution iff-checks become safety nets that should always evaluate to "absent"; the scaffold is exactly the persisted structure minus content.
- **Negative:** R-20 clutter after an abort; Kvasir loses the arc42 guidance prose at drafting time (compensated by its own Workflow steps, which already state each section's requirements).
- **Becomes harder:** persisting arc42 guidance deliberately into a project document — it would now have to be authored into the Workfile by Kvasir, which no rule asks for.

## Related
AC-3, AC-12, AC-18 · §5.1.1 I-3 failure contract, §5.1.5 `Focus: scaffold`, §5.1.11, §5.1.13 · ADR-0016, ADR-0018 · WP-R5-1, WP-R5-4, WP-R5-5.
