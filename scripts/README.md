# Scripts — Generators and Validation

This directory contains the agent generators, validation tools, and supporting scripts for Yggdrasil.

## Generators

### Odin Agent Generator

**Script:** `generate-odin-agents.sh`

Generates the three Odin agent files (autonomous, guided, interactive) from shared and mode-specific templates.

**Templates:**
- `odin-generator/preamble.template.md` — Frontmatter and title (with `{{MODE_TITLE}}` and `{{DESCRIPTION}}` substitution)
- `odin-generator/shared-body.template.md` — Shared orchestration content (Responsibilities, Boundaries, Conventions, Planning, Workflows, Execution, Review & Quality Gates)
- `odin-generator/communication-policy-{mode}.fragment.md` — Mode-specific Communication Policy (one per mode: autonomous, guided, interactive)

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

Generates the six subagent files (bragi, brokk, eitri, heimdall, kvasir, mimir) from per-agent templates and shared fragments.

**Templates:**
- `subagent-generator/{agent}.template.md` — Agent-specific head: frontmatter, Role, Responsibilities, Boundaries, Role Discipline (one per agent)
- `subagent-generator/workspace.fragment.md` — Shared Yggdrasil Workspace section (used by all agents)
- `subagent-generator/tooling.fragment.md` — Shared Workfile Tooling section (used only by the agents listed in `WORKFILE_AUTHORS`, i.e. all but Brokk)
- `subagent-generator/memory.fragment.md` — Shared Yggdrasil Memory section (used by all agents)
- `subagent-generator/{agent}.workflow.template.md` — Agent-specific Workflow tail (one per agent)

**Usage:**
```bash
# Regenerate all six subagents
./generate-subagents.sh

# Regenerate one agent
./generate-subagents.sh --agent mimir

# Print to stdout (for testing)
./generate-subagents.sh --print
./generate-subagents.sh --agent brokk --print
```

**Output:** `agents/bragi.md`, `agents/brokk.md`, `agents/eitri.md`, `agents/heimdall.md`, `agents/kvasir.md`, `agents/mimir.md`

## Validation and Testing

### Main Validator

**Script:** `validate.sh`

Read-only structural validator that performs eight checks:

1. **Frontmatter parse** — Agent and skill files have well-formed YAML frontmatter with required keys
2. **Required skill sections** — Skills contain the 5 required sections in correct order
3. **Slug/name match** — Skill `name:` field matches its directory slug
4. **Agent freshness** — All 9 agent files (3 Odin + 6 subagents) match regenerated output (byte-identical)
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
- Regenerates all six subagents into a temp directory
- Asserts byte-identity with committed versions
- Useful for CI pipelines or pre-commit hooks

**Capability Generator Smoke Test:** `ci-smoke-generator.sh`
- Builds a synthetic config base in a temp directory and runs `../config-home/generate-capabilities.sh` against it
- Asserts the inventory's section headers, one populated section per role, and that no agent name leaks into the output
- Also exercises the installed script's self-location path

**Usage:**
```bash
./ci-smoke-odin-generator.sh
./ci-smoke-subagent-generator.sh
./ci-smoke-generator.sh
```

All three exit with code 0 on success, non-zero on failure.

### Local CI Mirror

**Script:** `verify.sh`

Runs the entire CI check suite locally, so a push does not have to be the first time the pipeline is exercised. It mirrors `.github/workflows/ci.yml` — three jobs, eight checks — sequentially in one terminal:

| CI job | Check name | What it runs |
|---|---|---|
| structure | `validate` | `scripts/validate.sh` |
| structure | `smoke-odin` | `scripts/ci-smoke-odin-generator.sh` |
| structure | `smoke-subagent` | `scripts/ci-smoke-subagent-generator.sh` |
| structure | `smoke-capability` | `scripts/ci-smoke-generator.sh` |
| lint | `shellcheck` | `shellcheck --severity=warning --format=gcc` over tracked `*.sh` |
| lint | `markdownlint` | markdownlint-cli over `**/*.md` |
| lint | `yamllint` | yamllint over the repository |
| links | `links` | markdown-link-check per Markdown file, via `.markdown-link-check.json` |

