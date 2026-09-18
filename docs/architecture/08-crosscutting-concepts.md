# 8. Cross-cutting Concepts

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 8.1 Mode line propagation

`Mode:` is set once in the shape verdict and echoed verbatim in every brief (Kvasir, Heimdall), the Workfile header (`- **Mode:** … (source: …)`), the return block, and the Response. A reviewer BLOCKs on a missing or mismatched header. This is the Clarity-of-Intent mechanism (AC-13, AC-14).

## 8.2 Caller contract and return block

Composition between Odin workflows is by **skill load within one Odin session**: the caller states I-1, executes the loaded workflow's steps, and consumes I-3. Skipped steps are recorded in the callee's shape verdict with reasons, never silently. Only these two lines are the coupling surface — engineering doctrine may reference them but never restate the callee's steps (Doctrine Minimization).

## 8.3 Review gating and status promotion

Every scaffold passes `heimdall-architecture-review` `Focus: scaffold` (the standing review the Brokk session requires, C-12); every architecture Workfile passes `Focus: document` before ratification, persistence, or consumption — inside the Architecture workflow, once; every persisted directory passes its `Focus: persistence` checklist, dispatched directly in a standalone run or loaded by name from the engineering integration review. All architecture checklists live in that one skill (ADR-0010). `Status: Proposed` is the only authored status in both modes; Brokk promotes ratified IDs to `Accepted` on persistence. Document-mode as-is ADRs follow the same lifecycle, with `Kind: as-is` making their nature explicit.

## 8.6 Feature-directory placement

Each workflow family owns one mandatory feature directory holding its Odin doctrine skill and the specialists that serve it; `skills/architecture/` joins `research/`, `deliberation/`, `engineering/`. Membership is registered in exactly two places (`setup.sh`, `validate.sh` `MANDATORY_SKILL_DIRS`); every cross-directory reference is by skill name, never by path (C-11), so a directory move is a `git mv` plus path-string updates (C-10, README) — never an edit to the skills that reference the moved ones (ADR-0009). A skill *rename* additionally changes its `name:` frontmatter and re-derives its Check 5 owner, so the renamed file must be re-scanned for foreign slugs (C-3).

## 8.7 Scaffold-then-fill

The arc42 Workfile is produced in two roles, in both modes and both invocation paths: the **scaffolder** (Brokk, `brokk-arc42-template`) instantiates the skeleton — headings, guidance, pre-filled header, existing-document shape, next ADR number, attribution notice — and the **drafter** (Kvasir, `kvasir-software-architecture`) fills it, prunes by judgment, and removes guidance and (when none survives) the attribution notice. Neither role loads the other's skill; the Workfile is the only hand-off, described by I-5. The **persister** (Brokk, `brokk-architecture-persistence`) later splits the same file into the project directory. Judgment stays with Kvasir; mechanics stay with Brokk (ADR-0011).

## 8.4 Verification of doctrine (in place of tests)

Mechanical: `scripts/validate.sh` (all ten checks) and a `generate-odin-agents.sh` diff. Judgment: Heimdall `system-prompt-review` for SKILL.md/prompt edits (simulation of both modes and both invocation paths), `documentation-review` for README. Acceptance is a checklist derived from the AC list, expressed per work package in Appendix B. See ADR-0007.

## 8.5 Generated-prompt discipline

Template → generator → committed agent files; the agent files are build outputs. Any work package touching Odin's prompt edits templates and regenerates in the same package (C-2).
