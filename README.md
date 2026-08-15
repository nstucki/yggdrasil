# Yggdrasil — The Norse Pantheon of AI Agents

> *From the roots of knowledge to the heights of creation, the world-tree connects all realms — and so too does Yggdrasil unite a pantheon of specialized agents, each embodying a god of old.*

---

![Yggdrasil — The World-Tree](./images/yggdrasil.png)

## What Is Yggdrasil?

**Yggdrasil** is a configuration framework for [OpenCode](https://github.com/sst/opencode) that provides a pantheon of six specialized, role-defined AI agents for orchestrated software development. It is not a standalone application — `setup.sh` installs agent definitions, skills, and commands into your OpenCode configuration (`~/.config/opencode/`).

The name is drawn from the immense ash tree of Norse mythology at the center of the cosmos, whose roots and branches connect the nine realms — with the Well of Wisdom, Mímisbrunnr, at its base.

## Why Use It

- **Orchestrated, not single-agent.** A complete task lifecycle — research, strategy, implementation, review — handled by specialists rather than one generalist.
- **Review built in.** Every Brokk (implementer) output is reviewed by Heimdall before it is considered final. No agent reviews its own output.
- **A Final Review Gate** validates the assembled Deliverable against your original request before anything reaches you.
- **Persistent knowledge base.** A source-cited Yggdrasil Memory (`.yggdrasil-memory/`) persists findings across task lifecycles.
- **Extensible.** Grant custom tools and MCPs to any specialist; add `odin-*` skills. Curated starter skills ship by default and are meant to be adapted.

## The Pantheon

| Agent | Myth-identity | Role | Domain |
| ----- | ------------- | ---- | ------ |
| **Odin** | The All-Father | Orchestrator | Receives the objective, devises the workflow, delegates. Never implements, researches, or reviews directly. |
| **Mimir** | Well-Keeper of Mímisbrunnr | Researcher | Explores codebases, reads docs, gathers context. Illuminates; does not decide or implement. |
| **Bragi** | The Skald | Communicator | Advises on communication strategy, drafts and presents information, provides the multi-persona Deliberation Council for high-stakes decisions. |
| **Kvasir** | The Wise Counselor | Strategic Advisor | Synthesizes context into plans; decomposition, risk, approach. Consulted proactively by Odin. |
| **Brokk** | The Smith | Implementer | Transforms requirements into concrete Artifacts: code, docs, tests, config. Has write access. |
| **Heimdall** | The Watchman | Reviewer | Independently validates quality, correctness, completeness. Never implements fixes. |

Odin operates in three modes, adapting his autonomy to the task:

| Mode | Role |
| ------ | ------ |
| **Autonomous** | Self-directed execution with no user interaction. Odin makes reasonable assumptions and drives the full workflow independently. |
| **Guided** | Gathers initial requirements directly, then proceeds autonomously once the objective is clear. May task Bragi for advice on structuring the conversation. |
| **Interactive** | Collaborates with the user directly, involving them when decisions or clarifications are needed. Tasks Bragi for advice on framing and presentation. |

### The Pantheon — in myth

#### Odin — The All-Father

> *Odin sacrificed his eye at Mimir's well for a drink of wisdom. He hung nine nights on Yggdrasil, pierced by his own spear, to unlock the secrets of the runes. He leads the Einherjar and surveys all from Hliðskjálf, his high seat.*

#### Mimir — The Well-Keeper

> *Mimir is the guardian of Mímisbrunnr, the Well of Wisdom at the roots of Yggdrasil. He drinks from the well each day and possesses knowledge of all things — past, present, and future. Odin himself gave an eye for a single draught from that well.*

#### Bragi — The Skald

> *Bragi is the god of poetry and eloquence. He is renowned for his wisdom, his command of the spoken word, and his ability to weave meaning from speech. As the skalds of old shaped tales from raw events, Bragi shapes understanding from raw intent.*

#### Kvasir — The Wise Counselor

> *Kvasir was the wisest of all beings, created by the gods as a token of peace after the Æsir–Vanir war. He wandered the world, advising and teaching, sharing his wisdom freely with all who sought it. His blood was used to brew the Mead of Poetry — a drink that grants eloquence and wisdom to those who taste it.*

#### Brokk — The Smith

> *Brokk is a master dwarf smith of unmatched skill. With his brother Eitri, he forged Mjölnir (Thor's hammer), Draupnir (Odin's golden ring), and Gullinbursti (Freyr's golden boar) — treasures that shaped the fate of gods and giants alike.*

#### Heimdall — The Watchman

> *Heimdall is the ever-vigilant guardian of Bifröst, the rainbow bridge to Asgard. He sees and hears everything — his senses are so keen he can hear grass grow and see to the ends of the world. He stands watch, sounding Gjallarhorn when danger approaches.*

## How It Works

The lifecycle flows through the pantheon: **Odin** receives the objective and determines the path; **Bragi** advises on communication, **Kvasir** on strategy and decomposition; **Mimir** researches and gathers context; **Brokk** implements; **Heimdall** reviews; and **Odin** evaluates the outcome and decides next steps.

Odin selects among several established orchestration patterns depending on the task — from a simple *Research → Report* to the standard *Research → Implement → Review* to fuller flows that bring Kvasir's counsel to bear on complex, high-stakes work. Every plan ends at a Final Review Gate, where Heimdall validates the assembled Deliverable against your original request before it reaches you.

Patterns can be combined, repeated, or reordered as the task demands — for example, multiple research → implement → review rounds within a single task.

## Quick Start

1. **Install** — from the repo root:

   ```bash
   ./setup.sh
   ```

   (Use `./setup.sh -y` for non-interactive installs. See [Installation](#installation) for custom paths and upgrades.)

2. **Open a project** — in your terminal, `cd` into any project you want Yggdrasil to work on. OpenCode uses the current directory as its session workspace. Restart OpenCode (or start a new session) and the six agents appear in your agent selector.

3. **Switch to Odin and make a request.** For example, switch to the **Odin (Interactive)** agent and say:

   > *"Refactor the authentication middleware in this project. Start by researching the current structure, then propose an approach before implementing."*

   This exercises the full lifecycle: research → advise → implement → review. Odin also runs in Guided or Autonomous mode — see [The Pantheon](#the-pantheon).

## Installation

### Prerequisites

- [OpenCode](https://github.com/sst/opencode) installed and configured (requires `~/.config/opencode/`).

### Install

```bash
./setup.sh
```

You'll be prompted for two choices: whether to copy the curated optional skills (default: yes), and whether to merge into existing target directories (default: skip; the script merges safely — same-named Yggdrasil files overwritten, new files added, unrelated files preserved, nothing deleted). Pass `-y` to skip both prompts for CI or `curl ... | bash` installs.

**What gets installed:**

*Copied from the repo:*

- **Agents** → `~/.config/opencode/agents/yggdrasil/`
- **Commands** → `~/.config/opencode/commands/yggdrasil/`
- **Capability generator** → `~/.config/opencode/yggdrasil/generate-capabilities.sh`

*Created once, preserved on upgrades:*

- **Custom-capabilities scaffold** → `~/.config/opencode/yggdrasil/custom-capabilities.yaml` (first install only; never overwritten on upgrades)

*Generated at install time (not repo-committed):*

- **Capability inventory** → `~/.config/opencode/skills/yggdrasil/shared/capability-inventory/SKILL.md` (regenerated automatically on every install)

**Skills installed:**

Required (always installed, regardless of the prompt — Odin's workflow and Yggdrasil Memory mechanisms depend on them):

- **Memory skills** (`odin-memory-system`, `brokk-memory-curation`) → `~/.config/opencode/skills/yggdrasil/memories/`
- **Deliberation skills** (`odin-deliberation-council` and the five `bragi-council-deliberation-*` perspective skills) → `~/.config/opencode/skills/yggdrasil/deliberation/`
- **Research skills** (`odin-research-workflow`, `kvasir-research-decomposition`, `mimir-research-convention`, `heimdall-research-review`) → `~/.config/opencode/skills/yggdrasil/research/`

Optional (the curated starter skills, installed only if accepted at the prompt):

- **Optional skills** → `~/.config/opencode/skills/yggdrasil/<agent>/` subdirectories (see [Optional Skills](#optional-skills) below)

### Advanced installation

#### Custom Installation Path

By default, everything installs to `~/.config/opencode/`. To use a different location, set `OPENCODE_CONFIG_BASE` as an environment variable or use the `-c`/`--config-base` CLI flag:

```bash
# Environment variable
OPENCODE_CONFIG_BASE=/custom/path ./setup.sh -y

# CLI flag (takes precedence)
./setup.sh -c /custom/path -y
```

The path supports `~` expansion (e.g., `~/my-opencode-config`).

#### Optional Skills

Yggdrasil ships with a curated set of optional skills. **These are starting points, not prescriptions** — each is a Markdown file installed into the respective agent subdirectory under the installed `skills/yggdrasil/` tree. Review, modify, and extend them to match your team's workflows. Remove what you don't need, adjust what you do, and add your own. (Installed only if you accept the "Copy optional skills?" prompt at install time.)

**Directory structure:**

```
~/.config/opencode/skills/yggdrasil/
├── research/                          # Mandatory skills
│   ├── odin-research-workflow/
│   ├── kvasir-research-decomposition/
│   ├── mimir-research-convention/
│   └── heimdall-research-review/
├── memories/                          # Mandatory skills
│   ├── odin-memory-system/
│   └── brokk-memory-curation/
├── deliberation/                      # Mandatory skills
│   ├── odin-deliberation-council/
│   ├── bragi-council-deliberation-foundations/
│   ├── bragi-council-deliberation-systems/
│   ├── bragi-council-deliberation-adversary/
│   ├── bragi-council-deliberation-pragmatist/
│   ├── bragi-council-deliberation-humanist/
│   └── bragi-council-deliberation-herald/
├── bragi/                             # Optional skills (if accepted at install)
│   ├── bragi-presentation-structuring/
│   ├── bragi-question-formulation/
│   └── bragi-tradeoff-communication/
├── brokk/                             # Optional skills (if accepted at install)
│   ├── brokk-documentation-writing/
│   ├── brokk-git-usage/
│   ├── brokk-software-engineering/
│   └── brokk-system-prompts/
├── heimdall/                          # Optional skills (if accepted at install)
│   ├── heimdall-design-review/
│   ├── heimdall-documentation-review/
│   ├── heimdall-implementation-review/
│   └── heimdall-system-prompt-review/
├── kvasir/                            # Optional skills (if accepted at install)
│   ├── kvasir-approach-evaluation/
│   ├── kvasir-risk-assessment/
│   └── kvasir-task-decomposition/
└── mimir/                             # Optional skills (if accepted at install)
    ├── mimir-codebase-analysis/
    ├── mimir-diagnostic-analysis/
    └── mimir-security-analysis/
```

**Available optional skills by agent:**

- **Bragi:** Presentation structuring, Question formulation, Trade-off communication
- **Brokk:** Documentation writing, Git usage, Software engineering, System prompts
- **Heimdall:** Design review, Documentation review, Implementation review, System prompt review
- **Kvasir:** Approach evaluation, Risk assessment, Task decomposition
- **Mimir:** Codebase analysis, Diagnostic analysis, Security analysis

## Commands

Commands are **macros for user requests to Odin** — equivalent to stating the same request in natural language. Natural-language invocation remains fully valid; commands are shortcuts, not the only door. This ensures commands always flow through the full orchestration pipeline with proper review gates — never bypassing specialist review.

Yggdrasil provides five globally-installed slash-commands, available in every project once installed:

- **`/yggdrasil/deliberate <question>`** — Run the Deliberation Council: multiple perspective lenses analyze the question in parallel, synthesize the competing arguments, and deliver a reasoned conclusion. Multi-specialist workflow; expect to wait.
- **`/yggdrasil/research <topic>`** — Conduct deep research: decompose the topic into independent research areas, investigate each in parallel with review and synthesis, and deliver a comprehensive report. Adaptive multi-specialist workflow; expect to wait.
- **`/yggdrasil/remember [topic]`** — Promote reviewed findings to the project knowledge base. Runs the reviewed promotion pipeline (orchestrated, not an instant write). The only way promotion is initiated; never automatic at task wrap-up.
- **`/yggdrasil/dream [scope]`** — Consolidate and audit the knowledge base for duplicates, contradictions, and staleness. Orchestrated maintenance; may prune by judgment but never silently performs a forget.
- **`/yggdrasil/forget <scope>`** — Delete entries from the knowledge base. Destructive and always confirmed before dispatch; invocation is intent, not confirmation. Working-tree only; full wipe requires a second confirmation.

Each command routes through the full orchestration pipeline — reviewed at every stage, never an instant or unreviewed write.

## Memory System

Yggdrasil maintains a **persistent knowledge base** at `.yggdrasil-memory/`, rooted at the session working directory — recommended to be git-tracked — distinct from the transient, gitignored Yggdrasil Workspace (`.yggdrasil-workspace/`).

**Why they're separate:**

- **`.yggdrasil-workspace/`** — Transient Workfiles (research notes, drafts, intermediate outputs, review verdicts). Gitignored. Deleted between sessions. Task-scoped and ephemeral.
- **`.yggdrasil-memory/`** — Persistent knowledge base (verified findings, decisions, hard-won insights). Git-tracked. Survives between sessions and projects. Curated and long-lived.

This separation ensures that valuable, verified findings persist and accumulate across projects, while task-specific work doesn't clutter the knowledge base or version control.

**What it contains:** verified facts with file/line citations, decisions and rationale, and hard-won findings (root causes, dependency quirks, performance characteristics). Not task narratives, review verdicts, transient state, or anything reproducible in seconds by reading one file.

Yggdrasil Memory is maintained through the three [commands](#commands) above, each routed through the full reviewed orchestration pipeline — never an instant, unreviewed write. If a project has no `.yggdrasil-memory/` directory, the commands offer to establish it (scaffolded from canonical templates in the `brokk-memory-curation` skill). By default the knowledge base is git-tracked, so git history provides an audit trail and a recovery net for destructive operations.

**Typical Yggdrasil Memory workflow:**

1. **Run a research task** — e.g., `/yggdrasil/research "How does the authentication system work?"` — and Heimdall reviews the findings.
2. **Promote valuable findings** — if the findings are broadly useful (not task-specific), run `/yggdrasil/remember "authentication system"` to promote them to the knowledge base. The findings are reviewed again before promotion.
3. **Consolidate periodically** — run `/yggdrasil/dream` to audit the knowledge base for duplicates, contradictions, and staleness. This is maintenance, not deletion — the dream workflow identifies issues and suggests consolidation, but never silently removes entries.
4. **Remove outdated entries** — run `/yggdrasil/forget "old-finding-topic"` to delete entries that are no longer accurate or relevant. This is destructive and always confirmed before dispatch.

The full Yggdrasil Memory convention — promotion pipeline, dream consolidation, forget deletion, and the Recall mechanism — is governed by the same orchestration rules that shape every task: every write is reviewed, every deletion is confirmed, and nothing enters Yggdrasil Memory without a vetted pipeline. The orchestration doctrine for the three command-triggered operations lives in the **[`skills/memories/odin-memory-system/SKILL.md`](./skills/memories/odin-memory-system/SKILL.md)** skill; the canonical entry-schema template lives in **[`skills/memories/brokk-memory-curation/SKILL.md`](./skills/memories/brokk-memory-curation/SKILL.md)**.

## Extending Yggdrasil with Tools & Skills

> ⚠️ **After installation, do not edit files in this repository.** All customization (new skills, tool grants, capability registry) happens in the installed location (`~/.config/opencode/skills/yggdrasil/`, `~/.config/opencode/agents/yggdrasil/`, etc.). The repo is only used for framework upgrades. Changes made to the repo after install will be lost on the next upgrade.

The repo is only needed for the initial install and framework upgrades. Once installed, all extension happens in the installed location, via two paths that end in the same regeneration step: **add a new skill** to a specialist (a Markdown file), or **grant a new tool** to a specialist (a permission + registry entry). Both feed the same generator and surface in the same capability inventory.

### Add a New Skill to a Specialist

Specialist skills (Mimir, Brokk, Heimdall, Kvasir, Bragi) are plain Markdown files discovered from the installed skills tree — no agent definition edits are needed; each specialist's permission allowlist already admits any skill matching its own prefix (e.g., `brokk-*`). Unlike Odin's skills, they are **not** picked up by planning automatically: after adding one, you must regenerate the capability inventory, or Odin and Kvasir will not know it exists.

1. **Create the skill file** in the installed skills tree:

   ```bash
   $CONFIG_BASE/skills/yggdrasil/<agent>/<agent>-<name>/SKILL.md
   ```

    Mandatory skills live in the feature directories `research/`, `memories/`, and `deliberation/`; optional skills install flat at `<agent>/<agent>-<name>/`.

   where `<agent>` is one of `mimir`, `brokk`, `heimdall`, `kvasir`, `bragi`. The frontmatter requires `name` (must exactly match the directory name) and a one-line `description` phrased by role — never naming any agent:

   ```yaml
   ---
   name: <agent>-<name>
   description: <one-line, agent-neutral description>
   ---
   ```

   The body follows the same five sections as every shipped skill, in this order: `## Purpose`, `## When to Use`, `## Workflow`, `## Quality Criteria`, `## Anti-Patterns`.

2. **Regenerate the capability mirror**:

   ```bash
   $CONFIG_BASE/yggdrasil/generate-capabilities.sh
   ```

   This harvests the new skill's frontmatter into `$CONFIG_BASE/skills/yggdrasil/shared/capability-inventory/SKILL.md`, making it visible to Odin and Kvasir. **This step is required and nothing checks it for you** — a skill added without regeneration is invisible to planning. (`setup.sh` reruns the generator on every install and upgrade, so fresh installs are always current.)

For example, `$CONFIG_BASE/skills/yggdrasil/brokk/brokk-shell-scripting/SKILL.md` (frontmatter `name: brokk-shell-scripting`) appears in the inventory under **implementer** as `shell-scripting` after regeneration.

### Grant a New Tool to a Specialist

1. **Grant the tool** in the installed agent definition file:

   ```bash
   $CONFIG_BASE/agents/yggdrasil/<agent-name>.md
   ```

   Add the tool to the agent's `permission:` block (e.g., a new MCP or locally-available executable).

2. **Register the capability** in the installed custom-capabilities file:

   ```bash
   $CONFIG_BASE/yggdrasil/custom-capabilities.yaml
   ```

   ```yaml
   custom_capabilities:
     - name: <capability-slug>
       role: <researcher|implementer|reviewer|strategist|communicator>
       summary: <one-line, role-phrased description>
   ```

3. **Regenerate the capability mirror**:

   ```bash
   $CONFIG_BASE/yggdrasil/generate-capabilities.sh
   ```

   This updates `$CONFIG_BASE/skills/yggdrasil/shared/capability-inventory/SKILL.md`, making the new capability visible to both Odin and Kvasir immediately.

### Built-In Capability Inventory

Both Odin and Kvasir maintain awareness of all available capabilities — built-in skills plus custom-granted tools — by independently loading the same **`capability-inventory` skill** at the start of task execution/planning. No relay, copying, or curation needed — both agents load the same source directly via name-based discovery.

The inventory is assembled from two sources: **built-in skills** (harvested automatically from agent and skill frontmatter) and **custom capabilities** (read from `custom-capabilities.yaml`). The generator is created at install time and can be re-run after adding custom tools. Custom tool grants are managed post-install in `$CONFIG_BASE/yggdrasil/custom-capabilities.yaml` and `$CONFIG_BASE/agents/yggdrasil/`, never in the repo.

**When to regenerate the capability inventory:**

After you add a new skill or grant a new tool to a specialist, you must regenerate the inventory so Odin and Kvasir know about it:

```bash
$CONFIG_BASE/yggdrasil/generate-capabilities.sh
```

This is a one-line command that harvests all skill frontmatter and custom capabilities into a single `capability-inventory/SKILL.md` file. Without regeneration, your new skill or tool will be invisible to planning and task execution. (`setup.sh` automatically regenerates the inventory on every install and upgrade, so fresh installs are always current.)

### Deliberation Council

Odin provides an optional **Deliberation Council** workflow for high-stakes questions requiring diverse perspectives. It generates multiple viewpoints on a question, synthesizes them into a reasoned conclusion, and delivers the result as a final answer. Use this when you need to explore competing viewpoints, values, or approaches before deciding.

**How it works:**

1. **Optional research phase** — if the question requires factual grounding, Odin conducts targeted research to provide context for the deliberation.
2. **Parallel perspective analysis** — multiple specialists analyze the question from different angles (first-principles, systems-thinking, adversarial, pragmatic, humanistic) in parallel, each arguing their case fully.
3. **Synthesis** — the perspectives are synthesized into a reasoned conclusion that weighs competing arguments.
4. **Final answer** — the synthesis is drafted as a user-facing answer, disclosing its grounding and preserving minority views.
5. **Review** — the final answer is independently reviewed before delivery.

**When to use:** Explicitly request multiple perspectives, use the `/yggdrasil/deliberate` command, or ask for opinions/angles on a question. Factual or executable requests skip this workflow.

**What to expect:** This is a multi-specialist workflow that takes longer than a simple answer. You'll receive a reasoned conclusion that acknowledges competing viewpoints and explains its grounding.

### Research

Odin also provides a **Research workflow** for deep investigation of complex topics. It decomposes the question into independent research areas, investigates each in parallel with citations and review, synthesizes the findings, and delivers a comprehensive report. Use this when you need thorough, multi-faceted research rather than a quick answer.

**How it works:**

1. **Decomposition** — the topic is analyzed and broken into independent research areas.
2. **Plan checkpoint** — you see the research plan and can redirect before investigation begins (this is your steering point).
3. **Parallel investigation** — each research area is investigated independently, with findings grounded in live sources and backed by specific citations.
4. **Review and synthesis** — each investigation is reviewed, then synthesized into a comprehensive answer that names its own boundaries (what was covered, what was not, what remains uncertain).
5. **Final answer** — the synthesis is drafted as a user-facing report and independently reviewed before delivery.

**When to use:** Explicitly request research, investigation, or deep analysis, or use the `/yggdrasil/research` command. Factual or executable requests skip this workflow.

**What to expect:** This is a multi-specialist workflow that takes longer than a simple answer. The plan checkpoint gives you a chance to steer the investigation. You'll receive a comprehensive report with citations and clear boundaries on what was and wasn't covered.

## Development

### Validation

```bash
scripts/validate.sh    # or: bash scripts/validate.sh
```

The validator is read-only and reports PASS/FAIL per check. It verifies that agent frontmatter parses, that skill frontmatter and required sections are present, that the shared orchestration content in the Odin agent files stays byte-identical to regenerated output, and that subagent prompts and skills never reference other agents by name (subagent isolation).

To test a change to an agent or skill: edit the source file, run `scripts/validate.sh`, and (for Odin files) regenerate via `scripts/generate-odin-agents.sh` before committing.

### Generated Files — Critical Rule

**All files under `agents/` are generated output.** Never edit them directly. Instead:

1. **For Odin agents** (odin-autonomous.md, odin-guided.md, odin-interactive.md):
    - Edit the source templates in `scripts/odin-generator/`:
      - `preamble.template.md` — frontmatter and title (contains `{{MODE_TITLE}}` and `{{DESCRIPTION}}` substitution tokens)
      - `shared-body.template.md` — shared orchestration content (Responsibilities, Boundaries, Conventions, Planning, Execution, Review & Quality Gates)
      - `communication-policy-{mode}.fragment.md` — mode-specific Communication Policy (one file per mode: autonomous, guided, interactive)
    - Regenerate: `scripts/generate-odin-agents.sh`
    - Verify parity: `scripts/validate.sh` (Check 4) or `scripts/ci-smoke-odin-generator.sh`

2. **For subagent files** (bragi.md, brokk.md, heimdall.md, kvasir.md, mimir.md):
     - Edit the source templates in `scripts/subagent-generator/`:
       - `{agent}.template.md` — agent-specific definition (frontmatter, Role, Responsibilities, Boundaries, Role Discipline, Workflow, etc.)
       - `memory.fragment.md` — shared Yggdrasil Memory section (used by all agents)
        - `workspace.fragment.md` — shared Yggdrasil Workspace section (used by all agents except Brokk)
    - Regenerate: `scripts/generate-subagents.sh`
    - Verify parity: `scripts/validate.sh` (Check 4) or `scripts/ci-smoke-subagent-generator.sh`

**Why?** The generators ensure consistency across variants and prevent accidental divergence. Editing generated files directly causes them to fall out of sync with their templates — a future regeneration (by CI, a contributor, or a task) will silently overwrite your changes. The validation gate (`scripts/validate.sh` Check 4) catches this at commit time.

---

*Yggdrasil — Ever green, ever growing. The tree that connects all things.*
