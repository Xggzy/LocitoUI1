-- LocitoUI Window System
-- Version 0.2.0

local Window = {}
Window.__index = Window

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Utility = require(script.Parent.Utility)
local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Notification = require(script.Parent.Notification)
local Tab = require(script.Parent.Components.Tab)

local function ResolveKeyCode(Key)
	if typeof(Key) == "EnumItem" then
		return Key
	end

	if typeof(Key) == "string" then
		local KeyName = Key:gsub("%s+", "")
		local Success, KeyCode = pcall(function()
			return Enum.KeyCode[KeyName]
		end)

		if Success and KeyCode then
			return KeyCode
		end

		local LowerKeyName = KeyName:lower()
		for _, EnumItem in ipairs(Enum.KeyCode:GetEnumItems()) do
			if EnumItem.Name:lower() == LowerKeyName then
				return EnumItem
			end
		end
	end

	return nil
end

local function ColorToHex(Color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(Color.R * 255 + 0.5),
		math.floor(Color.G * 255 + 0.5),
		math.floor(Color.B * 255 + 0.5)
	)
end

local function EscapeRichText(Text)
	local Escaped = tostring(Text)
	Escaped = Escaped:gsub("&", "&amp;")
	Escaped = Escaped:gsub("<", "&lt;")
	Escaped = Escaped:gsub(">", "&gt;")
	return Escaped
end

local function BuildTitleText(Settings, ThemeValues, TitleText)
	if typeof(Settings.TitleRichText) == "string" then
		return Settings.TitleRichText, true
	end

	local AccentWord = Settings.TitleAccent or Settings.AccentTitle or Settings.HighlightTitle
	local Version = Settings.Version or Settings.ScriptVersion
	if not AccentWord and not Version and Settings.TitleRichText ~= true then
		return TitleText, false
	end

	local Rendered = EscapeRichText(TitleText)
	local UsesRichText = Settings.TitleRichText == true

	if AccentWord then
		local Word = EscapeRichText(AccentWord)
		local StartIndex, EndIndex = Rendered:find(Word, 1, true)
		if StartIndex then
			local AccentColor = ColorToHex(Settings.TitleAccentColor or ThemeValues.Accent)
			Rendered = Rendered:sub(1, StartIndex - 1)
				.. "<font color=\"" .. AccentColor .. "\">"
				.. Rendered:sub(StartIndex, EndIndex)
				.. "</font>"
				.. Rendered:sub(EndIndex + 1)
			UsesRichText = true
		end
	end

	if Version then
		Rendered = Rendered
			.. " <font size=\"10\" color=\""
			.. ColorToHex(Settings.VersionColor or ThemeValues.Muted)
			.. "\">"
			.. EscapeRichText(Version)
			.. "</font>"
		UsesRichText = true
	end

	return Rendered, UsesRichText
end

