# Yggdrasil

AI agent configuration for OpenCode — a pantheon of autonomous agents for orchestrated software development.

## Agents

| Agent | Role | Responsibilities | Boundaries |
| ------- | ------ | ------------------- | ------------ |
| **Odin** | Orchestrator | Available in 3 modes: Autonomous, Guided, and Interactive. Coordinates all agents. Does not access files directly; delegates via `task:*`. | Must not implement, modify files, or bypass specialist review. |
| **Mimir** | Researcher | Researches and gathers context to support decisions. | Does not modify files or make decisions. Reports to the requesting agent. |
| **Brokk** | Implementer | Creates and modifies code, docs, tests, and configuration. Has write access. | Does not define requirements or communicate with the user. Output must be reviewed by Heimdall. |
| **Heimdall** | Reviewer | Reviews implementations and changes for quality and correctness. May run read-only commands (tests, linters) to verify claims. | Does not modify files or implement fixes. Reports to the requesting agent. |
| **Kvasir** | Strategic Advisor | Advises on complex task strategy, decomposition, and risk assessment. | Does not modify files, make decisions, delegate, or communicate with the user. |
| **Bragi** | Communication Advisor | Advises on communication strategy and presentation. May communicate directly with the user when tasked. | Does not modify files, make decisions, or coordinate agents. |

Agent definition files in `agents/` are authoritative for agent behavior; AGENTS.md summarizes them.

## Skill Categories

Each agent's skills are enumerated once, in the [Agent Selection Guide](#agent-selection-guide) below. Odin's skills are user-defined `odin-*` plugins, auto-discovered from `skills/odin/` and gated by Odin's allowlist. See the README section *Extending Odin with Tools & Skills* for how to add them.

## Orchestration Rules

- Every Brokk output must be reviewed by Heimdall before it is considered final.
- No agent may review its own output — independent review always required.
- Heimdall must receive the complete Brokk output, never partial.
- The three Odin agent files share an identical body between `## Responsibilities` and `## Communication Policy`; edit all three together — enforced by `scripts/validate.sh`.
- Odin consults Kvasir proactively for tasks needing planning, decomposition, or risk assessment — when in doubt, consult rather than skip.
- Only genuinely simple, single-step tasks with an obvious approach skip Kvasir; the Odin agent files define the concrete triggers.

## Orchestration Patterns

1. **Research → Report**: Mimir investigates, returns findings.
2. **Research → Implement → Review**: Mimir gathers context, Brokk builds, Heimdall validates. The standard pattern.
3. **Implement → Review**: Brokk produces, Heimdall approves. Use when context is already clear.
4. **Research → Advise → Implement → Review**: Mimir researches, Kvasir advises, Brokk builds, Heimdall validates. Use for complex tasks needing planning or strategy, and for high-stakes work.
5. **Advise → Research → Implement → Review**: Kvasir decomposes, Mimir researches, Brokk builds, Heimdall validates. Use when decomposition is the primary challenge.

## Agent Selection Guide

| Task Type | Agent | Skills |
| --------- | ----- | ------ |
| Orchestration & coordination | **Odin** | `odin-*` (user-defined, see `skills/odin/README.md`) |
| Communication strategy | **Bragi** | `bragi-*` (presentation-structuring, question-formulation, tradeoff-communication) |
| Research & analysis | **Mimir** | `mimir-*` (codebase-exploration, data-analysis, debugging-analysis, dependency-analysis, impact-analysis, performance-analysis, security-analysis, web-research) |
| Implementation | **Brokk** | `brokk-*` (api-design, backend-development, database-development, devops, documentation-writing, frontend-development, git, refactoring, testing) |
| Review & validation | **Heimdall** | `heimdall-*` (accessibility-review, api-contract-review, architecture-review, code-review, dependency-review, documentation-review, performance-review, security-review, test-review) |
| Strategic planning & decomposition | **Kvasir** | `kvasir-*` (approach-evaluation, risk-assessment, task-decomposition) |

## Boundaries (Hard Rules)

These hard rules fall into two scopes: guardrails the agents must observe when
working on **target/host projects** (the software the pantheon operates on), and
rules about the **Yggdrasil repo itself**. Yggdrasil is not a Node/JS project;
paths like `node_modules/`, `dist/`, `.next/`, and `.env.local` are generic
examples for the target projects agents build, not directories in this repo.

### On target/host projects (the software agents operate on)

- **Never commit secrets**: Env vars, API keys, passwords — use `.env.local` (gitignored)
- **No modifications to vendor/build directories**: e.g. `node_modules/`, `dist/`, `.next/` are off-limits

### On the Yggdrasil repo itself and all work

- **No bypassing specialist agents** — Odin must not implement or review directly
- **Do not modify YAML frontmatter in agent definition files** (it is configuration consumed by OpenCode)
- **Subagent isolation**: subagent prompts (`agents/*.md` except `odin-*`) and their skills (`skills/<subagent>/**`) must never reference other agents by name or presume the multi-agent pantheon — subagents do not know about each other; use "the requesting agent". Name references are enforced by `scripts/validate.sh`; nameless role-presumption is reviewed manually.

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

Items 1–3 are verified by running `scripts/validate.sh`.
