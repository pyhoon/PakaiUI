# PakaiUI M3 forms and data display

Version 0.13. This document describes the form and data-display components added in M3. All components
return a `MiniHtml` element, so they compose through `up`, `down` and `add`. Text and attribute values are
escaped by default; raw HTML is only possible through `PUI.RawHtml` / `PUI.AddHtml`.

## Conventions

- Options types are prefixed with `PUI` because B4X types share a global namespace.
- `Hidden` is used instead of `Visible`, so a default `False` value means "shown".
- Field groups render their own label, control, help text and error text, so a form can be built without
  hand-written markup.
- `CssClass` and `Hidden` apply to the field-group root. For form controls, `Id` is the **control** id
  (not the group id) so the label's `for` attribute always resolves.
- When `Id` is empty, a stable id is derived from `Name` (`pui-<name>`). Checkbox and radio ids also
  include `Value` (`pui-<name>-<value>`) because several choices share one name. If both `Id` and `Name`
  are empty, a counter-based id is generated. Set `Id` explicitly when a specific id is required.
- `PUI.Select` cannot be declared because `Select` is a reserved B4X keyword; the component is
  `PUI.SelectField`.
- Help and error text are plain escaped text. A server-side message cannot inject markup.

## Input

`PUI.Input(Options As PUIInputOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Label` | String | `""` | Label text, escaped |
| `Name` | String | `""` | Form field name |
| `Id` | String | `""` | Control id; derived from `Name` when empty |
| `Value` | String | `""` | Current value, escaped |
| `Placeholder` | String | `""` | Placeholder, escaped |
| `InputType` | String | `text` | HTML input type (`text`, `email`, `password`, `number`, `search`, `url`, `tel`, `date`, `datetime-local`, `month`, `week`, `time`) |
| `Size` | String | `""` | `sm` or `lg` (`form-control-sm` / `form-control-lg`) |
| `HelpText` | String | `""` | Helper text (`div.form-text`) |
| `ErrorText` | String | `""` | Validation message (`div.invalid-feedback`) |
| `Required` | Boolean | `False` | Adds `required` and a visual asterisk on the label |
| `Disabled` | Boolean | `False` | Adds `disabled` |
| `ReadOnly` | Boolean | `False` | Adds `readonly` |
| `CssClass` | String | `""` | Extra classes on the field group |
| `Hidden` | Boolean | `False` | Adds `hidden` to the field group |

Unsupported input types are logged and rendered as `text`; they are never passed through unchecked.

Markup:

```html
<div class="mb-3">
  <label class="form-label" for="email-field">Email <span class="text-danger" aria-hidden="true"> *</span></label>
  <input type="email" class="form-control" id="email-field" name="email" required>
  <div class="form-text" id="email-field-help">Never shared.</div>
</div>
```

## Textarea

`PUI.Textarea(Options As PUITextareaOptions) As MiniHtml`

Options: `Label`, `Name`, `Id`, `Value`, `Placeholder`, `Rows`, `Size`, `HelpText`, `ErrorText`,
`Required`, `Disabled`, `ReadOnly`, `CssClass`, `Hidden`.

`Rows` defaults to 3. Values below 1 fall back to 3 and values above 50 are clamped to 50 (logged).
`Value` is rendered as escaped text content, so markup in it stays literal.

## SelectField

`PUI.SelectField(Options As PUISelectOptions) As MiniHtml`

`PUISelectOptions`: `Label`, `Name`, `Id`, `Items As List`, `SelectedValue`, `Placeholder`, `Multiple`,
`Size`, `HelpText`, `ErrorText`, `Required`, `Disabled`, `CssClass`, `Hidden`.

Each item is a `PUISelectItem` created with `PUI.NewSelectItem(Text, Value)`; it also has `Selected` and
`Disabled` fields. An empty item `Value` falls back to the item `Text`, so every option submits something
useful. `Placeholder` renders an empty-value option and is selected when no value is chosen.

- Single select: set `SelectedValue` to the item value to select. `SelectedValue` wins when set; an item's
  `Selected` flag is honored only when `SelectedValue` is empty.
- Multiple select: set `Multiple = True` and `Selected = True` on each selected item.
- The placeholder is selected only when no value and no item is selected.

Markup:

