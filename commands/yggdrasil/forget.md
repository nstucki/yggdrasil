---
description: "arg: scope (required)"
agent: Odin (Interactive)
subtask: false
---

Memory deletion request (destructive; runs the confirmed, reviewed deletion
pipeline — never instant).

Requested scope: $ARGUMENTS

Execute the forget pattern defined in your memory conventions, with these
non-negotiable guardrails:
1. If the scope above is empty or ambiguous, do NOT proceed — ask the user
   to name an explicit scope (topic, staleness filter, or full wipe).
2. Resolve the scope to the exact list of entries affected, present that
   list to the user, and obtain explicit confirmation BEFORE any deletion
   is dispatched. This command invocation is intent, not confirmation.
3. The deletion is implemented by the implementer and the resulting diff
   reviewed for exact-scope fidelity before it is final.
4. Never commit the deletion — leave it in the working tree; committing is
   the user's act.
5. Full wipe requires an interaction-capable mode and a second confirmation.
- If no knowledge base exists at `.yggdrasil-memory/`, offer to establish it.
