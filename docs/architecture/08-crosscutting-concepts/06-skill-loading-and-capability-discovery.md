# 8.6 Skill Loading and Capability Discovery

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§8](README.md)._

Each role loads only skills matching its prefix — Odin `capability-inventory` and `odin-*`, Mimir `mimir-*`, Brokk `brokk-*`, and so on — enforced by the `skill` permission allowlist (`agents/odin-autonomous.md:8-11`; `agents/mimir.md:63-65`; `agents/brokk.md:61-63`). Odin loads the generated `capability-inventory` skill once per session before planning; the Agent Selection Guide is routing doctrine, not a capability list (`agents/odin-autonomous.md:48, 66-68`). The inventory is generated install-side by `config-home/generate-capabilities.sh` from skill frontmatter plus `custom-capabilities.yaml`, and is regenerated on every install (`README.md:114, 118, 122`; `scripts/README.md:162-166`). Validator Checks 5 and 6 keep skill descriptions and subagent prompts free of agent names so the inventory can be role-phrased (`scripts/README.md:71-72`).
