# 5.1.3 Blackbox Odin prompt templates

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§5](README.md)._

- **Purpose:** register the workflow in `§ Workflows` and complete its thresholds per Odin variant.
- **Provided interface (edits):**
  - `scripts/odin-generator/shared-body.template.md`, § Workflows (currently lines 145–182): add `### Architecture` between `### Research` and `### Software Engineering` with: one-paragraph description; `**Triggering verdict:**` I-4; `**Invariant trigger rules:**` — `/yggdrasil/architect` → invoke; explicit document-the-architecture / as-is arc42 / decide-the-architecture / ADR language **without implementation intent** → invoke; the same language **with** implementation intent → skip here (Engineering check owns it); a request to understand/explain a codebase's structure that has no architecture document is the suggestion candidate; a pure research request or a question → skip. `**On invoke:**` load `odin-architecture-workflow`. Amend the Software Engineering paragraph (line 176) "gated by its own design review" → "delegated to the Architecture workflow, which carries its own design review".
  - `communication-policy-{interactive,guided,autonomous}.fragment.md` § Trigger Thresholds: add `/yggdrasil/architect` to the **Commands** line; add `**Architecture suggestion candidate:**` (interactive/guided: suggest; autonomous: skip) and `**Architecture ratification checkpoint:**` (interactive: pause; guided/autonomous: auto-proceed, summary rides the Deliverable).
  - Then `scripts/generate-odin-agents.sh`; `validate.sh` Check 4 must pass; consider adding one invariant marker string for Check 7 (open issue).
- **Location:** paths above; generated outputs `agents/odin-{autonomous,guided,interactive}.md` (never hand-edited).
- **Fulfilled AC:** AC-2. **Open issues:** Check 7 marker list not read (gap).
