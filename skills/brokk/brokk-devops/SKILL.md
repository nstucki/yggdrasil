---
name: brokk-devops
description: Implement deployment, infrastructure, automation, and operational workflows.
---

# DevOps

## Purpose

Build and maintain deployment pipelines, infrastructure configuration, automation, and operational tooling for reliable and repeatable delivery.

## When to Use

- When setting up or modifying deployment workflows.
- When configuring infrastructure (containers, networking, storage).
- When automating operational tasks (backups, monitoring, alerting).
- When an infrastructure or deployment approach has been approved and needs implementation.

## Workflow

1. **Understand the requirements.**
   - Review the deployment model, environment topology, and scaling needs.
   - Identify compliance, security, and observability requirements.

2. **Configure infrastructure.**
   - Define infrastructure as code (Terraform, CloudFormation, Kubernetes manifests).
   - Set up networking, storage, compute, and access controls.
   - Follow least-privilege principles for permissions and secrets.

3. **Implement deployment pipelines.**
   - Set up CI/CD workflows for building, testing, and deploying.
   - Configure environment promotion (development, staging, production).
   - Implement rollback strategies and health checks.

4. **Set up observability.**
   - Configure logging, metrics, and monitoring.
   - Set up alerting for key indicators and error rates.
   - Document runbooks for common operational tasks.

5. **Verify the setup.**
   - Test the deployment pipeline end-to-end.
   - Verify monitoring and alerting are firing correctly.
   - Document the infrastructure and operational procedures.

6. **Report.** Summarize completed work and remaining concerns to the requesting agent.

## Quality Criteria

- Infrastructure is defined as code, not configured manually.
- Deployment pipelines are automated and reproducible.
- Monitoring and alerting cover key health indicators.
- Rollback procedures are tested and documented.

## Anti-Patterns

- **Snowflake environments**: Environments that are manually configured and cannot be reproduced.
- **Pet vs. cattle**: Treating servers as unique and irreplaceable instead of disposable.
- **Secret sprawl**: Hardcoding or poorly managing secrets and credentials.
- **Alert fatigue**: Setting up too many alerts that get ignored.

## Related Skills

- `brokk-backend-development` — for the applications being deployed
- `brokk-documentation-writing` — for documenting infrastructure and runbooks
- `brokk-testing` — for integrating tests into the deployment pipeline
