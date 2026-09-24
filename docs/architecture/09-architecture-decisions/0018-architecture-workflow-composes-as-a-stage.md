# ADR-0018: The Architecture workflow composes as a stage, not through a request/result contract

- **Status:** Accepted
- **Date:** 2026-09-24
- **Kind:** recorded (evidence: `skills/architecture/odin-architecture-workflow/SKILL.md:3, 18-22, 29, 59`; `skills/engineering/odin-engineering-workflow/SKILL.md:14, 16-19, 24-26, 50-52, 62, 67, 97, 113`; `agents/odin-autonomous.md:207, 213`; `scripts/odin-generator/shared-body.template.md:186`; `README.md:231, 398, 414`)

## Context

The Software Engineering workflow needs an architecture decision before it splits work into packages, and the Architecture workflow produces exactly that. The earlier form joined them by a **caller contract**: a per-role grammar of `Architecture shape:`, `Architecture request:`, and `Architecture result:` lines that an enclosing workflow emitted and parsed, so that the inner workflow's shape, review verdict, section scope, scaffold state, and persistence outcome travelled as fields of one line. The contract was a second interface to maintain beside the workflow's own steps, its fields duplicated state that already existed in the Workfile header and the review Workfiles, and every change to the inner workflow's steps changed the grammar. Subsystem goals affected: Consistency (primary — every packaged workflow composes the same way), Maintainability, Usability (the enclosing plan reads the same artifacts the user sees).

## Decision

The Architecture workflow is **standalone** and composes **as a stage**: an enclosing workflow loads `odin-architecture-workflow` and runs it to completion — context gate, draft, ratification checkpoint, persistence, and their reviews — exactly as it would run Research or Deliberation; "no request line and no result line exist" (`odin-architecture-workflow/SKILL.md:29`). What the stage leaves in the conversation is what the enclosing plan consumes: the architecture Workfile (its §5 interfaces as contracts, its Appendix B as the package plan) and the persisted directory; ratification and persistence happened inside the stage and are never repeated (`odin-engineering-workflow/SKILL.md:50-52, 62, 67`). The inner workflow's Deliverable is fixed by its own skill in a `Deliverable:` line (`odin-architecture-workflow/SKILL.md:18-22`); when staged, its Response is folded into the enclosing Response (`:59`). A stage that stops on a `BLOCKED` review stops the enclosing run under Failed Review Classification; a stage whose persistence the user declined proceeds with the Workfile as the implementation contract (`odin-engineering-workflow/SKILL.md:52`). Odin's shared body states the same composition in the Software Engineering trigger description, generated from one template (`agents/odin-autonomous.md:213`; `scripts/odin-generator/shared-body.template.md:186`), and assigns trigger ownership so the two workflows never compete: architecture language with implementation intent fires the Engineering check, without it the Architecture check (`agents/odin-autonomous.md:207`).

## Consequences

- **Positive:** the Skill Library's provided interface for workflows is uniform — a trigger verdict, an `odin-*` skill, a fixed `Deliverable:` line (§5.1.3); the enclosing workflow's cost model names the inner workflow's dispatch count as a term, `D` = 4 or 6 (`odin-engineering-workflow/SKILL.md:113`); a change to the Architecture workflow's steps changes no other skill's grammar.
- **Negative:** the enclosing plan depends on what the stage "left in the conversation" rather than on a parsed line — a stage that returns malformed report items is caught at the plan checkpoint, not by a grammar check.
- **Becomes harder:** running the Architecture workflow partially inside another plan (for instance, drafting without persisting on the enclosing plan's say-so) — the stage runs whole, and only the user's decline at the stage's own checkpoint skips persistence.

## Related

DOC-13 · §5.1.3 (provided interface), §5.2, §8.5 · §12 "Stage (of a workflow)" · ADR-0006 (packaged workflows as Odin-prefixed skills — this record fixes how two of them compose) · ADR-0015, ADR-0016.
