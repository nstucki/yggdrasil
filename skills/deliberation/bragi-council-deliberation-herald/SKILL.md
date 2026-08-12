---
name: bragi-council-deliberation-herald
description: Render the Deliberation Council's synthesis artifact into a final user-facing deliverable — faithful communication of the reasoned conclusion, not re-deliberation.
---

# Council Deliberation — Herald

## Purpose

Render the Deliberation Council's synthesis artifact into a final user-facing deliverable. This is a rendering and communication task, not a re-deliberation. The goal is to faithfully represent Kvasir's reasoned conclusion, disclose the grounding (research performed or abstraction-only deliberation), and preserve the proportional representation of dissenting and minority views that were part of the synthesis.

## When to Use

- **Only when dispatched as the deliverable-drafting step of the Deliberation Council workflow.** This skill is invoked by the orchestrating agent after synthesis is complete; it is not a general-purpose communication or drafting heuristic.
- The input is Kvasir's synthesis artifact — the reasoned conclusion weighing all N perspective lenses.
- The output is a single, clear, well-structured user-facing answer that discloses its grounding and represents the synthesis faithfully.

## Workflow

1. **Read the synthesis artifact in full** before producing any deliverable.
2. **Identify the synthesis's core conclusion** — the reasoned position Kvasir reached after weighing the competing perspectives.
3. **Determine the grounding** — whether the deliberation was conducted on a research substrate (fact-rich, reviewed) or on abstraction alone (conceptual, values, or framing questions).
4. **Render the conclusion into clear, well-structured prose** suitable for the user.
   - State the conclusion directly and confidently — do not hedge or soften what the synthesis concluded.
   - Organize the supporting reasoning in a logical structure that serves the user's understanding.
   - Where the synthesis identified competing arguments or trade-offs, represent them proportionally — do not erase minority or dissenting views that were part of the synthesis.
5. **Disclose the grounding explicitly** — state whether research was performed (and cite the artifact if so) or note that the deliberation was conducted on abstraction alone.
6. **Return the full deliverable in your response to the dispatching orchestrator.** The orchestrator cannot read workspace artifact files directly; it relies on the content you return in your response to relay the deliverable to the user. This is the primary, load-bearing output — omitting it silently breaks the pipeline. Return the complete, final deliverable text verbatim and in full.
7. **Write the same deliverable to the designated artifact path** for the record and audit trail (secondary output).

## Quality Criteria

- The deliverable is faithful to the synthesis's actual conclusion and the weighting of arguments Kvasir reached.
- The grounding is disclosed — research performed (with artifact citation) or deliberation on abstraction alone.
- Dissenting and minority perspectives from the synthesis are represented proportionally, not erased or minimized.
- No new claims or arguments appear in the deliverable that were not present in the synthesis artifact.
- The prose is clear and well-structured, suitable for direct user communication.

## Anti-Patterns

- **Re-deliberating or re-arguing the question** — the synthesis is complete; the deliverable communicates it, not revisits it.
- **Softening, hedging, or rebalancing the synthesis's conclusion** — the deliverable states what Kvasir concluded, not what the drafting Bragi thinks is safer or more palatable.
- **Injecting the drafting Bragi's own opinion** — the deliverable represents the synthesis, not the drafting agent's perspective.
- **Omitting or erasing minority and dissenting perspectives** — if the synthesis included competing views, the deliverable must represent them proportionally.
- **Omitting the grounding disclosure** — the user must know whether the conclusion rests on reviewed research or on abstraction alone.
