---
name: heimdall-api-contract-review
description: Review API specifications and contracts for consistency, correctness, and completeness.
---

# API Contract Review

## Purpose

Review API specifications (OpenAPI, GraphQL schemas, protobuf, etc.) for consistency, correctness, completeness, and adherence to conventions.

## When to Use

- After an API specification has been created or modified.
- Before implementing an API on the server or consuming it on the client.
- When reviewing changes that affect external or internal API contracts.
- To confirm an API design is sound before implementation begins.

## Workflow

1. **Understand the API's purpose.**
   - Review the intended consumers and use cases.
   - Understand the data model and business logic the API represents.

2. **Review the specification structure.**
   - Verify endpoints, operations, and paths follow RESTful or schema conventions.
   - Check that naming is consistent (resources, fields, operations).
   - Ensure versioning strategy is clear and applied consistently.

3. **Validate request/response models.**
   - Check that all required fields are documented and optional fields are explicitly marked.
   - Verify data types, formats, and constraints are correct and consistent.
   - Ensure error responses are defined for failure cases.

4. **Check consistency across the API surface.**
   - Verify that similar operations follow the same patterns (pagination, filtering, sorting).
   - Check that authentication and authorization are consistently applied.
   - Ensure deprecation policies are documented where applicable.

5. **Document findings.**
   - List issues with specific location references (path, operation, schema).
   - Categorize by impact (breaking change, inconsistency, documentation gap).
   - Provide clear remediation guidance.

## Quality Criteria

- All endpoints have complete request and response definitions.
- Error responses are defined for every failure mode (4xx, 5xx).
- Naming and patterns are consistent across the entire API surface.
- Breaking changes are explicitly called out and justified.

## Anti-Patterns

- **Design by implementation**: Letting server internals leak into the API contract.
- **Inconsistent patterns**: Using different approaches for similar operations.
- **Missing error models**: Only defining success responses.
- **Over-fetching/under-fetching**: API responses don't match client needs.
