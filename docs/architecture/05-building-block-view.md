# 5. Building Block View

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 5.1 Whitebox Overall System

```mermaid
flowchart TB
  subgraph Odin prompt (generated)
    T1[shared-body.template.md § Workflows]
    T2[communication-policy-*.fragment.md ×3]
    G[generate-odin-agents.sh → agents/odin-*.md]
    T1 --> G
    T2 --> G
  end
  CMD[commands/yggdrasil/architect.md] -->|load skill| AW
  G -->|Architecture check → invoke| AW
  subgraph skills/architecture/ (new mandatory feature dir)
    AW[odin-architecture-workflow/SKILL.md]
    MCC[mimir-codebase-context/SKILL.md · moved]
    AT[brokk-arc42-template/SKILL.md · moved + renamed, scaffolds]
    KSA[kvasir-software-architecture/SKILL.md · moved, no template dependency]
    HAR[heimdall-architecture-review/SKILL.md · new]
    BAP[brokk-architecture-persistence/SKILL.md · moved]
  end
  subgraph skills/engineering/
    EW[odin-engineering-workflow/SKILL.md]
    HER[heimdall-engineering-review/SKILL.md]
  end
  EW -->|caller contract| AW
  EW -.step 2 loads by name.-> MCC
  AW -->|scope| MCC
  AW -->|Scaffold: mode, location| AT
  AT -->|scaffolded Workfile| KSA
  AW -->|Mode:, scaffold path| KSA
  AW -->|Focus: scaffold · Focus: document, Mode: · Focus: persistence| HAR
  HER -->|loads Focus: persistence checklist by name| HAR
  AW --> BAP
  INST[setup.sh · validate.sh · LICENSES/CC-BY-SA-4.0-arc42.txt] -.registers dir, path strings.- AW
  RD[README.md · capability inventory] -.documents.- AW
```

Motivation: one feature directory per workflow family, each holding its Odin doctrine skill plus the specialists that serve it (the convention `research/`, `deliberation/`, `engineering/` already follow — context research §6). Every skill the Architecture workflow dispatches — including `mimir-codebase-context`, which its own context gate uses — now lives in `skills/architecture/`; `engineering/` keeps only what is engineering-specific and reaches the architecture family by name (C-11). The arc42 skeleton is Brokk's: Brokk instantiates it (scaffold) and Brokk persists it; Kvasir only fills it.

| Building block | Responsibility | Changed by this objective? |
| --- | --- | --- |
| 5.1.1 `odin-architecture-workflow` | Orchestration doctrine for both modes; caller contract; scaffold step; review gates; persistence; Response | **New** (`skills/architecture/`) |
| 5.1.2 `commands/yggdrasil/architect.md` | Slash command → load the workflow skill | **New** |
| 5.1.3 Odin prompt templates | `§ Workflows` entry, trigger rules, Communication Policy thresholds | Modified |
| 5.1.4 `kvasir-software-architecture` | Dual-mode arc42 drafting into a pre-scaffolded Workfile; no template dependency | Modified; **moved** to `skills/architecture/` |
| 5.1.5 `heimdall-architecture-review` | Scaffold review, architecture-document review (both modes), persisted-directory review | **New** (`skills/architecture/`); `heimdall-engineering-review` reduced accordingly |
| 5.1.6 `odin-engineering-workflow` | Delegates steps 1(arch criteria)/4/5/9 to 5.1.1; step 2 keeps loading `mimir-codebase-context` by name | Modified |
| 5.1.7 `brokk-architecture-persistence` | Persist reviewed Workfile | Consumed; **moved** to `skills/architecture/`; content unchanged (open issue) |
| 5.1.8 `mimir-codebase-context` | Context gate for both workflows; system-scoped in document mode | Consumed; **moved** to `skills/architecture/`; content unchanged (possible one-line scope note — open issue) |
| 5.1.9 `README.md`, capability inventory | Document workflow; fix stale list; document new directory; regenerate | Modified / regenerated |
| 5.1.10 Installer, validator, license notice | Register `architecture` as mandatory; clean relocated deployed copies; update template slug/path | Modified (`setup.sh`, `scripts/validate.sh`, `LICENSES/CC-BY-SA-4.0-arc42.txt`) |
| 5.1.11 `brokk-arc42-template` (was `kvasir-arc42-template`) | Own the arc42 skeleton; scaffold it into the Workfile with header, shape detection, next ADR number, attribution | **Renamed + moved** to `skills/architecture/`; Purpose/When to Use/Workflow rewritten as scaffolding behavior; § Skeleton payload unchanged |

