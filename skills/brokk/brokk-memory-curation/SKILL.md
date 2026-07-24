---
name: brokk-memory-curation
description: Distill reviewed findings into a persistent, source-cited knowledge base; establish, consolidate, and prune knowledge entries.
---

# Memory Curation

## Purpose

Maintain a persistent, project-scoped knowledge base by distilling reviewed research findings into durable, source-cited entries; establishing the knowledge base structure in new projects; and executing consolidation and deletion operations when tasked by the requesting agent.

The knowledge base serves as a cross-task repository of distilled knowledge — facts, decisions, hard-won findings, and rationale — that would otherwise be lost when task artifacts expire. Every entry must be grounded in reviewed sources and maintained with explicit metadata (creation/update dates, confidence levels, status). The three write-side operations (promotion, consolidation, deletion) all route through this skill to ensure consistent quality and traceability.

## When to Use

- **Promotion (remember):** When the requesting agent tasks you to distill reviewed research findings into memory entries. The requesting agent provides the reviewed artifact path(s) and source citations; you extract durable claims and write them as new or updated entries.
- **Establishment:** When a project lacks a `.yggdrasil-memory/` directory and the requesting agent asks you to scaffold it. You create the directory structure, populate canonical templates, and initialize the manifest.
- **Consolidation (dream):** When the requesting agent provides a reviewed audit of the knowledge base and tasks you to apply its findings — merging duplicates, reconciling contradictions, pruning obsolete entries, reorganizing topics, and updating the manifest.
- **Deletion (forget):** When the requesting agent provides an explicit, confirmed scope of entries to delete and tasks you to remove them. You delete exactly the named entries, update the manifest, and leave changes in the working tree (never commit).

## Workflow

### Establishment Workflow

When tasked to establish `.yggdrasil-memory/` in a project:

1. **Check for existing directory.** If `.yggdrasil-memory/` already exists, report that it is already established and stop.
2. **Create the directory structure:**
   ```
   .yggdrasil-memory/
   ├── README.md       (canonical template from this skill)
   └── INDEX.md        (empty manifest with header in place)
   ```
3. **Populate `README.md`** from the canonical template (see Quality Criteria section below for the exact template text).
4. **Initialize `INDEX.md`** with a header and empty-state placeholder (see Quality Criteria section).
5. **Report completion** to the requesting agent with the directory path and a note that the knowledge base is ready for entries.

### Promotion Workflow (Distillation)

When tasked to promote reviewed findings into memory:

1. **Read the reviewed artifact(s) fully.** The requesting agent provides the path(s) to the reviewed research artifact(s) and/or original sources. Read them completely before extracting claims.
2. **Extract durable, source-cited claims only.** Identify statements that are:
   - Factual and verifiable against the sources you just read.
   - Durable (not task-specific, not transient state, not reproducible in seconds by reading one file).
   - Worth retaining across multiple tasks (decisions, hard-won findings, project facts).
   - **Never** secrets, credentials, or sensitive data.
3. **Organize by topic.** Group related claims into logical topics (e.g., "validation-tooling," "agent-permission-model"). One topic = one entry file.
4. **Write or update entry files.** For each topic:
   - Create a new file `<topic>.md` or update an existing one.
   - Include YAML frontmatter with required fields (see Quality Criteria for the schema).
   - Write the markdown body with the distilled knowledge, organized for clarity.
   - **Cite sources precisely:** in the frontmatter `sources` field, list file paths and line numbers (e.g., `scripts/validate.sh:42-50`, `AGENTS.md:35`).
5. **Update `INDEX.md`.** Add or update one line per entry: topic name, brief summary, updated date. Keep the manifest in sync with the files on disk.
6. **Report completion** to the requesting agent with the list of entries created/updated and the artifact path.

### Consolidation Workflow (Dream)

When tasked to apply a reviewed audit to the knowledge base:

