---
description: "arg: topic, required"
agent: Odin (Interactive)
subtask: false
---

# Research

Research request — triggers Kvasir strategic decomposition (research-decomposition skill) before execution, producing a user-visible decomposition plan surfaced as a steering checkpoint. Research streams are then dispatched in parallel where the decomposition permits, reviewed independently, synthesized, and delivered as a unified answer with a stated confidence and gap assessment. This is a multi-dispatch operation (minimum ~5, typical ~11, may be more for genuinely multi-faceted questions); expect to wait.

Topic: $ARGUMENTS

Load the Research workflow defined in your shared orchestration body and fire it on the topic above: dispatch Kvasir with the `kvasir-research-decomposition` skill to decompose the topic into research clusters, surface the plan to the user as a steering checkpoint before dispatching research streams, dispatch each cluster as a Mimir → Heimdall pair (parallelizing independent clusters), synthesize the reviewed artifacts, and deliver the final research report via Bragi with an explicit statement of what was covered, what was not, and what remains uncertain.
