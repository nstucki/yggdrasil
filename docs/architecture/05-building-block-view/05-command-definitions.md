# 5.1.4 Blackbox Command Definitions

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Seven slash commands — `research`, `architect`, `engineer`, `deliberate`, `remember`, `dream`, `forget` — each a Markdown file that routes the user's arguments to a named Odin mode and directs it to load one workflow skill (`commands/yggdrasil/*.md`, directory listing; `commands/yggdrasil/research.md:1-13`).

**Provided interface — the command definition contract** (quoted for `/yggdrasil/research`, `commands/yggdrasil/research.md:1-13`): frontmatter `description: "arg: topic, required"`, `agent: Odin (Interactive)`, `subtask: false`; body with a one-line description of the workflow and its cost ("expect to wait"), `Topic: $ARGUMENTS`, and the directive "Load the `odin-research-workflow` skill and execute the Research workflow defined there on the topic above."

**Required interfaces.** OpenCode command dispatch and the named Odin mode; in Odin, a command sets the triggering verdict's `command=yes` → `invoke` (`agents/odin-autonomous.md:187, 197, 207, 217`). Validator Check 8 asserts well-formed frontmatter and templates (`scripts/README.md:74`).

**Invariant.** In Autonomous mode no command is routed, so `command=` is always `no` there (`agents/odin-autonomous.md:296`).
