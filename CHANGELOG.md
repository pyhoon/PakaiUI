# Changelog

All notable changes to PakaiUI are recorded here. The project follows a `0.x` versioning policy: public
APIs may change, and breaking changes are documented explicitly.

## 0.10.0 (unreleased) — M0: reconnaissance and proof of concept

### Added

- `PUI` facade with `EscapeHtml`, `RawHtml`, `AddText`, `AddHtml` and `IsSafeUrl`.
- `PUIButtonOptions` and `PUICardOptions` option types, prefixed to avoid B4X global type collisions.
- `PUI.Button` with semantic variants/sizes, link mode (`Href`), disabled/hidden states, escaped text and
  attributes, and URL-scheme validation.
- `PUI.Card` with escaped title/subtitle/body/footer, plus `CardHeader`, `CardBody`, `CardFooter`,
  `CardTitle` and `CardText` part factories for composition.
- `source/build_b4xlib.bat` packaging script and the library `manifest.txt` / `libs.json`.
- `tests/m0-poc` console proof of concept: 28 assertions covering composition, escaping, URL validation,
  state attributes and explicit raw HTML.
- `docs/M0-RECONNAISSANCE.md` with verified MiniHTML 4.02 signatures, dependency/asset findings, the HTMX
  2.x baseline test definition and the recommended minimal public API.
- `AGENT.md` with build commands, architecture rules and the mandatory B4J warning checklist.

### Changed

- `source/` is now the PakaiUI library project (`PakaiUI.b4j`, `PUI.bas`) instead of a vendored copy of
  the MiniHTML4 project.
- PakaiUI consumes MiniHTML 4.02 as an external `.b4xlib` dependency.

### Removed

- Vendored MiniHTML4 project modules, snippets, templates and batch scripts from `source/`. They remain
  available in git history (commit `d14a5e7`) and upstream at `github.com/pyhoon/MiniHTML4`.
- The `.b4xlib` is no longer built from bundled MiniHTML sources.

### Verified

- Library and PoC compile with B4J 10.7 / JDK 19 (`B4JBuilder`).
- The CLI does not print IDE warning numbers; warning compliance (#19/#35/#9/#12) was audited by pattern
  and recorded in `docs/M0-RECONNAISSANCE.md`.
- PoC result: 28 passed, 0 failed, exit code 0.
- Local Bootstrap 5.3.8 and HTMX 2.0.8 assets serve byte-identically over HTTP without Node.js.

### Not included (later milestones)

- Badge, Alert, Breadcrumb, navigation, empty/loading states (M2).
- Forms, validation, tables, pagination (M3).
- HTMX/Alpine helpers, dialogs, toasts, theme switcher (M4).
- Pakai Server adapter, compatibility matrix, release (M5).