function Window.new(Settings)
	Settings = Settings or {}

	if Settings.CustomTheme then
		local ThemeName = Settings.Theme or Settings.ThemeName or "Custom"
		Theme:Add(ThemeName, Settings.CustomTheme, Settings.BaseTheme)
		Theme:Set(ThemeName)
	elseif Settings.Theme then
		Theme:Set(Settings.Theme)
	end

	local self = setmetatable({}, Window)
	self.Settings = Settings
	self.Tabs = {}
	self.Connections = {}
	self.ActiveTab = nil
	self.Visible = true

	local CurrentTheme = Theme:Get()
	local Player = Players.LocalPlayer
	local ParentGui = Settings.Parent or (Player and Player:WaitForChild("PlayerGui"))
	local PreviewLayout = Settings.Layout == "Preview" or Settings.Style == "Preview" or Settings.PreviewLayout == true
	local WindowSize = Settings.Size or UDim2.new(0, Settings.Width or (PreviewLayout and 672 or 680), 0, Settings.Height or (PreviewLayout and 430 or 450))
	local TopBarHeight = Settings.TopBarHeight or Settings.TopbarHeight or (PreviewLayout and 54 or 56)
	local OuterPadding = Settings.Padding or (PreviewLayout and 12 or 14)
	local TopBarPadding = Settings.TopBarPadding or (PreviewLayout and 18 or OuterPadding)
	local Gap = Settings.Gap or (PreviewLayout and 14 or 14)
	local ContentGap = Settings.ContentGap or 10
	local SidebarWidth = Settings.SidebarWidth or (PreviewLayout and 160 or 160)
	local HasSidebar = Settings.Sidebar ~= false
	local ContentTop = TopBarHeight + ContentGap
	local ContentX = HasSidebar and ((PreviewLayout and SidebarWidth or OuterPadding + SidebarWidth) + Gap) or OuterPadding
	local ContentRightPadding = Settings.ContentRightPadding or (PreviewLayout and 12 or OuterPadding)
	local ContentBottomPadding = Settings.ContentBottomPadding or (PreviewLayout and 12 or OuterPadding)
	local ContentWidthOffset = -(ContentX + ContentRightPadding)
	local ContentHeightOffset = -(ContentTop + ContentBottomPadding)
	local SidebarX = Settings.SidebarX or (PreviewLayout and 0 or OuterPadding)
	local SidebarY = Settings.SidebarY or (PreviewLayout and TopBarHeight or ContentTop)
	local SidebarHeightOffset = Settings.SidebarHeightOffset or (PreviewLayout and -TopBarHeight or ContentHeightOffset)
	local ShowControls = Settings.Controls ~= false
	local ShowClose = ShowControls and Settings.CloseButton ~= false
	local ShowMinimize = ShowControls and Settings.MinimizeButton ~= false
	local ControlReserve = ShowControls and 90 or 16
	local LogoSize = Settings.LogoSize or (PreviewLayout and 28 or 32)
	local LogoRadius = Settings.LogoRadius or (PreviewLayout and 9 or 10)
	local TitleX = Settings.Logo == false and TopBarPadding or (TopBarPadding + LogoSize + 12)
	local MainAnchor = Settings.AnchorPoint or Vector2.new(0.5, 0.5)
	local MainPosition = Settings.Position or UDim2.new(0.5, 0, 0.5, 0)
	local Radius = Settings.Radius or CurrentTheme.CornerRadius
	local ShadowPadding = Settings.ShadowPadding or 22
	local ToggleTime = Settings.ToggleTime or Settings.ToggleAnimationTime or 0.2

	local Gui = Utility:Create("ScreenGui", {
		Name = Settings.GuiName or "LocitoUI",
		Enabled = true,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = Settings.DisplayOrder or 999999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = ParentGui,
	})
	self.Gui = Gui
	self.FullSize = WindowSize
	self.CustomHiddenSize = Settings.HiddenSize ~= nil
	self.HiddenSize = Settings.HiddenSize or UDim2.new(WindowSize.X.Scale, WindowSize.X.Offset, 0, 0)
	self.ToggleTime = ToggleTime
	self.ToggleKey = ResolveKeyCode(Settings.ToggleKey or Settings.ToggleKeybind or Settings.MenuKeybind)
	self.ShadowPadding = ShadowPadding

	local Shadow
	if Settings.Shadow ~= false then
		Shadow = Utility:Create("Frame", {
			Name = "Shadow",
			AnchorPoint = MainAnchor,
			Position = Settings.ShadowPosition or MainPosition,
			Size = Settings.ShadowSize or (WindowSize + UDim2.new(0, ShadowPadding, 0, ShadowPadding)),
			BackgroundColor3 = CurrentTheme.Shadow or Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = Settings.ShadowTransparency or 0.48,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Gui,
		})
		Utility:Round(Shadow, Radius + 8)
		Theme:Register(Shadow, "BackgroundColor3", "Shadow")
	end
	self.Shadow = Shadow
	self.ShadowFullSize = Shadow and Shadow.Size
	self.ShadowHiddenSize = Shadow and UDim2.new(WindowSize.X.Scale, WindowSize.X.Offset + ShadowPadding, 0, ShadowPadding)

	local Main = Utility:Create("Frame", {
		Name = "MainWindow",
		AnchorPoint = MainAnchor,
		Position = MainPosition,
		Size = WindowSize,
		BackgroundColor3 = CurrentTheme.Background,
		BackgroundTransparency = Settings.Transparency or Settings.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = Gui,
	})
	Utility:Round(Main, Radius)
	local MainStroke = Utility:Stroke(Main, CurrentTheme.Border, Settings.BorderThickness or 1)
	Theme:Register(Main, "BackgroundColor3", "Background")
	Theme:Register(MainStroke, "Color", "Border")
	self.Frame = Main

	if Settings.BackgroundLogo ~= false and (Settings.BackgroundLogo == true or PreviewLayout) then
		local BackgroundLogoSize = Settings.BackgroundLogoSize or (PreviewLayout and 176 or 150)
		local BackgroundLogoText = Settings.BackgroundLogoText or Settings.LogoText or "L"
		local BackgroundLogoSpeed = Settings.BackgroundLogoSpeed or Settings.BackgroundLogoRotationSpeed or 22
		local BackgroundLogo = Utility:Create("Frame", {
			Name = "AnimatedBackgroundLogo",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Settings.BackgroundLogoPosition or UDim2.new(1, -126, 1, -80),
			Size = UDim2.new(0, BackgroundLogoSize, 0, BackgroundLogoSize),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Main,
		})

		local GlowDisc = Utility:Create("Frame", {
			Name = "GlowDisc",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.82, 0, 0.82, 0),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.BackgroundLogoGlowTransparency or 0.92,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(GlowDisc, BackgroundLogoSize)
		Theme:Register(GlowDisc, "BackgroundColor3", "Accent")

		local OuterRing = Utility:Create("Frame", {
			Name = "OuterRing",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(OuterRing, BackgroundLogoSize)
		local OuterStroke = Utility:Stroke(OuterRing, CurrentTheme.Accent, 2, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(OuterStroke, "Color", "Accent")

		local InnerRing = Utility:Create("Frame", {
			Name = "InnerRing",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.68, 0, 0.68, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(InnerRing, BackgroundLogoSize)
		local InnerStroke = Utility:Stroke(InnerRing, CurrentTheme.AccentLight, 1, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(InnerStroke, "Color", "AccentLight")

		local Diamond = Utility:Create("Frame", {
			Name = "DiamondMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.46, 0, 0.46, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(Diamond, 10)
		local DiamondStroke = Utility:Stroke(Diamond, CurrentTheme.Accent, 2, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(DiamondStroke, "Color", "Accent")

		local InnerDiamond = Utility:Create("Frame", {
			Name = "InnerDiamondMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.28, 0, 0.28, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(InnerDiamond, 7)
		local InnerDiamondStroke = Utility:Stroke(InnerDiamond, CurrentTheme.AccentLight, 1, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(InnerDiamondStroke, "Color", "AccentLight")

		local Spoke = Utility:Create("Frame", {
			Name = "Spoke",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -18, 0, 2),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = 0.74,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(Spoke, "BackgroundColor3", "Accent")

		local LogoWatermark = Utility:Create("TextLabel", {
			Name = "LogoWatermark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Settings.BackgroundLogoFont or Enum.Font.GothamBlack,
			Text = BackgroundLogoText,
			TextColor3 = CurrentTheme.Accent,
			TextTransparency = Settings.BackgroundLogoTextTransparency or 0.82,
			TextSize = Settings.BackgroundLogoTextSize or math.floor(BackgroundLogoSize * 0.42),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(LogoWatermark, "TextColor3", "Accent")

		self.BackgroundLogo = BackgroundLogo
		self.BackgroundLogoText = LogoWatermark

		table.insert(self.Connections, RunService.RenderStepped:Connect(function(DeltaTime)
			if not BackgroundLogo.Parent then
				return
			end

			local Rotation = (BackgroundLogo.Rotation + DeltaTime * BackgroundLogoSpeed) % 360
			local Pulse = math.sin(os.clock() * 2.4)
			BackgroundLogo.Rotation = Rotation
			InnerRing.Rotation = -Rotation * 1.35
			Diamond.Rotation = 45 - Rotation * 0.55
			InnerDiamond.Rotation = 45 + Rotation * 0.7
			GlowDisc.BackgroundTransparency = math.clamp((Settings.BackgroundLogoGlowTransparency or 0.92) + Pulse * 0.035, 0.84, 0.97)
			GlowDisc.Size = UDim2.new(0.82 + Pulse * 0.03, 0, 0.82 + Pulse * 0.03, 0)
			LogoWatermark.Rotation = -Rotation
			LogoWatermark.TextTransparency = math.clamp((Settings.BackgroundLogoTextTransparency or 0.82) + Pulse * 0.04, 0.68, 0.92)
		end))
	end

	local TopBar = Utility:Create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, TopBarHeight),
		BackgroundColor3 = CurrentTheme.Background,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Theme:Register(TopBar, "BackgroundColor3", "Background")
	self.TopBar = TopBar

	if Settings.AccentLine ~= false then
		local AccentLineThemeKey = Settings.AccentLineThemeKey or (PreviewLayout and "Border" or "Accent")
		local AccentLine = Utility:Create("Frame", {
			Name = "AccentLine",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, Settings.AccentLineHeight or 1),
			BackgroundColor3 = CurrentTheme[AccentLineThemeKey] or CurrentTheme.Accent,
			BackgroundTransparency = Settings.AccentLineTransparency or (PreviewLayout and 0.35 or 0.35),
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Theme:Register(AccentLine, "BackgroundColor3", AccentLineThemeKey)
		self.AccentLine = AccentLine
	end

	local LogoY = math.floor((TopBarHeight - LogoSize) / 2)
	if Settings.Logo ~= false and (Settings.LogoGlow == true or (PreviewLayout and Settings.LogoGlow ~= false)) then
		local LogoGlow = Utility:Create("Frame", {
			Name = "LogoGlow",
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.LogoGlowTransparency or 0.84,
			Position = UDim2.new(0, TopBarPadding - 4, 0, LogoY - 4),
			Size = UDim2.new(0, LogoSize + 8, 0, LogoSize + 8),
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Utility:Round(LogoGlow, LogoRadius + 6)
		Theme:Register(LogoGlow, "BackgroundColor3", "Accent")
		self.LogoGlow = LogoGlow
	end

	local Logo = Utility:Create("TextLabel", {
		Name = "Logo",
		BackgroundColor3 = CurrentTheme.Surface,
		Position = UDim2.new(0, TopBarPadding, 0, LogoY),
		Size = UDim2.new(0, LogoSize, 0, LogoSize),
		Visible = Settings.Logo ~= false,
		Font = Settings.LogoFont or Enum.Font.GothamBold,
		Text = (Settings.LogoImage or Settings.LogoId) and "" or (Settings.LogoText or "L"),
		TextColor3 = CurrentTheme.AccentLight,
		TextSize = Settings.LogoTextSize or (PreviewLayout and 14 or 18),
		Parent = TopBar,
	})
	Utility:Round(Logo, LogoRadius)
	Theme:Register(Logo, "BackgroundColor3", "Surface")
	Theme:Register(Logo, "TextColor3", "AccentLight")
	self.Logo = Logo

	if Settings.LogoImage or Settings.LogoId then
		local LogoImage = Utility:Create("ImageLabel", {
			Name = "LogoImage",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			Image = Settings.LogoImage or Settings.LogoId,
			ImageColor3 = Settings.LogoImageColor or Color3.fromRGB(255, 255, 255),
			ScaleType = Settings.LogoScaleType or Enum.ScaleType.Fit,
			Parent = Logo,
		})
		self.LogoImage = LogoImage
	end

	local RawTitleText = Settings.Name or Settings.Title or "Locito Hub"
	local TitleText, TitleRichText = BuildTitleText(Settings, CurrentTheme, RawTitleText)
	local HasSubtitle = Settings.Subtitle ~= false and Settings.Subtitle ~= nil
	local TitleY = Settings.TitleY or (HasSubtitle and 9 or math.floor((TopBarHeight - 22) / 2))

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, TitleY),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 22),
		Font = Settings.TitleFont or Enum.Font.GothamBold,
		Text = TitleText,
		TextColor3 = CurrentTheme.Text,
		TextSize = Settings.TitleSize or (PreviewLayout and 14 or 18),
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = TitleRichText,
		Parent = TopBar,
	})
	Theme:Register(Title, "TextColor3", "Text")
	self.Title = Title

	local Subtitle = Utility:Create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 30),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 16),
		Visible = HasSubtitle,
		Font = Settings.SubtitleFont or Enum.Font.Gotham,
		Text = Settings.Subtitle or "Original Roblox UI Library",
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.SubtitleSize or 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Subtitle, "TextColor3", "SubText")
	self.Subtitle = Subtitle

	local Close = Utility:Create("TextButton", {
		Name = "Close",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -TopBarPadding, 0, math.floor((TopBarHeight - (Settings.ControlSize or (PreviewLayout and 24 or 28))) / 2)),
		Size = UDim2.new(0, Settings.ControlSize or (PreviewLayout and 24 or 28), 0, Settings.ControlSize or (PreviewLayout and 24 or 28)),
		Visible = ShowClose,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Settings.ControlTransparency or (PreviewLayout and 1 or 0),
		Font = Enum.Font.GothamBold,
		Text = Settings.CloseText or (PreviewLayout and "x" or "X"),
		TextColor3 = CurrentTheme.SubText,
		TextSize = 16,
		AutoButtonColor = false,
		Parent = TopBar,
	})
	Utility:Round(Close, 8)
	Theme:Register(Close, "BackgroundColor3", "Surface")
	Theme:Register(Close, "TextColor3", "SubText")

	local Minimize = Utility:Create("TextButton", {
		Name = "Minimize",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, ShowClose and -(TopBarPadding + 34) or -TopBarPadding, 0, math.floor((TopBarHeight - (Settings.ControlSize or (PreviewLayout and 24 or 28))) / 2)),
		Size = UDim2.new(0, Settings.ControlSize or (PreviewLayout and 24 or 28), 0, Settings.ControlSize or (PreviewLayout and 24 or 28)),
		Visible = ShowMinimize,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Settings.ControlTransparency or (PreviewLayout and 1 or 0),
		Font = Enum.Font.GothamBold,
		Text = "-",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 16,
		AutoButtonColor = false,
		Parent = TopBar,
	})
	Utility:Round(Minimize, 8)
	Theme:Register(Minimize, "BackgroundColor3", "Surface")
	Theme:Register(Minimize, "TextColor3", "SubText")

	local Sidebar = Utility:Create("Frame", {
		Name = "Sidebar",
		Position = UDim2.new(0, SidebarX, 0, SidebarY),
		Size = UDim2.new(0, SidebarWidth, 1, SidebarHeightOffset),
		Visible = HasSidebar,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Utility:Round(Sidebar, Settings.SidebarRadius or (PreviewLayout and 0 or Settings.PanelRadius or Radius))
	Theme:Register(Sidebar, "BackgroundColor3", "Secondary")
	self.Sidebar = Sidebar

	if HasSidebar and (Settings.SidebarDivider == true or (PreviewLayout and Settings.SidebarDivider ~= false)) then
		local SidebarDivider = Utility:Create("Frame", {
			Name = "SidebarDivider",
			Position = UDim2.new(0, SidebarWidth, 0, TopBarHeight),
			Size = UDim2.new(0, 1, 1, -TopBarHeight),
			BackgroundColor3 = CurrentTheme.Border,
			BackgroundTransparency = Settings.SidebarDividerTransparency or 0.45,
			BorderSizePixel = 0,
			Parent = Main,
		})
		Theme:Register(SidebarDivider, "BackgroundColor3", "Border")
		self.SidebarDivider = SidebarDivider
	end

	local SidebarListInset = Settings.SidebarListInset or (PreviewLayout and 8 or 8)
	local SidebarList = Utility:Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, SidebarListInset, 0, SidebarListInset),
		Size = UDim2.new(1, -(SidebarListInset * 2), 1, -(SidebarListInset * 2)),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = Sidebar,
	})
	Theme:Register(SidebarList, "ScrollBarImageColor3", "Accent")
	local SidebarLayout = Utility:List(SidebarList, 6)
	Utility:AutoCanvas(SidebarList, SidebarLayout, 12)
	self.SidebarList = SidebarList

	local Content = Utility:Create("Frame", {
		Name = "Content",
		Position = UDim2.new(0, ContentX, 0, ContentTop),
		Size = UDim2.new(1, ContentWidthOffset, 1, ContentHeightOffset),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = Settings.ContentTransparency or (PreviewLayout and 1 or 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})
	Utility:Round(Content, Settings.ContentRadius or Settings.PanelRadius or (PreviewLayout and 0 or Radius))
	Theme:Register(Content, "BackgroundColor3", "Secondary")
	self.Content = Content

	local NotificationHolder = Utility:Create("Frame", {
		Name = "NotificationHolder",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 290, 1, -32),
		BackgroundTransparency = 1,
		Parent = Gui,
	})
	local NotificationLayout = Utility:List(NotificationHolder, 8)
	NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	self.NotificationHolder = NotificationHolder

	if Settings.Draggable ~= false then
		self.DragDisconnect = Utility:MakeDraggable(TopBar, Main, function(Position)
			if Shadow then
				Shadow.Position = Position
			end
		end)
	end

	if ShowClose then
		Close.MouseButton1Click:Connect(function()
			self:Destroy()
		end)
	end

	local Minimized = false
	if ShowMinimize then
		Minimize.MouseButton1Click:Connect(function()
			Minimized = not Minimized
			Animation:Play(Main, {
				Size = Minimized and UDim2.new(self.FullSize.X.Scale, self.FullSize.X.Offset, 0, TopBarHeight) or self.FullSize,
			}, { Time = 0.22 })
			if Shadow and self.ShadowFullSize then
				Animation:Play(Shadow, {
					Size = Minimized and UDim2.new(self.ShadowFullSize.X.Scale, self.ShadowFullSize.X.Offset, 0, TopBarHeight + ShadowPadding) or self.ShadowFullSize,
				}, { Time = 0.22 })
			end
		end)
	end

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
		if not self.ToggleKey then return end
		if Processed and Settings.ToggleIgnoresProcessedInput ~= true then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if Input.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end))

	for _, Button in ipairs({ Close, Minimize }) do
		Button.MouseEnter:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().Text }, { Time = 0.12 })
		end)
		Button.MouseLeave:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().SubText }, { Time = 0.12 })
		end)
	end

	if Settings.Animate == false then
		Main.Size = self.FullSize
		if Shadow and self.ShadowFullSize then
			Shadow.Size = self.ShadowFullSize
		end
	else
		Main.Size = self.HiddenSize
		if Shadow and self.ShadowHiddenSize then
			Shadow.Size = self.ShadowHiddenSize
		end
		Animation:Play(Main, { Size = self.FullSize }, { Time = 0.32 })
		if Shadow and self.ShadowFullSize then
			Animation:Play(Shadow, { Size = self.ShadowFullSize }, { Time = 0.32 })
		end
	end

	return self
