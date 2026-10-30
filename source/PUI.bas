B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=StaticCode
Version=10.7
@EndOfDesignText@
' PakaiUI - server-rendered UI components for B4J web applications.
' Version: 0.16 (MiniHTML 4.04+ escaping compatibility)
' HTML foundation: MiniHTML 4.05 (https://github.com/pyhoon/MiniHTML4); 4.04 or newer required
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
	Public Const VERSION As String = "0.16"

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

	' Table column alignment values for PUITableColumn.Align.
	Public Const AlignStart As String = "start"
	Public Const AlignCenter As String = "center"
	Public Const AlignEnd As String = "end"

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

	' Form and data-display options (M3).
	' InputType is named InputType because "Type" is a B4X reserved word.
	Type PUIInputOptions (Label As String, Name As String, Id As String, Value As String, Placeholder As String, InputType As String, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, ReadOnly As Boolean, CssClass As String, Hidden As Boolean)
	Type PUITextareaOptions (Label As String, Name As String, Id As String, Value As String, Placeholder As String, Rows As Int, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, ReadOnly As Boolean, CssClass As String, Hidden As Boolean)
	Type PUISelectItem (Text As String, Value As String, Selected As Boolean, Disabled As Boolean)
	Type PUISelectOptions (Label As String, Name As String, Id As String, Items As List, SelectedValue As String, Placeholder As String, Multiple As Boolean, Size As String, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
	Type PUICheckboxOptions (Label As String, Name As String, Id As String, Value As String, Checked As Boolean, Inline As Boolean, Switch As Boolean, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
	Type PUIRadioOptions (Label As String, Name As String, Id As String, Value As String, Checked As Boolean, Inline As Boolean, HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, CssClass As String, Hidden As Boolean)
	Type PUITableColumn (Title As String, Field As String, Align As String)
	Type PUITableOptions (Columns As List, Rows As List, Caption As String, EmptyText As String, RowIdField As String, Responsive As Boolean, Striped As Boolean, Hover As Boolean, Bordered As Boolean, Compact As Boolean, Id As String, CssClass As String, Hidden As Boolean)
	Type PUIPaginationOptions (CurrentPage As Int, TotalPages As Int, HrefPattern As String, AriaLabel As String, Size As String, Id As String, CssClass As String, Hidden As Boolean)
	Type PUIFilterBarOptions (Action As String, Method As String, AriaLabel As String, Id As String, CssClass As String, Hidden As Boolean)

	' Optional interaction options (M4). Htmx and Alpine emit typed attributes;
	' they never load a script. Modal and Toast use Bootstrap's JavaScript when
	' it is present, and ThemeSwitcher/Sidebar work without any JavaScript.
	Type PUIHtmxOptions (Url As String, Method As String, Target As String, Swap As String, Trigger As String, Confirm As String, Indicator As String, PushUrl As Boolean)
	Type PUIAlpineOptions (Data As String, Show As String, Text As String, Model As String, Click As String, Init As String, ClassName As String)
	Type PUIModalOptions (Id As String, Title As String, BodyText As String, FooterText As String, CloseText As String, Size As String, Scrollable As Boolean, Centered As Boolean, StaticBackdrop As Boolean)
	Type PUIModalTriggerOptions (Text As String, Target As String, Variant As String, Size As String, ButtonType As String, Id As String, CssClass As String, Disabled As Boolean, Hidden As Boolean)
	Type PUIToastOptions (Id As String, Title As String, Message As String, Variant As String, Dismissible As Boolean, Autohide As Boolean, DelayMs As Int, CssClass As String, Hidden As Boolean)
	Type PUIThemeSwitcherOptions (Current As String, LightHref As String, DarkHref As String, AutoHref As String, AriaLabel As String, Size As String, Id As String, CssClass As String, Hidden As Boolean)
	Type PUISidebarOptions (Brand As String, Href As String, Title As String, Items As List, AriaLabel As String, Sticky As Boolean, Border As Boolean, Id As String, CssClass As String, Hidden As Boolean)

	' Counter for generated field ids when neither Id nor Name is provided.
	Private mFieldCounter As Int
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
	tag1.text(Html, True, False)
	Return tag1
End Sub

' Appends escaped text to an element and returns the element.
Public Sub AddText (Parent As MiniHtml, Value As String) As MiniHtml
	If Parent = Null Then Return Null
	Parent.text(Value)
	Return Parent
End Sub

' Appends trusted HTML to an element and returns the element.
' Explicit counterpart of AddText. Never pass user input here.
Public Sub AddHtml (Parent As MiniHtml, Html As String) As MiniHtml
	If Parent = Null Then Return Null
	Parent.text(Html, True, False)
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

Public Sub NewInputOptions (Label As String, Name As String) As PUIInputOptions
	Dim options As PUIInputOptions
	options.Initialize
	options.Label = Label
	options.Name = Name
	Return options
End Sub

Public Sub NewTextareaOptions (Label As String, Name As String) As PUITextareaOptions
	Dim options As PUITextareaOptions
	options.Initialize
	options.Label = Label
	options.Name = Name
	options.Rows = 3
	Return options
End Sub

Public Sub NewSelectItem (Text As String, Value As String) As PUISelectItem
	Dim item As PUISelectItem
	item.Initialize
	item.Text = Text
	item.Value = Value
	Return item
End Sub

Public Sub NewSelectOptions (Label As String, Name As String) As PUISelectOptions
	Dim options As PUISelectOptions
	options.Initialize
	Dim items1 As List
	items1.Initialize
	options.Label = Label
	options.Name = Name
	options.Items = items1
	Return options
End Sub

Public Sub NewCheckboxOptions (Label As String) As PUICheckboxOptions
	Dim options As PUICheckboxOptions
	options.Initialize
	options.Label = Label
	Return options
End Sub

Public Sub NewRadioOptions (Label As String) As PUIRadioOptions
	Dim options As PUIRadioOptions
	options.Initialize
	options.Label = Label
	Return options
End Sub

Public Sub NewTableColumn (Title As String, Field As String) As PUITableColumn
	Dim column As PUITableColumn
	column.Initialize
	column.Title = Title
	column.Field = Field
	column.Align = AlignStart
	Return column
End Sub

Public Sub NewTableOptions As PUITableOptions
	Dim options As PUITableOptions
	options.Initialize
	Dim columns1 As List
	columns1.Initialize
	options.Columns = columns1
	Dim rows1 As List
	rows1.Initialize
	options.Rows = rows1
	options.Responsive = True
	Return options
End Sub

' Returns an empty Map for one table row. Add values with Put using the same
' field names as the PUITableColumn entries.
Public Sub NewTableRow As Map
	Dim row1 As Map
	row1.Initialize
	Return row1
End Sub

Public Sub NewPaginationOptions (CurrentPage As Int, TotalPages As Int, HrefPattern As String) As PUIPaginationOptions
	Dim options As PUIPaginationOptions
	options.Initialize
	options.CurrentPage = CurrentPage
	options.TotalPages = TotalPages
	options.HrefPattern = HrefPattern
	options.AriaLabel = "Page navigation"
	Return options
End Sub

Public Sub NewFilterBarOptions As PUIFilterBarOptions
	Dim options As PUIFilterBarOptions
	options.Initialize
	options.Method = "get"
	options.AriaLabel = "Filters"
	Return options
End Sub

Public Sub NewHtmxOptions (Url As String) As PUIHtmxOptions
	Dim options As PUIHtmxOptions
	options.Initialize
	options.Url = Url
	options.Method = "get"
	Return options
End Sub

Public Sub NewAlpineOptions As PUIAlpineOptions
	Dim options As PUIAlpineOptions
	options.Initialize
	Return options
End Sub

Public Sub NewModalOptions (Title As String, BodyText As String) As PUIModalOptions
	Dim options As PUIModalOptions
	options.Initialize
	options.Title = Title
	options.BodyText = BodyText
	options.CloseText = "Close"
	Return options
End Sub

Public Sub NewModalTriggerOptions (Text As String, Target As String) As PUIModalTriggerOptions
	Dim options As PUIModalTriggerOptions
	options.Initialize
	options.Text = Text
	options.Target = Target
	Return options
End Sub

Public Sub NewToastOptions (Message As String) As PUIToastOptions
	Dim options As PUIToastOptions
	options.Initialize
	options.Message = Message
	options.Dismissible = True
	options.DelayMs = 5000
	Return options
End Sub

Public Sub NewThemeSwitcherOptions (Current As String) As PUIThemeSwitcherOptions
	Dim options As PUIThemeSwitcherOptions
	options.Initialize
	options.Current = Current
	options.AutoHref = "?theme=auto"
	options.LightHref = "?theme=light"
	options.DarkHref = "?theme=dark"
	options.AriaLabel = "Theme"
	Return options
End Sub

Public Sub NewSidebarOptions (Brand As String) As PUISidebarOptions
	Dim options As PUISidebarOptions
	options.Initialize
	Dim items1 As List
	items1.Initialize
	options.Brand = Brand
	options.Items = items1
	options.AriaLabel = "Sidebar"
	options.Border = True
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
	title1.text(options1.Title)
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
	Dim label As String = options1.Text

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
		header1.up(card1).text(options1.HeaderText)
	End If

	If options1.Title <> "" Or options1.Subtitle <> "" Or options1.BodyText <> "" Then
		Dim body1 As MiniHtml = CardBody
		body1.up(card1)
		If options1.Title <> "" Then
			Dim title1 As MiniHtml = CardTitle
			title1.up(body1).text(options1.Title)
		End If
		If options1.Subtitle <> "" Then
			Dim subtitle1 As MiniHtml
			subtitle1.Initialize("h6")
			subtitle1.cls("card-subtitle mb-2 text-body-secondary")
			subtitle1.up(body1).text(options1.Subtitle)
		End If
		If options1.BodyText <> "" Then
			Dim text1 As MiniHtml = CardText
			text1.up(body1).text(options1.BodyText)
		End If
	End If

	If options1.FooterText <> "" Then
		Dim footer1 As MiniHtml = CardFooter
		footer1.up(card1).text(options1.FooterText)
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
	badge1.text(options1.Text)
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
		title1.text(options1.Title)
		title1.up(alert1)
	End If
	If options1.Message <> "" Then
		Dim message1 As MiniHtml = Tag("p").cls("mb-0")
		message1.text(options1.Message)
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
				listItem.text(item.Text)
			Else If IsSafeUrl(item.Href) Then
				Dim link1 As MiniHtml = Tag("a")
				link1.attr("href", EscapeHtml(item.Href))
				link1.text(item.Text)
				link1.up(listItem)
			Else
				LogError("PakaiUI: rejected unsafe breadcrumb URL: " & item.Href)
				listItem.text(item.Text)
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
	title1.text(options1.Title)
	title1.up(header1)
	If options1.Subtitle <> "" Then
		Dim subtitle1 As MiniHtml = Tag("p").cls("text-body-secondary mb-0")
		subtitle1.text(options1.Subtitle)
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
	link1.text(options1.Text)
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
		brand1.text(options1.Brand)
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
		title1.text(options1.Title)
		title1.up(box1)
	End If
	If options1.Message <> "" Then
		Dim message1 As MiniHtml = Tag("p").cls("text-body-secondary mb-0")
		message1.text(options1.Message)
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
		label1.text(options1.Text)
	End If
	label1.up(box1)
	Return box1
End Sub

' Text input field group: div.mb-3 > label + input.form-control + help/error.
' Id identifies the control (the label's for attribute points at it); CssClass
' and Hidden apply to the group. When Id is empty a stable id is derived from
' Name, so label association works without extra setup.
Public Sub Input (Options As PUIInputOptions) As MiniHtml
	Dim options1 As PUIInputOptions = Options
	If options1 = Null Then options1 = NewInputOptions("", "")

	Dim group1 As MiniHtml = Tag("div").cls("mb-3")
	If options1.CssClass <> "" Then group1.cls(EscapeHtml(options1.CssClass))
	If options1.Hidden Then group1.hidden

	Dim fieldId As String = ResolveFieldId(options1.Id, options1.Name, "input")
	AppendFieldLabel(group1, options1.Label, fieldId, options1.Required)

	Dim input1 As MiniHtml = Tag("input")
	input1.attr("type", NormalizeInputType(options1.InputType))
	input1.cls("form-control")
	Dim size1 As String = NormalizeFieldSize(options1.Size)
	If size1 <> "" Then input1.cls("form-control-" & size1)
	If options1.ErrorText <> "" Then input1.cls("is-invalid")
	input1.attr("id", EscapeHtml(fieldId))
	If options1.Name <> "" Then input1.attr("name", EscapeHtml(options1.Name))
	If options1.Value <> "" Then input1.attr("value", EscapeHtml(options1.Value))
	If options1.Placeholder <> "" Then input1.attr("placeholder", EscapeHtml(options1.Placeholder))
	If options1.Required Then input1.required
	If options1.Disabled Then input1.disabled
	If options1.ReadOnly Then input1.readonly
	If options1.ErrorText <> "" Then input1.attr("aria-invalid", "true")
	Dim describedBy1 As String = DescribedBy(fieldId, options1.HelpText, options1.ErrorText)
	If describedBy1 <> "" Then input1.attr("aria-describedby", EscapeHtml(describedBy1))
	input1.up(group1)

	AppendFieldFeedback(group1, fieldId, options1.HelpText, options1.ErrorText)
	Return group1
End Sub

' Multiline text field group. Value is rendered as escaped text content.
' Rows defaults to 3; values outside 1-50 are clamped with a log message.
Public Sub Textarea (Options As PUITextareaOptions) As MiniHtml
	Dim options1 As PUITextareaOptions = Options
	If options1 = Null Then options1 = NewTextareaOptions("", "")

	Dim group1 As MiniHtml = Tag("div").cls("mb-3")
	If options1.CssClass <> "" Then group1.cls(EscapeHtml(options1.CssClass))
	If options1.Hidden Then group1.hidden

	Dim fieldId As String = ResolveFieldId(options1.Id, options1.Name, "textarea")
	AppendFieldLabel(group1, options1.Label, fieldId, options1.Required)

	Dim textarea1 As MiniHtml = Tag("textarea")
	textarea1.cls("form-control")
	Dim size1 As String = NormalizeFieldSize(options1.Size)
	If size1 <> "" Then textarea1.cls("form-control-" & size1)
	If options1.ErrorText <> "" Then textarea1.cls("is-invalid")
	textarea1.attr("id", EscapeHtml(fieldId))
	If options1.Name <> "" Then textarea1.attr("name", EscapeHtml(options1.Name))
	textarea1.attr("rows", "" & NormalizeRows(options1.Rows))
	If options1.Placeholder <> "" Then textarea1.attr("placeholder", EscapeHtml(options1.Placeholder))
	If options1.Required Then textarea1.required
	If options1.Disabled Then textarea1.disabled
	If options1.ReadOnly Then textarea1.readonly
	If options1.ErrorText <> "" Then textarea1.attr("aria-invalid", "true")
	Dim describedBy1 As String = DescribedBy(fieldId, options1.HelpText, options1.ErrorText)
	If describedBy1 <> "" Then textarea1.attr("aria-describedby", EscapeHtml(describedBy1))
	textarea1.text(options1.Value)
	textarea1.up(group1)

	AppendFieldFeedback(group1, fieldId, options1.HelpText, options1.ErrorText)
	Return group1
End Sub

' Select field group. Item values are escaped and fall back to the item text
' when Value is empty. SelectedValue marks one option; for a multiple select
' set PUISelectItem.Selected on each selected item instead.
' Named SelectField because Select is a reserved B4X keyword.
Public Sub SelectField (Options As PUISelectOptions) As MiniHtml
	Dim options1 As PUISelectOptions = Options
	If options1 = Null Then options1 = NewSelectOptions("", "")

	Dim group1 As MiniHtml = Tag("div").cls("mb-3")
	If options1.CssClass <> "" Then group1.cls(EscapeHtml(options1.CssClass))
	If options1.Hidden Then group1.hidden

	Dim fieldId As String = ResolveFieldId(options1.Id, options1.Name, "select")
	AppendFieldLabel(group1, options1.Label, fieldId, options1.Required)

	Dim select1 As MiniHtml = Tag("select")
	select1.cls("form-select")
	Dim size1 As String = NormalizeFieldSize(options1.Size)
	If size1 <> "" Then select1.cls("form-select-" & size1)
	If options1.ErrorText <> "" Then select1.cls("is-invalid")
	select1.attr("id", EscapeHtml(fieldId))
	If options1.Name <> "" Then select1.attr("name", EscapeHtml(options1.Name))
	If options1.Required Then select1.required
	If options1.Disabled Then select1.disabled
	If options1.Multiple Then select1.bool("multiple")
	If options1.ErrorText <> "" Then select1.attr("aria-invalid", "true")
	Dim describedBy1 As String = DescribedBy(fieldId, options1.HelpText, options1.ErrorText)
	If describedBy1 <> "" Then select1.attr("aria-describedby", EscapeHtml(describedBy1))

	If options1.Placeholder <> "" Then
		Dim placeholder1 As MiniHtml = Tag("option")
		placeholder1.attr("value", "")
		If Not(options1.Multiple) And options1.SelectedValue = "" And Not(HasSelectedItem(options1.Items)) Then
			placeholder1.selected
		End If
		placeholder1.text(options1.Placeholder)
		placeholder1.up(select1)
	End If

	If options1.Items <> Null Then
		For i = 0 To options1.Items.Size - 1
			Dim item As PUISelectItem = options1.Items.Get(i)
			Dim option1 As MiniHtml = Tag("option")
			Dim itemValue As String = item.Value
			If itemValue = "" Then itemValue = item.Text
			option1.attr("value", EscapeHtml(itemValue))
			Dim itemSelected As Boolean = False
			If options1.Multiple Then
				itemSelected = item.Selected
			Else If options1.SelectedValue <> "" Then
				itemSelected = (itemValue = options1.SelectedValue)
			Else
				itemSelected = item.Selected
			End If
			If itemSelected Then option1.selected
			If item.Disabled Then option1.disabled
			option1.text(item.Text)
			option1.up(select1)
		Next
	End If

	select1.up(group1)
	AppendFieldFeedback(group1, fieldId, options1.HelpText, options1.ErrorText)
	Return group1
End Sub

' Checkbox field group: div.form-check > input + label + help/error.
' Switch renders a Bootstrap switch; Inline adds form-check-inline for use in
' filter rows. The checked state is explicit because B4X booleans default False.
Public Sub Checkbox (Options As PUICheckboxOptions) As MiniHtml
	Dim options1 As PUICheckboxOptions = Options
	If options1 = Null Then options1 = NewCheckboxOptions("")

	Return CheckControl("checkbox", options1.Label, options1.Name, options1.Id, options1.Value, _
		options1.Checked, options1.Inline, options1.Switch, options1.HelpText, options1.ErrorText, _
		options1.Required, options1.Disabled, options1.CssClass, options1.Hidden)
End Sub

' Radio field group. Use the same Name for every radio in a group and set
' Checked on the selected one.
Public Sub Radio (Options As PUIRadioOptions) As MiniHtml
	Dim options1 As PUIRadioOptions = Options
	If options1 = Null Then options1 = NewRadioOptions("")

	Return CheckControl("radio", options1.Label, options1.Name, options1.Id, options1.Value, _
		options1.Checked, options1.Inline, False, options1.HelpText, options1.ErrorText, _
		options1.Required, options1.Disabled, options1.CssClass, options1.Hidden)
End Sub

' Responsive table from column definitions and List-of-Map rows.
' Cell values are converted to text and escaped; Null values render empty.
' When Responsive is set the returned root is div.table-responsive, otherwise
' the table itself. RowIdField optionally copies a row value into <tr id>.
Public Sub Table (Options As PUITableOptions) As MiniHtml
	Dim options1 As PUITableOptions = Options
	If options1 = Null Then options1 = NewTableOptions

	Dim columnCount As Int = 0
	If options1.Columns <> Null Then columnCount = options1.Columns.Size

	Dim table1 As MiniHtml = Tag("table").cls("table")
	If options1.Striped Then table1.cls("table-striped")
	If options1.Hover Then table1.cls("table-hover")
	If options1.Bordered Then table1.cls("table-bordered")
	If options1.Compact Then table1.cls("table-sm")
	If options1.Caption <> "" Then table1.cls("caption-top")

	Dim root1 As MiniHtml = table1
	If options1.Responsive Then
		root1 = Tag("div").cls("table-responsive")
		table1.up(root1)
	End If
	If options1.CssClass <> "" Then root1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then root1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then root1.hidden

	If options1.Caption <> "" Then
		Dim caption1 As MiniHtml = Tag("caption")
		caption1.text(options1.Caption)
		caption1.up(table1)
	End If

	Dim head1 As MiniHtml = Tag("thead")
	head1.up(table1)
	Dim headRow1 As MiniHtml = Tag("tr")
	headRow1.up(head1)
	If options1.Columns <> Null Then
		For i = 0 To options1.Columns.Size - 1
			Dim column As PUITableColumn = options1.Columns.Get(i)
			Dim th1 As MiniHtml = Tag("th")
			th1.attr("scope", "col")
			Dim align1 As String = NormalizeAlignClass(column.Align, "table column")
			If align1 <> "" Then th1.cls(align1)
			th1.text(column.Title)
			th1.up(headRow1)
		Next
	End If

	Dim body1 As MiniHtml = Tag("tbody")
	body1.up(table1)
	Dim hasRows As Boolean = False
	If options1.Rows <> Null Then
		If options1.Rows.Size > 0 Then hasRows = True
	End If
	If hasRows = False Then
		Dim emptyRow1 As MiniHtml = Tag("tr")
		emptyRow1.up(body1)
		Dim emptyCell1 As MiniHtml = Tag("td")
		If columnCount > 0 Then emptyCell1.attr("colspan", "" & columnCount)
		emptyCell1.cls("text-center text-body-secondary")
		Dim emptyText1 As String = options1.EmptyText
		If emptyText1 = "" Then emptyText1 = "No data."
		emptyCell1.text(emptyText1)
		emptyCell1.up(emptyRow1)
	Else
		For i = 0 To options1.Rows.Size - 1
			Dim rowData As Map = options1.Rows.Get(i)
			Dim row1 As MiniHtml = Tag("tr")
			If options1.RowIdField <> "" Then
				Dim rowId1 As String = CellText(rowData, options1.RowIdField)
				If rowId1 <> "" Then row1.attr("id", EscapeHtml(rowId1))
			End If
			row1.up(body1)
			If options1.Columns <> Null Then
				For j = 0 To options1.Columns.Size - 1
					Dim rowColumn As PUITableColumn = options1.Columns.Get(j)
					Dim td1 As MiniHtml = Tag("td")
					Dim rowAlign As String = NormalizeAlignClass(rowColumn.Align, "table column")
					If rowAlign <> "" Then td1.cls(rowAlign)
					td1.text(CellText(rowData, rowColumn.Field))
					td1.up(row1)
				Next
			End If
		Next
	End If
	Return root1
End Sub

' Pagination navigation. HrefPattern must contain {page}, for example
' "/items?page={page}&sort=name". Pages outside 1..TotalPages are clamped.
' Page numbers and Previous/Next are rendered as links only when the pattern
' is usable and the resulting URL passes IsSafeUrl.
Public Sub Pagination (Options As PUIPaginationOptions) As MiniHtml
	Dim options1 As PUIPaginationOptions = Options
	If options1 = Null Then options1 = NewPaginationOptions(1, 1, "")

	Dim total1 As Int = options1.TotalPages
	If total1 < 1 Then total1 = 1
	Dim current1 As Int = options1.CurrentPage
	If current1 < 1 Then current1 = 1
	If current1 > total1 Then current1 = total1

	Dim nav1 As MiniHtml = Tag("nav")
	Dim label1 As String = options1.AriaLabel.Trim
	If label1 = "" Then label1 = "Page navigation"
	nav1.attr("aria-label", EscapeHtml(label1))
	If options1.CssClass <> "" Then nav1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then nav1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then nav1.hidden

	Dim list1 As MiniHtml = Tag("ul").cls("pagination")
	Dim paginationSize As String = NormalizePaginationSize(options1.Size)
	If paginationSize <> "" Then list1.cls(paginationSize)
	list1.up(nav1)

	Dim pattern1 As String = options1.HrefPattern
	Dim linkable1 As Boolean = pattern1.Contains("{page}")
	If pattern1 <> "" And Not(linkable1) Then
		Log("PakaiUI: pagination HrefPattern is missing {page}; rendering page numbers as text")
	End If

	AppendPageItem(list1, "Previous", current1 - 1, current1 > 1, False, pattern1, linkable1, "Previous page")
	If total1 <= 7 Then
		For page = 1 To total1
			AppendPageItem(list1, "" & page, page, True, page = current1, pattern1, linkable1, "")
		Next
	Else
		Dim windowStart As Int = current1 - 2
		Dim windowEnd As Int = current1 + 2
		If windowStart < 1 Then windowStart = 1
		If windowEnd > total1 Then windowEnd = total1
		If windowEnd - windowStart < 4 Then
			If windowStart = 1 Then
				windowEnd = windowStart + 4
				If windowEnd > total1 Then windowEnd = total1
			Else
				windowStart = windowEnd - 4
				If windowStart < 1 Then windowStart = 1
			End If
		End If

		If windowStart > 1 Then
			AppendPageItem(list1, "1", 1, True, current1 = 1, pattern1, linkable1, "")
			If windowStart > 2 Then AppendEllipsis(list1)
		End If
		For page = windowStart To windowEnd
			AppendPageItem(list1, "" & page, page, True, page = current1, pattern1, linkable1, "")
		Next
		If windowEnd < total1 Then
			If windowEnd < total1 - 1 Then AppendEllipsis(list1)
			AppendPageItem(list1, "" & total1, total1, True, current1 = total1, pattern1, linkable1, "")
		End If
	End If
	AppendPageItem(list1, "Next", current1 + 1, current1 < total1, False, pattern1, linkable1, "Next page")
	Return nav1
End Sub

' Filter/search form shell. Returns the form element so callers append Input,
' Select, Checkbox or Button controls with .up/.down. Method accepts get or
' post (default get); unsafe Action URLs are rejected and logged.
Public Sub FilterBar (Options As PUIFilterBarOptions) As MiniHtml
	Dim options1 As PUIFilterBarOptions = Options
	If options1 = Null Then options1 = NewFilterBarOptions

	Dim form1 As MiniHtml = Tag("form")
	form1.cls("row row-cols-lg-auto g-2 align-items-center mb-3")
	form1.attr("role", "search")
	Dim label1 As String = options1.AriaLabel.Trim
	If label1 = "" Then label1 = "Filters"
	form1.attr("aria-label", EscapeHtml(label1))
	form1.attr("method", NormalizeFormMethod(options1.Method))
	If options1.Action <> "" Then
		If IsSafeUrl(options1.Action) Then
			form1.attr("action", EscapeHtml(options1.Action))
		Else
			LogError("PakaiUI: rejected unsafe filter action URL: " & options1.Action)
		End If
	End If
	If options1.CssClass <> "" Then form1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then form1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then form1.hidden
	Return form1
End Sub

' Applies typed HTMX attributes to an existing element and returns it.
' The helper never loads HTMX; without the script the element renders normally.
' Unsafe URLs are rejected and logged. Trigger and Confirm are trusted strings.
Public Sub Htmx (Element As MiniHtml, Options As PUIHtmxOptions) As MiniHtml
	If Element = Null Or Options = Null Then Return Element
	Dim url1 As String = Options.Url.Trim
	If url1 = "" Then
		Log("PakaiUI: Htmx requires a Url; rendering the element without hx-* attributes")
		Return Element
	End If
	If Not(IsSafeUrl(url1)) Then
		LogError("PakaiUI: rejected unsafe HTMX URL: " & url1)
		Return Element
	End If

	Element.attr("hx-" & NormalizeHtmxMethod(Options.Method), EscapeHtml(url1))
	Dim target1 As String = Options.Target.Trim
	If target1 <> "" Then Element.attr("hx-target", EscapeHtml(target1))
	Dim swap1 As String = NormalizeHtmxSwap(Options.Swap)
	If swap1 <> "" Then Element.attr("hx-swap", swap1)
	Dim trigger1 As String = Options.Trigger.Trim
	If trigger1 <> "" Then Element.attr("hx-trigger", EscapeHtml(trigger1))
	If Options.Confirm <> "" Then Element.attr("hx-confirm", EscapeHtml(Options.Confirm))
	Dim indicator1 As String = Options.Indicator.Trim
	If indicator1 <> "" Then Element.attr("hx-indicator", EscapeHtml(indicator1))
	If Options.PushUrl Then Element.attr("hx-push-url", "true")
	Return Element
End Sub

' Applies typed Alpine.js attributes to an existing element and returns it.
' The helper never loads Alpine. Expression fields are trusted developer code,
' like PUI.RawHtml: never pass request data to Data, Show, Text, Model, Click,
' Init or ClassName.
Public Sub Alpine (Element As MiniHtml, Options As PUIAlpineOptions) As MiniHtml
	If Element = Null Or Options = Null Then Return Element
	If Options.Data.Trim <> "" Then Element.attr("x-data", EscapeHtml(Options.Data.Trim))
	If Options.Show.Trim <> "" Then Element.attr("x-show", EscapeHtml(Options.Show.Trim))
	If Options.Text.Trim <> "" Then Element.attr("x-text", EscapeHtml(Options.Text.Trim))
	If Options.Model.Trim <> "" Then Element.attr("x-model", EscapeHtml(Options.Model.Trim))
	If Options.Click.Trim <> "" Then Element.attr("x-on:click", EscapeHtml(Options.Click.Trim))
	If Options.Init.Trim <> "" Then Element.attr("x-init", EscapeHtml(Options.Init.Trim))
	If Options.ClassName.Trim <> "" Then Element.attr("x-bind:class", EscapeHtml(Options.ClassName.Trim))
	Return Element
End Sub

' Bootstrap modal dialog. Behavior owner: Bootstrap's JavaScript. The markup
' is inert without it; the content still exists in the DOM. Compose into
' ChildByClass("modal-body"). The returned id is available on the root.
' Named Modal rather than Dialog to match the Bootstrap component.
Public Sub Modal (Options As PUIModalOptions) As MiniHtml
	Dim options1 As PUIModalOptions = Options
	If options1 = Null Then options1 = NewModalOptions("", "")

	Dim modalId As String = ResolveFieldId(options1.Id, "", "modal")

	Dim modal1 As MiniHtml = Tag("div").cls("modal fade")
	modal1.attr("id", EscapeHtml(modalId))
	modal1.attr("tabindex", "-1")
	If options1.Title <> "" Then modal1.attr("aria-labelledby", EscapeHtml(modalId & "-label"))
	modal1.attr("aria-hidden", "true")
	If options1.StaticBackdrop Then
		modal1.attr("data-bs-backdrop", "static")
		modal1.attr("data-bs-keyboard", "false")
	End If

	Dim dialog1 As MiniHtml = Tag("div").cls("modal-dialog")
	Dim size1 As String = NormalizeModalSize(options1.Size)
	If size1 <> "" Then dialog1.cls(size1)
	If options1.Scrollable Then dialog1.cls("modal-dialog-scrollable")
	If options1.Centered Then dialog1.cls("modal-dialog-centered")
	dialog1.up(modal1)

	Dim content1 As MiniHtml = Tag("div").cls("modal-content")
	content1.up(dialog1)

	If options1.Title <> "" Then
		Dim header1 As MiniHtml = Tag("div").cls("modal-header")
		header1.up(content1)
		Dim title1 As MiniHtml = Tag("h2").cls("modal-title fs-5")
		title1.attr("id", EscapeHtml(modalId & "-label"))
		title1.text(options1.Title)
		title1.up(header1)
		Dim closeX1 As MiniHtml = Tag("button")
		closeX1.attr("type", "button")
		closeX1.cls("btn-close")
		closeX1.attr("data-bs-dismiss", "modal")
		closeX1.attr("aria-label", "Close")
		closeX1.up(header1)
	End If

	Dim body1 As MiniHtml = Tag("div").cls("modal-body")
	body1.text(options1.BodyText)
	body1.up(content1)

	If options1.FooterText <> "" Or options1.CloseText <> "" Then
		Dim footer1 As MiniHtml = Tag("div").cls("modal-footer")
		footer1.up(content1)
		If options1.FooterText <> "" Then
			Dim footerText1 As MiniHtml = Tag("p").cls("mb-0 me-auto")
			footerText1.text(options1.FooterText)
			footerText1.up(footer1)
		End If
		If options1.CloseText <> "" Then
			Dim closeButton1 As MiniHtml = Tag("button")
			closeButton1.attr("type", "button")
			closeButton1.cls("btn btn-secondary")
			closeButton1.attr("data-bs-dismiss", "modal")
			closeButton1.text(options1.CloseText)
			closeButton1.up(footer1)
		End If
	End If
	Return modal1
End Sub

' Button that opens a Bootstrap modal. Target accepts an id with or without a
' leading #. The trigger is inert without Bootstrap's JavaScript.
Public Sub ModalTrigger (Options As PUIModalTriggerOptions) As MiniHtml
	Dim options1 As PUIModalTriggerOptions = Options
	If options1 = Null Then options1 = NewModalTriggerOptions("", "")

	Dim buttonOptions1 As PUIButtonOptions = NewButtonOptions(options1.Text)
	buttonOptions1.Variant = options1.Variant
	buttonOptions1.Size = options1.Size
	buttonOptions1.ButtonType = options1.ButtonType
	buttonOptions1.Id = options1.Id
	buttonOptions1.CssClass = options1.CssClass
	buttonOptions1.Disabled = options1.Disabled
	buttonOptions1.Hidden = options1.Hidden
	Dim button1 As MiniHtml = Button(buttonOptions1)

	Dim target1 As String = options1.Target.Trim
	If target1.StartsWith("#") Then target1 = target1.SubString(1)
	If target1 = "" Then
		Log("PakaiUI: ModalTrigger requires a Target; rendering the button without modal attributes")
		Return button1
	End If
	button1.attr("data-bs-toggle", "modal")
	button1.attr("data-bs-target", EscapeHtml("#" & target1))
	Return button1
End Sub

' Bootstrap toast, rendered visible (toast show) so it is readable without
' JavaScript. Behavior owner: Bootstrap's JavaScript, which adds dismissal and
' autohide when it is loaded. The close button is inert without it.
Public Sub Toast (Options As PUIToastOptions) As MiniHtml
	Dim options1 As PUIToastOptions = Options
	If options1 = Null Then options1 = NewToastOptions("")

	Dim toast1 As MiniHtml = Tag("div").cls("toast show")
	Dim variant1 As String = NormalizeToastVariant(options1.Variant)
	If variant1 <> "" Then toast1.cls("text-bg-" & variant1)
	If options1.CssClass <> "" Then toast1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then toast1.attr("id", EscapeHtml(options1.Id))
	toast1.attr("role", "status")
	toast1.attr("aria-live", "polite")
	toast1.attr("aria-atomic", "true")
	If options1.Autohide Then
		toast1.attr("data-bs-autohide", "true")
		Dim delay1 As Int = options1.DelayMs
		If delay1 <= 0 Then delay1 = 5000
		toast1.attr("data-bs-delay", "" & delay1)
	Else
		toast1.attr("data-bs-autohide", "false")
	End If
	If options1.Hidden Then toast1.hidden

	If options1.Title <> "" Or options1.Dismissible Then
		Dim header1 As MiniHtml = Tag("div").cls("toast-header")
		header1.up(toast1)
		If options1.Title <> "" Then
			Dim title1 As MiniHtml = Tag("strong").cls("me-auto")
			title1.text(options1.Title)
			title1.up(header1)
		End If
		If options1.Dismissible Then
			Dim close1 As MiniHtml = Tag("button")
			close1.attr("type", "button")
			close1.cls("btn-close")
			If variant1 = VariantPrimary Or variant1 = VariantSecondary Or variant1 = VariantSuccess _
				Or variant1 = VariantDanger Or variant1 = VariantDark Then
				close1.cls("btn-close-white")
			End If
			close1.attr("data-bs-dismiss", "toast")
			close1.attr("aria-label", "Close")
			close1.up(header1)
		End If
	End If

	Dim body1 As MiniHtml = Tag("div").cls("toast-body")
	body1.text(options1.Message)
	body1.up(toast1)
	Return toast1
End Sub

' Theme switcher as a Bootstrap button group of server-rendered links.
' Behavior owner: the server. It works without JavaScript; the active link gets
' .active and aria-current="page". Hrefs are validated like every other URL.
Public Sub ThemeSwitcher (Options As PUIThemeSwitcherOptions) As MiniHtml
	Dim options1 As PUIThemeSwitcherOptions = Options
	If options1 = Null Then options1 = NewThemeSwitcherOptions(ThemeAuto)

	Dim group1 As MiniHtml = Tag("div").cls("btn-group")
	group1.attr("role", "group")
	Dim label1 As String = options1.AriaLabel.Trim
	If label1 = "" Then label1 = "Theme"
	group1.attr("aria-label", EscapeHtml(label1))
	If options1.CssClass <> "" Then group1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then group1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then group1.hidden

	Dim current1 As String = NormalizeTheme(options1.Current)
	AppendThemeButton(group1, "Auto", options1.AutoHref, current1 = ThemeAuto, options1.Size)
	AppendThemeButton(group1, "Light", options1.LightHref, current1 = ThemeLight, options1.Size)
	AppendThemeButton(group1, "Dark", options1.DarkHref, current1 = ThemeDark, options1.Size)
	Return group1
End Sub

' Sidebar navigation: an aside with optional brand, section title and a
' vertical Nav. Behavior owner: plain links and CSS; no JavaScript required.
' Sticky adds Bootstrap's sticky-top; place it in a flex/grid column.
Public Sub Sidebar (Options As PUISidebarOptions) As MiniHtml
	Dim options1 As PUISidebarOptions = Options
	If options1 = Null Then options1 = NewSidebarOptions("")

	Dim aside1 As MiniHtml = Tag("aside").cls("bg-body-tertiary p-3")
	If options1.Border Then aside1.cls("border-end")
	If options1.Sticky Then
		aside1.cls("sticky-top")
		aside1.cls("align-self-start")
	End If
	If options1.CssClass <> "" Then aside1.cls(EscapeHtml(options1.CssClass))
	If options1.Id <> "" Then aside1.attr("id", EscapeHtml(options1.Id))
	If options1.Hidden Then aside1.hidden

	If options1.Brand <> "" Then
		Dim brand1 As MiniHtml = Tag("a").cls("navbar-brand d-block mb-2")
		If options1.Href <> "" Then
			If IsSafeUrl(options1.Href) Then
				brand1.attr("href", EscapeHtml(options1.Href))
			Else
				LogError("PakaiUI: rejected unsafe sidebar brand URL: " & options1.Href)
			End If
		End If
		brand1.text(options1.Brand)
		brand1.up(aside1)
	End If

	If options1.Title <> "" Then
		Dim title1 As MiniHtml = Tag("h2").cls("h6 text-uppercase text-body-secondary")
		title1.text(options1.Title)
		title1.up(aside1)
	End If

	Dim navOptions1 As PUINavOptions = NewNavOptions
	navOptions1.Vertical = True
	navOptions1.Items = options1.Items
	Dim label1 As String = options1.AriaLabel.Trim
	If label1 = "" Then label1 = "Sidebar"
	navOptions1.AriaLabel = label1
	Dim nav1 As MiniHtml = Nav(navOptions1)
	nav1.cls("mb-0")
	nav1.up(aside1)
	Return aside1
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

' Appends <label class="form-label" for="..."> when LabelText is set.
' Required controls get a decorative asterisk; the control itself carries the
' required attribute, so assistive technology does not depend on the marker.
Private Sub AppendFieldLabel (Wrapper As MiniHtml, LabelText As String, FieldId As String, IsRequired As Boolean)
	If LabelText = "" Then Return
	Dim label1 As MiniHtml = Tag("label").cls("form-label")
	label1.attr("for", EscapeHtml(FieldId))
	label1.text(LabelText)
	If IsRequired Then
		Dim mark1 As MiniHtml = Tag("span").cls("text-danger")
		mark1.attr("aria-hidden", "true")
		mark1.text(" *")
		mark1.up(label1)
	End If
	label1.up(Wrapper)
End Sub

' Appends the optional helper and validation text. Both are plain escaped text
' so a server-side message can never inject markup.
Private Sub AppendFieldFeedback (Wrapper As MiniHtml, FieldId As String, HelpText As String, ErrorText As String)
	If HelpText <> "" Then
		Dim help1 As MiniHtml = Tag("div").cls("form-text")
		help1.attr("id", EscapeHtml(FieldId & "-help"))
		help1.text(HelpText)
		help1.up(Wrapper)
	End If
	If ErrorText <> "" Then
		Dim error1 As MiniHtml = Tag("div").cls("invalid-feedback")
		error1.attr("id", EscapeHtml(FieldId & "-error"))
		error1.text(ErrorText)
		error1.up(Wrapper)
	End If
End Sub

' Builds the aria-describedby value from the ids that are actually rendered.
Private Sub DescribedBy (FieldId As String, HelpText As String, ErrorText As String) As String
	Dim value As String = ""
	If HelpText <> "" Then value = FieldId & "-help"
	If ErrorText <> "" Then
		If value <> "" Then value = value & " "
		value = value & FieldId & "-error"
	End If
	Return value
End Sub

' Resolves the control id: explicit Id, then a sanitized Name, then a counter.
' A stable id is required so the label's for attribute has a target.
Private Sub ResolveFieldId (Id As String, Name As String, Prefix As String) As String
	Dim value As String = Id.Trim
	If value <> "" Then Return value
	value = SanitizeId(Name)
	If value <> "" Then Return "pui-" & value
	mFieldCounter = mFieldCounter + 1
	Return "pui-" & Prefix & "-" & mFieldCounter
End Sub

' Choice controls share a Name, so the derived id also includes the value to
' keep each checkbox or radio id unique. Set Id explicitly when values are empty.
Private Sub ResolveChoiceId (Id As String, Name As String, Value As String, Prefix As String) As String
	Dim value1 As String = Id.Trim
	If value1 <> "" Then Return value1
	Dim base1 As String = SanitizeId(Name)
	If base1 <> "" Then
		Dim valuePart1 As String = SanitizeId(Value)
		If valuePart1 <> "" Then base1 = base1 & "-" & valuePart1
		Return "pui-" & base1
	End If
	mFieldCounter = mFieldCounter + 1
	Return "pui-" & Prefix & "-" & mFieldCounter
End Sub

' Keeps letters, digits, dash, underscore and dot; replaces everything else.
Private Sub SanitizeId (Value As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To Value.Length - 1
		Dim c As Char = Value.CharAt(i)
		Dim code As Int = Asc(c)
		If (code >= 48 And code <= 57) Or (code >= 65 And code <= 90) Or (code >= 97 And code <= 122) _
			Or code = 45 Or code = 95 Or code = 46 Then
			sb.Append(c)
		Else
			sb.Append("-")
		End If
	Next
	Return sb.ToString.Trim
End Sub

Private Sub HasSelectedItem (Items As List) As Boolean
	If Items = Null Then Return False
	For i = 0 To Items.Size - 1
		Dim item As PUISelectItem = Items.Get(i)
		If item.Selected Then Return True
	Next
	Return False
End Sub

Private Sub NormalizeInputType (InputType As String) As String
	Dim value As String = InputType.Trim.ToLowerCase
	If value = "" Then Return "text"
	Select value
		Case "text", "email", "password", "number", "search", "url", "tel", _
			"date", "datetime-local", "month", "week", "time"
			Return value
		Case Else
			Log("PakaiUI: unsupported input type '" & value & "'; using text")
			Return "text"
	End Select
End Sub

Private Sub NormalizeFieldSize (Size As String) As String
	Dim value As String = Size.Trim.ToLowerCase
	Select value
		Case SizeSmall, SizeLarge
			Return value
		Case Else
			Return ""
	End Select
End Sub

Private Sub NormalizeRows (Rows As Int) As Int
	If Rows <= 0 Then Return 3
	If Rows > 50 Then
		Log("PakaiUI: textarea rows " & Rows & " clamped to 50")
		Return 50
	End If
	Return Rows
End Sub

' Shared renderer for Checkbox and Radio. InputType is "checkbox" or "radio".
Private Sub CheckControl (InputType As String, LabelText As String, Name As String, Id As String, _
		Value As String, Checked As Boolean, Inline As Boolean, Switch As Boolean, _
		HelpText As String, ErrorText As String, Required As Boolean, Disabled As Boolean, _
		CssClass As String, Hidden As Boolean) As MiniHtml

	Dim wrapper1 As MiniHtml = Tag("div").cls("form-check")
	If Inline Then wrapper1.cls("form-check-inline")
	If Switch Then wrapper1.cls("form-switch")
	If CssClass <> "" Then wrapper1.cls(EscapeHtml(CssClass))
	If Hidden Then wrapper1.hidden

	Dim fieldId As String = ResolveChoiceId(Id, Name, Value, InputType)

	Dim input1 As MiniHtml = Tag("input")
	input1.cls("form-check-input")
	If ErrorText <> "" Then input1.cls("is-invalid")
	input1.attr("type", InputType)
	input1.attr("id", EscapeHtml(fieldId))
	If Name <> "" Then input1.attr("name", EscapeHtml(Name))
	If Value <> "" Then input1.attr("value", EscapeHtml(Value))
	If Checked Then input1.checked
	If Required Then input1.required
	If Disabled Then input1.disabled
	If ErrorText <> "" Then input1.attr("aria-invalid", "true")
	Dim describedBy1 As String = DescribedBy(fieldId, HelpText, ErrorText)
	If describedBy1 <> "" Then input1.attr("aria-describedby", EscapeHtml(describedBy1))
	input1.up(wrapper1)

	If LabelText <> "" Then
		Dim label1 As MiniHtml = Tag("label").cls("form-check-label")
		label1.attr("for", EscapeHtml(fieldId))
		label1.text(LabelText)
		label1.up(wrapper1)
	End If

	AppendFieldFeedback(wrapper1, fieldId, HelpText, ErrorText)
	Return wrapper1
End Sub

' Reads one table cell as text. Missing keys and Null values render empty.
Private Sub CellText (RowMap As Map, Field As String) As String
	If RowMap = Null Or Field = "" Then Return ""
	If RowMap.ContainsKey(Field) = False Then Return ""
	Dim value As Object = RowMap.Get(Field)
	If value = Null Then Return ""
	Return "" & value
End Sub

Private Sub NormalizeAlignClass (Align As String, Component As String) As String
	Dim value As String = Align.Trim.ToLowerCase
	Select value
		Case "", AlignStart, "left"
			Return ""
		Case AlignCenter, "center"
			Return "text-center"
		Case AlignEnd, "right"
			Return "text-end"
		Case Else
			Log("PakaiUI: unknown " & Component & " alignment '" & value & "'; using default")
			Return ""
	End Select
End Sub

' Appends one pagination <li>. Active and disabled entries render a span;
' ordinary pages render a link when the pattern produces a safe URL.
Private Sub AppendPageItem (List As MiniHtml, Text As String, Page As Int, Enabled As Boolean, _
		Active As Boolean, Pattern As String, Linkable As Boolean, AriaLabel As String)

	Dim item1 As MiniHtml = Tag("li").cls("page-item")
	If Active Then item1.cls("active")
	If Not(Enabled) Then item1.cls("disabled")
	If Active Then item1.attr("aria-current", "page")

	Dim label1 As String = Text
	If Enabled And Not(Active) And Linkable And Page >= 1 Then
		Dim href1 As String = Pattern.Replace("{page}", "" & Page)
		If IsSafeUrl(href1) Then
			Dim link1 As MiniHtml = Tag("a").cls("page-link")
			link1.attr("href", EscapeHtml(href1))
			If AriaLabel <> "" Then link1.attr("aria-label", EscapeHtml(AriaLabel))
			link1.text(label1)
			link1.up(item1)
			item1.up(List)
			Return
		Else
			LogError("PakaiUI: rejected unsafe pagination URL: " & href1)
		End If
	End If

	Dim span1 As MiniHtml = Tag("span").cls("page-link")
	If AriaLabel <> "" Then span1.attr("aria-label", EscapeHtml(AriaLabel))
	span1.text(label1)
	span1.up(item1)
	item1.up(List)
End Sub

Private Sub AppendEllipsis (List As MiniHtml)
	Dim item1 As MiniHtml = Tag("li").cls("page-item disabled")
	Dim span1 As MiniHtml = Tag("span").cls("page-link")
	span1.attr("aria-hidden", "true")
	span1.text("...")
	span1.up(item1)
	item1.up(List)
End Sub

Private Sub NormalizePaginationSize (Size As String) As String
	Dim value As String = Size.Trim.ToLowerCase
	Select value
		Case SizeSmall
			Return "pagination-sm"
		Case SizeLarge
			Return "pagination-lg"
		Case Else
			Return ""
	End Select
End Sub

Private Sub NormalizeFormMethod (Method As String) As String
	Dim value As String = Method.Trim.ToLowerCase
	Select value
		Case "get", "post"
			Return value
		Case ""
			Return "get"
		Case Else
			Log("PakaiUI: unsupported filter method '" & value & "'; using get")
			Return "get"
	End Select
End Sub

Private Sub NormalizeHtmxMethod (Method As String) As String
	Dim value As String = Method.Trim.ToLowerCase
	Select value
		Case "get", "post", "put", "patch", "delete"
			Return value
		Case ""
			Return "get"
		Case Else
			Log("PakaiUI: unsupported HTMX method '" & value & "'; using get")
			Return "get"
	End Select
End Sub

Private Sub NormalizeHtmxSwap (Swap As String) As String
	Dim value As String = Swap.Trim.ToLowerCase
	Select value
		Case "innerhtml"
			Return "innerHTML"
		Case "outerhtml"
			Return "outerHTML"
		Case "beforebegin", "afterbegin", "beforeend", "afterend", "delete", "none"
			Return value
		Case ""
			Return ""
		Case Else
			Log("PakaiUI: unsupported HTMX swap '" & value & "'; using the HTMX default")
			Return ""
	End Select
End Sub

Private Sub NormalizeModalSize (Size As String) As String
	Dim value As String = Size.Trim.ToLowerCase
	Select value
		Case SizeSmall
			Return "modal-sm"
		Case SizeLarge
			Return "modal-lg"
		Case "xl"
			Return "modal-xl"
		Case Else
			If value <> "" Then Log("PakaiUI: unsupported modal size '" & value & "'; using the default")
			Return ""
	End Select
End Sub

Private Sub NormalizeToastVariant (Variant As String) As String
	Dim value As String = Variant.Trim.ToLowerCase
	Select value
		Case ""
			Return ""
		Case VariantPrimary, VariantSecondary, VariantSuccess, VariantDanger, _
			VariantWarning, VariantInfo, VariantLight, VariantDark
			Return value
		Case Else
			Log("PakaiUI: unknown toast variant '" & value & "'; rendering a neutral toast")
			Return ""
	End Select
End Sub

' Appends one link-style button to the theme group.
Private Sub AppendThemeButton (Group As MiniHtml, Text As String, Href As String, Active As Boolean, Size As String)
	Dim buttonOptions1 As PUIButtonOptions = NewButtonOptions(Text)
	buttonOptions1.Variant = VariantOutlineSecondary
	buttonOptions1.Size = Size
	buttonOptions1.Href = Href
	Dim button1 As MiniHtml = Button(buttonOptions1)
	If Active Then
		button1.cls("active")
		button1.attr("aria-current", "page")
	End If
	button1.up(Group)
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
