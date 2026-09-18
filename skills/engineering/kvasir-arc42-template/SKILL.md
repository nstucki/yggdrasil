---
name: kvasir-arc42-template
description: Reference skeleton for arc42-structured architecture documents — the twelve section headings with adapted arc42 guidance, an omission-marker convention, and the decision-record, work-package, and traceability appendices that the architecture step instantiates.
---

# arc42 Template — Architecture Document

<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: Gernot Starke and Peter Hruschka — arc42 template, https://arc42.org

SPDX has no per-region mechanism, so the tag above is declared for the whole file.
It is the arc42-derived guidance text in this file that carries CC BY-SA 4.0; the
content marked "Yggdrasil" is original to this repository. The exact scope and the full
legal code are in LICENSES/CC-BY-SA-4.0-arc42.txt in the Yggdrasil source repository
(not installed with this skill) and at https://creativecommons.org/licenses/by-sa/4.0/legalcode.
-->

> ## Attribution and license
>
> **The arc42 section guidance in this file is reproduced and adapted from the arc42 template for architecture communication and documentation**, created by **Gernot Starke** and **Peter Hruschka** — <https://arc42.org>. Source of the reproduced text: <https://github.com/arc42/arc42-template>, English AsciiDoc edition (`EN/adoc/01_…` through `EN/adoc/12_…`), template version **9.0 (July 2025)**, retrieved 2026-09-16.
>
> **License.** The arc42-derived content of this skill is licensed under the **Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)** — <https://creativecommons.org/licenses/by-sa/4.0/> (full legal code: <https://creativecommons.org/licenses/by-sa/4.0/legalcode>). A copy of the legal code, together with a statement of the precise scope of that license within the Yggdrasil repository, ships with the Yggdrasil **source** at `LICENSES/CC-BY-SA-4.0-arc42.txt`; that file is deliberately not installed alongside this skill, so if you are reading an installed copy, consult the source repository or the canonical URL above. The arc42-derived content is *not* covered by the license terms of the rest of this repository.
>
> **Changes made to the arc42 original** (disclosed as CC BY-SA 4.0 §3(a)(1)(B) requires):
>
> 1. **Converted from AsciiDoc to Markdown.** The AsciiDoc `ifdef::arc42help[]` / `[role="arc42help"]` wrappers and the `[[section-…]]` anchors were dropped, and each guidance block is presented in a fenced `text` block so that it renders literally.
> 2. **Only the arc42 guidance (`arc42help`) text of sections 1–12 and their subsections is reproduced.** arc42's own fill-in scaffolding — its placeholder tables, `_<white box template>_` markers, the black-box and white-box template help blocks, and the Infrastructure Level 1/2 help blocks — is not reproduced.
> 3. **Block labels re-rendered.** The AsciiDoc labels `.Contents`, `.Content`, `.Motivation`, `.Form`, `.Structure`, `.Examples`, and `.Further Information` are rendered as `Contents:`, `Content:`, `Motivation:`, `Form:`, `Structure:`, `Examples:`, and `Further Information:`.
> 4. **`Further Information` blocks trimmed.** The `.Further Information` blocks — which link into <https://docs.arc42.org> — are omitted throughout, except in section 10.2, where the `Examples` block and the `Further Information` block (the Bass/Clements/Kazman citation) are retained because they carry substantive content.
> 5. **Images not included.** AsciiDoc image macros are replaced by bracketed placeholders carrying the macro's alt text — `[image: Categories of Quality Requirements]`, `[image: Hierarchy of building blocks]`, `[image: Possible topics for crosscutting concepts]`. The image files themselves are not reproduced.
> 6. **AsciiDoc inline markup left as written.** Inline emphasis (`_floor plan_`, `*Level 1*`) and inline link syntax (`https://…[label]`) appear exactly as in the source, unconverted.
> 7. **Typographic punctuation normalized to ASCII** — for example `system’s` → `system's` and `“Risk management…”` → `"Risk management…"`.
> 8. **Heading numbers made explicit** (`1.`, `1.1`, `5.3`, …); the AsciiDoc original generates section numbers automatically.
> 9. **Paragraph line wrapping may differ** from the source files.
>
> **What is *not* arc42.** Everything marked **Yggdrasil** in this file is original content of this repository and is **no part of the arc42 template**: the five sections below (Purpose, When to Use, Workflow, Quality Criteria, and Anti-Patterns), the document header block, every `> **Yggdrasil:**` note, all fill-in tables and angle-bracket placeholders, the omission-marker convention, and Appendices A–C. arc42 does not endorse this repository or its use of the template.
>
> **Reading convention.** A fenced block introduced by **arc42 guidance §N** is arc42-original text under CC BY-SA 4.0. A blockquote introduced by `> **Yggdrasil:**` is this repository's own guidance.

