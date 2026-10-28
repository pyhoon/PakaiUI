# PakaiUI — Technical Specification and Implementation Plan

**Repository:** `pakai-ui-b4j`  
**Project:** PakaiUI  
**Target:** Reusable B4J web UI component library distributed as a `.b4xlib`  
**Status:** Public extension; APIs may evolve until a stable release

## 1. Purpose

PakaiUI is a reusable, server-rendered UI component library for B4J web applications. It should integrate with Pakai Server while remaining usable in other B4J web projects without requiring Pakai Server as a dependency.

The library provides a consistent component API, a Bootstrap-compatible visual theme, and optional HTMX/Alpine.js enhancements. It builds on MiniHTML4 rather than introducing a competing HTML builder or duplicating existing helpers unnecessarily.

## 2. Core decisions

- **Public repository:** `pakai-ui-b4j`.
- **HTML foundation:** MiniHTML4 — https://github.com/pyhoon/MiniHTML4.
- **Styling:** Bootstrap 5.3+ with a custom PakaiUI theme.
- **HTMX baseline:** HTMX 2.x initially. Evaluate HTMX 4 separately and do not claim v4 support until tested.
- **Client-side behavior:** Alpine.js is optional.
- **Framework integration:** Pakai Server integration is optional and must not be a core dependency.
- **Early-stage libraries:** MiniJS and MiniCSS are optional experiments only. Neither may be required by the initial stable PakaiUI release.
- **Assets:** Publish versioned, ready-to-serve CSS and any required JavaScript separately from the `.b4xlib`. Consumers should not need Node.js at runtime.
- **Future framework direction:** Keep the design flexible for a possible EndsMeet/Pakai Server v9 direction, but do not assume its architecture or promise compatibility before its APIs are settled.

## 3. Architecture principles

1. **Framework-independent core.** Do not depend on Pakai Server, EndsMeet, database libraries, or application-specific routing/authentication in core.
2. **Optional adapters.** Pakai Server integration belongs in a separate adapter or example layer. PakaiUI must not start a server or manage routing, authentication, or server lifecycle.
3. **Verify before implementing.** Inspect MiniHTML4's current source and signatures before coding. README descriptions alone are not sufficient evidence of exact APIs.
4. **Avoid duplication.** Inventory MiniHTML4's existing helpers and reuse them wherever appropriate.
5. **Safe output by default.** Escape text and attribute values. Make trusted raw HTML an explicit, separate operation.
6. **Semantic public API.** Prefer variants such as `Primary`, `Secondary`, and `Danger` over making Bootstrap class strings the main public API.
7. **Progressive enhancement.** Basic components should render and remain useful without HTMX or Alpine.js.
8. **One owner per interaction.** Avoid having Bootstrap JavaScript and Alpine.js control the same component behavior.
9. **Theme consistency.** Use semantic design tokens and support Bootstrap-compatible light/dark themes, including `data-bs-theme` where appropriate.
10. **Public API maturity.** Mark pre-stable APIs as subject to change; use changelog entries and tagged releases.

## 4. Repository reconnaissance

### Primary repositories

- MiniHTML4: https://github.com/pyhoon/MiniHTML4
- Pakai Server for B4J: https://github.com/pyhoon/pakai-server-b4j

### Related repositories to inspect as useful

- https://github.com/pyhoon/MiniHtml-B4X
- https://github.com/pyhoon/MiniHtml2-B4X
- https://github.com/pyhoon/EndsMeet
- https://github.com/pyhoon/MiniJS-B4X
- https://github.com/pyhoon/MiniORMUtils-B4X
- https://github.com/pyhoon/WebApiUtils-B4J
- Relevant maintained `pyhoon/pakai-*` repositories

Treat `jAdmin` as historical context only; do not base the new library architecture on old code without an explicit, evidence-based reason.

### MiniHTML4 inspection checklist

Inspect the current repository structure and source files. Files that may be relevant, if present, include:

- `source/MiniHtml.bas`
- `source/MH.bas`
- `source/Helper.bas`
- `source/Cache.bas`
- `Helper.md`
- `Cache.md`
- `CHANGELOG.md`
- `MIGRATION.md`
- `source/libs.json`
- `source/manifest.txt`

Verify rather than assume:

- Exact type and method signatures.
- Fluent-builder and child-composition patterns.
- How rendering/building works.
- Text and attribute escaping behavior.
- How trusted raw HTML is represented.
- Class, style, boolean-attribute, and conditional helpers.
- Existing Bootstrap, form, layout, HTMX, asset, cache, and page/template helpers.
- Declared library dependencies and packaging details.
- Whether helpers already solve proposed PakaiUI use cases.

## 5. Frontend dependencies and compatibility

### Bootstrap

Use Bootstrap 5.3+ as the initial CSS framework baseline. PakaiUI should expose semantic options while allowing advanced callers to provide custom classes where appropriate.

### HTMX

Use HTMX 2.x as the initial compatibility baseline, subject to verification against the actual Pakai Server source and tests. Evaluate HTMX 4 as a separate compatibility task because behavior and compatibility details may differ. Do not mix version-specific assumptions into the core component API unless required.

### Alpine.js

Alpine.js is optional and should be used for local client-side state where it adds value. Do not require it for static rendering or ordinary server-driven interactions.

### MiniJS and MiniCSS

Both are owned by the project author but are early-stage projects. They must remain optional and must not be mandatory dependencies of the initial stable PakaiUI release.

If either is tested in PakaiUI:

- Isolate it behind a small adapter or experimental module.
- Avoid exposing unstable APIs in PakaiUI's public surface.
- Keep the normal build and demo functional when the library is absent.
- Reassess integration only when its API, tests, and release policy are stable.

