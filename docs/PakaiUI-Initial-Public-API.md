# PakaiUI initial public API — v0.1

## 1. Public API structure

PakaiUI

Public facade and component conventions

Components

Button, Alert, Card, Badge, Form controls

HTML foundation

MiniHTML4 for composition and rendering

Theme

Bootstrap-compatible CSS and design tokens

Optional adapters

Pakai Server, HTMX, Alpine.js

The names and signatures below are proposed API contracts, not claims about existing MiniHTML4 methods. The coding agent must verify B4J and MiniHTML4 conventions before implementing them.

## 2. Core facade: `PUI`

`PUI` is the main entry point. It exposes component factories, shared configuration, and HTML-safe utility methods.

Proposed public methods:

| Method                  | Purpose                                      |
| ----------------------- | -------------------------------------------- |
| `Initialize`            | Initialize the library and its configuration |
| `Button(Options)`       | Create a button or link-style button         |
| `Badge(Options)`        | Create a status or category badge            |
| `Alert(Options)`        | Create a contextual alert                    |
| `Card(Options)`         | Create a card                                |
| `Breadcrumb(Items)`     | Create breadcrumb navigation                 |
| `PageHeader(Options)`   | Create a page title and optional actions     |
| `Container(Options)`    | Create a responsive content container        |
| `Row(Options)`          | Create a responsive grid row                 |
| `Column(Options)`       | Create a responsive grid column              |
| `Input(Options)`        | Create a form input                          |
| `TextArea(Options)`     | Create a multiline input                     |
| `Select(Options)`       | Create a select control                      |
| `Checkbox(Options)`     | Create a checkbox                            |
| `Radio(Options)`        | Create a radio control                       |
| `Table(Options)`        | Create a responsive table                    |
| `EmptyState(Options)`   | Create an empty-state panel                  |
| `LoadingState(Options)` | Create a loading indicator                   |

Return type: Prefer the native MiniHTML4 element/component type if its public API supports safe composition. If that proves impractical, use a PakaiUI-owned component interface that can render to an HTML fragment. The final choice must follow the M0 source inspection and compile test—not assumptions about MiniHTML4's API.

Do not create all these methods in the first milestone. The table defines the intended public surface; implement the first few components first.

## 3. Shared conventions

Every component should follow the same conventions.

### Variants

Use semantic variants instead of forcing users to remember Bootstrap classes.

```
PUI.VariantPrimary
PUI.VariantSecondary
PUI.VariantSuccess
PUI.VariantDanger
PUI.VariantWarning
PUI.VariantInfo
PUI.VariantLight
PUI.VariantDark
PUI.VariantOutline
PUI.VariantLink
```

Not every component supports every variant. Document supported values and provide a sensible default.

### Sizes

```
PUI.SizeSmall
PUI.SizeDefault
PUI.SizeLarge
```

Only apply sizes to components where the distinction is meaningful.

### Shared options

Components may support these common settings where appropriate:

- `Id As String`
- `CssClass As String`
- `Attributes As Map`
- `Visible As Boolean`
- `Disabled As Boolean`

`CssClass` is an escape hatch for custom styling, not the primary configuration API.

`Attributes` must be validated. Event-handler attributes such as inline JavaScript should not be silently accepted as ordinary attributes.

## 4. Initial component contracts

The following are proposed logical contracts. The exact B4J declarations and integration with MiniHTML4 should be finalized after source inspection.

### Button

Options:

| Property   | Type    | Meaning                         |
| ---------- | ------- | ------------------------------- |
| `Text`     | String  | Visible button label            |
| `Variant`  | String  | Semantic visual variant         |
| `Size`     | String  | Optional button size            |
| `Disabled` | Boolean | Whether interaction is disabled |
| `Type`     | String  | `button`, `submit`, or `reset`  |
| `Href`     | String  | Optional link destination       |
| `Id`       | String  | Optional HTML ID                |
| `CssClass` | String  | Additional CSS classes          |

Rules:

- Render a `<button>` by default.
- Render an `<a>` when `Href` is supplied.
- Do not produce both a button element and a link element for one component.
- Escape the visible label and attribute values.
- Validate URL and attribute handling.

### Badge

Options:

- `Text`
- `Variant`
- `CssClass`

Use for short statuses, counts, labels, and categories. Avoid embedding layout or business logic into the badge component.

### Alert

Options:

- `Title`
- `Message`
- `Variant`
- `Dismissible`
- `Id`

Initially, support text content rather than arbitrary HTML content. Dismissible behavior should be implemented only when its JavaScript dependency and fallback behavior are clearly defined.

### Card

Options:

- `Title`
- `Subtitle`
- `BodyText`
- `FooterText`
- `CssClass`
- `Id`

For the first release, use escaped text fields. Rich nested content should be added only after the composition API is established.

### Breadcrumb

Represent each breadcrumb item with:

- `Text`
- `Href`
- `Active`

The active item should be marked semantically and should not require a navigable link.

### PageHeader

Options:

- `Title`
- `Subtitle`
- `CssClass`
- `Id`