## Purpose

Provide the reference arc42 skeleton — the twelve numbered section headings, their sub-structure, the per-section guidance, and the decision-record, work-package, and traceability appendices — that the `kvasir-software-architecture` skill instantiates in its architecture-drafting step. § Skeleton below *is* that payload; everything above it is how to use it.

The persisted form of the document is a directory — one file per numbered section, one per decision record, plus a generated index — produced by the implementation phase's persistence step from this single Workfile; the skeleton itself stays one Workfile.

**This skill is loaded by name with the `skill` tool, never read as a file.** Its content lives in this `SKILL.md` because a skill's own body is inlined when the skill is loaded, whereas companion files sitting beside a `SKILL.md` are not reliably readable by a subagent at runtime — a file-based template is unreachable. Every future change to the skeleton belongs inside this file.

This is a document skeleton, not a method for deciding architecture: quality-goal selection, option evaluation, and the decisions themselves belong to the architecture step's own skill. This skill governs only the shape of the document those decisions are written into.

Licensing scope is stated in the `Attribution and license` block above, and the reading convention is the last paragraph of it: a fenced **arc42 guidance §N** block is arc42-original text under CC BY-SA 4.0; a `> **Yggdrasil:**` blockquote is this repository's own guidance. Know which is which before you copy anything out of here — Workflow step 9 depends on the distinction.

## When to Use

- Loaded by the architecture step of the software engineering workflow, before anything is written into the architecture Workfile.
- Loaded again when an architecture Workfile is revised, so the revision keeps the skeleton's headings, omission markers, and appendix structure.
- Loaded by a reviewer or by the requesting agent to check an instantiated architecture document against the skeleton it was built from.
- **Not for** any other purpose. This skill carries no architecture method, no review rubric, and no project-specific content.

## Workflow

Steps 1–8 are the rules for instantiating the skeleton; step 9 governs attribution; step 10 governs the appendices.

1. Copy everything below the horizontal rule in § Skeleton into the architecture Workfile, then fill it.
2. Delete each guidance block — the fenced **arc42 guidance** blocks and the `> **Yggdrasil:**` blockquotes — as you fill the section it belongs to. Guidance left in a finished section is noise.
3. **Keep every numbered heading.** A section this change does not affect keeps its heading and gets a one-line marker, so a reader can tell "considered and excluded" from "forgotten". The wording depends on the document mode: in **seed** mode use `_Omitted — <reason>_`, because the document is the project's whole architecture record and there is no change for a section to be unaffected by; in **update delta** mode use `_Not affected by this change_` for the sections the delta leaves alone. The persistence step copies a seed marker verbatim into the section's own file and never writes an unaffected section in update-delta mode, so `_Not affected by this change_` never lands in the project tree.
4. Document only what a reader of *this* change needs. The twelve sections are a checklist to walk, not a quota to fill.
5. Quality goals come first: everything in §4, §9, and §10 should point back to §1.2.
6. Prefer one good diagram per view over several partial ones. Mermaid, in fenced ` ```mermaid ` blocks, next to the prose it illustrates.
7. Blackbox interfaces in §5 must be precise enough to write a failing test against.
8. Angle-bracket placeholders (`<…>`) are fill-ins; table rows are examples of shape, not required counts.
9. **Attribution travels with arc42 text — and only with it.** The `Attribution and license` block at the top of this skill is skill-level content. When every `arc42 guidance §N` block has been deleted from the Workfile, do **not** copy that block in: the finished document then contains no arc42-licensed text (the section names and numbering are structure, not the Licensed Material — see the scope statement in the license file the block cites). **If any `arc42 guidance §N` block survives into the Workfile** — a section left unfilled with its guidance in place, or guidance deliberately retained — copy the `Attribution and license` block verbatim to the top of the Workfile, directly under the document title, and name in your report every section that still carries arc42 text. Surviving arc42 text stays under CC BY-SA 4.0 wherever the document goes — when the implementation phase persists it into the project, and when it is published outside the organization; your own content does not.
10. **Appendices A–C are Workfile content, not document content.** Appendix A holds the full architecture decision record text; Appendix A is split into separate decision-record files, and §1–§12 into one file per section, when the document is persisted into the project. Appendices B and C — work packages and traceability — are planning material and are never persisted. Keep all three in the Workfile, each complete: Appendix B with its `Package check:` verdict line, Appendix C with exactly one row per acceptance criterion in scope.

## Quality Criteria

- All twelve numbered arc42 headings are present in the Workfile, at the heading levels this skeleton sets.
- Every section is either filled or carries an explicit omission marker; none is silently dropped.
- No `arc42 guidance §N` block and no `> **Yggdrasil:**` blockquote remains in a section that has been filled.
- §1.2 is filled before §4, §9, and §10 are written, and each of those points back to it.
- Every angle-bracket placeholder (`<…>`) in the copied skeleton is either resolved or deleted with its row.
- The skeleton's title is promoted to a top-level `#` in the Workfile; every other heading level is left exactly as the skeleton sets it — in the Workfile. The persistence step promotes each section by one heading level when it becomes its own file.
- The document header block carries `Status`, `Date`, `Document scope`, and the `Section scope:` verdict.
- Appendices A, B, and C are present, with Appendix B's `Package check:` verdict line filled in.
- The `Attribution and license` block appears in the Workfile **if and only if** at least one `arc42 guidance §N` block remains in it. When persisted, this rule holds per section file.