### 5.1.1 Blackbox `odin-architecture-workflow`

- **Purpose / responsibility:** the single source of doctrine for architecture work: mode selection, conditional context gate, Kvasir drafting dispatch, mandatory design review, ratification checkpoint, persistence, Response — and the composite-caller contract.
- **Provided interfaces:**
  - **I-1 Caller contract** (brief lines a composite caller supplies; absent → standalone defaults):
    ```text
    Architecture request: mode=<document-existing | decide-new | infer>, objective=<text | none>, requirements=<Workfile path | none>, context=<Workfile path (reviewed) | none>, persistence=<inline | deferred>, location=<path | docs/architecture/>
    ```
    Contract: `context=<path> (reviewed)` ⇒ context gate skipped (ADR-0004); `persistence=deferred` ⇒ ratification checkpoint, persistence step, and Response step skipped — caller owns them (ADR-0006); `mode=infer` ⇒ inference rule in step 1. The scaffold step (3) is never skipped (ADR-0011).
  - **I-2 Shape verdict** (recorded before any dispatch):
    ```text
    Architecture shape: mode=<document-existing | decide-new>, source=<direction | inference>, context=<yes/no — reason>, persistence=<inline | deferred | declined>
    ```
    Inference rule: an objective naming a change (add/replace/migrate/introduce/split …) → `decide-new`; document/describe/as-is/"how is it structured" language or no change objective → `document-existing`; ambiguous → clarification per Communication Policy (Interactive asks; Guided/Autonomous take `document-existing` and record `source=inference`).
  - **I-3 Return block** (to the user log or the composite caller):
    ```text
    Architecture result: mode=<…>, source=<…>, workfile=<path>, review=<path> — <PASS | PASS-WITH-NOTES>, section-scope=<included=…, omitted=…>, package-check=<verdict | n/a>, shape=<directory | legacy single file | non-arc42 | none>, persisted=<path | deferred | declined | not-reached>, gaps=<n>
    ```
    Failure contract: a `BLOCKED` review after § Failed Review Classification exhausts one resume → return `review=<path> — BLOCKED` and stop; no persistence, no Response claiming success (AC-12). `persisted=` on that exit: `deferred` on a composite call (the caller still owns ratification and persistence timing, unchanged by the block), `not-reached` on a standalone run (steps 6–8 were never entered, so neither a caller nor the user ever decided persistence — `not-reached` exists for exactly this case and no other).
  - **I-4 Trigger verdict** (stated by Odin, defined in 5.1.3): `Architecture check: command=<yes/no>, explicit-request=<yes/no> → <invoke/skip/suggest>`.
  - **Fixed Deliverable:** `Deliverable: response=yes, artifact=yes — persisted arc42 directory (absent only when persistence=deferred to a caller or declined by the user in decide-new mode), source=workflow-fixed`.
  - **I-5 Scaffold brief and result** (step 3):
    ```text
    Scaffold: mode=<document-existing | decide-new>, source=<direction | inference>, workfile=<NN-architecture-arc42.md path>, location=<docs/architecture/ | path>, objective=<text | none>
    Scaffold result: workfile=<path>, document-scope=<seed | update delta>, existing=<path (directory index README.md | legacy single file | non-arc42) | none>, next-adr=<NNNN>, attribution=present
    ```
    `mode=` and `source=` carry forward verbatim from step 1's shape verdict (I-2) — same field order and enumeration as I-2/I-3 — so the scaffolder can pre-fill the `Mode … (source …)` header line directly from the brief without re-derivation (Revision 3). Contract: Brokk writes the skeleton only — header pre-filled (`Status: Proposed`, `Date`, `Document scope`, `Mode … (source …)` from I-5's `mode=`/`source=`, `Section scope: pending`, `Existing document` iff update delta), all twelve headings with their guidance blocks, appendix headings (decide-new) or the `_Not applicable — document-existing mode_` markers (document-existing), the attribution notice at the top; **no section content and no pruning of §1–§12** — pruning is the drafter's judgment. Kvasir's brief then carries `Scaffold: <path>` and the `Scaffold result` line.
