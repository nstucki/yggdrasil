# 8.1 Mode line propagation

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§8](README.md)._

`Mode:` is set once in the shape verdict and echoed verbatim in every brief (Kvasir, Heimdall), the Workfile header (`- **Mode:** … (source: …)`), the return block, and the Response. A reviewer BLOCKs on a missing or mismatched header. This is the Clarity-of-Intent mechanism (AC-13, AC-14).
