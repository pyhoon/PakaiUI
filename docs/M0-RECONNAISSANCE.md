# M0 — Reconnaissance and Proof of Concept

**Project:** PakaiUI
**Milestone:** M0
**Status:** Complete
**Date:** 2026-10-29
**Library version at completion:** 0.10 (experimental)

This document records only what was verified by reading source or by executing a command. Anything not
executed is labelled as a plan or an open question.

---

## 1. Environment and artifacts

| Item | Verified value | How verified |
| --- | --- | --- |
| OS | Windows | `win32` environment |
| B4J IDE | 10.7 (`C:\Program Files\B4X\B4J\B4J.exe`) | Install folder + project `Version=10.7` |
| Headless builder | `B4JBuilder v10.70` | `B4JBuilder.exe` banner |
| Build JDK | 19 (`C:\Java\jdk-19.0.2`) | `java -version` → `openjdk 19.0.2`; builder prints `Global Java version: 19` |
| Additional libraries | `C:\B4X\Additional` (`AdditionalLibrariesFolder` in `b4xV5.ini`) | B4J settings file |
| MiniHTML | 4.02 | `manifest.txt` inside `C:\B4X\Additional\B4X\MiniHTML.b4xlib` |
| MiniHTML b4xlib SHA-256 | `306B7F24649FA5CD49AB3A508E7019FC684FEA417354D92611C8F34AFC7EC797` | `Get-FileHash` |
| Installed EndsMeet | **4.03** | `manifest.txt` inside `C:\B4X\Additional\B4J\EndsMeet.b4xlib` |
| Pakai Server demo pin | EndsMeet **4.02**, MiniHTML **4.02**, MiniJS **0.60**, MiniCSS **0.40**, MiniORMUtils **6.04**, WebApiUtils **7.00** | `demo/libs.json` |
| Demo template | Pakai Server Web Demo `6.99 rev4` | `demo/demo.b4j` lines 40-43 |
| PakaiUI b4xlib SHA-256 | `84E1BB446A16905E2F6304CC50A80116B00274B902CD9F86FD413BB7F8F5A974` | `Get-FileHash` |
| `PUI.bas` SHA-256 | `C7E5CAFBA61ADB9B0D7F86642D0B8A3ABBF63FD48EA0E4BC4CC659A4AEFEBA95` | `Get-FileHash` |

**Dependency drift found:** the demo pins EndsMeet 4.02 but 4.03 is installed. PakaiUI does not depend on
EndsMeet, so this does not affect M0, but Pin-and-verify must be part of the M5 compatibility matrix.

### Source copies inspected

- `C:\Projects\MiniHTML4\source` — byte-identical copy of the MiniHTML 4.02 library project that was
  originally vendored in this repository (verified by SHA-256 of `MiniHtml.bas` and
  `Snippets/Helper.txt`).
- `C:\Projects\pakai-server-b4j\source` — Pakai Server 6.99 project used to verify the frontend versions
  and integration boundaries the demo was copied from.
- `source/` is now the PakaiUI library project. The vendored MiniHTML project files were removed from
  `source/` because MiniHTML is consumed as the installed 4.02 `.b4xlib`; the old files remain in git
  history (commit `d14a5e7`).

---

## 2. MiniHTML 4.02 verified API

File: MiniHTML 4.02 `source/MiniHtml.bas` (upstream: `github.com/pyhoon/MiniHTML4`).
Line numbers refer to that file. `MiniHtml` is a class; all builder methods return `MiniHtml` unless noted.

### 2.1 Construction and rendering