## Anti-Patterns

- **Template worship** — filling all twelve sections for a change that touches three, so the signal drowns in ceremony. Prune, and mark what you pruned.
- **Silent deletion** — dropping an irrelevant section instead of marking it omitted, leaving a reader unable to tell considered-and-excluded from forgotten.
- **Guidance left in a finished section** — the section reads as filled while still carrying the instructions for filling it.
- **Renumbering or renaming the arc42 sections** — the numbering is the shared vocabulary; a §5 that is not the building block view breaks every cross-reference and every reader's expectation.
- **Table rows as quotas** — treating the example rows as a required count, inventing risks, scenarios, or packages to fill them.
- **Orphaned arc42 text** — an `arc42 guidance` block left in the document without the attribution and license notice.
- **Attribution by reflex** — pasting the notice into a document that contains no arc42 text, misattributing your own content to arc42.
- **Editing the skeleton instead of the Workfile** — this skill is reference material; adapt the copy in the Workfile and leave the skeleton intact.
- **Splitting this content into a companion file** — reference material a skill needs must live in the skill's own `SKILL.md` or in another skill loaded by name; a companion file beside a `SKILL.md` is not reliably readable at runtime — this concerns the skill's own reference material; the *persisted* architecture document is deliberately multi-file.

## Skeleton

Copy everything below the horizontal rule into the architecture Workfile.

---

> **Yggdrasil:** when you copy this header block into a new Workfile, promote the heading below to a top-level `#` — in the produced document it is that document's own title, and it is `##` here only because this template file nests it under its own top-level title. Leave every other heading in the payload exactly as it is below: sections 1–12, their subsections, and Appendices A–C are already at the levels the produced Workfile requires.

## \<System / Subsystem\> — Architecture (arc42)

- **Status:** Proposed
- **Date:** \<YYYY-MM-DD\>
- **Document scope:** \<seed | update delta\>
- **Section scope:** included=\<…\>, omitted=\<…\>

> **Yggdrasil:** in *update delta* mode, add the header line `- **Existing document:** <path> (<directory index README.md | legacy single file | non-arc42>)` naming what this delta merges into, and list the sections it replaces.

## 1. Introduction and Goals

**arc42 guidance §1** — arc42-original text, CC BY-SA 4.0:

```text
Describes the relevant requirements and the driving forces that software 
architects and development team must consider. These include

* underlying business goals, 
* essential features, 
* essential functional requirements, 
* quality goals for the architecture and
* relevant stakeholders and their expectations
```

### 1.1 Requirements Overview

**arc42 guidance §1.1** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Short description of the functional requirements, driving forces, extract (or abstract)
of requirements. Link to (hopefully existing) requirements documents
(with version number and information where to find it).

Motivation:
From the point of view of the end users a system is created or modified to
improve support of a business activity and/or improve the quality.

