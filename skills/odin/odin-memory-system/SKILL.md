---
name: odin-memory-system
description: Orchestration doctrine for memory promotion, consolidation, and deletion operations triggered by user commands.
---

# Memory System

## Purpose

Define the orchestration doctrine for the three command-triggered memory operations — Remember (promotion), Dream (consolidation), and Forget (deletion). Each operation is an orchestrated, reviewed pipeline that dispatches to specialists; this skill specifies the agent roles, review gates, and guardrails for each.

The write-side implementation — how entries are physically written, the entry frontmatter schema, the directory structure, the canonical `README.md` template — is governed by the `brokk-memory-curation` skill loaded by the implementer. This skill is the orchestration doctrine (which agents to dispatch, review gates, guardrails); that skill is the implementation reference.

## When to Use

- **Remember** — when a memory-promotion command (`/yggdrasil/remember`) or an equivalent natural-language request ("remember this finding") is received.
- **Dream** — when a memory-consolidation command (`/yggdrasil/dream`) is received, or when you proactively suggest consolidation to the user (e.g., after a subagent reports a contradiction with an `active`-status memory entry).
- **Forget** — when a memory-deletion instruction is received, whether via command or natural language, naming an explicit scope.

Do **not** load this skill for ordinary tasks where subagents consult memory autonomously (Recall) — that is handled by the standing convention in the system prompt.

All three operations presuppose an existing knowledge base at `.yggdrasil-memory/` rooted at the current working directory. **Fail-safe establishment:** If `.yggdrasil-memory/` is absent at the root of the current working directory when a memory command is invoked, inform the user and offer to establish it (scaffolded by the implementer per the `brokk-memory-curation` skill's canonical templates) before any write operation proceeds. This is what makes globally installed memory commands safe in host projects with no memory directory.

## Workflow

### Remember (promotion)

A user-triggered operation — initiated only by explicit user request via the `/yggdrasil/remember` command or an equivalent natural-language request; **never launched automatically at task wrap-up**. Only reviewed research is eligible.

1. If a subject is given, promote that finding/topic/artifact. If the subject is empty, identify durable findings from the current task's reviewed research, propose the promotion list to the user, and proceed only on approval.
2. Task the implementer to distill the Heimdall-passed findings into memory entries, citing sources.
3. Heimdall reviews the memory write before it is final.
4. **Never promote secrets or credentials.**
5. When Heimdall-passed research from the current task contains durable findings worth retaining, you may flag this in the final deliverable as a single informational line (e.g., pointing the user to `/yggdrasil/remember`) — suggest, never launch the pipeline — mirroring the Dream operation's suggest-but-don't-trigger pattern.

### Dream (consolidation)

A user-triggered maintenance task (you may suggest it). Runs the standard Research → Implement → Review pattern. An optional focus scope (topic, area, or subset of entries) may narrow the audit; when omitted, the entire knowledge base is audited:

1. Task the researcher to audit the knowledge base for duplicates, contradictions, and staleness, re-verifying claims against current sources.
2. Heimdall reviews the audit before any action is taken on it.
3. Task the implementer to consolidate per the reviewed audit — merge, prune by reviewed judgment, or reorganize as warranted.
4. Heimdall reviews the resulting memory diff for fidelity before it is final.
5. Dream prunes by reviewed judgment but never silently performs a forget — deletion of user-named scope is a separate, explicitly confirmed operation.

### Forget (deletion)

Explicit user instruction naming a scope. Never autonomous; never chains from another operation.

1. If the scope is empty or ambiguous, do **not** proceed — ask the user to name an explicit scope (topic, staleness filter, or full wipe).
2. Resolve the scope to the exact list of entries affected, present that list to the user, and obtain explicit confirmation before any deletion is dispatched. The command invocation is intent, not confirmation.
3. Task the implementer to delete exactly the confirmed scope.
4. Heimdall reviews the diff for exact-scope fidelity before it is final.
5. **Never commit the deletion** — leave it in the working tree; committing is the user's act.
6. Full wipe requires an interaction-capable mode and a second confirmation.

## Quality Criteria

- **Only reviewed research is eligible for promotion.** No entry is written without a distinct upstream reviewed artifact backing it.
- **Every write is reviewed.** Promotion, consolidation, and deletion each pass through a Heimdall review gate before they are final.
- **Never promote secrets or credentials.** Entries are git-tracked by default and visible in diffs.
- **Forget is always confirmed.** The exact list of entries to be deleted is presented to the user and explicitly confirmed before any deletion is dispatched.
- **Never commit deletions.** Changes are left in the working tree; committing is the user's act.
- **Dream never silently forgets.** Deletion of user-named scope is a separate, explicitly confirmed operation (Forget), not a side effect of consolidation.
- **Full wipe requires an interaction-capable mode and a second confirmation.**

## Anti-Patterns

- **Auto-launching Remember at task wrap-up.** Promotion is user-triggered only. You may suggest it as a single informational line in the final deliverable; never launch the pipeline without explicit user request.
- **Chaining Forget into Dream or any other operation.** Dream prunes by reviewed judgment; Forget obeys explicit, confirmed instruction. Keep the semantics separate. Never silently delete entries as a side effect of Dream.
- **Committing deletions.** Forget leaves changes in the working tree. Committing is the user's act, never the agent's.
- **Promoting without a reviewed source.** No entry may be created or modified without a distinct upstream reviewed artifact backing it. If you are tempted to write something without a reviewed source, it does not belong in memory yet.
- **Expanding Forget scope beyond what was confirmed.** Delete exactly the confirmed list, nothing more. Never infer "related" or "probably stale" entries to delete alongside the confirmed scope.
- **Skipping the review gate.** Every write operation — promotion, consolidation, deletion — must pass through Heimdall review before it is final. No exceptions.
