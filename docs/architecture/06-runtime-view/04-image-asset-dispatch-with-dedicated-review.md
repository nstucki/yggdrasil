# 6.4 Image Asset Dispatch with Dedicated Review

_Part of [Yggdrasil — Architecture (arc42)](../README.md) · [§6](README.md)._

Realizes AC-1, AC-2, AC-3 (and exercises AC-7 at runtime). Read from `scripts/odin-generator/shared-body.template.md:19-29, 49, 150, 225` (as revised by WP-2), §5.1.2's image brief / manifest contract, and the standing review mechanics (`agents/odin-autonomous.md:237-265`).

```mermaid
sequenceDiagram
    autonumber
    participant U as User
    participant O as Odin
    participant E as Eitri (model: per ADR-0009)
    participant FS as Target project / Workspace
    participant H as Heimdall

    U->>O: "Create a hero illustration for the README at images/hero.svg"
    O->>O: Deliverable: artifact=yes (images/hero.svg); capability-inventory loaded (### Designer present)
    O->>E: task(eitri) — brief: asset path, format=svg, subject, style, references, manifest 01-image-hero.md
    E->>FS: read reference assets / design tokens (read, glob, grep)
    alt brief complete and format authorable
        E->>FS: edit images/hero.svg (allowed by **/*.svg)
        E->>FS: edit .yggdrasil-workspace/<task>/01-image-hero.md (manifest)
        E-->>O: Image: asset=images/hero.svg, format=svg, dimensions=viewBox 0 0 1200 400, model=<id|unknown>, manifest=01-image-hero.md
    else brief incomplete or raster requested without a granted tool
        E->>FS: edit manifest with Status: blocked — <reason>
        E-->>O: Image: blocked — <reason>, manifest=01-image-hero.md
        O->>O: Failed-path: re-brief (execution defect) or escalate per Communication Policy
    end
    O->>H: task(heimdall) — review brief: exact originating brief, asset path, manifest path, baseline pinned
    H->>FS: read images/hero.svg (image content), read manifest, check Brief compliance rows against the brief
    H-->>O: Verdict: PASS | PASS-WITH-NOTES | BLOCKED (+ findings)
    alt BLOCKED
        O->>E: resume session (task_id) — fix round ≤ 3 per Failed Review Classification
    end
    O->>H: Final Review Gate (fresh session) on the assembled Deliverable
    H-->>O: PASS
    O-->>U: Response naming images/hero.svg and disclosing model/gaps from the manifest
```

**Error path taken.** A host permission denial (a path outside the ADR-0010 globs, e.g. `docs/hero.pdf`) surfaces as a tool error to Eitri, who reports `Image: blocked — path docs/hero.pdf not writable under permission profile` and writes the blocked manifest; Odin treats it as an execution defect if the brief mis-named the path, or as a plan-level mismatch if the Deliverable genuinely requires a format Eitri cannot write (then Kvasir is consulted before any fix — `agents/odin-autonomous.md:267-279`). A third consecutive `BLOCKED` on the Eitri session is an unresolvable blocker handled per Communication Policy.