- **Workflow steps (doctrine outline):** 1 shape verdict (I-2) → 2 context gate (conditional; Mimir `mimir-codebase-context`, scope = whole system/subsystem in document mode, objective in decide mode; standing `Focus: context` review) → **3 scaffold (always; Brokk `brokk-arc42-template`, I-5; standing review = Heimdall `heimdall-architecture-review`, `Focus: scaffold`, writes `NN-review-architecture-scaffold.md`)** → 4 drafting (Kvasir `kvasir-software-architecture` + `Mode:` line + `Scaffold:` path; fills `NN-architecture-arc42.md` in place) → 5 design review gate (mandatory; Heimdall `heimdall-architecture-review`, `Focus: document`, `Mode:` echoed; writes `NN-review-architecture.md`) → 6 ratification checkpoint (pause/auto per Communication Policy; skipped when `persistence=deferred`) → 7 persistence (Brokk `brokk-architecture-persistence`; skipped when deferred/declined; standing review = Heimdall `heimdall-architecture-review`, `Focus: persistence`, writes `NN-review-architecture-persistence.md`) → 8 Response (Bragi; skipped when deferred) → return block (I-3). `persistence=deferred` skips steps 6–8.
- **Required interfaces:** `Mode:` line accepted by 5.1.4 and 5.1.5; I-5 accepted by 5.1.11; `Focus: scaffold | document | persistence` accepted by 5.1.5; Brokk persistence inputs (reviewed Workfile, ratification record, baseline, location, migration flag); Mimir scope brief.
- **Quality characteristics:** Doctrine Minimization (single owner), Reusability (I-1/I-3 identical for both paths), Cost Proportionality (steps 2, 6–8 conditional; step 3 unconditional by user direction — see Q-3).
- **Location:** `skills/architecture/odin-architecture-workflow/SKILL.md` (new; ADR-0009).
- **Fulfilled acceptance criteria:** AC-3, AC-4, AC-5, AC-6, AC-11, AC-12, AC-13, AC-14, AC-15, AC-18, AC-20.
- **Open issues:** none — the persistence session's standing review is `heimdall-architecture-review` `Focus: persistence` (ADR-0010), and the scaffold session's is `Focus: scaffold` (ADR-0011).

### 5.1.2 Blackbox `commands/yggdrasil/architect.md`

- **Purpose:** route `/yggdrasil/architect <request>` to Odin and load the workflow skill.
- **Provided interface:** frontmatter `description: "arg: request, required — mode inferred or stated (document | decide)"`, `agent: Odin (Interactive)`, `subtask: false`; body: one-paragraph description (both modes, review gate, persistence, "expect to wait"), `Request: $ARGUMENTS`, directive "Load the `odin-architecture-workflow` skill and execute the Architecture workflow defined there on the request above." Mirrors `commands/yggdrasil/engineer.md` lines 1–13.
- **Location:** `commands/yggdrasil/architect.md` (new). Installed by `setup.sh` to `~/.config/opencode/commands/yggdrasil/`.
- **Fulfilled AC:** AC-1. **Open issues:** none (routing mechanism itself is an unverified item in the context research; pattern copied verbatim).

### 5.1.3 Blackbox Odin prompt templates