Defer complex action-slot composition until the library has a documented way to compose nested MiniHTML4 elements.

### Form controls

The first form-control release should use consistent conventions:

- `Name`
- `Id`
- `Label`
- `Value`
- `Placeholder`
- `Required`
- `Disabled`
- `HelpText`
- `ErrorText`
- `CssClass`

Not every field applies to every control. `Select` additionally needs a collection of options; checkbox and radio controls need an explicit checked/selected state.

Accessibility requirements:

- Associate labels with controls.
- Use stable IDs.
- Render required and invalid states consistently.
- Provide appropriate `aria-*` attributes when needed.
- Never treat an error message or label as trusted HTML by default.

### Table

The initial table API should support structured column definitions and rows, rather than requiring callers to assemble arbitrary HTML strings.

Proposed column fields:

- `Title`
- `Field`
- `Align`
- `Sortable` — reserved for a later implementation if sorting is supported

Proposed table options:

- `Columns`
- `Rows`
- `Responsive`
- `Striped`
- `Hover`
- `Bordered`
- `CssClass`

Sorting, pagination, filtering, and HTMX-powered updates can be layered on later without making the initial table dependent on JavaScript.

## 5. Composition contract

Composition is the most important API decision to validate during M0.

PakaiUI should support nesting components inside layouts and cards without requiring developers to manually concatenate HTML strings.

Preferred approach:

1. Reuse MiniHTML4's native element and child-composition mechanisms.
2. Let PakaiUI components produce compatible elements.
3. Render the final page through MiniHTML4's established rendering path.

If MiniHTML4 cannot support this cleanly, define a small PakaiUI component interface and adapter. Do not build a second general-purpose HTML tree or builder.

For raw HTML, provide an explicitly named trusted-content mechanism only if needed. Never implicitly interpret ordinary text as HTML.

## 6. Theme and configuration API

Provide a small configuration surface for shared behavior:

- Default theme mode: light, dark, or follow the application's setting.
- Optional custom CSS class conventions.
- Asset configuration or documented asset references.
- Optional HTMX/Alpine.js enablement in the rendered page template.

Theme mode should use Bootstrap-compatible `data-bs-theme` where applicable.

Do not make `PUI.Initialize` start a web server, register routes, or alter global framework state.

## 7. HTMX integration API

HTMX helpers should be optional and separate from basic components. They should express server-driven behavior without forcing a particular routing framework.

A future helper could configure:

- Request URL
- HTTP method
- Target selector
- Swap strategy
- Trigger
- Optional confirmation text

Use a typed options object rather than exposing an arbitrary unvalidated HTML attribute map as the main API.

Do not finalize method names or supported swap/trigger values until HTMX 2.x behavior and MiniHTML4's existing helpers have been verified. Avoid binding the core library to HTMX 4-specific behavior.

## 8. What is explicitly out of scope for v0.1

Do not include these in the initial public API:

- Authentication, authorization, or session management
- Routing or server lifecycle management
- ORM/database integration
- A complete client-side application framework
- A replacement for Bootstrap
- A replacement for MiniHTML4
- Mandatory Alpine.js or HTMX dependencies
- Mandatory MiniJS or MiniCSS dependencies
- A complex plugin/renderer registry
- A generic arbitrary-HTML templating engine
- Framework-specific APIs tied to a future EndsMeet version

## 9. Versioning policy

Treat the first public release as an early API version.

- Document the public methods and option fields.
- Keep internal helper methods private where possible.
- Avoid exposing implementation details that would prevent refactoring.
- Record breaking changes in `CHANGELOG.md`.
- Tag releases.
- Do not promise compatibility with future EndsMeet/Pakai Server v9 until it is implemented and tested.

## 10. Implementation order

Implement the API in this order:

1. Verify MiniHTML4 composition, rendering, and escaping.
2. Define the component return/composition contract.
3. Implement `PUI` initialization and shared conventions.
4. Implement Button, Badge, Alert, and Card.
5. Create a standalone B4J demo that consumes the `.b4xlib`.
6. Verify HTML output, accessibility basics, and safe escaping.
7. Add form controls and layout components.
8. Add HTMX helpers and optional framework integration only after the core API is stable.

## 11. Acceptance criteria

The initial API is ready for wider use when:

- A standalone B4J project can consume the library.
- Core components compose without unsafe manual string concatenation.
- User text and attributes are escaped correctly.
- The API does not expose unnecessary Bootstrap implementation details.
- Components work without HTMX or Alpine.js.
- The library does not require Pakai Server, EndsMeet, MiniJS, or MiniCSS.
- A demo documents real usage and the tested dependency versions.
- Public signatures match the actual compiled B4J implementation.

## My recommendation

Keep the initial stable surface deliberately small: `PUI`, Button, Badge, Alert, Card, and the composition contract. Those are enough to validate the architecture and demonstrate the library publicly. Add forms, tables, and interactive components only after you have verified the MiniHTML4 integration.

One important caveat: the signatures above define the intended API contract, not a compiled implementation. The next step is to inspect MiniHTML4 and turn this into exact B4J class declarations and method signatures.