# 9. Architecture Decisions

_Part of [Yggdrasil — Architecture (arc42)](../README.md)._

The decision log — one row per architecturally significant decision, with its full record beside it in this folder.

ADR-0001–ADR-0008 were inferred from the repository and recorded as-is: each states what the system already does and where that is evidenced. ADR-0009–ADR-0011 are decisions taken for the Designer (Eitri) revision and ratified by the user. None is a proposal.

| ID | Title | Status | Date | Kind | Link |
| --- | --- | --- | --- | --- | --- |
| ADR-0001 | Single orchestrator with hub-and-spoke dispatch to five role-bound specialists | Superseded by ADR-0011 | 2026-09-20 | as-is | [ADR-0001](0001-single-orchestrator-with-hub-and-spoke-dispatch-to-five-role-bound-specialists.md) |
| ADR-0002 | Mandatory independent review by a dedicated reviewer with a Final Review Gate | Accepted | 2026-09-20 | as-is | [ADR-0002](0002-mandatory-independent-review-by-a-dedicated-reviewer-with-a-final-review-gate.md) |
| ADR-0003 | Least-privilege frontmatter permission blocks as the sole authorization mechanism | Accepted | 2026-09-20 | as-is | [ADR-0003](0003-least-privilege-frontmatter-permission-blocks-as-the-sole-authorization-mechanism.md) |
| ADR-0004 | Generated agent definitions with byte-identity validation | Accepted | 2026-09-20 | as-is | [ADR-0004](0004-generated-agent-definitions-with-byte-identity-validation.md) |
| ADR-0005 | Transient Workspace and persistent Memory as two separate stores | Accepted | 2026-09-20 | as-is | [ADR-0005](0005-transient-workspace-and-persistent-memory-as-two-separate-stores.md) |
| ADR-0006 | Trigger-gated packaged workflows carried as Odin-prefixed skills | Accepted | 2026-09-20 | as-is | [ADR-0006](0006-trigger-gated-packaged-workflows-carried-as-odin-prefixed-skills.md) |
| ADR-0007 | Three Odin modes varying only in the Communication Policy fragment | Accepted | 2026-09-20 | as-is | [ADR-0007](0007-three-odin-modes-varying-only-in-the-communication-policy-fragment.md) |
| ADR-0008 | Memory written only through command-triggered, reviewed pipelines | Accepted | 2026-09-20 | as-is | [ADR-0008](0008-memory-written-only-through-command-triggered-reviewed-pipelines.md) |
| ADR-0009 | Image model selected by the OpenCode-native `model:` agent field, with install-site override in `opencode.json` | Accepted | 2026-09-20 | decision | [ADR-0009](0009-image-model-selected-by-the-opencode-native-model-agent-field-with-install-site-override-in-opencode-json.md) |
| ADR-0010 | Designer permission profile: workspace-markdown and image-file `edit` allowlist, unscoped read surface, no shell, no network | Accepted | 2026-09-20 | decision | [ADR-0010](0010-designer-permission-profile-workspace-markdown-and-image-file-edit-allowlist-unscoped-read-surface-no-shell-no-network.md) |
| ADR-0011 | Designer as sixth role-bound specialist, registered by in-place extension of the roster lists (supersedes ADR-0001) | Accepted | 2026-09-20 | decision | [ADR-0011](0011-designer-as-sixth-role-bound-specialist-registered-by-in-place-extension-of-the-roster-lists.md) |
