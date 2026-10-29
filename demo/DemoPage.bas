B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI Asadi-style demo page.
' Uses PUI components for the shell, cards, filter form and table, and the
' optional pakaiui-asadi.css layer for the visual language. Server-rendered,
' no JavaScript required.
Sub Class_Globals
	Private Const BootstrapVersion As String = "5.3.8"
	Private Const IconsVersion As String = "1.13.1"
End Sub

Public Sub Initialize
End Sub

Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	If req.RequestURI <> "/" Then Return True
	Dim theme1 As String = ValidateTheme(req.GetParameter("theme"))
	resp.ContentType = "text/html;charset=utf-8"
	resp.Write(BuildPage(theme1, req.GetParameter("q"), req.GetParameter("type")).build)
	Return False
End Sub

Private Sub BuildPage (Theme As String, Query As String, TypeFilter As String) As MiniHtml
	Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("PakaiUI Asadi Demo")
	pageOptions.Theme = Theme
	pageOptions.Description = "PakaiUI components with the optional Asadi-style theme layer."
	pageOptions.BodyCssClass = "pui-asadi"
	Dim page As MiniHtml = PUI.Document(pageOptions)
	Dim head1 As MiniHtml = PUI.Head(page)
	PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=" & BootstrapVersion)
	PUI.StyleSheet(head1, "/assets/css/bootstrap-icons.min.css?v=" & IconsVersion)
	PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=" & PUI.VERSION)
	PUI.StyleSheet(head1, "/assets/css/pakaiui-asadi.css?v=" & PUI.VERSION)
	Dim body1 As MiniHtml = PUI.Body(page)

	AddSidebar(body1)

	Dim main1 As MiniHtml = Tag("div").cls("pui-asadi-main")
	main1.up(body1)
	AddTopbar(main1, Theme)

	Dim content1 As MiniHtml = Tag("div").cls("pui-asadi-content")
	content1.up(main1)
	AddOverview(content1, Query, TypeFilter)
	AddFooter(content1)
	Return page
End Sub

Private Sub AddSidebar (Parent As MiniHtml)
	Dim sideOptions As PUISidebarOptions = PUI.NewSidebarOptions("PakaiUI")
	sideOptions.Href = "/"
	sideOptions.Title = "WORKSPACE"
	sideOptions.Border = False
	sideOptions.CssClass = "pui-asadi-sidebar"
	sideOptions.Items.Add(MakeNavItem("Overview", "/", True, False))
	sideOptions.Items.Add(MakeNavItem("Schema objects", "#objects", False, False))
	sideOptions.Items.Add(MakeNavItem("SQL workspace", "#", False, True))
	sideOptions.Items.Add(MakeNavItem("Exports", "#", False, True))
	Dim side1 As MiniHtml = PUI.Sidebar(sideOptions)
	side1.up(Parent)

	Dim dbLabel As MiniHtml = Tag("div").cls("pui-asadi-nav-label")
	dbLabel.text("REGISTERED")
	dbLabel.up(side1)
	Dim dbNavOptions As PUINavOptions = PUI.NewNavOptions
	dbNavOptions.Vertical = True
	dbNavOptions.CssClass = "pui-asadi-db-nav"
	dbNavOptions.AriaLabel = "Registered databases"
	dbNavOptions.Items.Add(MakeNavItem("demo.db", "#objects", False, False))
	dbNavOptions.Items.Add(MakeNavItem("analytics.db", "#objects", False, False))
	dbNavOptions.Items.Add(MakeNavItem("archive.db", "#objects", False, False))
	PUI.Nav(dbNavOptions).up(side1)

	Dim foot1 As MiniHtml = Tag("div").cls("pui-asadi-sidefoot")
	foot1.up(side1)
	Tag("span").cls("status-dot").up(foot1)
	PUI.AddText(foot1, " Connected to demo")
End Sub

Private Sub AddTopbar (Parent As MiniHtml, Theme As String)
	Dim bar1 As MiniHtml = Tag("header").cls("pui-asadi-topbar")
	bar1.up(Parent)

	Dim crumbOptions As PUIBreadcrumbOptions = PUI.NewBreadcrumbOptions
	crumbOptions.CssClass = "pui-asadi-crumb"
	crumbOptions.Items.Add(PUI.NewBreadcrumbItem("Workspace", "/"))
	Dim currentCrumb As PUIBreadcrumbItem = PUI.NewBreadcrumbItem("Overview", "")
	currentCrumb.Active = True
	crumbOptions.Items.Add(currentCrumb)
	PUI.Breadcrumb(crumbOptions).up(bar1)

	Dim actions1 As MiniHtml = Tag("div").cls("pui-asadi-topbar-actions")
	actions1.up(bar1)
	Dim badgeOptions As PUIBadgeOptions = PUI.NewBadgeOptions("Read-only demo")
	badgeOptions.Variant = PUI.VariantLight
	badgeOptions.CssClass = "pui-asadi-readonly"
	PUI.Badge(badgeOptions).up(actions1)
	Dim themeOptions As PUIThemeSwitcherOptions = PUI.NewThemeSwitcherOptions(Theme)
	themeOptions.Size = PUI.SizeSmall
	themeOptions.CssClass = "pui-asadi-theme"
	PUI.ThemeSwitcher(themeOptions).up(actions1)
