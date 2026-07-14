---
name: brokk-database-development
description: Design and implement database schemas, queries, migrations, and data access logic.
---

# Database Development

## Purpose

Design and implement database schemas, migrations, queries, and data access layers that are reliable, performant, and maintainable.

## When to Use

- When designing new database schemas or data models.
- When creating or modifying migrations.
- When implementing data access logic or complex queries.
- When optimizing database performance or data integrity.

## Workflow

1. **Understand the data model.**
   - Review the entities, relationships, and access patterns.
   - Identify constraints, indexes, and data integrity requirements.

2. **Design the schema.**
   - Define tables, columns, types, and relationships.
   - Plan indexes based on query patterns.
   - Consider data growth, partitioning, and archiving needs.

3. **Implement migrations.**
   - Create reversible migrations (up and down).
   - Handle data backfills and transformations carefully.
   - Test migrations against realistic data volumes.

4. **Write data access logic.**
   - Implement queries, repositories, or data access objects.
   - Use parameterized queries to prevent injection.
   - Optimize for the access patterns (eager loading, batching, pagination).

5. **Verify correctness and performance.**
   - Test queries against realistic data.
   - Check query plans for full table scans or missing indexes.
   - Verify data integrity constraints are enforced.

6. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- Migrations are reversible and tested.
- Queries use indexes effectively and avoid common pitfalls (N+1, full scans).
- Data integrity is enforced at the database level where appropriate.
- Schema changes are backward-compatible where required.

## Anti-Patterns

- **Schema-as-afterthought**: Designing the schema without understanding access patterns.
- **God table**: Creating overly broad tables with many nullable columns instead of normalized designs.
- **Migration fear**: Avoiding schema changes because migrations are risky or untested.
- **Raw SQL everywhere**: Not using the ORM or query builder consistently.
