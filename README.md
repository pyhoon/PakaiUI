# PakaiUI

A reusable, server-rendered UI component library for B4J web applications, built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3.

PakaiUI is distributed as a `.b4xlib`, produces plain HTML, and works without Pakai Server. HTMX 2.x and
Alpine.js are optional enhancements, never requirements.

## Status

**v0.15 — M5 complete, release readiness (experimental API).**

M0 delivered the verified MiniHTML4 reconnaissance, the escaping/composition contract and a compiled
proof of concept. M1 added theme tokens (light/dark via `data-bs-theme`), the document skeleton
(`PUI.Document` / `Head` / `Body`), page-layout primitives (`PUI.Container`, `PUI.Row`, `PUI.Col`), the
tracked `assets/` folder, the asset sync script and the standalone gallery. M2 added the core component
set: `Badge`, `Alert`, `Breadcrumb`, `PageHeader`, `Nav` / `NavItem` / `Navbar`, `EmptyState`,
`LoadingState` and card extensions. M3 added form and data-display components: `Input`, `Textarea`,
`SelectField`, `Checkbox`, `Radio`, validation feedback, `Table`, `Pagination` and `FilterBar`. M4 added
optional interactions: typed `Htmx` and `Alpine` attribute helpers, `Modal` / `ModalTrigger`, `Toast`,
`ThemeSwitcher` and `Sidebar`. M5 adds the verified Pakai Server/EndsMeet example, the complete API
reference, the compatibility matrix and the versioning/migration/release policy. None of it makes HTMX,
Alpine.js or Pakai Server a core dependency. See [`docs/API-REFERENCE.md`](docs/API-REFERENCE.md),
[`docs/COMPATIBILITY.md`](docs/COMPATIBILITY.md), [`docs/VERSIONING.md`](docs/VERSIONING.md),
[`docs/PAKAI-SERVER-INTEGRATION.md`](docs/PAKAI-SERVER-INTEGRATION.md) and the milestone references
[`M2`](docs/M2-COMPONENTS.md), [`M3`](docs/M3-FORMS.md), [`M4`](docs/M4-INTERACTIONS.md).

## Requirements

| Component | Version |
| --- | --- |
| B4J | 10.7 |
| Java | 19 (build/run) |
| MiniHTML | 4.02 (`MiniHTML.b4xlib`) |
| Bootstrap | 5.3.8 (for the rendered markup) |
| HTMX | 2.0.8 (optional) |
| Alpine.js | 3.15.8 (optional, not required) |
| EndsMeet | 4.03 (optional Pakai Server-style example host) |

PakaiUI core does not depend on Pakai Server, MiniJS, MiniCSS, HTMX or Alpine.js.

## Installation

