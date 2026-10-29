# PakaiUI

A reusable, server-rendered UI component library for B4J web applications, built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3.

PakaiUI is distributed as a `.b4xlib`, produces plain HTML, and works without Pakai Server. HTMX 2.x and
Alpine.js are optional enhancements, never requirements.

## Status

**v0.12 — M2 complete (experimental API).**

M0 delivered the verified MiniHTML4 reconnaissance, the escaping/composition contract and a compiled
proof of concept. M1 added theme tokens (light/dark via `data-bs-theme`), the document skeleton
(`PUI.Document` / `Head` / `Body`), page-layout primitives (`PUI.Container`, `PUI.Row`, `PUI.Col`), the
tracked `assets/` folder, the asset sync script and the standalone gallery. M2 adds the core component
set: `Badge`, `Alert`, `Breadcrumb`, `PageHeader`, `Nav` / `NavItem` / `Navbar`, `EmptyState`,
`LoadingState` and card extensions (header, image, hidden). See
[`docs/M2-COMPONENTS.md`](docs/M2-COMPONENTS.md) for the component reference and
[`docs/M0-RECONNAISSANCE.md`](docs/M0-RECONNAISSANCE.md) for the verified MiniHTML behaviour.

## Requirements

| Component | Version |
| --- | --- |
| B4J | 10.7 |
| Java | 19 (build/run) |
| MiniHTML | 4.02 (`MiniHTML.b4xlib`) |
| Bootstrap | 5.3.8 (for the rendered markup) |
| HTMX | 2.0.8 (optional) |
| Alpine.js | 3.15.8 (optional, not required) |

PakaiUI core does not depend on Pakai Server, MiniJS, MiniCSS, HTMX or Alpine.js.

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
```

Text and attribute values are escaped by default. Raw HTML must be explicit:

```b4j
body1.down(PUI.RawHtml("<strong>trusted markup</strong>"))
PUI.AddText(body1, "<script>this is escaped</script>")
```

## Repository layout

```
source/                      PakaiUI library project (PUI.bas, manifest, b4xlib build script)
assets/                      Tracked frontend assets (Bootstrap 5.3.8, icons, HTMX 2.0.8, pakaiui.css)
sync-assets.bat              Copies assets/ into <project>\Objects\www\assets (additive)
tests/m0-poc/                Console proof of concept consuming the installed b4xlib
tests/m1-foundation/         M1 foundation API tests (35 assertions)
tests/m2-components/         M2 core component tests (135 assertions)
gallery/                     Standalone jServer demo and HTMX 2.x baseline host
docs/                        M0 findings, M2 component reference, specification and API inputs
demo/                        Pakai Server Web starter kept for reference
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

# Standalone gallery (HTMX baseline + M2 components) on http://localhost:51010/
cd ..\..\gallery
cmd /c ..\sync-assets.bat .
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="Gallery.b4j" -NoClean=True -ShowWarnings=True
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Gallery.jar
```

See [`AGENT.md`](AGENT.md) for the full command reference and the B4J/MiniHTML pitfalls that must be
respected.

## License

MIT — see [`LICENSE`](LICENSE).
