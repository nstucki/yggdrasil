# 8.8 Generation and Structural Validation

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§8](README.md)._

All eight agent definitions are derived: Odin modes from a preamble, a shared body, and a policy fragment; subagents from a template head, shared workspace/tooling/memory fragments, and a workflow tail (`scripts/README.md:5-57`; `scripts/generate-subagents.sh:103-121`). `validate.sh` runs eight read-only checks — frontmatter, skill sections and slugs, byte-identity of all agents, subagent isolation, capability mirror, Odin parity markers, command files — and two smoke tests assert generator parity for CI (`scripts/README.md:59-103`). The maintainer workflow is edit source → regenerate → validate → commit source (`scripts/README.md:105-151`).
