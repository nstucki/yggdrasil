---
name: mimir-dependency-analysis
description: Analyze existing dependencies and evaluate new technologies for adoption.
---

# Dependency Analysis

## Purpose

Assess the health, security, and compatibility of existing dependencies. Evaluate new libraries, frameworks, and technologies for adoption — including comparison of alternatives and migration cost. This is an investigative skill: it examines the existing state and options before or independent of implementation, producing findings that inform decisions — validating delivered dependency changes is the concern of a subsequent dependency review.

## When to Use

- When assessing the health or risk of existing dependencies.
- When evaluating new libraries or frameworks for adoption.
- When comparing technology alternatives for a specific use case.
- When planning a migration or major dependency upgrade.

## Workflow

1. **Define the evaluation scope.**
   - Identify whether this is an audit of existing dependencies or an evaluation of new technologies.
   - For comparisons: define the evaluation criteria and weightings upfront.
2. **Inventory and assess dependencies.**
   - List direct and transitive dependencies with versions and lock file status.
   - For new technologies: identify candidates and their key characteristics.
3. **Evaluate maintenance and community health.**
   - Check release frequency, recent activity, and number of maintainers.
   - Assess bus factor, issue/PR responsiveness, and community size.
   - Look at maturity, adoption, and real-world usage.
4. **Assess risks and compatibility.**
   - Check for known vulnerabilities (reference CVE or advisory IDs).
   - Evaluate licensing concerns and compliance conflicts.
   - Check compatibility with the existing stack and platform.
   - For new technologies: assess integration complexity and migration cost.
5. **Report findings.**
   - Summarize health and risk for each dependency or technology.
   - For comparisons: present a ranked recommendation with trade-offs.
   - Prioritize risks and recommend concrete actions.

## Quality Criteria

- Both direct and transitive dependencies are considered.
- Vulnerability assessments reference specific CVE or advisory IDs.
- Recommendations are ranked by impact and effort.
- Trade-offs are presented clearly, not hidden.

## Anti-Patterns

- **Version blindness**: Ignoring whether dependencies are outdated or have known issues.
- **Ignoring transitive deps**: Assessing only direct dependencies, missing the full dependency tree.
- **Shiny object bias**: Recommending new technologies without evaluating stability or migration cost.
- **False precision**: Reporting health scores without citing concrete evidence.
