# 10. Quality Requirements

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§10](README.md)._

## 10.1 Quality Requirements Overview

The quality tree refines the standing goals S1–S5 (unchanged) and the four revision goals into the attributes the system's mechanisms serve. Every leaf traces to a mechanism cited in §5 or §8.

| Goal | Attribute | Mechanism |
| --- | --- | --- |
| S1 Independent verification | Reviewer independence; ground-truth verification; gate completeness — extended to image Artifacts | §8.1 review gates; `agents/odin-autonomous.md:245-265`; `shared-body.template.md:225` (revised) |
| S2 Role isolation / least privilege | Tool-surface minimality; cross-agent opacity; scope discipline — Eitri's profile | §8.2, §8.6; ADR-0010 permission block; validator Check 5 with `eitri` |
| S3 Reproducibility | Generator determinism; committed-vs-generated parity — nine files | §8.8; validator Check 4; smoke tests |
| S4 Traceability | Source citation; Memory provenance; image manifests recording model and parameters | §8.4; §5.1.2 manifest contract |
| S5 Extensibility at install site | Repo-untouched extension; inventory regeneration; model override without repo edits | §5.1.8; §8.10; ADR-0009 |
| Consistency (revision goal 1) | Structural parity of the sixth agent with the five; zero Odin special cases | §5.1.2 template shape; §5.1.7 roster contract; ADR-0011 |
| Configurability (revision goal 2) | Per-agent model swap without code, durable across upgrades | §8.10; ADR-0009 |
| Clarity (revision goal 3) | Complete pantheon documentation; explicit boundaries and non-capabilities | §5.1.2 Eitri row and boundaries; README updates (WP-4); ADR-0010 stated needs |
| Maintainability (revision goal 4) | Additive change via templates and enumerated roster lists; no hidden dependency | §5.1.7; §8.8; ADR-0011 (debt R12 acknowledged) |

## 10.2 Quality Scenarios

QS-1–QS-8 stand from the seed document with one correction (QS-6: nine agent files). QS-9 onward are this revision's candidate non-functional tests; each measure carries a number and a unit.

