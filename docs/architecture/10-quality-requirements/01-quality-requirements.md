# 10. Quality Requirements

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§10](README.md)._

## 10.1 Quality Requirements Overview

The quality tree below refines the five inferred goals of §1.2 into the attributes the system's mechanisms observably serve. Every leaf traces to a mechanism cited in §5 or §8.

| Goal (§1.2) | Attribute | Mechanism |
| --- | --- | --- |
| 1 Independent verification | Reviewer independence; ground-truth verification; gate completeness | §8.1 review gates; `agents/odin-autonomous.md:245-265` |
| 2 Role isolation / least privilege | Tool-surface minimality; cross-agent opacity; scope discipline | §8.2, §8.6; permission blocks; validator Check 5 |
| 3 Reproducibility | Generator determinism; committed-vs-generated parity | §8.8; validator Check 4; smoke tests |
| 4 Traceability | Source citation; Memory provenance and lifecycle | §8.4; Memory schema `sources`, `confidence`, `status` |
| 5 Extensibility at install site | Repo-untouched extension; inventory regeneration | §5.1.8; `custom-capabilities.yaml`; `generate-capabilities.sh` |

## 10.2 Quality Scenarios

Each scenario states what the inferred goal implies and whether the measure was **observed** in the evidence or is **unverified** (implied by doctrine but not demonstrated by execution in the context Workfile).

| ID | Goal | Stimulus | Response | Measure | Status |
| --- | --- | --- | --- | --- | --- |
| QS-1 | 1 | Any Mimir or Brokk Subtask completes | Odin dispatches a dedicated Heimdall review with the full output path and the exact brief before any dependent work | 1 review dispatch per Subtask; 0 Deliverables handed over without a passing Final Review Gate | Unverified — doctrine at `agents/odin-autonomous.md:252-258`; no execution trace in evidence |
| QS-2 | 1 | Heimdall returns `BLOCKED` three times consecutively for one producer session | Odin stops the fix loop and takes a disclosed terminal action | ≤ 3 fix rounds per producer session; 1 Kvasir consult after the 2nd failure | Unverified — `agents/odin-autonomous.md:275` |
| QS-3 | 2 | Odin attempts to read a Workfile or edit a project file | The host denies the call — Odin's permission block grants no file tools | 0 file tools allowed to Odin (`read`, `edit`, `bash`, `glob`, `grep` all absent) | Observed — `agents/odin-autonomous.md:6-19` |
| QS-4 | 2 | Brokk attempts to `edit` a file under `.yggdrasil-workspace/`, or Mimir attempts to `edit` outside it | The host denies the call | 2 deny globs for Brokk; 1 deny-all + 2 allow globs for Mimir | Observed — `agents/brokk.md:53-56`; `agents/mimir.md:55-58` |
| QS-5 | 2 | A subagent prompt or skill mentions another agent by name | `validate.sh` Check 5 fails with a non-zero exit | 0 cross-agent name references permitted | Observed (rule) — `scripts/README.md:71, 81`; run result not in evidence |
| QS-6 | 3 | A maintainer edits `agents/odin-guided.md` directly | `validate.sh` Check 4 and `ci-smoke-odin-generator.sh` fail | 0 bytes of difference tolerated across all 8 agent files | Observed (rule) — `scripts/README.md:70, 87-90`; run result not in evidence |
| QS-7 | 4 | Brokk promotes a Memory entry with an empty `sources` list or a credential | Heimdall's review blocks the write | 100 % of Memory entries carry ≥ 1 source; 0 secrets promoted | Unverified — `skills/memories/brokk-memory-curation/SKILL.md:104-110`; `skills/memories/odin-memory-system/SKILL.md:31, 57-58` |
| QS-8 | 5 | An operator adds a skill or a custom tool grant in the configuration home and re-runs `setup.sh` | The capability inventory regenerates and Odin plans against it on the next session | 1 regeneration per install; 0 repository files changed | Unverified — `README.md:122`; `scripts/README.md:162-166`; `setup.sh` not read |
