# ADR-0017: Persistence creates the folder layout — no scaffold step and no template skill

- **Status:** Accepted
- **Date:** 2026-09-24
- **Kind:** recorded (evidence: directory listing of `skills/architecture/` (five skills, no template skill); `skills/architecture/odin-architecture-workflow/SKILL.md:12, 55, 86`; `skills/architecture/brokk-architecture-persistence/SKILL.md:42, 80, 134`; `skills/architecture/kvasir-software-architecture/SKILL.md` § Layout Map, § Document Shape; `README.md:230, 402`)

## Context

The earlier form of the workflow dispatched a pre-drafting Scaffold step: a template skill created the twelve index-only section folders in the target and returned a `Scaffold result:` line the drafter consumed, and it carried a second, byte-identical copy of the persisted-layout specification beside the persistence skill's — a two-file copy that had to move together on every layout change (§11 R14 as originally stated). The step wrote structure into the project before any decision was ratified, cost a dispatch and a review on every run, and gave the drafter a dependency on a project-side artifact it must otherwise never read. Subsystem goals affected: Maintainability (primary), Consistency, Durability.

## Decision

The persistence step owns the layout entirely. It **creates** the fixed twelve-folder layout when — and only when — the target is absent and the header reads `seed`, and otherwise **fills** the existing layout by the Workfile's Appendix C, document-by-document (`odin-architecture-workflow/SKILL.md:55`; `brokk-architecture-persistence/SKILL.md:134`). No step precedes drafting other than the conditional context gate; the workflow skill names a pre-drafting structure dispatch as an anti-pattern (`:86`). The drafter maps headings onto the fixed folders in Appendix C from the layout specification alone and never reads the target beyond the two-fact check (§5.2 I-7). The fixed folder table — twelve folder names and their one-line descriptions — lives in the persistence skill (`brokk-architecture-persistence/SKILL.md:42`); its description column is required word-identical to the `Holds` column of the drafting skill's § Document Shape, which generates the section indices' descriptions. The template skill and its licensed attribution text are gone; the drafting skill's output carries no attribution notice because it carries no licensed text.

## Consequences

- **Positive:** nothing is written to the project before ratification; one fewer dispatch and one fewer review per run; the full layout specification has one owner; the drafter's dependency on the target is exactly the two header facts.
- **Negative:** a smaller duplicate remains — the twelve section descriptions exist in two skills, checked by no validator (§11 R17); the persistence session carries both the create and the merge paths.
- **Becomes harder:** pre-creating an empty architecture directory as a standalone act — the layout appears only with the first persisted seed.

## Related

DOC-12 · §5.2 I-5, I-7 · §11 R14 (closed), R17 · supersedes the template-skill clauses of ADR-0014 (Context, Decision, Consequences: "copied byte-for-byte into the template skill", "two of them a synchronized copy") · ADR-0016.