End Sub

Private Sub AddOverview (Parent As MiniHtml, Query As String, TypeFilter As String)
	Dim eyebrow1 As MiniHtml = Tag("div").cls("pui-asadi-eyebrow")
	eyebrow1.up(Parent)
	PUI.AddText(eyebrow1, "DATABASE WORKSPACE")

	Dim headerOptions As PUIPageHeaderOptions = PUI.NewPageHeaderOptions("Workspace overview")
	headerOptions.Subtitle = "A PakaiUI demo wearing the Asadi visual language: quiet panels, a dark workspace rail and a blue accent."
	headerOptions.CssClass = "pui-asadi-pageheader"
	PUI.PageHeader(headerOptions).up(Parent)

	Dim noteOptions As PUIAlertOptions = PUI.NewAlertOptions("Demo data only. The page is server-rendered with PakaiUI components; the Asadi look comes from the optional CSS theme layer.")
	noteOptions.Title = "PakaiUI + Asadi theme"
	noteOptions.Variant = PUI.VariantInfo
	noteOptions.CssClass = "pui-asadi-note"
	PUI.Alert(noteOptions).up(Parent)

	AddStats(Parent)
	AddObjectsPanel(Parent, Query, TypeFilter)
End Sub

Private Sub AddStats (Parent As MiniHtml)
	Dim grid1 As MiniHtml = Tag("div").cls("pui-asadi-stats")
	grid1.up(Parent)
	AddStat(grid1, "Databases", "3", "Registered")
	AddStat(grid1, "Schema objects", "8", "Tables, views, indexes")
	AddStat(grid1, "Rows scanned", "24.9k", "Last query")
	AddStat(grid1, "Latency", "42 ms", "Local demo")
End Sub

Private Sub AddStat (Parent As MiniHtml, Label As String, Value As String, Foot As String)
	Dim cardOptions As PUICardOptions = PUI.NewCardOptions("", "")
	cardOptions.CssClass = "pui-asadi-stat"
	Dim card1 As MiniHtml = PUI.Card(cardOptions)
	card1.up(Parent)
	Dim label1 As MiniHtml = Tag("span").cls("pui-asadi-stat-label")
	label1.up(card1)
	PUI.AddText(label1, Label)
	Dim value1 As MiniHtml = Tag("strong")
	value1.up(card1)
	PUI.AddText(value1, Value)
	Dim foot1 As MiniHtml = Tag("span").cls("pui-asadi-stat-foot")
	foot1.up(card1)
	PUI.AddText(foot1, Foot)
End Sub

Private Sub AddObjectsPanel (Parent As MiniHtml, Query As String, TypeFilter As String)
	Dim allObjects As List = BuildObjects
	Dim objects1 As List = FilterObjects(allObjects, Query, TypeFilter)

	Dim panel1 As MiniHtml = Tag("section").cls("pui-asadi-panel")
	panel1.attr("id", "objects")
	panel1.up(Parent)

	Dim head1 As MiniHtml = Tag("div").cls("pui-asadi-panel-head")
	head1.up(panel1)
	Dim title1 As MiniHtml = Tag("h2")
	title1.up(head1)
	PUI.AddText(title1, "Schema objects")
	Dim countOptions As PUIBadgeOptions = PUI.NewBadgeOptions(objects1.Size & " objects")
	countOptions.Variant = PUI.VariantLight
	countOptions.CssClass = "pui-asadi-count"
	PUI.Badge(countOptions).up(head1)

	Dim body1 As MiniHtml = Tag("div").cls("pui-asadi-panel-body")
	body1.up(panel1)

	Dim filterOptions As PUIFilterBarOptions = PUI.NewFilterBarOptions
	filterOptions.Action = "/"
	filterOptions.Method = "get"
	filterOptions.AriaLabel = "Filter schema objects"
	filterOptions.CssClass = "pui-asadi-filters"
	Dim filter1 As MiniHtml = PUI.FilterBar(filterOptions)
	filter1.up(body1)

	Dim searchOptions As PUIInputOptions = PUI.NewInputOptions("Search", "q")
	searchOptions.Value = Query
	searchOptions.Placeholder = "Name or type"
	searchOptions.CssClass = "col-auto"
	PUI.Input(searchOptions).up(filter1)

	Dim typeOptions As PUISelectOptions = PUI.NewSelectOptions("Type", "type")
	typeOptions.CssClass = "col-auto"
	typeOptions.Placeholder = "All types"
	If TypeFilter <> "" Then typeOptions.SelectedValue = TypeFilter
	typeOptions.Items.Add(PUI.NewSelectItem("Table", "table"))
	typeOptions.Items.Add(PUI.NewSelectItem("View", "view"))
	typeOptions.Items.Add(PUI.NewSelectItem("Index", "index"))
	PUI.SelectField(typeOptions).up(filter1)

	Dim filterButton As PUIButtonOptions = PUI.NewButtonOptions("Filter")
	filterButton.ButtonType = "submit"
	filterButton.Variant = PUI.VariantPrimary
	filterButton.Size = PUI.SizeSmall
	PUI.Button(filterButton).up(filter1)

	If Query <> "" Or TypeFilter <> "" Then
		Dim clearOptions As PUIButtonOptions = PUI.NewButtonOptions("Clear")
		clearOptions.Href = "/"
		clearOptions.Variant = PUI.VariantLink
		clearOptions.Size = PUI.SizeSmall
		PUI.Button(clearOptions).up(filter1)
	End If

	Dim tableOptions As PUITableOptions = PUI.NewTableOptions
	tableOptions.Columns.Add(PUI.NewTableColumn("Object", "name"))
	tableOptions.Columns.Add(PUI.NewTableColumn("Type", "type"))
	Dim rowsColumn As PUITableColumn = PUI.NewTableColumn("Rows", "rows")
	rowsColumn.Align = PUI.AlignEnd
	tableOptions.Columns.Add(rowsColumn)
	Dim updatedColumn As PUITableColumn = PUI.NewTableColumn("Updated", "updated")
	updatedColumn.Align = PUI.AlignEnd
	tableOptions.Columns.Add(updatedColumn)
	tableOptions.Rows = objects1
	tableOptions.EmptyText = "No objects match these filters."
	tableOptions.Hover = True
	tableOptions.CssClass = "pui-asadi-table"
	PUI.Table(tableOptions).up(body1)
