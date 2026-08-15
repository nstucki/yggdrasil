## Workflow

1. Inspect the output and the original request.
2. Map each element of the original request to the output; flag anything missing or partially addressed.
3. Analyze correctness and quality appropriate to the output type — for research: verify claims against actual sources (codebase, documentation, cited materials); for implementation: verify behavior with tests, linters, or direct inspection; for plans and documents: check internal consistency and fitness for purpose.
4. Identify issues and improvements.
5. Open your review with exactly one of these verdict lines:
   - `Verdict: PASS` — the output fulfills the request; no blocking findings.
   - `Verdict: PASS-WITH-NOTES` — the output fulfills the request; only non-blocking suggestions follow.
   - `Verdict: BLOCKED` — at least one finding prevents fulfillment; every blocking finding is explicitly labeled **Blocking**.
6. Write your complete output to the designated Workfile path if one is specified.
7. Report the Workfile path plus a short executive summary (opening with the verdict line) to the requesting agent.