```html
<div class="mb-3">
  <label class="form-label" for="status-field">Status</label>
  <select class="form-select" id="status-field" name="status">
    <option value="">Choose a status</option>
    <option value="active">Active</option>
    <option value="archived">Archived</option>
  </select>
</div>
```

## Checkbox and Radio

`PUI.Checkbox(Options As PUICheckboxOptions) As MiniHtml`

Options: `Label`, `Name`, `Id`, `Value`, `Checked`, `Inline`, `Switch`, `HelpText`, `ErrorText`,
`Required`, `Disabled`, `CssClass`, `Hidden`.

`PUI.Radio(Options As PUIRadioOptions) As MiniHtml`

Options: `Label`, `Name`, `Id`, `Value`, `Checked`, `Inline`, `HelpText`, `ErrorText`, `Required`,
`Disabled`, `CssClass`, `Hidden`. Radios never render `Switch`.

- `Inline` adds `form-check-inline` for filter rows.
- `Switch` adds `form-switch` (checkbox only).
- `Checked` is explicit because a missing B4X boolean defaults to `False`.
- Radios in one group share `Name`; set `Checked` on one of them.

Markup: `<div class="form-check"><input class="form-check-input" type="checkbox" id="..." checked>
<label class="form-check-label" for="...">Label</label></div>`.

## Validation feedback

There is no separate validation component. Every field group supports:

- `HelpText` -> `<div class="form-text" id="<id>-help">`, referenced by `aria-describedby`.
- `ErrorText` -> `<div class="invalid-feedback" id="<id>-error">`, plus `is-invalid` and
  `aria-invalid="true"` on the control, also referenced by `aria-describedby`.

Bootstrap's CSS shows `.invalid-feedback` when the sibling control has `.is-invalid`, so error messages
are visible on the server-rendered page without JavaScript. Empty `ErrorText` removes all invalid state.

`Required` adds the native `required` attribute, so the browser's own validation still works if scripts
are disabled. PakaiUI never validates business rules itself.

## Table

`PUI.Table(Options As PUITableOptions) As MiniHtml`

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `Columns` | List | empty | `PUITableColumn` entries |
| `Rows` | List | empty | `Map` entries keyed by column `Field` |
| `Caption` | String | `""` | Optional caption, escaped; rendered at the top |
| `EmptyText` | String | `No data.` | Message when there are no rows |
| `RowIdField` | String | `""` | Optional map field copied to `<tr id>` |
| `Responsive` | Boolean | `True` | Wraps the table in `div.table-responsive` |
| `Striped` | Boolean | `False` | `table-striped` |
| `Hover` | Boolean | `False` | `table-hover` |
| `Bordered` | Boolean | `False` | `table-bordered` |
| `Compact` | Boolean | `False` | `table-sm` |
| `Id` | String | `""` | Id on the component root |
| `CssClass` | String | `""` | Extra classes on the component root |
| `Hidden` | Boolean | `False` | Adds `hidden` to the component root |

A column is created with `PUI.NewTableColumn(Title, Field)` and has `Align` (`PUI.AlignStart`,
`PUI.AlignCenter`, `PUI.AlignEnd`; `left`/`right` are accepted aliases). Alignment classes are applied to
both the header cell and the body cells.

Rows are ordinary B4X maps (`PUI.NewTableRow` returns an initialized map). Values are converted to text
and escaped; `Null` values and missing keys render an empty cell. Row ids are escaped but not modified, so
`RowIdField` values should be valid HTML ids.

When `Responsive` is set the returned root is the `div.table-responsive` wrapper; otherwise it is the
`<table>` itself. `Id`, `CssClass` and `Hidden` always apply to the root.

With no rows the body contains one full-width cell (`colspan` = column count) with `EmptyText`.

Sorting, filtering and HTMX row updates are deliberately not part of the table; they compose around it.

## Pagination

`PUI.Pagination(Options As PUIPaginationOptions) As MiniHtml`

Options: `CurrentPage`, `TotalPages`, `HrefPattern`, `AriaLabel` (default `Page navigation`), `Size`,
`Id`, `CssClass`, `Hidden`.

- `HrefPattern` must contain `{page}`, for example `/items?page={page}&sort=name`.
- Pages outside `1..TotalPages` are clamped; `TotalPages < 1` is treated as one page.
- Up to seven pages are shown in full. More than that keeps the first and last page, a five-page window
  around the current page, and `...` gaps.
