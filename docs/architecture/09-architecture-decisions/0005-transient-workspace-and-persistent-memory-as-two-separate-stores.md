# ADR-0005: Transient Workspace and persistent Memory as two separate stores

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:72-90`; `agents/brokk.md:53-56, 75, 89-91`; `agents/mimir.md:55-58`; `agents/bragi.md:57-63`)

## Context

Specialists need to hand large intermediate results to each other without routing them through Odin's context, and some findings deserve to outlive the task. The forces: goal 4 (traceability — persistent knowledge must be source-cited and lifecycle-managed), goal 2 (writers of intermediate files and writers of project files must be disjoint), and the rule that Odin acts on summaries only.

## Decision

The system keeps two stores in the target project with opposite lifecycles. The **Yggdrasil Workspace** (`.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`) holds transient, gitignored, relatively-addressed Workfiles written with `edit` by Mimir, Kvasir, Heimdall, and Bragi, read (not written) by Brokk, and never read by Odin; Workfile content becomes a Deliverable only by promotion. The **Yggdrasil Memory** (`.yggdrasil-memory/` plus `INDEX.md`) holds persistent, recommended-git-tracked, source-cited entries that are never Artifacts and are written only by the Memory pipelines (ADR-0008). Artifacts are, by definition, files outside both stores.

## Consequences

- **Positive:** Intermediate material never pollutes the project or Odin's context; Brokk's write surface and the specialists' Workfile surface are disjoint by permission; the Artifact definition is exact.
- **Negative:** Every specialist prompt must carry the Workspace and Memory conventions (hence the shared fragments of ADR-0004); a `.gitignore` entry must exist in every target project, a standing duty placed on Brokk.
- **Becomes harder:** Delivering a Workfile as-is — doctrine forbids a bare workspace path as a Deliverable.

## Related

§2 C7–C9, §5.1.5, §5.1.6, §8.3, §8.4 · ADR-0003, ADR-0008 · `agents/odin-autonomous.md:74-90`
