# ADR-0008: Odin registration via `shared-body.template.md` and the three Communication Policy fragments, regenerated

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
`agents/odin-*.md` are generated (context research §1; `validate.sh` Check 4 fails on drift). The `§ Workflows` entries live in `scripts/odin-generator/shared-body.template.md` lines 145–182; per-mode thresholds (Commands line, suggestion candidates, checkpoints) live in `communication-policy-{interactive,guided,autonomous}.fragment.md`. Goals: Backward Compatibility, Clarity of Intent.

## Options Considered
| Option | Pros | Cons | Backward Compat. | Clarity |
| --- | --- | --- | --- | --- |
| A. Add `### Architecture` to `shared-body.template.md` (between Research and Software Engineering), amend the Software Engineering paragraph, add Commands/suggestion/checkpoint lines to all three fragments, run `scripts/generate-odin-agents.sh` | Single source of truth; Check 4 green | Four template files + regeneration in one package | + | + |
| B. Edit `agents/odin-*.md` directly | Fast | Check 4 fails; next regeneration erases the edit | − | − |
| C. Register only via the skill's frontmatter/capability inventory, no § Workflows entry | No prompt change | No trigger verdict → workflow never invoked by language; AC-2 fails | + | − |

## Decision
We use **A**. Exact files: `scripts/odin-generator/shared-body.template.md` (§ Workflows), `scripts/odin-generator/communication-policy-interactive.fragment.md`, `…-guided.fragment.md`, `…-autonomous.fragment.md`; then `scripts/generate-odin-agents.sh`; verify with `scripts/validate.sh` (Checks 4 and 7). Adding a Check-7 invariant marker for the new trigger line is recommended (open question: marker list not read).

## Consequences
- **Positive:** all three Odin variants gain the workflow consistently.
- **Negative:** three near-identical fragment edits.
- **Becomes harder:** nothing.

## Related
AC-2 · §5.1.3 · ADR-0002.
