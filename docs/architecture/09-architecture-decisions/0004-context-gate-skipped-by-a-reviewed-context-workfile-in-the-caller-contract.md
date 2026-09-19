# ADR-0004: Context gate skipped by a reviewed context Workfile in the caller contract

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
The workflow owns a conditional context step (settled). The engineering workflow already runs its own context gate (step 2) with a standing review; running Mimir twice would break NF-3 and Backward Compatibility. Goals: Cost Proportionality, Backward Compatibility, Reusability.

## Options Considered
| Option | Pros | Cons | Cost Prop. | Backward Compat. | Reusability |
| --- | --- | --- | --- | --- | --- |
| A. `context=<path> (reviewed)` in I-1 ⇒ skip; else fire when not established in conversation | Explicit, auditable; one rule for all callers | Caller must state review status | + | + | + |
| B. Always skip when invoked from a composite | Simple | Composite callers that skipped context leave Kvasir blind on brownfield repos | + | 0 | − |
| C. Always run inside the workflow | Self-sufficient | Duplicate Mimir dispatch in engineering (Δ dispatches > 0) | − | − | 0 |

## Decision
We use **A**. Skip iff a *reviewed* context Workfile is supplied or the shape-verdict reason records that context is already established in conversation; the verdict records `context=no — <reason>`. An unreviewed Workfile is treated as absent.

## Consequences
- **Positive:** engineering dispatch count unchanged; standalone still self-sufficient.
- **Negative:** callers must carry the review status through.
- **Becomes harder:** nothing material.

## Related
AC-9, AC-19 · §5.1.1 I-1/I-2, §5.1.8 · ADR-0003.
