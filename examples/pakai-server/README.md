# PakaiUI on Pakai Server / EndsMeet

A minimal, buildable host that renders PakaiUI pages from an EndsMeet route. It proves the optional
integration model without adding Pakai Server to the PakaiUI library:

- `PuiHomeHandler` builds a `MiniHtml` document with PUI and calls `resp.Write(page.build)`.
- `PuiFormHandler` reads `req.GetParameter("name")` and renders the result through PUI, which escapes it.
- EndsMeet owns the listener, routing, static files and response; PakaiUI owns only the HTML.

There is no PakaiUI adapter library to install. The integration point is the standard servlet response.

## Requirements

| Component | Version |
| --- | --- |
| B4J | 10.7 |
| Java | 19 (build and run) |
| EndsMeet | 4.03 (`C:\B4X\Additional\B4J\EndsMeet.b4xlib`) |
| MiniHTML | 4.05 (4.04+ required) |
| PakaiUI | 0.16 (installed `PakaiUI.b4xlib`) |

## Build and run

Build and install PakaiUI first (from the repository root):

```powershell
cd source
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force
```

Then build the example, sync its assets and run it from `Objects` so EndsMeet serves `www`:

```powershell
cd ..\examples\pakai-server
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiServerExample.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiServerExample.jar
```

Open `http://localhost:51020/`.

Routes:

| Route | Method | Purpose |
| --- | --- | --- |
| `/` | GET | Home page, table and form |
| `/submit` | POST | Renders the submitted name through `PUI.Alert` |
| `/assets/*` | GET | Bootstrap, icons, HTMX, Alpine and `pakaiui.css` from `Objects\www\assets` |

## Verified results

Executed on 2026-10-30:

| Check | Result |
| --- | --- |
| Build | PASS - B4JBuilder 10.70, exit code 0 |
| Server start | PASS - `EndsMeet server (version = 4.03) is running on port 51020` |
| Home page | PASS - title, navbar, form, 4-row table, 3 stylesheets loaded |
| Static CSS | PASS - `/assets/css/bootstrap.min.css` and `pakaiui.css` resolve through EndsMeet |
| Form POST | PASS - `/submit` rendered `Form received` and the submitted name |
| Escaping | PASS - `<b>Test</b>` rendered as escaped text, no raw `<b>` element |
| Browser console | PASS - no errors |
| Layout | PASS - no horizontal page overflow |

## Integration notes

- **One server.** Call `App.Initialize`, register routes with `App.Get` / `App.Post`, then `App.Start`.
  Never start a second listener for PakaiUI.
- **Assets.** EndsMeet's default static folder is `www` under `File.DirApp`; run from `Objects` and sync the
  tracked `assets/` folder with `sync-assets.bat`. Link assets with the version query strings shown in
  `assets/README.md`.
- **Base paths.** If the host mounts pages under a prefix, change the stylesheet and form `Action` hrefs to
  include that prefix. PakaiUI renders the URLs it is given; it cannot infer the mount point.
- **Authorization.** This example has no authentication. Add the host's filter/role policy before exposing
  a real page; rendering HTML does not provide access control.
- **CSP.** PakaiUI itself emits no inline scripts. If the host sets a strict Content-Security-Policy, allow
  the self-hosted assets under `script-src` / `style-src` as appropriate, or omit the optional scripts.
- **Not packaged.** This example is not part of `PakaiUI.b4xlib` and is not a dependency of the library.