| Signature | Line | Notes |
| --- | --- | --- |
| `Initialize(Name As String = ModeNoTag, Mode As String = "default", Flat As Boolean = False, Indents As Int = 0, IndentString As String = "  ")` | 32 | Mode auto-selected from the tag name |
| `build(indent As Int = -1) As String` | 73 | Single renderer; prepends `<!DOCTYPE html>` for `<html>` |
| `ModeSelf = "self"`, `ModeMeta = "meta"`, `ModeNoTag = ""`, `ModeUniline = "uniline"`, `ModeMultiline = "multiline"` | 25-29 | Public constants |
| Tag auto-modes: `meta/link/img/br/input/path` → meta; `html/head/body/form/table/svg` → multiline; empty name → no tag; otherwise uniline | 39-54 | `Name` ending in `/` forces self-closing |
| Line feed/indent defaults: `br/span/b/i/...` → off, otherwise on | 58-65 | Affects rendered whitespace |
| `setFlat`, `setIndentation`, `setLineFeed`, `setIndentString`, `setDocType` | 960-1030 | Output formatting controls |

### 2.2 Attributes, classes and styles

| Signature | Line | Notes |
| --- | --- | --- |
| `attr(key As String, value As String)` | 190 | Stores raw value; **no escaping** |
| `attrs(keyvals As Map)` | 196 | Iterates keys as strings |
| `bool(key As String)` | 205 | Stores empty value → bare attribute |
| `attrIf(condition, key, value)` / `attrIfValue(key, value)` | 211 / 217 | `attrIfValue` adds only when non-empty |
| `attrsIfConditions` / `attrsIfValues` | 222 / 230 | Map-driven variants |
| `boolIf(condition, key)` | 238 | Conditional boolean attribute |
| `cls(value)` / `addClass(value)` / `removeClass(value)` | 475 / 485 / 499 | Splits on spaces; de-duplicates; syncs the `class` attribute |
| `clsIf` / `clsIIf` / `addClassIf` / `addClassIIf` | 545-564 | Conditional class helpers |
| `sty(value)` / `addStyle` / `removeStyle` | 480 / 513 / 531 | Splits `key:value` pairs; syncs `style` |
| `required`, `disabled`, `checked`, `selected`, `selectedIf`, `hidden`, `readonly`, `defer` | 890-928 | Boolean attribute helpers |
| `classesAsString` / `stylesAsString` | 585 / 596 | Current class/style values |

Attribute serialization (115-137): every attribute is written as ` key` followed by `="value"`. If the
value is empty, only the key is written (boolean attribute). If the value starts **and** ends with `'`,
it is written without adding double quotes. There is no escaping and no attribute-name validation.

### 2.3 Composition and traversal

| Signature | Line | Return value |
| --- | --- | --- |
| `add(childTag)` | 262 | **parent** |
| `addChild(childTag)` | 270 | **child** |
| `addTo(parentTag)` | 278 | **child** (safe no-op when parent uninitialized) |
| `up(parentTag)` | 284 | **child** (alias of `addTo`) |
| `down(childTag)` | 289 | **child** (alias of `addChild`) |
| `childByIndex` / `childById` / `childByName` / `childByClass` | 299-371 | Deep search for the named variants |
| `getChildren` / `setChildren` | 936 / 939 | Direct list access |
| `getParent` / `setParent` | 944 / 947 | |

Children are appended verbatim (149-156): `MiniHtml` children are built recursively, everything else is
appended through `StringBuilder.Append`. This is where unescaped strings become markup.

### 2.4 Text, parsing and serialization

| Signature | Line | Notes |
| --- | --- | --- |
| `text(value, wrap = True)` | 461 | Appends the raw string; `wrap` also sets indentation |
| `textIf` / `textIfValue` | 250 / 256 | Conditional text |
| `replace(value As Object)` | 468 | Clears children and appends one value |
| `comment(value, position = "above")` | 396 | Removes `--` from the value |
| `script(value)` | 852 | Wraps a script child |
| `parse(HtmlText) As MiniHtml` | 663 | Returns the first top-level element |
| `fromJson` / `fromMap` / `toMap` / `toJson` | 677 / 682 / 776 / 843 | Shorthand JSON round-trip |
| `convertFromBytes` / `convertToBytes` | 606 / 610 | UTF-8 helpers; useful for caching |

