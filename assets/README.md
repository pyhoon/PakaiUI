# PakaiUI frontend assets

Tracked, versioned copies of the browser assets PakaiUI galleries and
applications link to. These files are **not** part of `PakaiUI.b4xlib`
(a b4xlib cannot serve browser assets). Each consuming B4J web project keeps
its own copy under `Objects/www/assets` and serves it from there.

## Files

| File | Required? | Version | Purpose |
| --- | --- | --- | --- |
| `css/bootstrap.min.css` | required | 5.3.8 | All component styling |
| `css/pakaiui.css` | optional | PakaiUI 0.13 | `--pui-*` token aliases; never overrides Bootstrap |
| `css/bootstrap-icons.min.css` | optional | 1.13.1 | `bi bi-*` icon classes |
| `css/fonts/bootstrap-icons.woff2` / `.woff` | with icons | 1.13.1 | Icon font, loaded relative to `css/` |
| `css/LICENSE/bootstrap/LICENSE.txt` | with bootstrap | — | MIT license of Bootstrap |
| `js/bootstrap.min.js` | optional | 5.3.8 | Interactive Bootstrap behaviours (dropdown, collapse, ...) |
| `js/bootstrap.min.js.map` | optional | 5.3.8 | Source map for browser devtools only |
| `js/htmx.min.js` | optional | 2.0.8 | HTMX attributes (`hx-*`) |

Layout note: the icons CSS references `./fonts/bootstrap-icons.*`, so keep the
font files beside `bootstrap-icons.min.css` under `css/fonts/`.

## Signed versions (SHA-256)

| File | SHA-256 |
| --- | --- |
| `css/bootstrap.min.css` | `596A918E5D4C71CB731B23412D5B145E429C2203A23E9BF7BA90EFF3E291BBB8` |
| `css/pakaiui.css` | `273D3177897B3449266171DEE49B72C4E654B395C243E6DBB0F71CD56D0A961B` |
| `css/bootstrap-icons.min.css` | `5BDE1B1280C519BE069FF3A711B639E0E996886AD4E4F7C6B4AB99237ED875B4` |
| `css/fonts/bootstrap-icons.woff2` | `6C75710364A1CA5604267716F6D28997B26319FDB078CF11E0B42AB66FF2EA61` |
| `css/fonts/bootstrap-icons.woff` | `F55513B7B591CB84A3B87FF0E34EA24D4831D6FEDC22E54B911CA64B5B544A15` |
| `js/bootstrap.min.js` | `175CADA6CDDB051C3B171E8D78DEDC75DDB01758D5FBC17515AB3841D1931279` |
| `js/bootstrap.min.js.map` | `52B03D8D959CA53D69C1F34C13E6242080C9ACCBBE0237C829349F777383C0CB` |
| `js/htmx.min.js` | `22283EF68CB7545914F0A88A1BDEDC7256A703D1D580C1D255217D0A50D31313` |

Before upgrading a file, record the new hash here next to the new version
string. A changed hash without a documented upgrade is a supply-chain red flag.

## Serving and installation (no Node.js required)

1. Copy the assets into the consuming project:

   ```powershell
   # From the repository root; works for any project folder
   cmd /c sync-assets.bat demo        # -> demo\Objects\www\assets
   ```

   `sync-assets.bat` copies (never deletes) tracked files into
   `<target>\Objects\www\assets`. Run it again after upgrading tracked assets.
   Behind the scenes it is `robocopy ... /E`; generated or project-owned files
   in the target that are not tracked here (for example a project's own
   `main.css` or images) are left alone.

2. Serve the project's `Objects` folder as the static root (standard jServer
   behaviour: files under `Objects/www` are web-accessible at `/assets/...`).
   Do not link web pages to the tracked repository `assets/` folder directly.

3. Reference the links in code with a configurable base so CDN or absolute
   hosting stays one string away:

   ```b4j
   Dim AssetBase As String = ""      ' same origin, for example "" or "/portal"
   PUI.StyleSheet(head1, AssetBase & "/assets/css/bootstrap.min.css?v=5.3.8")
   PUI.StyleSheet(head1, AssetBase & "/assets/css/pakaiui.css?v=0.13")
   PUI.StyleSheet(head1, AssetBase & "/assets/css/bootstrap-icons.min.css?v=1.13.1")
   ' scripts at the end of <body>, loaded with defer
   PUI.Script(body1, AssetBase & "/assets/js/bootstrap.min.js?v=5.3.8", True)
   PUI.Script(body1, AssetBase & "/assets/js/htmx.min.js?v=2.0.8", True)
   ```

## CDN / external hosting

`res.json` is a Pakai-style manifest mapping each file to its upstream source
URL. To self-update, or to fetch files on a fresh machine, re-download from
those sources and verify the hashes in this README before trusting the copies.

For a CDN deployment keep `AssetBase` pointing at a remote origin, for example
`https://cdn.example.com/pakai`, and upload this folder's content (no Node.js
involved). Cache-bust by appending `?v=<version>` to each link, as shown
above, or host a versioned directory `assets/5.3.8/` and point `AssetBase`
at it.

## Compatibility matrix

| PakaiUI version | Bootstrap | Bootstrap Icons | HTMX |
| --- | --- | --- | --- |
| 0.13 (current) | 5.3.8 | 1.13.1 | 2.0.8 |

Do not jump Bootstrap major/minor versions without re-running the HTMX
baseline test documented in `docs/M0-RECONNAISSANCE.md` section 9.