Form:
Short textual description, probably in tabular use-case format.
If requirements documents exist this overview should refer to these documents.

Keep these excerpts as short as possible. Balance readability of this document with potential redundancy w.r.t to requirements documents.
```

> **Yggdrasil:** the objective in three to five lines — what changes and for whom. List the acceptance criterion IDs in scope; do not restate the requirements themselves.

### 1.2 Quality Goals

**arc42 guidance §1.2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The top three (max five) quality goals for the architecture whose fulfillment is of highest importance to the major stakeholders. 
We really mean quality goals for the architecture. Don't confuse them with project goals.
They are not necessarily identical.

Consider this overview of potential topics (based upon the ISO 25010 standard):

[image: Categories of Quality Requirements]

Motivation:
You should know the quality goals of your most important stakeholders, since they will influence fundamental architectural decisions. 
Make sure to be very concrete about these qualities, avoid buzzwords.
If you as an architect do not know how the quality of your work will be judged...

Form:
A table with quality goals and concrete scenarios, ordered by priorities
```

> **Yggdrasil:** the top three to five quality goals, ranked. These are the evaluation criteria for every decision in §9 and the source of the scenarios in §10. Motivate each from this objective, not from generic virtue.

| Rank | Quality goal | Motivation for this change | Scenario hint |
| --- | --- | --- | --- |

### 1.3 Stakeholders

**arc42 guidance §1.3** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Explicit overview of stakeholders of the system, i.e. all person, roles or organizations that

* should know the architecture
* have to be convinced of the architecture
* have to work with the architecture or with code
* need the documentation of the architecture for their work
* have to come up with decisions about the system or its development

Motivation:
You should know all parties involved in development of the system or affected by the system.
Otherwise, you may get nasty surprises later in the development process.
These stakeholders determine the extent and the level of detail of your work and its results.

Form:
Table with role names, person names, and their expectations with respect to the architecture and its documentation.
```

> **Yggdrasil:** include only when this change alters who is affected or what they expect. Otherwise mark it omitted.

| Role | Expectations of this change |
| --- | --- |

## 2. Architecture Constraints

**arc42 guidance §2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Any requirement that constraints software architects in their freedom of design and implementation decisions or decision about the development process. These constraints sometimes go beyond individual systems and are valid for whole organizations and companies.

Motivation:
Architects should know exactly where they are free in their design decisions and where they must adhere to constraints.
Constraints must always be dealt with; they may be negotiable, though.

Form:
Simple tables of constraints with explanations.
If needed you can subdivide them into
technical constraints, organizational and political constraints and
conventions (e.g. programming or versioning guidelines, documentation or naming conventions)
```

> **Yggdrasil:** what you are not free to choose — technology mandates, platform and version floors, regulatory rules, team conventions, existing contracts you must honor. Constraints bound the options tables in §9. One line each; omit the section if nothing constrains this change.

## 3. Context and Scope

**arc42 guidance §3** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Context and scope - as the name suggests - delimits your system (i.e. your scope) from all its communication partners
(neighboring systems and users, i.e. the context of your system). It thereby specifies the external interfaces.

If necessary, differentiate the business context (domain specific inputs and outputs) from the technical context (channels, protocols, hardware).

Motivation:
The domain interfaces and technical interfaces to communication partners are among your system's most critical aspects. Make sure that you completely understand them.

Form:
Various options:

* Context diagrams
* Lists of communication partners and their interfaces.
```

### 3.1 Business Context

**arc42 guidance §3.1** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Specification of *all* communication partners (users, IT-systems, ...) with explanations of domain specific inputs and outputs or interfaces.
Optionally you can add domain specific formats or communication protocols.

Motivation:
All stakeholders should understand which data are exchanged with the environment of the system.

Form:
All kinds of diagrams that show the system as a black box and specify the domain interfaces to communication partners.

Alternatively (or additionally) you can use a table.
The title of the table is the name of your system, the three columns contain the name of the communication partner, the inputs, and the outputs.
```

> **Yggdrasil:** the external actors and neighboring systems this change touches, and the information exchanged with each. A `flowchart` with the system as one box and the actors around it is usually enough.

### 3.2 Technical Context

**arc42 guidance §3.2** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Technical interfaces (channels and transmission media) linking your system to its environment. In addition a mapping of domain specific input/output to the channels, i.e. an explanation which I/O uses which channel.

