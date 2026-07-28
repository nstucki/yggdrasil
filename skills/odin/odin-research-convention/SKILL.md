---
name: odin-research-convention
description: Define and apply a standing, source-agnostic convention for scoping research requests and grounding findings in verifiable proof.
---

# Research Convention

## Purpose

Establish a consistent, standing definition of "research". This convention ensures that research requests are scoped appropriately and executed against the correct sources of truth, reducing ambiguity and improving research quality.

## Standing Definition

Unless explicitly stated otherwise in a specific request, **research** is defined as gathering and verifying information from authoritative and contextual sources, with findings grounded in specific, verifiable proof.

### Source Tiers

Research sources fall into two tiers by authority:

**Authoritative sources** — where ground truth lives:
- The project's source tree and configuration (code, build artifacts, tests, dependencies)
- The system-of-record documentation for the project (architecture decisions, API specifications, operational procedures, team conventions)

**Contextual sources** — where intent and history live:
- Work-tracking systems (issue trackers, tickets, roadmaps)
- Decision logs, communication archives, and meeting notes

Findings from authoritative sources are definitive. Findings from contextual sources provide context and rationale but do not override authoritative sources.

### Parameterization

Each project or deployment maps its concrete systems onto these two tiers. The requesting context may name specific systems per request (e.g., "consult the internal wiki and the issue tracker"). If no systems are named, the standing default applies: start with authoritative sources, then consult contextual sources for history and intent.

### Example Instantiation

For reference, a typical instantiation in an organization using Codebase, Confluence, and Jira:

| System | Tier | Role |
|---|---|---|
| Codebase (source tree rooted at session working directory) | Authoritative | Source code structure, implementation details, patterns, configuration, tests, dependencies |
| Confluence (internal wiki/docs) | Authoritative | Architecture decisions, API specifications, deployment procedures, team conventions |
| Jira (issue tracker) | Contextual | Work history, current progress, roadmap, acceptance criteria, strategic direction |

This example is illustrative, not normative. Your project may use different systems or map them differently.

## Proof Requirements

Every research finding must be accompanied by verifiable proof. This section defines valid proof formats and validation rules.

### Proof Principles

1. **Every claim requires proof** — No finding can be reported without a corresponding proof reference.
2. **Proofs must be specific** — Vague citations (e.g., "the codebase", "the docs") are not acceptable.
3. **Unverifiable claims must be marked** — If a claim cannot be verified against a source, mark it as `[UNVERIFIED]` with a brief explanation of why verification was not possible.

### Valid Proof Formats by Source Kind

| Source Kind | Valid Proof Format | Example Shape |
|---|---|---|
| File-based (code, config, local docs) | Path + line numbers | `src/foo.ts:42-58` |
| Web/document system | Full, resolvable URL or stable page identifier | `https://docs.example.com/page-id` |
| Tracker/registry (issues, tickets, packages) | Unique key or full URL | `PROJ-1234` or `https://tracker.example.com/browse/PROJ-1234` |
| Data/API (databases, telemetry, endpoints) | Query/request + retrieval timestamp | `SELECT … @ 2026-07-28` |
| Ephemeral/human (meetings, chat) | Dated, attributed reference — or mark `[UNVERIFIED]` | `standup 2026-07-21, per <role>` |

### Proof Examples

**File-based Proof (Good):**
```
The Button component accepts a `disabled` prop (src/components/Button.tsx:15-20).
```

**File-based Proof (Bad):**
```
The Button component has a disabled prop (see Button.tsx).
```
*Missing line numbers; not specific enough.*

**URL-based Proof (Good):**
```
According to the API Design Guide (https://docs.example.com/api-design), 
all endpoints must return a 200 status on success.
```

**URL-based Proof (Bad):**
```
The documentation says endpoints should return 200 (see the docs).
```
*Missing full URL; not resolvable.*

**Unverifiable Claim (Good):**
```
The team prefers TypeScript over JavaScript [UNVERIFIED — no explicit documentation found; 
based on codebase observation that all new files are .ts/.tsx].
```

## When to Use

This convention applies to **all research requests** unless the user explicitly states otherwise. Examples of explicit overrides:

- "Research external libraries and frameworks" (external research)
- "Investigate third-party API documentation" (external research)
- "Research industry best practices" (external research)
- "Research only the issue tracker, ignore code" (scoped override)

## Workflow

1. **Receive research request** from a user.
2. **Check for explicit scope override** — if present, apply the stated scope instead.
3. **If no override, apply the standing convention:**
   - Start with authoritative sources (project source tree and system-of-record documentation)
   - Consult contextual sources (work-tracking systems, decision logs) for history and intent
   - Authoritative findings override contextual ones
4. **Attach proof per Proof Requirements** — Include specific file paths with line numbers, full URLs, or unique keys. Mark any unverifiable claims with `[UNVERIFIED]` and explain why verification was not possible.
5. **Self-validate proofs before reporting** — Verify that file paths exist and line numbers are accurate, URLs resolve to valid pages, keys are valid and accessible. Flag any broken or stale proofs.

## Quality Criteria

- Research is scoped to the standing definition unless explicitly overridden.
- Every finding has verifiable proof per Proof Requirements — No finding without proof or `[UNVERIFIED]` marker.
- Proofs are specific, not vague — File paths include line numbers, URLs are complete and resolvable, keys are exact and identifiable.
- Authoritative sources are consulted before or alongside contextual sources.
- Ambiguous requests are clarified with the requesting agent before proceeding.

## Anti-Patterns

- **Ignoring the convention** — Researching external sources when internal sources are the standing default.
- **Context-first research** — Using contextual sources as authoritative when authoritative sources are available.
- **Unproven findings** — Reporting a claim with no proof reference at all.
- **Vague citations** — Citing "the codebase" or "the documentation" without specific file paths, line numbers, or URLs.
- **Stale proofs** — Citing files or pages that no longer exist without flagging them as broken or marking the claim as `[UNVERIFIED]`.
- **Scope creep** — Expanding research beyond the stated or standing scope without explicit approval.

## Review Requirements for Proofs

Reviewers must validate all research outputs against the following proof checklist before approving findings.

### Reviewer Proof Validation Checklist

**1. Completeness**
- [ ] Every finding has a proof reference (file path, URL, key, or timestamp)
- [ ] No findings are missing proof or `[UNVERIFIED]` markers
- [ ] All `[UNVERIFIED]` claims include an explanation

**2. Specificity**
- [ ] Each proof meets the format for its source kind (path+lines, resolvable URL/identifier, exact key, query+timestamp)
- [ ] No vague references like "the codebase" or "the docs"

**3. Spot-Check (Verify at least 2 proofs)**
- [ ] Verify that at least 2 proofs resolve to their claimed sources (paths exist, URLs load, keys are valid)

**4. Unverified Ratio**
- [ ] Count the total number of `[UNVERIFIED]` claims
- [ ] Calculate ratio: unverified claims / total claims
- [ ] Flag if ratio exceeds 25% (more than 1 in 4 claims unverified)

### Review Outcomes

- **PASS** — All proofs are complete, specific, spot-checked, and unverified ratio is ≤25%.
- **PASS-WITH-NOTES** — Proofs are mostly complete and specific, but minor gaps exist (e.g., one vague citation, unverified ratio at 20-25%). Request clarification or improvement before merging.
- **BLOCKED** — Critical proof gaps exist (e.g., >25% unverified, multiple vague citations, broken file paths). Reject and request resubmission with complete proofs.