`MiniHtmlParser.bas`:

| Item | Line | Notes |
| --- | --- | --- |
| `EscapedEntitiesMap` | 13, 28 | `quot amp apos lt gt` plus numeric entities |
| Attribute regex (supports `@click`, `:class`) | 225 | Value is everything up to the same quote char |
| Text node creation | 102-113 | Stores the **raw** source in the `value` attribute |
| `ParseRawTextNode` | 117 | Script/style content |
| `UnescapeEntities` | 354-377 | Only called by API consumers such as `GetTextFromNode` |

---

## 3. Escaping and raw HTML findings

### 3.1 Nothing is escaped

`text()` appends the string as-is (461-465) and `attr()` stores the value as-is (190-193). `build()`
writes both without escaping (115-156). Consequences:

- `PUI` must escape every text and attribute value itself.
- `MiniHtml` has no trusted-HTML type; raw markup and plain text are the same thing to it.
- A value ending in `'` combined with the quote rule at 122-128 is an additional injection surface; escape
  quotes before storing.

### 3.2 Parser behaviour (round-trip safety)

The parser keeps escaped entities in attribute values and text nodes (`CreateTextNode` 102-113,
`ParseAttributes` 225-256). Only `GetTextFromNode` (and similar helpers) call `UnescapeEntities`
(354-377). Therefore:

- parse → build preserves the escaped source, so a parsed fragment can be re-rendered safely.
- If application code uses `GetTextFromNode` and passes the result to `text()`, the text must be escaped
  again.
- The PoC initially expected the parsed `id` to be unescaped; it is not, and the assertion was corrected
  to expect `PUI.EscapeHtml(original)`. This is recorded because it is a real behavioural detail.

### 3.3 Escaping contract adopted by PakaiUI

`PUI.EscapeHtml` uses the same mapping as EndsMeet's `EscapeHtml` (`EndsMeet.bas:358`), so PakaiUI and
Pakai Server render text identically:

| Character | Output |
| --- | --- |
| `"` | `&quot;` |
| `'` | `&#39;` |
| `<` | `&lt;` |
| `>` | `&gt;` |
| `&` | `&amp;` |

PakaiUI exposes raw output only through `PUI.RawHtml` (trusted fragment) and `PUI.AddHtml` (append
trusted fragment). Both are named so that code review can find them.

---

## 4. Composition contract (the M0 gate)

**Result: MiniHTML composition is sufficient; no PakaiUI tree or builder is needed.**

Verified behaviour:

- A component can return a fully built `MiniHtml` subtree.
- Composite components can be assembled by nesting `MiniHtml` elements:
  - `parent.down(child)` returns the child, so a chain can continue on the child.
  - `parent.add(child)` returns the parent, useful for closing a chain.
- A component can expose named slots as ordinary elements (for example `PUI.CardBody`) and callers attach
  children with `down`.
- An option-built component can be extended by retrieving its slot: `card.ChildByClass("card-body")`.
- `Card` containing `Button` was rendered, parsed back and asserted in the PoC.

Decision: **components return `MiniHtml`**; no `IPakaiComponent` interface, no renderer registry, no
second tree. Slot factories are preferred over hiding markup inside strings.

---

## 5. MiniHTML helper inventory and mapping

The shipped snippet is `Snippets/Helper.txt` inside the MiniHTML b4xlib (generated from
`Helper.bas`; the same content as the former `MH.bas` in this repository). Line numbers refer to
`Helper.bas` v4.02.

