# 8.6 Feature-directory placement

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§8](README.md)._

Each workflow family owns one mandatory feature directory holding its Odin doctrine skill and the specialists that serve it; `skills/architecture/` joins `research/`, `deliberation/`, `engineering/`. Membership is registered in exactly two places (`setup.sh`, `validate.sh` `MANDATORY_SKILL_DIRS`); every cross-directory reference is by skill name, never by path (C-11), so a directory move is a `git mv` plus path-string updates (C-10, README) — never an edit to the skills that reference the moved ones (ADR-0009). A skill *rename* additionally changes its `name:` frontmatter and re-derives its Check 5 owner, so the renamed file must be re-scanned for foreign slugs (C-3).
