B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=StaticCode
Version=10.7
@EndOfDesignText@
' PakaiUI - server-rendered UI components for B4J web applications.
' Version: 0.12 (M2 core components: badge, alert, breadcrumb, header, nav,
'          empty and loading states, plus card extensions)
' HTML foundation: MiniHTML 4.02 (https://github.com/pyhoon/MiniHTML4)
'
' Safety contract:
'   - Text and attribute values are escaped by default.
'   - Raw HTML is produced only by RawHtml / AddHtml, which are explicit.
'   - Components return a MiniHtml element so they compose through up / down / add.
'
' Conventions:
'   - Public option types are prefixed with PUI because B4X types share a global namespace.
'   - No dependency on Pakai Server, MiniJS or MiniCSS.
Sub Process_Globals
	Public Const VERSION As String = "0.12"

	' Bootstrap 5.3 semantic variants
	Public Const VariantPrimary As String = "primary"
	Public Const VariantSecondary As String = "secondary"
	Public Const VariantSuccess As String = "success"
	Public Const VariantDanger As String = "danger"
	Public Const VariantWarning As String = "warning"
	Public Const VariantInfo As String = "info"
	Public Const VariantLight As String = "light"
	Public Const VariantDark As String = "dark"
	Public Const VariantLink As String = "link"
	Public Const VariantOutlinePrimary As String = "outline-primary"
	Public Const VariantOutlineSecondary As String = "outline-secondary"
	Public Const VariantOutlineSuccess As String = "outline-success"
	Public Const VariantOutlineDanger As String = "outline-danger"
	Public Const VariantOutlineWarning As String = "outline-warning"
	Public Const VariantOutlineInfo As String = "outline-info"
	Public Const VariantOutlineLight As String = "outline-light"
	Public Const VariantOutlineDark As String = "outline-dark"

	' Sizes
	Public Const SizeSmall As String = "sm"
	Public Const SizeDefault As String = ""
	Public Const SizeLarge As String = "lg"

	' Theme values for PUIPageOptions.Theme (data-bs-theme on the <html> element).
	' ThemeAuto renders no attribute: the page follows the browser default, which
	' Bootstrap treats as light.
	Public Const ThemeAuto As String = ""
	Public Const ThemeLight As String = "light"
	Public Const ThemeDark As String = "dark"

	' Component options. Types are global in B4X, hence the PUI prefix.
	' ButtonType is named ButtonType because "Type" is a B4X reserved word.
	' Hidden is used instead of Visible so that a default False value means "shown".
	Type PUIButtonOptions (Text As String, Variant As String, Size As String, ButtonType As String, Href As String, Id As String, CssClass As String, Disabled As Boolean, Hidden As Boolean)
	Type PUICardOptions (Title As String, Subtitle As String, BodyText As String, FooterText As String, Id As String, CssClass As String, HeaderText As String, ImageSrc As String, ImageAlt As String, Hidden As Boolean)

	' Page and layout options (M1 foundation).
	Type PUIPageOptions (Title As String, Description As String, Lang As String, Theme As String, BodyCssClass As String)
	Type PUIContainerOptions (Id As String, CssClass As String, Breakpoint As String, Fluid As Boolean, Hidden As Boolean)
	Type PUIRowOptions (Id As String, CssClass As String, Hidden As Boolean)
	Type PUIColOptions (Id As String, CssClass As String, Breakpoint As String, Width As Int, Auto As Boolean, Hidden As Boolean)

	' Core component options (M2).
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
End Sub

' Reserved for future library-wide configuration.
' It never starts a server, registers routes or changes global framework state.
Public Sub Initialize

End Sub

