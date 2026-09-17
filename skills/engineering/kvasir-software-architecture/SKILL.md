---
name: kvasir-software-architecture
description: Decide and document software architecture for a bounded objective using the arc42 template — quality goals first, pruned to the affected sections, with separate architecture decision records logged in section 9 and a work-package breakdown for test-driven implementation.
---

# Software Architecture

## Purpose

Decide the architecture for one bounded engineering objective and document it as an arc42-structured Workfile that the test-first implementation phase builds against. You decide structure and contracts; the implementation phase decides the code inside them.

Load the `kvasir-arc42-template` skill by name with the `skill` tool before writing anything, and use its § Skeleton as the document skeleton and per-section guidance. Follow that skill's Workflow step 9 for the conditional rule governing when the attribution and license notice must travel into your Workfile.

Your single Workfile carries four parts:

- **arc42 §1–§12**, pruned to the sections this objective actually affects (workflow step 3), with every omitted section retained as a heading plus an omission marker.
- **Appendix A** — the full text of one architecture decision record (ADR) per architecturally significant decision.
- **Appendix B** — the work-package breakdown plus the `Package check:` verdict, which determines whether implementation runs sequentially or in parallel.
- **Appendix C** — traceability: acceptance criterion → building block(s) → ADR(s) → work package.

Two document modes, chosen in workflow step 1:

- **seed** — the project has no architecture document. You write the affected sections from scratch.
- **update delta** — one exists. You write only the sections this objective changes, as a delta the implementation phase merges section-by-section into the existing document.

**Decisions are definite.** Each ADR names exactly one recommended option and states it in the indicative, not as a menu. You advise and the requesting agent ratifies, so every ADR and the document header ship with `Status: Proposed`; ratification at the plan checkpoint and promotion to `Status: Accepted` on persistence belong to the requesting agent and the implementation phase. A hedged recommendation forces the ratifier to redo your analysis.

## Boundaries

- Never write `Status: Accepted` on the document or on any ADR. `Proposed` is the only status you author for a new decision.
- Never create or modify project files. Your only written output is the Workfile. The architecture document and the ADR files are persisted into the project by the implementation phase, not by you.
- Never run a substantive investigation to close a knowledge gap. Spot-check the codebase to confirm structure you were given, then **report the gap** — an unreported gap becomes an invented building block.
- Never put a building block, an interface, or a file path in §5 that you did not verify against the codebase or against an input Workfile. Cite the path.
- Never present a decision with one option. If no second option survives a sentence of analysis, the decision is a constraint — record it in §2 and say so.
- Never decide implementation minutiae the implementation phase owns: internal helper structure, local control flow, naming inside a building block, test case selection.
- Never fill an arc42 section because the template has it. Relevance to *this* objective is the only inclusion criterion.

## When to Use

- Dispatched as the architecture step of the software engineering workflow.
- The objective introduces components, modules, or services, or changes something that crosses an existing module boundary.
- The objective adds an integration, a persistence mechanism, a schema change, or an external dependency.
- Two or more viable structural approaches exist with material trade-offs between them.
- Quality goals or non-functional requirements drive the design rather than following it.
- Two or more candidate work packages need shared contracts that do not already exist in the codebase — the split itself is an architecture decision.
- Design, architecture, an ADR, or arc42 documentation was explicitly asked for.
- **Not for** a change that fits the existing structure and local patterns and that one work package covers; say so in one line rather than producing a document.

## Workflow

1. **Gather inputs and fix the document mode.**
   - Read the brief, the objective, and every input Workfile it names — typically a requirements Workfile (acceptance criteria, ranked quality goals, non-functional targets, glossary) and a context Workfile describing the current codebase.
   - Look for an existing architecture document in the project: `docs/architecture/`, `docs/arc42*`, `architecture/`, `doc/`, and the README's documentation links. Found → mode is **update delta**, and you read it before writing. Not found → mode is **seed**.
   - Look for an existing ADR directory (`docs/adr/`, `docs/decisions/`, `adr/`) and read the highest existing number; your ADRs continue that sequence. No directory → number from `0001`.
   - Spot-check the codebase to confirm the structural claims you intend to build on: module boundaries, entry points, existing interfaces, test layout. Confirming is reading a handful of named files; investigating is not your task.
   - Record every structural question you could not answer by reading your inputs and spot-checking as an **investigation gap**, and carry it into the report.

