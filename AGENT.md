# AGENT.md

Instructions for AI agents and contributors working in this repository.

## 1. What this project is

**PakaiUI** is a reusable, server-rendered UI component library for B4J web applications. It is built on
[MiniHTML 4.02](https://github.com/pyhoon/MiniHTML4) and Bootstrap 5.3, distributed as a `.b4xlib`, and
works without Pakai Server. HTMX 2.x and Alpine.js are optional enhancements only.

| Item | Value |
| --- | --- |
| Library version | `0.10` (experimental; public API may change) |
| Current milestone | **M0 complete** — reconnaissance + compiled proof of concept |
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
docs/PakaiUI-*.md            Design inputs: specification, API proposal, considerations (read-only)
source/                      PakaiUI library B4J project
  PUI.bas                    Public facade: options types, components, escaping
  PakaiUI.b4j                Library project (smoke-test AppStart)
  manifest.txt               b4xlib manifest (version + dependencies)
  libs.json                  External library pin (MiniHTML 4.02)
  build_b4xlib.bat           Packages Objects\PakaiUI.b4xlib with jar.exe
tests/m0-poc/                Console proof of concept (consumes the installed b4xlib)
demo/                        Pakai Server Web 6.99 starter (reference; not a PakaiUI demo yet)
```

- `docs/PakaiUI-Technical-Specification.md`, `docs/PakaiUI-Initial-Public-API.md` and
  `docs/PakaiUI-Consideration-Before-Started.md` are the design inputs. Treat them as **design input**,
  not as a description of what is implemented.
- `demo/` is a Pakai Server starter that was vendored for reference. It is **not** built or shipped with
  PakaiUI and must not leak framework assumptions into `source/`.
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
   defaults to `False`. Use `Hidden` (and similar negative flags). `Type` is a reserved word, hence
   `ButtonType`.

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
`Object`-versus-value comparison, and is allowed.

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
| M1 | Foundation, theme tokens, page/container primitives, standalone gallery demo, asset docs | Next |
| M2 | Button, Badge, Alert, Card, Breadcrumb, page header, navigation, empty/loading states | Not started |
| M3 | Forms, validation feedback, tables, pagination, filters | Not started |
| M4 | Optional HTMX/Alpine interactions (dialogs, toasts, theme switcher) | Not started |
| M5 | Pakai Server adapter/examples, first consumer integration (`pakai-asadi`), docs, compatibility matrix, release | Not started |

M0 scope deliberately stops at Button + Card. Do not implement the rest of the catalogue without moving
to the corresponding milestone.

## 9. Change discipline

- Update `CHANGELOG.md` for public API changes and mark breaking changes explicitly.
- Keep `docs/M0-RECONNAISSANCE.md` factual: new claims need source locations or captured command output.
- Do not commit build output (`Objects/`, `.b4j.meta`, generated `m0-output.html`).
- Do not commit unless the user asks.