end

function Window:_SelectTab(TabObject)
	if self.ActiveTab == TabObject then return end

	if self.ActiveTab then
		self.ActiveTab:_SetSelected(false)
	end

	self.ActiveTab = TabObject
	TabObject:_SetSelected(true)
end

function Window:CreateTab(Name, Icon)
	local NewTab = Tab.new(self, Name, Icon)
	table.insert(self.Tabs, NewTab)

	if #self.Tabs == 1 then
		self:_SelectTab(NewTab)
	end

	return NewTab
end

Window.Tab = Window.CreateTab
Window.Page = Window.CreateTab

function Window:Notify(Title, Message, Duration, Kind)
	return Notification.new(self, {
		Title = Title,
		Message = Message,
		Duration = Duration,
		Kind = Kind,
	})
end

function Window:SetVisible(Visible, Animated)
	if self.Destroyed or not self.Frame then
		return
	end

	if self.Visible == Visible then
		return
	end

	self.Visible = Visible
	local ShouldAnimate = Animated ~= false and self.Settings.ToggleAnimation ~= false

	if Visible then
		self.Frame.Visible = true
		self.Frame.Size = ShouldAnimate and self.HiddenSize or self.FullSize
		if self.Shadow then
			self.Shadow.Visible = true
			self.Shadow.Size = ShouldAnimate and self.ShadowHiddenSize or self.ShadowFullSize
		end

		if ShouldAnimate then
			Animation:Play(self.Frame, { Size = self.FullSize }, { Time = self.ToggleTime })
			if self.Shadow and self.ShadowFullSize then
				Animation:Play(self.Shadow, { Size = self.ShadowFullSize }, { Time = self.ToggleTime })
			end
		end
	else
		if ShouldAnimate then
			Animation:Play(self.Frame, { Size = self.HiddenSize }, { Time = self.ToggleTime })
			if self.Shadow and self.ShadowHiddenSize then
				Animation:Play(self.Shadow, { Size = self.ShadowHiddenSize }, { Time = self.ToggleTime })
			end

			task.delay(self.ToggleTime + 0.03, function()
				if not self.Visible and self.Frame then
					self.Frame.Visible = false
				end
				if not self.Visible and self.Shadow then
					self.Shadow.Visible = false
				end
			end)
		else
			self.Frame.Visible = false
			if self.Shadow then
				self.Shadow.Visible = false
			end
		end
	end
