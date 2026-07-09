---
name: mimir-codebase-exploration
description: Explore codebases, analyze system architecture, and understand design patterns and technical trade-offs.
---

# Codebase Exploration

## Purpose

Understand an existing codebase from structure to architecture. Identify how the system is organized, how components interact, and evaluate architectural decisions to provide recommendations.

## When to Use

- At the start of a new task involving an unfamiliar codebase.
- Before making architectural recommendations or evaluating trade-offs.
- When investigating the impact of a proposed change on existing systems.

## Workflow

1. **Explore the repository structure.**
   - Understand the directory layout, key entry points, and configuration.
   - Identify the language(s), frameworks, and build systems in use.

2. **Map components and relationships.**
   - Identify the major modules, services, or packages.
   - Trace dependencies between them and understand data flow.
   - Document relevant execution paths.

3. **Analyze architecture and patterns.**
   - Identify the architectural style (layered, hexagonal, microservices, etc.).
   - Recognize design patterns and conventions in use.
   - Evaluate component boundaries and cohesion.

4. **Evaluate trade-offs and risks.**
   - Assess scalability, maintainability, and performance concerns.
   - Compare alternative approaches where applicable.
   - Identify technical debt or areas of risk.

5. **Summarize findings.**
   - Provide a clear overview of the codebase structure.
   - Highlight key architectural decisions and their implications.
   - Make actionable recommendations where possible.

## Quality Criteria

- The report enables informed decisions about downstream work in the codebase.
- All important components and their relationships are documented.
- Architectural risks and trade-offs are explicitly called out.
- Recommendations are specific, not generic.

## Anti-Patterns

- **Surface-level scan**: Only listing directories without understanding relationships.
- **Over-analysis**: Spending too much time on irrelevant details instead of what matters for the task.
- **No synthesis**: Providing facts without interpretation or recommendations.
- **Prescription without context**: Recommending architectural changes without understanding constraints.

## Related Skills

- `mimir-dependency-analysis` — for assessing dependencies discovered during exploration.
- `mimir-web-research` — for researching external documentation or standards.
- `mimir-performance-analysis` — for deeper performance investigation.
- `mimir-security-analysis` — for security concerns discovered during exploration.