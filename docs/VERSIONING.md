# PakaiUI versioning, migration and release policy

Version 0.16, 2026-10-30. This document is the contract for how PakaiUI versions, changes and releases
the library, the assets and the documentation.

## Version policy

PakaiUI is pre-1.0 and experimental. Versions follow a `0.MINOR.PATCH` scheme:

- **MINOR** (`0.14` -> `0.15`) marks a milestone or a public API change. Before 1.0 a minor release may
  contain breaking changes, but every breaking change must be listed in `CHANGELOG.md` and this document.
- **PATCH** (`0.15.0` -> `0.15.1`) is for fixes, documentation corrections and internal changes that do not
  change public signatures or rendered contracts.
- Asset-only upgrades (Bootstrap, HTMX, Alpine, icons) are called out explicitly and include new SHA-256
  hashes. They are not silently mixed into a patch.
- A 1.0 release would commit to semantic versioning for the public API in `docs/API-REFERENCE.md`; that
  promise has not been made yet.

The single source of the library version is `PUI.VERSION`. A release is consistent only when all of these
agree:

| Location | Value |
| --- | --- |
| `source/PUI.bas` | `Public Const VERSION = "0.16"` and the file header |
| `source/manifest.txt` | `Version=0.16` |
| `source/libs.json` | `"Version": "0.16"` |
| `assets/res.json` | `"Version": "0.16"` |
| `assets/css/pakaiui.css` | header `PakaiUI theme tokens 0.16` |
| `assets/css/pakaiui-asadi.css` | header `PakaiUI Asadi theme 0.16` |
| `README.md`, `AGENT.md`, `CHANGELOG.md` | current milestone/version |
| `gallery/HomePage.bas` | `PakaiUIVersion` |
| Milestone documents | version they describe |

## Public API contract

- Public methods, option types and constants are listed in [`API-REFERENCE.md`](API-REFERENCE.md).
- Private helpers may change at any time; do not call them from applications.
- Adding fields to the end of an option type is treated as compatible. Reordering or removing fields is
  breaking.
- Changing rendered Bootstrap classes or required attributes is treated as a breaking change when it
  changes documented behavior, even if B4J signatures are unchanged.
- New optional components may be added in a minor release.
- `PUI.VERSION` is informational; guard code should not branch on it unless the migration notes say so.

## Deprecation

- Deprecated public API is documented in `CHANGELOG.md` and the relevant component reference before
  removal.
- A deprecated method or field remains for at least one minor release when practical.
- Pre-1.0, a security or correctness fix may remove an unsafe API immediately; the reason and migration
  are recorded in `CHANGELOG.md`.
- Never leave a deprecated alias undocumented or untested.

## Migration history

### 0.15 -> 0.16 (MiniHTML 4.04+ escaping)

No public API changes. PakaiUI now relies on MiniHTML 4.04+ escaping `.text` values by default and no longer
pre-escapes them; attribute values are still escaped by PakaiUI. MiniHTML 4.04 or newer is required —
do not pair 0.16 with 4.02/4.03. Rebuild against the 0.16 `.b4xlib` and refresh `pakaiui.css` and
`pakaiui-asadi.css` (`?v=0.16`); the CSS changed only in its version header.

### 0.14 -> 0.15 (M5)

No public API changes. Adds the Pakai Server/EndsMeet example, the compatibility matrix, this policy and
the complete API reference. Existing applications need only rebuild against the 0.15 `.b4xlib` and refresh
`assets/css/pakaiui.css` (`?v=0.15`).

### 0.13 -> 0.14 (M4)

Additive: `Htmx`, `Alpine`, `Modal`, `ModalTrigger`, `Toast`, `ThemeSwitcher`, `Sidebar` and their option
types/factories. No existing signatures changed. New optional JavaScript assets must be synced only if those
features are used. The gallery theme switch now uses `ThemeSwitcher`.

### 0.12 -> 0.13 (M3)

Additive: form controls, table, pagination, filter bar and their options. Public form components use `Id`
for the control and `CssClass`/`Hidden` for the field group. No M1/M2 signature changed. `Select` is
unavailable as a B4X method name, so the component is `SelectField`.

### 0.11 -> 0.12 (M2)

Additive components. `PUICardOptions` gained `HeaderText`, `ImageSrc`, `ImageAlt` and `Hidden` at the end;
existing field assignments remain valid. New navbar markup uses `flex-wrap` instead of a collapse toggle.

### 0.10 -> 0.11 (M1)

Additive: theme tokens, document skeleton, page primitives, tracked assets and the standalone gallery.
`Button` and `Card` kept their signatures.

## Migrating a host application

1. Install the new `PakaiUI.b4xlib` into `C:\B4X\Additional\B4J` (replace the file, restart the IDE).
2. Run `sync-assets.bat <project>` to copy the tracked assets into `Objects\www\assets`.
3. Update asset query strings to the new versions (`bootstrap.min.css?v=5.3.8`,
   `pakaiui.css?v=0.15`, `htmx.min.js?v=2.0.8`, `alpine.min.js?v=3.15.8`).
4. Compile the host. Read `CHANGELOG.md` if any option field or rendered class changed.
5. Re-run the host's own tests and the relevant PakaiUI suites.

For a Pakai Server host, the rendering integration is unchanged: build a `MiniHtml` document and write
`page.build` to the response. See [`PAKAI-SERVER-INTEGRATION.md`](PAKAI-SERVER-INTEGRATION.md).

## Release checklist

Run from the repository root unless a step says otherwise.

```powershell
# 1. Build and smoke-test the library
cd source
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\PakaiUI.jar

# 2. Package and install
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force

# 3. Run every suite from its own folder (28 + 35 + 135 + 203 + 162 assertions)
#    See AGENT.md for the exact commands.

# 4. Rebuild the gallery, sync assets and verify it in a browser
# 5. Rebuild examples\pakai-server, sync assets and verify / and /submit

# 6. Record SHA-256 hashes
Get-FileHash source\PUI.bas
Get-FileHash source\Objects\PakaiUI.b4xlib
Get-FileHash assets\css\pakaiui.css
Get-FileHash assets\js\alpine.min.js
```

Release is complete only when:

- The build and all suites exit 0.
- The installed `PakaiUI.b4xlib` hash matches the packaged artifact.
- The gallery and example render with no browser console errors.
- `docs/COMPATIBILITY.md`, `docs/API-REFERENCE.md`, `CHANGELOG.md` and this document describe the same
  version.
- Asset hashes in `assets/README.md` match the tracked files.
- A clean `git status` is reviewed; commit and tag only with the maintainer's approval.
- No remote push or tag is performed without explicit instruction.

## Tagging

Use annotated tags in the form `v0.15.0` once the release commit is approved. The tag message records the
library, asset and documentation versions plus the artifact SHA-256. Do not tag a build that has not passed
the checklist above.