end

function Window:Show(Animated)
	self:SetVisible(true, Animated)
end

function Window:Hide(Animated)
	self:SetVisible(false, Animated)
end

function Window:Toggle(Animated)
	self:SetVisible(not self.Visible, Animated)
end

function Window:SetTitle(Text)
	if self.Title then
		self.Title.Text = Text
	end
end

function Window:SetSubtitle(Text)
	if self.Subtitle then
		self.Subtitle.Text = Text
	end
end

function Window:SetSize(Size)
	self.FullSize = Size
	if not self.CustomHiddenSize then
		self.HiddenSize = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
	end
	self.Frame.Size = self.Visible and Size or self.HiddenSize
	if self.Shadow then
		self.ShadowFullSize = Size + UDim2.new(0, self.ShadowPadding, 0, self.ShadowPadding)
		self.ShadowHiddenSize = UDim2.new(Size.X.Scale, Size.X.Offset + self.ShadowPadding, 0, self.ShadowPadding)
		self.Shadow.Size = self.Visible and self.ShadowFullSize or self.ShadowHiddenSize
	end
end

function Window:SetPosition(Position)
	self.Frame.Position = Position
	if self.Shadow then
		self.Shadow.Position = Position
	end
end

function Window:SetTheme(Name)
	return Theme:Set(Name)
