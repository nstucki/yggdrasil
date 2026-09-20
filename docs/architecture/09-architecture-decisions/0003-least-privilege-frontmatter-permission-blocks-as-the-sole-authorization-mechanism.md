# ADR-0003: Least-privilege frontmatter permission blocks as the sole authorization mechanism

- **Status:** Accepted
- **Date:** 2026-09-20
- **Kind:** as-is (inferred from `agents/odin-autonomous.md:6-19`; `agents/mimir.md:6-68`; `agents/brokk.md:6-64`; context Workfile § Cross-cutting Concepts item 10)

## Context

The framework has no code of its own to enforce boundaries; the only enforcement point is the host's permission model declared per agent. The forces: goal 2 (least privilege) and goal 1 (a reviewer must not be able to alter what it reviews; a producer must not be able to approve itself); the need to keep Workfile and Artifact writers disjoint (ADR-0005).

## Decision

Every agent's frontmatter opens its `permission:` block with `"*": deny` and allows tools per role. Odin is granted only `skill` (allowlist `capability-inventory`, `odin-*`), `task` (allowlist of the five specialists), and `todo` — no file or shell access. Mimir is read-only on the codebase (inspection-only `bash` globs, test runners allowed, release scripts denied) and may `edit` only `.yggdrasil-workspace/**/*.md`. Brokk may `edit` anything except `.yggdrasil-workspace/**` and has broad `bash` with history-rewriting (`git commit --amend`, `git stash drop/clear`) and chained or redirected `git` denied. Skill loading is restricted to the role prefix for every agent. Authentication is delegated entirely to OpenCode and the host.

## Consequences

- **Positive:** The most consequential boundaries — Odin cannot read Workfiles, Brokk cannot write Workfiles, researchers cannot write the project — are mechanical, not behavioral; the block is readable in one place per agent.
- **Negative:** Rules are glob patterns; the deny lists for shell escapes are enumerated by hand (§11 R5); boundaries the permission model cannot express (scope discipline, "never paraphrase") remain prose (§11 R4).
- **Becomes harder:** Granting a specialist a one-off capability without editing its generated frontmatter — which is why custom grants live install-side in `custom-capabilities.yaml` (goal 5).

## Related

§2 C3, §3.2, §5.1.2, §8.6 · ADR-0001, ADR-0005 · `agents/brokk.md:6-64`
