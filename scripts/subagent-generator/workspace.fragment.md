## Yggdrasil Workspace

The Yggdrasil Workspace (`.yggdrasil-workspace/`, rooted at the session working directory) holds transient, task-scoped exchange files. The requesting agent scopes each task to a directory (e.g., `.yggdrasil-workspace/<yyyymmdd>-<task-slug>-<xx>/`).

- **Workfile**: A Workfile is a transient file in this workspace.
- **Inputs**: If the task prompt references Workfile paths, read them fully before starting work.
- **Paths**: Resolve all Workfile paths relative to the task directory. Always relative, never absolute — they stay portable and consistent with the briefs you receive.
- **Filenames**: Sequenced and self-describing (e.g., `01-research-<topic>.md`).