end

function Window:SetLogoText(Text)
	if self.Logo then
		self.Logo.Text = Text
		self.Logo.Visible = true
	end
	if self.LogoImage then
		self.LogoImage.Visible = false
	end
end

function Window:SetLogoImage(Image, Color)
	if not self.Logo then
		return
	end

	self.Logo.Visible = true
	self.Logo.Text = ""

	if not self.LogoImage then
		self.LogoImage = Utility:Create("ImageLabel", {
			Name = "LogoImage",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			ScaleType = Enum.ScaleType.Fit,
			Parent = self.Logo,
		})
	end

	self.LogoImage.Visible = true
	self.LogoImage.Image = Image
	if Color then
		self.LogoImage.ImageColor3 = Color
	end
end

function Window:SetBackgroundLogoVisible(Visible)
	if self.BackgroundLogo then
		self.BackgroundLogo.Visible = Visible == true
	end
end

function Window:SetToggleKey(Key)
	self.ToggleKey = ResolveKeyCode(Key)
end

function Window:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.DragDisconnect then
		self.DragDisconnect()
		self.DragDisconnect = nil
	end

	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	self.Connections = {}

	for _, TabObject in ipairs(self.Tabs) do
		if TabObject.Destroy then
			TabObject:Destroy()
		end
	end
	self.Tabs = {}
	self.ActiveTab = nil

	if self.Gui then
		self.Gui:Destroy()
		self.Gui = nil
	end

	self.Shadow = nil
end

return Window
