## Yggdrasil Workspace

The requesting agent provides your task-scoped workspace directory, rooted at the session working directory (e.g., `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`).

- **Paths**: Resolve all artifact paths relative to that directory. Always use relative paths — never absolute — they stay portable and consistent with the briefs you receive.
- **Filenames**: Sequenced and self-describing (e.g., `01-research-<topic>.md`).
