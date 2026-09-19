# 12. Glossary

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§12](README.md)._

| Term | Definition |
| --- | --- |
| Mode | `document-existing` (as-is record, no proposals) or `decide-new` (forward-looking, ADRs + packages). |
| Mode source | `direction` (user or caller stated it) or `inference` (derived by the shape-verdict rule). |
| Caller contract | The `Architecture request:` line a composite caller supplies (I-1). |
| Return block | The `Architecture result:` line the workflow returns (I-3). |
| `persistence=deferred` | The caller owns ratification and persistence; the workflow stops after the review gate. |
| `persisted=refused` (R5) | I-3 value: steps 6–8 were entered, but the persistence step refused on its own precondition — a legacy-shaped target with no cited migration direction — and wrote nothing; distinct from `deferred` (caller owns it), `declined` (user said no), and `not-reached` (steps 6–8 never entered). |
| As-is ADR | A decision record describing a decision already embodied in the codebase, marked `Kind: as-is`. |
| Doctrine | Orchestration/method markdown (SKILL.md, prompt templates, command files) — the "code" of this objective. |
| Feature directory | A `skills/<family>/` directory listed in `MANDATORY_SKILL_DIRS`, holding one Odin workflow skill plus its specialists; `architecture/` is the new one. |
| `Focus: scaffold` / `Focus: document` / `Focus: persistence` | The three artifact types `heimdall-architecture-review` reviews: the scaffolded skeleton, the filled arc42 Workfile (with `Mode:`), and the persisted directory. |
| Scaffold | See "Scaffold (R5, redefined)" below — the R2–R4 meaning (a skeleton *Workfile* written by Brokk) is superseded; Brokk writes no Workfile (C-16). |
| Scaffolder / drafter / persister | The three roles of §8.7, each in its own medium: the **scaffolder** (Brokk) creates the folder skeleton in the target project; the **drafter** (Kvasir) authors the Workfile and its Appendix D layout map in the workspace; the **persister** (Brokk) copies the reviewed Workfile into the scaffolded folders. Only the drafter ever touches the Workfile; only Brokk ever touches the target. |
| Architecture context (R4) | `NN-context-architecture-<area>.md`, produced by `mimir-architecture-context`: structural facts for §5/§6/§8 and as-is documentation. |
| Engineering context (R4) | `NN-context-engineering-<area>.md`, produced by `mimir-engineering-context`: behavior, engineering conventions, test infrastructure, executed baseline, interfaces under test. |
| Boundary interface (R4) | A provided or required surface of a module/component — what §5 blackboxes quote; distinct from an "interface under test", the signature a TDD session calls. |
| Scaffold (R5, redefined) | The arc42 folder layout created in the **target project** by Brokk before drafting: twelve index-only section folders, the `09-architecture-decisions/` log, a top index at `Status: Scaffolded`; no content, no guidance text. (R2–R4 used the word for a skeleton *Workfile*; that mechanic is superseded.) |
| Topic document (R5) | `NN-<slug>.md` inside a section folder — one independently consulted unit of the section (a concept, a scenario, a building-block group), or the whole section when it does not decompose. |
| Section index (R5) | The generated `README.md` in a section folder: H1, backlink, description, state or Documents table. Brokk-owned; never hand-edited. |
| Layout map (R5) | Appendix D of the architecture Workfile: `heading → target path → promotion`, one row per heading; the drafter's split decisions made mechanical for the persister. |
| Status: Scaffolded (R5) | Top-index status between scaffold and first persistence; the invariant persistence checks before seeding. |
| D-1 (R5) | User decision, 2026-09-19: **A** — migrate the existing flat `docs/architecture/` to the folder layout as the first act of R5's persistence. |

---
