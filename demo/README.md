# PakaiUI Asadi-style demo

A standalone jServer page that composes PakaiUI components and applies the optional
`assets/css/pakaiui-asadi.css` theme. It replaces the previous vendored Pakai Server starter and
demonstrates PakaiUI in a denser, dashboard-like visual language inspired by Pakai Asadi.

The demo is server-rendered and needs no JavaScript. It has mock database data, a working server-side
search/type filter, a theme switch, stat cards, a responsive table and a fixed workspace sidebar.

## Run

Build and install PakaiUI first, then build the demo, sync assets and run from `Objects`:

```powershell
cd demo
& "C:\Program Files\B4X\B4J\B4JBuilder.exe" -Task=Build -Project="PakaiDemo.b4j" -NoClean=True -ShowWarnings=True
cmd /c ..\sync-assets.bat .
cd Objects
& "C:\Java\jdk-19.0.2\bin\java.exe" -jar PakaiDemo.jar
```

Open `http://localhost:51030/`.

## What it demonstrates

- `PUI.Sidebar` with a brand, section label, active/disabled nav items and a secondary database nav.
- `PUI.Breadcrumb`, `PUI.Badge` and `PUI.ThemeSwitcher` in a custom topbar.
- `PUI.PageHeader`, `PUI.Alert`, `PUI.Card` stats and `PUI.Table` in the content panel.
- `PUI.FilterBar`, `PUI.Input` and `PUI.SelectField` for a working server-side filter.
- The theme's light/dark modes through `?theme=light`, `?theme=dark` and `?theme=auto`.

## Theme layer

`assets/css/pakaiui-asadi.css` is loaded after Bootstrap and `pakaiui.css`. It scopes all overrides under
`.pui-asadi` (the document body here), so it can be enabled per application without changing Bootstrap
defaults elsewhere. It defines the sidebar, topbar, content width, stat cards, panels, table, form and
dark-mode tokens.

The theme is not part of `PakaiUI.b4xlib`; install it with the other tracked assets:

```powershell
cmd /c sync-assets.bat <project-folder>
```

Then link it after the base stylesheets:

```b4j
PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=" & PUI.VERSION)
PUI.StyleSheet(head1, "/assets/css/pakaiui-asadi.css?v=" & PUI.VERSION)
```

Set `PUIPageOptions.BodyCssClass = "pui-asadi"` to activate it.