- Previous/Next are disabled at the boundaries and use `Previous` / `Next` text.
- The current page is a `span.page-link` inside `li.page-item.active` with `aria-current="page"`.
- Every URL is escaped and checked with `PUI.IsSafeUrl`; unsafe patterns or a missing `{page}` render
  page numbers as text instead of links.
- `Size` accepts `sm` or `lg`.

Markup:

```html
<nav aria-label="Page navigation">
  <ul class="pagination">
    <li class="page-item disabled"><span class="page-link">Previous</span></li>
    <li class="page-item active" aria-current="page"><span class="page-link">1</span></li>
    <li class="page-item"><a class="page-link" href="/items?page=2">2</a></li>
    <li class="page-item"><a class="page-link" href="/items?page=2">Next</a></li>
  </ul>
</nav>
```

## FilterBar

`PUI.FilterBar(Options As PUIFilterBarOptions) As MiniHtml`

Options: `Action`, `Method` (default `get`; `post` also accepted), `AriaLabel` (default `Filters`), `Id`,
`CssClass`, `Hidden`.

Renders a `<form role="search">` with `row row-cols-lg-auto g-2 align-items-center mb-3` and returns the
form element. Append fields and a submit button:

```b4j
Dim filterOptions As PUIFilterBarOptions = PUI.NewFilterBarOptions
filterOptions.Action = "/search"
Dim form1 As MiniHtml = PUI.FilterBar(filterOptions)
PUI.Input(PUI.NewInputOptions("Search", "q")).up(form1)
PUI.Button(buttonWithTypeSubmit).up(form1)
```

The action URL is validated; unsafe values are logged and omitted (the form then submits to the current
URL). Unsupported methods fall back to `get` with a log message. A submit button must set
`ButtonType = "submit"`; `PUI.Button` defaults to `type="button"`.

## Accessibility summary

- Every control with a label has a matching `for`/`id` pair; ids are derived when not supplied.
- `HelpText` and `ErrorText` are linked with `aria-describedby`; invalid controls use
  `aria-invalid="true"` and Bootstrap's `is-invalid` class.
- Required controls use the native `required` attribute; the label asterisk is decorative.
- Disabled and read-only states use native attributes.
- Tables use `<caption>` (optional), `<th scope="col">` headers and plain `<td>` body cells.
- Pagination is a labelled `<nav>` with `aria-current="page"` and disabled Previous/Next states.
- The filter form has an accessible name and the `search` landmark role.

## Dependencies

- Bootstrap CSS 5.3.8 for the classes above.
- No Bootstrap JavaScript is required by any M3 component.
- No HTMX, Alpine.js, MiniJS, MiniCSS or Pakai Server dependency.

## Verification

Executed on 2026-10-29 with PakaiUI 0.13 (b4xlib SHA-256
`7E1D2BF2D76489DA0DDA2E94CB5BDDD58BC9737AE8AD67382AC182BE4FDE5195`):

| Check | Result |
| --- | --- |
| M3 form/data-display tests | PASS - 203 passed, 0 failed, exit code 0 |
| M2 component regression | PASS - 135 passed, 0 failed, exit code 0 |
| M1 foundation regression | PASS - 35 passed, 0 failed, exit code 0 |
| M0 proof of concept regression | PASS - 28 passed, 0 failed, exit code 0 |
| Gallery: fields, choices, table and pagination | PASS - 1 search form, 4 inputs, 1 textarea, 1 select, 3 checkboxes, 3 radios, 1 table with 4 rows, 1 pagination nav |
| Gallery: label association | PASS - 11 labels, 0 broken `for` targets |
| Gallery: unique ids | PASS - 23 ids, no duplicates |
| Gallery: validation feedback | PASS - invalid input renders visible `invalid-feedback` |
| Gallery: table overflow | PASS - `.table-responsive` computes `overflow-x: auto` |
| Gallery: dark theme | PASS - `data-bs-theme="dark"`, no horizontal page overflow |
| Gallery: browser console | PASS - no errors |
| HTMX baseline after M3 | PASS - unchanged and recorded in `docs/M0-RECONNAISSANCE.md` section 9 |