End Sub

Private Sub AddFooter (Parent As MiniHtml)
	Dim footer1 As MiniHtml = Tag("footer").cls("pui-asadi-footer")
	footer1.up(Parent)
	PUI.AddText(footer1, "PakaiUI " & PUI.VERSION & " - Asadi theme - Bootstrap " & BootstrapVersion)
End Sub

Private Sub BuildObjects As List
	Dim items1 As List
	items1.Initialize
	items1.Add(NewObject("users", "table", 1240, "2026-10-30 09:12"))
	items1.Add(NewObject("orders", "table", 8920, "2026-10-30 09:08"))
	items1.Add(NewObject("products", "table", 412, "2026-10-30 08:54"))
	items1.Add(NewObject("active_users", "view", 1240, "2026-10-30 09:12"))
	items1.Add(NewObject("orders_by_month", "view", 12, "2026-10-30 09:08"))
	items1.Add(NewObject("idx_orders_user", "index", 8920, "2026-10-29 18:20"))
	items1.Add(NewObject("audit_log", "table", 24500, "2026-10-30 09:15"))
	items1.Add(NewObject("schema_migrations", "table", 18, "2026-10-28 11:02"))
	Return items1
End Sub

Private Sub NewObject (Name As String, ObjectType As String, Rows As Int, Updated As String) As Map
	Dim row1 As Map
	row1.Initialize
	row1.Put("name", Name)
	row1.Put("type", ObjectType)
	row1.Put("rows", Rows)
	row1.Put("updated", Updated)
	Return row1
End Sub

Private Sub FilterObjects (Items As List, Query As String, TypeFilter As String) As List
	Dim result1 As List
	result1.Initialize
	Dim q1 As String = Query.Trim.ToLowerCase
	Dim type1 As String = TypeFilter.Trim.ToLowerCase
	For i = 0 To Items.Size - 1
		Dim row1 As Map = Items.Get(i)
		Dim name1 As String = row1.Get("name")
		Dim rowType As String = row1.Get("type")
		If q1 <> "" Then
			If name1.ToLowerCase.Contains(q1) = False And rowType.ToLowerCase.Contains(q1) = False Then Continue
		End If
		If type1 <> "" And type1 <> "all" And rowType <> type1 Then Continue
		result1.Add(row1)
	Next
	Return result1
End Sub

Private Sub MakeNavItem (Text As String, Href As String, Active As Boolean, Disabled As Boolean) As PUINavItemOptions
	Dim item1 As PUINavItemOptions = PUI.NewNavItemOptions(Text, Href)
	item1.Active = Active
	item1.Disabled = Disabled
	Return item1
End Sub

Private Sub ValidateTheme (Requested As String) As String
	Dim value As String = Requested.Trim.ToLowerCase
	If value = PUI.ThemeLight Then Return PUI.ThemeLight
	If value = PUI.ThemeDark Then Return PUI.ThemeDark
	Return PUI.ThemeAuto
End Sub

Private Sub Tag (Name As String) As MiniHtml
	Dim tag1 As MiniHtml
	tag1.Initialize(Name)
	Return tag1
End Sub
