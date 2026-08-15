---
name: odin-research-workflow
description: Orchestration doctrine for the Research workflow — one-shot strategic decomposition into clusters, a user-visible steering checkpoint, parallel independently reviewed research streams, and a synthesized, boundary-naming report.
---

# Research Workflow

## Purpose

Define the orchestration doctrine for the Research workflow — an adaptive, trigger-gated workflow that decomposes a research question into parallel-executable clusters, executes them as reviewed research streams, and synthesizes a unified answer that names its own boundaries.

The workflow packages the "(Research A → Review ∥ Research B → Review ∥ ...) → Synthesize → Review" pattern from the Orchestration Patterns table in your system prompt, and is distinct from a one-shot "Research → Review → Report": the workflow guarantees one upfront Kvasir consultation whose decomposition plan is surfaced to the user as a steering checkpoint before execution commits. Parallelism is an emergent property of the decomposition, not a command-level feature: independent clusters run in parallel; dependent chains run in sequence.

**Fixed Deliverable (per § Deliverables and § Deliverable Determination in your system prompt):** a Response (the research report drafted by Bragi, step 8) and an Artifact (the persisted report file, persisted by Brokk, step 9). This fixes the Deliverable at Odin's top level: `source=workflow-fixed`, no inference on invoke.

## When to Use

- When the Research check verdict is **invoke** — via the `/yggdrasil/research` command or explicit research/investigate/analyze-into language in the request, per the Trigger Thresholds in your Communication Policy.

Kvasir working inside this workflow does not make it a Consultation Layer mode. The standing workflow rules in your system prompt apply: the triggering verdict is stated before invoking; the workflow is the plan for its scope (Kvasir Consultation Check verdict: `skip — packaged workflow` — this workflow carries its own mandatory Kvasir consultation as step 1); the workflow ends at the Final Review Gate.

## Workflow

1. **Decomposition (mandatory).** Dispatch Kvasir with the `kvasir-research-decomposition` skill and the research topic. Kvasir writes a decomposition plan to a Workfile — N clusters with per-cluster investigation questions (N may be 1). This consultation is mandatory on every invoke.
2. **Plan checkpoint (steering).** Surface the decomposition plan to the user as a readable summary — *"I will research these N aspects: [list]. This will take a few minutes."* The user may accept, modify, or redirect before execution begins. Whether to pause for steering input or auto-proceed is governed by your Communication Policy; when auto-proceeding, continue unless the plan is obviously defective.
3. **Parallel research.** For each cluster, dispatch Mimir with the cluster's investigation questions and its `mimir-research-convention` skill. Parallelize genuinely independent clusters; sequence dependent chains. Each Mimir writes `NN-research-cluster-<name>.md`.
4. **Parallel review.** For each Mimir Workfile, dispatch a fresh Heimdall session (distinct-subtask isolation) with its `heimdall-research-review` skill. Parallelize across independent clusters. Each Heimdall writes `NN-review-cluster-<name>.md`.
5. **Synthesis.** Dispatch Mimir with all reviewed research Workfiles and its `mimir-research-convention` skill to produce a unified synthesis — organized around the question, not around the sources, and naming its own boundaries: what was covered, what was not covered, and what remains uncertain. Writes `NN-synthesis.md`.
6. **Synthesis review.** Dispatch Heimdall with its `heimdall-research-review` skill to review the synthesis Workfile before Bragi consumes it.
7. **Deliverable (Response).** Dispatch Bragi to draft the user-facing research report from the reviewed synthesis. The report must explicitly state: what was covered, what was not covered, what remains uncertain, and what the user should verify externally. Writes the report Workfile.
8. **Deliverable (Artifact).** Dispatch Brokk to persist the report as an Artifact at a user-visible path.
9. **Final Review Gate.** Dispatch a fresh Heimdall session to validate the assembled Deliverable (Response + Artifact) against the user's original request.

## Quality Criteria

- **One-shot decomposition.** The decomposition runs once — no re-decomposition loop.
- **N is bounded by the decomposition** — typically 2–5 for heavy research, 1 for a light question; adaptive, never a fixed default.
- **Cost (total dispatches, Final Review Gate included):** `2N + 6` minimum (N Mimir + N Heimdall + Kvasir decomposition + synthesis + synthesis review + Bragi + Brokk + Final Review Gate); e.g., N=1 → 8, N=3 → 12.
- **The steering checkpoint always happens** — whether to pause for steering input or auto-proceed is governed by your Communication Policy.
- **Every research stream is independently reviewed** before synthesis consumes it, with fresh-session distinct-subtask isolation.
- **The synthesis and the report name their own boundaries** — covered, not covered, uncertain, and (in the report) what to verify externally.

## Anti-Patterns

- **Skipping the decomposition.** The Kvasir consultation is mandatory on invoke — even when the topic looks simple (N=1 is a valid decomposition outcome). Only an infrastructure failure of the dispatch itself triggers the own-judgment fallback.
- **Hiding the plan.** Executing the decomposition without surfacing the steering checkpoint — the visible, steerable plan is what makes the mandatory consultation additive.
- **Re-decomposing mid-flight.** If execution reveals the plan is wrong, that is Mid-Execution Consultation territory, not a second run of the decomposition skill.
- **Restating skill internals in briefs.** Name the specialist skill and the inputs; do not copy its methodology into the dispatch brief.
- **Reviewing streams with a shared or resumed reviewer session.** Each cluster review uses a fresh session (distinct-subtask isolation); anchored reviewers defeat independent validation.
- **Synthesizing unreviewed streams.** No research Workfile enters synthesis without a passing review.
- **Source-organized synthesis.** The synthesis is organized around the question; a per-source digest is not a synthesis.
- **Boundary-free reporting.** A report that does not state what was not covered and what remains uncertain overstates its own authority.
- **Skipping the Final Review Gate.** The Deliverable (Response + Artifact) is user-facing output and must pass the gate like any other.