Motivation:
Many stakeholders make architectural decision based on the technical interfaces between the system and its context. Especially infrastructure or hardware designers decide these technical interfaces.

Form:
E.g. UML deployment diagram describing channels to neighboring systems,
together with a mapping table showing the relationships between channels and input/output.
```

> **Yggdrasil:** the channels, protocols, and formats behind §3.1 — map each business exchange to its technical carrier. Omit when no external interface changes.

## 4. Solution Strategy

**arc42 guidance §4** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
A short summary and explanation of the fundamental decisions and solution strategies, that shape system architecture. It includes

* technology decisions
* decisions about the top-level decomposition of the system, e.g. usage of an architectural pattern or design pattern
* decisions on how to achieve key quality goals
* relevant organizational decisions, e.g. selecting a development process or delegating certain tasks to third parties.

Motivation:
These decisions form the cornerstones for your architecture. They are the foundation for many other detailed decisions or implementation rules.

Form:
Keep the explanations of such key decisions short.

Motivate what was decided and why it was decided that way,
based upon problem statement, quality goals and key constraints.
Refer to details in the following sections.
```

> **Yggdrasil:** the shape of the solution in half a page — the technology choices, the decomposition approach, and the tactic adopted for each §1.2 quality goal. Summarize decisions and cross-reference their ADR IDs; the reasoning lives in the ADRs, not here.

## 5. Building Block View

**arc42 guidance §5** — arc42-original text, CC BY-SA 4.0:

```text
Content:
The building block view shows the static decomposition of the system into building blocks (modules, components, subsystems, classes, interfaces, packages, libraries, frameworks, layers, partitions, tiers, functions, macros, operations, data structures, ...) as well as their dependencies (relationships, associations, ...)

This view is mandatory for every architecture documentation.
In analogy to a house this is the _floor plan_.

Motivation:
Maintain an overview of your source code by making its structure understandable through
abstraction.

This allows you to communicate with your stakeholder on an abstract level without disclosing implementation details.

Form:
The building block view is a hierarchical collection of black boxes and white boxes
(see figure below) and their descriptions.

[image: Hierarchy of building blocks]

*Level 1* is the white box description of the overall system together with black
box descriptions of all contained building blocks.

*Level 2* zooms into some building blocks of level 1.
Thus it contains the white box description of selected building blocks of level 1, together with black box descriptions of their internal building blocks.

*Level 3* zooms into selected building blocks of level 2, and so on.
```

### 5.1 Whitebox Overall System

**arc42 guidance §5.1** — arc42-original text, CC BY-SA 4.0:

```text
Here you describe the decomposition of the overall system using the following white box template. It contains

 * an overview diagram
 * a motivation for the decomposition
 * black box descriptions of the contained building blocks. For these we offer you alternatives:

   ** use _one_ table for a short and pragmatic overview of all contained building blocks and their interfaces
   ** use a list of black box descriptions of the building blocks according to the black box template (see below).
   Depending on your choice of tool this list could be sub-chapters (in text files), sub-pages (in a Wiki) or nested elements (in a modeling tool).


 * (optional:) important interfaces, that are not explained in the black box templates of a building block, but are very important for understanding the white box.
Since there are so many ways to specify interfaces why do not provide a specific template for them.
 In the worst case you have to specify and describe syntax, semantics, protocols, error handling,
 restrictions, versions, qualities, necessary compatibilities and many things more.
In the best case you will get away with examples or simple signatures.
```

> **Yggdrasil:** one Mermaid diagram of the system, or of the affected subsystem when the change is local, plus the motivation for this decomposition and a table of the blocks it contains.

| Building block | Responsibility | Changed by this objective? |
| --- | --- | --- |

#### 5.1.\<n\> Blackbox \<Building Block\>

> **Yggdrasil:** one blackbox entry per building block this change touches. Interfaces must carry signatures, parameter and return types, error and failure contracts, and schema or migration changes — enough to write a failing test without opening the implementation.

- **Purpose / responsibility:** …
- **Provided interfaces:** …
- **Required interfaces:** …
- **Quality characteristics:** … (only when a §1.2 goal depends on this block)
- **Location:** \<path in the repository\>
- **Fulfilled acceptance criteria:** \<AC IDs\>
- **Open issues:** …

### 5.2 Level 2

**arc42 guidance §5.2** — arc42-original text, CC BY-SA 4.0:

