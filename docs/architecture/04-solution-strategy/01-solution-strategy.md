# 4. Solution Strategy

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§4](README.md)._

The strategy the system **follows** — summarized from the decisions recorded as-is in §9 / Appendix A. Nothing here is proposed.

1. **One orchestrator, five role-bound specialists, hub-and-spoke** (ADR-0001). Odin alone holds the `task` permission and may reach exactly the five specialists; specialists cannot task each other and never reason about the user's Deliverable. Odin never performs specialist work and never reads artifact files — it acts on executive summaries and routes paths (`agents/odin-autonomous.md:6-19, 38-40, 72, 81`). Serves goal 2 (role isolation).

2. **Mandatory independent review by a dedicated reviewer** (ADR-0002). Every Mimir and Brokk Subtask receives a dedicated Heimdall review; every Orchestration Task ends at a Final Review Gate in a fresh Heimdall session; a verdict is `PASS`, `PASS-WITH-NOTES`, or `BLOCKED` and is never re-reviewed; failed reviews follow a classification ladder capped at three fix rounds (`agents/odin-autonomous.md:237-279`). Serves goal 1 (independent verification).

3. **Least-privilege permission blocks as the only enforcement mechanism** (ADR-0003). Every agent frontmatter begins with `"*": deny` and allows tools per role, with `edit` scoped by path glob and `bash` by command pattern, including shell-escape guards on `git` (`agents/mimir.md:6-68`; `agents/brokk.md:6-64`). Serves goals 2 and 1.

4. **Generated agent definitions with byte-identity validation** (ADR-0004). Odin's three modes are one shared body plus a mode-specific Communication Policy fragment; each subagent is a template head plus shared workspace/tooling/memory fragments plus a workflow tail; `validate.sh` and two smoke tests assert parity (`scripts/README.md:5-103`; `scripts/generate-subagents.sh:103-121`). Serves goal 3 (reproducibility).

5. **Two stores with opposite lifecycles** (ADR-0005). Transient, gitignored Workfiles in `.yggdrasil-workspace/` for intra-task exchange, written by Mimir/Kvasir/Heimdall/Bragi and read-only for Brokk; persistent, git-tracked Memories in `.yggdrasil-memory/` written only by reviewed pipelines (`agents/odin-autonomous.md:74-90`; `agents/brokk.md:53-56, 89-91`). Serves goals 4 and 2.

6. **Trigger-gated packaged workflows as Odin-prefixed skills** (ADR-0006). Research, Architecture, Software Engineering, and Deliberation Council are each a one-line triggering verdict in Odin's prompt plus a full-mechanism `odin-*` skill loaded on invoke; a packaged workflow is exempt from the Kvasir Consultation Check and inherits the standing review rules (`agents/odin-autonomous.md:172-219`). Serves goals 1 and 5.

7. **Three Odin modes that differ only in Communication Policy** (ADR-0007). Autonomous, Guided, and Interactive share every orchestration rule; the mode fragment sets whether Odin asks, suggests, or auto-proceeds at each checkpoint (`scripts/README.md:11-16`; `agents/odin-autonomous.md:280-302`). Serves the user-steering interest in §1.3.

8. **Memory governed by command-triggered, reviewed pipelines** (ADR-0008). Remember, Dream, and Forget are the only writers; every write is reviewed; Forget is confirmed; Memories are consulted as leads and verified against live sources before use (`agents/odin-autonomous.md:84-90`; `skills/memories/odin-memory-system/SKILL.md:24-61`). Serves goals 4 and 1.

**Cross-cutting tactic named by the doctrine:** forcing-function verdict lines. Odin must state a one-line recorded verdict before every consequential branch — `Deliverable:`, `Kvasir check:`, `Research check:`, `Architecture check:`, `Engineering check:`, `Deliberation check:` — so that a skipped step is visibly self-contradictory rather than silently omitted (`agents/odin-autonomous.md:119-123, 160, 185, 195, 205, 215`).
