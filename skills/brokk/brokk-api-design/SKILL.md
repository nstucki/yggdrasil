---
name: brokk-api-design
description: Design and implement API specifications, contracts, and server interfaces following best practices.
---

# API Design

## Purpose

Design and implement APIs that are consistent, predictable, and easy to consume. This covers contract-first design, versioning strategies, request/response modeling, and SDK generation.

## When to Use

- When creating new API endpoints or services.
- When designing or modifying API contracts (OpenAPI, GraphQL, protobuf).
- Before implementing server logic — to ensure the contract is sound first.
- When updating existing APIs to maintain consistency and versioning.

## Workflow

1. **Understand the consumers and use cases.**
   - Identify who will consume the API (internal services, third-party developers, frontend).
   - Understand the operations they need and the data they require.
   - Consider performance requirements (pagination, filtering, caching).

2. **Design the contract first.**
   - Define endpoints, operations, and their signatures before writing implementation code.
   - Model request and response schemas with clear types, constraints, and examples.
   - Use consistent naming conventions across the entire API surface.

3. **Apply API design principles.**
   - Follow RESTful conventions (resources, HTTP methods, status codes) or the chosen paradigm's best practices.
   - Design for evolvability: use versioning, avoid breaking changes, add fields rather than modifying existing ones.
   - Keep responses focused — include what clients need, not everything from the data model.

4. **Document and verify.**
   - Ensure the contract is self-documenting with clear descriptions and examples.
   - Validate the specification against schema standards (e.g., OpenAPI validation).
   - Consider generating client SDKs or type definitions from the contract.

5. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- The contract is designed before implementation begins.
- All endpoints have defined request and response schemas with types and constraints.
- Error responses are consistent across all endpoints.
- Breaking changes are avoided or explicitly versioned.
- The specification passes schema validation.

## Anti-Patterns

- **Implementation-first**: Letting server code define the API, resulting in inconsistent or leaky contracts.
- **Under-specification**: Omitting types, constraints, or examples from the contract.
- **Copy-paste APIs**: Repeating similar patterns instead of designing shared models.
- **Ignoring consumers**: Designing APIs based on the data model rather than client needs.
