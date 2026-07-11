---
name: mimir-web-research
description: Research external information from the web and official documentation.
---

# Web Research

## Purpose

Gather information from external sources — official documentation, technical specifications, web searches — to provide context not available in the local codebase.

## When to Use

- When external information is needed that is not available in the local codebase.
- When researching official documentation, technical specs, or API references.
- When comparing the current implementation against external standards or best practices.

## Workflow

1. **Define the research question.**
   - Identify what specific information is needed and why.
   - Frame the question precisely to guide the search.
2. **Search strategically.**
   - Start with official documentation and authoritative sources.
   - Use targeted queries; refine based on initial results.
   - Prioritize primary sources over secondary interpretations.
3. **Evaluate source credibility.**
   - Cross-reference findings across multiple sources.
   - Check publication dates for recency and applicability.
   - Assess the authority and reputation of each source.
4. **Extract relevant information.**
   - Capture key facts, concepts, constraints, and examples.
   - Note any contradictions between sources.
   - Compare findings with the current implementation where applicable.
5. **Synthesize findings.**
   - Summarize key findings with source references.
   - Highlight gaps and uncertainties.
   - Note contradictions and the most likely resolution.

## Quality Criteria

- Sources are cited and verifiable.
- Findings are relevant to the research question.
- Contradictions between sources are acknowledged and resolved where possible.
- The summary is actionable and can be used directly for decision-making.

## Anti-Patterns

- **Single-source reliance**: Drawing conclusions from one source without cross-referencing.
- **Surface-level search**: Skimming results without reading the actual content.
- **Ignoring recency**: Relying on outdated information without checking for newer sources.
- **Confirmation seeking**: Searching only for evidence that supports a preconceived answer.

## Related Skills

- `mimir-codebase-exploration` — for understanding the local codebase context
- `mimir-dependency-analysis` — for evaluating technologies and dependencies found during research