```text
Here you can specify the inner structure of (some) building blocks from level 1 as white boxes.

You have to decide which building blocks of your system are important enough to justify such a detailed description.
Please prefer relevance over completeness. Specify important, surprising, risky, complex or volatile building blocks.
Leave out normal, simple, boring or standardized parts of your system
```

> **Yggdrasil:** refine only the blocks this change alters internally. Depth is earned by change, not by symmetry — do not decompose a block you are not touching.

### 5.3 Level 3

**arc42 guidance §5.3** — arc42-original text, CC BY-SA 4.0:

```text
Here you can specify the inner structure of (some) building blocks from level 2 as white boxes.

When you need more detailed levels of your architecture please copy this
part of arc42 for additional levels.
```

## 6. Runtime View

**arc42 guidance §6** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The runtime view describes concrete behavior and interactions of the system's building blocks in form of scenarios from the following areas:

* important use cases or features: how do building blocks execute them?
* interactions at critical external interfaces: how do building blocks cooperate with users and neighboring systems?
* operation and administration: launch, start-up, stop
* error and exception scenarios

Remark: The main criterion for the choice of possible scenarios (sequences, workflows) is their *architectural relevance*. It is *not* important to describe a large number of scenarios. You should rather document a representative selection.

Motivation:
You should understand how (instances of) building blocks of your system perform their job and communicate at runtime.
You will mainly capture scenarios in your documentation to communicate your architecture to stakeholders that are less willing or able to read and understand the static models (building block view, deployment view).

Form:
There are many notations for describing scenarios, e.g.

* numbered list of steps (in natural language)
* activity diagrams or flow charts
* sequence diagrams
* BPMN or EPCs (event process chains)
* state machines
* ...
```

> **Yggdrasil:** one subsection per scenario, typically one to three: the critical flow, plus any scenario a §1.2 quality goal hinges on. A `sequenceDiagram` and a few lines of notes, naming the acceptance criterion IDs realized and the error path taken.

### 6.\<n\> \<Scenario name\>

## 7. Deployment View

**arc42 guidance §7** — arc42-original text, CC BY-SA 4.0:

```text
Content:
The deployment view describes:

 1. technical infrastructure used to execute your system, with infrastructure elements like geographical locations, environments, computers, processors, channels and net topologies as well as other infrastructure elements and

2. mapping of (software) building blocks to that infrastructure elements.

Often systems are executed in different environments, e.g. development environment, test environment, production environment. In such cases you should document all relevant environments.

Especially document a deployment view if your software is executed as distributed system with more than one computer, processor, server or container or when you design and construct your own hardware processors and chips.

From a software perspective it is sufficient to capture only those elements of an infrastructure that are needed to show a deployment of your building blocks. Hardware architects can go beyond that and describe an infrastructure to any level of detail they need to capture.

Motivation:
Software does not run without hardware.
This underlying infrastructure can and will influence a system and/or some
cross-cutting concepts. Therefore, there is a need to know the infrastructure.

Form:
Maybe a highest level deployment diagram is already contained in section 3.2. as
technical context with your own infrastructure as ONE black box. In this section one can
zoom into this black box using additional deployment diagrams:

* UML offers deployment diagrams to express that view. Use it, probably with nested diagrams,
when your infrastructure is more complex.
* When your (hardware) stakeholders prefer other kinds of diagrams rather than a deployment diagram, let them use any kind that is able to show nodes and channels of the infrastructure.
```

> **Yggdrasil:** infrastructure level 1 — nodes, runtimes, and what is deployed where — as a `flowchart` with subgraphs. Include only when infrastructure, topology, or the deployment procedure changes; otherwise mark it omitted.

## 8. Cross-cutting Concepts

**arc42 guidance §8** — arc42-original text, CC BY-SA 4.0:

```text
Content:
This section describes crosscutting concepts (practices, patterns, regulations or solution ideas).
Such concepts are often related to multiple building blocks. 
They may include many different topics, such as the topics shown in the following diagram:

[image: Possible topics for crosscutting concepts]

Motivation:
Concepts form the basis for _conceptual integrity_ (consistency, homogeneity) of the architecture. 
Thus, they are an important contribution to achieve inner qualities of your system.

This is the place in the template that we provided for a cohesive specification of such concepts.

Many of these concepts relate to or influence several of your building blocks. 

Form:
The form can be varied:

