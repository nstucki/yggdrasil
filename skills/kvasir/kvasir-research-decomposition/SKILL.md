---
name: kvasir-research-decomposition
description: Decompose and cluster complex research tasks for systematic parallel investigation.
---

# Research Decomposition

## Purpose

Take complex research requirements and systematically decompose them into related clusters that enable parallel investigation while maintaining logical coherence and dependency awareness.

## When to Use

- Receive complex research requests needing decomposition
- Must organize research into decomposed clusters for parallel execution
- Research involves multi-repository codebase exploration
- Need to maximize investigation efficiency through intelligent task clustering
- Research spans multiple systematic investigation phases

## Workflow

1. **Understand research objectives and constraints.**
   - Analyze research questions and success criteria provided
   - Identify information dependencies and prerequisite knowledge
   - Map investigation scope and key entities involved

2. **Define research scope and formulate investigation questions.**
   - Cluster related investigation areas (e.g., service A architecture, service A integration points)
   - Example: "Service discovery" and "Registry setup" cluster together vs. separate from "API patterns"
   - Example: "Database schema" clusters with "ORM configuration" but separate from "caching layer"
   - Formulate specific, answerable questions for each cluster
   - List what each cluster needs to discover and how findings interconnect

3. **Cluster research into parallel-executable groups.**
   - Group investigations that can proceed independently
   - Ensure clusters have clear boundaries and minimal inter-dependencies
   - Example: "Authentication architecture" is separate from "User service implementation"
   - Example: "Database migrations" can run parallel with "API endpoint discovery"
   - Assign investigation priority and sequencing where needed

4. **Plan cross-cluster integration points.**
   - Identify where cluster findings must be synthesized
   - Define validation criteria where results from different clusters intersect
   - Map dependency relationships for later integration

5. **Deliver decomposed research plan.**
   - Present clusters with clear investigation scope for each
   - Provide execution guidance and success criteria per cluster
   - Specify synthesis points where findings must be integrated

## Quality Criteria

- Research scope is decomposed into minimally-dependent clusters
- Each cluster has specific, measurable investigation objectives
- Clustering enables genuinely parallel research (not artificial parallelization)
- Cluster boundaries are clear and unambiguous
- Integration points between clusters are explicitly identified and mapped
- Decomposition reduces total investigation time vs. sequential approach

## Anti-Patterns

- **Artificial clustering**: Creating separate clusters that share dependencies
- **Over-fragmentation**: Breaking research into too many small clusters
- **Under-clustering**: Grouping unrelated investigations together
- **Missing integration**: Decomposing without planning cross-cluster synthesis
- **Unclear cluster scope**: Leaving investigators uncertain what each cluster covers
- **Ignoring dependencies**: Not mapping how findings feed into each other
