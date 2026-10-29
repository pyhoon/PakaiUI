# Changelog

All notable changes to PakaiUI are recorded here. The project follows a `0.x` versioning policy: public
APIs may change, and breaking changes are documented explicitly.

## 0.15.0 (2026-10-30) — M5: integration and release readiness

### Added

- Verified `examples/pakai-server` host: an EndsMeet 4.03 application that renders PakaiUI pages from
  `GET /` and handles `POST /submit` with escaped request data. It consumes the installed `.b4xlib` and
  is not packaged with the library.
- `docs/PAKAI-SERVER-INTEGRATION.md`: host model, build/run steps, static assets, base paths,
  authentication/CSP/error-handling guidance and verified results.
- `docs/API-REFERENCE.md`: complete public methods, option types and constants.
- `docs/COMPATIBILITY.md`: verified B4J/JDK/MiniHTML/Bootstrap/HTMX/Alpine/EndsMeet versions, evidence and
  constraints.
- `docs/VERSIONING.md`: version policy, migration history, deprecation, release checklist and tagging rules.
- Example host README with routes and verification record.

### Changed

- `PUI.VERSION`, `manifest.txt`, `source/libs.json`, `assets/res.json`, the CSS header, gallery and docs
  bumped to 0.15.
- `source/libs.json` version corrected from the stale 0.10 value to 0.15.
- `.gitignore` now excludes `examples/*/Objects`, logs, backups and IDE metadata.
- `sync-assets.bat` resolves the tracked `assets\` folder relative to the script, so the documented
  commands work from a project folder as well as from the repository root.
- README/AGENT document the example, API reference, compatibility matrix and release policy.

### Verified

- Pakai Server/EndsMeet example build: PASS, exit code 0.
- Example runtime: PASS - EndsMeet 4.03 on port 51020; `/` renders navbar/form/table with assets.
- Example POST: PASS - `<b>Test</b>` rendered escaped on `/submit`.
- Example browser console: PASS - no errors; no horizontal overflow.
- M4 interactions: 162 passed, 0 failed, exit code 0.
- M3 forms/data display: 203 passed, 0 failed, exit code 0.
- M2 components: 135 passed, 0 failed, exit code 0.
- M1 foundation: 35 passed, 0 failed, exit code 0.
- M0 proof of concept: 28 passed, 0 failed, exit code 0.

### Not included

- No Git tag or remote push was performed; release tagging awaits maintainer approval.
- `C:\Projects\pakai-asadi` was inspected as a reference consumer and was not modified or repackaged.

## 0.14.0 (unreleased) — M4: optional interactions

### Added

- `PUI.Htmx` (`PUIHtmxOptions`): typed `hx-*` attributes on any element, with URL validation, method and
  swap whitelists, target, trigger, confirm, indicator and push-url support. The helper never loads HTMX.
- `PUI.Alpine` (`PUIAlpineOptions`): typed `x-data`, `x-show`, `x-text`, `x-model`, `x-on:click`, `x-init`
  and `x-bind:class` attributes. The helper never loads Alpine; expression fields are documented as
  trusted developer code.
- `PUI.Modal` (`PUIModalOptions`) and `PUI.ModalTrigger` (`PUIModalTriggerOptions`): Bootstrap dialog
  markup with title labels, sizes, scrollable/centered/static-backdrop options and dismiss buttons.
- `PUI.Toast` (`PUIToastOptions`): visible Bootstrap toast with optional title, variant, close button,
  autohide data and escaped message.
- `PUI.ThemeSwitcher` (`PUIThemeSwitcherOptions`): server-rendered Auto/Light/Dark link group with an
  active state; works without JavaScript.
- `PUI.Sidebar` (`PUISidebarOptions`): static aside with optional brand, title, vertical nav, sticky and
  border options; no JavaScript required.
- Option factories: `NewHtmxOptions`, `NewAlpineOptions`, `NewModalOptions`, `NewModalTriggerOptions`,
  `NewToastOptions`, `NewThemeSwitcherOptions` and `NewSidebarOptions`.
- Tracked Alpine.js 3.15.8 asset with its MIT license, hashes and resource manifest entry.
- `tests/m4-interactions` console test project: 162 assertions covering markup, escaping, validation,
  defaults, trust boundaries and composition.
- `docs/M4-INTERACTIONS.md` behavior-owner table, component reference, security notes and verification.
- The gallery now demonstrates the HTMX helper, Alpine local state, a modal, a toast, the theme switcher
  and a sidebar.

### Changed

- `PUI.VERSION` and `manifest.txt` version bumped to 0.14.
- The gallery theme switch now uses `PUI.ThemeSwitcher` instead of hand-built buttons.
- The gallery loads Alpine 3.15.8 as an optional deferred script; the library core still loads nothing.

### Verified

- M4 optional interaction tests: 162 passed, 0 failed, exit code 0.
- M3 form/data-display tests still pass: 203 passed, 0 failed, exit code 0.
- M2 component tests still pass: 135 passed, 0 failed, exit code 0.
- M1 foundation tests still pass: 35 passed, 0 failed, exit code 0.
- M0 proof of concept still passes: 28 passed, 0 failed, exit code 0.
- Gallery: 33 unique ids, 12 labels with no broken `for` targets, Bootstrap/HTMX/Alpine loaded and no
  console errors.
- Alpine: panel hidden at initialization and opened by the toggle; counter updates to 1.
- Bootstrap modal opens and closes; toast dismisses.
- Theme switcher: Dark loads `?theme=dark` with Dark active; Auto removes the theme attribute.
- HTMX helper form POSTs and swaps escaped content; the M0 ping/POST/outerHTML baseline still passes.

### Not included (later milestone)

- Pakai Server adapter/examples, first consumer integration (`pakai-asadi`), compatibility matrix,
  migration/versioning policy and release (M5).

## 0.13.0 (unreleased) — M3: forms and data display

### Added

- `PUI.Input` (`PUIInputOptions`): label association, safe id derivation, escaped value/placeholder,
  input types, sizes, help text, error text, required/disabled/read-only and hidden states.
- `PUI.Textarea` (`PUITextareaOptions`): rows with clamping, escaped text content and the same field
  group, validation and accessibility behavior as `Input`.
- `PUI.SelectField` (`PUISelectOptions` + `PUISelectItem`): placeholder option, value fallback to text,
  single-value selection, multiple selection with per-item flags, disabled options and sizes. Named
  `SelectField` because `Select` is a reserved B4X keyword.
- `PUI.Checkbox` (`PUICheckboxOptions`) and `PUI.Radio` (`PUIRadioOptions`): inline and switch variants,
  explicit checked state, labels, help/error text, and name+value-derived ids so choices in one group
  stay unique.
- Server-rendered validation feedback on every field group: `HelpText`, `ErrorText`, `is-invalid`,
  `aria-invalid` and `aria-describedby`; visible without JavaScript.
- `PUI.Table` (`PUITableOptions` + `PUITableColumn`): responsive wrapper by default, striped/hover/
  bordered/compact variants, caption, alignment, empty state and optional row ids. Rows are
  `List`-of-`Map`; values are converted to text and escaped.
- `PUI.Pagination` (`PUIPaginationOptions`): pattern-based links, first/last pages, five-page window,
  ellipsis gaps, disabled Previous/Next, clamping and URL validation.
- `PUI.FilterBar` (`PUIFilterBarOptions`): accessible search form shell with validated action and
  `get`/`post` methods.
- Option factories: `NewInputOptions`, `NewTextareaOptions`, `NewSelectItem`, `NewSelectOptions`,
  `NewCheckboxOptions`, `NewRadioOptions`, `NewTableColumn`, `NewTableOptions`, `NewTableRow`,
  `NewPaginationOptions` and `NewFilterBarOptions`.
- `PUI.AlignStart`, `PUI.AlignCenter` and `PUI.AlignEnd` alignment constants.
- `tests/m3-forms` console test project: 203 assertions covering markup, escaping, ids, validation,
  accessibility, tables, pagination and composition.
- `docs/M3-FORMS.md` form and data-display reference.
- The gallery now demonstrates a filter form, field groups, validation, checkbox/radio choices, a
  responsive table and pagination.

### Changed

- `PUI.VERSION` and `manifest.txt` version bumped to 0.13.
- `PUI.Input` / `Textarea` / `SelectField` / `Checkbox` / `Radio` treat `Id` as the control id and apply
  `CssClass`/`Hidden` to the field-group root; this differs from components whose root is the control.

### Verified

- M3 form and data-display tests: 203 passed, 0 failed, exit code 0.
- M2 component tests still pass: 135 passed, 0 failed, exit code 0.
- M1 foundation tests still pass: 35 passed, 0 failed, exit code 0.
- M0 proof of concept still passes: 28 passed, 0 failed, exit code 0.
- Gallery: all M3 components render, 11 labels resolve to controls, 23 element ids are unique, the
  invalid feedback is visible, the table computes `overflow-x: auto`, dark theme works and the browser
  console is clean.

### Not included (later milestones)

- HTMX/Alpine helpers, dialogs, toasts, theme switcher, sidebar interactions (M4).
- Pakai Server adapter, compatibility matrix, release (M5).
- Table sorting; layer it around `PUI.Table` rather than adding a JavaScript dependency.

## 0.12.0 (unreleased) — M2: core components

### Added

- `PUI.Badge` (`PUIBadgeOptions`): `text-bg-*` variants, optional pill, escaped text, id/class/hidden.
- `PUI.Alert` (`PUIAlertOptions`): contextual `alert-*` variants, optional title and message,
  `role="alert"`, and an optional Bootstrap dismissible close button.
- `PUI.Breadcrumb` (`PUIBreadcrumbOptions` + `PUIBreadcrumbItem`): ordered breadcrumb list, escaped
  links, and a non-navigable active item with `aria-current="page"`.
- `PUI.PageHeader` (`PUIPageHeaderOptions`): bordered page title block with an optional subtitle.
- `PUI.Nav` (`PUINavOptions`), `PUI.NavItem` (`PUINavItemOptions`) and `PUI.Navbar`
  (`PUINavbarOptions`): pills/tabs/vertical lists, active and disabled states, safe URLs, and a
  JavaScript-free navbar that wraps instead of collapsing.
- `PUI.EmptyState` (`PUIEmptyStateOptions`): icon, title, message and optional action button.
- `PUI.LoadingState` (`PUILoadingStateOptions`): accessible `role="status"` spinner with optional
  visible text and centered layout.
- Card extensions: `HeaderText`, `ImageSrc`, `ImageAlt` and `Hidden`. Image URLs are validated and
  unsafe values are omitted with a log message.
- Option factories: `NewBadgeOptions`, `NewAlertOptions`, `NewBreadcrumbItem`, `NewBreadcrumbOptions`,
  `NewPageHeaderOptions`, `NewNavItemOptions`, `NewNavOptions`, `NewNavbarOptions`,
  `NewEmptyStateOptions` and `NewLoadingStateOptions`.
- `tests/m2-components` console test project: 135 assertions covering markup, escaping, defaults,
  invalid input, accessibility attributes and composition.
- `docs/M2-COMPONENTS.md` component reference (options, markup, accessibility, dependencies).
- The gallery now demonstrates badges, alerts, breadcrumbs, page headers, navigation and the
  empty/loading states.

### Changed

- `PUI.VERSION` and `manifest.txt` version bumped to 0.12.
- `PUICardOptions` gained fields at the end; existing field assignments remain compatible and the new
  fields default to empty or `False`.

### Verified

- M2 component tests: 135 passed, 0 failed, exit code 0.
- M1 foundation tests still pass: 35 passed, 0 failed, exit code 0.
- M0 proof of concept still passes: 28 passed, 0 failed, exit code 0.
- Gallery: all M2 components render, assets load, the browser console is clean, and the dismissible
  alert is removed by Bootstrap's JavaScript.
- Navbar items wrap on narrow containers instead of overflowing, with no JavaScript dependency.

### Not included (later milestones)

- Forms, validation, tables, pagination, filter controls (M3).
- HTMX/Alpine helpers, dialogs, toasts, theme switcher, sidebar interactions (M4).
- Pakai Server adapter, compatibility matrix, release (M5).

## 0.11.0 (unreleased) — M1: foundation and demo

### Added

- Theme constants `PUI.ThemeAuto`, `PUI.ThemeLight`, `PUI.ThemeDark` and `PUIPageOptions.Theme`, rendered as
  `data-bs-theme` on the document root.
- `PUI.Document`, `PUI.Head`, `PUI.Body`, `PUI.StyleSheet`, `PUI.MetaDescription` and `PUI.Script` for a
  complete HTML5 document skeleton (doctype is emitted by MiniHTML for the `html` root).
- `PUI.Container`, `PUI.Row` and `PUI.Col` page-layout primitives with fluid/breakpoint/width/auto/hidden
  options.
- `PUI.NewPageOptions`, `NewContainerOptions`, `NewRowOptions` and `NewColOptions` factories.
- Tracked, versioned `assets/` folder: Bootstrap 5.3.8, Bootstrap Icons 1.13.1, HTMX 2.0.8 and the
  `pakaiui.css` token alias layer, with `assets/README.md` (versions + SHA-256 hashes) and `assets/res.json`.
- `sync-assets.bat` to copy tracked assets into a consuming project's `Objects\www\assets` (additive).
- `tests/m1-foundation` console test project: 35 assertions covering the document skeleton, theme
  normalization, head helpers and the layout primitives.
- `gallery/` standalone jServer demo (plain jServer, no Pakai Server) that hosts the HTMX 2.x baseline
  fixture and the component gallery.

### Changed

- `PUI.VERSION` and `manifest.txt` version bumped to 0.11.
- The command-line builder does not surface IDE warning numbers; the warning audit remains by pattern.

### Verified

- M1 foundation tests: 35 passed, 0 failed, exit code 0.
- M0 proof of concept still passes after the M1 additions: 28 passed, 0 failed, exit code 0.
- HTMX 2.0.8 passes the baseline test against PakaiUI 0.11 (GET/POST, innerHTML/outerHTML, 204, no
  Alpine.js); result recorded in `docs/M0-RECONNAISSANCE.md` section 9.
- Dark theme renders `data-bs-theme="dark"`; light and auto themes verified.

### Not included (later milestones)

- Badge, Alert, Breadcrumb, navigation, empty/loading states (M2).
- Forms, validation, tables, pagination (M3).
- HTMX/Alpine helpers, dialogs, toasts, theme switcher (M4).
- Pakai Server adapter, compatibility matrix, release (M5).

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
