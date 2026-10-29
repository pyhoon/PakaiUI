# AGENT.md

Instructions for AI agents and contributors working in this repository.

## 1. What this project is

**PakaiUI** is a reusable, server-rendered UI component library for B4J web applications. It is built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3, distributed as a `.b4xlib`, and
works without Pakai Server. HTMX 2.x and Alpine.js are optional enhancements only.

| Item | Value |
| --- | --- |
| Library version | `0.15` (experimental; public API may change) |
| Current milestone | **M5 complete** - Pakai Server example, API reference, compatibility matrix, versioning/release policy |
| B4J | 10.7 (`C:\Program Files\B4X\B4J`) |
| JDK used for builds/runs | 19 (`C:\Java\jdk-19.0.2`) |
| HTML foundation | MiniHTML 4.02 (`C:\B4X\Additional\B4X\MiniHTML.b4xlib`) |
| CSS baseline | Bootstrap 5.3.8 |
| Optional JS | HTMX 2.0.8, Alpine.js 3.15.8 |
| License | MIT (`LICENSE`) |

Read `docs/M0-RECONNAISSANCE.md` before changing the API or the rendering contract. It records the
verified MiniHTML behaviour and the decisions that follow from it.

## 2. Ground truth and repository layout

```
AGENT.md                     This file (agent/contributor instructions)
README.md                    Project overview and quick start
CHANGELOG.md                 Release history (0.x, breaking changes documented)
docs/M0-RECONNAISSANCE.md    Verified findings, API inventory, M0 evidence
docs/M2-COMPONENTS.md        M2 component reference: options, markup, accessibility, dependencies
docs/M3-FORMS.md             M3 form and data-display reference: options, markup, accessibility, verification
docs/M4-INTERACTIONS.md      M4 optional interaction reference: behavior owners, options, security, verification
docs/API-REFERENCE.md        Complete public API, option types and constants
docs/COMPATIBILITY.md        Verified versions, evidence, constraints
docs/VERSIONING.md           Versioning, migration, deprecation and release policy
docs/PAKAI-SERVER-INTEGRATION.md  EndsMeet/Pakai Server host model, example and production notes
docs/PakaiUI-*.md            Design inputs: specification, API proposal, considerations (read-only)
assets/                      Tracked frontend assets (Bootstrap 5.3.8, icons, HTMX 2.0.8, Alpine 3.15.8, pakaiui.css, Asadi theme)
  README.md                  Versions, SHA-256 hashes, serving and upgrade notes
  res.json                   Pakai-style manifest of upstream sources
sync-assets.bat              Copies assets/ into <project>\Objects\www\assets (additive)
source/                      PakaiUI library B4J project
  PUI.bas                    Public facade: options types, components, escaping, page primitives
  PakaiUI.b4j                Library project (smoke-test AppStart)
  manifest.txt               b4xlib manifest (version + dependencies)
  libs.json                  External library pin (MiniHTML 4.02)
  build_b4xlib.bat           Packages Objects\PakaiUI.b4xlib with jar.exe
tests/m0-poc/                Console proof of concept (consumes the installed b4xlib)
tests/m1-foundation/         M1 foundation API tests (35 assertions)
tests/m2-components/         M2 core component tests (135 assertions)
tests/m3-forms/              M3 form and data-display tests (203 assertions)
tests/m4-interactions/       M4 optional interaction tests (162 assertions)
gallery/                     Standalone jServer demo (plain jServer, no Pakai Server) + HTMX baseline
examples/pakai-server/       Optional Pakai Server/EndsMeet host example (not packaged)
demo/                        Asadi-style standalone demo using the optional theme layer
```

- `docs/PakaiUI-Technical-Specification.md`, `docs/PakaiUI-Initial-Public-API.md` and
  `docs/PakaiUI-Consideration-Before-Started.md` are the design inputs. Treat them as **design input**,
  not as a description of what is implemented.
- `demo/` is a standalone Asadi-style demo. It is built and tested, but is not packaged into
  `PakaiUI.b4xlib` and must not create a framework dependency in `source/`.
- `C:\Projects\pakai-asadi` is a separate Pakai Server application and the first planned integration
  consumer (M5). It is not part of this repository: do not add it as a dependency or copy its code into the
  core.
- Do not rewrite the design-input documents. Record verified facts in `docs/M0-RECONNAISSANCE.md`.
  Do not add Pakai Server, MiniJS or MiniCSS as core dependencies.

## 3. Build, package and test commands (verified)

