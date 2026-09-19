# 8.9 Layout map and promotion (R5)

_Part of [Architecture Workflow (Yggdrasil) — Architecture (arc42)](../README.md) · [§8](README.md)._

Appendix D is the drafter's single, reviewable projection of the Workfile onto the persisted tree: one row per heading under each `## N.` — `Workfile heading → target path → promotion`. The split rule (5.1.4) decides how many topic documents a section gets; the map records the decision so the persister copies without judgment and the reviewer checks totality (every heading exactly once), conformance (naming, ordinals, slugs), and the rule. Promotion is uniform: a document's root heading is promoted to H1 by `depth − 1`, and its body by the same distance — the old "one for sections, two for records" becomes two instances of one rule. Appendix D is Workfile content, never persisted.
