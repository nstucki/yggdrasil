# 12. Glossary

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

| Term | Definition |
| --- | --- |
| Mode | `document-existing` (as-is record, no proposals) or `decide-new` (forward-looking, ADRs + packages). |
| Mode source | `direction` (user or caller stated it) or `inference` (derived by the shape-verdict rule). |
| Caller contract | The `Architecture request:` line a composite caller supplies (I-1). |
| Return block | The `Architecture result:` line the workflow returns (I-3). |
| `persistence=deferred` | The caller owns ratification and persistence; the workflow stops after the review gate. |
| As-is ADR | A decision record describing a decision already embodied in the codebase, marked `Kind: as-is`. |
| Doctrine | Orchestration/method markdown (SKILL.md, prompt templates, command files) — the "code" of this objective. |
| Feature directory | A `skills/<family>/` directory listed in `MANDATORY_SKILL_DIRS`, holding one Odin workflow skill plus its specialists; `architecture/` is the new one. |
| `Focus: scaffold` / `Focus: document` / `Focus: persistence` | The three artifact types `heimdall-architecture-review` reviews: the scaffolded skeleton, the filled arc42 Workfile (with `Mode:`), and the persisted directory. |
| Scaffold | The arc42 Workfile as written by Brokk before drafting: pre-filled header, all headings with guidance, appendix treatment by mode, attribution notice, no section content (I-5). |
| Scaffolder / drafter / persister | The three Brokk–Kvasir–Brokk roles that touch the arc42 Workfile in sequence (§8.7). |
