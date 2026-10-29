B4J=true
Group=PakaiUI
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' PakaiUI gallery - home page handler (plain jServer, no Pakai Server).
' Builds the whole gallery page through PUI composition; every text value
' passes through PUI.AddText / PUI.EscapeHtml, every attribute through
' escaped literals.
Sub Class_Globals
	Private Const AssetBase As String = ""
	Private Const BootstrapVersion As String = "5.3.8"
	Private Const IconsVersion As String = "1.13.1"
	Private Const HtmxVersion As String = "2.0.8"
	Private Const PakaiUIVersion As String = "0.12"
	Private Const UrlPing As String = "/hx/ping"
	Private Const UrlEcho As String = "/hx/echo"
	Private Const UrlSpin As String = "/hx/spin"
	Private Const UrlEmpty As String = "/hx/empty"
End Sub

Public Sub Initialize
End Sub

Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	If req.RequestURI <> "/" Then Return True
	resp.ContentType = "text/html;charset=utf-8"
	resp.Write(BuildPage(ValidateTheme(req.GetParameter("theme"))))
	Return False
End Sub

' Unknown theme values fall back to the browser default (PUI.ThemeAuto).
Private Sub ValidateTheme (Requested As String) As String
	If Requested = PUI.ThemeLight Then Return PUI.ThemeLight
	If Requested = PUI.ThemeDark Then Return PUI.ThemeDark
	Return PUI.ThemeAuto
End Sub

Private Sub BuildPage (Theme As String) As String
	Dim pageOptions As PUIPageOptions = PUI.NewPageOptions("PakaiUI Gallery")
	pageOptions.Theme = Theme
	pageOptions.Description = "Standalone PakaiUI gallery: plain jServer, Bootstrap 5.3, HTMX 2; no Pakai Server."
	Dim page As MiniHtml = PUI.Document(pageOptions)
	Dim head1 As MiniHtml = PUI.Head(page)
	PUI.StyleSheet(head1, AssetBase & "/assets/css/bootstrap.min.css?v=" & BootstrapVersion)
	PUI.StyleSheet(head1, AssetBase & "/assets/css/bootstrap-icons.min.css?v=" & IconsVersion)
	PUI.StyleSheet(head1, AssetBase & "/assets/css/pakaiui.css?v=" & PakaiUIVersion)
	Dim body1 As MiniHtml = PUI.Body(page)

	Dim container1 As MiniHtml = PUI.Container(Null)
	container1.cls("py-4")
	container1.up(body1)

	' Hero ----------------------------------------------------------------
	Dim hero1 As MiniHtml
	hero1.Initialize("header")
	hero1.cls("mb-4")
	hero1.up(container1)
	Dim headline1 As MiniHtml
	headline1.Initialize("h1")
	headline1.cls("display-5 fw-bold")
	headline1.up(hero1)
	headline1.text("PakaiUI Gallery")
	Dim lead1 As MiniHtml
	lead1.Initialize("p")
	lead1.cls("lead text-body-secondary")
	lead1.up(hero1)
	PUI.AddText(lead1, "Standalone jServer demo. The page is composed with PUI components, no Pakai Server involved.")
	ThemeNav(Theme).up(hero1)

	' Two-column row: components and the HTMX fixture ----------------------
	Dim grid1 As MiniHtml = PUI.Row(Null)
	grid1.cls("g-3")
	grid1.up(container1)
	Dim broadOptions As PUIColOptions
	broadOptions.Initialize
	broadOptions.Breakpoint = "md"
	broadOptions.Width = 7
	Dim broad1 As MiniHtml = PUI.Col(broadOptions)
	broad1.up(grid1)
	broad1.down(ComponentsCard)
	Dim narrowOptions As PUIColOptions
	narrowOptions.Initialize
	narrowOptions.Breakpoint = "md"
	narrowOptions.Width = 5
	Dim narrow1 As MiniHtml = PUI.Col(narrowOptions)
	narrow1.up(grid1)
	narrow1.down(HtmxFixtureCard)

	' Core components (M2) ------------------------------------------------
	Dim coreHeaderOptions As PUIPageHeaderOptions = PUI.NewPageHeaderOptions("Core components")
	coreHeaderOptions.Subtitle = "Badges, alerts, breadcrumbs, navigation and explicit empty/loading states."
	coreHeaderOptions.CssClass = "mt-5"
	PUI.PageHeader(coreHeaderOptions).up(container1)

	Dim coreGrid As MiniHtml = PUI.Row(Null)
	coreGrid.cls("g-3")
	coreGrid.up(container1)
	Dim coreColOptions As PUIColOptions
	coreColOptions.Initialize
	coreColOptions.Breakpoint = "md"
	coreColOptions.Width = 4

	Dim coreCol1 As MiniHtml = PUI.Col(coreColOptions)
	coreCol1.up(coreGrid)
	coreCol1.down(BadgesAndAlertsCard)

	Dim coreCol2 As MiniHtml = PUI.Col(coreColOptions)
	coreCol2.up(coreGrid)
	coreCol2.down(NavigationCard)

	Dim coreCol3 As MiniHtml = PUI.Col(coreColOptions)
	coreCol3.up(coreGrid)
	coreCol3.down(StatesCard)

	' Scripts at the end of the body --------------------------------------
	PUI.Script(body1, AssetBase & "/assets/js/bootstrap.min.js?v=" & BootstrapVersion, True)
	PUI.Script(body1, AssetBase & "/assets/js/htmx.min.js?v=" & HtmxVersion, True)

	' Footer --------------------------------------------------------------
	Dim footer1 As MiniHtml
	footer1.Initialize("footer")
	footer1.cls("mt-4 text-body-secondary small")
	footer1.up(container1)
	PUI.AddText(footer1, "PakaiUI " & PakaiUIVersion & " - Bootstrap " & BootstrapVersion & " - HTMX " & HtmxVersion _
		& " - assets self-hosted, no CSS or JS build step, no Node.js.")
	Return page.build