* concept papers with any kind of structure
* example implementations,especially for technical concepts
* cross-cutting model excerpts or scenarios using notations of the architecture views

Structure:
Pick **only** the most-needed topics for your system and assign each a level-2 heading in this section (e.g. 8.1, 8.2 etc).

DO NOT ATTEMPT to cover all of the topics of the aforementioned diagram.
```

> **Yggdrasil:** one subsection per concept this change introduces or alters — error handling, persistence, security, validation, logging, transactions, testing approach. An unchanged concept belongs in the existing document, not in this delta.

### 8.\<n\> \<Concept name\>

## 9. Architecture Decisions

**arc42 guidance §9** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
Important, expensive, large scale or risky architecture decisions including rationales.
With "decisions" we mean selecting one alternative based on given criteria.

Please use your judgement to decide whether an architectural decision should be documented
here in this central section or whether you better document it locally
(e.g. within the white box template of one building block).

Avoid redundancy. 
Refer to section 4, where you already captured the most important decisions of your architecture.

Motivation:
Stakeholders of your system should be able to comprehend and retrace your decisions.

Form:
Various options:

* ADR (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions[Documenting Architecture Decisions]) for every important decision
* List or table, ordered by importance and consequences or:
* more detailed in form of separate sections per decision
```

> **Yggdrasil:** in the AsciiDoc original, `ADR` above is followed by a hyperlink whose label is "Documenting Architecture Decisions" — Michael Nygard's blog post. The acronym is not expanded in the arc42 source.
>
> **Yggdrasil:** the decision log. One row per architecturally significant decision, with a one-line summary beneath each row. Full reasoning lives in the ADR itself — link, do not duplicate. New decisions are `Proposed` until ratified. The `Link` column carries the ADR's appendix anchor in the Workfile (`#adr-nnnn-…`); the persistence step rewrites it to the decision file's relative path.

| ID | Title | Status | Date | Link |
| --- | --- | --- | --- | --- |
| ADR-\<NNNN\> | \<decision title\> | Proposed | \<YYYY-MM-DD\> | \<appendix anchor\> |

## 10. Quality Requirements

**arc42 guidance §10** — arc42-original text, CC BY-SA 4.0:

```text
Content:
This section contains all relevant quality requirements. 

The most important of these requirements  have already been described in section 1.2. (quality goals), therefore they should only be referenced here.
In this section 10 you should also capture quality requirements with lesser importance, which will not create high risks when they are not fully achieved (but might be _nice-to-have_).

Motivation:
Since quality requirements will have a lot of influence on architectural decisions you should know  what qualities are really important for your stakeholders, in a specific and measurable way.
```

### 10.1 Quality Requirements Overview

**arc42 guidance §10.1** — arc42-original text, CC BY-SA 4.0:

```text
Content:
An overview or summary of quality requirements. 

Motivation:
Often we encounter dozens (or even hundreds) of detailed quality requirements. 
In this overview section you should try to summarize, e.g. by describing categories or topics (as suggested by https://www.iso.org/obp/ui/#iso:std:iso-iec:25010:ed-2:v1:en[ISO 25010:2023] or https://quality.arc42.org[Q42])

If these summary descriptions are already precise, specific enough and measurable, you may skip section 10.2.

Form:
Use a simple table in which each line contains a category or topic and a short description of the quality requirement.
Alternatively, you may use a mindmap to structure these quality requirements.
In literature, the idea of a _quality attribute tree_ has also been described, which puts the generic term "quality" as the root and uses a tree-like refinement of the term "quality". 
[Bass+21] introduced the term "Quality Attribute Utility Tree" for this purpose.
```

> **Yggdrasil:** optional. Useful when more than five scenarios need organizing; for a bounded change, mark it omitted and go straight to §10.2.

### 10.2 Quality Scenarios

**arc42 guidance §10.2** — arc42-original text, CC BY-SA 4.0:

