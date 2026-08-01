# Engine upstream

This directory vendors selected targets from
[nathantannar4/Engine](https://github.com/nathantannar4/Engine).

- Upstream version: `2.13.1`
- Upstream commit: `9e674764e18889165a6618359fbd93d40c41b801`
- Previous vendored baseline: `1.8.1` (`0d2d564af1ad667c684071f208e431425806855f`)
- Synced targets: `Engine`, `EngineCore`, `EngineCoreC`, `EngineMacros`, and `EngineMacrosCore`

`EngineMacros` and `EngineMacrosCore` are retained as source snapshots but are not
currently declared as SwiftUIZ package targets. The separately distributed upstream
`EngineExtensions` target is not part of SwiftUIZ's `Engine` module.

SwiftUIZ-specific changes are intentionally limited to:

- public inspection and mutation of graph inputs and their property list;
- explicit-ID indexing and lookup for view outputs.

Runtime metadata layouts, OS version routing, and C runtime shims should otherwise
track upstream rather than preserving older SwiftUIZ workarounds.