End Sub

' Server-side light/dark switch: two links rather than client-side JS.
Private Sub ThemeNav (Current As String) As MiniHtml
	Dim nav1 As MiniHtml
	nav1.Initialize("nav")
	nav1.cls("mt-3")
	nav1.attr("aria-label", "Theme switch")
	Dim lightOptions As PUIButtonOptions
	lightOptions.Initialize
	lightOptions.Text = "Light theme"
	lightOptions.Variant = PUI.VariantOutlineSecondary
	lightOptions.Href = "/?theme=light"
	Dim light1 As MiniHtml = PUI.Button(lightOptions)
	If Current = PUI.ThemeLight Then light1.attr("aria-current", "page")
	light1.up(nav1)
	Dim darkOptions As PUIButtonOptions
	darkOptions.Initialize
	darkOptions.Text = "Dark theme"
	darkOptions.Variant = PUI.VariantOutlineSecondary
	darkOptions.Href = "/?theme=dark"
	Dim dark1 As MiniHtml = PUI.Button(darkOptions)
	If Current = PUI.ThemeDark Then dark1.attr("aria-current", "page")
	dark1.up(nav1)
	Return nav1
End Sub

Private Sub ComponentsCard As MiniHtml
	Dim options As PUICardOptions = PUI.NewCardOptions("Components", "Buttons and cards, composed and escaped server-side.")
	Dim card1 As MiniHtml = PUI.Card(options)
	Dim body1 As MiniHtml = card1.ChildByClass("card-body")
	Dim buttons1 As MiniHtml
	buttons1.Initialize("div")
	buttons1.cls("d-flex flex-wrap gap-2 mb-3")
	buttons1.up(body1)
	buttons1.down(PUI.Button(MakeButton("Primary", PUI.VariantPrimary, "")))
	buttons1.down(PUI.Button(MakeButton("Outline danger", PUI.VariantOutlineDanger, "")))
	buttons1.down(PUI.Button(MakeButton("Small success", PUI.VariantSuccess, PUI.SizeSmall)))
	Dim disabledOptions As PUIButtonOptions = MakeButton("Disabled", PUI.VariantSecondary, "")
	disabledOptions.Disabled = True
	buttons1.down(PUI.Button(disabledOptions))
	Dim linkOptions As PUIButtonOptions = MakeButton("Dark theme (link)", PUI.VariantLink, "")
	linkOptions.Href = "/?theme=dark"
	buttons1.down(PUI.Button(linkOptions))
	Dim inner As PUICardOptions = PUI.NewCardOptions("Escape demo", "")
	inner.CssClass = "bg-body-tertiary"
	Dim innerCard As MiniHtml = PUI.Card(inner)
	buttons1.down(innerCard)
	Dim escapeNote As MiniHtml
	escapeNote.Initialize("p")
	escapeNote.cls("mb-0 small")
	escapeNote.up(innerCard.ChildByClass("card-body"))
	PUI.AddText(escapeNote, "<script>alert(1)</script> stays literal text; nothing here can run.")
	Return card1
End Sub

