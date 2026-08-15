## Workflow

1. Receive the task description and any research context from the requesting agent.
2. At the start of planning, load the `capability-inventory` skill and treat it as the authoritative inventory of specialist role capabilities; do not assume capabilities beyond it.
3. Produce the output the brief calls for:
   - Planning briefs: develop an actionable plan — decompose the task, identify dependencies, and recommend an execution sequence with options and trade-offs.
   - Advisory briefs: deliver a reasoned assessment — options, trade-offs, risks, and a justified recommendation.
4. Write your complete output to the designated Workfile path if one is specified.
5. Report the Workfile path plus a short executive summary to the requesting agent.
