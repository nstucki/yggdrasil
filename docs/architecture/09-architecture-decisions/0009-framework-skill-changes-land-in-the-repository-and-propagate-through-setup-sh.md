# ADR-0009: Framework skill changes land in the repository and propagate through setup.sh

- **Status:** Accepted
- **Date:** 2026-09-23

## Context

The six Architecture-workflow skills exist twice: as git-tracked sources under `skills/architecture/` in this repository, and as installed copies under `<config-base>/skills/yggdrasil/architecture/`. The two trees are byte-identical today (`git diff --no-index --stat` between them prints nothing), and `setup.sh:354-358` produces the installed tree by `cp -R` from the repository on every install and upgrade, overwriting same-named files (`README.md:150-152`). `README.md:265` tells readers not to edit the repository after installation because repository changes "will be lost on the next upgrade" — advice that is correct for an install-site operator adding skills or tool grants (§1.2 system goal 5, §1.3), but that inverts for a framework maintainer changing shipped skill behavior: an edit made only in the installed copy is what `setup.sh` overwrites. The skills are loaded at runtime from the installed tree, so a change is not observable in a session until it has been propagated. The decision fixes which tree the work packages of Appendix B edit and how a change reaches the runtime. Subsystem goals affected: Durability (a change that survives upgrades), Consistency (one behavior in both trees), Maintainability (one place to edit).

## Options Considered

| Option | Pros | Cons | Durability | Clarity | Maintainability | Consistency | Usability |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A — Edit the repository; propagate with `./setup.sh -y`; verify byte-identity | Change is git-tracked and survives upgrades; one edit site; matches the maintainer workflow already used for `agents/` (`scripts/README.md:105-151`) | A change is not live until `setup.sh` runs; contradicts the literal README warning | high — survives upgrade | high — one source | high — one edit | high — identity check | medium — extra propagation step |
| B — Edit the installed copy first, back-port to the repository when satisfied | Change is live in the next session with no propagation step; natural for live-testing prose | Two edits per change; drift window in which the repository is stale; a forgotten back-port is silently overwritten at the next upgrade | low — lost at upgrade if not back-ported | low — two sources disagree during the window | low — double edit | low — no check that both agree | high — immediate |
| C — Replace the installed `architecture/` tree with a symlink to the repository (development-mode install) | Live and git-tracked at once; zero propagation | Diverges from what `setup.sh` produces for every other install; a stray edit in the "installed" tree is a repository edit; `setup.sh` would remove or overwrite the link on the next run; untested against OpenCode's skill loader | medium — until the next `setup.sh` | medium — one file, two names | medium — no propagation, but a bespoke install | low — this machine differs from every other | high — immediate |

## Decision

We edit the six skills in the repository's `skills/architecture/<skill>/SKILL.md` and propagate with `./setup.sh -y`; a change is complete only when `git diff --no-index --stat skills/architecture <config-base>/skills/yggdrasil/architecture` prints nothing and `scripts/validate.sh` exits 0 (§5.2 I-6; QS-15). The README warning at `README.md:265` is read as addressed to the install-site operator; the maintainer/operator ambiguity in its wording is recorded as R10 and left to a documentation change outside this delta. Rationale: only option A keeps the change under version control and identical in both trees, which Durability (goal 1) and Consistency (goal 4) require; option B's drift window is exactly the failure R10 describes; option C would make this machine's install unlike every other.

## Consequences

- **Positive:** every behavior change is a reviewable commit; the installed tree is provably the shipped tree; the work packages have one write set.
- **Negative:** a maintainer cannot test a prose change in a live session without running `setup.sh` (a few seconds, but a step to forget).
- **Becomes harder:** quick live experiments on skill wording — the disciplined path is edit → `setup.sh` → session, not edit-in-place.

## Related

DOC-9 · §5.1.3, §5.1.8, §5.2 I-6 · R10 · all work packages (write sets) and the integrate step of Appendix B.
