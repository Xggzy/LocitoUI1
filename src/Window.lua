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
		local BackgroundLogoState = {
			Shape = Settings.BackgroundLogoShape or Settings.BackgroundShape or "Sword",
			Material = Settings.BackgroundLogoMaterial or Settings.BackgroundMaterial or "Noir",
			Speed = BackgroundLogoSpeed,
			Intensity = Settings.BackgroundLogoIntensity or Settings.BackgroundAnimationIntensity or 1.25,
			Transparency = Settings.BackgroundLogoTransparency or Settings.BackgroundSwordTransparency,
			PrimaryColor = Settings.BackgroundLogoPrimaryColor,
			SecondaryColor = Settings.BackgroundLogoSecondaryColor,
			StoneColor = Settings.BackgroundLogoStoneColor,
			OuterSword = Settings.OuterSword == true or Settings.OrbitSword == true or Settings.ExternalSword == true,
			OuterSwordSpeed = Settings.OuterSwordSpeed or Settings.OrbitSwordSpeed or 46,
			OuterSwordRadiusX = Settings.OuterSwordRadiusX or Settings.OrbitSwordRadiusX,
			OuterSwordRadiusY = Settings.OuterSwordRadiusY or Settings.OrbitSwordRadiusY,
			BackgroundVisible = true,
		}
		local BackgroundLogo = Utility:Create("Frame", {
			Name = "AnimatedBackgroundLogo",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Settings.BackgroundLogoPosition or (PreviewLayout and UDim2.new(0.66, 0, 0.58, 0) or UDim2.new(1, -126, 1, -80)),
			Size = UDim2.new(0, BackgroundLogoSize, 0, BackgroundLogoSize),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Main,
		})

		local OuterSwordLayer
		local OuterSwordGroup
		local OuterBlade
		local OuterTip
		local OuterGuard
		local OuterGrip
		local OuterPommel
		local OuterName

		if BackgroundLogoState.OuterSword then
			OuterSwordLayer = Utility:Create("Frame", {
				Name = "OuterSwordOrbitLayer",
				AnchorPoint = MainAnchor,
				Position = MainPosition,
				Size = WindowSize,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = Gui,
			})

			OuterSwordGroup = Utility:Create("Frame", {
				Name = "OuterOrbitSword",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = Settings.OuterSwordSize or UDim2.new(0, 72, 0, 146),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordLayer,
			})

			OuterBlade = Utility:Create("Frame", {
				Name = "OuterBlade",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.04, 0),
				Size = UDim2.new(0, 9, 0.58, 0),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterBlade, 5)

			OuterTip = Utility:Create("Frame", {
				Name = "OuterTip",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.04, 0),
				Size = UDim2.new(0, 21, 0, 21),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Rotation = 45,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterTip, 4)

			OuterGuard = Utility:Create("Frame", {
				Name = "OuterGuard",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.62, 0),
				Size = UDim2.new(0.66, 0, 0, 8),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.28,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterGuard, 8)

			OuterGrip = Utility:Create("Frame", {
				Name = "OuterGrip",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.62, 0),
				Size = UDim2.new(0, 14, 0.22, 0),
				BackgroundColor3 = CurrentTheme.SurfaceLight,
				BackgroundTransparency = 0.18,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterGrip, 6)

			OuterPommel = Utility:Create("Frame", {
				Name = "OuterPommel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.84, 0),
				Size = UDim2.new(0, 23, 0, 10),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.28,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterPommel, 8)

			if Settings.OuterSwordName ~= false then
				OuterName = Utility:Create("TextLabel", {
					Name = "OuterName",
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBlack,
					Text = Settings.BackgroundLogoName or Settings.Name or "Locito",
					TextColor3 = CurrentTheme.Accent,
					TextTransparency = 0.34,
					TextScaled = true,
					ZIndex = Settings.OuterSwordZIndex or 2,
					Parent = OuterSwordGroup,
				})
			end

			self.OuterSwordLayer = OuterSwordLayer
			self.OuterSword = OuterSwordGroup
		end

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

		local SparkGroup = Utility:Create("Frame", {
			Name = "SparkOrbit",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		local SparkDots = {}
		local SparkPositions = {
			{ X = 0.16, Y = 0.3, Size = 5 },
			{ X = 0.5, Y = 0.12, Size = 4 },
			{ X = 0.82, Y = 0.28, Size = 5 },
			{ X = 0.82, Y = 0.72, Size = 6 },
			{ X = 0.5, Y = 0.88, Size = 4 },
			{ X = 0.16, Y = 0.7, Size = 5 },
		}
		for Index, Data in ipairs(SparkPositions) do
			local Spark = Utility:Create("Frame", {
				Name = "Spark" .. Index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(Data.X, 0, Data.Y, 0),
				Size = UDim2.new(0, Data.Size, 0, Data.Size),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.6,
				BorderSizePixel = 0,
				ZIndex = 0,
				Parent = SparkGroup,
			})
			Utility:Round(Spark, Data.Size)
			Theme:Register(Spark, "BackgroundColor3", "AccentLight")
			table.insert(SparkDots, Spark)
		end

		local CrossLine = Utility:Create("Frame", {
			Name = "CrossLine",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 2, 1, -18),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = 0.72,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(CrossLine, "BackgroundColor3", "Accent")

		local HexGroup = Utility:Create("Frame", {
			Name = "HexMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		local HexLines = {}
		for Index, Rotation in ipairs({ 0, 60, -60 }) do
			local HexLine = Utility:Create("Frame", {
				Name = "HexLine" .. Index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.62,
				BorderSizePixel = 0,
				Rotation = Rotation,
				ZIndex = 0,
				Parent = HexGroup,
			})
			Theme:Register(HexLine, "BackgroundColor3", "Accent")
			table.insert(HexLines, HexLine)
		end

		local SwordBaseRotation = Settings.BackgroundSwordRotation or 0
		local SwordTransparency = Settings.BackgroundSwordTransparency or 0.44
		local SwordGroup = Utility:Create("Frame", {
			Name = "SwordStoneMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, 0, 0.5, 0),
			Size = Settings.BackgroundSwordSize or UDim2.new(0.62, 0, 0.9, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = SwordBaseRotation,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})

		local Blade = Utility:Create("Frame", {
			Name = "Blade",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.06, 0),
			Size = UDim2.new(0, 10, 0.52, 0),
			BackgroundColor3 = CurrentTheme.AccentLight,
			BackgroundTransparency = SwordTransparency,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Blade, 5)
		Theme:Register(Blade, "BackgroundColor3", "AccentLight")

		local Tip = Utility:Create("Frame", {
			Name = "BladeTip",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.07, 0),
			Size = UDim2.new(0, 22, 0, 22),
			BackgroundColor3 = CurrentTheme.AccentLight,
			BackgroundTransparency = SwordTransparency,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Tip, 4)
		Theme:Register(Tip, "BackgroundColor3", "AccentLight")

		local Guard = Utility:Create("Frame", {
			Name = "Guard",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.58, 0),
			Size = UDim2.new(0.5, 0, 0, 9),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = math.max(SwordTransparency - 0.04, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Guard, 8)
		Theme:Register(Guard, "BackgroundColor3", "Accent")

		local Grip = Utility:Create("Frame", {
			Name = "Grip",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.58, 0),
			Size = UDim2.new(0, 16, 0.2, 0),
			BackgroundColor3 = CurrentTheme.SurfaceLight,
			BackgroundTransparency = math.max(SwordTransparency - 0.16, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Grip, 6)
		Theme:Register(Grip, "BackgroundColor3", "SurfaceLight")

		local Pommel = Utility:Create("Frame", {
			Name = "Pommel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.78, 0),
			Size = UDim2.new(0, 24, 0, 10),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = math.max(SwordTransparency - 0.04, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Pommel, 8)
		Theme:Register(Pommel, "BackgroundColor3", "Accent")

		local Stone = Utility:Create("Frame", {
			Name = "Stone",
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, 0),
			Size = UDim2.new(0.62, 0, 0.2, 0),
			BackgroundColor3 = CurrentTheme.SurfaceLight,
			BackgroundTransparency = math.max(SwordTransparency - 0.12, 0),
			BorderSizePixel = 0,
			Rotation = -2,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Stone, 14)
		Theme:Register(Stone, "BackgroundColor3", "SurfaceLight")

		local StoneStroke = Utility:Stroke(Stone, CurrentTheme.Accent, 1, 0.62)
		Theme:Register(StoneStroke, "Color", "Accent")

		local Inscription = Utility:Create("TextLabel", {
			Name = "Inscription",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.91, 0),
			Size = UDim2.new(0.68, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBlack,
			Text = Settings.BackgroundLogoName or Settings.Name or "Locito",
			TextColor3 = CurrentTheme.Accent,
			TextTransparency = math.max(SwordTransparency - 0.08, 0),
			TextScaled = true,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Theme:Register(Inscription, "TextColor3", "Accent")

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
			TextStrokeColor3 = CurrentTheme.AccentLight,
			TextStrokeTransparency = Settings.BackgroundLogoTextStrokeTransparency or 0.88,
			TextTransparency = Settings.BackgroundLogoTextTransparency or 0.72,
			TextSize = Settings.BackgroundLogoTextSize or math.floor(BackgroundLogoSize * 0.42),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(LogoWatermark, "TextColor3", "Accent")
		Theme:Register(LogoWatermark, "TextStrokeColor3", "AccentLight")

		local function ClampNumber(Value, Min, Max, Default)
			local Number = tonumber(Value)
			if not Number then
				return Default
			end
			return math.clamp(Number, Min, Max)
		end

		local function ReadColor(Value, Fallback)
			if typeof(Value) == "Color3" then
				return Value
			end
			return Fallback
		end

		local function ApplyFrame(Object, Color, Transparency)
			if Object then
				Object.BackgroundColor3 = Color
				if Transparency then
					Object.BackgroundTransparency = Transparency
				end
			end
		end

		local function ApplyStroke(Stroke, Color, Transparency, Thickness)
			if Stroke then
				Stroke.Color = Color
				if Transparency then
					Stroke.Transparency = Transparency
				end
				if Thickness then
					Stroke.Thickness = Thickness
				end
			end
		end

		local function GetMaterial()
			local ActiveTheme = Theme:Get()
			local Material = string.lower(tostring(BackgroundLogoState.Material or "Noir"))
			local Primary = ActiveTheme.Accent
			local Secondary = ActiveTheme.AccentLight
			local StoneColor = ActiveTheme.SurfaceLight
			local Transparency = 0.44
			local GlowTransparency = 0.86
			local StrokeTransparency = 0.48

			if Material == "neon" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.AccentLight or ActiveTheme.Accent
				StoneColor = ActiveTheme.Accent
				Transparency = 0.26
				GlowTransparency = 0.78
				StrokeTransparency = 0.22
			elseif Material == "glass" then
				Primary = ActiveTheme.AccentLight or Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.Accent
				StoneColor = ActiveTheme.SurfaceLight
				Transparency = 0.58
				GlowTransparency = 0.9
				StrokeTransparency = 0.6
			elseif Material == "ghost" or Material == "see through" or Material == "see-through" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.SubText or Color3.fromRGB(190, 190, 196)
				StoneColor = ActiveTheme.Background
				Transparency = 0.74
				GlowTransparency = 0.94
				StrokeTransparency = 0.72
			elseif Material == "wood" or Material == "wooden" then
				Primary = Color3.fromRGB(214, 170, 104)
				Secondary = Color3.fromRGB(104, 70, 38)
				StoneColor = Color3.fromRGB(61, 42, 27)
				Transparency = 0.36
				GlowTransparency = 0.88
				StrokeTransparency = 0.42
			elseif Material == "chrome" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = Color3.fromRGB(150, 150, 158)
				StoneColor = Color3.fromRGB(26, 26, 30)
				Transparency = 0.32
				GlowTransparency = 0.84
				StrokeTransparency = 0.3
			elseif Material == "custom" then
				Transparency = 0.42
				GlowTransparency = 0.84
				StrokeTransparency = 0.36
			else
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = Color3.fromRGB(18, 18, 22)
				StoneColor = Color3.fromRGB(8, 8, 10)
				Transparency = 0.4
				GlowTransparency = 0.88
				StrokeTransparency = 0.42
			end

			return {
				Primary = ReadColor(BackgroundLogoState.PrimaryColor, Primary),
				Secondary = ReadColor(BackgroundLogoState.SecondaryColor, Secondary),
				Stone = ReadColor(BackgroundLogoState.StoneColor, StoneColor),
				Transparency = ClampNumber(BackgroundLogoState.Transparency, 0.16, 0.9, Transparency),
				GlowTransparency = GlowTransparency,
				StrokeTransparency = StrokeTransparency,
			}
		end

		local function ApplyBackgroundLogoStyle()
			local Material = GetMaterial()
			local Shape = string.lower(tostring(BackgroundLogoState.Shape or "Sword"))
			local Intensity = ClampNumber(BackgroundLogoState.Intensity, 0, 2, 1.25)
			local Transparency = Material.Transparency
			local RingTransparency = math.clamp(Transparency - 0.14, 0.12, 0.92)
			local SoftTransparency = math.clamp(Transparency + 0.16, 0.22, 0.96)
			local HeavyTransparency = math.clamp(Transparency - 0.18, 0.08, 0.86)
			local GlowTransparency = math.clamp(Settings.BackgroundLogoGlowTransparency or (Material.GlowTransparency - Intensity * 0.05), 0.72, 1)
			local StrokeTransparency = math.clamp(Material.StrokeTransparency - Intensity * 0.08, 0.08, 0.88)

			local UsesOuterSword = OuterSwordGroup ~= nil and BackgroundLogoState.OuterSword ~= false
			local ShowsSword = not UsesOuterSword and (Shape == "sword" or Shape == "blade" or Shape == "shatter")
			local ShowsDiamond = Shape == "sword" or Shape == "diamond" or Shape == "cross" or Shape == "shatter"
			local ShowsHex = Shape == "hex" or Shape == "shatter"
			local ShowsCross = Shape == "cross" or Shape == "orbit"
			local ShowsSpoke = Shape ~= "blade" and Shape ~= "hex"

			SwordGroup.Visible = ShowsSword
			Diamond.Visible = ShowsDiamond
			InnerDiamond.Visible = ShowsDiamond
			HexGroup.Visible = ShowsHex
			CrossLine.Visible = ShowsCross
			Spoke.Visible = ShowsSpoke
			LogoWatermark.Visible = Shape ~= "blade"

			SwordGroup.Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, 0, 0.5, 0)
			SwordGroup.Size = Settings.BackgroundSwordSize or (Shape == "blade" and UDim2.new(0.48, 0, 0.92, 0) or UDim2.new(0.62, 0, 0.9, 0))
			Diamond.Size = Shape == "diamond" and UDim2.new(0.58, 0, 0.58, 0) or UDim2.new(0.46, 0, 0.46, 0)
			InnerDiamond.Size = Shape == "diamond" and UDim2.new(0.36, 0, 0.36, 0) or UDim2.new(0.28, 0, 0.28, 0)
			HexGroup.Size = Shape == "shatter" and UDim2.new(0.88, 0, 0.88, 0) or UDim2.new(0.7, 0, 0.7, 0)

			ApplyFrame(GlowDisc, Material.Primary, GlowTransparency)
			ApplyFrame(Blade, Material.Primary, HeavyTransparency)
			ApplyFrame(Tip, Material.Primary, HeavyTransparency)
			ApplyFrame(Guard, Material.Secondary, Transparency)
			ApplyFrame(Grip, Material.Stone, math.clamp(Transparency - 0.16, 0.04, 0.84))
			ApplyFrame(Pommel, Material.Secondary, Transparency)
			ApplyFrame(Stone, Material.Stone, math.clamp(Transparency - 0.1, 0.04, 0.86))
			ApplyFrame(Spoke, Material.Primary, SoftTransparency)
			ApplyFrame(CrossLine, Material.Primary, SoftTransparency)

			for _, Spark in ipairs(SparkDots) do
				ApplyFrame(Spark, Material.Primary, math.clamp(Transparency + 0.08, 0.22, 0.88))
			end

			for _, HexLine in ipairs(HexLines) do
				ApplyFrame(HexLine, Material.Primary, RingTransparency)
			end

			ApplyStroke(OuterStroke, Material.Primary, RingTransparency, Shape == "orbit" and 3 or 2)
			ApplyStroke(InnerStroke, Material.Secondary, SoftTransparency, Shape == "orbit" and 2 or 1)
			ApplyStroke(DiamondStroke, Material.Primary, StrokeTransparency, Shape == "diamond" and 3 or 2)
			ApplyStroke(InnerDiamondStroke, Material.Secondary, SoftTransparency, Shape == "diamond" and 2 or 1)
			ApplyStroke(StoneStroke, Material.Primary, SoftTransparency, 1)

			LogoWatermark.TextColor3 = Material.Primary
			LogoWatermark.TextStrokeColor3 = Material.Secondary
			LogoWatermark.TextTransparency = math.clamp(Transparency + 0.18, 0.42, 0.9)
			LogoWatermark.TextStrokeTransparency = math.clamp(Transparency + 0.28, 0.54, 0.95)
			Inscription.TextColor3 = Material.Primary
			Inscription.TextTransparency = math.clamp(Transparency + 0.02, 0.28, 0.9)

			if OuterSwordGroup then
				OuterSwordGroup.Visible = BackgroundLogoState.OuterSword ~= false
				ApplyFrame(OuterBlade, Material.Primary, math.clamp(Transparency - 0.24, 0.04, 0.78))
				ApplyFrame(OuterTip, Material.Primary, math.clamp(Transparency - 0.24, 0.04, 0.78))
				ApplyFrame(OuterGuard, Material.Secondary, math.clamp(Transparency - 0.1, 0.06, 0.82))
				ApplyFrame(OuterGrip, Material.Stone, math.clamp(Transparency - 0.18, 0.04, 0.82))
				ApplyFrame(OuterPommel, Material.Secondary, math.clamp(Transparency - 0.1, 0.06, 0.82))
				if OuterName then
					OuterName.TextColor3 = Material.Primary
					OuterName.TextTransparency = math.clamp(Transparency + 0.06, 0.22, 0.82)
				end
			end

			BackgroundLogoState._LastMaterial = Material
		end

		self.BackgroundLogo = BackgroundLogo
		self.BackgroundLogoText = LogoWatermark
		self.BackgroundLogoState = BackgroundLogoState
		self.BackgroundLogoStyleApplier = ApplyBackgroundLogoStyle
		ApplyBackgroundLogoStyle()

		local BackgroundThemeDisconnect = Theme:OnChanged(function()
			task.defer(ApplyBackgroundLogoStyle)
		end)
		table.insert(self.Connections, { Disconnect = BackgroundThemeDisconnect })

		table.insert(self.Connections, RunService.RenderStepped:Connect(function(DeltaTime)
			if not BackgroundLogo.Parent then
				return
			end

			local Speed = ClampNumber(BackgroundLogoState.Speed, 0, 90, BackgroundLogoSpeed)
			local Intensity = ClampNumber(BackgroundLogoState.Intensity, 0, 2, 1.25)
			local Material = BackgroundLogoState._LastMaterial or GetMaterial()
			local Transparency = Material.Transparency
			local Rotation = (BackgroundLogo.Rotation + DeltaTime * Speed) % 360
			local Pulse = math.sin(os.clock() * (2.4 + Intensity))
			local Shape = string.lower(tostring(BackgroundLogoState.Shape or "Sword"))
			BackgroundLogo.Rotation = Rotation
			InnerRing.Rotation = -Rotation * 1.35
			Diamond.Rotation = 45 - Rotation * 0.55
			InnerDiamond.Rotation = 45 + Rotation * 0.7
			HexGroup.Rotation = Rotation * 1.2
			CrossLine.Rotation = -Rotation * 1.6
			SparkGroup.Rotation = -Rotation * 1.8
			SwordGroup.Rotation = SwordBaseRotation + math.sin(os.clock() * (1.6 + Intensity * 0.4)) * (2 + Intensity * 3)
			SwordGroup.Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, math.sin(os.clock() * 1.4) * Intensity * 2, 0.5, math.cos(os.clock() * 1.2) * Intensity * 2)
			Blade.BackgroundTransparency = math.clamp(Transparency - 0.18 + Pulse * 0.08, 0.08, 0.86)
			Tip.BackgroundTransparency = Blade.BackgroundTransparency
			for Index, Spark in ipairs(SparkDots) do
				local SparkPulse = math.sin(os.clock() * (3 + Intensity) + Index)
				local SparkSize = 4 + (Index % 3) + math.max(SparkPulse, 0) * Intensity * 3
				Spark.BackgroundTransparency = math.clamp(Transparency + 0.12 + SparkPulse * 0.22, 0.18, 0.9)
				Spark.Size = UDim2.new(0, SparkSize, 0, SparkSize)
			end
			GlowDisc.BackgroundTransparency = math.clamp((Settings.BackgroundLogoGlowTransparency or Material.GlowTransparency or 0.88) + Pulse * 0.05, 0.72, 1)
			GlowDisc.Size = UDim2.new(0.82 + Pulse * 0.04 * Intensity, 0, 0.82 + Pulse * 0.04 * Intensity, 0)
			LogoWatermark.Rotation = -Rotation
			LogoWatermark.TextTransparency = math.clamp(Transparency + 0.18 + Pulse * 0.04, 0.42, 0.9)
			if Shape == "shatter" then
				Spoke.Rotation = 24 + math.sin(os.clock() * 2.8) * 8
			else
				Spoke.Rotation = 0
			end

			if OuterSwordGroup then
				OuterSwordGroup.Visible = self.Visible and BackgroundLogoState.BackgroundVisible ~= false and BackgroundLogoState.OuterSword ~= false
				local OrbitSpeed = ClampNumber(BackgroundLogoState.OuterSwordSpeed, 0, 180, 46)
				local RadiusX = ClampNumber(BackgroundLogoState.OuterSwordRadiusX, 160, 620, (WindowSize.X.Offset / 2) + 78)
				local RadiusY = ClampNumber(BackgroundLogoState.OuterSwordRadiusY, 120, 460, (WindowSize.Y.Offset / 2) + 64)
				local Angle = math.rad(os.clock() * OrbitSpeed)
				local OffsetX = math.cos(Angle) * RadiusX
				local OffsetY = math.sin(Angle) * RadiusY
				local Tilt = math.sin(os.clock() * (2.2 + Intensity)) * (5 + Intensity * 3)

				OuterSwordGroup.Position = UDim2.new(0.5, OffsetX, 0.5, OffsetY)
				OuterSwordGroup.Rotation = math.deg(Angle) + 90 + Tilt
				OuterBlade.BackgroundTransparency = math.clamp(Transparency - 0.24 + Pulse * 0.05, 0.04, 0.78)
				OuterTip.BackgroundTransparency = OuterBlade.BackgroundTransparency
			end
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
			if self.OuterSwordLayer then
				self.OuterSwordLayer.Position = Position
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
		if self.OuterSwordLayer then
			self.OuterSwordLayer.Visible = not self.BackgroundLogoState or self.BackgroundLogoState.BackgroundVisible ~= false
		end
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
				if not self.Visible and self.OuterSwordLayer then
					self.OuterSwordLayer.Visible = false
				end
			end)
		else
			self.Frame.Visible = false
			if self.Shadow then
				self.Shadow.Visible = false
			end
			if self.OuterSwordLayer then
				self.OuterSwordLayer.Visible = false
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
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Size = Size
	end
end

function Window:SetPosition(Position)
	self.Frame.Position = Position
	if self.Shadow then
		self.Shadow.Position = Position
	end
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Position = Position
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
	if self.BackgroundLogoState then
		self.BackgroundLogoState.BackgroundVisible = Visible == true
	end
	if self.BackgroundLogo then
		self.BackgroundLogo.Visible = Visible == true
	end
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Visible = Visible == true and self.Visible == true
	end
end

function Window:SetBackgroundAnimation(Options)
	if not self.BackgroundLogoState or typeof(Options) ~= "table" then
		return false
	end

	local State = self.BackgroundLogoState
	for Key, Value in pairs(Options) do
		if Key == "Shape" or Key == "Material" then
			if typeof(Value) == "string" and Value ~= "" then
				State[Key] = Value
				if Key == "Material" and string.lower(Value) ~= "custom" then
					State.PrimaryColor = nil
					State.SecondaryColor = nil
					State.StoneColor = nil
				end
			end
		elseif Key == "Speed" or Key == "Intensity" or Key == "Transparency" or Key == "OuterSwordSpeed" or Key == "OuterSwordRadiusX" or Key == "OuterSwordRadiusY" then
			local Number = tonumber(Value)
			if Number then
				State[Key] = Number
			end
		elseif Key == "OuterSword" then
			State.OuterSword = Value == true
		elseif Key == "PrimaryColor" or Key == "SecondaryColor" or Key == "StoneColor" then
			if typeof(Value) == "Color3" then
				State[Key] = Value
				State.Material = "Custom"
			end
		end
	end

	if self.BackgroundLogoStyleApplier then
		self.BackgroundLogoStyleApplier()
	end

	return true
end

function Window:SetBackgroundLogoShape(Shape)
	return self:SetBackgroundAnimation({ Shape = Shape })
end

function Window:SetBackgroundLogoMaterial(Material)
	return self:SetBackgroundAnimation({ Material = Material })
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
