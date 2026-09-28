# 9. Architecture Decisions

_Part of [Yggdrasil — Architecture (arc42)](../README.md)._

The decision log — one row per architecturally significant decision, with its full record beside it in this folder.

Decisions already in force, inferred from the repository and recorded as-is. None is a proposal; each records what the system does today and where that is evidenced. Full text in Appendix A.

| ID | Title | Status | Date | Kind | Link |
| --- | --- | --- | --- | --- | --- |
| ADR-0001 | Single orchestrator with hub-and-spoke dispatch to five role-bound specialists | Accepted | 2026-09-20 | as-is | [ADR-0001](0001-single-orchestrator-with-hub-and-spoke-dispatch-to-five-role-bound-specialists.md) |
| ADR-0002 | Mandatory independent review by a dedicated reviewer with a Final Review Gate | Accepted | 2026-09-20 | as-is | [ADR-0002](0002-mandatory-independent-review-by-a-dedicated-reviewer-with-a-final-review-gate.md) |
| ADR-0003 | Least-privilege frontmatter permission blocks as the sole authorization mechanism | Accepted | 2026-09-20 | as-is | [ADR-0003](0003-least-privilege-frontmatter-permission-blocks-as-the-sole-authorization-mechanism.md) |
| ADR-0004 | Generated agent definitions with byte-identity validation | Accepted | 2026-09-20 | as-is | [ADR-0004](0004-generated-agent-definitions-with-byte-identity-validation.md) |
| ADR-0005 | Transient Workspace and persistent Memory as two separate stores | Accepted | 2026-09-20 | as-is | [ADR-0005](0005-transient-workspace-and-persistent-memory-as-two-separate-stores.md) |
| ADR-0006 | Trigger-gated packaged workflows carried as Odin-prefixed skills | Accepted | 2026-09-20 | as-is | [ADR-0006](0006-trigger-gated-packaged-workflows-carried-as-odin-prefixed-skills.md) |
| ADR-0007 | Three Odin modes varying only in the Communication Policy fragment | Accepted | 2026-09-20 | as-is | [ADR-0007](0007-three-odin-modes-varying-only-in-the-communication-policy-fragment.md) |
| ADR-0008 | Memory written only through command-triggered, reviewed pipelines | Accepted | 2026-09-20 | as-is | [ADR-0008](0008-memory-written-only-through-command-triggered-reviewed-pipelines.md) |
| ADR-0009 | Framework skill changes land in the repository and propagate through setup.sh | Accepted | 2026-09-23 | decided | [ADR-0009](0009-framework-skill-changes-land-in-the-repository-and-propagate-through-setup-sh.md) |
| ADR-0010 | One long-term-relevance test for persisted content in both modes and both scopes | Accepted | 2026-09-23 | decided | [ADR-0010](0010-one-long-term-relevance-test-for-persisted-content-in-both-modes-and-both-scopes.md) |
| ADR-0011 | Closed set of three typed omission markers | Accepted | 2026-09-23 | decided | [ADR-0011](0011-closed-set-of-three-typed-omission-markers.md) |
| ADR-0012 | Persisted sections carry only document-stable references | Accepted | 2026-09-23 | decided | [ADR-0012](0012-persisted-sections-carry-only-document-stable-references.md) |
| ADR-0013 | Relevance enforced by a judgment-based blocking review criterion | Accepted | 2026-09-23 | decided | [ADR-0013](0013-relevance-enforced-by-a-judgment-based-blocking-review-criterion.md) |
| ADR-0014 | Document-granular update deltas with explicit supersession | Accepted | 2026-09-23 | decided | [ADR-0014](0014-document-granular-update-deltas-with-explicit-supersession.md) |
| ADR-0015 | One mode-less Architecture workflow — the objective fixes the content, the target's state fixes the document scope | Accepted | 2026-09-24 | recorded | [ADR-0015](0015-one-mode-less-architecture-workflow.md) |
| ADR-0016 | The drafting step is permanently unreviewed; the ratification checkpoint and the persistence review are its gates | Accepted | 2026-09-24 | recorded | [ADR-0016](0016-drafting-step-permanently-unreviewed.md) |
| ADR-0017 | Persistence creates the folder layout — no scaffold step and no template skill | Accepted | 2026-09-24 | recorded | [ADR-0017](0017-persistence-creates-the-folder-layout.md) |
| ADR-0018 | The Architecture workflow composes as a stage, not through a request/result contract | Accepted | 2026-09-24 | recorded | [ADR-0018](0018-architecture-workflow-composes-as-a-stage.md) |
| ADR-0019 | The TDD workflow is standalone and composes as a stage of the Software Engineering workflow | Accepted | 2026-09-24 | recorded | [ADR-0019](0019-tdd-workflow-composes-as-a-stage.md) |
| ADR-0020 | Only a fresh, reviewed commit session writes history — after every gating review passes | Accepted | 2026-09-24 | recorded | [ADR-0020](0020-only-a-reviewed-commit-session-writes-history.md) |
| ADR-0021 | One unreviewed plan step owns the packages, the execution shape, and the commit plan | Accepted | 2026-09-24 | recorded | [ADR-0021](0021-one-unreviewed-plan-step-owns-packages-shape-and-commits.md) |
| ADR-0022 | A commit is a reviewed green tree state — batch boundaries, four commit types, and three branch prefixes fixed by the plan and the commit skill | Accepted | 2026-09-24 | recorded | [ADR-0022](0022-a-commit-is-a-reviewed-green-tree-state.md) |
