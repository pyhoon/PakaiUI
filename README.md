# PakaiUI

A reusable, server-rendered UI component library for B4J web applications, built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3.

PakaiUI is distributed as a `.b4xlib`, produces plain HTML, and works without Pakai Server. HTMX 2.x and
Alpine.js are optional enhancements, never requirements.

## Status

**v0.10 — M0 complete (experimental API).**

M0 delivered the verified MiniHTML4 reconnaissance, the escaping/composition contract, and a compiled
proof of concept. The component catalogue is intentionally limited to `Button` and `Card`; further
components belong to later milestones. See [`docs/M0-RECONNAISSANCE.md`](docs/M0-RECONNAISSANCE.md).

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

Text and attribute values are escaped by default. Raw HTML must be explicit:

```b4j
body1.down(PUI.RawHtml("<strong>trusted markup</strong>"))
PUI.AddText(body1, "<script>this is escaped</script>")
```

## Repository layout

```
source/                      PakaiUI library project (PUI.bas, manifest, b4xlib build script)
tests/m0-poc/                Console proof of concept consuming the installed b4xlib
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
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\PakaiUI.jar

# Package and install the library
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force

# M0 proof of concept (expects 28/28 PASS and exit code 0)
cd ..\tests\m0-poc
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M0PoC.b4j" -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M0PoC.jar
```

See [`AGENT.md`](AGENT.md) for the full command reference and the B4J/ MiniHTML pitfalls that must be
respected.

## License

MIT — see [`LICENSE`](LICENSE).