| PakaiUI need | MiniHTML helper | Reuse decision |
| --- | --- | --- |
| Tag factories | `Create`, `Div`, `Span`, `P`, `Button`, `Anchor`, ... (15-217) | Reuse the `MiniHtml` class directly; `PUI` does not copy the factories |
| Button | `Button` (43), `AnchorButton` (451), `ButtonSubmit` (489), `ButtonIcon` (447) | Reuse the element pattern; variant mapping, escaping and URL validation are PakaiUI's job |
| Card | `Card`/`CardHeader`/`CardBody`/`CardFooter`/`CardTitle`/`CardText` (307-329) | Adopt the same structure and class names; add escaped option-based factory |
| Badge | `Badge(text, cls)` (331) | Helper requires a raw Bootstrap class string; PakaiUI maps a semantic variant instead |
| Alert | `Alert(info) As String` (619), `AlertDismissible` (361) | Not reusable: returns `String` (breaks composition), takes unescaped text, no title/ID |
| Forms | `InputText`, `InputNumber`, `SelectInput`, `CheckboxInput`, ... (238-301) | M3: helper values are unescaped and the API is positional; PakaiUI will wrap |
| Table | tag factories only (`Table`, `Tr`, `Td`, `Th`) | M3: PakaiUI adds a structured column/row API |
| HTMX | `HxGet` (369), `HxPost` (373), `FormHx` (393), ... | M4: thin optional helpers; no typed options yet |
| Modal/toast | `ContainerModal` (517), `ContainerToast` (523), `Toast` (623) | M4: `Toast` calls `MiniJs`; PakaiUI must not require MiniJS |
| Navigation | `Navbar` (402), `NavLinkItem` (455), ... | M2: reusable patterns, but hard-coded Bootstrap classes and `$SERVER_URL$` placeholders |
| Caching | `Cache.bas`/`MC.bas`, `convertToBytes`/`convertFromBytes` | Application concern; PakaiUI elements are pure `MiniHtml` and therefore cacheable as UTF-8 bytes |
| Layout | `Container` (222), `Row` (230), `Col` (234) | M1: reuse class names, keep the API semantic |

**Gap summary:** MiniHTML helpers are app-level conveniences with raw class strings and no escaping.
PakaiUI adds: escaping, semantic variants, validated attributes/URLs, composition-friendly factories and
stable public names.

---

## 6. Dependencies and packaging

### MiniHTML 4.02

- `manifest.txt`: `B4J.DependsOn=B4XCollections,Json`; `CustomClassTemplates=View Class (Main)|MainView`.
- b4xlib contents: `MiniHtml.bas`, `MiniHtmlParser.bas`, `MainView.b4x_excluded`, `Snippets/*.txt`,
  `manifest.txt`, `LICENSE`.
- The b4xlib itself does **not** declare MiniJS. However the shipped `Snippets/Helper.txt` (`MH`) calls
  `MiniJs` in `CreateMiniJs`, `Toast` and `CreateCustomEventScript`, so a project that pastes `MH` needs
  MiniJS 0.60 even though the b4xlib does not.
- The original MiniHTML project file also referenced `endsmeet`, `jcore`, `minijs`, `json`,
  `b4xcollections` and `minihtml` (project libraries), and packaged the b4xlib with a manual `jar` macro
  (`MiniHTML.b4j` line 41).

### PakaiUI packaging decision

- `manifest.txt`: `B4J.DependsOn=B4XCollections,Json,MiniHTML`; `Supported Platforms=B4J`.
- Package with `jar -cMf Objects\PakaiUI.b4xlib PUI.bas manifest.txt LICENSE`
  (`source/build_b4xlib.bat`). This is the same archive shape as MiniHTML's documented macro and was
  verified by extracting and inspecting the resulting archive.
- Consumer project declares `Library5=minihtml` and `Library6=pakaiui`; the PoC compiled `PUI.bas` from
  the installed b4xlib (verified by inspecting the PoC jar for `b4j/pakaiui/m0/pui.class`).

---

## 7. Pakai Server (EndsMeet) findings

Verified from the installed EndsMeet 4.03 `.b4xlib` and the demo source:

