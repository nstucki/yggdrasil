# 5.1.13 Persisted layout specification — folder per section (R5; ADR-0018)

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§5](README.md)._

The normative copy lives in `brokk-architecture-persistence` § The Persisted Layout; `brokk-arc42-template` carries it verbatim (ADR-0020, Q-23); `kvasir-software-architecture` carries the structure half (names and numbering) as its Document shape table; `heimdall-architecture-review` checks against it.

```text
docs/architecture/
├── README.md                                  # top index (generated): Status Scaffolded|Accepted, Date, Document scope, Mode, Sections table (state · docs · last updated), Change Log
├── 01-introduction-and-goals/
│   ├── README.md                              # section index (generated): "# 1. Introduction and Goals", backlink, description, state line, Documents table
│   └── 01-introduction-and-goals.md           # single topic document (default name = section slug)
├── 05-building-block-view/
│   ├── README.md
│   ├── 01-whitebox-overall-system.md          # topic documents: NN-<slug>.md, NN contiguous from 01 in map order
│   ├── 02-<building-block-group>.md
│   └── …
├── 07-deployment-view/
│   └── README.md                              # omitted section: index only, marker verbatim in the state line
├── 09-architecture-decisions/
│   ├── README.md                              # the decision log (was 09-architecture-decisions.md)
│   ├── 0001-<slug>.md                         # records keep NNNN — global identifiers, append-only
│   └── 0016-<slug>.md
└── 12-glossary/
    ├── README.md
    └── 01-glossary.md
```

- **Fixed folder table:** the twelve `NN-<section-slug>/` names are the delivered fixed filename table with `.md` removed; no variants. All twelve folders always exist (C-17: each holds at least its index).
- **Topic document:** `NN-<slug>.md`; `NN` two-digit, contiguous from `01`, in Appendix D order; slug = kebab-case of the document's root heading title (a single-document section uses the section slug). Records: `NNNN-<slug>.md`, four-digit, continuing the project sequence — records are global identifiers and append-only; topic ordinals are folder-local ordering and may be re-assigned by a later delta that re-splits (the superseded file is kept and listed, never deleted).
- **Per-document format:** a document is one Workfile heading (its root) plus those of its descendants that no other row maps; H1 = the root heading promoted by `depth − 1` (a `## N.` root → 1; a `### N.m` root → 2; a `#### N.m.k` root → 3; an ADR `### ADR-NNNN` under `## Appendix A` → 2), body promoted by the same distance, backlink line second (`_Part of [<Title>](../README.md) · [§N](README.md)._`); records carry no backlink. Where children are carved out, the parent document ends where the first carved-out child began; the section index lists the reading order.
- **Section index (generated, Brokk-owned):** `# N. <Title>`; backlink to the top index; the one-line Yggdrasil section description; state line — `_Pending — not yet drafted_` (scaffold), `_Omitted — <reason>_` (omitted), or a Documents table (`# · Document · Root heading · Last updated`) plus, when applicable, "Omitted subsections" (markers verbatim) and "Superseded documents" (files a later map no longer names).
- **Top index:** as delivered, plus `Mode`, a `Docs` column, and `Status: Scaffolded` before first fill.
- **Omitted section = index-only folder**, and in a flat→folder migration the legacy stub file *becomes* that index by rename (`NN-<section>.md` → `NN-<section>/README.md`) — never delete-and-recreate.
- **Identity rules:** *folder layout* iff `README.md` and `01-introduction-and-goals/README.md`; *flat directory (legacy)* iff `README.md` and `01-introduction-and-goals.md`; *legacy single file* / *non-arc42* / *none* as before.
- **Status invariant:** persistence in seed scope requires top `Status: Scaffolded`; in update-delta scope `Accepted`; scaffold `created` produces `Scaffolded`; first persistence promotes to `Accepted`. A persistence step never creates a folder that the scaffold did not.
- **No arc42 guidance text anywhere under the target, ever** — so no file under the target carries the attribution notice; the notice lives in the skill that carries the licensed text.