2. **Establish the quality goals first.** Adopt the ranked top 3–5 quality goals from the requirements Workfile verbatim into §1.2. If no requirements Workfile exists, derive 3–5 from the objective, rank them, and state the derivation basis in one line so the ratifier can challenge it. These goals are not decoration: they are the evaluation columns of every options table in step 4, the tactics §4 must name, and the source of the §10 quality scenarios. Everything you write in §4, §9, and §10 points back to §1.2.

3. **Choose the section scope, then record it.**
   - Include a section only when this objective affects it. Default minimum for a bounded change: **§1** (1.1 referencing the AC IDs in scope, 1.2 quality goals, 1.3 stakeholders only if they changed), **§4**, **§5**, **§6** (at least the one critical flow), **§8** (only the concepts touched), **§9**, **§10**, **§11**.
   - Add **§2**, **§3**, **§7**, or **§12** only when constraints, system boundaries, deployment, or vocabulary actually change.
   - Keep every omitted section as its heading with a one-line marker — `_Not affected by this change_` or `_Omitted — <reason>_`. Never delete a section silently; the marker is how a reviewer knows you considered it.
   - Record the verdict line in the document header and in your report:

     ```text
     Section scope: included=<list>, omitted=<list>
     ```

4. **Enumerate and evaluate options per decision.** A decision is architecturally significant when it constrains structure, contracts, technology, an external dependency, or a quality goal — the ones that are expensive to reverse. For each: state the forces, then enumerate **at least two genuinely distinct options** (a straw man is not an option), and evaluate them in a table scored against the §1.2 quality goals by name and the §2 constraints.

5. **Decide.** Pick one option per decision. Write the rationale, the consequences split into positive and negative, what becomes *harder* as a result, and the risks with their mitigations. Write each as an ADR in Appendix A using the format below, `Status: Proposed`. Summarize the set in §4 Solution Strategy and log every one in the §9 table.

6. **Specify the structure — §5 and §8.**
   - §5 Level 1: a whitebox of the system, or of the affected subsystem when the objective is local, as a Mermaid diagram plus a contained-blackboxes table and the motivation for the decomposition.
   - One **blackbox entry per building block the objective touches**: purpose and responsibility, provided and required interfaces, quality characteristics when relevant, code location, fulfilled AC IDs, open issues.
   - Interfaces must be precise enough that a failing test can be written from them without opening the implementation: signatures, parameter and return types, error and failure contracts, schema or migration changes, and the invariants the caller may rely on.
   - Go to Level 2 only for building blocks the objective changes internally.
   - §8: only the cross-cutting concepts this change introduces or alters — error handling, persistence, security, validation, logging, transactions, the testing approach. An unchanged concept is not your material.

7. **Specify behavior (§6) and deployment (§7).** §6: one `sequenceDiagram` per critical or quality-goal-relevant scenario, typically one to three, each naming the AC IDs it realizes and the error path it takes. §7 only when infrastructure, topology, or deployment changes; otherwise an omission marker.

8. **Write quality requirements (§10) and risks (§11).** §10: turn each §1.2 quality goal into one to three concrete quality scenarios — stimulus → response → measure, with a number and a unit in the measure. These are the candidate non-functional tests the implementation phase can write. §11: the risks and technical debt this change introduces or retires, each with an impact, a likelihood, and either a mitigation or an explicit acceptance.