B4JBuilder resolves `-Project` against the **current directory** (its `-BaseFolder` argument has an open
issue upstream), so always run it from the project folder. If the folder contains exactly one `.b4j` file,
`-Project` can be omitted and the builder selects it. Running `B4JBuilder.exe` with no arguments prints its
supported parameters; v10.70 reports `-Task` (`Build` default, `BuildLibrary`), `-BaseFolder`, `-Project`,
`-Obfuscate`, `-ShowWarnings`, `-Configuration`, `-NoClean` and `-Output`.

Use `-NoClean=True` when a project has user-managed runtime files under `Objects/` (SQLite databases, local
configuration). Never delete or overwrite those as part of a build. Preserve the builder output and exit
status; a build is successful only if the process exits successfully.

The `java` on `PATH` is Java 8 and cannot load the Java 19 class files produced by the builder. Always run
jars with `C:\Java\jdk-19.0.2\bin\java.exe` (or the B4J IDE's Run command).

The command-line builder does **not** print the B4J IDE's warning numbers, even with `-ShowWarnings=True`:
a deliberately bad `Object` comparison still builds silently. `-ShowWarnings=True` is therefore not proof
that warnings are absent. Audit the warning rules in section 5 by pattern, and use the IDE when available.

Builder reference: [B4ABuilder / B4JBuilder command-line compilation](https://www.b4x.com/android/forum/threads/b4abuilder-b4jbuilder-command-line-compilation.50154/).

### Compile and run the library smoke test

```powershell
cd C:\Projects\PakaiUI\source
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\PakaiUI.jar
```

Expected: `Completed successfully` and one rendered `<button>` line. Warning compliance is audited
manually, not inferred from this output.

### Package and install the `.b4xlib`

```powershell
cd C:\Projects\PakaiUI\source
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force
```

`build_b4xlib.bat` creates a zip containing `PUI.bas`, `manifest.txt` and `LICENSE` (the same layout
MiniHTML uses). Use `%JAVABIN%` to override the JDK path.

### Build and run the M0 proof of concept

```powershell
cd C:\Projects\PakaiUI\tests\m0-poc
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M0PoC.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M0PoC.jar
```

Expected: 28 `PASS` lines, `M0 PoC: 28 passed, 0 failed`, exit code 0. The rendered page is written to
`File.DirApp`: `Objects\m0-output.html` when run from the B4J IDE, or the current directory when the jar is
launched from a terminal. The `PakaiUI: rejected unsafe button URL` line is an expected stderr message from
the negative URL test.

### Sync tracked frontend assets

```powershell
cd C:\Projects\PakaiUI
cmd /c sync-assets.bat gallery        # -> gallery\Objects\www\assets
cmd /c sync-assets.bat demo          # -> demo\Objects\www\assets (additive)
```

`sync-assets.bat` copies (never deletes) tracked files from `assets/` into
`<target>\Objects\www\assets`. Run it again after upgrading tracked assets; project-owned
files such as `main.css`, `app.js` and images are left in place.

### Build and run the M1 foundation tests

```powershell
cd C:\Projects\PakaiUI\tests\m1-foundation
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M1Foundation.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M1Foundation.jar
```

Expected: 35 `PASS` lines, `M1 tests: 35 passed, 0 failed`, exit code 0. The sample page is written to
`File.DirApp\m1-output.html`.

### Build and run the M2 component tests

```powershell
cd C:\Projects\PakaiUI\tests\m2-components
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M2Components.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M2Components.jar
```

Expected: 135 `PASS` lines, `M2 tests: 135 passed, 0 failed`, exit code 0. The sample page is written to
`File.DirApp\m2-output.html`. The `PakaiUI: rejected unsafe ...` and `unknown ... variant` lines are
expected stderr messages from the negative tests.

### Build and run the M3 form and data-display tests

```powershell
cd C:\Projects\PakaiUI\tests\m3-forms
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M3Forms.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M3Forms.jar
```

Expected: 203 `PASS` lines, `M3 tests: 203 passed, 0 failed`, exit code 0. The sample page is written to
`File.DirApp\m3-output.html`. Lines about rejected pagination URLs, unsupported input types/methods,
clamped rows and missing `{page}` patterns are expected from the negative tests.

### Build and run the M4 optional interaction tests

```powershell
cd C:\Projects\PakaiUI\tests\m4-interactions
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="M4Interactions.b4j" -NoClean=True -ShowWarnings=True
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Objects\M4Interactions.jar
```

Expected: 162 `PASS` lines, `M4 tests: 162 passed, 0 failed`, exit code 0. The sample page is written to
`File.DirApp\m4-output.html`. Rejected HTMX/button/sidebar URLs, missing targets, unsupported
methods/swaps, unknown modal sizes, toast variants and themes produce expected log lines from the
negative tests.

### Build and run the standalone gallery (HTMX baseline host)

```powershell
cd C:\Projects\PakaiUI\gallery
cmd /c ..\sync-assets.bat .
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="Gallery.b4j" -NoClean=True -ShowWarnings=True
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar Gallery.jar        # DirApp = Objects, so www is served
```

The server listens on `http://localhost:51010/`. The gallery exercises the HTMX 2.x baseline
fixture defined in `docs/M0-RECONNAISSANCE.md` section 9 plus the M2 component set (badges, alerts,
breadcrumb, page header, nav, navbar, empty and loading states), the M3 set (form fields, choices,
validation feedback, responsive table and pagination) and the M4 set (HTMX/Alpine helpers, modal, toast,
theme switcher, sidebar); the verified results are recorded there, in `docs/M2-COMPONENTS.md`,
`docs/M3-FORMS.md` and `docs/M4-INTERACTIONS.md`.

### Build and run the Pakai Server / EndsMeet example

```powershell
cd C:\Projects\PakaiUI\examples\pakai-server
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiServerExample.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiServerExample.jar
```

Expected: build exit code 0 and `EndsMeet server (version = 4.03) is running on port 51020`. Open
`http://localhost:51020/`; `POST /submit` renders the escaped form value. This project is an example only
and is not packaged into `PakaiUI.b4xlib`; see `docs/PAKAI-SERVER-INTEGRATION.md`.

### Build and run the Asadi-style demo

```powershell
cd C:\Projects\PakaiUI\demo
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiDemo.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiDemo.jar
```

Expected: `PakaiUI Asadi demo listening on http://localhost:51030/`. The page uses PUI components plus the
opt-in `assets/css/pakaiui-asadi.css` theme layer. It is not packaged into the library.

**Always rebuild the `.b4xlib` and reinstall it before testing a consumer project.** The PoC compiles
`PUI.bas` from the installed library, not from `source/` directly.

### Dependencies

The builder resolves `#AdditionalJar` names from `C:\Program Files\B4X\B4J\libraries`, while `.b4xlib`
libraries are resolved from `C:\B4X\Additional`. Ensure every `libs.json` dependency is installed before
treating a missing-jar build failure as a source error, and keep versions consistent between `libs.json`
and any `#AdditionalJar` declarations.

## 4. Architecture rules (non-negotiable)

1. **No framework dependency in core.** `source/` must not reference EndsMeet/Pakai Server, databases,
   routing, sessions or authentication. Adapters belong in a separate optional layer (M5).
2. **MiniHTML4 is the only HTML builder.** Do not introduce a second element tree, template engine or
   string-concatenation renderer. Components return `MiniHtml`.
3. **Escape by default.** Every text value and every attribute value is escaped at render time.
   Raw HTML is possible only through the explicitly named `PUI.RawHtml` / `PUI.AddHtml`.
4. **Composition over strings.** Use `up` / `down` / `add` (or the card part factories). Never build
   components by concatenating HTML strings.
5. **Optional enhancements stay optional.** Basic output must work without HTMX, Alpine.js, MiniJS,
   MiniCSS or Pakai Server. Do not make them mandatory in `manifest.txt`.
6. **Semantic API.** Prefer `PUI.VariantPrimary` over `"btn btn-primary"`. `CssClass` is an escape hatch,
   not the primary configuration surface.
7. **Public API naming.** The facade is the static module `PUI`; exported option types are prefixed
   (`PUIButtonOptions`, `PUICardOptions`) because B4X types share a global namespace.
8. **Option-type defaults.** B4X booleans default to `False`, so never introduce a `Visible` option that
   defaults to `False`. Use `Hidden` (and similar negative flags). `Type` and `Select` are reserved words,
   hence `InputType` / `ButtonType` and `PUI.SelectField`.
9. **Enhancement helpers only emit attributes.** `PUI.Htmx` and `PUI.Alpine` never load scripts or contain
   inline JavaScript, and no core component requires HTMX, Alpine.js or Bootstrap JavaScript. Document the
   behavior owner and the no-JS fallback for every interactive component.

## 5. B4J IDE code smells to avoid (mandatory review checklist)

These warnings must not be introduced. The command-line builder does not surface them, so audit by
pattern during review (and use the B4J IDE when available).

### 5.1 Never leave an empty `Catch` block (warning #19)

```b4j
Try
	'some code
Catch
	Log(LastException.Message)
End Try
```

Do the same in cleanup helpers such as `CloseQuietly` and defensive `Db.Close` calls: either log
`LastException.Message` or deliberately set a safe fallback value.

### 5.2 Put an `Object` on the right side of a comparison (warning #35)

Comparison of `Object` with other types fails when the exact types do not match. Apply this to any
expression typed `As Object` (including `Map.Get`):

```b4j
If 1 = Index.Get("unique") Then UniqueLabel = " · unique"
If False = KeyResult.Get("ok") Then
If 0 < Column.Get("pk") Then
If ColumnName = Column.Get("name") Then
```

Not:

```b4j
If Index.Get("unique") = 1 Then UniqueLabel = " · unique"
```

Comparing a class reference to `Null` (`If options1 = Null Then`) is a null guard, not an
`Object`-versus-value comparison, and is allowed. The same applies to an `Object` value:
`If value = Null Then` is the safe direction; `If Null = value Then` is not, because B4J compiles it to a
call on `Null` and throws a `NullPointerException` at runtime (verified). Keep `Null` on the right for
null guards, and use the `Object`-on-the-right form only for real value comparisons.

### 5.3 No unused variables or subs

Remove unused locals, parameters and private subs. B4J 10.7 reports `unused variable` as warning #9 and
`unused sub` as warning #12; the project rule is the same in both cases: leave no dead identifiers.

## 6. Verified MiniHTML gotchas

These are proven by source inspection and the M0 PoC. Do not "fix" them inside PakaiUI by changing
MiniHTML; handle them in `PUI`.

- `MiniHtml.text` and `MiniHtml.attr` store raw strings. **Nothing is escaped** during `build`.
- Attribute order comes from a B4X `Map`, so it is **not deterministic**. Never assert whole HTML strings;
  parse the output and assert on names, classes and attributes.
- `attr(key, "")` emits a bare boolean attribute. Use `attrIfValue` / `attrIf` for optional values.
- `add` returns the parent; `addChild` / `down` return the child; `up` / `addTo` return the child.
- `text(value, wrap)` also sets the element's indentation flag.
- `build()` output starts with `CRLF` and contains indentation for non-flat tags. Use `setFlat(True)` when
  an exact fragment is required (see `PUI.RawHtml`).
- Parsing preserves entity-escaped attribute and text values; `GetTextFromNode` is what unescapes them.
  Never pass `GetTextFromNode` output to `text()` without escaping.
- The shipped `MH` helper snippet uses `MiniJs` (`MH.Toast`, `MH.CreateCustomEventScript`). PakaiUI must
  not call `MH`; `PUI` only uses the `MiniHtml` class.
- B4X converts `Null` assigned to a `String` into the literal text `"null"`. Normalise application data
  (Map, JSON, database) before assigning it to option fields; PakaiUI cannot tell `"null"` from real text.
- `File.DirApp` is the `Objects` folder when a project runs from the B4J IDE, but the current directory when
  a jar is launched from a terminal. Write runtime output to `File.DirApp`, never to a hard-coded
  `Objects` path.
- The B4J IDE saves project and module files with a UTF-8 BOM and may re-save them on open. BOM-only diffs
  are expected and harmless.

## 7. Testing rules

- Consumer tests go in `tests/` and must consume the **installed** `.b4xlib`, not a copy of `PUI.bas`.
- Assert on parsed elements (`GetName`, `GetAttributes`, `ChildByClass`) and on escaped substrings, not on
  full rendered strings.
- Include negative tests: hostile text, hostile attribute values, rejected URL schemes, disabled state.
- The PoC prints `PASS`/`FAIL` and exits 0/1 (via `JavaObject` → `System.exit`), so it can gate automation.
- Record actual command output in the relevant milestone document; do not claim a test passed without
  captured evidence.

## 8. Milestones

| Milestone | Scope | Status |
| --- | --- | --- |
| M0 | Reconnaissance, verified MiniHTML API, escaping/dependency/asset findings, minimal PoC | **Done** |
| M1 | Foundation, theme tokens, page/container primitives, standalone gallery demo, asset docs | **Done** |
| M2 | Button, Badge, Alert, Card, Breadcrumb, page header, navigation, empty/loading states | **Done** |
| M3 | Forms, validation feedback, tables, pagination, filters | **Done** |
| M4 | Optional HTMX/Alpine interactions (dialogs, toasts, theme switcher) | **Done** |
| M5 | Pakai Server adapter/examples, first consumer integration (`pakai-asadi`), docs, compatibility matrix, release | **Done** (example; `pakai-asadi` not modified) |

M0 scope deliberately stops at Button + Card. Do not implement the rest of the catalogue without moving
to the corresponding milestone.

## 9. Change discipline

- Update `CHANGELOG.md` for public API changes and mark breaking changes explicitly.
- Keep `docs/M0-RECONNAISSANCE.md` factual: new claims need source locations or captured command output.
- Do not commit build output (`Objects/`, `.b4j.meta`, generated `m0-output.html`).
- Do not commit unless the user asks.
