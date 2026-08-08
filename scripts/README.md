# Scripts — Generators and Validation

This directory contains the agent generators, validation tools, and supporting scripts for Yggdrasil.

## Generators

### Odin Agent Generator

**Script:** `generate-odin-agents.sh`

Generates the three Odin agent files (autonomous, guided, interactive) from shared and mode-specific templates.

**Templates:**
- `odin-generator/preamble.template` — Frontmatter and title (with `{{MODE_TITLE}}` and `{{DESCRIPTION}}` substitution)
- `odin-generator/shared-body.template` — Shared orchestration content (Responsibilities, Boundaries, Conventions, Planning, Execution, Review & Quality Gates)
- `odin-generator/communication-policy-{mode}.fragment` — Mode-specific Communication Policy (one per mode: autonomous, guided, interactive)

**Usage:**
```bash
# Regenerate all three Odin agents
./generate-odin-agents.sh

# Regenerate one mode
./generate-odin-agents.sh --mode autonomous

# Print to stdout (for testing)
./generate-odin-agents.sh --print
./generate-odin-agents.sh --mode guided --print
```

**Output:** `agents/odin-autonomous.md`, `agents/odin-guided.md`, `agents/odin-interactive.md`

### Subagent Generator

**Script:** `generate-subagents.sh`

Generates the five subagent files (bragi, brokk, heimdall, kvasir, mimir) from per-agent templates and shared fragments.

**Templates:**
- `subagent-generator/{agent}.template` — Agent-specific definition (one per agent)
- `subagent-generator/knowledge-base.fragment` — Shared Persistent Knowledge Base section (used by all agents)
- `subagent-generator/workspace-convention.fragment` — Shared Yggdrasil Workspace section (used by all agents except Brokk)

**Usage:**
```bash
# Regenerate all five subagents
./generate-subagents.sh

# Regenerate one agent
./generate-subagents.sh --agent mimir

# Print to stdout (for testing)
./generate-subagents.sh --print
./generate-subagents.sh --agent brokk --print
```

**Output:** `agents/bragi.md`, `agents/brokk.md`, `agents/heimdall.md`, `agents/kvasir.md`, `agents/mimir.md`

## Validation and Testing

### Main Validator

**Script:** `validate.sh`

Read-only structural validator that performs eight checks:

1. **Frontmatter parse** — Agent and skill files have well-formed YAML frontmatter with required keys
2. **Required skill sections** — Skills contain the 5 required sections in correct order
3. **Slug/name match** — Skill `name:` field matches its directory slug
4. **Agent freshness** — All 8 agent files match regenerated output (byte-identical)
5. **Subagent isolation** — Subagent prompts and skills don't reference other agents by name
6. **Capability mirror** — Skill descriptions don't leak agent names; repo scaffold is empty
7. **Parity markers** — Odin agent files contain invariant orchestration markers
8. **Command files** — Command definitions have valid frontmatter and templates

**Usage:**
```bash
./validate.sh
```

**Exit code:** 0 if all checks pass, non-zero if any fail.

### Smoke Tests

Supplementary tests that verify generator parity in isolation (useful for CI/pre-commit integration).

**Odin Generator Smoke Test:** `ci-smoke-odin-generator.sh`
- Regenerates all three Odin agents into a temp directory
- Asserts byte-identity with committed versions
- Useful for CI pipelines or pre-commit hooks

**Subagent Generator Smoke Test:** `ci-smoke-subagent-generator.sh`
- Regenerates all five subagents into a temp directory
- Asserts byte-identity with committed versions
- Useful for CI pipelines or pre-commit hooks

**Usage:**
```bash
./ci-smoke-odin-generator.sh
./ci-smoke-subagent-generator.sh
```

Both exit with code 0 on success, non-zero on failure.

## Workflow: Editing Generated Files

**Rule:** All files under `agents/` are generated. Never edit them directly.

### To modify an Odin agent:

1. Identify which template/fragment to edit:
   - Frontmatter/title changes → `odin-generator/preamble.template`
   - Shared content (Responsibilities, Boundaries, Conventions, Planning, Execution, Review) → `odin-generator/shared-body.template`
   - Mode-specific Communication Policy → `odin-generator/communication-policy-{mode}.fragment`

2. Edit the template/fragment

3. Regenerate:
   ```bash
   ./generate-odin-agents.sh
   ```

4. Verify parity:
   ```bash
   ./validate.sh
   ```
   (Check 4 must pass)

5. Commit the template/fragment changes (not the generated `agents/odin-*.md` files)

### To modify a subagent:

1. Identify which template/fragment to edit:
   - Agent-specific content → `subagent-generator/{agent}.template`
   - Shared Persistent Knowledge Base section → `subagent-generator/knowledge-base.fragment` (affects all agents)
    - Shared Yggdrasil Workspace section → `subagent-generator/workspace-convention.fragment` (affects all agents except Brokk)

2. Edit the template/fragment

3. Regenerate:
   ```bash
   ./generate-subagents.sh
   ```

4. Verify parity:
   ```bash
   ./validate.sh
   ```
   (Check 4 must pass)

5. Commit the template/fragment changes (not the generated `agents/{agent}.md` files)

## Generator Implementation Details

Both generators are pure concatenation scripts:

- **Odin:** `preamble.template` (with sed substitution) + newline + `shared-body.template` + newline + `communication-policy-{mode}.fragment`
- **Subagents:** `{agent}.template` + newline + (newline + `workspace-convention.fragment` if agent ≠ brokk) + newline + `knowledge-base.fragment`

No complex logic — just `cat` and `sed`. This makes the generators transparent and the parity checks deterministic.

## Capability Inventory Generator

**Script:** `generate-capabilities.sh`

Generates the dynamic capability-inventory skill (a separate system from the agent generators). Not covered here; see the skill documentation.

---

*For more information on the agent definitions and orchestration patterns, see the main README.md.*