' The M0-defined HTMX 2.x baseline fixture (M0-RECONNAISSANCE section 9).
Private Sub HtmxFixtureCard As MiniHtml
	Dim options As PUICardOptions = PUI.NewCardOptions("HTMX " & HtmxVersion & " baseline fixture", "")
	Dim card1 As MiniHtml = PUI.Card(options)
	Dim body1 As MiniHtml = card1.ChildByClass("card-body")

	' 1. hx-get /hx/ping --------------------------------------------------
	Dim note1 As MiniHtml
	note1.Initialize("p")
	note1.cls("text-body-secondary small mb-2")
	note1.up(body1)
	PUI.AddText(note1, "Ping issues GET " & UrlPing & " and swaps the target below (innerHTML). Without JavaScript the form falls back to a normal GET navigation.")
	Dim pingForm As MiniHtml
	pingForm.Initialize("form")
	pingForm.attr("action", UrlPing)
	pingForm.attr("method", "get")
	pingForm.cls("mb-2")
	pingForm.up(body1)
	Dim pingButton As MiniHtml = PUI.Button(MakeButton("Ping", PUI.VariantPrimary, PUI.SizeSmall))
	pingButton.attr("hx-get", UrlPing)
	pingButton.attr("hx-target", "#m0-htmx")
	pingButton.attr("hx-swap", "innerHTML")
	pingForm.down(pingButton)
	Dim pingTarget As MiniHtml
	pingTarget.Initialize("div")
	pingTarget.cls("p-2 bg-body-tertiary rounded")
	pingTarget.attr("id", "m0-htmx")
	pingTarget.up(body1)
	PUI.AddText(pingTarget, "idle")

	' 2. hx-post form -----------------------------------------------------
	Dim note2 As MiniHtml
	note2.Initialize("p")
	note2.cls("text-body-secondary small mb-2 mt-3")
	note2.up(body1)
	PUI.AddText(note2, "Send posts the form by XHR; without JavaScript it degrades to a normal POST that renders the fragment alone.")
	Dim postForm As MiniHtml
	postForm.Initialize("form")
	postForm.attr("action", UrlEcho)
	postForm.attr("method", "post")
	postForm.attr("hx-post", UrlEcho)
	postForm.attr("hx-target", "#m0-echo")
	postForm.attr("hx-swap", "innerHTML")
	postForm.cls("mb-2")
	postForm.up(body1)
	Dim nameInput As MiniHtml
	nameInput.Initialize("input")
	nameInput.attr("type", "text")
	nameInput.attr("name", "name")
	nameInput.attr("value", "Pakai")
	nameInput.attr("placeholder", "Your name")
	nameInput.cls("form-control mb-2")
	postForm.down(nameInput)
	Dim sendOptions As PUIButtonOptions = MakeButton("Send", PUI.VariantPrimary, PUI.SizeSmall)
	sendOptions.ButtonType = "submit"
	postForm.down(PUI.Button(sendOptions))
	Dim echoTarget As MiniHtml
	echoTarget.Initialize("div")
	echoTarget.cls("p-2 bg-body-tertiary rounded")
	echoTarget.attr("id", "m0-echo")
	echoTarget.up(body1)
	PUI.AddText(echoTarget, "no POST yet")

	' 3. hx-swap outerHTML ------------------------------------------------
	Dim note3 As MiniHtml
	note3.Initialize("p")
	note3.cls("text-body-secondary small mb-2 mt-3")
	note3.up(body1)
	PUI.AddText(note3, "This button swaps itself (outerHTML): the replacement is a chip, so the demo can be re-run only by reloading.")
	Dim spinButton As MiniHtml = PUI.Button(MakeButton("Swap me (outerHTML)", PUI.VariantOutlineSuccess, PUI.SizeSmall))
	spinButton.attr("id", "m0-spin")
	spinButton.attr("hx-get", UrlSpin)
	spinButton.attr("hx-target", "this")
	spinButton.attr("hx-swap", "outerHTML")
	spinButton.up(body1)

	' 4. 204 No Content ---------------------------------------------------
	Dim note4 As MiniHtml
	note4.Initialize("p")
	note4.cls("text-body-secondary small mb-2 mt-3")
	note4.up(body1)
	PUI.AddText(note4, "The server answers 204 No Content, so HTMX performs no swap.")
	Dim emptyButton As MiniHtml = PUI.Button(MakeButton("Empty response", PUI.VariantOutlineSecondary, PUI.SizeSmall))
	emptyButton.attr("hx-get", UrlEmpty)
	emptyButton.up(body1)
	Return card1
End Sub