- **Purpose:** register the workflow in `§ Workflows` and complete its thresholds per Odin variant.
- **Provided interface (edits):**
  - `scripts/odin-generator/shared-body.template.md`, § Workflows (currently lines 145–182): add `### Architecture` between `### Research` and `### Software Engineering` with: one-paragraph description; `**Triggering verdict:**` I-4; `**Invariant trigger rules:**` — `/yggdrasil/architect` → invoke; explicit document-the-architecture / as-is arc42 / decide-the-architecture / ADR language **without implementation intent** → invoke; the same language **with** implementation intent → skip here (Engineering check owns it); a request to understand/explain a codebase's structure that has no architecture document is the suggestion candidate; a pure research request or a question → skip. `**On invoke:**` load `odin-architecture-workflow`. Amend the Software Engineering paragraph (line 176) "gated by its own design review" → "delegated to the Architecture workflow, which carries its own design review".
  - `communication-policy-{interactive,guided,autonomous}.fragment.md` § Trigger Thresholds: add `/yggdrasil/architect` to the **Commands** line; add `**Architecture suggestion candidate:**` (interactive/guided: suggest; autonomous: skip) and `**Architecture ratification checkpoint:**` (interactive: pause; guided/autonomous: auto-proceed, summary rides the Deliverable).
  - Then `scripts/generate-odin-agents.sh`; `validate.sh` Check 4 must pass; consider adding one invariant marker string for Check 7 (open issue).
- **Location:** paths above; generated outputs `agents/odin-{autonomous,guided,interactive}.md` (never hand-edited).
- **Fulfilled AC:** AC-2. **Open issues:** Check 7 marker list not read (gap).

### 5.1.4 Blackbox `kvasir-software-architecture` (dual-mode)

