# Odin Skills

This directory holds custom skills for the Odin orchestrator — for any purpose, not just capability routing.

To add a custom skill, create a subdirectory here named `odin-<name>/` containing a `SKILL.md` file with frontmatter `name: odin-<name>`. It becomes available immediately — Odin auto-discovers skills in this directory, and its permission allowlist admits any `odin-*` name.

For example, `odin-release-checklist/SKILL.md` (frontmatter `name: odin-release-checklist`) might teach Odin a specific sequence of checks to run through before finalizing any release-related task.
