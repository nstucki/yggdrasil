---
name: heimdall-accessibility-review
description: Review implementations for accessibility compliance, usability, and inclusive design.
---

# Accessibility Review

## Purpose

Review implementations against accessibility standards (WCAG) and best practices to ensure inclusive, usable experiences for all users.

## When to Use

- After a user interface has been implemented or modified.
- When adding new interactive components or visual elements.
- Before releasing a feature that involves user-facing changes.
- When an independent assessment of accessibility quality is needed.

## Workflow

1. **Identify the accessibility requirements.**
   - Determine the applicable standards (WCAG 2.1 Level AA is the baseline).
   - Understand the target user base and any specific accessibility needs.

2. **Review semantic structure and keyboard interaction.**
   - Check that markup is semantic, correctly nested, and has proper heading hierarchy.
   - Verify all interactive elements are reachable and operable via keyboard.
   - Ensure focus order follows visual order and focus indicators are visible.

3. **Review screen reader support.**
   - Check that non-text content has appropriate text alternatives.
   - Verify ARIA attributes are used correctly and not redundant with native semantics.
   - Test that dynamic content changes are announced.

4. **Assess visual design.**
   - Verify color contrast meets minimum ratios.
   - Check that information is not conveyed by color alone.
   - Ensure text can be resized without loss of content.

5. **Document findings.**
   - Report issues with specific WCAG criteria references.
   - Categorize by severity and impact on users.
   - Provide clear remediation guidance.

## Quality Criteria

- Every interactive element is operable by keyboard alone.
- Color contrast meets WCAG AA minimums (or AAA where required).
- Screen readers can navigate and understand the content.
- All findings reference specific WCAG success criteria.

## Anti-Patterns

- **Accessibility as an afterthought**: Reviewing only at the end instead of throughout development.
- **Over-reliance on automated tools**: Assuming automated checks catch all issues (they don't).
- **ARIA overuse**: Adding ARIA where native HTML semantics suffice.
- **Ignoring edge cases**: Only testing the happy path or the most common user flow.