```text
Content:
Quality scenarios make quality requirements concrete and allow to decide whether they are fulfilled (in the sense of acceptance criteria).
Ensure that your scenarios are specific and measurable.

Two kinds of scenarios are especially useful:

* _Usage scenarios_ (also called application scenarios or use case scenarios) describe the system's runtime reaction to a certain stimulus. 
This also includes scenarios that describe the system's efficiency or performance. 
Example: The system reacts to a user's request within one second.
* _Change scenarios_ describe the desired effect of a modification or extension of the system or of its immediate environment. 
Example: Additional functionality is implemented or requirements for a quality attribute change, and the effort or duration of the change is measured.

Form:

Typical information for detailed scenarios include the following:

In short form (favoured in the Q42 model):

* **Context/Background**: What kind of system or component, what is the envirionment or situation?
* **Source/Stimulus**: Who or what initiates or triggers a behaviour, reaction or action.
* **Metric/Acceptance Criteria**: A response including a _measure_ or _metric_

The long form of scenarios (favoured by the SEI and [Bass+21]) is more detailed and includes the following information:

* **Scenario ID**: A unique identifier for the scenario.
* **Scenario Name**: A short, descriptive name for the scenario.
* **Source**: The entity (user, system, or event) that initiates the scenario.
* **Stimulus**: The triggering event or condition the system must address.
* **Environment**: The operational context or condition under which the system experiences the stimulus.
* **Artifact**: The building-blocks or other elements of the system affected by the stimulus.
* **Response**: The outcome or behavior the system exhibits in reaction to the stimulus.
* **Response Measure**: The criteria or metric by which the system's response is evaluated.

Examples:
See https://quality.arc42.org[the Q42 quality model website] for detailed examples of quality requirements.

Further Information:

* Len Bass, Paul Clements, Rick Kazman: "Software Architecture in Practice", 4th Edition, Addison-Wesley, 2021.
```

> **Yggdrasil:** one to three scenarios per §1.2 quality goal. The measure carries a number and a unit — these become the candidate non-functional tests.

| ID | Quality goal | Stimulus | Response | Measure |
| --- | --- | --- | --- | --- |

## 11. Risks and Technical Debts

**arc42 guidance §11** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
A list of identified technical risks or technical debts, ordered by priority

Motivation:
"Risk management is project management for grown-ups" (Tim Lister, Atlantic Systems Guild.) 

This should be your motto for systematic detection and evaluation of risks and technical debts in the architecture, which will be needed by management stakeholders (e.g. project managers, product owners) as part of the overall risk analysis and measurement planning.

Form:
List of risks and/or technical debts, probably including suggested measures to minimize, mitigate or avoid risks or reduce technical debts.
```

> **Yggdrasil:** what this change introduces or retires. Each entry gets either a mitigation or an explicit acceptance — "known and accepted" is a valid outcome; silence is not.

| Risk / debt | Impact | Likelihood | Mitigation or acceptance |
| --- | --- | --- | --- |

## 12. Glossary

**arc42 guidance §12** — arc42-original text, CC BY-SA 4.0:

```text
Contents:
The most important domain and technical terms that your stakeholders use when discussing the system.

You can also see the glossary as source for translations if you work in multi-language teams.

Motivation:
You should clearly define your terms, so that all stakeholders

* have an identical understanding of these terms
* do not use synonyms and homonyms

Form:

A table with columns <Term> and <Definition>.

Potentially more columns in case you need translations.
```

> **Yggdrasil:** only terms this change introduces or redefines. Mark a term the codebase and the requirements use differently — that disagreement is a defect to surface.

| Term | Definition |
| --- | --- |

---

*Appendices A–C are original content of this repository. arc42 has no appendices; these are not part of the arc42 template.*

## Appendix A — Architecture Decision Records

> **Yggdrasil:** full ADR text, one per decision logged in §9, in the format the skill defines (Title · Status · Date · Context · Options Considered · Decision · Consequences · Related). At least two genuinely distinct options per decision, scored against the §1.2 quality goals. *Workfile content — split into separate decision-record files under the project's decision directory on persistence.*

## Appendix B — Work Packages

> **Yggdrasil:** one row per package, each a vertical slice that delivers observable behavior. Shared-surface churn (dependency registration, routing, migrations, lockfiles, generated code, shared fixtures) belongs to a single sequential scaffold package. *Workfile content — not persisted.*

| Package | Write set | Owned ACs | Contracts provided | Contracts consumed | Test seam | Depends on | Done criterion |
| --- | --- | --- | --- | --- | --- | --- | --- |

```text
Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
```

## Appendix C — Traceability

> **Yggdrasil:** one row per acceptance criterion in scope — exactly one owning package each. A missing row is a coverage hole; two packages on one row is a write-set collision. *Workfile content — not persisted.*

| AC | Building block(s) | ADR(s) | Package |
| --- | --- | --- | --- |
