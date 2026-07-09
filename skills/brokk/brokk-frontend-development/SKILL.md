---
name: brokk-frontend-development
description: Implement user interfaces, frontend logic, and client-side functionality.
---

# Frontend Development

## Purpose

Create and maintain user interfaces and client-side functionality that are usable, responsive, and consistent with the design system.

## When to Use

- When implementing new UI components, pages, or features.
- When modifying existing frontend functionality.
- When integrating with backend APIs or services.
- When a UX design or component plan has been approved and frontend implementation is needed.

## Workflow

1. **Understand the requirements.**
   - Review the design, user flows, and acceptance criteria.
   - Identify states: loading, empty, error, edge cases.

2. **Set up the component structure.**
   - Follow the project's component architecture and conventions.
   - Break the UI into composable, reusable components.
   - Manage state appropriately (local, shared, server state).

3. **Implement the interface.**
   - Build components with semantic, accessible markup.
   - Handle user interactions, validation, and feedback.
   - Integrate with backend APIs and services.

4. **Verify the implementation.**
   - Test across relevant screen sizes and browsers.
   - Check accessibility basics (keyboard navigation, screen reader).
   - Verify error and loading states are handled.

5. **Report completed work and remaining concerns to the requesting agent with a clear summary.**

## Quality Criteria

- Components match the design and acceptance criteria.
- The UI handles loading, empty, error, and edge case states.
- Keyboard navigation and basic accessibility are in place.
- State management is consistent and predictable.

## Anti-Patterns

- **Logic in components**: Putting business logic in UI components instead of separating concerns.
- **State sprawl**: Managing state in too many places without a clear strategy.
- **Accessibility afterthought**: Adding accessibility after the UI is built instead of during.
- **Over-abstraction**: Creating too many layers of components before they are needed.

## Related Skills

- `brokk-api-design` — for designing the APIs the frontend consumes
- `brokk-backend-development` — for the APIs the frontend consumes
- `brokk-documentation-writing` — for documenting UI components
- `brokk-testing` — for writing frontend tests