| API | Purpose | Relevance to PakaiUI |
| --- | --- | --- |
| `ctx As Map` | Per-request template values | PakaiUI must not require it; apps may pass strings into components |
| `AssetsFolder` | Static files folder | Documented in M1 asset delivery; PakaiUI does not serve files |
| `ServerUrl`, `Get/Post/Route/Rest` | Routing and absolute URLs | Out of scope for the core |
| `EscapeHtml(Raw)` (line 358) | Escapes `" ' < > &` | Reference mapping for `PUI.EscapeHtml`; no dependency |
| `ReplaceMap(Base, Replacements)` (line 381) | Replaces `$KEY$` tokens; `$H_KEY$` values are escaped | Explains `$SERVER_URL$` in demo views; PakaiUI must not hard-code these placeholders |
| `WriteHtml` / `WriteHtml2` | Writes a rendered response | M5 adapter can call `PUI` components and render with MiniHTML |

The demo (`demo/`) is a Pakai Server starter, not a PakaiUI demo. It is retained as reference for M1/M5
and is not part of the M0 build.

---

## 8. Frontend versions and standalone asset delivery

### Versions referenced by Pakai Server source

| Asset | Version | Evidence |
| --- | --- | --- |
| Bootstrap CSS/JS | **5.3.8** | `demo/MainView.bas` lines 50-51, 70-71; local `bootstrap.min.css` header `Bootstrap v5.3.8` |
| Bootstrap Icons | **1.13.1** | `demo/MainView.bas` line 72 |
| HTMX | **2.0.8** | `demo/MainView.bas` line 52; string verified inside the local `htmx.min.js` |
| Alpine.js | **3.15.8** | Pakai Server `HelpHandler.bas:247` only; the demo does not load Alpine |
| MiniJS | 0.60 | `demo/libs.json`; only needed by the `MH` toast helpers |
| MiniCSS | 0.40 | `demo/libs.json`; not used by the demo views |

SRI hashes are present in the demo views for Bootstrap and HTMX (`MainView.bas` lines 50-53).

### Standalone delivery test (no Node.js)

The local asset folder `source/Objects/www/assets` was served with
`python -m http.server 8099 --directory source\Objects\www` and fetched over HTTP:

| Request | Status | Served bytes | Hash equals local file |
| --- | --- | --- | --- |
| `/assets/css/bootstrap.min.css` | 200 | 232,116 | `596A918E5D4C71CB731B23412D5B145E429C2203A23E9BF7BA90EFF3E291BBB8` |
| `/assets/js/htmx.min.js` | 200 | 51,250 | `22283EF68CB7545914F0A88A1BDEDC7256A703D1D580C1D255217D0A50D31313` |
| `/assets/css/bootstrap-icons.min.css` | 200 | 87,012 | (fonts referenced relatively) |

Served bodies matched the local files byte-for-byte and contained the expected version strings
(`Bootstrap v5.3.8`, HTMX `2.0.8`). This proves the assets can be self-hosted without a build toolchain.

**Repository gap:** these assets are currently untracked build output (`source/Objects/` is ignored). The
only tracked browser assets are `demo/Objects/www/assets/css/main.css`, `app.js` and images. M1 must add a
tracked, versioned `assets/` folder and document installation/serving.

---

## 9. HTMX 2.x baseline test (defined, not yet executed)

M0 defines the test; there is no PakaiUI demo page or server yet, so no browser test was run. Do not claim
HTMX compatibility until this test is executed and recorded.

**Fixture:** Bootstrap 5.3.8 + HTMX 2.0.8 (self-hosted), no Alpine.js, one page rendered by PakaiUI.

1. Page contains `<button hx-get="/hx/ping" hx-target="#m0-htmx" hx-swap="innerHTML">Ping</button>` and
   `<div id="m0-htmx">idle</div>`.
