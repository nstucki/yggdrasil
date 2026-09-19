# ADR-0007: Doctrine-not-code delivery: prompt/documentation skills and reviews replace TDD

- **Status:** Accepted
- **Date:** 2026-09-18

## Context
The deliverable is markdown doctrine and templates; there is no test suite, and `brokk-test-driven-development` / `implementation-review` assume executable tests. Available capabilities (inventory): Implementer `system-prompts`, `documentation-writing`; Reviewer `system-prompt-review`, `documentation-review`, `engineering-review`; mechanical check `scripts/validate.sh`. Goals: Backward Compatibility (validate.sh green), Clarity of Intent.

## Options Considered
| Option | Pros | Cons | Backward Compat. | Clarity |
| --- | --- | --- | --- | --- |
| A. Implement with `brokk-system-prompts` (SKILL.md, templates, command) and `brokk-documentation-writing` (README); review with `heimdall-system-prompt-review` (simulate both modes and both paths) and `heimdall-documentation-review`; `validate.sh` + generator diff as the mechanical gate; "test seam" in Appendix B = review checklist derived from ACs | Uses purpose-built skills; adversarial simulation catches trigger/precedence defects | No red-green evidence; relies on reviewer rigor | + | + |
| B. Force TDD with `validate.sh` as the only "test" | Familiar loop | validate.sh cannot express behavioral ACs; red phase meaningless for prose | 0 | − |
| C. Implement with generic `software-engineering` + `implementation-review` | No skill selection needed | Checklists target code; prompt failure modes unexamined | 0 | − |

## Decision
We use **A**. Work-package "test seam" fields (Appendix B) name the checklist items and the `validate.sh` checks that must pass; every package touching a generated file includes regeneration. Note C-4: the optional skill slugs above appear in implementation *briefs*, never in mandatory skill text.

## Consequences
- **Positive:** correct reviewers for prompt behavior; mechanical drift caught.
- **Negative:** no executable regression suite for trigger semantics.
- **Becomes harder:** proving Q-4/Q-5 without a scripted run — mitigated by reviewer simulation transcripts.

## Related
All ACs (governs how every package is built and reviewed) · §8.4 · Appendix B, all packages.
