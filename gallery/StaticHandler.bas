B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI gallery - static file handler for /assets/* (no DefaultServlet).
' Serves files from <DirApp>\www\assets so the page handler can safely own "/".
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	Dim path As String = req.RequestURI
	If Not(path.StartsWith("/assets/")) Then
		resp.Status = 404
		resp.ContentType = "text/plain;charset=utf-8"
		resp.Write("Not found")
		Return
	End If
	Dim relative As String = path.SubString("/assets/".Length)
	Dim baseDir As String = File.Combine(File.DirApp, "www")
	Dim fullPath As String = baseDir & "\assets\" & relative.Replace("/", "\")
	If Not(File.Exists(baseDir, "assets\" & relative.Replace("/", "\"))) Then
		resp.Status = 404
		resp.ContentType = "text/plain;charset=utf-8"
		resp.Write("Not found: " & PUI.EscapeHtml(relative))
		Return
	End If
	resp.ContentType = ContentTypeFor(relative)
	Dim in As InputStream = File.OpenInput(baseDir, "assets\" & relative.Replace("/", "\"))
	Dim out As OutputStream = resp.OutputStream
	File.Copy2(in, out)
	out.Close
	in.Close
End Sub

Private Sub ContentTypeFor (Path As String) As String
	Dim lower As String = Path.ToLowerCase
	If lower.EndsWith(".css") Then Return "text/css;charset=utf-8"
	If lower.EndsWith(".js") Then Return "application/javascript;charset=utf-8"
	If lower.EndsWith(".map") Then Return "application/json;charset=utf-8"
	If lower.EndsWith(".woff2") Then Return "font/woff2"
	If lower.EndsWith(".woff") Then Return "font/woff"
	If lower.EndsWith(".png") Then Return "image/png"
	If lower.EndsWith(".svg") Then Return "image/svg+xml"
	Return "application/octet-stream"
End Sub
