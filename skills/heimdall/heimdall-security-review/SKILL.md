---
name: heimdall-security-review
description: Review implementations for vulnerabilities, security risks, and compliance with security best practices.
---

# Security Review

## Purpose

Independently assess implementations and designs for security vulnerabilities, unsafe practices, and compliance with security best practices. This is a validation skill: it reviews delivered work and changes against security standards and prior analysis findings — open-ended investigation of existing systems belongs to a prior security analysis.

## When to Use

- Before releasing code that handles authentication, authorization, or sensitive data.
- When reviewing changes that process user input or external data.
- After a prior security analysis, to validate that identified risks were addressed in the implementation.
- To confirm security-sensitive changes are safe to deploy.

## Workflow

1. **Understand the security context.**
   - Review what data is involved and its sensitivity level.
   - Identify trust boundaries and entry points.

2. **Review authentication and access controls.**
   - Verify that authentication is required where expected.
   - Check that authorization checks are consistent and not bypassable.
   - Review session management, tokens, and credential handling.

3. **Analyze input and output handling.**
   - Check for injection vulnerabilities (SQL, command, XSS, template).
   - Verify input validation and output encoding.
   - Review file handling, uploads, and data deserialization.

4. **Assess configuration and secrets management.**
   - Check for hardcoded secrets, insecure defaults, or debug endpoints.
   - Verify encryption practices for data at rest and in transit.
   - Review logging for sensitive data exposure.

5. **Document findings.**
   - Report vulnerabilities with severity, impact, and exploitability.
   - Provide clear, actionable remediation guidance.
   - Note any areas that need deeper investigation.

## Quality Criteria

- Each entry point and trust boundary is explicitly reviewed.
- Vulnerabilities are categorized by severity with clear rationale.
- Recommendations include specific code or configuration changes where possible.
- Common vulnerability classes are systematically checked (OWASP Top 10 or equivalent).

## Anti-Patterns

- **Assuming external security**: Relying on firewalls, WAFs, or infrastructure instead of application-level security.
- **Penetration-test-only mindset**: Only looking for exploitable bugs, not design-level flaws.
- **False sense of completeness**: Claiming an application is "secure" instead of "secure against known threat models."
- **Alert fatigue**: Flagging low-severity issues while missing critical vulnerabilities.

## Related Skills

- `heimdall-api-contract-review` — when reviewing API authentication and authorization
- `heimdall-architecture-review` — when security concerns affect system architecture
- `heimdall-code-review` — for general code review of the same changes
- `heimdall-dependency-review` — for reviewing dependency-related security concerns
