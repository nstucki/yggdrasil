# 10. Quality Requirements

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§10](README.md)._

## 10.1 Quality Requirements Overview

The quality tree refines the goals of §1.2 into the attributes the system's mechanisms observably serve. Rows 1–5 refine the five inferred system goals; rows D1–D5 refine the five stated goals of the architecture-documentation subsystem. Every leaf traces to a mechanism cited in §5 or §8.

| Goal (§1.2) | Attribute | Mechanism |
| --- | --- | --- |
| 1 Independent verification | Reviewer independence; ground-truth verification; gate completeness | §8.1 review gates; `agents/odin-autonomous.md:245-265` |
| 2 Role isolation / least privilege | Tool-surface minimality; cross-agent opacity; scope discipline | §8.2, §8.6; permission blocks; validator Check 5 |
| 3 Reproducibility | Generator determinism; committed-vs-generated parity | §8.8; validator Check 4; smoke tests |
| 4 Traceability | Source citation; Memory provenance and lifecycle | §8.4; Memory schema `sources`, `confidence`, `status` |
| 5 Extensibility at install site | Repo-untouched extension; inventory regeneration | §5.1.8; `custom-capabilities.yaml`; `generate-capabilities.sh` |
| D1 Durability | Task-scoped content excluded at source, draft, and gate; references resolve inside the document | §5.2 I-1, I-3, I-4 |
| D2 Clarity | Omission reason visible in the marker; scope stated with reasons in the report | §5.2 I-2 |
| D3 Maintainability | Delta touches only the documents the objective changes; refresh on re-authoring | §5.2 I-1 refresh rule, I-5 |
| D4 Consistency | One test text, three consumers, zero mode or scope exemptions | §5.2 I-1, I-4 |
| D5 Usability | §5 and §9 carry contracts and decisions, no implementation-phase guidance | §5.2 I-1 per-section application |

## 10.2 Quality Scenarios

Each scenario states what the goal implies and whether the measure was **observed** in the evidence, is **unverified** (implied by doctrine but not demonstrated by execution), or is a **target** the work packages of Appendix B must reach.

| ID | Goal | Stimulus | Response | Measure | Status |
| --- | --- | --- | --- | --- | --- |
| QS-1 | 1 | Any Mimir or Brokk Subtask completes | Odin dispatches a dedicated Heimdall review with the full output path and the exact brief before any dependent work | 1 review dispatch per Subtask; 0 Deliverables handed over without a passing Final Review Gate | Unverified — doctrine at `agents/odin-autonomous.md:252-258`; no execution trace in evidence |
| QS-2 | 1 | Heimdall returns `BLOCKED` three times consecutively for one producer session | Odin stops the fix loop and takes a disclosed terminal action | ≤ 3 fix rounds per producer session; 1 Kvasir consult after the 2nd failure | Unverified — `agents/odin-autonomous.md:275` |
| QS-3 | 2 | Odin attempts to read a Workfile or edit a project file | The host denies the call — Odin's permission block grants no file tools | 0 file tools allowed to Odin (`read`, `edit`, `bash`, `glob`, `grep` all absent) | Observed — `agents/odin-autonomous.md:6-19` |
| QS-4 | 2 | Brokk attempts to `edit` a file under `.yggdrasil-workspace/`, or Mimir attempts to `edit` outside it | The host denies the call | 2 deny globs for Brokk; 1 deny-all + 2 allow globs for Mimir | Observed — `agents/brokk.md:53-56`; `agents/mimir.md:55-58` |
| QS-5 | 2 | A subagent prompt or skill mentions another agent by name | `validate.sh` Check 5 fails with a non-zero exit | 0 cross-agent name references permitted | Observed (rule) — `scripts/README.md:71, 81`; run result not in evidence |
| QS-6 | 3 | A maintainer edits `agents/odin-guided.md` directly | `validate.sh` Check 4 and `ci-smoke-odin-generator.sh` fail | 0 bytes of difference tolerated across all 8 agent files | Observed (rule) — `scripts/README.md:70, 87-90`; run result not in evidence |
| QS-7 | 4 | Brokk promotes a Memory entry with an empty `sources` list or a credential | Heimdall's review blocks the write | 100 % of Memory entries carry ≥ 1 source; 0 secrets promoted | Unverified — `skills/memories/brokk-memory-curation/SKILL.md:104-110`; `skills/memories/odin-memory-system/SKILL.md:31, 57-58` |
| QS-8 | 5 | An operator adds a skill or a custom tool grant in the configuration home and re-runs `setup.sh` | The capability inventory regenerates and Odin plans against it on the next session | 1 regeneration per install; 0 repository files changed | Observed (rule) — `README.md:122`; `scripts/README.md:162-166`; `setup.sh:349-393` copies repository trees into the configuration home and regenerates the inventory |
| QS-9 | D1 | A `decide-new` delta is persisted into any target project | No topic document or record written by the delta contains a task-scoped reference | 0 matches of `\.yggdrasil-workspace/[0-9]{8}-` and `Revision [0-9]+:` across the documents the delta wrote; 0 `AC-[0-9]+` tokens in §1–§12; 0 sentences citing a review verdict as provenance of the document (reviewer-counted — a verdict quoted as doctrine, e.g. in 5.1.1, is not provenance) | Target — WP-1 |
| QS-10 | D2 | A Workfile omits any section or subsection | Every marker is one of the three I-2 strings and the `Section scope:` line carries a type tag per omitted section; the report carries one rationale clause per omitted section | 100 % of markers in the closed set; 100 % of omitted sections tagged; 1 rationale clause per omitted section | Target — WP-1 |
| QS-11 | D3 | A delta changes one building block of a section persisted as ten documents | The drafter re-authors one topic document; the other nine are carried forward byte-identical | 1 re-authored document; 9 documents with 0 bytes changed; 0 "Superseded documents" entries without a `→ superseded` row | Target — WP-3 |
| QS-12 | D4 | A `document-existing` refresh and a `decide-new` delta run over the same target | The design review applies the same long-term-relevance item to both | 1 shared item under `Focus: document`; 0 mode-specific exemptions from it | Target — WP-2 |
| QS-13 | D5 | An implementation session reads §5 and §9 of a persisted document to brief a work package | It finds interfaces, invariants, and decisions and no implementation-phase guidance | 0 statements in §5 blackbox entries or §9 records matching the minutiae tell-tales (helper structure, naming inside a block, test-case selection), reviewer-counted | Target — WP-1 |
| QS-14 | D1 (gate) | A fixture Workfile carries one workspace path of the form `.yggdrasil-workspace/<yyyymmdd>-…` in §1.1 and is reviewed under `Focus: document` | The review returns `BLOCKED` with a finding naming §1.1 and the path | 1 blocking finding; 0 `PASS` or `PASS-WITH-NOTES` verdicts | Target — WP-2 |
| QS-15 | D3 (propagation) | A maintainer edits any `skills/architecture/*/SKILL.md` and runs `./setup.sh -y` | The installed copy equals the repository copy | 0 lines from `git diff --no-index --stat skills/architecture <config-base>/skills/yggdrasil/architecture`; `scripts/validate.sh` exit 0 | Target — integrate step |
