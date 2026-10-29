B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI on Pakai Server example - home route.
' The handler builds a MiniHtml document with PUI and writes its rendered string.
' resp.Write is the only integration point; there is no PakaiUI adapter to install.
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	resp.ContentType = "text/html; charset=utf-8"
	resp.Write(BuildPage.build)
End Sub

Private Sub BuildPage As MiniHtml
	Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("PakaiUI on Pakai Server")
	pageOptions.Description = "PakaiUI rendered from a Pakai Server / EndsMeet handler."
	Dim page As MiniHtml = PUI.Document(pageOptions)
	Dim head1 As MiniHtml = PUI.Head(page)
	PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
	PUI.StyleSheet(head1, "/assets/css/bootstrap-icons.min.css?v=1.13.1")
	PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=" & PUI.VERSION)
	Dim body1 As MiniHtml = PUI.Body(page)

	Dim navbarOptions As PUINavbarOptions = PUI.NewNavbarOptions("PakaiUI + Pakai Server")
	navbarOptions.Href = "/"
	navbarOptions.Breakpoint = "sm"
	navbarOptions.Items.Add(PUI.NewNavItemOptions("This page", "/"))
	navbarOptions.Items.Add(PUI.NewNavItemOptions("Form", "#example-form"))
	PUI.Navbar(navbarOptions).up(body1)

	Dim container1 As MiniHtml = PUI.Container(Null)
	container1.cls("py-5")
	container1.up(body1)

	Dim headerOptions As PUIPageHeaderOptions = PUI.NewPageHeaderOptions("PakaiUI on Pakai Server")
	headerOptions.Subtitle = "This page is composed by PUI inside an EndsMeet route. PakaiUI returns plain HTML; EndsMeet owns the server, routing and response."
	PUI.PageHeader(headerOptions).up(container1)

	Dim infoOptions As PUIAlertOptions = PUI.NewAlertOptions("The handler renders a MiniHtml document and calls resp.Write(page.build). There is no separate listener and no adapter library to install.")
	infoOptions.Title = "One server, one response"
	infoOptions.Variant = PUI.VariantInfo
	infoOptions.CssClass = "mb-4"
	PUI.Alert(infoOptions).up(container1)

	Dim formOptions As PUIFilterBarOptions = PUI.NewFilterBarOptions
	formOptions.Action = "/submit"
	formOptions.Method = "post"
	formOptions.AriaLabel = "PakaiUI example form"
	Dim form1 As MiniHtml = PUI.FilterBar(formOptions)
	form1.attr("id", "example-form")
	form1.up(container1)

	Dim nameOptions As PUIInputOptions = PUI.NewInputOptions("Name", "name")
	nameOptions.Placeholder = "Your name"
	nameOptions.HelpText = "The POST handler escapes this value before rendering it."
	nameOptions.Required = True
	nameOptions.CssClass = "col-auto"
	PUI.Input(nameOptions).up(form1)

	Dim submitOptions As PUIButtonOptions = PUI.NewButtonOptions("Submit")
	submitOptions.ButtonType = "submit"
	submitOptions.Variant = PUI.VariantPrimary
	PUI.Button(submitOptions).up(form1)

	Dim tableOptions As PUITableOptions = PUI.NewTableOptions
	tableOptions.Caption = "Verified example stack"
	tableOptions.Striped = True
	tableOptions.Hover = True
	tableOptions.Columns.Add(PUI.NewTableColumn("Component", "component"))
	tableOptions.Columns.Add(PUI.NewTableColumn("Version", "version"))
	Dim rowB4J As Map = PUI.NewTableRow
	rowB4J.Put("component", "B4J")
	rowB4J.Put("version", "10.7")
	tableOptions.Rows.Add(rowB4J)
	Dim rowEndsMeet As Map = PUI.NewTableRow
	rowEndsMeet.Put("component", "EndsMeet")
	rowEndsMeet.Put("version", "4.03")
	tableOptions.Rows.Add(rowEndsMeet)
	Dim rowMiniHtml As Map = PUI.NewTableRow
	rowMiniHtml.Put("component", "MiniHTML")
	rowMiniHtml.Put("version", "4.02")
	tableOptions.Rows.Add(rowMiniHtml)
	Dim rowPakaiUI As Map = PUI.NewTableRow
	rowPakaiUI.Put("component", "PakaiUI")
	rowPakaiUI.Put("version", PUI.VERSION)
	tableOptions.Rows.Add(rowPakaiUI)
	tableOptions.CssClass = "mt-4"
	PUI.Table(tableOptions).up(container1)

	Dim footer1 As MiniHtml
	footer1.Initialize("footer")
	footer1.cls("mt-5 text-body-secondary small")
	footer1.up(container1)
	PUI.AddText(footer1, "PakaiUI " & PUI.VERSION & " - EndsMeet 4.03 - static assets served by EndsMeet from Objects\www.")
	Return page
End Sub