Private Sub BadgesAndAlertsCard As MiniHtml
	Dim options As PUICardOptions = PUI.NewCardOptions("Badges and alerts", "")
	Dim card1 As MiniHtml = PUI.Card(options)
	Dim body1 As MiniHtml = card1.ChildByClass("card-body")

	Dim badges1 As MiniHtml
	badges1.Initialize("div")
	badges1.cls("d-flex flex-wrap gap-2 mb-3")
	badges1.up(body1)
	badges1.down(PUI.Badge(PUI.NewBadgeOptions("New")))
	Dim stableOptions As PUIBadgeOptions = PUI.NewBadgeOptions("Stable")
	stableOptions.Variant = PUI.VariantSuccess
	stableOptions.Pill = True
	badges1.down(PUI.Badge(stableOptions))
	Dim deprecatedOptions As PUIBadgeOptions = PUI.NewBadgeOptions("Deprecated")
	deprecatedOptions.Variant = PUI.VariantDanger
	badges1.down(PUI.Badge(deprecatedOptions))

	Dim infoOptions As PUIAlertOptions = PUI.NewAlertOptions("Bootstrap and HTMX are served from the local assets folder.")
	infoOptions.Title = "Self-hosted assets"
	infoOptions.Variant = PUI.VariantInfo
	infoOptions.CssClass = "mb-2"
	PUI.Alert(infoOptions).up(body1)

	Dim savedOptions As PUIAlertOptions = PUI.NewAlertOptions("The close button uses Bootstrap's JavaScript; without it the alert stays visible.")
	savedOptions.Title = "Dismissible"
	savedOptions.Variant = PUI.VariantSuccess
	savedOptions.Dismissible = True
	savedOptions.CssClass = "mb-0"
	PUI.Alert(savedOptions).up(body1)
	Return card1
End Sub

Private Sub NavigationCard As MiniHtml
	Dim options As PUICardOptions = PUI.NewCardOptions("Navigation and breadcrumb", "")
	Dim card1 As MiniHtml = PUI.Card(options)
	Dim body1 As MiniHtml = card1.ChildByClass("card-body")

	Dim crumbOptions As PUIBreadcrumbOptions = PUI.NewBreadcrumbOptions
	crumbOptions.Items.Add(PUI.NewBreadcrumbItem("Home", "/"))
	crumbOptions.Items.Add(PUI.NewBreadcrumbItem("Components", ""))
	Dim currentCrumb As PUIBreadcrumbItem = PUI.NewBreadcrumbItem("Navigation", "")
	currentCrumb.Active = True
	crumbOptions.Items.Add(currentCrumb)
	PUI.Breadcrumb(crumbOptions).up(body1)

	Dim navOptions As PUINavOptions = PUI.NewNavOptions
	navOptions.Pills = True
	navOptions.AriaLabel = "Component sections"
	Dim overviewItem As PUINavItemOptions = PUI.NewNavItemOptions("Overview", "/")
	overviewItem.Active = True
	navOptions.Items.Add(overviewItem)
	navOptions.Items.Add(PUI.NewNavItemOptions("HTMX baseline", "#m0-htmx"))
	navOptions.Items.Add(PUI.NewNavItemOptions("States", "#core-states"))
	Dim nav1 As MiniHtml = PUI.Nav(navOptions)
	nav1.cls("mb-3")
	nav1.up(body1)

	Dim navbarOptions As PUINavbarOptions = PUI.NewNavbarOptions("PakaiUI")
	navbarOptions.Href = "/"
	navbarOptions.Breakpoint = "sm"
	navbarOptions.Items.Add(PUI.NewNavItemOptions("Home", "/"))
	navbarOptions.Items.Add(PUI.NewNavItemOptions("Baseline", "#m0-htmx"))
	PUI.Navbar(navbarOptions).up(body1)
	Return card1
End Sub

Private Sub StatesCard As MiniHtml
	Dim options As PUICardOptions = PUI.NewCardOptions("Empty and loading states", "")
	Dim card1 As MiniHtml = PUI.Card(options)
	Dim body1 As MiniHtml = card1.ChildByClass("card-body")

	Dim emptyOptions As PUIEmptyStateOptions = PUI.NewEmptyStateOptions("No records yet", "Create the first record, or adjust the filters.")
	emptyOptions.IconClass = "bi-inbox"
	emptyOptions.ActionText = "Create record"
	emptyOptions.ActionHref = "#core-states"
	emptyOptions.CssClass = "py-4"
	Dim empty1 As MiniHtml = PUI.EmptyState(emptyOptions)
	empty1.attr("id", "core-states")
	empty1.up(body1)

	Dim loadingOptions As PUILoadingStateOptions = PUI.NewLoadingStateOptions("Loading records...")
	loadingOptions.Variant = PUI.VariantPrimary
	loadingOptions.Centered = True
	loadingOptions.CssClass = "border-top pt-3"
	PUI.LoadingState(loadingOptions).up(body1)
	Return card1
End Sub

Private Sub MakeButton (Text As String, Variant As String, Size As String) As PUIButtonOptions
	Dim options As PUIButtonOptions = PUI.NewButtonOptions(Text)
	options.Variant = Variant
	options.Size = Size
	Return options
End Sub
