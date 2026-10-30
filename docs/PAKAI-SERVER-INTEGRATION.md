# PakaiUI on Pakai Server / EndsMeet

Version 0.15. PakaiUI has no Pakai Server dependency and needs no adapter to run inside one. A host handler
builds a `MiniHtml` document with PUI, renders it with `page.build`, and writes the string to the servlet
response. This document records the verified example and the integration rules.

## Integration model

```
EndsMeet / Pakai Server host
  App.Initialize -> App.Get/Post -> App.Start
        |
        v
  Handler.Handle(req As ServletRequest, resp As ServletResponse)
        |  PUI.Document / components
        v
  MiniHtml tree -> page.build -> resp.Write(html)
```

- One server. PakaiUI never starts a listener, registers routes or reads sessions.
- One response. PakaiUI returns plain HTML; the host owns headers, cookies, compression, auth and errors.
- Assets remain host-owned. Sync the tracked `assets/` folder into `Objects\www\assets`; EndsMeet serves
  `www` from `File.DirApp` by default.
- Optional JavaScript (Bootstrap, HTMX, Alpine) is loaded by the page, not by the library.

## Verified example

The buildable example lives in [`../examples/pakai-server`](../examples/pakai-server):

| File | Purpose |
| --- | --- |
| `PakaiServerExample.b4j` | EndsMeet host: port 51020, `GET /` and `POST /submit` |
| `PuiHomeHandler.bas` | Renders the home page, form and version table with PUI |
| `PuiFormHandler.bas` | Reads `req.GetParameter("name")` and renders an escaped result |
| `README.md` | Build, sync, run and verification record |

Build and run:

```powershell
cd source
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiUI.b4j" -NoClean=True -ShowWarnings=True
cmd /c build_b4xlib.bat
Copy-Item Objects\PakaiUI.b4xlib C:\B4X\Additional\B4J\PakaiUI.b4xlib -Force

cd ..\examples\pakai-server
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiServerExample.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\..\sync-assets.bat examples\pakai-server
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiServerExample.jar
```

Open `http://localhost:51020/`.

The whole integration is the handler:

```b4j
Sub Handle (req As ServletRequest, resp As ServletResponse)
    Dim page As MiniHtml = BuildPage
    resp.ContentType = "text/html; charset=utf-8"
    resp.Write(page.build)
End Sub
```

And the form result:

```b4j
Dim visitor As String = req.GetParameter("name")
If visitor = "" Then visitor = "world"
Dim alertOptions As PUIAlertOptions = PUI.NewAlertOptions("Hello " & visitor & "!")
alertOptions.Variant = PUI.VariantSuccess
PUI.Alert(alertOptions).up(container1)
```

`PUI.Alert` escapes the message, so request data cannot inject markup.

## Verified results (2026-10-30)

| Check | Result |
| --- | --- |
| Build | PASS - B4JBuilder 10.70, exit 0 |
| Start | PASS - `EndsMeet server (version = 4.03) is running on port 51020` |
| Home page | PASS - navbar, form, 4-row table; Bootstrap/PakaiUI CSS loaded |
| POST `/submit` with `<b>Test</b>` | PASS - result page rendered the value as escaped text |
| Browser console | PASS - no errors |
| Layout | PASS - no horizontal overflow |

## Static assets

EndsMeet 4.03 defaults `staticfiles.AssetsFolder` to `www` under `File.DirApp` and starts a Jetty default
servlet for it. Run the host from `Objects`, sync assets with `sync-assets.bat`, and use the versioned URLs
from `assets/README.md`:

```b4j
PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
PUI.StyleSheet(head1, "/assets/css/bootstrap-icons.min.css?v=1.13.1")
PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=" & PUI.VERSION)
PUI.Script(body1, "/assets/js/bootstrap.min.js?v=5.3.8", True)
PUI.Script(body1, "/assets/js/htmx.min.js?v=2.0.8", True)
PUI.Script(body1, "/assets/js/alpine.min.js?v=3.15.8", True)
```

If the host changes `App.AssetsFolder` or serves assets from another origin, set `AssetBase` explicitly in
the stylesheet and script URLs.

## Mounting under a path

PakaiUI renders the URLs it is given. If the application is mounted at `/portal`, prefix every asset and
form URL:

```b4j
PUI.StyleSheet(head1, "/portal/assets/css/bootstrap.min.css?v=5.3.8")
formOptions.Action = "/portal/submit"
```

Route registration still belongs to EndsMeet. Keep the base path identical in routes, links and forms.

## Authentication and authorization

PakaiUI provides no authentication. Add the host's filters before rendering an authenticated page:

- register the auth/role filter before the page route;
- return a redirect or `403` before calling the handler that renders the page;
- keep authorization checks server-side; hiding a button is not access control;
- never place secrets or session tokens in option text that is rendered to the page.

The example intentionally has no authentication so it can run locally.

## Content-Security-Policy

PakaiUI emits no inline `<script>` and no inline event handlers. If the host enforces a CSP:

- allow the self-hosted `assets/js` files in `script-src` when Bootstrap/HTMX/Alpine are used;
- allow `assets/css` in `style-src`;
- keep `PUI.Alpine` expressions and `PUIHtmxOptions.Trigger` free of user data; they are trusted
  developer code, not an escaping boundary;
- the Bootstrap modal and toast require JavaScript; otherwise the static markup remains but the
  interaction is inert.

## Error handling

- Build the page before setting a success status; if rendering throws, let the host's error filter handle
  the response.
- Do not write partial HTML and then set a different status. Render to a string and write once.
- Log rejected URLs and unknown variants from PakaiUI; they are deliberate degradation messages, not
  request failures.
- For form posts, validate and authorize before calling `page.build`.

## Relationship to Pakai Asadi

[Pakai Asadi](https://github.com/pyhoon/PakaiAsadi) is the first integration consumer. Its login,
registration, workspace shell, product and category pages are built with PUI components and the optional
`pakaiui-asadi.css` theme, while its EndsMeet routes, authentication, authorization callback and SQL safety
rules remain its own. The example above proves the same host contract independently and does not require
Pakai Asadi or any adapter library.

Do not copy PakaiUI source into a host and do not add EndsMeet to `PakaiUI.b4xlib`. The dependency
direction is one-way: host -> PakaiUI.

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `404` for `/assets/...` | Run from `Objects`, or point `App.AssetsFolder` at the folder containing `assets` |
| Assets load, page is unstyled | Sync assets and check the versioned filenames |
| `App.Get("", ...)` not reached | Do not map the root as literal `/`; use the empty string as this example does |
| Form submits to the wrong URL | Use the same base path in `FilterBar.Action` and the registered route |
| Page renders but modal does not open | Bootstrap JavaScript is not loaded or CSP blocks it |
| `java` cannot load the jar | The `java` on `PATH` may be Java 8; use the Java 19 runtime explicitly |