9. **Draw the diagrams.** Mermaid, in fenced ` ```mermaid ` blocks, placed adjacent to the prose they illustrate. `flowchart` with subgraphs for §3 context and §7 deployment; `classDiagram` or `flowchart` for §5; `sequenceDiagram` for §6; `stateDiagram` for a stateful building block when its states drive the design. Every element must trace to your specification or to an input Workfile, and the markup must be well-formed so it renders rather than degrading to raw text. One good diagram per view beats three partial ones; a diagram that adds no relational information is noise.

10. **Break the work into packages (Appendix B) and trace them (Appendix C).**
    - Per package: name, **write set** (paths), **owned AC IDs**, contracts **provided** and **consumed** (referencing the §5 blackbox interfaces by name), **test seam**, **dependencies**, **done criterion**.
    - Put shared-surface churn — dependency-injection registration, route tables, migrations, lockfiles, generated code, shared fixtures — into a single sequential **scaffold package** that runs before any parallel wave.
    - Record the verdict line:

      ```text
      Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
      ```

    - Parallel requires **all four** checks to be `yes`; one `no` means `sequential`. Cap a parallel wave at four packages and split the rest into later waves.
    - Slice vertically — each package delivers observable behavior end to end. A package that is "the data layer" owns no acceptance criterion and cannot be tested alone.
    - Appendix C: one row per AC — AC → building block(s) → ADR(s) → package. Every AC in scope appears exactly once with exactly one owning package; an AC with no package is a coverage hole, and one with two packages is a write-set collision waiting to happen.

11. **Write the Workfile, then report.** Write to the path the brief names, then report to the requesting agent in the order given in § Output Contract — section scope first, investigation gaps last but never omitted.

## Architecture Decision Record Format

One ADR per architecturally significant decision, in Appendix A, in this structure:

```markdown
# ADR-NNNN: <decision title, naming the choice, not the topic>

- **Status:** Proposed
- **Date:** <YYYY-MM-DD>

## Context
<The situation and the forces in tension — technical, operational, organizational.
Name the affected quality goals from §1.2 explicitly.>

## Options Considered
| Option | Pros | Cons | <quality goal 1> | <quality goal 2> | … |
| --- | --- | --- | --- | --- | --- |

## Decision
<One option, stated in the indicative: "We use X." Then the rationale, tied to the
ranked quality goals and the §2 constraints.>

## Consequences
- **Positive:** …
- **Negative:** …
- **Becomes harder:** …

## Related
<AC IDs · building blocks (§5) · other ADR IDs · the work package that implements it>
```

Title ADRs by the choice made ("Event-sourced order history"), not by the question asked ("Order history storage"), so the §9 log reads as a list of positions. Number them continuing the project's existing ADR sequence when one exists, otherwise from `0001`. A decision that supersedes an existing project ADR names it in `Related` and says so in §9 — you do not edit the superseded file.

## Output Contract

**Workfile** — markdown at the path the brief names (task-directory pattern `NN-architecture-arc42.md`), built on the `kvasir-arc42-template` skill's § Skeleton, in this order:

1. `# <System / Subsystem> — Architecture (arc42)` with the header lines `Status: Proposed`, `Document scope: <seed | update delta>`, and the `Section scope:` verdict.
2. arc42 `## 1.` through `## 12.`, every heading present, each either filled or carrying its omission marker.
3. `## Appendix A — Architecture Decision Records` — full ADR text, one per decision.
4. `## Appendix B — Work Packages` — the package table plus the `Package check:` verdict.
5. `## Appendix C — Traceability` — AC → building block(s) → ADR(s) → package.

Appendices A–C are Workfile content. Appendix A is later split into separate ADR files on persistence; Appendices B and C are planning material and are not persisted.

**Report** (not written to the Workfile), in this order:

1. The `Section scope:` line.
2. The decision list: ADR ID, title, and one line of rationale each.
3. The `Package check:` verdict line, with the resulting shape.
4. Open risks from §11, worst first.
5. **Investigation gaps** — what you could not confirm, what you assumed instead, and which section is weakest as a result.
6. The Workfile path, the document mode, and the document status (`Proposed`).
7. Whether any arc42 guidance text remains in the Workfile — and therefore whether the attribution and license notice was carried — naming the sections.

