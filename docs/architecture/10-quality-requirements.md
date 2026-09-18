# 10. Quality Requirements

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 10.1 Quality Requirements Overview

_Omitted — fewer than ten scenarios; see 10.2._

## 10.2 Quality Scenarios

| ID | Quality goal | Stimulus | Response | Measure |
| --- | --- | --- | --- | --- |
| Q-1 | Doctrine Minimization | Refactor of `odin-engineering-workflow` steps 1(arch bullet)/4/5/9 lands | Architecture doctrine there is references + caller contract only | Word count of those passages ≤ 50% of baseline (baseline: lines 26, 44 arch bullet, 50, 52, 85 persistence sentences ≈ 620 words → ≤ 310 words) |
| Q-2 | Doctrine Minimization | A maintainer changes the review-gate rule | Edit touches exactly one skill file | 1 file (`odin-architecture-workflow/SKILL.md`), 0 edits elsewhere |
| Q-3 | Cost Proportionality | Standalone run (either mode) with context already established | Dispatches: Brokk(scaffold), Heimdall(scaffold standing), Kvasir, Heimdall(document), Brokk(persistence), Heimdall(persistence standing), Bragi | ≤ 7 dispatches (was ≤ 5 before the user-directed scaffold step); with context gate firing ≤ 9 (adds Mimir + standing review); decide-new standalone with persistence declined ≤ 5 |
| Q-4 | Reusability | Same objective run standalone (decide-new) and via engineering | Workfile headers identical in all fields except `Date`; return block fields identical | 100% of 6 header fields; 100% of I-3 fields |
| Q-5 | Backward Compatibility | `/yggdrasil/engineer` with architecture firing, before vs after | Same dispatch sequence and Workfile set | Δ dispatches = **+2 exactly** (Brokk scaffold + its standing review — user-directed, ADR-0011; NF-3 superseded), no other additions; same Workfile names (`NN-architecture-arc42.md`, `NN-review-architecture.md` — now written by `heimdall-architecture-review`) plus the new `NN-review-architecture-scaffold.md`; checkpoint content and ratification timing unchanged; integration review still applies the persisted-architecture items (loaded by name) |
| Q-6 | Backward Compatibility | `kvasir-software-architecture` briefed without a `Mode:` line | Behaves as decide-new | 0 behavioral differences from today's Output Contract |
| Q-7 | Clarity of Intent | Any completed run | `Mode:` + source in Workfile header and Response | Present in 100% of runs; reviewer BLOCKs on absence |
| Q-8 | Cost Proportionality | Trigger evaluation | One verdict line, no dispatch | 0 dispatches; 1 line, same grammar as the other three checks (NF-7) |
| Q-9 | Reusability / Compatibility | `scripts/validate.sh` after implementation | All checks green | 10/10 checks PASS; Check 4 regeneration diff = 0 bytes |
| Q-10 | Backward Compatibility | `scripts/validate.sh` immediately after WP-0 (directory moves, template rename with its two rename-forced edits, list registration) | All checks green; a fresh mandatory-only `setup.sh` install contains the six architecture skills once each and no `kvasir-arc42-template` | 10/10 checks PASS; `find <config>/skills/yggdrasil -name SKILL.md` shows each relocated/renamed slug exactly 1× (0 stale copies under `engineering/`, 0 hits for `kvasir-arc42-template`) |
| Q-11 | Doctrine Minimization | Grep for the persisted-architecture checklist items (a)–(f) across `skills/` | Text exists in exactly one skill file | 1 file (`heimdall-architecture-review/SKILL.md`); `heimdall-engineering-review` carries only the one-bullet load-by-name reference |
| Q-12 | Doctrine Minimization | Grep for `arc42-template` and for the arc42 § Skeleton heading text across `skills/` | The skeleton and every reference to the template skill exist only where Brokk owns them or Odin dispatches them | § Skeleton in 1 file (`brokk-arc42-template/SKILL.md`); `kvasir-software-architecture/SKILL.md` and `heimdall-*` skills contain 0 occurrences of `arc42-template` (C-3) |
| Q-13 | Cost Proportionality | Standing review of a scaffold session | `Focus: scaffold` is short and mechanical | ≤ 8 checklist items; review Workfile ≤ 1 page; 0 re-derivation beyond path resolution and highest-ADR lookup |
