B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI on Pakai Server example - POST result route.
' Demonstrates server-rendered handling and escaping of request data.
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	Dim visitor As String = req.GetParameter("name")
	If visitor = "" Then visitor = "world"
	resp.ContentType = "text/html; charset=utf-8"
	resp.Write(BuildResult(visitor).build)
End Sub

Private Sub BuildResult (Visitor As String) As MiniHtml
	Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("PakaiUI form result")
	pageOptions.Description = "Server-rendered PakaiUI form result."
	Dim page As MiniHtml = PUI.Document(pageOptions)
	Dim head1 As MiniHtml = PUI.Head(page)
	PUI.StyleSheet(head1, "/assets/css/bootstrap.min.css?v=5.3.8")
	PUI.StyleSheet(head1, "/assets/css/pakaiui.css?v=" & PUI.VERSION)
	Dim body1 As MiniHtml = PUI.Body(page)

	Dim container1 As MiniHtml = PUI.Container(Null)
	container1.cls("py-5")
	container1.up(body1)

	Dim headerOptions As PUIPageHeaderOptions = PUI.NewPageHeaderOptions("Form received")
	PUI.PageHeader(headerOptions).up(container1)

	Dim alertOptions As PUIAlertOptions = PUI.NewAlertOptions("Hello " & Visitor & "! The POST handler read the value with req.GetParameter and PUI escaped it for the response.")
	alertOptions.Title = "Server-rendered result"
	alertOptions.Variant = PUI.VariantSuccess
	PUI.Alert(alertOptions).up(container1)

	Dim backOptions As PUIButtonOptions = PUI.NewButtonOptions("Back to the example")
	backOptions.Href = "/"
	backOptions.Variant = PUI.VariantOutlineSecondary
	PUI.Button(backOptions).up(container1)
	Return page
End Sub
