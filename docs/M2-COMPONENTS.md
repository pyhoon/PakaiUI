# PakaiUI M2 component reference

Version 0.12. This document describes the core component set added in M2. All components return a
`MiniHtml` element, so they compose through `up`, `down` and `add`. Text and attribute values are escaped
by default; raw HTML is only possible through `PUI.RawHtml` / `PUI.AddHtml`.

## Conventions

- Options types are prefixed with `PUI` because B4X types share a global namespace.
- `Hidden` is used instead of `Visible`, so a default `False` value means "shown".
- Base variants (`primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, `dark`) are
  valid for Badge, Alert and LoadingState. Outline and link variants are button-only; unsupported values
  are logged and fall back to `primary`.
- `Id` and `CssClass` are applied to the component root unless the component documentation says
  otherwise. `CssClass` is an escape hatch, not the primary configuration API.
- Unknown variants, unsafe URLs and unsupported sizes are logged and degrade safely. They never render
  unescaped input.

## Badge

`PUI.Badge(Options As PUIBadgeOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Text` | String | `""` | Short label, escaped |
| `Variant` | String | `primary` | `text-bg-*` base variant |
| `Pill` | Boolean | `False` | Adds `rounded-pill` |
| `Id` | String | `""` | Optional element id |
| `CssClass` | String | `""` | Extra classes |
| `Hidden` | Boolean | `False` | Adds `hidden` |

Markup: `<span class="badge text-bg-primary">Text</span>`.

## Alert

`PUI.Alert(Options As PUIAlertOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Title` | String | `""` | Optional `h4.alert-heading`, escaped |
| `Message` | String | `""` | Optional message paragraph, escaped |
| `Variant` | String | `primary` | `alert-*` base variant |
| `Dismissible` | Boolean | `False` | Adds the close button and animation classes |
| `Id` | String | `""` | Optional element id |
| `CssClass` | String | `""` | Extra classes |
| `Hidden` | Boolean | `False` | Adds `hidden` |

Markup: `<div class="alert alert-primary" role="alert">...</div>`.

A dismissible alert renders `alert-dismissible fade show` and
`<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close">`. This is the only
M2 behavior that needs Bootstrap's JavaScript. Without it the button is inert, but the alert content
remains readable.

## Card extensions

`PUI.Card(Options As PUICardOptions) As MiniHtml`

M2 adds four fields at the end of `PUICardOptions`:

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `HeaderText` | String | `""` | Optional `card-header`, escaped |
| `ImageSrc` | String | `""` | Optional top image; unsafe URLs are omitted |
| `ImageAlt` | String | `""` | Image alternative text, escaped |
| `Hidden` | Boolean | `False` | Adds `hidden` |

Render order: top image, header, body (title/subtitle/body text), footer. For nested content, use the
`CardHeader`, `CardBody`, `CardFooter`, `CardTitle` and `CardText` part factories.

## Breadcrumb

`PUI.Breadcrumb(Options As PUIBreadcrumbOptions) As MiniHtml`

`PUIBreadcrumbOptions`: `Items As List`, `AriaLabel` (default `breadcrumb`), `Id`, `CssClass`, `Hidden`.

Each item is a `PUIBreadcrumbItem` created with `PUI.NewBreadcrumbItem(Text, Href)` and may set `Active`.
Active items render as text with `class="breadcrumb-item active"` and `aria-current="page"`; they never
emit a link even when `Href` is set. Unsafe item URLs are logged and rendered as text.

Markup: `<nav aria-label="breadcrumb"><ol class="breadcrumb">...</ol></nav>`.

## Page header

`PUI.PageHeader(Options As PUIPageHeaderOptions) As MiniHtml`

Options: `Title`, `Subtitle`, `Id`, `CssClass`, `Hidden`.

Markup: `<header class="pb-2 mb-4 border-bottom"><h1 class="h3">...</h1><p class="text-body-secondary mb-0">...</p></header>`.
The subtitle paragraph is omitted when `Subtitle` is empty.

## Navigation

### Nav

`PUI.Nav(Options As PUINavOptions) As MiniHtml`

Options: `Items As List`, `Pills`, `Tabs`, `Vertical`, `AriaLabel`, `Id`, `CssClass`, `Hidden`.

Renders `<ul class="nav">` with `nav-tabs` or `nav-pills`, plus `flex-column` when vertical. Tabs take
precedence when both `Pills` and `Tabs` are set. Each entry in `Items` is rendered with `PUI.NavItem`.

### NavItem

`PUI.NavItem(Options As PUINavItemOptions) As MiniHtml`

Options: `Text`, `Href`, `Active`, `Disabled`, `Id`, `CssClass`, `Hidden`.

Renders `<li class="nav-item">` with either `<a class="nav-link">` or, when there is no safe `Href`, a
`<span class="nav-link">`. `Id` and `CssClass` apply to the link; `Hidden` hides the list item. Active
links keep their `href` and add `aria-current="page"`. Disabled links add `disabled`, `aria-disabled="true"`
and `tabindex="-1"`. Unsafe URLs are logged and replaced by a span.

### Navbar

`PUI.Navbar(Options As PUINavbarOptions) As MiniHtml`

Options: `Brand`, `Href`, `Items As List`, `Breakpoint` (default `md`), `AriaLabel` (default
`Main navigation`), `Id`, `CssClass`, `Hidden`.

Markup: `<nav class="navbar navbar-expand-md bg-body-tertiary flex-wrap" aria-label="Main navigation">`
with a `container-fluid`, an optional brand link and a `ul.navbar-nav`. There is no collapse toggler, so
items remain visible and wrap on narrow screens without JavaScript. The brand URL is validated like any
other URL.

## Empty state

`PUI.EmptyState(Options As PUIEmptyStateOptions) As MiniHtml`

Options: `Title`, `Message`, `IconClass` (for example `bi-inbox`), `ActionText`, `ActionHref`, `Id`,
`CssClass`, `Hidden`.

Markup: `<div class="text-center py-5">` with an optional Bootstrap Icons `<i aria-hidden="true">`, an
`h2.h4` title, a secondary message paragraph and an optional action. The action is a standard
`PUI.Button`; it is only rendered when `ActionText` is set and uses `ActionHref` when one is provided.
HTMX attributes can be attached to the action button after rendering.

## Loading state

`PUI.LoadingState(Options As PUILoadingStateOptions) As MiniHtml`

Options: `Text`, `Size`, `Variant`, `Centered`, `Id`, `CssClass`, `Hidden`.

Markup: `<div class="d-flex align-items-center gap-2" role="status">` containing
`<div class="spinner-border text-primary" aria-hidden="true">` and a label. `SizeSmall` adds
`spinner-border-sm`; Bootstrap 5.3 has no large spinner, so other sizes are logged and ignored. When
`Text` is empty the label is `visually-hidden` with `Loading...`, so the state remains announced to
assistive technology. `Centered` adds `justify-content-center`.

## Accessibility summary

- Dismissible alerts expose `role="alert"` and a labelled close button.
- Breadcrumb active items use `aria-current="page"` and are not links.
- Nav and navbar expose an accessible name; active links use `aria-current="page"`, disabled links use
  `aria-disabled="true"` and `tabindex="-1"`.
- Loading states use `role="status"` and always provide a text label for screen readers.
- Decorative icons are marked `aria-hidden="true"`.
- All user-provided text and attribute values are escaped.

## Dependencies

- Bootstrap CSS 5.3.8 for the classes above (tracked in `assets/css`).
- Bootstrap Icons 1.13.1 only when `EmptyState` uses an icon.
- Bootstrap JavaScript 5.3.8 only for dismissing an `Alert` with `Dismissible = True`.
- No HTMX, Alpine.js, MiniJS, MiniCSS or Pakai Server dependency.

## Verification

Executed on 2026-10-29 with PakaiUI 0.12 (b4xlib SHA-256
`D65F791502A17A297F1AD78FFFD159170D2594CC7960EE034A268845079DF576`):

| Check | Result |
| --- | --- |
| M2 component tests | PASS - 135 passed, 0 failed, exit code 0 |
| M1 foundation regression | PASS - 35 passed, 0 failed, exit code 0 |
| M0 proof of concept regression | PASS - 28 passed, 0 failed, exit code 0 |
| Gallery renders every M2 component | PASS - 3 badges, 2 alerts, 1 breadcrumb, 1 nav, 1 navbar, 1 page header, 1 empty state, 1 spinner |
| Gallery browser console | PASS - no errors |
| Dismissible alert with Bootstrap JS | PASS - alert count 2 -> 1 after clicking the close button |
| Navbar wrapping without JavaScript | PASS - computed `flex-wrap: wrap`, brand and items fit the card |
| M1 HTMX baseline after M2 | PASS - unchanged and recorded in `docs/M0-RECONNAISSANCE.md` section 9 |
