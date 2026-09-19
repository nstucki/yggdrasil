# 8.2 Caller contract and return block

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§8](README.md)._

Composition between Odin workflows is by **skill load within one Odin session**: the caller states I-1, executes the loaded workflow's steps, and consumes I-3. Skipped steps are recorded in the callee's shape verdict with reasons, never silently. Only these two lines are the coupling surface — engineering doctrine may reference them but never restate the callee's steps (Doctrine Minimization). R4: I-1 carries objective, requirements, persistence timing, and location — **no context Workfile**; the callee's own gate is the only source of its structural evidence (ADR-0014).
