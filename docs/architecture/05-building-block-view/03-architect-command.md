# 5.1.2 Blackbox `commands/yggdrasil/architect.md`

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§5](README.md)._

- **Purpose:** route `/yggdrasil/architect <request>` to Odin and load the workflow skill.
- **Provided interface:** frontmatter `description: "arg: request, required — mode inferred or stated (document | decide)"`, `agent: Odin (Interactive)`, `subtask: false`; body: one-paragraph description (both modes, review gate, persistence, "expect to wait"), `Request: $ARGUMENTS`, directive "Load the `odin-architecture-workflow` skill and execute the Architecture workflow defined there on the request above." Mirrors `commands/yggdrasil/engineer.md` lines 1–13.
- **Location:** `commands/yggdrasil/architect.md` (new). Installed by `setup.sh` to `~/.config/opencode/commands/yggdrasil/`.
- **Fulfilled AC:** AC-1. **Open issues:** none (routing mechanism itself is an unverified item in the context research; pattern copied verbatim).
