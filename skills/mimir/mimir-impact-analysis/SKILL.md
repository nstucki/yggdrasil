---
name: mimir-impact-analysis
description: Analyze the blast radius and risk of proposed changes.
---

# Impact Analysis

## Purpose

Determine which files, modules, services, and tests would be affected by a proposed change. Assess the risk and scope before implementation begins.

## When to Use

- Before implementing a change that may affect multiple modules or services.
- When assessing the risk of a refactoring or migration.
- When planning a dependency upgrade or API change.
- When evaluating whether a fix might introduce regressions.

## Workflow

1. **Define the proposed change.**
   - Identify the specific files, functions, or interfaces to be modified.
   - Document the nature of the change (addition, modification, removal, rename).
2. **Trace dependencies and references.**
   - Find all imports, calls, and references to the affected code.
   - Identify transitive dependencies — code that depends on code that depends on the change.
   - Check for dynamic references (reflection, string-based lookups, dependency injection).
3. **Assess test coverage impact.**
   - Identify existing tests that cover the affected code.
   - Determine which tests need updating and which new tests are needed.
   - Flag areas with no test coverage that would be affected.
4. **Evaluate risk and scope.**
   - Classify the change scope (isolated, module-level, cross-module, system-wide).
   - Identify high-risk areas (shared utilities, public APIs, hot paths).
   - Flag potential breaking changes for consumers.
5. **Report the impact assessment.**
   - List all affected files grouped by module or service.
   - Summarize risk level and recommended approach (incremental vs. big-bang).
   - Identify safe-to-change areas and areas requiring extra caution.

## Quality Criteria

- Both direct and transitive impacts are identified.
- Dynamic references are considered, not just static imports.
- Test coverage gaps in affected areas are flagged.
- Risk assessment is specific and actionable.

## Anti-Patterns

- **Shallow tracing**: Only checking direct imports, missing transitive dependencies.
- **Ignoring dynamic references**: Missing reflection, string-based lookups, or runtime wiring.
- **Scope underestimation**: Assuming a change is isolated without verifying.
- **Skipping test impact**: Not identifying which tests need updating.