Do not require MiniCSS to generate production CSS for consumers.

### Theme inspiration and licensing

A custom PakaiUI theme may take visual inspiration from Penguin UI, but Penguin UI must not be a runtime dependency. Review applicable licenses before copying code, CSS, assets, or other protected material.

## 6. Asset delivery

A `.b4xlib` does not automatically serve browser assets. Deliver the frontend assets separately with explicit versioning and instructions.

Document:

- Required versus optional CSS/JavaScript files.
- Supported asset versions and compatibility combinations.
- Local hosting and CDN options.
- How a B4J web application serves or references the assets.
- Upgrade and cache-busting guidance.
- A consumer workflow that requires no Node.js runtime.

Keep asset URLs and deployment choices configurable where practical. Avoid requiring an external CDN for basic offline or self-hosted deployments.

## 7. Proposed layering

### Layer A — PakaiUI core

- Reusable component APIs built on MiniHTML4.
- Semantic variants and consistent component conventions.
- Explicit safe-text versus trusted-HTML handling.
- No server framework, authentication, routing, or database dependency.

### Layer B — Theme and browser assets

- PakaiUI theme CSS.
- Bootstrap-compatible semantic tokens.
- Light/dark theme support.
- Optional HTMX and Alpine.js usage examples.

### Layer C — Optional integration

- Pakai Server adapter or integration examples.
- Potential future EndsMeet adapter, only after the framework APIs are defined.
- Other B4J web-framework adapters can be considered without changing core.

## 8. Milestones

### M0 — Reconnaissance and proof of concept

Do not implement the full component catalogue yet.

1. Inspect the current MiniHTML4 and Pakai Server repositories.
2. Record verified API signatures with source paths and relevant code locations.
3. Inventory existing MiniHTML4 helpers and map them to proposed PakaiUI features.
4. Verify escaping, raw HTML, dependencies, and asset behavior.
5. Verify frontend versions currently referenced by Pakai Server from source.
6. Define the HTMX 2.x baseline test and a separate HTMX 4 evaluation.
7. Review MiniJS and MiniCSS for possible future optional integration only.
8. Produce `M0-RECONNAISSANCE.md`.
9. Build a minimal standalone B4J proof of concept that renders one PakaiUI component via MiniHTML4.
10. Compile and run the proof of concept. Report actual outcomes; do not claim success without test evidence.

**M0 deliverable:** verified findings, a small compiled proof of concept (if compilation succeeds), and a recommended minimal public API.

### M1 — Foundation and demo

- Establish project structure and API conventions.
- Set theme tokens and light/dark behavior.
- Create page/container primitives and a small initial component set.
- Build a standalone gallery/demo that consumes the library without Pakai Server.
- Document asset installation and serving.

### M2 — Core components

Implement and test:

- Button
- Badge
- Alert
- Card
- Breadcrumb
- Page header
- Navigation primitives
- Empty state
- Loading state

### M3 — Forms and data display

Implement and test:

- Input
- Textarea
- Select
- Checkbox and radio
- Validation feedback
- Responsive tables
- Pagination
- Filter controls

### M4 — Optional interactions

Add optional helpers/examples for:

- HTMX requests and server-rendered updates
- Alpine.js local state
- Dialogs and toasts
- Theme switcher
- Sidebar/navigation interactions

For each interactive component, choose one clear behavior owner and document its dependencies. Static rendering should remain available when enhancement libraries are not loaded.

### M5 — Integration and release readiness

- Add optional Pakai Server integration examples or an adapter.
- Complete API documentation and the component gallery.
- Run clean compilation and regression tests.
- Publish a compatibility matrix for B4J, MiniHTML4, Bootstrap, HTMX, and optional Alpine.js.
- Document versioning, migration, and breaking-change policy.

## 9. Acceptance criteria

The initial usable release is acceptable when:

- The `.b4xlib` builds and can be consumed by a separate B4J demo project.
- The demo works without Pakai Server.
- PakaiUI reuses MiniHTML4 and does not introduce a competing HTML builder.
- Text and attributes are escaped correctly, and raw HTML handling is explicit.
- Basic components do not require HTMX or Alpine.js.
- CSS and JavaScript assets are versioned, documented, and easy to serve.
- Consumers do not need Node.js at runtime.
- MiniJS and MiniCSS are not mandatory dependencies.
- HTMX compatibility claims are backed by tests.
- Framework-specific code is isolated from the core.
- The code, demo, and documentation make it clear which APIs are stable and which may change.

## 10. Public repository setup

Recommended initial repository contents:

```text
pakai-ui-b4j/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── docs/
│   ├── architecture.md
│   ├── assets.md
│   ├── compatibility.md
│   └── components/
├── source/
├── demo/
├── assets/
│   ├── css/
│   └── js/
└── tests/
```

Adapt this structure to B4J and MiniHTML4 conventions found during M0. Do not create empty directories or modules solely to match this illustrative tree.

Before publishing, select a license intentionally and ensure any bundled assets and copied snippets are compatible with it. Add issue templates and contribution guidance if appropriate. Use tagged releases and maintain a changelog.

## 11. Immediate instruction to the coding agent

**Start with M0 only.** Inspect the live repositories and source code, write `M0-RECONNAISSANCE.md` with verified signatures and findings, then compile/run the smallest standalone proof of concept. Do not implement the full component catalogue until these findings are complete.

Do not invent APIs, dependencies, frontend versions, or successful test results. If a repository or toolchain cannot be accessed, document the limitation and continue with the parts that can be verified.