' Escapes text and attribute values for HTML output.
' Mapping matches EndsMeet.EscapeHtml so PakaiUI and Pakai Server render consistently.
Public Sub EscapeHtml (Raw As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Raw.Length - 1
		Dim c As Char = Raw.CharAt(i)
		Select c
			Case QUOTE
				sb.Append("&quot;")
			Case "'"
				sb.Append("&#39;")
			Case "<"
				sb.Append("&lt;")
			Case ">"
				sb.Append("&gt;")
			Case "&"
				sb.Append("&amp;")
			Case Else
				sb.Append(c)
		End Select
	Next
	Return sb.ToString
End Sub

' Wraps already trusted HTML so it can take part in composition.
' The result renders exactly Html, with no escaping and no surrounding tag.
' Use only for markup you control. Never pass user input here.
Public Sub RawHtml (Html As String) As MiniHtml
	Dim tag1 As MiniHtml
	tag1.Initialize("")
	tag1.setFlat(True)
	tag1.text(Html, False)
	Return tag1
End Sub

' Appends escaped text to an element and returns the element.
Public Sub AddText (Parent As MiniHtml, Value As String) As MiniHtml
	If Parent = Null Then Return Null
	Parent.text(EscapeHtml(Value))
	Return Parent
End Sub

' Appends trusted HTML to an element and returns the element.
' Explicit counterpart of AddText. Never pass user input here.
Public Sub AddHtml (Parent As MiniHtml, Html As String) As MiniHtml
	If Parent = Null Then Return Null
	Parent.text(Html)
	Return Parent
End Sub

Public Sub NewButtonOptions (Text As String) As PUIButtonOptions
	Dim options As PUIButtonOptions
	options.Initialize
	options.Text = Text
	Return options
End Sub

Public Sub NewCardOptions (Title As String, BodyText As String) As PUICardOptions
	Dim options As PUICardOptions
	options.Initialize
	options.Title = Title
	options.BodyText = BodyText
	Return options
End Sub

Public Sub NewPageOptions (Title As String) As PUIPageOptions
	Dim options As PUIPageOptions
	options.Initialize
	options.Title = Title
	options.Lang = "en"
	options.Theme = ThemeAuto
	Return options
End Sub

Public Sub NewContainerOptions As PUIContainerOptions
	Dim options As PUIContainerOptions
	options.Initialize
	Return options
End Sub

Public Sub NewRowOptions As PUIRowOptions
	Dim options As PUIRowOptions
	options.Initialize
	Return options
End Sub

Public Sub NewColOptions As PUIColOptions
	Dim options As PUIColOptions
	options.Initialize
	Return options
End Sub

Public Sub NewBadgeOptions (Text As String) As PUIBadgeOptions
	Dim options As PUIBadgeOptions
	options.Initialize
	options.Text = Text
	Return options
End Sub

Public Sub NewAlertOptions (Message As String) As PUIAlertOptions
	Dim options As PUIAlertOptions
	options.Initialize
	options.Message = Message
	Return options
End Sub

Public Sub NewBreadcrumbItem (Text As String, Href As String) As PUIBreadcrumbItem
	Dim item As PUIBreadcrumbItem
	item.Initialize
	item.Text = Text
	item.Href = Href
	Return item
End Sub

Public Sub NewBreadcrumbOptions As PUIBreadcrumbOptions
	Dim options As PUIBreadcrumbOptions
	options.Initialize
	Dim items1 As List
	items1.Initialize
	options.Items = items1
	options.AriaLabel = "breadcrumb"
	Return options
End Sub

Public Sub NewPageHeaderOptions (Title As String) As PUIPageHeaderOptions
	Dim options As PUIPageHeaderOptions
	options.Initialize
	options.Title = Title
	Return options
End Sub

Public Sub NewNavItemOptions (Text As String, Href As String) As PUINavItemOptions
	Dim options As PUINavItemOptions
	options.Initialize
	options.Text = Text
	options.Href = Href
	Return options
End Sub

Public Sub NewNavOptions As PUINavOptions
	Dim options As PUINavOptions
	options.Initialize
	Dim items1 As List
	items1.Initialize
	options.Items = items1
	Return options
End Sub

Public Sub NewNavbarOptions (Brand As String) As PUINavbarOptions
	Dim options As PUINavbarOptions
	options.Initialize
	Dim items1 As List
	items1.Initialize
	options.Brand = Brand
	options.Items = items1
	options.Breakpoint = "md"
	options.AriaLabel = "Main navigation"
	Return options
End Sub

Public Sub NewEmptyStateOptions (Title As String, Message As String) As PUIEmptyStateOptions
	Dim options As PUIEmptyStateOptions
	options.Initialize
	options.Title = Title
	options.Message = Message
	Return options
End Sub

Public Sub NewLoadingStateOptions (Text As String) As PUILoadingStateOptions
	Dim options As PUILoadingStateOptions
	options.Initialize
	options.Text = Text
	Return options
End Sub

' Builds a complete document skeleton: <html lang data-bs-theme> with head
' (charset, viewport, title, optional description meta) and an empty body.
' Rendering the returned root automatically prepends the HTML5 doctype
' (verified MiniHtml behaviour for the "html" tag). Attach head assets with
' StyleSheet / MetaDescription / Script, page content through PUI.Body.
Public Sub Document (Options As PUIPageOptions) As MiniHtml
	Dim options1 As PUIPageOptions = Options
	If options1 = Null Then options1 = NewPageOptions("")

	Dim html1 As MiniHtml
	html1.Initialize("html")
	Dim lang1 As String = options1.Lang.Trim
	If lang1 = "" Then lang1 = "en"
	html1.attr("lang", EscapeHtml(lang1))
	Dim theme1 As String = NormalizeTheme(options1.Theme)
	If theme1 <> "" Then html1.attr("data-bs-theme", theme1)

	Dim head1 As MiniHtml
	head1.Initialize("head")
	head1.up(html1)
	Dim charset1 As MiniHtml
	charset1.Initialize("meta")
	charset1.attr("charset", "utf-8")
	charset1.up(head1)
	Dim viewport1 As MiniHtml
	viewport1.Initialize("meta")
	viewport1.attr("name", "viewport")
	viewport1.attr("content", "width=device-width, initial-scale=1")
	viewport1.up(head1)
	Dim title1 As MiniHtml
	title1.Initialize("title")
	title1.up(head1)
	title1.text(EscapeHtml(options1.Title))
	If options1.Description <> "" Then
		Dim description1 As MiniHtml
		description1.Initialize("meta")
		description1.attr("name", "description")
		description1.attr("content", EscapeHtml(options1.Description))
		description1.up(head1)
	End If

	Dim body1 As MiniHtml
	body1.Initialize("body")
	body1.up(html1)
	If options1.BodyCssClass <> "" Then body1.cls(EscapeHtml(options1.BodyCssClass))
	Return html1
End Sub

' Returns the <head> element of a document built by Document.
Public Sub Head (Doc As MiniHtml) As MiniHtml
	If Doc = Null Then Return Null
	Return Doc.ChildByName("head")
End Sub

' Returns the <body> element of a document built by Document.
Public Sub Body (Doc As MiniHtml) As MiniHtml
	If Doc = Null Then Return Null
	Return Doc.ChildByName("body")
End Sub

' Appends <link rel="stylesheet" href="..."> to Parent (usually the head)
' and returns Parent.
Public Sub StyleSheet (Parent As MiniHtml, Href As String) As MiniHtml
	If Parent = Null Then Return Null
	Dim link1 As MiniHtml
	link1.Initialize("link")
	link1.attr("rel", "stylesheet")
	link1.attr("href", EscapeHtml(Href))
	link1.up(Parent)
	Return Parent
End Sub

' Appends <meta name="description" content="..."> to Parent and returns Parent.
Public Sub MetaDescription (Parent As MiniHtml, Content As String) As MiniHtml
	If Parent = Null Then Return Null
	Dim meta1 As MiniHtml
	meta1.Initialize("meta")
	meta1.attr("name", "description")
	meta1.attr("content", EscapeHtml(Content))
	meta1.up(Parent)
	Return Parent
End Sub

' Appends <script src="..."> to Parent (usually the end of the body).
' Defer adds the defer attribute. Scripts must never contain package user
' data; this helper only sets the src attribute. Returns Parent.
Public Sub Script (Parent As MiniHtml, Src As String, Defer As Boolean) As MiniHtml
	If Parent = Null Then Return Null
	Dim script1 As MiniHtml
	script1.Initialize("script")
	script1.attr("src", EscapeHtml(Src))
	If Defer Then script1.defer
	script1.up(Parent)
	Return Parent
End Sub

' Renders the page container: div.container, or div.container-fluid when
' Fluid is set, or div.container-{breakpoint} when Breakpoint is set
' (Fluid wins; Breakpoint only applies to the fixed container).
Public Sub Container (Options As PUIContainerOptions) As MiniHtml
	Dim options1 As PUIContainerOptions = Options
	If options1 = Null Then options1 = NewContainerOptions

	Dim container1 As MiniHtml
	container1.Initialize("div")
	If options1.Fluid Then
		container1.cls("container-fluid")
	Else If options1.Breakpoint <> "" Then
		container1.cls("container-" & NormalizeBreakpoint(options1.Breakpoint))
	Else
		container1.cls("container")
	End If
	If options1.CssClass <> "" Then container1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then container1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then container1.hidden
	Return container1
End Sub

' Renders a flexbox row: div.row. Nest col elements with .down(col1).
Public Sub Row (Options As PUIRowOptions) As MiniHtml
	Dim options1 As PUIRowOptions = Options
	If options1 = Null Then options1 = NewRowOptions

	Dim row1 As MiniHtml
	row1.Initialize("div")
	row1.cls("row")
	If options1.CssClass <> "" Then row1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then row1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then row1.hidden
	Return row1
End Sub

' Renders a grid column. Width 1-12 stays as col-12 (with Breakpoint:
' col-md-6). Width 0 with Auto renders col-auto (col-md-auto), width 0
' without Auto renders col (col-md). Invalid widths are logged and ignored.
' Nest inside PUI.Row with .down.
Public Sub Col (Options As PUIColOptions) As MiniHtml
	Dim options1 As PUIColOptions = Options
	If options1 = Null Then options1 = NewColOptions

	Dim col1 As MiniHtml
	col1.Initialize("div")
	col1.cls(NormalizeColClass(options1.Breakpoint, options1.Width, options1.Auto))
	If options1.CssClass <> "" Then col1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then col1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then col1.hidden
	Return col1
End Sub

' Renders a <button>, or an <a> styled as a button when Href is set.
' Unsafe URL schemes (for example javascript:) are rejected and logged; the
' link is then rendered without an href attribute.
Public Sub Button (Options As PUIButtonOptions) As MiniHtml
	Dim options1 As PUIButtonOptions = Options
	If options1 = Null Then
		Dim emptyOptions As PUIButtonOptions
		emptyOptions.Initialize
		options1 = emptyOptions
	End If

	Dim variant As String = NormalizeVariant(options1.Variant)
	Dim sizeClass As String = NormalizeSize(options1.Size)
	Dim label As String = EscapeHtml(options1.Text)

	If options1.Href <> "" Then
		Dim link1 As MiniHtml
		link1.Initialize("a")
		link1.cls("btn btn-" & variant)
		If sizeClass <> "" Then link1.cls(sizeClass)
		If options1.CssClass <> "" Then link1.cls(EscapeHtml(options1.CssClass))
		If options1.Id <> "" Then link1.attr("id", EscapeHtml(options1.Id))
		If IsSafeUrl(options1.Href) Then
			link1.attr("href", EscapeHtml(options1.Href))
		Else
			LogError("PakaiUI: rejected unsafe button URL: " & options1.Href)
		End If
		If options1.Disabled Then
			link1.cls("disabled")
			link1.attr("aria-disabled", "true")
			link1.attr("tabindex", "-1")
		End If
		If options1.Hidden Then link1.hidden
		link1.text(label)
		Return link1
	End If

	Dim button1 As MiniHtml
	button1.Initialize("button")
	button1.attr("type", NormalizeButtonType(options1.ButtonType))
	button1.cls("btn btn-" & variant)
	If sizeClass <> "" Then button1.cls(sizeClass)
	If options1.CssClass <> "" Then button1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then button1.attr("id", EscapeHtml(options1.Id))
	If options1.Disabled Then button1.disabled
	If options1.Hidden Then button1.hidden
	button1.text(label)
	Return button1
End Sub

' Renders a complete card from text-only options.
' Optional image (top), header, body and footer are emitted in that order.
' Unsafe image URLs are rejected and logged; the image is then omitted.
' To compose arbitrary content inside a card use the CardHeader, CardBody,
' CardFooter, CardTitle and CardText part factories, or append to the
' element returned by ChildByClass("card-body").
Public Sub Card (Options As PUICardOptions) As MiniHtml
	Dim options1 As PUICardOptions = Options
	If options1 = Null Then
		Dim emptyOptions As PUICardOptions
		emptyOptions.Initialize
		options1 = emptyOptions
	End If

	Dim card1 As MiniHtml
	card1.Initialize("div")
	card1.cls("card")
	If options1.CssClass <> "" Then card1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then card1.attr("id", EscapeHtml(options1.Id))

	If options1.ImageSrc <> "" Then
		If IsSafeUrl(options1.ImageSrc) Then
			Dim image1 As MiniHtml = Tag("img")
			image1.cls("card-img-top")
			image1.attr("src", EscapeHtml(options1.ImageSrc))
			image1.attr("alt", EscapeHtml(options1.ImageAlt))
			image1.up(card1)
		Else
			LogError("PakaiUI: rejected unsafe card image URL: " & options1.ImageSrc)
		End If
	End If

	If options1.HeaderText <> "" Then
		Dim header1 As MiniHtml = CardHeader
		header1.up(card1).text(EscapeHtml(options1.HeaderText))
	End If

	If options1.Title <> "" Or options1.Subtitle <> "" Or options1.BodyText <> "" Then
		Dim body1 As MiniHtml = CardBody
		body1.up(card1)
		If options1.Title <> "" Then
			Dim title1 As MiniHtml = CardTitle
			title1.up(body1).text(EscapeHtml(options1.Title))
		End If
		If options1.Subtitle <> "" Then
			Dim subtitle1 As MiniHtml
			subtitle1.Initialize("h6")
			subtitle1.cls("card-subtitle mb-2 text-body-secondary")
			subtitle1.up(body1).text(EscapeHtml(options1.Subtitle))
		End If
		If options1.BodyText <> "" Then
			Dim text1 As MiniHtml = CardText
			text1.up(body1).text(EscapeHtml(options1.BodyText))
		End If
	End If

	If options1.FooterText <> "" Then
		Dim footer1 As MiniHtml = CardFooter
		footer1.up(card1).text(EscapeHtml(options1.FooterText))
	End If
	If options1.Hidden Then card1.hidden
	Return card1
End Sub

Public Sub CardHeader As MiniHtml
	Return Tag("div").cls("card-header")
End Sub

Public Sub CardBody As MiniHtml
	Return Tag("div").cls("card-body")
End Sub

Public Sub CardFooter As MiniHtml
	Return Tag("div").cls("card-footer")
End Sub

Public Sub CardTitle As MiniHtml
	Return Tag("h5").cls("card-title")
End Sub

Public Sub CardText As MiniHtml
	Return Tag("p").cls("card-text")
End Sub

' Short status, count or category label: span.badge with text-bg-* variant.
' Pill adds rounded-pill. Only base variants are valid (no outline/link).
Public Sub Badge (Options As PUIBadgeOptions) As MiniHtml
	Dim options1 As PUIBadgeOptions = Options
	If options1 = Null Then
		Dim emptyOptions As PUIBadgeOptions
		emptyOptions.Initialize
		options1 = emptyOptions
	End If

	Dim badge1 As MiniHtml = Tag("span")
	badge1.cls("badge text-bg-" & NormalizeBaseVariant(options1.Variant, "badge"))
	If options1.Pill Then badge1.cls("rounded-pill")
	If options1.CssClass <> "" Then badge1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then badge1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then badge1.hidden
	badge1.text(EscapeHtml(options1.Text))
	Return badge1
End Sub

' Contextual alert: div.alert.alert-{variant} with role="alert".
' Dismissible adds alert-dismissible fade show and a Bootstrap close button.
' The close button needs Bootstrap's JavaScript; without it the button is inert
' but the alert content remains fully readable.
Public Sub Alert (Options As PUIAlertOptions) As MiniHtml
	Dim options1 As PUIAlertOptions = Options
	If options1 = Null Then
		Dim emptyOptions As PUIAlertOptions
		emptyOptions.Initialize
		options1 = emptyOptions
	End If

	Dim alert1 As MiniHtml = Tag("div")
	alert1.cls("alert alert-" & NormalizeBaseVariant(options1.Variant, "alert"))
	alert1.attr("role", "alert")
	If options1.Dismissible Then
		alert1.cls("alert-dismissible")
		alert1.cls("fade")
		alert1.cls("show")
	End If
	If options1.CssClass <> "" Then alert1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then alert1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then alert1.hidden

	If options1.Title <> "" Then
		Dim title1 As MiniHtml = Tag("h4").cls("alert-heading")
		title1.text(EscapeHtml(options1.Title))
		title1.up(alert1)
	End If
	If options1.Message <> "" Then
		Dim message1 As MiniHtml = Tag("p").cls("mb-0")
		message1.text(EscapeHtml(options1.Message))
		message1.up(alert1)
	End If
	If options1.Dismissible Then
		Dim close1 As MiniHtml = Tag("button")
		close1.attr("type", "button")
		close1.cls("btn-close")
		close1.attr("data-bs-dismiss", "alert")
		close1.attr("aria-label", "Close")
		close1.up(alert1)
	End If
	Return alert1
End Sub

' Breadcrumb navigation: nav[aria-label] > ol.breadcrumb > li.breadcrumb-item.
' The active item is rendered as text with class active and aria-current="page";
' it never emits a link even when Href is set.
Public Sub Breadcrumb (Options As PUIBreadcrumbOptions) As MiniHtml
	Dim options1 As PUIBreadcrumbOptions = Options
	If options1 = Null Then options1 = NewBreadcrumbOptions

	Dim nav1 As MiniHtml = Tag("nav")
	Dim label As String = options1.AriaLabel.Trim
	If label = "" Then label = "breadcrumb"
	nav1.attr("aria-label", EscapeHtml(label))
	If options1.CssClass <> "" Then nav1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then nav1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then nav1.hidden

	Dim list1 As MiniHtml = Tag("ol").cls("breadcrumb")
	list1.up(nav1)
	If options1.Items <> Null Then
		For i = 0 To options1.Items.Size - 1
			Dim item As PUIBreadcrumbItem = options1.Items.Get(i)
			Dim listItem As MiniHtml = Tag("li").cls("breadcrumb-item")
			If item.Active Then
				listItem.cls("active")
				listItem.attr("aria-current", "page")
			End If
			If item.Active Or item.Href = "" Then
				listItem.text(EscapeHtml(item.Text))
			Else If IsSafeUrl(item.Href) Then
				Dim link1 As MiniHtml = Tag("a")
				link1.attr("href", EscapeHtml(item.Href))
				link1.text(EscapeHtml(item.Text))
				link1.up(listItem)
			Else
				LogError("PakaiUI: rejected unsafe breadcrumb URL: " & item.Href)
				listItem.text(EscapeHtml(item.Text))
			End If
			listItem.up(list1)
		Next
	End If
	Return nav1
End Sub

' Page title block: header.border-bottom > h1.h3 + optional subtitle.
Public Sub PageHeader (Options As PUIPageHeaderOptions) As MiniHtml
	Dim options1 As PUIPageHeaderOptions = Options
	If options1 = Null Then options1 = NewPageHeaderOptions("")

	Dim header1 As MiniHtml = Tag("header").cls("pb-2 mb-4 border-bottom")
	If options1.CssClass <> "" Then header1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then header1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then header1.hidden

	Dim title1 As MiniHtml = Tag("h1").cls("h3")
	title1.text(EscapeHtml(options1.Title))
	title1.up(header1)
	If options1.Subtitle <> "" Then
		Dim subtitle1 As MiniHtml = Tag("p").cls("text-body-secondary mb-0")
		subtitle1.text(EscapeHtml(options1.Subtitle))
		subtitle1.up(header1)
	End If
	Return header1
End Sub

' Navigation list: ul.nav with optional nav-pills, nav-tabs or flex-column.
' Tabs win over Pills when both are set. Items are appended as NavItem.
Public Sub Nav (Options As PUINavOptions) As MiniHtml
	Dim options1 As PUINavOptions = Options
	If options1 = Null Then options1 = NewNavOptions

	Dim nav1 As MiniHtml = Tag("ul").cls("nav")
	If options1.Tabs Then
		nav1.cls("nav-tabs")
	Else If options1.Pills Then
		nav1.cls("nav-pills")
	End If
	If options1.Vertical Then nav1.cls("flex-column")
	If options1.CssClass <> "" Then nav1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then nav1.attr("id", EscapeHtml(options1.Id))
	If options1.AriaLabel <> "" Then nav1.attr("aria-label", EscapeHtml(options1.AriaLabel))
	If options1.Hidden Then nav1.hidden

	If options1.Items <> Null Then
		For i = 0 To options1.Items.Size - 1
			Dim item As PUINavItemOptions = options1.Items.Get(i)
			NavItem(item).up(nav1)
		Next
	End If
	Return nav1
End Sub

' One navigation entry: li.nav-item > a.nav-link (or span.nav-link when no
' safe href is available). Id and CssClass apply to the link; Hidden hides
' the list item. Active items keep their link and add aria-current="page".
Public Sub NavItem (Options As PUINavItemOptions) As MiniHtml
	Dim options1 As PUINavItemOptions = Options
	If options1 = Null Then options1 = NewNavItemOptions("", "")

	Dim listItem As MiniHtml = Tag("li").cls("nav-item")
	If options1.Hidden Then listItem.hidden

	Dim linkClass As String = "nav-link"
	If options1.Active Then linkClass = linkClass & " active"
	If options1.Disabled Then linkClass = linkClass & " disabled"

	Dim useLink As Boolean = options1.Href <> "" And IsSafeUrl(options1.Href)
	If options1.Href <> "" And Not(useLink) Then
		LogError("PakaiUI: rejected unsafe navigation URL: " & options1.Href)
	End If
	Dim link1 As MiniHtml
	If useLink Then
		link1 = Tag("a")
		link1.attr("href", EscapeHtml(options1.Href))
	Else
		link1 = Tag("span")
	End If
	link1.cls(linkClass)
	If options1.CssClass <> "" Then link1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then link1.attr("id", EscapeHtml(options1.Id))
	If options1.Active Then link1.attr("aria-current", "page")
	If options1.Disabled Then
		link1.attr("aria-disabled", "true")
		link1.attr("tabindex", "-1")
	End If
	link1.text(EscapeHtml(options1.Text))
	link1.up(listItem)
	Return listItem
End Sub

' Top-level navigation bar: nav.navbar > div.container-fluid with an optional
' brand link and a ul.navbar-nav built from Items. There is no collapse
' toggler, so items stay visible and wrap on small screens without JavaScript.
Public Sub Navbar (Options As PUINavbarOptions) As MiniHtml
	Dim options1 As PUINavbarOptions = Options
	If options1 = Null Then options1 = NewNavbarOptions("")

	Dim nav1 As MiniHtml = Tag("nav").cls("navbar")
	Dim breakpoint1 As String = options1.Breakpoint.Trim
	If breakpoint1 = "" Then
		nav1.cls("navbar-expand")
	Else
		nav1.cls("navbar-expand-" & NormalizeBreakpoint(breakpoint1))
	End If
	nav1.cls("bg-body-tertiary")
	nav1.cls("flex-wrap")
	If options1.CssClass <> "" Then nav1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then nav1.attr("id", EscapeHtml(options1.Id))
	Dim label As String = options1.AriaLabel.Trim
	If label = "" Then label = "Main navigation"
	nav1.attr("aria-label", EscapeHtml(label))
	If options1.Hidden Then nav1.hidden

	Dim inner1 As MiniHtml = Tag("div").cls("container-fluid")
	inner1.up(nav1)
	If options1.Brand <> "" Then
		Dim brand1 As MiniHtml = Tag("a").cls("navbar-brand")
		If options1.Href <> "" Then
			If IsSafeUrl(options1.Href) Then
				brand1.attr("href", EscapeHtml(options1.Href))
			Else
				LogError("PakaiUI: rejected unsafe navbar brand URL: " & options1.Href)
			End If
		End If
		brand1.text(EscapeHtml(options1.Brand))
		brand1.up(inner1)
	End If

	Dim list1 As MiniHtml = Tag("ul").cls("navbar-nav")
	list1.up(inner1)
	If options1.Items <> Null Then
		For i = 0 To options1.Items.Size - 1
			Dim item As PUINavItemOptions = options1.Items.Get(i)
			NavItem(item).up(list1)
		Next
	End If
	Return nav1
End Sub

' Empty-state panel: optional icon, title, message and action button.
' The action is rendered only when ActionText is set. Attach HTMX attributes
' to the returned button by locating it with ChildByClass("btn") if needed.
Public Sub EmptyState (Options As PUIEmptyStateOptions) As MiniHtml
	Dim options1 As PUIEmptyStateOptions = Options
	If options1 = Null Then options1 = NewEmptyStateOptions("", "")

	Dim box1 As MiniHtml = Tag("div").cls("text-center py-5")
	If options1.CssClass <> "" Then box1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then box1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then box1.hidden

	If options1.IconClass <> "" Then
		Dim icon1 As MiniHtml = Tag("i")
		icon1.cls("bi " & EscapeHtml(options1.IconClass))
		icon1.cls("fs-1 text-body-secondary")
		icon1.attr("aria-hidden", "true")
		icon1.up(box1)
	End If
	If options1.Title <> "" Then
		Dim title1 As MiniHtml = Tag("h2").cls("h4")
		title1.text(EscapeHtml(options1.Title))
		title1.up(box1)
	End If
	If options1.Message <> "" Then
		Dim message1 As MiniHtml = Tag("p").cls("text-body-secondary mb-0")
		message1.text(EscapeHtml(options1.Message))
		message1.up(box1)
	End If
	If options1.ActionText <> "" Then
		Dim actionOptions As PUIButtonOptions = NewButtonOptions(options1.ActionText)
		actionOptions.Href = options1.ActionHref
		actionOptions.CssClass = "mt-3"
		Button(actionOptions).up(box1)
	End If
	Return box1
End Sub

' Loading indicator: div[role=status] > spinner-border + label.
' Only the small size is meaningful in Bootstrap 5.3; other sizes are logged
' and ignored. An empty Text still produces screen-reader text.
Public Sub LoadingState (Options As PUILoadingStateOptions) As MiniHtml
	Dim options1 As PUILoadingStateOptions = Options
	If options1 = Null Then options1 = NewLoadingStateOptions("")

	Dim box1 As MiniHtml = Tag("div").cls("d-flex align-items-center gap-2")
	If options1.Centered Then box1.cls("justify-content-center")
	If options1.CssClass <> "" Then box1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then box1.attr("id", EscapeHtml(options1.Id))
	box1.attr("role", "status")
	If options1.Hidden Then box1.hidden

	Dim spinner1 As MiniHtml = Tag("div").cls("spinner-border")
	Dim sizeClass As String = NormalizeSpinnerSize(options1.Size)
	If sizeClass <> "" Then spinner1.cls(sizeClass)
	spinner1.cls("text-" & NormalizeBaseVariant(options1.Variant, "loading state"))
	spinner1.attr("aria-hidden", "true")
	spinner1.up(box1)

	Dim label1 As MiniHtml = Tag("span")
	If options1.Text = "" Then
		label1.cls("visually-hidden")
		label1.text("Loading...")
	Else
		label1.text(EscapeHtml(options1.Text))
	End If
	label1.up(box1)
	Return box1
End Sub

' Returns True for relative URLs and for the http, https, mailto and tel schemes.
' Anything else, including javascript:, data: and vbscript:, is rejected.
Public Sub IsSafeUrl (Url As String) As Boolean
	Dim value As String = Url.Trim.ToLowerCase
	If value = "" Then Return False
	If value.Contains(Chr(9)) Or value.Contains(Chr(10)) Or value.Contains(Chr(13)) Then Return False
	Dim colonIndex As Int = value.IndexOf(":")
	Dim slashIndex As Int = value.IndexOf("/")
	If colonIndex > -1 And (slashIndex = -1 Or colonIndex < slashIndex) Then
		Dim scheme As String = value.SubString2(0, colonIndex)
		If scheme = "http" Or scheme = "https" Or scheme = "mailto" Or scheme = "tel" Then Return True
		Return False
	End If
	Return True
End Sub

Private Sub Tag (Name As String) As MiniHtml
	Dim tag1 As MiniHtml
	tag1.Initialize(Name)
	Return tag1
End Sub

Private Sub NormalizeVariant (Variant As String) As String
	Dim value As String = Variant.Trim.ToLowerCase
	If value = "" Then Return VariantPrimary
	Dim allowed() As String = Array As String(VariantPrimary, VariantSecondary, VariantSuccess, VariantDanger, _
		VariantWarning, VariantInfo, VariantLight, VariantDark, VariantLink, _
		VariantOutlinePrimary, VariantOutlineSecondary, VariantOutlineSuccess, VariantOutlineDanger, _
		VariantOutlineWarning, VariantOutlineInfo, VariantOutlineLight, VariantOutlineDark)
	If allowed.As(List).IndexOf(value) > -1 Then Return value
	Log("PakaiUI: unknown button variant '" & value & "'; using primary")
	Return VariantPrimary
End Sub

' Base variants are the ones Bootstrap uses for badge (text-bg-*), alert
' (alert-*) and text-* utilities. Outline and link variants are button-only.
Private Sub NormalizeBaseVariant (Variant As String, Component As String) As String
	Dim value As String = Variant.Trim.ToLowerCase
	Select value
		Case VariantPrimary, VariantSecondary, VariantSuccess, VariantDanger, _
			VariantWarning, VariantInfo, VariantLight, VariantDark
			Return value
		Case ""
			Return VariantPrimary
		Case Else
			Log("PakaiUI: unknown " & Component & " variant '" & value & "'; using primary")
			Return VariantPrimary
	End Select
End Sub

Private Sub NormalizeSpinnerSize (Size As String) As String
	Dim value As String = Size.Trim.ToLowerCase
	Select value
		Case SizeSmall
			Return "spinner-border-sm"
		Case ""
			Return ""
		Case Else
			Log("PakaiUI: loading state supports only the sm size; ignoring '" & value & "'")
			Return ""
	End Select
End Sub

Private Sub NormalizeSize (Size As String) As String
	Dim value As String = Size.Trim.ToLowerCase
	Select value
		Case SizeSmall
			Return "btn-sm"
		Case SizeLarge
			Return "btn-lg"
		Case Else
			Return ""
	End Select
End Sub

Private Sub NormalizeButtonType (ButtonType As String) As String
	Dim value As String = ButtonType.Trim.ToLowerCase
	Select value
		Case "button", "submit", "reset"
			Return value
		Case Else
			Return "button"
	End Select
End Sub

Private Sub NormalizeTheme (Theme As String) As String
	Dim value As String = Theme.Trim.ToLowerCase
	Select value
		Case ThemeLight, ThemeDark
			Return value
		Case Else
			If value <> "" Then
				Log("PakaiUI: unknown theme '" & value & "'; rendering no data-bs-theme attribute")
			End If
			Return ""
	End Select
End Sub

' Lower-cases and validates a Bootstrap breakpoint; unknown values are
' logged and rendered as the unmodified lower-cased value so a future
' Bootstrap release is not blocked by a hardcoded PakaiUI list.
Private Sub NormalizeBreakpoint (Breakpoint As String) As String
	Dim value As String = Breakpoint.Trim.ToLowerCase
	Select value
		Case "sm", "md", "lg", "xl", "xxl"
			Return value
		Case Else
			Log("PakaiUI: unexpected breakpoint '" & value & "'; rendering it as written")
			Return value
	End Select
End Sub

' Builds the Bootstrap column class from the PUIColOptions fields.
Private Sub NormalizeColClass (Breakpoint As String, Width As Int, Auto As Boolean) As String
	Dim prefix As String = "col"
	Dim breakpoint1 As String = Breakpoint.Trim.ToLowerCase
	If breakpoint1 <> "" Then prefix = "col-" & breakpoint1
	If Width > 0 Then
		If Width > 12 Then
			Log("PakaiUI: col width " & Width & " is outside Bootstrap's 1-12 scale; rendering without a width modifier")
			Return prefix
		End If
		Return prefix & "-" & Width
	End If
	If Auto Then Return prefix & "-auto"
	Return prefix
End Sub
