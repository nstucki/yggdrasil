# ADR-0002: Single `/yggdrasil/architect` command with an implementation-intent precedence rule

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
One command is settled. The open design is the trigger language and its collision with the Engineering check, whose invariant rule already claims "requirements-analysis/architecture-before-implementation language" (`shared-body.template.md:180`). Goals: Clarity of Intent, Cost Proportionality, Backward Compatibility.

## Options Considered
| Option | Pros | Cons | Clarity | Cost Prop. | Backward Compat. |
| --- | --- | --- | --- | --- | --- |
| A. `Architecture check` with precedence: implementation intent ⇒ Engineering; none ⇒ Architecture; suggestion candidate = "explain the structure" on an undocumented codebase | Deterministic; engineering rule untouched | Needs a precedence sentence in both entries | + | + | + |
| B. Architecture check first; Engineering only when it skips | Simple ordering | Reverses today's engineering trigger; heavy runs lose architecture-before-implementation | − | 0 | − |
| C. Two commands (`document-architecture`, `decide-architecture`) and no inference | No mode inference | Rejected by settled decision; doubles command/threshold lines | + | − | + |

## Decision
We use **A**. Verdict `Architecture check: command=<yes/no>, explicit-request=<yes/no> → <invoke/skip/suggest>`. Rules: `/yggdrasil/architect` → invoke; explicit document/as-is/arc42/ADR/decide-the-architecture language **without** implementation intent → invoke; with implementation intent → skip (Engineering check owns it); "how is this system structured?" on a codebase with no architecture document → suggestion candidate; research or question → skip. Mode itself is decided inside the workflow (I-2), not by the trigger.

## Consequences
- **Positive:** Engineering trigger text unchanged; one new verdict line; command surface minimal.
- **Negative:** one more suggestion-candidate threshold line per Communication Policy fragment.
- **Becomes harder:** users wanting architecture-then-implement in one go must use `/yggdrasil/engineer` — documented in README.

## Related
AC-1, AC-2 · §5.1.2, §5.1.3 · ADR-0008.
