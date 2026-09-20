# 8.3 Workfile Exchange Convention

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§8](README.md)._

Specialists exchange transient Workfiles under `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/` with sequenced, self-describing names and relative paths; Mimir, Kvasir, Heimdall, and Bragi write them, Brokk reads them, Odin acts on summaries only; content becomes a Deliverable solely by promotion (`agents/odin-autonomous.md:74-82`). Workfiles are created and grown incrementally with the `edit` tool because `write` is documented to hang (`agents/bragi.md:59-63`). The convention is embodied in a shared `workspace.fragment.md` concatenated into every subagent and a `tooling.fragment.md` concatenated into the Workfile-authoring ones (`scripts/generate-subagents.sh:70, 103-121`).