1. **Read the reviewed audit artifact fully.** The requesting agent provides the path to the reviewed audit (an analysis of the knowledge base for duplicates, contradictions, staleness, and reorganization opportunities). Read it completely.
2. **Execute the audit's findings faithfully.** Do not re-decide what the audit already decided. Apply its guidance exactly:
   - **Merge/deduplicate:** Combine overlapping entries into one authoritative entry; union their source citations.
   - **Reconcile contradictions:** Where the audit identified conflicting claims, follow its guidance on which entry to keep (mark the loser `superseded` or delete it).
   - **Prune:** Delete entries the audit marked as obsolete, trivially re-derivable, or below the value bar. Downgrade `confidence` on aging unverified entries per the audit's guidance.
   - **Reorganize:** Split bloated topic files, rename topics, or restructure as the audit recommends.
3. **Update `INDEX.md`.** Rebuild the manifest to reflect all changes (deletions, merges, renames, confidence downgrades).
4. **Leave changes in the working tree.** Do not commit. The requesting agent will review the diff and commit if approved.
5. **Report completion** to the requesting agent with a summary of changes (entries merged, deleted, reorganized, confidence adjusted) and the artifact path.

### Deletion Workflow (Forget)

When tasked to delete entries from the knowledge base:

1. **Verify the scope.** The requesting agent provides an explicit, confirmed list of entry names/topics to delete. This list has already been presented to the user and confirmed. Do not infer, expand, or interpret the scope — delete exactly what you are given.
2. **Delete entry files.** Remove the named `.md` files from `.yggdrasil-memory/`.
3. **Update `INDEX.md`.** Remove the corresponding lines from the manifest. Ensure the manifest remains valid and consistent.
4. **Leave changes in the working tree.** Do not commit. The requesting agent will review the diff and commit if approved.
5. **Report completion** to the requesting agent with the list of deleted entries and confirmation that the manifest is consistent.

## Quality Criteria

### Entry Frontmatter Schema

Every entry must include the following YAML frontmatter (in this order):

```yaml
---
topic: <kebab-case-topic-name>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
sources:
  - <file-path>:<line-range>  # e.g., scripts/validate.sh:42-50
  - <file-path>               # e.g., AGENTS.md
confidence: <high|medium|low>
status: <active|stale|superseded>
---
```

**Field definitions:**
- `topic`: Unique identifier for the entry, kebab-case, matching the filename (without `.md`).
- `created`: ISO date when the entry was first written.
- `updated`: ISO date of the most recent modification.
- `sources`: List of file paths and/or line ranges where the claims in this entry are sourced. Always cite verifiable sources; never leave this empty.
- `confidence`: `high` (verified recently), `medium` (verified but aging), `low` (unverified or contradicted by newer sources).
- `status`: `active` (current and in use), `stale` (unverified for a long time; consider re-verifying or deleting), `superseded` (replaced by a newer entry; kept for history).

### INDEX.md Manifest Format

The manifest lists all entries in the knowledge base. Format:

```markdown
# Knowledge Base Index

| Topic | Summary | Updated |
|-------|---------|---------|
| validation-tooling | validate.sh Check 4 enforces byte-identical shared body blocks via shasum | 2026-07-23 |
| agent-permission-model | Permission blocks are protected; changes require documented governance amendments | 2026-07-23 |
```

**Rules:**
- One row per entry file (excluding this file itself).
- Columns: topic name, one-line summary, updated date (ISO format).
- Keep the manifest in sync with the files on disk — every `.md` file in the directory (except `README.md` and `INDEX.md` itself) must have a corresponding row.
- When entries are added, merged, deleted, or renamed, update the manifest immediately.

### README.md Canonical Template

Every project's `.yggdrasil-memory/README.md` is generated from this canonical template (stored in this skill). The template is:

```markdown
# Knowledge Base

This directory contains the project's persistent knowledge base — distilled, source-cited findings that persist across task lifecycles.

## What Goes Here

- **Facts about the project** (e.g., "validate.sh Check 4 enforces byte-identical shared body blocks via shasum") — with file/line citations.
- **Decisions and rationale** (e.g., "temperature changes are made one role at a time because…").
- **Hard-won findings** (root causes from debugging tasks, dependency quirks, performance characteristics).
- **NOT**: task narratives, review verdicts, transient state, anything reproducible in seconds by reading one file.

## Entry Format

Each entry is a markdown file with YAML frontmatter. See the schema below.

### Frontmatter Schema

```yaml
---
topic: <kebab-case-topic-name>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
sources:
  - <file-path>:<line-range>  # e.g., scripts/validate.sh:42-50
  - <file-path>               # e.g., AGENTS.md
