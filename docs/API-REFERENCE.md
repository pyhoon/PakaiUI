# PakaiUI public API reference

Version 0.16. This is the complete public surface of the `PUI` static module and its option types.
Component behavior, markup and accessibility notes live in:

- [`M2-COMPONENTS.md`](M2-COMPONENTS.md) - badges, alerts, cards, breadcrumbs, headers, navigation, states
- [`M3-FORMS.md`](M3-FORMS.md) - form controls, validation, tables, pagination, filter bar
- [`M4-INTERACTIONS.md`](M4-INTERACTIONS.md) - HTMX/Alpine helpers, modal, toast, theme switcher, sidebar
- [`PAKAI-SERVER-INTEGRATION.md`](PAKAI-SERVER-INTEGRATION.md) - optional Pakai Server/EndsMeet host

All components return `MiniHtml` and compose through `up`, `down` and `add`. Text and attribute values
are escaped by default. Raw HTML is possible only through `PUI.RawHtml` / `PUI.AddHtml`.

## Conventions

- Options types are prefixed with `PUI` because B4X types share a global namespace.
- `Hidden` replaces `Visible`, so the default `False` means "shown".
- `Type` and `Select` are reserved B4X words: `ButtonType`, `InputType`, `PUI.SelectField`.
- `Id` and `CssClass` apply to the component root unless the component documentation states otherwise.
  Form controls apply `Id` to the control and `CssClass`/`Hidden` to the field group.
- Unknown variants, unsafe URLs and unsupported sizes are logged and degrade safely.

## Core facade

| Method | Purpose |
| --- | --- |
| `Initialize` | Reserved for future library-wide configuration; never starts a server or changes global state |
| `EscapeHtml(Raw As String) As String` | Escapes `&`, `<`, `>`, `"` and `'` |
| `RawHtml(Html As String) As MiniHtml` | Trusted HTML fragment; explicit and never used for user input |
| `AddText(Parent As MiniHtml, Value As String) As MiniHtml` | Appends escaped text and returns `Parent` |
| `AddHtml(Parent As MiniHtml, Html As String) As MiniHtml` | Appends trusted HTML and returns `Parent` |
| `IsSafeUrl(Url As String) As Boolean` | Allows relative URLs plus `http`, `https`, `mailto`, `tel` |

## Page and layout primitives

| Method | Purpose |
| --- | --- |
| `Document(Options As PUIPageOptions) As MiniHtml` | HTML5 document with charset, viewport, title, optional description and theme |
| `Head(Doc As MiniHtml) As MiniHtml` | Returns the document `<head>` |
| `Body(Doc As MiniHtml) As MiniHtml` | Returns the document `<body>` |
| `StyleSheet(Parent As MiniHtml, Href As String) As MiniHtml` | Appends `<link rel="stylesheet">` |
| `MetaDescription(Parent As MiniHtml, Content As String) As MiniHtml` | Appends the description meta tag |
| `Script(Parent As MiniHtml, Src As String, Defer As Boolean) As MiniHtml` | Appends a `src`-only script tag, optionally deferred |
| `Container(Options As PUIContainerOptions) As MiniHtml` | `container`, `container-fluid` or `container-{breakpoint}` |
| `Row(Options As PUIRowOptions) As MiniHtml` | Bootstrap row |
| `Col(Options As PUIColOptions) As MiniHtml` | Bootstrap column with breakpoint/width/auto |

## Components

### M0-M2