CI's parallel three-job layout is intentional (runtime budget, per-step failure attribution in the GitHub UI) and is not reproduced here; `verify.sh` is a local convenience, not a replacement for the workflow. CI does not call it.

**Usage:**
```bash
./verify.sh                      # run every check
./verify.sh --skip links         # skip the slow, network-bound link check
./verify.sh --only markdownlint  # run a single check
./verify.sh --help               # usage, check list, exit codes
```

`--skip` and `--only` are both repeatable and mutually exclusive.

**Exit code:** 0 if every selected check passed; 1 if any check failed or was skipped because its tool is not installed; 2 on bad usage. A check skipped explicitly with `--skip` does **not** make the run fail.

**Tool versions** are hardcoded in the script and **must be kept in sync with the `env:` block of `.github/workflows/ci.yml`** (the script carries a `# keep in sync with .github/workflows/ci.yml env:` comment at that spot): markdownlint-cli `0.45.0`, markdown-link-check `3.12.2`, yamllint `1.37.1`. `shellcheck` is unpinned, matching CI's use of the version preinstalled on `ubuntu-latest`.

**Missing tools** never abort the run. The check is reported as `SKIPPED (missing tool)` together with the exact install command, and the run still exits non-zero:

```bash
brew install shellcheck
npm i -g markdownlint-cli@0.45.0
npm i -g markdown-link-check@3.12.2
python3 -m pip install yamllint==1.37.1
```

On macOS a pip *user* install puts the `yamllint` console script in `~/Library/Python/X.Y/bin`, which is not on `PATH` by default; the script falls back to `python3 -m yamllint` rather than reporting an installed tool as missing.

**Deliberate deviations from `ci.yml`:**

1. **yamllint output format.** CI runs `yamllint --format github .` to get GitHub Actions annotations; `verify.sh` uses yamllint's default format, because annotation syntax (`::error file=...`) is noise in a terminal. Scope and pass/fail behaviour are identical.
2. **File enumeration.** CI enumerates with `find`, which is safe on a fresh checkout because a checkout contains tracked files only. A local work tree also holds untracked and gitignored paths (such as the transient `.yggdrasil-workspace/` scratch tree), so the `shellcheck` and `links` checks enumerate with `git ls-files` instead. That matches what CI actually sees and sidesteps GNU/BSD `find` differences. Consequence: a brand-new file is invisible to those two checks until it is `git add`ed — which is also exactly when CI would start seeing it.

Markdown path exclusions are **not** part of the script: they live in `.markdownlintignore` at the repository root (`docs/`, `.yggdrasil-workspace/`, `node_modules/`), which markdownlint-cli loads automatically, so CI and `verify.sh` share one source of truth. Link checking deliberately still covers `docs/`.

The script targets macOS bash 3.2 as well as modern bash, avoids GNU-only flags, and requires no `package.json`, Makefile, or container runtime.

## Workflow: Editing Generated Files

**Rule:** All files under `agents/` are generated. Never edit them directly.

### To modify an Odin agent:

1. Identify which template/fragment to edit:
    - Frontmatter/title changes → `odin-generator/preamble.template.md`
    - Shared content (Responsibilities, Boundaries, Conventions, Planning, Workflows, Execution, Review) → `odin-generator/shared-body.template.md`
    - Mode-specific Communication Policy → `odin-generator/communication-policy-{mode}.fragment.md`

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
      - Agent-specific head (frontmatter, Role, Responsibilities, Boundaries, Role Discipline) → `subagent-generator/{agent}.template.md`
      - Agent-specific Workflow tail → `subagent-generator/{agent}.workflow.template.md`
      - Shared Yggdrasil Memory section → `subagent-generator/memory.fragment.md` (affects all agents)
      - Shared Yggdrasil Workspace section → `subagent-generator/workspace.fragment.md` (affects all agents)
      - Shared Workfile Tooling section → `subagent-generator/tooling.fragment.md` (affects the `WORKFILE_AUTHORS` agents only — all but Brokk)

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

