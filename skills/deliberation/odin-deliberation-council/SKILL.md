---
name: odin-deliberation-council
description: Orchestration doctrine for the Deliberation Council workflow — parallel perspective-lens deliberation over an optional reviewed research substrate, synthesized into a reasoned, reviewed conclusion.
---

# Deliberation Council

## Purpose

Define the orchestration doctrine for the Deliberation Council workflow — a trigger-gated workflow that generates diverse perspectives on a question, synthesizes them into a reasoned conclusion, and communicates it as a deliverable.

This skill is the dispatch doctrine; the five `bragi-council-deliberation-*` perspective skills are the per-lens instructions that the dispatched Bragi instances load themselves. Keep dispatch briefs at the orchestration level: name the lens skill, the question, and the context inputs; do not restate or invent lens instructions.

## When to Use

- When the Deliberation check verdict is **invoke** — via the `/yggdrasil/deliberate` command, explicit multi-perspective language in the request, or a user-confirmed suggestion, per the Trigger Thresholds in your Communication Policy.
- Load this skill **before** planning or dispatching any part of the workflow — never run it from memory of its steps.

Kvasir working inside this workflow does not make it a Consultation Layer mode. The standing workflow rules in your system prompt apply: the triggering verdict is stated before invoking; the workflow is the plan for its scope (Kvasir Consultation Check verdict: `skip — packaged workflow`); the workflow ends at the Final Review Gate.

## Workflow

1. **Research gate (conditional Stage 0).** Assess whether the question requires factual substrate the lenses cannot self-provide (Bragi lacks research skills). When in doubt, err toward research — unnecessary latency is cheaper than silent ungrounded deliberation. The user may override this gate in either direction; when research fires, disclose it and its added dispatch cost at the next user contact your Communication Policy permits. If needed, decide the approach before dispatching:
    - **Single Mimir session** — bounded question, one pass (the common case).
    - **Multiple Mimir sessions** — distinct factual areas, dispatched in parallel and merged into one substrate.
    - **Research workflow** — broad question warranting full Kvasir decomposition; use that workflow instead (load `odin-research-workflow`).
    Each substrate must be **fact-rich and framing-poor**: "what is the case?", not "what does it mean?" (the lenses' job). Factual findings, sourced claims, descriptive context — no recommendations, no prioritized framings. Each substrate begins with a **scope-declaration preamble**: what was investigated, what was out-of-scope, and why. If research is not needed (conceptual, values, or framing questions), skip this step and step 2 — the lenses fire on the question alone.
2. **Substrate review (conditional).** Dispatch a fresh Heimdall session to review the substrate — all constituent Mimir artifacts, verified against their actual sources per the Review Rules in your system prompt — before any lens consumes it. The lenses cannot perform this verification themselves, and a substrate defect propagates into every downstream perspective. Failed reviews follow Failed Review Classification. Skipped whenever step 1 produced no substrate.
3. **Perspective dispatch.** Dispatch N (default 5) Bragi tasks in parallel, each with one perspective lens from the `bragi-council-deliberation-*` skills, the question, and any available context:
    - `bragi-council-deliberation-foundations` — first-principles lens, strip away convention.
    - `bragi-council-deliberation-systems` — systems-thinking lens, map relationships and feedback loops.
    - `bragi-council-deliberation-adversary` — adversarial lens, construct the strongest case against.
    - `bragi-council-deliberation-pragmatist` — pragmatist lens, test against concrete constraints.
    - `bragi-council-deliberation-humanist` — humanist lens, who is affected and what they value.
    If a substrate was produced, each lens receives it as input context — treated as factual background, not a framing to react to. Each lens must argue its case fully without seeking consensus — convergence is the synthesizer's job.
4. **Synthesis.** Dispatch one Kvasir task to synthesize: read all N perspective artifacts, weigh the competing arguments, and reach a reasoned conclusion. Kvasir is informed whether a shared research prior was used — shared-input agreement is a weaker signal than independently-emergent agreement.
5. **Deliverable.** Dispatch one fresh-session Bragi task to draft the final user-facing answer from Kvasir's synthesis artifact, per the `bragi-council-deliberation-herald` skill. The deliverable discloses its grounding per that skill's Workflow.
6. **Final Review Gate.** Dispatch a fresh Heimdall session to validate the assembled deliverable against the user's original request.

## Quality Criteria

- **One round — no iteration.** The council deliberates once; there is no re-deliberation loop.
- **N=5 — all perspectives fire by default.**
- **Cost (total dispatches, Final Review Gate included):** N + 3 without research (8 at N=5); N + 5 minimum with research (10 at N=5 — one Mimir plus the substrate review), scaling with additional parallel Mimir sessions.
- **Substrates are fact-rich and framing-poor**, each opening with a scope-declaration preamble.
- **Every substrate is reviewed before any lens consumes it** — source-verified, not just coherence-checked.
- **Lenses argue independently** — no lens sees another lens's output; convergence happens only at synthesis.
- **The deliverable discloses its grounding** — research performed (with artifact citation) or deliberation on abstraction alone.

## Anti-Patterns

- **Deliberating ungrounded when facts are needed.** Skipping the research-gate assessment, or resolving genuine doubt toward "no research" — doubt resolves toward research.
- **Framing substrates.** A substrate that recommends, prioritizes, or interprets pre-anchors every lens; substrates state only what is the case.
- **Skipping the substrate review.** An unverified substrate defect propagates into all N perspectives at once.
- **Consensus-seeking lenses.** Briefing lenses to converge, or sharing lens outputs between lenses — each lens argues its own case fully; the synthesizer weighs them.
- **Synthesizer-to-user delivery.** Kvasir's synthesis is an intermediate artifact — a fresh Bragi session drafts the user-facing deliverable from it, preserving the advisory boundary.
- **Iterating rounds.** One deliberation round only; if the conclusion is unsatisfying, that is a new task, not a re-run.
- **Skipping the Final Review Gate.** The deliverable is user-facing output and must pass the gate like any other.
