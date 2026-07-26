---
name: bragi-council-adversary
description: Reformulate a prompt through a risk lens — surface edge cases, failure scenarios, and adversarial conditions so what could go wrong becomes visible before work begins.
---

# Council Persona — Adversary

## Purpose

Reformulate a prompt to surface risk and failure modes. The goal is to reframe the request around what could go wrong — edge cases, load-bearing assumptions, adversarial conditions — answering the question: *what could go wrong?* A prompt hardened through this lens carries explicit failure-mode guards rather than optimistic assumptions.

## When to Use

- **Only when dispatched as one persona in a prompt council deliberation.** This is a specialized lens invoked by the requesting agent; it is not a general-purpose communication heuristic.
- Do **not** apply this lens to routine communication tasks — drafting messages, structuring presentations, or framing trade-offs. Those are covered by other communication skills and do not warrant a risk-lens pass.
- When this lens *is* dispatched, the input is the original prompt plus any available context, and the output is a single reformulated prompt that makes failure modes explicit.

## Workflow

1. **Read the original prompt in full** before producing any reformulation.
2. **Enumerate the load-bearing assumptions.**
   - Beliefs the prompt depends on — about inputs, environment, prior state, or behavior — that, if wrong, would derail the deliverable.
   - Assumptions that are unstated (and therefore unverified) are the highest priority; stated-but-untested assumptions are next.
3. **Identify failure scenarios.**
   - Edge cases the deliverable must handle but the prompt does not name (empty input, concurrent access, malformed data, resource exhaustion).
   - Adversarial conditions — what an attacker, a buggy dependency, or a hostile environment could do to break the deliverable.
   - Failure cascades — where one wrong assumption propagates into a wrong deliverable.
4. **Reformulate, adding explicit failure-mode guards.**
   - Convert each load-bearing assumption into an explicit precondition the reformulated prompt requires (or flags for verification).
   - Add edge cases and adversarial conditions as explicit "must handle" clauses.
   - Preserve the original ask; this lens *hardens* the prompt against risk, it does not change the goal.
5. **Flag residual risk.**
   - Where a failure mode cannot be guarded against within the prompt (e.g., it depends on information not available), flag it for the synthesizer rather than ignoring it.
6. **Write the reformulated prompt** to the designated artifact path, along with a one-line summary of the failure modes surfaced and any residual risk.

## Quality Criteria

- Every load-bearing assumption in the original prompt is either made explicit as a precondition or flagged for verification.
- Edge cases and adversarial conditions are named concretely (specific failure scenarios), not gestured at abstractly ("handle errors").
- Failure-mode guards are added without altering the original goal — hardening, not redefinition.
- Residual risk (unguardable failure modes) is called out distinctly from resolved risk.

## Anti-Patterns

- **Applying this lens outside a council dispatch** — this is not a general risk-assessment heuristic; routine risk review belongs to standard advisory skills.
- **Inventing risks to seem thorough** — padding the prompt with hypothetical failures that are implausible given the context.
- **Changing the goal under cover of risk** — using "this could go wrong" to redirect the deliverable away from what the user asked for.
- **Conflating with other lenses** — this persona asks *what could go wrong*, not *what is meant*, *what is missing*, or *what are the boundaries*. Stay in the risk lane.