### Adding a specialist — roster touch list

The specialist roster is not a manifest. It is spelled out literally in the places listed below, each sitting beside the check or render step that consumes it, and **they must all agree**. A partial edit fails `validate.sh` Check 4 or Check 5 for most of these lists — but *not* for the install-side capability generator, which the repository validator never runs. Work the list top to bottom, in one commit.

| # | File | What to add |
|---|---|---|
| 1 | `scripts/subagent-generator/{agent}.template.md` | New file: frontmatter (`name`, `description`, `mode: subagent`, `temperature`, `permission`) plus Role / Responsibilities / Boundaries / Role Discipline |
| 2 | `scripts/subagent-generator/{agent}.workflow.template.md` | New file: the `## Workflow` tail |
| 3 | `scripts/generate-subagents.sh` | `SUBAGENTS`; `WORKFILE_AUTHORS` (only if the agent writes Workfiles); the `--agent` error text; the header comments and their agent count |
| 4 | `scripts/validate.sh` | Check 4 `SUBAGENT_NAMES` and its pass message count; Check 5 `SUBAGENT_NAMES`, `ALL_AGENT_NAMES`, and the skill-owner `case` arm; Check 6's namelessness loop; the header docstring |
| 5 | `scripts/ci-smoke-subagent-generator.sh` | The regeneration loop and one `check_identical` call |
| 6 | `scripts/odin-generator/preamble.template.md` | One `{agent}: allow` line in the orchestrator's `task:` allowlist |
| 7 | `scripts/odin-generator/shared-body.template.md` | One Agent Selection Guide row; the Workfile-writer sentence; the review-rule clauses (preserving the invariant marker strings Check 7 greps for) |
| 8 | `config-home/generate-capabilities.sh` | The `{agent}) role="{role}"` map arm; the `{role}_skills` accumulator; the description-harvest loop and its `case` arm; a `### {Role}` render section |
| 9 | `config-home/custom-capabilities.yaml` | The `role:` enum in the schema comment |
| 10 | `scripts/ci-smoke-generator.sh` | One role-section assertion and the agent name in the leak-check loop |
| 11 | `README.md` (repo root) | Pantheon table row, mythological-identity section, agent lists, role enum, and every "N agents" count |

Then regenerate (`./generate-subagents.sh`, `./generate-odin-agents.sh`) and run `./validate.sh` plus all three smoke tests.

## Generator Implementation Details

Both generators are pure concatenation scripts:

- **Odin:** `preamble.template.md` (with sed substitution) + newline + `shared-body.template.md` + newline + `communication-policy-{mode}.fragment.md`
- **Subagents:** `{agent}.template.md` + newline + `workspace.fragment.md` + newline + (`tooling.fragment.md` + newline, for `WORKFILE_AUTHORS` agents only) + `memory.fragment.md` + newline + `{agent}.workflow.template.md`

No complex logic — just `cat` and `sed`. This makes the generators transparent and the parity checks deterministic.

## Capability Inventory Generator

**Script:** `../config-home/generate-capabilities.sh` (not in this directory)

Generates the dynamic capability-inventory skill (a separate system from the agent generators). Unlike the scripts here, it is **install-side**: `setup.sh` copies it to `$CONFIG_BASE/yggdrasil/` and it runs against the installed layout, not the repo. It lives in `config-home/` together with the `custom-capabilities.yaml` scaffold — both are payload for the installed config home. See the main README.

---

*For more information on the agent definitions and orchestration patterns, see the main README.md.*