- **Purpose:** fill the pre-scaffolded arc42 Workfile in either mode with the same ADR discipline; decide structure and contracts, never instantiate the skeleton or investigate the repository for its shape.
- **Provided interface:** brief lines `Mode: document-existing | decide-new` (absent ⇒ `decide-new`, preserving today's behavior — Backward Compatibility) and `Scaffold: <path>` plus the `Scaffold result` line (I-5). Workfile header carries `- **Mode:** <mode> (source: <direction | inference>)` (pre-filled by the scaffold; AC-13). **Template dependency removed:** lines 12 and 145 no longer load or name any template skill; the skeleton, header, `Document scope`, `Existing document`, and next ADR number arrive pre-filled. A short "Filling the scaffold" rule set replaces the template's Workflow steps 1–3 and 9: fill or mark every heading (seed: `_Omitted — <reason>_`; update delta: `_Not affected by this change_`), delete each `arc42 guidance §N` block and `> **Yggdrasil:**` note as you fill its section, never delete or renumber a heading, and **delete the attribution notice iff no guidance block survives** — otherwise keep it and name the surviving sections in the report. Workflow step 1's document/ADR-directory lookup shrinks to "read the pre-filled header; in update-delta mode read the existing document's `README.md`, `01-`, `04-`, `05-`, `09-` and every section file this objective touches" (the lookup itself is the scaffold's job). Behavior by mode:
  - `decide-new`: unchanged (Workflow steps 1–11, Appendices A–C, `Package check:`).
  - `document-existing`: inputs = reviewed context Workfile (system-scoped) + optional user focus; §1.1 states the documented scope, §1.2 quality goals *inferred from evidence* and marked so; section scope defaults to all twelve, each filled from cited evidence or marked `_Omitted — no evidence in context Workfile_`; §5/§6/§8 describe what exists, every block citing a path from the context Workfile; Appendix A records **existing** decisions inferable from evidence as ADRs with an extra line `- **Kind:** as-is (inferred from <paths>)`, still `Status: Proposed` (the *description* is what is proposed; promotion on persistence unchanged); Appendices B and C carry the marker `_Not applicable — document-existing mode_`; no `Package check:`; the report's item 3 reads `Package check: n/a`. Boundary added: "never propose a change in document-existing mode — an improvement idea goes to §11 as technical debt, not to §4/§9."
  - Update-delta applies to both modes (document mode over an existing arc42 directory is a refresh delta).
- **Location:** `skills/architecture/kvasir-software-architecture/SKILL.md` — moved from `skills/engineering/` by WP-0 (content unchanged by the move), then edited by WP-3 (Purpose incl. line 12, When to Use, Workflow steps 1/3/4–5/10, Output Contract incl. line 145, Quality Criteria, Anti-Patterns; "Splitting this content into a companion file" anti-pattern text that lived in the template is not needed here).
- **Fulfilled AC:** AC-4, AC-6, AC-7, AC-13.
- **Open issues:** none beyond C-3 wording discipline — in particular the skill must not name `brokk-arc42-template` (say "the scaffolded Workfile the brief names").

### 5.1.5 Blackbox `heimdall-architecture-review` (new dedicated review skill)

- **Purpose / responsibility:** the single owner of every architecture review checklist — the arc42 document in both modes, and the persisted directory — so that no checklist for an architecture artifact lives in the engineering-review skill.
- **Provided interface:**
  - Brief lines: `Focus: scaffold | document | persistence` (exactly one; missing → ask the requesting agent). With `Focus: document`, also `Mode: decide-new | document-existing` (absent ⇒ `decide-new`).
  - Verdict grammar (first line of the review Workfile): `Verdict: <PASS | PASS-WITH-NOTES | BLOCKED> — focus=<scaffold|document|persistence>, mode=<decide-new|document-existing|n/a>, artifact=<path>, <one-clause reason>`.
  - Review Workfile names: `NN-review-architecture-scaffold.md` (scaffold), `NN-review-architecture.md` (document), `NN-review-architecture-persistence.md` (persistence).
  - `Focus: scaffold` (standing review of the Brokk scaffold session; deliberately short — ≤ 8 items): the twelve numbered headings and their subsections are present at the skeleton's levels, none filled; header carries `Status: Proposed`, `Date`, `Document scope`, `Mode … (source …)` equal to the I-5 brief's `mode=` and `source=` values, `Section scope: pending`, and `Existing document: <path> (<shape>)` iff `document-scope=update delta`; the shape classification and `next-adr` in the `Scaffold result` line are re-derived by the reviewer against the live target (resolve the path; read the highest existing decision number); appendix treatment matches the mode; the attribution notice is present (guidance blocks are). BLOCKED on: a missing/renumbered heading; wrong shape or wrong `next-adr`; any filled section content; attribution absent; `Mode` header mismatching the brief.
  - `Focus: document`, `Mode: decide-new`: the checklist currently at `heimdall-engineering-review/SKILL.md` § Focus: architecture (lines 81–95), moved verbatim — header/status/section-scope/existing-document lines, quality goals drive §4/§9/§10, honest pruning, attribution iff guidance survives, ≥2 options per ADR, log↔records one-to-one, §5 paths opened and interfaces test-precise, §6 error paths, Appendix B package fields and `Package check:` consistency, Appendix C exactly-once ownership, update-delta consistency, gaps reported; BLOCKED set unchanged.
  - `Focus: document`, `Mode: document-existing`: the shared items (header, pruning, attribution, log↔records, §5 paths, §6, gaps, update-delta) plus: every §5 block cites a path present in the context Workfile; no proposal language in §4/§9 (BLOCKED if a §9 row proposes a change); each ADR carries `Kind: as-is` with evidence paths; Appendices B/C carry `_Not applicable — document-existing mode_`; `- **Mode:**` header present and matches the brief (BLOCKED if absent or mismatched). The ≥2-options, Appendix B, and Appendix C items do not apply.
  - `Focus: persistence`: the "Persisted architecture — merged, never overwritten" items (a)–(f), "Decision records promoted correctly", "Log-to-file consistency both ways", and "Planning material stays transient", currently at `heimdall-engineering-review/SKILL.md` lines 125–136, moved verbatim, with their BLOCKED conditions; inputs are the persistence manifest, the reviewed Workfile, the ratification record, and the pinned baseline. No test-suite item (a standalone run has none).
  - Common steps 0–2 (control line, pin baseline, common checks, review Workfile order) mirror the engineering-review skill's, restated here because a skill must be self-contained (C-1 five sections + Boundaries). The skill names no foreign slug (C-3): it says "the scaffold session", "the drafting step", "the persistence manifest".
- **Effect on `heimdall-engineering-review`** (`skills/engineering/heimdall-engineering-review/SKILL.md`, stays in place): Purpose table row `architecture` (line 15) deleted; verdict grammar (line 24), When to Use (line 44), and Step 0 (line 55) list `context | package | integration`; a `Not for` line added: "architecture documents and their persisted form — reviewed by the dedicated architecture-review skill (`heimdall-architecture-review`)"; § Focus: architecture (lines 81–95) **deleted**, not deprecated; in § Focus: integration, lines 125–136 replaced by one bullet — "**Persisted architecture.** When the manifest reports a persistence action, load `heimdall-architecture-review` by name and apply its `Focus: persistence` checklist to the persisted directory; its blocking conditions are blocking here." — and the BLOCKED line (137) trimmed to match; Step 2's filename list drops `NN-review-architecture.md`. The engineering integration review therefore keeps checking the persisted architecture with the same items at the same dispatch (Backward Compatibility), sourced from one place (Doctrine Minimization). Cross-references: heimdall→heimdall skill (Check 5 self-reference allowed); `engineering/`→`architecture/` is mandatory→mandatory once WP-0 lands (Check 9).
- **Location:** `skills/architecture/heimdall-architecture-review/SKILL.md` (new); `name: heimdall-architecture-review`; nameless description (Check 6); no other agent named (Check 5).
- **Fulfilled AC:** AC-11, AC-12, AC-14.
- **Open issues:** none.

### 5.1.6 Blackbox `odin-engineering-workflow` (delegating)

- **Provided interface (edits):**
  - Purpose paragraph "One review gate beyond the standing rules" (line 26) → replaced by one sentence: the architecture step is the Architecture workflow, which carries its own design review.
  - Step 1: keep the `Engineering shape:` line and the context/analysis criteria; the **Architecture** bullet shrinks to: "fires per the decide-new firing criteria in `odin-architecture-workflow` § When to Use, and **without exception whenever two or more work packages are expected**."
  - Step 4 → "**Architecture (optional).** Load `odin-architecture-workflow` and execute it with `Architecture request: mode=decide-new, objective=<…>, requirements=<path>, context=<reviewed path | none>, persistence=deferred`. Record its return block. Ratification is yours at the checkpoint; promotion happens at persistence."
  - Step 5 removed; steps 6–10 renumbered 5–9; internal references updated (step 6's "reviewed architecture document", the Review-skill assignment table row "Architecture document (step 5) · `Focus: architecture`" → "reviewed inside the Architecture workflow by `heimdall-architecture-review`", line 89's "except the added design review in step 5"). The Purpose paragraph (line 14) listing per-step skills drops `kvasir-software-architecture`, `kvasir-arc42-template`, and `brokk-architecture-persistence` in favor of "the Architecture workflow's skills (loaded by `odin-architecture-workflow`)" — the slugs still resolve after the move (C-11), but the engineering skill should no longer enumerate another workflow's specialists.
  - Old step 9 (integration): the persistence sentence block → "When the architecture step fired, this session also runs the Architecture workflow's persistence step (`odin-architecture-workflow` step 7) with the ratification record from the checkpoint; its brief contents are defined there."
  - Step 2 (context gate) is **unchanged**: it dispatches `mimir-codebase-context` by name; the skill's relocation to `skills/architecture/` has no effect (C-11; the only other mention, line 14, is the Purpose enumeration being rewritten anyway). Re-verified by grep: no path reference to `mimir-codebase-context` exists anywhere in the repo (C-10).
- **Location:** `skills/engineering/odin-engineering-workflow/SKILL.md` (lines 14, 26, 35–52, 85, 89–98).
- **Fulfilled AC:** AC-8, AC-9, AC-10, AC-19, AC-20.
- **Open issues:** renumbering vs. leaving a tombstone step — decided: renumber (ADR-0005).

### 5.1.7 / 5.1.8 Consumed blocks

- `brokk-architecture-persistence` (moved to `skills/architecture/brokk-architecture-persistence/SKILL.md` by WP-0; the move itself changed no content): inputs unchanged (reviewed Workfile, ratification record, baseline, location, migration flag). Document mode supplies a ratification record listing the as-is ADR IDs ratified. **Open issue closed:** the index footer and the When to Use entry were reworded to name both callers. Content has changed since delivery — those two wording fixes, plus the two-level heading-promotion rule for decision records and the not-persisted disposition of Workfile-level process metadata.
- `mimir-codebase-context` (moved to `skills/architecture/mimir-codebase-context/SKILL.md` by WP-0; content unchanged): scope is "a software engineering objective"; document mode passes "the system as a whole (or `<subsystem>`)" as the objective. Both workflows dispatch it by name — `odin-engineering-workflow` step 2 and `odin-architecture-workflow` step 2 — so its directory is irrelevant to either (C-11). **Open issue:** whether one clarifying line in its When to Use is needed — defer to implementation review.
- `brokk-arc42-template` — see 5.1.11 (it is no longer merely consumed).

### 5.1.9 README and capability inventory

- `README.md`: fix lines 177–184 (add `brokk-architecture-persistence`; then reflect the moves — the `engineering/` block lists `odin-engineering-workflow`, `bragi-business-analysis`, `brokk-test-driven-development`, `heimdall-engineering-review`; a new `architecture/` block lists `odin-architecture-workflow`, `mimir-codebase-context`, `brokk-arc42-template`, `kvasir-software-architecture`, `heimdall-architecture-review`, `brokk-architecture-persistence`); line 131's **Required** bullet list gains a new `- **Architecture skills** (…) → ~/.config/opencode/skills/yggdrasil/architecture/` bullet naming the six mandatory architecture skills (incl. `brokk-arc42-template`), and the Engineering bullet drops the four relocated slugs — this Required list (lines 128–131) is where mandatory skills are documented; the **"Available optional skills by agent"** table at lines 210–216 must **not** gain `brokk-arc42-template` (it is mandatory, exactly like `brokk-architecture-persistence`, which is correctly absent from that table today); line 273 mandatory-directory sentence adds `architecture/`; command list adds `/yggdrasil/architect`; new "Architecture workflow" usage section beside the engineering one (~line 392); an upgrade note that `setup.sh` removes relocated skill copies from `engineering/` in the config home. Run `config-home/generate-capabilities.sh` (C-7). **Fulfilled AC:** AC-16, AC-17.

### 5.1.10 Installer, validator, and license notice (registration of the new directory)

- **Provided interface (edits):**
  - `setup.sh:167` → `MANDATORY_SKILL_DIRS="research memories deliberation engineering architecture"`; `setup.sh:362` warning text lists `architecture/`; after the mandatory copy loop (line 358), a cleanup that removes, when present, `${DST_SKILLS}/engineering/{kvasir-software-architecture,kvasir-arc42-template,brokk-architecture-persistence,mimir-codebase-context}` — relocated (and, for the template, renamed) skills whose stale copies would otherwise be installed twice under the same `name`, or under the old name (C-6).
  - `scripts/validate.sh:762` → the same five-entry list; comments at lines 40 and 443 updated. No check logic changes: Check 9 derives optional roots from the list, so `architecture/` becomes a mandatory root automatically; Check 5 derives the template's owner as `brokk` from its new slug automatically.
  - `LICENSES/CC-BY-SA-4.0-arc42.txt` line 6 → `brokk-arc42-template skill:`; lines 8 and 66 → `skills/architecture/brokk-arc42-template/SKILL.md` (C-10).
  - `config-home/generate-capabilities.sh:155` comment updated (no logic change — role derivation is by slug prefix; the renamed template lands under Implementer automatically).
  - The four directory moves (`git mv skills/engineering/{kvasir-software-architecture,brokk-architecture-persistence,mimir-codebase-context} skills/architecture/` and `git mv skills/engineering/kvasir-arc42-template skills/architecture/brokk-arc42-template`), with file contents byte-identical **except two rename-forced edits in the template**: frontmatter `name: brokk-arc42-template` (Check 3) and line 43's `kvasir-software-architecture` → "the architecture-drafting step" (Check 5, C-3). The template's Purpose/Workflow rewrite is WP-3's, not WP-0's.
- **Invariant after this block lands:** `scripts/validate.sh` passes all ten checks with no content edits beyond the two rename-forced ones — the move is behavior-neutral by construction (Q-10).
- **Location:** `setup.sh`, `scripts/validate.sh`, `LICENSES/CC-BY-SA-4.0-arc42.txt`, `config-home/generate-capabilities.sh` (comment), `skills/architecture/` (directory, five relocated/renamed entries).
- **Fulfilled AC:** AC-15.
- **Open issues:** whether `setup.sh` should also warn when it removes a relocated copy (recommend: one `info` line per removal).

### 5.1.11 Blackbox `brokk-arc42-template` (renamed from `kvasir-arc42-template`; scaffolds)

- **Purpose / responsibility:** own the arc42 skeleton (the § Skeleton payload, unchanged, with its attribution block) **and** instantiate it: detect the target document's shape and next ADR number, write the skeleton into the architecture Workfile with a pre-filled header, and report the `Scaffold result` line. This is Brokk's natural seam — Brokk already classifies document shape and resolves the decision directory in `brokk-architecture-persistence` steps 2–3; the scaffold step performs the same classification at the start so that Kvasir never has to.
- **Provided interface:** I-5 (§5.1.1). Workflow (rewritten from the current "how the drafter instantiates" rules into the scaffolder's own procedure): (1) read `Scaffold:` brief line; (2) resolve the target: look for `docs/architecture/`, `docs/arc42*`, `architecture/`, `doc/`, README links; classify as arc42 directory / legacy single file / non-arc42 / none (the same four shapes and the same read set the persistence skill uses) ⇒ `document-scope`; (3) resolve the decision directory and highest existing number ⇒ `next-adr`; (4) write the Workfile: title promoted to `#`, header block pre-filled (`Status: Proposed`, `Date`, `Document scope`, `Mode … (source …)` copied directly from I-5's `mode=` and `source=` fields — the brief carries both, so no re-derivation and no separate mechanism; a brief lacking either field is a malformed brief → ask the requesting agent, write nothing —, `Section scope: pending`, `Existing document` iff update delta), attribution block directly under the title, §1–§12 with every guidance block and Yggdrasil note intact, Appendices A–C headings (decide-new) or A heading + B/C n/a markers (document-existing); write **no** section content and prune **no** section — pruning is the drafter's judgment; (5) report I-5's result line. Boundaries: never fill a section; never decide scope; never edit an existing project document (the scaffold is a Workfile). The fill-in rules that were the template's Workflow steps 1–3, 9 (delete guidance as you fill, keep headings, omission markers, attribution iff guidance survives) move to `kvasir-software-architecture` (§5.1.4); the template retains the "attribution travels with arc42 text" statement as reader guidance because the license block is skill-level content.
- **Required interfaces:** the target project tree (read-only); the brief.
- **Quality characteristics:** Doctrine Minimization (skeleton + instantiation in one owner); Clarity of Intent (`Mode` header pre-filled from the verdict).
- **Location:** `skills/architecture/brokk-arc42-template/SKILL.md` — renamed/moved by WP-0 (with the two rename-forced edits), Purpose/When to Use/Workflow/Quality Criteria/Anti-Patterns rewritten by WP-3; § Skeleton payload and the `Attribution and license` block unchanged; frontmatter `description` nameless (Check 6); no foreign slug or agent name anywhere (Check 5).
- **Fulfilled AC:** AC-4, AC-6 (jointly with 5.1.4 — the scaffold is the precondition of both modes' Workfile).
- **Open issues:** none.

## 5.2 Level 2

_Omitted — no block is decomposed further; the doctrine outline in 5.1.1 is the whitebox of the only new block._

## 5.3 Level 3

_Omitted — not needed._
