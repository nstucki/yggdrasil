---
description: "arg: scope (required)"
agent: Odin (Interactive)
subtask: false
---

# Forget

Memory deletion request (destructive; runs the confirmed, reviewed deletion pipeline — never instant).

Requested scope: $ARGUMENTS

Load the `odin-memory-system` skill and execute the forget pattern defined there, using the scope above. The skill's guardrails (explicit-scope requirement, confirmation before deletion, never commit) are non-negotiable.
