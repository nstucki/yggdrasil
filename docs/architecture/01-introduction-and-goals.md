# 1. Introduction and Goals

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](README.md)._

## 1.1 Requirements Overview

A new packaged Odin workflow, **Architecture**, that (a) runs standalone via `/yggdrasil/architect` and explicit-language triggers; (b) runs in one of two modes — `document-existing` (as-is arc42 record) or `decide-new` (arc42 + ADRs + work packages, what `kvasir-software-architecture` does today); (c) is invoked by `odin-engineering-workflow` in place of its inline architecture doctrine (steps 1, 4, 5, 9); (d) always persists document-existing output as a repo Artifact via `brokk-architecture-persistence`, after a mandatory Heimdall design review inside the workflow.

**Acceptance criteria in scope:** AC-1 … AC-20 (`03-requirements.md` § Acceptance Criteria).

**Deliverable adaptation:** the system under design is *orchestration doctrine* — SKILL.md files, a command file, and Odin prompt templates — not application code. "Building blocks" are markdown doctrine files; "interfaces" are brief lines and verdict lines; "tests" are review checklists and `scripts/validate.sh` (ADR-0007).

## 1.2 Quality Goals

Adopted verbatim (ranked) from `03-requirements.md` § Quality Goals.

| Rank | Quality goal | Motivation for this change | Scenario hint |
| --- | --- | --- | --- |
| 1 | **Doctrine Minimization** | Architecture doctrine is duplicated across engineering steps 1/4/5/9 and the specialist skills. | Engineering workflow's architecture step text shrinks ≥50%; one skill owns dispatch, mode selection, review gating. |
| 2 | **Reusability** | Standalone and composite callers must get identical behavior without duplicated logic. | Both paths yield a Workfile with identical header fields and identical return block. |
| 3 | **Cost Proportionality** | A standalone architecture run must not inherit the engineering workflow's full ceremony. | Dispatch count bounded; optional steps fire on stated criteria only. |
| 4 | **Backward Compatibility** | Existing `/yggdrasil/engineer` users must see no change. | Engineering outputs, checkpoint, and dispatch count unchanged. |
| 5 | **Clarity of Intent** | Readers must know whether a document is as-is or forward-looking and whether the mode was directed or inferred. | `Mode:` and `Mode source:` in Workfile header and Response. |

## 1.3 Stakeholders

| Role | Expectations of this change |
| --- | --- |
| User (any Odin mode) | One command; clear mode; persisted arc42 directory; review before persistence. |
| Odin (three variants) | One new trigger verdict; unambiguous precedence against the Engineering check. |
| Engineering workflow (as caller) | Same outputs as today from a single delegation; no new dispatches. |
| Kvasir / Heimdall / Brokk / Mimir / Bragi skills | Mode-aware briefs; no cross-agent naming (validate.sh Check 5). |
| Framework maintainer | Templates edited, agents regenerated, validate.sh green, README current. |
