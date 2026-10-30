# PakaiUI compatibility matrix

Version 0.16, verified 2026-10-30. Only the combinations below were built or run; anything else is
untested, not "probably fine".

## Supported stack

| Component | Verified version | Role |
| --- | --- | --- |
| B4J | 10.7 (B4JBuilder 10.70) | Compiler and IDE |
| Java | 19 (`C:\Java\jdk-19.0.2`) | Build and run runtime |
| MiniHTML | 4.05 (4.04+ required) | HTML tree, rendering, composition, text escaping |
| PakaiUI | 0.16 | This library |
| Bootstrap CSS | 5.3.8 | Required for component styling |
| Bootstrap JavaScript | 5.3.8 | Optional: modal, toast dismissal |
| Bootstrap Icons | 1.13.1 | Optional: empty-state icons |
| HTMX | 2.0.8 | Optional: `PUI.Htmx` behavior |
| Alpine.js | 3.15.8 | Optional: `PUI.Alpine` behavior |
| EndsMeet | 4.03 | Optional: Pakai Server-style host in the M5 example |

Pakai Server template metadata observed for reference: 6.99. PakaiUI does not import Pakai Server,
EndsMeet, MiniJS, MiniCSS or MiniORMUtils. There is no Pakai Server runtime dependency.

## Compatibility table

| PakaiUI | MiniHTML | Bootstrap | Icons | HTMX | Alpine | Status |
| --- | --- | --- | --- | --- | --- | --- |
| 0.16 (current) | 4.05 | 5.3.8 | 1.13.1 | 2.0.8 | 3.15.8 | Verified |
| 0.15 | 4.02 | 5.3.8 | 1.13.1 | 2.0.8 | 3.15.8 | Superseded: double-escapes text on 4.04+ |
| 0.14 | 4.02 | 5.3.8 | 1.13.1 | 2.0.8 | 3.15.8 | Verified |
| 0.13 | 4.02 | 5.3.8 | 1.13.1 | 2.0.8 | not used | Verified |
| 0.12 | 4.02 | 5.3.8 | 1.13.1 | 2.0.8 | not used | Verified |
| 0.11 | 4.02 | 5.3.8 | 1.13.1 | 2.0.8 | not used | Verified |
| 0.10 | 4.02 | 5.3.8 | not used | 2.0.8 baseline | not used | Verified |

Bootstrap 5.3.x patch upgrades are expected to be compatible but were not re-tested. Bootstrap 4, 6,
HTMX 1.x/4.x, Alpine 2.x, MiniHTML 4.02/4.03, B4J below 10.7 and Java below 19 are untested. PakaiUI 0.16 requires MiniHTML 4.04 or newer because it relies on the default text escaping introduced in 4.04.

## Evidence

| Check | Result |
| --- | --- |
| M5 Pakai Server/EndsMeet example build | PASS - B4JBuilder 10.70, EndsMeet 4.03, exit 0 |
| M5 example run and routes | PASS - `/` and POST `/submit` on port 51020 |
| M5 example assets | PASS - Bootstrap/PakaiUI CSS served from `Objects\www\assets` |
| M5 example escaping | PASS - submitted markup rendered escaped, no browser errors |
| M4 optional interactions | PASS - 162 assertions, exit 0 |
| M3 forms/data display | PASS - 203 assertions, exit 0 |
| M2 core components | PASS - 135 assertions, exit 0 |
| M1 foundation | PASS - 35 assertions, exit 0 |
| M0 proof of concept | PASS - 28 assertions, exit 0 |
| HTMX 2.x baseline | PASS - GET, POST, outerHTML and 204 behavior |
| Gallery | PASS - all M1-M4 sections, 33 unique ids, 12 labels, no console errors |

Total automated assertions: **563**. All suites exit 0.

## Verified behavior of optional dependencies

| Dependency absent | Result |
| --- | --- |
| Bootstrap JavaScript | Page renders; modal and toast markup exists; modal trigger and toast close are inert |
| HTMX | `PUI.Htmx` elements remain ordinary HTML; forms still use their `action`/`method` fallback |
| Alpine.js | `PUI.Alpine` attributes are inert; initially visible content stays visible |
| Icons | Components render; empty-state icons have no glyph |
| MiniJS / MiniCSS | No effect: PakaiUI never references them |

## Version pins and artifacts

- `source/PUI.bas`: `VERSION = "0.16"` and the file header.
- `source/manifest.txt`: `Version=0.16`; dependencies `B4XCollections, Json, MiniHTML`.
- `assets/res.json`: asset manifest `Version=0.16`.
- `assets/css/pakaiui.css`: header version 0.16.
- `PakaiUI.b4xlib` SHA-256: `4AF3253F1E66CC08EAA2C330E525FAFEF7E606E74233F1C87A28D51A1F86F2F3`.
- Hashes: see `assets/README.md` and the artifact table in
  [`M0-RECONNAISSANCE.md`](M0-RECONNAISSANCE.md).

## Verified constraints

These are properties of the toolchain, not PakaiUI bugs. Keep them in mind when integrating.

- B4JBuilder's command line does not surface IDE warning numbers even with `-ShowWarnings=True`; audit by
  pattern or use the IDE.
- MiniHTML attributes are stored in a Map, so attribute order is not deterministic. Assert by parsing.
- `MiniHtml.attr(key, "")` emits a bare boolean attribute. Only set optional attributes when non-empty.
- `Null = value` throws at runtime in B4J; use `value = Null` for object null guards.
- `Select` and `Type` are reserved words, hence `SelectField`, `InputType` and `ButtonType`.
- B4J converts `Null` assigned to a `String` into the literal text `"null"`.
- Assets are not part of `PakaiUI.b4xlib`; each host serves its own synced copy.
- The gallery and example must run from their `Objects` folder so `www` and `logs` resolve.

## Related documents

- [`VERSIONING.md`](VERSIONING.md) - versioning, migration and release policy
- [`API-REFERENCE.md`](API-REFERENCE.md) - complete public API
- [`PAKAI-SERVER-INTEGRATION.md`](PAKAI-SERVER-INTEGRATION.md) - optional host example
- [`M0-RECONNAISSANCE.md`](M0-RECONNAISSANCE.md) - verified MiniHTML/browser findings