2. Handler returns a fragment, for example `<span id="m0-htmx">pong</span>`.
3. Pass criteria:
   - initial page shows `idle`;
   - click issues `GET /hx/ping` with `HX-Request: true` and HTTP 200;
   - `#m0-htmx` is replaced by `pong`, only that element changes, no full page load;
   - the page URL and browser history are unchanged;
   - with JavaScript disabled the button degrades to a normal form/GET action (or explicitly does
     nothing, documented);
   - no Alpine.js is required.
4. Repeat for `hx-post` with a form, and for `hx-swap="outerHTML"`.
5. Optional: verify a 204 response causes no swap, and record behaviour.

**HTMX 4:** evaluated as a separate task only after a stable release is available for testing. Do not add
v4-only attributes or defaults to the core, and do not claim v4 support before the baseline test is
re-run against it.

---

## 10. MiniJS and MiniCSS review (optional, future only)

| Library | Version | Verified API sample | Decision |
| --- | --- | --- | --- |
| MiniJS | 0.60 | `Generate`, `AddLine`, `AddEventListener`, `AddCustomEventDispatch`, condition/loop helpers | Optional only. MiniHTML's `MH.Toast` needs it; PakaiUI core must not. Revisit only for M4 interaction helpers, behind an optional module |
| MiniCSS | 0.40 | `AddRule`, `AddProperty`, `AddVariable`, `AddMediaQuery`, `GenerateCSS`, `ExportToFile` | Optional build-time tool at most. Consumers must not need MiniCSS or Node.js to use PakaiUI |

Neither library appears in PakaiUI's manifest or project libraries.

---

## 11. Requirements for the minimal public API

Based on the findings above, the M0 recommendation is deliberately small:

```b4j
' Types (declared in PUI Process_Globals; global namespace, so prefixed)
Type PUIButtonOptions (Text As String, Variant As String, Size As String, ButtonType As String, _
	Href As String, Id As String, CssClass As String, Disabled As Boolean, Hidden As Boolean)
Type PUICardOptions (Title As String, Subtitle As String, BodyText As String, FooterText As String, _
	Id As String, CssClass As String)

' Facade
Public Sub Initialize
Public Sub EscapeHtml (Raw As String) As String
Public Sub RawHtml (Html As String) As MiniHtml
Public Sub AddText (Parent As MiniHtml, Value As String) As MiniHtml
Public Sub AddHtml (Parent As MiniHtml, Html As String) As MiniHtml
Public Sub IsSafeUrl (Url As String) As Boolean
Public Sub NewButtonOptions (Text As String) As PUIButtonOptions
Public Sub NewCardOptions (Title As String, BodyText As String) As PUICardOptions
Public Sub Button (Options As PUIButtonOptions) As MiniHtml
Public Sub Card (Options As PUICardOptions) As MiniHtml
Public Sub CardHeader As MiniHtml
Public Sub CardBody As MiniHtml
Public Sub CardFooter As MiniHtml
Public Sub CardTitle As MiniHtml
Public Sub CardText As MiniHtml
```

Rules baked into this surface:

- `PUI.Variant*` and `PUI.Size*` constants replace raw Bootstrap classes as the primary API.
- `PUIButtonOptions.Hidden` replaces a `Visible` flag so that the B4X `False` default is safe.
- `Href` switches the element to `<a>`; `javascript:`, `data:` and `vbscript:` are rejected and logged.
- `CssClass` is an escape hatch; it is escaped and never used for events or styles.
- There is no `Attributes As Map` in v0.10; arbitrary attributes are deferred until a validated API exists.
- Components return `MiniHtml` and compose through MiniHTML.

Deliberately deferred: Badge, Alert (M2), forms/tables (M3), HTMX helpers/dialogs/toasts (M4), Pakai
Server adapter (M5).

---

## 12. Proof of concept — actual results

### Project

`tests/m0-poc/M0PoC.b4j` — console application, libraries `b4xcollections`, `javaobject`, `jcore`, `json`,
`minihtml`, `pakaiui`. It consumes the installed `C:\B4X\Additional\B4J\PakaiUI.b4xlib`; it does not
reference `source/PUI.bas`.

