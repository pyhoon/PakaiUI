# PakaiUI M4 optional interactions

Version 0.14. This document describes the optional interaction helpers and components added in M4. None
of them makes HTMX, Alpine.js or Bootstrap JavaScript a core dependency: the library only renders markup,
and every feature states which code owns the behavior.

## Behavior ownership

| Feature | Component | Behavior owner | Optional dependency | Without the dependency |
| --- | --- | --- | --- | --- |
| Server-driven requests | `PUI.Htmx` | HTMX | `js/htmx.min.js` 2.0.8 | Element renders and works as ordinary HTML; no AJAX swap |
| Local UI state | `PUI.Alpine` | Alpine.js | `js/alpine.min.js` 3.15.8 | Attributes are inert; initial content stays visible |
| Dialog | `PUI.Modal` + `PUI.ModalTrigger` | Bootstrap JavaScript | `js/bootstrap.min.js` 5.3.8 | Markup is rendered in the DOM; the trigger does not open it |
| Notification | `PUI.Toast` | Bootstrap JavaScript | `js/bootstrap.min.js` 5.3.8 | Toast is visible; close button is inert |
| Theme selection | `PUI.ThemeSwitcher` | Server | none | Works as server-side links |
| Sidebar navigation | `PUI.Sidebar` | Browser / CSS | none | Works as a static aside with links |

The gallery loads Bootstrap, HTMX and Alpine at the end of `<body>` with `defer`; the core library never
loads a script.

## HTMX helper

`PUI.Htmx(Element As MiniHtml, Options As PUIHtmxOptions) As MiniHtml`

Applies typed `hx-*` attributes to an element that was built with any other component, then returns the
same element. The helper is a modifier, not a wrapper.

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Url` | String | required | Request URL; validated with `PUI.IsSafeUrl` |
| `Method` | String | `get` | `get`, `post`, `put`, `patch` or `delete` |
| `Target` | String | `""` | CSS selector for the swap target |
| `Swap` | String | `""` | `innerHTML`, `outerHTML`, `beforebegin`, `afterbegin`, `beforeend`, `afterend`, `delete` or `none` |
| `Trigger` | String | `""` | HTMX trigger expression (trusted developer value) |
| `Confirm` | String | `""` | Confirmation text, escaped |
| `Indicator` | String | `""` | CSS selector for a request indicator |
| `PushUrl` | Boolean | `False` | Adds `hx-push-url="true"` |

Rules:

- Unsafe or empty URLs are logged and no `hx-*` attributes are applied. The element still renders.
- Unsupported methods fall back to `get`; unsupported swaps are omitted so HTMX uses its default.
- The URL, target, confirm, indicator and trigger values are escaped at render time.
- `Trigger` is a trusted HTMX expression, like an Alpine expression. Never pass request data to it.

```b4j
Dim options As PUIHtmxOptions = PUI.NewHtmxOptions("/search")
options.Method = "post"
options.Target = "#results"
options.Swap = "innerHTML"
PUI.Htmx(form1, options)
```

## Alpine helper

`PUI.Alpine(Element As MiniHtml, Options As PUIAlpineOptions) As MiniHtml`

Applies typed Alpine attributes to an existing element and returns it.

| Option | Type | Attribute | Meaning |
| --- | --- | --- | --- |
| `Data` | String | `x-data` | Local state object |
| `Show` | String | `x-show` | Visibility expression |
| `Text` | String | `x-text` | Text binding |
| `Model` | String | `x-model` | Two-way input binding |
| `Click` | String | `x-on:click` | Click expression |
| `Init` | String | `x-init` | Initialization expression |
| `ClassName` | String | `x-bind:class` | Class binding expression |

**Trust boundary:** the expression fields are developer code, like `PUI.RawHtml`. They are escaped for
HTML, but Alpine evaluates the decoded attribute value. Never pass request data, user names or database
values to these fields. Put dynamic text inside normal escaped content and bind only to state names.

Static fallback: without Alpine the attributes do nothing. Content that is initially visible stays
visible, so local-state panels degrade to readable content. Avoid building content that exists only in an
Alpine template; PakaiUI does not use `x-cloak` or hidden Alpine templates.

```b4j
Dim state As PUIAlpineOptions = PUI.NewAlpineOptions
state.Data = "{ open: false }"
PUI.Alpine(card1, state)

