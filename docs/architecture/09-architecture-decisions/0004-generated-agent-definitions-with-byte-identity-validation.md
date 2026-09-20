# ADR-0004: Generated agent definitions with byte-identity validation

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `scripts/README.md:5-160`; `scripts/generate-subagents.sh:70, 103-145`; listings of `scripts/odin-generator/` and `scripts/subagent-generator/`)

## Context

Eight agent files share large blocks of doctrine: the three Odin modes share everything but their Communication Policy; the five subagents share the Workspace, Memory, and tooling sections. Hand-maintained copies drift. The forces: goal 3 (reproducibility) and the parity invariants that validator Checks 5–7 depend on.

## Decision

All files under `agents/` are generated and never edited directly. `generate-odin-agents.sh` concatenates `preamble.template.md` (with `{{MODE_TITLE}}`/`{{DESCRIPTION}}` substituted), `shared-body.template.md`, and `communication-policy-{mode}.fragment.md`. `generate-subagents.sh` concatenates `{agent}.template.md`, `workspace.fragment.md`, `tooling.fragment.md` (Workfile-authoring agents only — not Brokk), `memory.fragment.md`, and `{agent}.workflow.template.md`. Both are pure `cat` + `sed`. `validate.sh` Check 4 and two smoke tests assert that the committed files are byte-identical to generator output; the maintainer workflow is edit source → regenerate → validate → commit.

## Consequences

- **Positive:** One edit to a shared fragment updates every agent; drift is impossible to commit unnoticed; the generators are transparent enough to audit by reading.
- **Negative:** Contributors must know the rule; the generator's documentation has already drifted from the script (§11 R1).
- **Becomes harder:** Per-agent deviations from a shared fragment — they require a new fragment or a template-level conditional such as the tooling-fragment gate.

## Related

§2 C4, §5.1.7, §5.2, §8.8 · ADR-0007 · `scripts/generate-subagents.sh:103-121`