### Build commands and output

```text
cd C:\Projects\PakaiUI\source
B4JBuilder -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
  B4JBuilder v10.70
  Global Java version: 19
  Compiling code.
  Compiling generated Java code.
  Building jar file.
  Jar file created: C:\Projects\PakaiUI\source\Objects\PakaiUI.jar
  Completed successfully (about 2 seconds)
```

```text
cmd /c build_b4xlib.bat
  Built Objects\PakaiUI.b4xlib
```

```text
cd C:\Projects\PakaiUI\tests\m0-poc
B4JBuilder -Task=Build -Project="M0PoC.b4j" -NoClean=True -ShowWarnings=True
  Completed successfully (about 2 seconds)
java -jar Objects\M0PoC.jar
  M0 PoC: 28 passed, 0 failed
  exit code 0
```

`B4JBuilder -BaseFolder` did not affect project resolution; running from the project folder is required.
This is documented in `AGENT.md`.

### Warning audit (manual)

The command-line builder does **not** print the B4J IDE's warning numbers, even with
`-ShowWarnings=True`. A deliberately bad `Object` comparison still builds silently (verified by the project
owner). The absence of warning lines in the output above is therefore not evidence; the code was audited
by pattern against the three project rules:

| Rule | Audit result |
| --- | --- |
| #19 empty `Catch` | `PUI.bas` and `M0PoC.b4j` contain no `Try`/`Catch` blocks, so none can be empty. Future code must log `LastException.Message`. |
| #35 `Object` on the right | The PoC has three `Object` comparisons and all put the object on the right: `hostileId = attributes.Get("id")`, `"https://example.com/a?x=1&amp;y=2" = link1.GetAttributes.Get("href")`, `"submit" = ...GetAttributes.Get("type")`. `PUI.bas` only compares class references to `Null` (`options1 = Null`, `Parent = Null`), which is a null guard, not an `Object`-vs-value comparison. |
| #9 unused variable / #12 unused sub | Every local and private sub in `PUI.bas` and `M0PoC.b4j` is referenced; `PUI` exports public API deliberately. |

Opening both projects in the B4J IDE remains the authoritative warning check.

### Assertions executed (28)

Composition: card-body slot exists; part factories compose; card contains the button.
Escaping: no raw `<script`; button text escaped; card body text escaped; hostile `id` remains one escaped
attribute; no `onmouseover` attribute after parsing.
URLs: `https` accepted; relative accepted; `javascript:` and `data:` rejected; unsafe button rendered
without `href`; href value escaped (`&` → `&amp;`).
State: disabled attribute; hidden attribute; submit type.
Explicit HTML: `RawHtml` is byte-exact; `AddText` escapes; `AddHtml` passes through.
Escape function: all five characters covered.

### Rendered output (abridged)

```html
<div class="card" id="m0-card">
  <div class="card-body">
    <h5 class="card-title">Welcome</h5>
    <h6 class="card-subtitle mb-2 text-body-secondary">M0 proof of concept</h6>
    <p class="card-text">Body text with &lt;b&gt;markup&lt;/b&gt; &amp; &#39;quotes&#39;</p>
    <button type="button" class="btn btn-danger" id="x&quot; onmouseover=&quot;alert(1)">&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt; &amp; &#39;y&#39;</button>
  </div>
</div>
```

The hostile label and attribute value are data, not markup, and the rendered HTML parses back to a single
button with no `onmouseover` attribute.

### Deliberate negative test

`PUI.Button` with `Href = "javascript:alert(1)"` logs
`PakaiUI: rejected unsafe button URL: javascript:alert(1)` to stderr and renders the anchor without an
`href`. This line is expected in the PoC output.

---

## 13. Findings, risks and mitigations

