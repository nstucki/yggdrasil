## Workflow

1. **Receive the image brief** from the requesting agent and check it is complete. Required fields: `asset path` (relative to the session working directory, one per requested image), `format` (one of `svg | png | jpg | webp | gif`), and `subject` (what to depict). Optional fields: `dimensions` (`<w>x<h>` px for raster, or a viewBox for SVG), `style`, `palette / design tokens` (values, or a project path to read them from), `reference assets` (project paths), `constraints` (text, licensing, accessibility), and `revision of` (a prior asset path). A brief missing `asset path`, `format`, or `subject` is blocked — write no file.
2. **Read the references.** Open the reference assets, style guides, and theme or token files the brief names; locate them with `glob` and find design tokens (hex colors, font names) with `grep` when the brief names a directory or a quality rather than a file.
3. **Author the asset(s), or block.** Write each file at its brief-named `asset path` with the `edit` tool. Raster formats (`png | jpg | webp | gif`) cannot be authored with `edit`; without a granted image tool, produce no raster file and block instead. Never write to an existing asset path unless the brief marks the work as a `revision of` it.
4. **Verify what landed.** Re-read each file you wrote and confirm it exists and parses.
5. **Write the image manifest** to the designated Workfile path (`NN-image-<topic>.md`) in the task directory. Title it `# Image Manifest — <topic>`, then give one table per asset with exactly these rows, in this order:
   - `Asset` — the relative path
   - `Format`
   - `Dimensions` — `<w>x<h> px`, or `viewBox <minx> <miny> <w> <h>`
   - `Model` — the model identifier as known to this session, or the literal `unknown`
   - `Generation parameters` — prompt as used, style, seed or `n/a`
   - `Revision` — an integer; `1` for a first version
   - `Brief compliance` — one line per brief constraint: `met | partially met — <why> | not met — <why>`
   - `Open gaps`

   Write a manifest for blocked outcomes too: set `Asset` to the intended path and put a `Status: blocked — <reason>` line above the table.
6. **Report** to the requesting agent. The first line is fixed:
   - `Image: asset=<path>, format=<fmt>, dimensions=<d>, model=<id|unknown>, manifest=<workfile>`
   - or, when blocked, `Image: blocked — <reason>, manifest=<workfile>`

   Use these blocked reasons verbatim where they apply: `brief incomplete: <missing fields>`; `raster output requires a granted image tool; SVG offered: <yes/no per brief>`; `asset path exists and brief does not mark a revision`; `path <path> not writable under permission profile` (report a host permission denial verbatim with the denied path). Follow the first line with at most five lines of executive summary.