Dim toggle As PUIAlpineOptions = PUI.NewAlpineOptions
toggle.Click = "open = !open"
PUI.Alpine(button1, toggle)

Dim panel As PUIAlpineOptions = PUI.NewAlpineOptions
panel.Show = "open"
PUI.Alpine(panel1, panel)
```

## Modal

`PUI.Modal(Options As PUIModalOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Id` | String | generated | Modal id, used as the trigger target |
| `Title` | String | `""` | Header title, escaped |
| `BodyText` | String | `""` | Escaped body text |
| `FooterText` | String | `""` | Escaped footer note |
| `CloseText` | String | `Close` via factory | Footer close button label; empty omits the button |
| `Size` | String | `""` | `sm`, `lg` or `xl` |
| `Scrollable` | Boolean | `False` | `modal-dialog-scrollable` |
| `Centered` | Boolean | `False` | `modal-dialog-centered` |
| `StaticBackdrop` | Boolean | `False` | Adds static backdrop and disables Escape |

Markup follows Bootstrap 5.3: `div.modal.fade > div.modal-dialog > div.modal-content`, with optional
header, body and footer. The title id is `<id>-label` and the modal points at it with `aria-labelledby`.
The close buttons use `data-bs-dismiss="modal"`; Bootstrap's JavaScript owns opening and closing.

After rendering, arbitrary content can be composed into `modal.ChildByClass("modal-body")`. The modal
root has no `hidden` attribute; Bootstrap's CSS hides `.modal` until JavaScript adds `.show`.

`PUI.ModalTrigger(Options As PUIModalTriggerOptions) As MiniHtml`

Options: `Text`, `Target` (id with or without `#`), `Variant`, `Size`, `ButtonType`, `Id`, `CssClass`,
`Disabled`, `Hidden`. Renders a normal `PUI.Button` plus `data-bs-toggle="modal"` and
`data-bs-target="#<target>"`. An empty target renders an inert button with a log message.

```b4j
Dim modalOptions As PUIModalOptions = PUI.NewModalOptions("Delete record?", "This cannot be undone.")
modalOptions.Id = "confirm-modal"
PUI.Modal(modalOptions).up(body1)

Dim triggerOptions As PUIModalTriggerOptions = PUI.NewModalTriggerOptions("Delete", "confirm-modal")
triggerOptions.Variant = PUI.VariantDanger
PUI.ModalTrigger(triggerOptions).up(body1)
```

## Toast

`PUI.Toast(Options As PUIToastOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Id` | String | `""` | Optional element id |
| `Title` | String | `""` | Header title, escaped |
| `Message` | String | `""` | Body text, escaped |
| `Variant` | String | `""` | Optional base variant (`text-bg-*`) |
| `Dismissible` | Boolean | `True` via factory | Adds a close button |
| `Autohide` | Boolean | `False` | Adds `data-bs-autohide`; Bootstrap JavaScript must initialize the toast |
| `DelayMs` | Int | `5000` | Autohide delay; values <= 0 fall back to 5000 |
| `CssClass` | String | `""` | Extra classes |
| `Hidden` | Boolean | `False` | Adds `hidden` |

The toast renders with `toast show`, `role="status"`, `aria-live="polite"` and `aria-atomic="true"`, so it
is readable even without JavaScript. Dismissal uses `data-bs-dismiss="toast"` and requires Bootstrap's
JavaScript. Colored variants use `btn-close-white` for the close button.

## Theme switcher

`PUI.ThemeSwitcher(Options As PUIThemeSwitcherOptions) As MiniHtml`

Options: `Current`, `AutoHref`, `LightHref`, `DarkHref`, `AriaLabel` (default `Theme`), `Size`, `Id`,
`CssClass`, `Hidden`.

Renders `div.btn-group[role=group]` with three link-style buttons: Auto, Light and Dark. The link matching
`Current` gets `active` and `aria-current="page"`. The factory defaults to `?theme=auto`,
`?theme=light` and `?theme=dark`, which work on the current page. Hrefs are validated like every other
URL; an unsafe href is omitted. The behavior owner is the server, so no JavaScript is needed.

```b4j
Dim themeOptions As PUIThemeSwitcherOptions = PUI.NewThemeSwitcherOptions(PUI.ThemeDark)
PUI.ThemeSwitcher(themeOptions).up(header1)
```

## Sidebar

`PUI.Sidebar(Options As PUISidebarOptions) As MiniHtml`

Options: `Brand`, `Href`, `Title`, `Items` (`PUINavItemOptions` list), `AriaLabel` (default `Sidebar`),
`Sticky`, `Border` (default `True`), `Id`, `CssClass`, `Hidden`.

Renders `aside.bg-body-tertiary.p-3` with an optional brand link, an optional section title and a vertical
`PUI.Nav` list. `Sticky` adds `sticky-top align-self-start`; `Border` adds `border-end`. Items keep the
M2 behavior: active `aria-current="page"`, disabled `aria-disabled` and `tabindex="-1"`, safe hrefs.

The sidebar is a static navigation surface and needs no JavaScript. It stacks above content on narrow
screens when placed in a Bootstrap row/column layout; no collapse script is required.

## Script and asset loading

```b4j
PUI.Script(body1, "/assets/js/bootstrap.min.js?v=5.3.8", True)
PUI.Script(body1, "/assets/js/htmx.min.js?v=2.0.8", True)
PUI.Script(body1, "/assets/js/alpine.min.js?v=3.15.8", True)
```

Tracked files and SHA-256 hashes are recorded in `assets/README.md` and `assets/res.json`. Alpine.js is
MIT licensed; its license is tracked at `assets/js/LICENSE/alpine/LICENSE.md`.

## Accessibility summary

- Modals use `aria-labelledby` for the title, `aria-hidden="true"` initially, and labelled close buttons.
- Toasts use `role="status"`, `aria-live="polite"` and `aria-atomic="true"`.
- The theme group has `role="group"` and an accessible name; the active choice carries `aria-current`.
- Sidebar navigation reuses the M2 nav semantics and accessible name.
- HTMX and Alpine helpers never replace native elements: use real buttons, links and forms so keyboard
  and assistive-technology behavior remains correct.
- Without enhancement scripts, all rendered text remains readable and escaped.

## Dependencies

- Bootstrap CSS 5.3.8 for modal, toast, theme button group, sidebar and all M1-M3 components.
- Bootstrap JavaScript 5.3.8 only for modal open/close and toast dismissal/autohide.
- HTMX 2.0.8 only when `PUI.Htmx` attributes are used.
- Alpine.js 3.15.8 only when `PUI.Alpine` attributes are used.
- No MiniJS, MiniCSS or Pakai Server dependency.

## Verification

Executed on 2026-10-29 with PakaiUI 0.14 (b4xlib SHA-256
`EB0820714D64B59AE10A5FC9720CDDC488A96F940A0907A241F0E6F2B561544C`):

| Check | Result |
| --- | --- |
| M4 interaction tests | PASS - 162 passed, 0 failed, exit code 0 |
| M3 form/data-display regression | PASS - 203 passed, 0 failed, exit code 0 |
| M2 component regression | PASS - 135 passed, 0 failed, exit code 0 |
| M1 foundation regression | PASS - 35 passed, 0 failed, exit code 0 |
| M0 proof of concept regression | PASS - 28 passed, 0 failed, exit code 0 |
| Library smoke test | PASS - `PakaiUI v0.14 smoke test`, exit code 0 |
| Gallery: section and ids | PASS - 33 ids, no duplicates; 12 labels, 0 broken `for` targets |
| Gallery: assets loaded | PASS - Bootstrap JS, HTMX 2.0.8 and Alpine 3.15.8 present |
| Alpine toggle and counter | PASS - panel hidden at init, opens on click; count becomes 1 |
| Bootstrap modal | PASS - opens with `.show` and `modal-open`, closes from the header button |
| Bootstrap toast | PASS - visible initially, dismissed by the close button |
| Theme switcher | PASS - Dark link loads `?theme=dark` with `data-bs-theme="dark"` and Dark active; Auto restores no theme and the Auto link |
| HTMX helper form | PASS - POST `/hx/echo`, target updated, hostile input rendered escaped |
| HTMX baseline after M4 | PASS - ping, POST echo and outerHTML swap still work; no console errors |
| Gallery layout | PASS - no horizontal page overflow |