| Method | Purpose |
| --- | --- |
| `Button(Options As PUIButtonOptions) As MiniHtml` | `<button>` or link-style `<a>`; variants, sizes, disabled/hidden |
| `Card(Options As PUICardOptions) As MiniHtml` | Card with optional image, header, title/subtitle/body and footer |
| `CardHeader As MiniHtml` | Empty `div.card-header` slot |
| `CardBody As MiniHtml` | Empty `div.card-body` slot |
| `CardFooter As MiniHtml` | Empty `div.card-footer` slot |
| `CardTitle As MiniHtml` | Empty `h5.card-title` slot |
| `CardText As MiniHtml` | Empty `p.card-text` slot |
| `Badge(Options As PUIBadgeOptions) As MiniHtml` | `span.badge` with base variant, optional pill |
| `Alert(Options As PUIAlertOptions) As MiniHtml` | Contextual alert with optional title and dismiss button |
| `Breadcrumb(Options As PUIBreadcrumbOptions) As MiniHtml` | Breadcrumb list with active, non-link current item |
| `PageHeader(Options As PUIPageHeaderOptions) As MiniHtml` | Bordered page title with optional subtitle |
| `Nav(Options As PUINavOptions) As MiniHtml` | Nav list with pills/tabs/vertical options |
| `NavItem(Options As PUINavItemOptions) As MiniHtml` | Nav list item with active/disabled states |
| `Navbar(Options As PUINavbarOptions) As MiniHtml` | JavaScript-free navbar that wraps, with optional brand |
| `EmptyState(Options As PUIEmptyStateOptions) As MiniHtml` | Icon/title/message panel with optional action |
| `LoadingState(Options As PUILoadingStateOptions) As MiniHtml` | Accessible spinner with label |

### M3 forms and data display

| Method | Purpose |
| --- | --- |
| `Input(Options As PUIInputOptions) As MiniHtml` | Labelled input with help/error, types, sizes and states |
| `Textarea(Options As PUITextareaOptions) As MiniHtml` | Labelled textarea with rows and escaped text content |
| `SelectField(Options As PUISelectOptions) As MiniHtml` | Labelled select, placeholder, single/multiple selection |
| `Checkbox(Options As PUICheckboxOptions) As MiniHtml` | Checkbox with inline/switch options |
| `Radio(Options As PUIRadioOptions) As MiniHtml` | Radio with inline option |
| `Table(Options As PUITableOptions) As MiniHtml` | Responsive table from columns and List-of-Map rows |
| `Pagination(Options As PUIPaginationOptions) As MiniHtml` | Pattern-based pagination with window and ellipses |
| `FilterBar(Options As PUIFilterBarOptions) As MiniHtml` | Search form shell for composing filter controls |

### M4 optional interactions

| Method | Purpose |
| --- | --- |
| `Htmx(Element As MiniHtml, Options As PUIHtmxOptions) As MiniHtml` | Applies validated `hx-*` attributes to an element |
| `Alpine(Element As MiniHtml, Options As PUIAlpineOptions) As MiniHtml` | Applies typed `x-*` attributes to an element |
| `Modal(Options As PUIModalOptions) As MiniHtml` | Bootstrap modal markup |
| `ModalTrigger(Options As PUIModalTriggerOptions) As MiniHtml` | Button that opens a modal by id |
| `Toast(Options As PUIToastOptions) As MiniHtml` | Visible Bootstrap toast |
| `ThemeSwitcher(Options As PUIThemeSwitcherOptions) As MiniHtml` | Server-side Auto/Light/Dark link group |
| `Sidebar(Options As PUISidebarOptions) As MiniHtml` | Static aside with brand, title and vertical nav |

## Option factories

Exact signatures:

```b4j
NewButtonOptions (Text As String) As PUIButtonOptions
NewCardOptions (Title As String, BodyText As String) As PUICardOptions
NewPageOptions (Title As String) As PUIPageOptions
NewContainerOptions As PUIContainerOptions
NewRowOptions As PUIRowOptions
NewColOptions As PUIColOptions
NewBadgeOptions (Text As String) As PUIBadgeOptions
NewAlertOptions (Message As String) As PUIAlertOptions
NewBreadcrumbItem (Text As String, Href As String) As PUIBreadcrumbItem
NewBreadcrumbOptions As PUIBreadcrumbOptions
NewPageHeaderOptions (Title As String) As PUIPageHeaderOptions
NewNavItemOptions (Text As String, Href As String) As PUINavItemOptions
NewNavOptions As PUINavOptions
NewNavbarOptions (Brand As String) As PUINavbarOptions
NewEmptyStateOptions (Title As String, Message As String) As PUIEmptyStateOptions
NewLoadingStateOptions (Text As String) As PUILoadingStateOptions
NewInputOptions (Label As String, Name As String) As PUIInputOptions
NewTextareaOptions (Label As String, Name As String) As PUITextareaOptions
NewSelectItem (Text As String, Value As String) As PUISelectItem
NewSelectOptions (Label As String, Name As String) As PUISelectOptions
NewCheckboxOptions (Label As String) As PUICheckboxOptions
NewRadioOptions (Label As String) As PUIRadioOptions
NewTableColumn (Title As String, Field As String) As PUITableColumn
NewTableOptions As PUITableOptions
NewTableRow As Map
NewPaginationOptions (CurrentPage As Int, TotalPages As Int, HrefPattern As String) As PUIPaginationOptions
NewFilterBarOptions As PUIFilterBarOptions
NewHtmxOptions (Url As String) As PUIHtmxOptions
NewAlpineOptions As PUIAlpineOptions
NewModalOptions (Title As String, BodyText As String) As PUIModalOptions
NewModalTriggerOptions (Text As String, Target As String) As PUIModalTriggerOptions
NewToastOptions (Message As String) As PUIToastOptions
NewThemeSwitcherOptions (Current As String) As PUIThemeSwitcherOptions
NewSidebarOptions (Brand As String) As PUISidebarOptions
```

## Option types

Exact declarations from `source/PUI.bas`:

```b4j
Type PUIButtonOptions (Text As String, Variant As String, Size As String, ButtonType As String, Href As String, Id As String, CssClass As String, Disabled As Boolean, Hidden As Boolean)
Type PUICardOptions (Title As String, Subtitle As String, BodyText As String, FooterText As String, Id As String, CssClass As String, HeaderText As String, ImageSrc As String, ImageAlt As String, Hidden As Boolean)

Type PUIPageOptions (Title As String, Description As String, Lang As String, Theme As String, BodyCssClass As String)
Type PUIContainerOptions (Id As String, CssClass As String, Breakpoint As String, Fluid As Boolean, Hidden As Boolean)
Type PUIRowOptions (Id As String, CssClass As String, Hidden As Boolean)
Type PUIColOptions (Id As String, CssClass As String, Breakpoint As String, Width As Int, Auto As Boolean, Hidden As Boolean)

Type PUIBadgeOptions (Text As String, Variant As String, Pill As Boolean, Id As String, CssClass As String, Hidden As Boolean)
Type PUIAlertOptions (Title As String, Message As String, Variant As String, Dismissible As Boolean, Id As String, CssClass As String, Hidden As Boolean)
Type PUIBreadcrumbItem (Text As String, Href As String, Active As Boolean)
Type PUIBreadcrumbOptions (Items As List, AriaLabel As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUIPageHeaderOptions (Title As String, Subtitle As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUINavItemOptions (Text As String, Href As String, Active As Boolean, Disabled As Boolean, Id As String, CssClass As String, Hidden As Boolean)
Type PUINavOptions (Items As List, Pills As Boolean, Tabs As Boolean, Vertical As Boolean, AriaLabel As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUINavbarOptions (Brand As String, Href As String, Items As List, Breakpoint As String, AriaLabel As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUIEmptyStateOptions (Title As String, Message As String, IconClass As String, ActionText As String, ActionHref As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUILoadingStateOptions (Text As String, Size As String, Variant As String, Centered As Boolean, Id As String, CssClass As String, Hidden As Boolean)

Type PUIInputOptions (Label As String, Name As String, Id As String, Value As String, Placeholder As String, InputType As String, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, ReadOnly As Boolean, CssClass As String, Hidden As Boolean)
Type PUITextareaOptions (Label As String, Name As String, Id As String, Value As String, Placeholder As String, Rows As Int, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, ReadOnly As Boolean, CssClass As String, Hidden As Boolean)
Type PUISelectItem (Text As String, Value As String, Selected As Boolean, Disabled As Boolean)
Type PUISelectOptions (Label As String, Name As String, Id As String, Items As List, SelectedValue As String, Placeholder As String, Multiple As Boolean, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
Type PUICheckboxOptions (Label As String, Name As String, Id As String, Value As String, Checked As Boolean, Inline As Boolean, Switch As Boolean, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
Type PUIRadioOptions (Label As String, Name As String, Id As String, Value As String, Checked As Boolean, Inline As Boolean, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
Type PUITableColumn (Title As String, Field As String, Align As String)
Type PUITableOptions (Columns As List, Rows As List, Caption As String, EmptyText As String, RowIdField As String, Responsive As Boolean, Striped As Boolean, Hover As Boolean, Bordered As Boolean, Compact As Boolean, Id As String, CssClass As String, Hidden As Boolean)
Type PUIPaginationOptions (CurrentPage As Int, TotalPages As Int, HrefPattern As String, AriaLabel As String, Size As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUIFilterBarOptions (Action As String, Method As String, AriaLabel As String, Id As String, CssClass As String, Hidden As Boolean)

Type PUIHtmxOptions (Url As String, Method As String, Target As String, Swap As String, Trigger As String, Confirm As String, Indicator As String, PushUrl As Boolean)
Type PUIAlpineOptions (Data As String, Show As String, Text As String, Model As String, Click As String, Init As String, ClassName As String)
Type PUIModalOptions (Id As String, Title As String, BodyText As String, FooterText As String, CloseText As String, Size As String, Scrollable As Boolean, Centered As Boolean, StaticBackdrop As Boolean)
Type PUIModalTriggerOptions (Text As String, Target As String, Variant As String, Size As String, ButtonType As String, Id As String, CssClass As String, Disabled As Boolean, Hidden As Boolean)
Type PUIToastOptions (Id As String, Title As String, Message As String, Variant As String, Dismissible As Boolean, Autohide As Boolean, DelayMs As Int, CssClass As String, Hidden As Boolean)
Type PUIThemeSwitcherOptions (Current As String, LightHref As String, DarkHref As String, AutoHref As String, AriaLabel As String, Size As String, Id As String, CssClass As String, Hidden As Boolean)
Type PUISidebarOptions (Brand As String, Href As String, Title As String, Items As List, AriaLabel As String, Sticky As Boolean, Border As Boolean, Id As String, CssClass As String, Hidden As Boolean)
```

