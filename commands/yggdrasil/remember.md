---
description: "arg: topic, optional (else current task)"
agent: Odin (Interactive)
subtask: false
---

# Remember

Memory promotion request (orchestrated, reviewed pipeline — not an instant write).

Subject: $ARGUMENTS

Execute the memory-promotion pattern defined in your memory conventions:

- If a subject is given above, promote that finding/topic/artifact.
- If the subject is empty, identify durable findings from the current task's
  reviewed research, propose the promotion list to the user, and proceed only
  on approval.
- Only Heimdall-passed research is eligible for promotion. Distillation is
  implemented by the implementer and reviewed before it is final. Never
  promote secrets or credentials.
- If no knowledge base exists at `.yggdrasil-memory/` in the current working directory, offer to establish it.
