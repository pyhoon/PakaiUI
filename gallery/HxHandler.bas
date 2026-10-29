B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI gallery - HTMX fragment handler (plain jServer, no Pakai Server).
' Implements the M0-defined baseline endpoints:
'   /hx/ping  GET  -> 200, fragment for innerHTML swap
'   /hx/echo  POST -> 200, greets the posted name (escaped)
'   /hx/spin  GET  -> 200, replacement for the outerHTML swap demo
'   /hx/empty GET  -> 204, No Content (no swap)
' Fragments are short trusted literals; user data goes through PUI.EscapeHtml.
Sub Class_Globals
	Private Const UrlPing As String = "/hx/ping"
	Private Const UrlEcho As String = "/hx/echo"
	Private Const UrlSpin As String = "/hx/spin"
	Private Const UrlEmpty As String = "/hx/empty"
End Sub

Public Sub Initialize
End Sub

Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	Dim path As String = req.RequestURI
	If Not(path.StartsWith("/hx/")) Then Return True
	Log("HxHandler: " & req.Method & " " & path & " HX-Request=" & req.GetHeader("HX-Request"))
	Select path
		Case UrlPing
			resp.ContentType = "text/html;charset=utf-8"
			resp.Write("<span id=" & QUOTE & "m0-htmx" & QUOTE & ">pong</span>")
		Case UrlEcho
			Dim visitor As String = req.GetParameter("name")
			If visitor = "" Then visitor = "world"
			resp.ContentType = "text/html;charset=utf-8"
			resp.Write("<span class=" & QUOTE & "text-bg-primary p-1 rounded" & QUOTE & ">Hello " & PUI.EscapeHtml(visitor) & "</span>")
		Case UrlSpin
			resp.ContentType = "text/html;charset=utf-8"
			resp.Write("<span id=" & QUOTE & "m0-spin" & QUOTE & " class=" & QUOTE & "text-bg-success p-2 rounded d-inline-block" & QUOTE & ">swapped</span>")
		Case UrlEmpty
			resp.Status = 204
		Case Else
			resp.ContentType = "text/plain;charset=utf-8"
			resp.Status = 404
			resp.Write("Not found: " & PUI.EscapeHtml(path))
	End Select
	Return False
End Sub