## Constants

| Group | Values |
| --- | --- |
| Version | `VERSION = "0.16"` |
| Variants | `VariantPrimary`, `VariantSecondary`, `VariantSuccess`, `VariantDanger`, `VariantWarning`, `VariantInfo`, `VariantLight`, `VariantDark`, `VariantLink` |
| Outline variants | `VariantOutlinePrimary`, `VariantOutlineSecondary`, `VariantOutlineSuccess`, `VariantOutlineDanger`, `VariantOutlineWarning`, `VariantOutlineInfo`, `VariantOutlineLight`, `VariantOutlineDark` |
| Sizes | `SizeSmall = "sm"`, `SizeDefault = ""`, `SizeLarge = "lg"` |
| Themes | `ThemeAuto = ""`, `ThemeLight = "light"`, `ThemeDark = "dark"` |
| Table alignment | `AlignStart = "start"`, `AlignCenter = "center"`, `AlignEnd = "end"` |

## Composition and ids

- `parent.down(child)` attaches a child and returns the child; `parent.up(grandparent)` attaches upward.
- `PUI.Card` exposes named slots (`CardHeader`, `CardBody`, ...) for nested content.
- Form controls derive an id from `Name` when `Id` is empty; checkboxes/radios include `Value`, because
  several choices share a name. Set `Id` explicitly when a fixed id is required.
- `PUI.Modal` generates an id when none is supplied; read it from the returned root to build a trigger.

## Verification

The public surface above is exercised by 563 assertions across M0-M4 plus the M5 build/gallery checks;
see [`COMPATIBILITY.md`](COMPATIBILITY.md) for versions and evidence.
