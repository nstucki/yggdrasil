# ADR-0002: Mandatory independent review by a dedicated reviewer with a Final Review Gate

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:33, 40, 100, 148, 177, 237-279`; `agents/brokk.md:88`; `skills/architecture/odin-architecture-workflow/SKILL.md:118, 160`; `skills/memories/odin-memory-system/SKILL.md:57`)

## Context

Specialist outputs are produced by language-model sessions whose self-reports cannot be trusted as evidence. The forces: goal 1 (independent verification) dominates; the cost of a review dispatch per Subtask is accepted; a review must compare against ground truth and against the user's original request, not merely against the producer's brief.

## Decision

The system routes every Mimir and Brokk Subtask through a dedicated Heimdall review and ends every Orchestration Task — including every packaged workflow — at a Final Review Gate in a fresh Heimdall session that receives the user's original request in full and the complete assembled Deliverable. A verdict is `PASS`, `PASS-WITH-NOTES`, or `BLOCKED`, is authoritative, and is never re-reviewed; a missing verdict is re-tasked, never inferred. Review briefs pin the baseline. Failed reviews follow the Failed Review Classification: direct fix loop for execution defects, mandatory Kvasir consultation for plan-level mismatches, a cap of three fix rounds per producer session with a Kvasir consult after two, and a verify-then-reconsider path for disputed findings. Kvasir and Bragi outputs receive no dedicated review; the gate is their backstop. No agent reviews its own output.

## Consequences

- **Positive:** Defects are caught at the piece and at the whole; failure handling is uniform across composed plans and packaged workflows; the terminal failure report is itself gated.
- **Negative:** Roughly doubles dispatch count on the execution chain; the gate can fail on defects that originated in unreviewed consultation output (§11 R3).
- **Becomes harder:** Fast, low-ceremony tasks — even a single-Subtask task carries one review, though that one dispatch may serve as both Subtask Review and gate (`agents/odin-autonomous.md:263`).

## Related

§5.1.1, §5.1.2 (Heimdall), §6.1–6.3, §8.1 · ADR-0001, ADR-0008 · `agents/odin-autonomous.md:237-279`