Download `PakaiUI.b4xlib` from the [latest release](https://github.com/pyhoon/PakaiUI/releases/latest), copy it
into `C:\B4X\Additional\B4J`, and restart B4J. Tick **PakaiUI** in the host project's libraries; B4J resolves
MiniHTML 4.02 from the library manifest.

Then sync the tracked frontend assets into the host project's web root:

```powershell
cmd /c sync-assets.bat <project-folder>
```

Run the script from a repository checkout or unpacked source archive; it resolves `assets\` relative to
itself. The copy is additive: Bootstrap, Bootstrap Icons, HTMX, Alpine.js, `pakaiui.css` and
`pakaiui-asadi.css` go into `<project-folder>\Objects\www\assets`, and files already present there are left
alone. Link the versioned stylesheets from the page as shown below.

## Usage

```b4j
' Page skeleton with a dark theme
Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("My app")
pageOptions.Theme = PUI.ThemeDark
Dim page As MiniHtml = PUI.Document(pageOptions)
Dim head1 As MiniHtml = PUI.Head(page)
PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
Dim body1 As MiniHtml = PUI.Body(page)

' Page header and breadcrumb
body1.down(PUI.PageHeader(PUI.NewPageHeaderOptions("Dashboard")))
Dim crumbOptions As PUIBreadcrumbOptions = PUI.NewBreadcrumbOptions
crumbOptions.Items.Add(PUI.NewBreadcrumbItem("Home", "/"))
Dim currentCrumb As PUIBreadcrumbItem = PUI.NewBreadcrumbItem("Dashboard", "")
currentCrumb.Active = True
crumbOptions.Items.Add(currentCrumb)
body1.down(PUI.Breadcrumb(crumbOptions))

' Badge and alert
Dim badgeOptions As PUIBadgeOptions = PUI.NewBadgeOptions("New")
badgeOptions.Variant = PUI.VariantSuccess
body1.down(PUI.Badge(badgeOptions))

Dim alertOptions As PUIAlertOptions = PUI.NewAlertOptions("Changes saved.")
alertOptions.Title = "Saved"
alertOptions.Variant = PUI.VariantSuccess
alertOptions.Dismissible = True
body1.down(PUI.Alert(alertOptions))

' Button, then a card with escaped text and composed content
Dim buttonOptions As PUIButtonOptions = PUI.NewButtonOptions("Save")
buttonOptions.ButtonType = "submit"
Dim cardOptions As PUICardOptions = PUI.NewCardOptions("Welcome", "Body text")
Dim card1 As MiniHtml = PUI.Card(cardOptions)
card1.ChildByClass("card-body").down(PUI.Button(buttonOptions))
body1.down(card1)

' Empty and loading states
body1.down(PUI.EmptyState(PUI.NewEmptyStateOptions("No records", "Create one to get started.")))
body1.down(PUI.LoadingState(PUI.NewLoadingStateOptions("Loading...")))

' Form fields: labels, help text and server-rendered validation feedback
Dim emailOptions As PUIInputOptions = PUI.NewInputOptions("Email", "email")
emailOptions.InputType = "email"
emailOptions.HelpText = "Never shown publicly."
body1.down(PUI.Input(emailOptions))

Dim planOptions As PUISelectOptions = PUI.NewSelectOptions("Plan", "plan")
planOptions.Placeholder = "Choose a plan"
planOptions.Items.Add(PUI.NewSelectItem("Starter", "starter"))
planOptions.Items.Add(PUI.NewSelectItem("Pro", "pro"))
body1.down(PUI.SelectField(planOptions))

' Responsive table from column definitions and List-of-Map rows
Dim tableOptions As PUITableOptions = PUI.NewTableOptions
tableOptions.Striped = True
tableOptions.Columns.Add(PUI.NewTableColumn("Name", "name"))
tableOptions.Columns.Add(PUI.NewTableColumn("Plan", "plan"))
Dim row1 As Map = PUI.NewTableRow
row1.Put("name", "Aeric")
row1.Put("plan", "Pro")
tableOptions.Rows.Add(row1)
body1.down(PUI.Table(tableOptions))

Dim pagerOptions As PUIPaginationOptions = PUI.NewPaginationOptions(1, 5, "/?page={page}")
body1.down(PUI.Pagination(pagerOptions))

' Optional interactions: helpers emit attributes, scripts load separately
Dim pingOptions As PUIButtonOptions = PUI.NewButtonOptions("Ping")
Dim pingButton As MiniHtml = PUI.Button(pingOptions)
Dim htmxOptions As PUIHtmxOptions = PUI.NewHtmxOptions("/ping")
htmxOptions.Target = "#result"
PUI.Htmx(pingButton, htmxOptions).up(body1)

Dim localState As PUIAlpineOptions = PUI.NewAlpineOptions
localState.Data = "{ open: false }"
PUI.Alpine(card1, localState)

Dim dialogOptions As PUIModalOptions = PUI.NewModalOptions("Confirm", "Continue?")
dialogOptions.Id = "confirm-dialog"
PUI.Modal(dialogOptions).up(body1)
PUI.ModalTrigger(PUI.NewModalTriggerOptions("Open", "confirm-dialog")).up(body1)

Dim themeOptions As PUIThemeSwitcherOptions = PUI.NewThemeSwitcherOptions(PUI.ThemeDark)
PUI.ThemeSwitcher(themeOptions).up(body1)
```

`PUI.Select` is named `PUI.SelectField` because `Select` is a reserved B4X keyword. Form controls return
complete field groups: `Id` identifies the control (for the label), while `CssClass` and `Hidden` apply to
the group.

Text and attribute values are escaped by default. Raw HTML must be explicit:

```b4j
body1.down(PUI.RawHtml("<strong>trusted markup</strong>"))
PUI.AddText(body1, "<script>this is escaped</script>")
```

## Demos

- `demo/` — Asadi-style dashboard on `http://localhost:51030/`, using PUI components plus the optional
  `pakaiui-asadi.css` theme layer. Server-rendered, no JavaScript.
- `gallery/` — full component gallery and HTMX baseline on `http://localhost:51010/`.
- `examples/pakai-server/` — Pakai Server/EndsMeet host on `http://localhost:51020/`.

## Repository layout

```
source/                      PakaiUI library project (PUI.bas, manifest, b4xlib build script)
assets/                      Tracked frontend assets (Bootstrap 5.3.8, icons, HTMX 2.0.8, Alpine 3.15.8, pakaiui.css, Asadi theme)
sync-assets.bat              Copies assets/ into <project>\Objects\www\assets (additive)
tests/m0-poc/                Console proof of concept consuming the installed b4xlib
tests/m1-foundation/         M1 foundation API tests (35 assertions)
tests/m2-components/         M2 core component tests (135 assertions)
tests/m3-forms/              M3 form and data-display tests (203 assertions)
tests/m4-interactions/       M4 optional interaction tests (162 assertions)
gallery/                     Standalone jServer demo and HTMX 2.x baseline host
examples/pakai-server/       Pakai Server/EndsMeet host example (optional integration)
docs/                        M0 findings, M2-M4 references, API, compatibility, versioning, integration
demo/                        Asadi-style standalone demo using the optional theme layer
AGENT.md                     Build/test commands and contribution rules
CHANGELOG.md                 Version history and breaking changes
```

## Build and test

Run B4JBuilder from the project folder (it resolves `-Project` against the current directory).

```powershell
# Library smoke test
cd source
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\PakaiUI.jar

# Package and install the library
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force

# M0 proof of concept (expects 28/28 PASS and exit code 0)
cd ..\tests\m0-poc
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M0PoC.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M0PoC.jar

# M1 foundation tests (expects 35/35 PASS and exit code 0)
cd ..\m1-foundation
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M1Foundation.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M1Foundation.jar

# M2 component tests (expects 135/135 PASS and exit code 0)
cd ..\m2-components
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M2Components.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M2Components.jar

# M3 form and data-display tests (expects 203/203 PASS and exit code 0)
cd ..\m3-forms
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M3Forms.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M3Forms.jar

# M4 optional interaction tests (expects 162/162 PASS and exit code 0)
cd ..\m4-interactions
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M4Interactions.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M4Interactions.jar

# Standalone gallery (HTMX baseline + M2/M3/M4 components) on http://localhost:51010/
cd ..\..\gallery
cmd /c ..\sync-assets.bat .
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="Gallery.b4j" -NoClean=True -ShowWarnings=True
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Gallery.jar

# Optional Pakai Server / EndsMeet example on http://localhost:51020/
cd ..\..\examples\pakai-server
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiServerExample.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiServerExample.jar

# Asadi-style demo on http://localhost:51030/
cd ..\..\..\demo
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiDemo.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiDemo.jar
```

See [`AGENT.md`](AGENT.md) for the full command reference and the B4J/MiniHTML pitfalls that must be
respected.

## License

MIT — see [`LICENSE`](LICENSE).