| # | Finding | Risk | Mitigation adopted |
| --- | --- | --- | --- |
| 1 | MiniHTML does not escape text or attributes | XSS if callers use `text`/`attr` directly | `PUI` escapes; raw output needs an explicit call; PoC tests injection |
| 2 | Attribute order is non-deterministic | Brittle tests and diffs | Tests parse output; no whole-string assertions |
| 3 | `attr(k, "")` emits a boolean attribute | Accidental `href=""` / `value=""` | Use `attrIf`/`attrIfValue`; documented |
| 4 | B4X option booleans default to `False` | A `Visible` flag would hide everything | `Hidden` flag instead |
| 5 | `Type` is reserved in B4X | Cannot name a field `Type` | `ButtonType` field |
| 6 | `MH` snippet depends on `MiniJs` | Accidental MiniJS dependency | `PUI` never calls `MH`; only the `MiniHtml` class |
| 7 | Parser preserves entities; `GetTextFromNode` unescapes | Double unescape/re-escape bugs | Documented; `AddText` escapes; PoC asserts parser behaviour |
| 8 | `build()` emits CRLF/indentation | Exact-fragment comparisons fail | `RawHtml` uses flat mode; tests parse |
| 9 | Demo's asset folder is untracked | M1 cannot ship assets from the repo | M1 adds a tracked `assets/` folder |
| 10 | EndsMeet pin (4.02) ≠ installed (4.03) | Integration tested against a different version than documented | No core dependency; matrix in M5; pin recorded |
| 11 | B4X converts `Null` assigned to a `String` into the literal text `"null"` | Option values can render as `null` text, ids or variants | Applications must normalise data before building options; PakaiUI cannot distinguish `"null"` from real text. Verified by assigning `Null` to option fields in a throwaway test (the PoC asserts the normal path instead) |

---

## 14. Limitations (not done in M0)

- No browser session was run: HTMX/Alpine interaction and visual rendering are untested. Only the HTML
  output and static asset delivery were verified.
- The Pakai Server demo was not started (it needs config/database and is not part of PakaiUI).
- Only B4J 10.7 on Windows with JDK 19 was tested. Other B4J/JDK combinations are unverified.
- `B4JBuilder -Task=BuildLibrary` was not used; the b4xlib is packaged with `jar`, which was verified by
  extraction and by a successful consumer build.
- No light/dark theme, CSS token layer or gallery demo exists yet (M1).
- No automated CI exists; the PoC is the current regression gate.

---

## 15. Recommended next steps (M1)

1. Add a tracked `assets/` folder with Bootstrap 5.3.8, Bootstrap Icons 1.13.1 and (optional) HTMX 2.0.8,
   plus versioned filenames and documented upgrade/cache-busting steps.
2. Add PakaiUI theme tokens and light/dark support through `data-bs-theme`, without overriding Bootstrap.
3. Add container/row/column and page primitives following the composition contract.
4. Add a standalone gallery demo that consumes `PakaiUI.b4xlib` without Pakai Server.
5. Execute the HTMX 2.x baseline test from section 9 and record the result.
6. Move the PoC assertions into a repeatable test project alongside the gallery.

## 16. Integration target (outside M0 scope)

The maintainer has identified `C:\Projects\pakai-asadi` (Pakai Asadi, a modern-UI Pakai Server application)
as the first real integration test for PakaiUI once the library is ready. Its pinned stack, read from that
repository during M0, is compatible with PakaiUI's baseline:

| Item | pakai-asadi |
| --- | --- |
| B4J | 10.7 |
| EndsMeet | 4.03 |
| MiniHTML | 4.02 |
| MiniORMUtils | 6.04 |
| Database | SQLite (`sqlite-jdbc` 3.53) |
| Libraries declared | `endsmeet`, `jcore`, `minihtml`, `miniormutils` |

pakai-asadi was **not** built or modified during M0. Integration will be verified in M5 (or earlier as a
manual smoke test) by adding `pakaiui` to that project and replacing selected hand-built markup; core
PakaiUI must remain independent of EndsMeet so this stays an optional consumer relationship.

