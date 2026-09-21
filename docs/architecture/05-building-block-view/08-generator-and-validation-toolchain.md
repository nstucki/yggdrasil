# 5.1.7 Blackbox Generator and Validation Toolchain

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§5](README.md)._

**Purpose and responsibility.** Produces the **nine** files under `agents/` from template and fragment sources and asserts that the committed files are byte-identical to the output; validates skills and commands structurally (`scripts/README.md:1-160`; `scripts/generate-subagents.sh:1-175`).

**Provided interface — generator assembly order** (deterministic concatenation, `cat` + `sed`; `scripts/README.md:153-160`):

- Odin: `odin-generator/preamble.template.md` (with `{{MODE_TITLE}}` and `{{DESCRIPTION}}` substituted) + `shared-body.template.md` + `communication-policy-{autonomous|guided|interactive}.fragment.md` → `agents/odin-{mode}.md` (`scripts/README.md:9-31`).
- Subagents: `subagent-generator/{agent}.template.md` + `workspace.fragment.md` + `tooling.fragment.md` (only for agents in `WORKFILE_AUTHORS`, i.e. not Brokk) + `memory.fragment.md` + `{agent}.workflow.template.md` → `agents/{agent}.md` (`scripts/generate-subagents.sh:68-74, 103-121, 128-136`). **Roster contract (revised):** `SUBAGENTS="bragi brokk eitri heimdall kvasir mimir"` and `WORKFILE_AUTHORS="bragi eitri heimdall kvasir mimir"` (`:68, :74`); the `--agent` error text lists the six names (`:35`); header comments say six (`:3-11, 151`).
- CLI: `--mode <m>` / `--agent <a>` to regenerate one; `--print` to emit to stdout (`scripts/README.md:18-29, 44-55`).

**Provided interface — `validate.sh`, ten read-only checks, exit 0 iff all pass** (`scripts/validate.sh:1-60`): (1) frontmatter parse — `name` and `description` required, additional keys such as `model` permitted (`:8-10`); (2) five required skill sections in order; (3) skill `name:` equals directory slug; (4) all **9** agent files byte-identical to regenerated output — `SUBAGENT_NAMES='bragi brokk eitri heimdall kvasir mimir'` and the pass message counts 6 subagents (`:351, :427`, revised); (5) subagent isolation — `SUBAGENT_NAMES` and `ALL_AGENT_NAMES` include `eitri`, and the owner `case` admits `eitri` (`:450-451, :486`, revised); (6) skill-description namelessness scans for `eitri` too (`:520`, revised) and the repo scaffold stays empty; (7) Odin invariant markers — list unchanged (`:598-625`); (8) command files; (9) mandatory-skill isolation from optional skills — unaffected, no `skills/eitri/` ships; (10) no license texts under `skills/`.

**Provided interface — smoke tests.** `ci-smoke-odin-generator.sh` and `ci-smoke-subagent-generator.sh` regenerate into a temp directory and assert byte-identity; the subagent test loops over six names and asserts `eitri.md` (`scripts/ci-smoke-subagent-generator.sh:40, 68-72`, revised). `ci-smoke-generator.sh` asserts the inventory carries a `### Designer` section and leaks none of the seven agent names (`scripts/ci-smoke-generator.sh:105-109, 121`, revised). All three run in CI (`.github/workflows/ci.yml:47-54`).

**Required interfaces.** Bash 3.2+, `cat`, `sed`, `diff`, `grep`; the template sources in `scripts/odin-generator/` and `scripts/subagent-generator/`.

**Invariant.** Maintainers edit templates and fragments, regenerate, run `validate.sh` (Check 4 must pass), and commit the source changes — never the generated files directly (`scripts/README.md:105-151`). Adding a specialist touches every roster list ADR-0011 enumerates in one commit; a partial edit fails Check 4 (missing template or missing generated file) or Check 5 (unscanned prompt).

**Fulfilled acceptance criteria.** AC-5, AC-6.
