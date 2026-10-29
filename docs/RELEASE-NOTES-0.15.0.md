# PakaiUI 0.15.0 — M5: integration and release readiness

**Release date:** 2026-10-30  
**Tag:** `v0.15.0`  
**Commit:** `3804abe`  
**Status:** experimental 0.x release

PakaiUI is a server-rendered UI component library for B4J web applications, built on MiniHTML 4.02 and
Bootstrap 5.3. It produces plain HTML and works without Pakai Server. HTMX and Alpine.js remain optional.

## Highlights

- Adds a verified **Pakai Server / EndsMeet host example** that renders PUI pages from normal routes, with
  no adapter library and no second server.
- Completes the public API documentation, compatibility matrix, versioning/migration policy and release
  checklist.
- Confirms the full M1-M4 component set with 563 automated assertions, gallery checks and the host example.

## Included in this release

### Components and primitives

- Page/document: `Document`, `Head`, `Body`, stylesheets, scripts, containers, rows and columns.
- Core components: Button, Card, Badge, Alert, Breadcrumb, PageHeader, Nav/NavItem/Navbar, EmptyState,
  LoadingState.
- Forms and data display: Input, Textarea, SelectField, Checkbox, Radio, validation feedback, Table,
  Pagination, FilterBar.
- Optional interactions: Htmx/Alpine helpers, Modal/ModalTrigger, Toast, ThemeSwitcher, Sidebar.
- 34 option factories, 29 option types and documented constants.

### Examples and documentation

- `examples/pakai-server/` - EndsMeet 4.03 host for `GET /` and `POST /submit`.
- `docs/API-REFERENCE.md` - complete public API.
- `docs/COMPATIBILITY.md` - verified versions and constraints.
- `docs/VERSIONING.md` - versioning, migration and release policy.
- `docs/PAKAI-SERVER-INTEGRATION.md` - host integration guidance.
- M2/M3/M4 component references and the M0 reconnaissance record.

### Tooling

- `sync-assets.bat` now resolves tracked assets relative to the script, so it works from repository or
  project folders.
- `source/libs.json` version corrected to 0.15.

## Verified stack

| Component | Version |
| --- | --- |
| B4J | 10.7 (B4JBuilder 10.70) |
| Java | 19 |
| MiniHTML | 4.02 |
| Bootstrap CSS/JS | 5.3.8 |
| Bootstrap Icons | 1.13.1 |
| HTMX | 2.0.8 (optional) |
| Alpine.js | 3.15.8 (optional) |
| EndsMeet | 4.03 (example host only) |

## Verification

- M0 PoC: 28 passed
- M1 foundation: 35 passed
- M2 components: 135 passed
- M3 forms/data display: 203 passed
- M4 optional interactions: 162 passed
- **Total: 563 assertions, 0 failed**
- Library smoke test: `PakaiUI v0.15`, exit 0
- Gallery: all sections, 33 unique ids, 12 labels, no console errors
- Pakai Server example: builds, starts on port 51020, GET/POST verified, submitted markup escaped

## Installation

1. Install `PakaiUI.b4xlib` into `C:\B4X\Additional\B4J`.
2. Sync assets into the host project:

   ```powershell
   cmd /c sync-assets.bat <project-folder>
   ```

3. Link the versioned assets from the page:

   ```b4j
   PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
   PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=0.15")
   ```

## Artifact

`PakaiUI.b4xlib` SHA-256:

```text
AFB3E766F2F5CF703430D0B48A753CCD44A6CAFF991C6103D81ECAA39293092C
```

## Upgrading

From 0.14, there are **no public API changes**. Rebuild against the 0.15 `.b4xlib`, refresh `pakaiui.css`
with `?v=0.15`, and keep the existing asset versions. See `CHANGELOG.md` and `docs/VERSIONING.md` for
earlier migrations.

## Known limitations

- PakaiUI is pre-1.0; the public API may still change.
- No CI pipeline or automated hash gate yet; verification is currently manual.
- Browser testing covers Chromium on Windows, not a full browser matrix.
- `C:\Projects\pakai-asadi` was inspected but not modified; it remains a future consumer.
- B4JBuilder does not surface IDE warning numbers, so warning audits remain pattern-based or IDE-based.

## Links

- API reference: [`API-REFERENCE.md`](API-REFERENCE.md)
- Compatibility: [`COMPATIBILITY.md`](COMPATIBILITY.md)
- Versioning and release policy: [`VERSIONING.md`](VERSIONING.md)
- Pakai Server integration: [`PAKAI-SERVER-INTEGRATION.md`](PAKAI-SERVER-INTEGRATION.md)
