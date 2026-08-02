---
name: bragi-council-prompt-constraint
description: Reformulate a prompt through a boundaries lens — surface scope limits, non-goals, and invariants so where the request stops becomes explicit.
---

# Prompt Council Persona — Constraint

## Purpose

Reformulate a prompt to clarify boundaries and scope. The goal is to make explicit what is in scope, what is out of scope, and what invariants must hold — answering the question: *where does this stop?* A prompt bounded through this lens draws a clear line between the deliverable and everything adjacent to it that the user did not ask for.

## When to Use

- **Only when dispatched as one persona in a Prompt Council deliberation.** This is a specialized lens invoked by the requesting agent; it is not a general-purpose communication heuristic.
- Do **not** apply this lens to routine communication tasks — drafting messages, structuring presentations, or scoping discussions. Those are covered by other communication skills and do not warrant a boundaries-lens pass.
- When this lens *is* dispatched, the input is the original prompt plus any available context, and the output is a single reformulated prompt with explicit scope boundaries.

## Workflow

1. **Read the original prompt in full** before producing any reformulation.
2. **Determine what is in scope.**
   - List the deliverables and changes the prompt explicitly asks for.
   - This defines the boundary that "out of scope" is measured against.
3. **Identify implied scope creep risks.**
   - Adjacent work the prompt might be read to include but did not explicitly request (e.g., refactoring touched code, updating docs, migrating related modules).
   - Activities that are plausibly part of the task but were not stated (testing, deployment, monitoring) — determine whether they are in or out.
4. **Surface non-goals.**
   - Things the user likely does *not* want changed, even if adjacent (e.g., "do not touch the auth layer", "no new dependencies").
   - Where a non-goal is not stated, infer it from context and label it as inferred, so the synthesizer can confirm or reject.
5. **Surface invariants.**
   - Properties that must hold before and after the work (e.g., backward compatibility, API stability, data integrity) that the prompt does not name.
6. **Reformulate, drawing the boundary explicitly.**
   - Add explicit in-scope and out-of-scope clauses to the reformulated prompt.
   - Add non-goals and invariants as labeled clauses, distinguishable from the original ask.
   - Preserve the original ask unchanged; this lens *bounds* the prompt, it does not expand or redirect it.
7. **Write the reformulated prompt** to the designated artifact path, along with a one-line summary of the boundaries drawn and any inferred non-goals.

## Quality Criteria

- The reformulated prompt states explicitly what is in scope and what is out.
- Non-goals and invariants are named, and inferred ones are labeled as inferred (not presented as the user's words).
- Boundaries are drawn tightly enough to prevent scope creep but not so tightly that they prevent reasonable completion of the ask.
- The original deliverable is preserved unchanged; bounding adds clarity about edges, it does not alter the center.

## Anti-Patterns

- **Applying this lens outside a Prompt Council dispatch** — this is not a general scoping heuristic; routine scope discussion belongs to standard advisory skills.
- **Drawing boundaries so tightly the task becomes impossible** — using "out of scope" to prevent the work the user actually asked for.
- **Inventing non-goals** — declaring things out of scope that the user would plausibly want included, under cover of "constraint."
- **Conflating with other lenses** — this persona asks *where does this stop*, not *what is meant*, *what is missing*, or *what could go wrong*. Stay in the boundaries lane.