| ID | Goal | Stimulus | Response | Measure | Status |
| --- | --- | --- | --- | --- | --- |
| QS-1 | S1 | Any Mimir, Brokk, or Eitri Subtask completes | Odin dispatches a dedicated Heimdall review with the full output path and the exact brief before any dependent work | 1 review dispatch per Subtask; 0 Deliverables handed over without a passing Final Review Gate | Unverified — doctrine at `agents/odin-autonomous.md:252-258` |
| QS-2 | S1 | Heimdall returns `BLOCKED` three times consecutively for one producer session | Odin stops the fix loop and takes a disclosed terminal action | ≤ 3 fix rounds per producer session; 1 Kvasir consult after the 2nd failure | Unverified — `agents/odin-autonomous.md:275` |
| QS-3 | S2 | Odin attempts to read a Workfile or edit a project file | The host denies the call — Odin's permission block grants no file tools | 0 file tools allowed to Odin | Observed — `agents/odin-autonomous.md:6-19` |
| QS-4 | S2 | Brokk attempts to `edit` a file under `.yggdrasil-workspace/`, or Mimir attempts to `edit` outside it | The host denies the call | 2 deny globs for Brokk; 1 deny-all + 2 allow globs for Mimir | Observed — `agents/brokk.md:53-56`; `agents/mimir.md:55-58` |
| QS-5 | S2 | A subagent prompt or skill mentions another agent by name | `validate.sh` Check 5 fails with a non-zero exit | 0 cross-agent name references permitted | Observed (rule) — `scripts/validate.sh:433-496` |
| QS-6 | S3 | A maintainer edits `agents/odin-guided.md` or `agents/eitri.md` directly | `validate.sh` Check 4 and the matching smoke test fail | 0 bytes of difference tolerated across all **9** agent files | Observed (rule) — `scripts/validate.sh:338-431`; `scripts/README.md:70, 87-95` |
| QS-7 | S4 | Brokk promotes a Memory entry with an empty `sources` list or a credential | Heimdall's review blocks the write | 100 % of Memory entries carry ≥ 1 source; 0 secrets promoted | Unverified — `skills/memories/brokk-memory-curation/SKILL.md:104-110` |
| QS-8 | S5 | An operator adds a skill or a custom tool grant in the configuration home and re-runs `setup.sh` | The capability inventory regenerates and Odin plans against it on the next session | 1 regeneration per install; 0 repository files changed | Unverified — `README.md:127`; `scripts/README.md:162-166` |
| QS-9 | Consistency | WP-1–WP-4 land and `bash scripts/validate.sh` runs | Every check passes | 10 of 10 checks `PASS`; exit code 0; Check 4 message reports 3 Odin agents and 6 subagents | Test — `scripts/validate.sh:427` (revised message) |
| QS-10 | Consistency | `scripts/generate-subagents.sh --agent eitri --print` is diffed against `agents/eitri.md` | Byte-identical | 0 bytes of difference; `ci-smoke-subagent-generator.sh` exits 0 with 6 ✓ lines | Test — AC-5 |
| QS-11 | Consistency | The Odin templates are diffed before and after WP-2 | Only roster-shaped edits | ≤ 6 changed lines across `preamble.template.md` and `shared-body.template.md` (1 allowlist line, 1 selection-guide row, 1 Workfile-writer sentence, 1 Artifact sentence, 2 review-rule lines); 0 conditionals mentioning `eitri` elsewhere; 15 of 15 Check 7 markers present | Test — `scripts/validate.sh:598-625` |
| QS-12 | Configurability | An operator sets `agent.eitri.model` in the configuration home's `opencode.json` and starts a new Eitri session | Eitri's session reports the new model in the manifest `Model` row | 0 repository edits; 0 regenerations; 0 `setup.sh` runs; change effective within 1 session start; value unchanged after 1 subsequent `setup.sh` upgrade | Manual acceptance (host behavior; not CI-testable) — AC-7, AC-8 |
| QS-13 | Configurability | An operator edits `model:` in the installed `eitri.md` instead, then runs `setup.sh` | The edit is effective until the upgrade, then reverts to the shipped default | 1 upgrade reverts it; README documents this in ≥ 1 sentence | Manual acceptance + doc test — `README.md:111` |
| QS-14 | Configurability | Two distinct model ids are configured in turn (e.g., one local, one cloud) and an identical brief is dispatched under each | Both sessions produce a manifest whose `Model` row names the configured id | 2 configurations exercised; 2 of 2 manifests carry the matching id or `unknown` with a stated reason | Manual acceptance — requirements § Quality Goals target |
| QS-15 | Clarity | A reader opens `README.md` after WP-4 | The pantheon is complete and counts agree | 7 rows in the pantheon table; 7 `####` entries under "The Pantheon — in myth"; 0 occurrences of "five subagent", "five specialist", "six agents", or "six specialized" remaining in `README.md`, `scripts/README.md`, and `scripts/*.sh` comments | Test — grep-based, WP-4 done criterion |
| QS-16 | Clarity | `config-home/generate-capabilities.sh --print` runs against a layout containing `eitri.md` | The inventory shows the Designer | 1 `### Designer` section; 1 description line under it; 0 occurrences of any of the 7 agent names anywhere in the output | Test — `scripts/ci-smoke-generator.sh` (revised) — AC-11 |
| QS-17 | Maintainability | A maintainer adds a hypothetical seventh specialist by analogy to this revision | The roster touch list is complete and documented | ≤ 7 script/template files touched (the ADR-0011 list); `scripts/README.md` names every one of them in 1 subsection | Doc test — WP-1 done criterion |
| QS-18 | S2 / Clarity | Eitri attempts to `edit` a `.pdf`, a `.md` outside the workspace, or `.yggdrasil-memory/INDEX.md` | The host denies the call — no allow glob matches | 0 writes outside the 8 allow globs; 0 `*.md` allows reaching outside `.yggdrasil-workspace/`; (amended per R21: 0 explicit Memory deny globs — protection is by construction, as for Mimir/Bragi/Kvasir/Heimdall) | Observed (rule) — `eitri.template.md:8-17`; ADR-0010 (amended) |
