# ADR-0016: Scaffold step writes the arc42 folder skeleton into the target project; Kvasir authors the Workfile from the shape report — supersedes ADR-0011

- **Status:** Accepted (Revision 5, user-directed doctrine repair) — **supersedes ADR-0011** (`Accepted`, persisted; file left unedited, C-14)
- **Date:** 2026-09-19

## Context
ADR-0011 put the arc42 skeleton into a Workfile written by a Brokk session, which Kvasir then filled in place. That contradicts § Yggdrasil Workspace: "Mimir, Kvasir, Heimdall, and Bragi write Workfiles … Brokk reads Workfiles as inputs but does not write them" (`shared-body.template.md:49`, C-16). Brokk's medium is the target project (Artifacts). The user's corrected intent: Brokk scaffolds the architecture directory in the project, Kvasir drafts Workfiles mirroring that shape, Brokk's persistence skill fills the scaffold after ratification. The goals ADR-0011 served must survive: Brokk owns the template; a dedicated scaffold step resolves the mechanical facts (shape, scope, `next-adr`) before drafting; Kvasir loads no template skill (Check 5, C-3). Goals: Backward Compatibility (doctrine), Doctrine Minimization, Clarity of Intent, Cost Proportionality.

## Options Considered
| Option | Pros | Cons | Backward Compat. (doctrine) | Doctrine Min. | Clarity | Cost Prop. |
| --- | --- | --- | --- | --- | --- | --- |
| A. Status quo (Brokk writes the skeleton Workfile) — **Rejected: violates C-16** | Implemented | A Brokk session writing to the workspace; every review missed it | − | + | 0 | + |
| B. Kvasir instantiates its own skeleton Workfile from a template it loads | No Brokk scaffold dispatch | Kvasir would have to load `brokk-arc42-template` (Check 5 forbids) or the template returns to Kvasir ownership (reverses R2 user direction); Kvasir performs the repository look-up ADR-0011 removed from it | + | − | 0 | + |
| C. **Brokk scaffolds the folder skeleton in the target project (ADR-0017 defines its content); reports shape/scope/`next-adr` (I-5); Kvasir creates the Workfile itself from the report and its own Document shape table, plus an Appendix D layout map (ADR-0019); persistence fills the scaffold (ADR-0020)** | Each role writes only in its medium; the scaffold *is* the persisted structure, so persistence becomes a copy-in; the mechanical facts still resolve before drafting | Kvasir authors the header again (R-25); an aborted run leaves a skeleton in the project (R-20); I-3/I-5 grammar change | + | + | + | + (no new dispatch) |
| D. Odin writes the skeleton | No specialist dispatch | Odin produces no Artifacts or Workfiles by its own boundaries; no review of the skeleton | − | − | − | + |
| E. As C, but also rename `brokk-arc42-template` → `brokk-arc42-scaffold` | Name says what it does | Third rename of a shipped slug: `LICENSES/CC-BY-SA-4.0-arc42.txt` lines 6/8/66, README, deployed-copy sweep, inventory — for no behavior | 0 | 0 | + | − |

## Decision
We use **C**, keeping the slug (rejecting E). Step 3 of `odin-architecture-workflow` dispatches Brokk with `brokk-arc42-template` and the I-5 brief without a `workfile=` field; Brokk acts on the target project only (create / verify / extend, §5.1.11) and returns `Scaffold result: target=…, structure=…, shape=…, document-scope=…, existing=…, next-adr=…`. Step 4 dispatches Kvasir with that line and the Workfile path to **create**; Kvasir writes the header from the line (`Document scope`, `Scaffold: <target> (structure: …)`, `Existing document` iff update delta) and the twelve-section structure from its own Document shape table. I-3 gains `scaffold=<path> — <created | verified | extended>` so an unfilled skeleton is always disclosed. The `Focus: scaffold` review targets the project tree (§5.1.5).

## Consequences
- **Positive:** the standing rule holds by construction; persistence needs no shape re-derivation (the scaffold is the shape); the `Focus: scaffold` review gains a mechanical `git diff = additions only` check; Kvasir's independence from the template skill and Brokk's template ownership are preserved.
- **Negative:** a `Status: Scaffolded` skeleton can be left behind by an aborted run (R-20, disclosed not deleted); the Kvasir header is authored, not pre-filled (R-25, double-checked by two reviews); I-3 and I-5 grammars change post-delivery (R-24).
- **Becomes harder:** running Kvasir's skill without a scaffolded target — it now expects the result line; a caller must run step 3 first (already true under ADR-0011 for the Workfile).

## Related
AC-4, AC-5, AC-6, AC-11, AC-18 · §5.1.1 (I-3, I-5, steps 3–4, 7), §5.1.4, §5.1.5, §5.1.11, §8.7, §8.10 · ADR-0011 (superseded), ADR-0017, ADR-0018, ADR-0019, ADR-0020 · WP-R5-1, WP-R5-2, WP-R5-3, WP-R5-4.
