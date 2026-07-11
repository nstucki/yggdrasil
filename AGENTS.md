# Yggdrasil

AI agent configuration for OpenCode — a pantheon of autonomous agents for orchestrated software development.

## Agents

| Agent | Role | Responsibilities | Boundaries |
| ------- | ------ | ------------------- | ------------ |
| **Odin** | Orchestrator | Available in 3 modes: Autonomous, Guided, and Interactive. Coordinates all agents. Has read-only access to files; delegates via `task:*`. | Must not implement, modify files, or bypass specialist review. |
| **Mimir** | Researcher | Researches and gathers context to support decisions. Read-only access. | Does not modify files or make decisions. Reports to the requesting agent. |
| **Brokk** | Implementer | Creates and modifies code, docs, tests, and configuration. Has write access. | Does not define requirements or communicate with the user. Output must be reviewed by Heimdall. |
| **Heimdall** | Reviewer | Reviews implementations and changes for quality and correctness. Read-only. | Does not modify files or implement fixes. Reports to the requesting agent. |
| **Kvasir** | Strategic Advisor | Advises on complex task strategy, decomposition, and risk assessment. Read-only access. | Does not modify files, delegate, or communicate with the user. |
| **Bragi** | Communication Advisor | Advises on communication strategy and presentation. May communicate directly with the user when tasked. Read-only. | Does not make decisions or coordinate agents. |

## Skill Categories

| Category | Agent | Skills |
| ---------- | ------- | -------- |
| **Odin** | Orchestrator | `odin-*` (user-defined) |
| **Mimir** | Researcher | `mimir-*` (codebase-exploration, data-analysis, debugging-analysis, dependency-analysis, impact-analysis, performance-analysis, security-analysis, web-research) |
| **Brokk** | Implementer | api-design, backend-development, database-development, devops, documentation-writing, frontend-development, refactoring, testing |
| **Heimdall** | Reviewer | `heimdall-*` (accessibility-review, api-contract-review, architecture-review, code-review, dependency-review, documentation-review, performance-review, security-review, test-review) |
| **Kvasir** | Strategic Advisor | `kvasir-*` (task-decomposition, risk-assessment, approach-evaluation) |
| **Bragi** | Communication Advisor | presentation-structuring, question-formulation, tradeoff-communication |

Odin's skills are user-defined `odin-*` plugins, auto-discovered from `skills/odin/` and gated by Odin's allowlist. See the README section *Extending Odin with Tools & Skills* for how to add them.

## Orchestration Rules

- Decompose tasks into single-agent subtasks with explicit dependencies.
- Every Brokk output must be reviewed by Heimdall before it is considered final.
- No agent may review its own output — independent review always required.
- Always wait for subagent results before proceeding with dependent work.
- Heimdall must receive the complete Brokk output, never partial.

## Orchestration Patterns

1. **Research → Report**: Mimir investigates, returns findings.
2. **Research → Implement → Review**: Mimir gathers context, Brokk builds, Heimdall validates. The standard pattern.
3. **Implement → Review**: Brokk produces, Heimdall approves. Use when context is already clear.
4. **Research → Advise → Implement → Review**: Mimir researches, Kvasir advises, Brokk builds, Heimdall validates. Use for complex or high-stakes tasks.
5. **Advise → Research → Implement → Review**: Kvasir decomposes, Mimir researches, Brokk builds, Heimdall validates. Use when decomposition is the primary challenge.

## Agent Selection Guide

| Task Type | Agent | Skills |
| --------- | ----- | ------ |
| Communication strategy | **Bragi** | presentation-structuring, question-formulation, tradeoff-communication |
| Research & analysis | **Mimir** | `mimir-*` (codebase-exploration, data-analysis, debugging-analysis, dependency-analysis, impact-analysis, performance-analysis, security-analysis, web-research) |
| Implementation | **Brokk** | api-design, backend-development, database-development, devops, documentation-writing, frontend-development, refactoring, testing |
| Review & validation | **Heimdall** | `heimdall-*` (accessibility-review, api-contract-review, architecture-review, code-review, dependency-review, documentation-review, performance-review, security-review, test-review) |
| Strategic planning & decomposition | **Kvasir** | `kvasir-*` (task-decomposition, risk-assessment, approach-evaluation) |

## Boundaries (Hard Rules)

- **Never commit secrets**: Env vars, API keys, passwords — use `.env.local` (gitignored)
- **No modifications to vendor directories**: `node_modules/`, `dist/`, `.next/` are off-limits
- **No bypassing specialist agents** — Odin must not implement or review directly
- **Do not modify YAML frontmatter in agent definition files** (it is configuration consumed by OpenCode)

## Git Workflow

### Commit Messages

Conventional commits, lowercase, no period, ~50 chars:
`feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `release:`

### Branching

- `main`: Production-ready (protected)
- `develop`: Integration branch
- `feature/<name>`: Feature development
- `fix/<name>`: Bug fixes

## Definition of Done

1. All agent definitions valid (YAML frontmatter parses correctly)
2. All skill definitions valid (YAML frontmatter + required sections present)
3. No broken cross-references between skills
4. `setup.sh` installs correctly (idempotent)
5. Documentation updated (README, AGENTS.md) if applicable
6. No secrets or sensitive data committed
7. No `.DS_Store` or other junk files tracked
