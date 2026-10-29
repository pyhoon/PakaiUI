# PakaiUI

A reusable, server-rendered UI component library for B4J web applications, built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3.

PakaiUI is distributed as a `.b4xlib`, produces plain HTML, and works without Pakai Server. HTMX 2.x and
Alpine.js are optional enhancements, never requirements.

## Status

**v0.11 — M1 in progress (experimental API).**

M0 delivered the verified MiniHTML4 reconnaissance, the escaping/composition contract, and a compiled
proof of concept. M1 adds theme tokens (light/dark via `data-bs-theme`), a document skeleton
(`PUI.Document` / `Head` / `Body`) and page-layout primitives (`PUI.Container`, `PUI.Row`,
`PUI.Col`), plus a tracked `assets/` folder and a standalone gallery demo. The component catalogue
is still `Button` and `Card`; further components belong to later milestones. See
[`docs/M0-RECONNAISSANCE.md`](docs/M0-RECONNAISSANCE.md).

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
' Button
Dim buttonOptions As PUIButtonOptions = PUI.NewButtonOptions("Save")
buttonOptions.Variant = PUI.VariantPrimary
buttonOptions.ButtonType = "submit"
body1.down(PUI.Button(buttonOptions))

' Link-style button
Dim linkOptions As PUIButtonOptions = PUI.NewButtonOptions("Documentation")
linkOptions.Href = "https://example.com/docs"
linkOptions.Variant = PUI.VariantOutlineSecondary
body1.down(PUI.Button(linkOptions))

' Card with escaped text, then compose content into its body slot
Dim cardOptions As PUICardOptions = PUI.NewCardOptions("Welcome", "Body text")
Dim card1 As MiniHtml = PUI.Card(cardOptions)
card1.ChildByClass("card-body").down(PUI.Button(buttonOptions))
body1.down(card1)
```

' Page skeleton with a dark theme and a container/row/column grid
Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("My app")
pageOptions.Theme = PUI.ThemeDark
Dim page As MiniHtml = PUI.Document(pageOptions)
Dim head1 As MiniHtml = PUI.Head(page)
PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
Dim body1 As MiniHtml = PUI.Body(page)
Dim container1 As MiniHtml = PUI.Container(Null)
container1.up(body1)
Dim grid1 As MiniHtml = PUI.Row(Null)
grid1.up(container1)
Dim col1 As PUIColOptions = PUI.NewColOptions
col1.Breakpoint = "md"
col1.Width = 6
PUI.Col(col1).up(grid1).down(PUI.Card(PUI.NewCardOptions("Left", "Content")))
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
gallery/                     Standalone jServer demo and HTMX 2.x baseline host
docs/                        M0 findings, technical specification, API proposal, design considerations
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

# Standalone gallery (HTMX baseline host) on http://localhost:51010/
cd ..\..\gallery
cmd /c ..\sync-assets.bat .
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="Gallery.b4j" -NoClean=True -ShowWarnings=True
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Gallery.jar
```

See [`AGENT.md`](AGENT.md) for the full command reference and the B4J/ MiniHTML pitfalls that must be
respected.

## License

MIT — see [`LICENSE`](LICENSE).
