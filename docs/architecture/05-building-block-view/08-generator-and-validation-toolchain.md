# 5.1.7 Blackbox Generator and Validation Toolchain

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Produces the eight files under `agents/` from template and fragment sources and asserts that the committed files are byte-identical to the output; validates skills and commands structurally (`scripts/README.md:1-160`).

**Provided interface — generator assembly order** (deterministic concatenation, `cat` + `sed`; `scripts/README.md:153-160`):

- Odin: `odin-generator/preamble.template.md` (with `{{MODE_TITLE}}` and `{{DESCRIPTION}}` substituted) + `shared-body.template.md` + `communication-policy-{autonomous|guided|interactive}.fragment.md` → `agents/odin-{mode}.md` (`scripts/README.md:9-31`; `scripts/odin-generator/` listing).
- Subagents: `subagent-generator/{agent}.template.md` + `workspace.fragment.md` + `tooling.fragment.md` (only for Workfile-authoring agents, i.e. not Brokk) + `memory.fragment.md` + `{agent}.workflow.template.md` → `agents/{agent}.md` (`scripts/generate-subagents.sh:70, 103-121, 128-136`; `scripts/subagent-generator/` listing). Note: `scripts/README.md:158` describes only three of these five pieces — see §11.
- CLI: `--mode <m>` / `--agent <a>` to regenerate one; `--print` to emit to stdout (`scripts/README.md:18-29, 44-55`).

**Provided interface — `validate.sh`, eight read-only checks, exit 0 iff all pass** (`scripts/README.md:63-81`): (1) frontmatter parse; (2) five required skill sections in order; (3) skill `name:` equals directory slug; (4) all 8 agent files byte-identical to regenerated output; (5) subagent isolation — no cross-agent names in subagent prompts and skills; (6) capability mirror — skill descriptions do not leak agent names and the repo scaffold is empty; (7) parity markers — Odin files contain invariant orchestration markers; (8) command files have valid frontmatter and templates.

**Provided interface — smoke tests.** `ci-smoke-odin-generator.sh` and `ci-smoke-subagent-generator.sh` regenerate into a temp directory and assert byte-identity; exit 0 on success (`scripts/README.md:83-103`; `scripts/ci-smoke-generator.sh` also present in the listing, not described in `scripts/README.md`).

**Required interfaces.** Bash, `cat`, `sed`; the template sources in `scripts/odin-generator/` and `scripts/subagent-generator/`.

**Invariant.** Maintainers edit templates and fragments, regenerate, run `validate.sh` (Check 4 must pass), and commit the source changes — never the generated files directly (`scripts/README.md:105-151`).