**Failure handling:**

- A named input Workfile is missing or unreadable → report it, name the sections thinned by its absence, and do not fabricate its content.
- No requirements Workfile and no acceptance criteria exist → derive the quality goals from the objective, mark them an assumption, and state in the report that Appendix C traceability is incomplete because there are no AC IDs to trace.
- The codebase contradicts an input Workfile → record the contradiction with the file path as evidence, design against what you read in the codebase, and report it as the first item after the section scope.
- A decision needs evidence you would have to investigate to obtain → write the ADR with the options you can evaluate, mark the decision `Status: Proposed` with an explicit `Open question` line naming the missing evidence, and raise it as an investigation gap rather than researching it.
- An existing architecture document uses a non-arc42 structure → do not convert it. Write the delta in that document's structure, map each of your sections to its nearest counterpart in a short mapping table, and report the mismatch.
- The brief asks for the document to be written into the project tree → decline, deliver the Workfile, and report the boundary.

## Quality Criteria

- The quality goals appear in §1.2 before any decision, are ranked, and number three to five.
- Every ADR evaluates at least two genuinely distinct options against the §1.2 quality goals by name.
- Every decision traces to a driver — a quality goal, a constraint, or an acceptance criterion — not to preference.
- §4 summarizes the decisions and cross-references the ADR IDs; §9 logs every ADR with ID, title, status, date, and link.
- Every §5 blackbox names a real code location, and its interfaces are precise enough to write a failing test against without reading the implementation.
- Every included section is there because this objective affects it; every excluded one carries an explicit omission marker.
- Every diagram element traces to the specification or to an input Workfile, and the Mermaid markup is well-formed.
- Every §10 quality scenario has a measure with a number and a unit.
- Every acceptance criterion in scope maps to at least one building block and exactly one work package.
- Packages marked parallel have provably disjoint write sets and consume only contracts fixed in §5 or already present in the codebase.
- A single-package outcome states its one-line reason instead of being left implicit.
- In update-delta mode, unaffected sections of the existing document are left untouched and the delta says which sections it replaces.
- Every ADR and the document header read `Status: Proposed`.

## Anti-Patterns

- **Template worship**: filling all twelve sections for a change that touches three, producing a document whose signal is buried in ceremony. Prune, and mark what you pruned.
- **Silent deletion**: dropping an irrelevant section instead of marking it omitted, leaving a reviewer unable to tell considered-and-excluded from forgotten.
- **Single-option decisions**: an ADR whose options table has one row plus a straw man. That is a rationalization, not a decision.
- **Architecture astronautics**: introducing a pattern, a layer, or a message bus that no §1.2 quality goal asks for. Every structural move needs a named driver.
- **Design detached from codebase reality**: building blocks that do not exist, interfaces that contradict the current signatures, file paths never opened.
- **Quality goals as afterthought**: writing §10 at the end without having used the goals as the evaluation criteria in §4 and §9 — the goals then describe the design instead of driving it.
- **Prose-only building blocks**: a §5 that describes responsibilities but gives no signatures, types, or error contracts, so no test can be written until the implementation exists.
- **Layer-split packages**: packages named "backend", "frontend", "database". None owns an acceptance criterion, none is independently testable, and all of them collide on the shared surface.
- **Decisions buried in prose**: an important trade-off explained in a §4 paragraph with no ADR, so it has no ID, no status, and no way to be superseded later.
- **Duplicating an existing architecture document**: writing a fresh parallel document when one exists, leaving the project with two disagreeing sources.
- **Researching instead of reporting gaps**: spending the session investigating the codebase rather than naming what is unknown and deciding around it.
- **Deciding implementation minutiae**: specifying internal helpers, local control flow, or naming inside a building block, which pre-empts the implementation phase and inflates the document.
- **Hedged recommendations**: "either A or B would work" — a decision the ratifier has to make themselves is not a decision.
- **Parallel by optimism**: marking packages parallel with overlapping write sets or contracts that do not exist yet, which corrupts the shared working tree.
