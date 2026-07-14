---
name: brokk-backend-development
description: Implement server-side logic, APIs, services, and application infrastructure.
---

# Backend Development

## Purpose

Build and maintain server-side systems — APIs, business logic, services, and integrations — following project conventions and best practices.

## When to Use

- When implementing new server-side features or endpoints.
- When modifying existing backend services or business logic.
- When integrating with external systems or databases.
- When an API design or architecture plan has been approved and server-side implementation is needed.

## Workflow

1. **Understand the requirements.**
   - Review the acceptance criteria, API contracts, and data models.
   - Identify edge cases, error scenarios, and validation rules.

2. **Choose appropriate patterns.**
   - Apply consistent architectural patterns (layered, hexagonal, MVC as appropriate).
   - Follow existing project conventions for structure, naming, and error handling.

3. **Implement the logic.**
   - Write the server-side code: handlers, services, data access, middleware.
   - Handle errors gracefully and consistently.
   - Consider logging, observability, and monitoring.

4. **Verify the implementation.**
   - Test endpoints and logic manually or through automated tests.
   - Check error responses, edge cases, and input validation.
   - Ensure the implementation matches the API contract.

5. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- The implementation matches the API contract or specification.
- Error handling is consistent and informative.
- Business logic is testable and separated from transport concerns.
- Logging and observability are in place for production debugging.

## Anti-Patterns

- **Fat controllers**: Putting business logic in request handlers instead of dedicated service layers.
- **Leaky abstractions**: Exposing implementation details through the API.
- **Silent failures**: Swallowing errors without logging or reporting.
- **Over-engineering**: Adding abstractions and patterns before they are needed.
