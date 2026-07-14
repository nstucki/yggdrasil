---
name: heimdall-dependency-review
description: Review project dependencies for security, licensing, maintenance health, and version compatibility.
---

# Dependency Review

## Purpose

Review project dependencies to identify risks related to security, licensing, maintenance status, and version compatibility. This is a validation skill: it assesses dependency decisions and changes that have been delivered (or proposed for adoption) against quality standards and prior analysis findings — open-ended investigation and technology comparison belongs to a prior dependency analysis.

## When to Use

- When new dependencies are being introduced to a project.
- When reviewing a project's existing dependency set for health.
- Before major version upgrades or migration decisions.
- When an independent assessment of dependency risk is needed.

## Workflow

1. **Inventory the dependencies.**
   - Identify direct and transitive dependencies relevant to the review scope.
   - Note the current versions and resolution strategies (pinned, range, lock file).

2. **Check for security vulnerabilities.**
   - Consult vulnerability databases (CVE, GitHub Advisory, OSV) for known issues.
   - Check whether the versions in use are affected.
   - Evaluate severity and exploitability in the project's context.

3. **Evaluate maintenance health.**
   - Check release frequency and recent activity.
   - Review number of maintainers and bus factor.
   - Assess issue and PR response times.
   - Note the project's maturity and adoption.

4. **Assess licensing and compatibility.**
   - Verify licenses are compatible with the project's usage model.
   - Check for breaking changes and evaluate migration risk.
   - Consider alternatives if the dependency is high-risk.

5. **Document findings.**
   - List dependencies by risk level (critical, high, medium, low).
   - Provide specific recommendations (upgrade, replace, monitor, no action).
   - Reference sources for vulnerability or licensing claims.

## Quality Criteria

- Every dependency is assessed, not just the obvious ones.
- Vulnerability claims reference specific sources (CVE IDs, advisories).
- Recommendations are actionable and prioritized.
- Licensing concerns are checked for both direct and transitive dependencies.

## Anti-Patterns

- **Version blindness**: Approving dependencies without checking the specific versions in use for known issues.
- **Ignoring transitive deps**: Reviewing only direct dependencies, leaving the transitive tree unexamined.
- **Silent approval**: Not raising concerns about outdated or unmaintained dependencies.
- **False precision**: Accepting health scores without verifying the underlying evidence.