confidence: <high|medium|low>
status: <active|stale|superseded>
---
```

**Fields:**
- `topic`: Unique identifier, kebab-case, matching the filename (without `.md`).
- `created`: ISO date when the entry was first written.
- `updated`: ISO date of the most recent modification.
- `sources`: File paths and/or line ranges where the claims are sourced. Always cite verifiable sources.
- `confidence`: `high` (verified recently), `medium` (verified but aging), `low` (unverified or contradicted).
- `status`: `active` (current), `stale` (unverified for a long time), `superseded` (replaced by a newer entry).

## INDEX.md

The `INDEX.md` file is a manifest listing all entries in the knowledge base. It is kept in sync with the files on disk — every entry file must have a corresponding row in the manifest.

## Maintenance

The knowledge base is maintained through three operations:

- **Remember (promotion):** Distill reviewed research findings into new or updated entries. Only reviewed research is eligible.
- **Dream (consolidation):** Audit the knowledge base for duplicates, contradictions, and staleness; consolidate and prune per a reviewed audit.
- **Forget (deletion):** Delete entries by explicit user instruction and confirmation.

All mutations are reviewed before they are final. Changes are left in the working tree (never committed by agents) — committing is the user's act.

## Git History as Recovery Net

By default, this directory is git-tracked. Git history provides an audit trail of all changes and serves as a recovery net for destructive operations (forget, dream pruning). A mistaken deletion is `git checkout` away.

## Canonical Source

This README is generated from the canonical template in the `brokk-memory-curation` skill. If you are reading this in a host/target project, the schema and conventions are authoritative in the skill; this file documents them for your reference.
```

### Quality Criteria for Entries

- **Every entry must cite verifiable sources.** The `sources` field must list file paths and/or line numbers where the claims are grounded. Never cite a source you have not read.
- **No entry created or modified without a distinct upstream reviewed artifact backing it.** Promotion requires a reviewed research artifact. Consolidation requires a reviewed audit. Deletion requires explicit user confirmation. Never write to memory based on your own reasoning or inference.
- **INDEX.md always kept in sync.** Every entry file on disk must have a corresponding row in the manifest. Every row in the manifest must correspond to a file on disk.
- **Never promote secrets or credentials.** Entries are git-tracked by default and visible in diffs. Sensitive data is non-promotable content.
- **Confidence and status fields are honest.** Mark entries `low` confidence if sources are old or unverified. Mark entries `stale` if they have not been re-verified in a long time. Never overstate certainty.

## Anti-Patterns

- **Fabricating knowledge not present in sources.** Every claim must be extractable from the reviewed artifact or original sources you read. Never extrapolate, infer, or add reasoning beyond what the sources support.
- **Skipping INDEX.md updates.** A manifest out of sync with the files on disk is worse than no manifest — it creates confusion and makes future consolidation harder. Update it every time you modify the entry files.
- **Expanding a forget scope beyond what was confirmed.** The requesting agent provides an explicit list of entries to delete. Delete exactly that list, nothing more. Never infer "related" entries or "probably stale" entries to delete alongside the confirmed scope.
- **Treating memory entries as a place for raw or unreviewed notes.** Memory is not a scratch pad. Every entry is a durable claim backed by reviewed sources. If you are tempted to write something without a reviewed source, it does not belong in memory yet.
- **Promoting task narratives or transient state.** Memory is for durable knowledge, not "what happened in this task" or "the current state of X." If a claim is only true for this task or only true right now, it is not durable enough for memory.
- **Chaining forget into other operations.** Dream prunes by judgment (reviewed); forget obeys explicit instruction (confirmed). Keep the semantics separate. Never silently delete entries as a side effect of dream or any other operation.
