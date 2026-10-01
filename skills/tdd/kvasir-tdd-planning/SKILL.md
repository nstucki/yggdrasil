---
name: kvasir-tdd-planning
description: Plan the test-driven execution of a bounded objective in one pass — the work packages (verbatim from a ratified architecture's Appendix B, or one derived package when none exists), the execution shape and mode under the five parallel criteria, and the commit plan: which packages land together, in what order, under which type and subject, on which branch, every commit a reviewed green state.
---

# TDD Planning

## Purpose

Answer three questions in one pass, for one bounded objective: how the work **splits** (packages), how it **executes** (shape, waves, mode), and how it **lands in history** (batches, order, type, subject, branch).

**Two repository facts are yours to resolve, and only two** — the current branch (`git branch --show-current`) and the working-tree state (`git status --porcelain`). Everything else about the repository belongs to the steps that execute the plan.

**You author the Workfile, touch no project file, and run no tests.** The baseline is the context Workfile's or the brief's; you never produce one yourself.

**Decisions are definite.** State the shape, the mode, and each batch in the indicative, never as a menu — a plan the ratifier must finish is not a plan. Every plan ships at `Status: Proposed`; the plan checkpoint ratifies it.

**Your step receives no review** — the checkpoint, and the reviews of every session that executes this plan, are its gates. The quality of this Workfile is yours to own.

## Boundaries

- Never create or modify a project file. Your only written output is the single Workfile the brief names.
- Never execute the test suite, or any command beyond the two repository facts above.
- Never re-derive, rename, merge, or split a package that Appendix B specifies — take it verbatim. A defect in it is a report that the architecture is wrong, not a plan-side fix.
- Never derive more than one package without an architecture Workfile. Report `packages=needs-architecture` and stop.
- Never plan a parallel wave while any of the five criteria reads `no`.
- Never plan a batch boundary that is not a verifiable green tree state (§ Commit Plan Rules).
- Never make a `Phase: red` result a batch boundary. Failing tests are not a green state.
- Never plan a commit on a non-conforming branch without a `create` line, and never plan one onto `main`, `master`, or `develop`.
- Never write a subject that describes the run rather than the diff.
- Never decide implementation minutiae the execution step owns: helper structure, local control flow, naming inside a package, test-case selection.
- Never restate the red-green-refactor cycle or any review checklist. Briefs name skills; the dispatched session loads its own method.
- Never guess a test command. No source means no plan: report it and stop.
- Never overwrite a file that already exists at the Workfile path. Ask, and write nothing until you are answered.

## When to Use

- Dispatched as the plan step of the TDD workflow, with: the objective; the path of the Workfile to **create**; and the architecture, requirements, and context Workfile paths that exist — or, when no context Workfile exists, the test command and baseline the brief states.
- **Not without a test-command source.** A plan whose packages have no test seam is not a plan.
- **Not for** executing anything, and **not for** writing into the project tree.

## Plan Shape

The Workfile's title is `# TDD Plan — <objective>`, followed by the header block:

```text
- **Status:** Proposed
- **Date:** <YYYY-MM-DD>
- **Branch:** current `<name>` | create `<type>/<kebab>` from `<name>`
- **Tree at planning:** clean | dirty — <paths>
- **Test command:** `<full suite>` — source: <context Workfile | brief>
- **Baseline:** green | red — <n> failing: <names> — source: <…>
- **Packages from:** architecture Appendix B (<path>) | derived from the objective
```

Each field has exactly one source: `Branch` and `Tree at planning` are the two repository facts; `Test command` and `Baseline` are the context Workfile's or the brief's; `Packages from` is the presence or absence of Appendix B. A header that guesses a field is a header that fails at execution.

Then four fixed sections, in this order.

**`## 1. Packages`** — one `### <name>` per package, each carrying the same field list: **Kind** (`feature | fix | refactor | test | scaffold | integration`), **Write set** (paths), **Owned criteria** (IDs), **Contracts provided / consumed** (naming the §5 interfaces, or existing code by path), **Test seam and command**, **Dependencies**, **Done criterion**, **Mode** (`integrated | split-phase`).

**`## 2. Execution Shape`** — the `Package check:` line, the ordered list of waves and steps, and one line of rationale per criterion.

**`## 3. Commit Plan`** — the table below.

**`## 4. Risks and Gaps`** — worst first.

The two verdict lines, fenced, their grammar fixed **here and nowhere else**:

```text
Package check: packages=<n>, disjoint write sets=<yes/no>, contracts fixed upfront=<yes/no>, independently testable=<yes/no>, shared-surface churn isolated=<yes/no>, fan-out ≤ 4=<yes/no> → <sequential | scaffold→parallel(<k>)→integrate>
TDD plan: packages=<n>, shape=<…>, mode=<integrated | split-phase | mixed>, commits=<k>, branch=<name>, source=<architecture-doc | derived>
```

The Commit Plan table, one row per batch, in commit order:

```markdown
| # | Batch (packages) | Type | Subject | Body | Gate |
| --- | --- | --- | --- | --- | --- |
| 1 | scaffold-contracts | feat: | add order contracts and fixtures | — | PASS on scaffold-contracts |
| 2 | order-intake, order-history + integration | feat: | record orders from the intake endpoint | why the two land together | PASS on order-intake, order-history + integration |
```

`Gate` is phrased `PASS on <package names>[ + integration]` and names **every** review the batch needs. The commit step reads one row of this table and the commit review checks a commit against it — a column rename is a three-file edit.

## Commit Plan Rules

1. **A batch boundary is a verifiable green tree state.** The commit session runs the full suite on the working tree, and that run proves the commit only if the tree beyond the staged set holds nothing but the recorded baseline-dirty paths.
2. **A parallel wave plus its integration is exactly one batch.** Wave packages coexist uncommitted in one tree; no subset of them is verifiably green alone.
3. **Consecutive sequential packages share a batch only if their write sets are pairwise disjoint.** An intersecting write set starts a new batch, so the predecessor is committed first and `HEAD` is a clean diff reference for the successor.
4. **A scaffold is its own batch, committed before fan-out.** That gives the wave a committed base, and "no commits during a wave" then needs no exception.
5. **No `Phase: red` result is a batch boundary.** In split-phase mode the batch closes after the `green+refactor` review.
6. **Type** per the commit step's § Commit Types — `feature→feat:`, `fix→fix:`, `refactor→refactor:`, `test→test:` (green tests only, characterization or coverage), `scaffold→feat:` or `test:` when it adds only fixtures and declarations, and a mixed batch takes the kind of the package that delivers behavior. **That section, not this echo, is normative.**
7. **Subject:** imperative, lowercase, ≤ ~50 characters, describing what the diff does. A body only when the *why* is not visible in the diff.
8. **Branch:** `current` when the current branch carries one of the three prefixes the commit step fixes (`feature/`, `fix/`, `refactor/`); otherwise `create <type>/<kebab>` from the current branch, the prefix matching the dominant type (`feat:`→`feature/`, `fix:`→`fix/`, `refactor:`→`refactor/`).
9. **Baseline-dirty paths** are recorded path by path in the header, surfaced as a risk, and never part of any batch.
10. **Commit count is minimal** — one batch unless a rule above forces a split, or the user asked for small steps.

## Workflow

1. **Read the brief and the inputs; resolve the two repository facts; open nothing you will overwrite.** Read Appendix B and §5 when given, the context Workfile's § Test Infrastructure and § Baseline Run, and the requirements by ID. A file already at the Workfile path stops you here.
2. **Establish the packages.** With an architecture Workfile: take Appendix B verbatim, naming the §5 contracts by name. Without one: derive **exactly one** package from the objective — write set, owned criteria (requirement IDs, or restated from the request and labelled derived), contracts as existing code by path, and test seam — and state the derived list explicitly, so the checkpoint and the implementing session can both correct it. More than one package needed → stop and report `packages=needs-architecture`.
3. **Decide the shape.** Apply the five criteria as judgment against the codebase, not as a formality: resolve the write sets and confirm they do not intersect; confirm each contract exists in §5, in §8, or in code; confirm each package's tests can run without the others' real implementations; confirm shared-surface churn — dependency-injection registration, route tables, migrations, manifests and lockfiles, generated code, shared fixtures — sits in a scaffold package; and cap the wave at four. **Sequential when ANY holds:** a single slice; shared files; a dependency on another package's real implementation; global generated state; a bug fix; or the user asked for small steps. Add the scaffold and integration packages when a wave exists, and order everything by dependency.
4. **Decide the mode per package.** Integrated by default; split-phase for security- or contract-critical work, on user request, or when a prior review found tests fitted to the implementation.
5. **Plan the commits** per § Commit Plan Rules, and fill `Branch:` from the first repository fact and rule 8.
6. **Record risks and gaps, self-check, create the Workfile, and report.** Self-check: every in-scope criterion is owned exactly once; `Package check:` agrees with the shape and with the table; every batch boundary is green-verifiable; every batch's `Gate` names every review it needs; and no path appears in two batches.

## Output Contract

**Workfile** — markdown at the path the brief names (task-directory pattern `NN-plan-tdd.md`), with the header block and the four sections in the fixed order of § Plan Shape.

**Report** (not written to the Workfile), in this order:

1. The `TDD plan:` line.
2. The `Package check:` line.
3. The packages — name, kind, owned criteria, mode.
4. The commit plan, one line per batch: `#`, packages, type, subject, gate.
5. The branch and the tree state.
6. The baseline.
7. Risks and gaps, worst first.
8. The Workfile path.

**Failure handling:**

- No test-command source → report `test seam: none — context step must fire` and write nothing else of substance.
- More than one package needed with no Appendix B → report `packages=needs-architecture` and stop.
- Appendix B's own `Package check:` reads `no` on a criterion → plan sequential and report the contradiction.
- A write-set path does not exist → record it as *to be created* and note it.
- A consumed contract is absent from §5 and from the code → record the gap, plan sequential, and report it.
- The current branch does not conform → emit a `create` line.
- A file already exists at the Workfile path → ask, and write nothing.
- The brief asks you to run tests, implement, or commit → decline, and report the boundary.
- The tree is dirty on a path inside a write set → a **blocking risk** in the report, surfaced at the checkpoint: the commit step will refuse to stage it.

## Quality Criteria

- One Workfile was created, no project file changed, and no command ran beyond the two repository facts.
- Every header field equals its declared source.
- Packages are verbatim from Appendix B when it exists, or exactly one explicitly-derived package when it does not.
- Every in-scope acceptance criterion is owned by exactly one package.
- `Package check:` is consistent with the execution shape and with the package table.
- Every batch boundary is a green-verifiable tree state; a wave plus its integration is one batch; batched sequential packages have pairwise-disjoint write sets.
- Every commit row carries a type from the four, an imperative subject of ≤ ~50 characters, and a `Gate` naming every review the batch needs.
- The branch conforms, or a `create` line exists.
- The commit count is minimal for the rules that apply.
- The report holds every item of § Output Contract, in order.

## Anti-Patterns

- **Re-deriving Appendix B** — "improving" a package the ratification already fixed.
- **Parallel by optimism** — a wave planned on write sets nobody resolved against the tree.
- **Layer-split packages** — "backend", "frontend", "database": none owns a criterion, none is testable alone, all collide on the shared surface.
- **A red-state commit** — a `test:` batch over failing tests, or a batch closing on a `Phase: red` result.
- **Splitting a wave across batches**, or **batching packages whose write sets intersect**.
- **A subject that narrates the run** — "implement package B" describes the plan, not the diff.
- **Planning a commit to `main`.**
- **Running the suite "to be sure"** — execution belongs to the context step and the commit step.
- **A plan with no seam** — "the implementer will find the runner".
- **A hedged shape** — "parallel if possible", "probably two commits". Decide, and let the checkpoint overrule you.
