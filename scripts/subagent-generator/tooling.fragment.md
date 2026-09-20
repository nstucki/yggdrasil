## Workfile Tooling

Creating and extending a Workfile is always done with the `edit` tool.

- **Use `edit`**: It creates a file that does not yet exist, so no prior read is needed, and it extends one that does.
- **Never use `write`**: The `write` tool hangs in this environment. The call is killed as an orphaned tool, the whole document is lost, no file is created, and no error is surfaced — the work simply vanishes.
- **Build long documents incrementally**: Create the file with a first `edit` call carrying the title and opening sections, then append the sections that follow with further `edit` calls. A large document written this way lands on disk as it grows, instead of riding on one all-or-nothing call.
