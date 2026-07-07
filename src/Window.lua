-- LocitoUI Window System
-- Version 0.2.0

local Window = {}
Window.__index = Window

local Players = game:GetService("Players")

local Utility = require(script.Parent.Utility)
local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Notification = require(script.Parent.Notification)
local Tab = require(script.Parent.Components.Tab)

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
	self.ActiveTab = nil
	self.Visible = true

	local CurrentTheme = Theme:Get()
	local Player = Players.LocalPlayer
	local ParentGui = Settings.Parent or (Player and Player:WaitForChild("PlayerGui"))
	local WindowSize = Settings.Size or UDim2.new(0, Settings.Width or 680, 0, Settings.Height or 450)
	local TopBarHeight = Settings.TopBarHeight or Settings.TopbarHeight or 56
	local OuterPadding = Settings.Padding or 14
	local Gap = Settings.Gap or 14
	local ContentGap = Settings.ContentGap or 10
	local SidebarWidth = Settings.SidebarWidth or 160
	local HasSidebar = Settings.Sidebar ~= false
	local ContentX = HasSidebar and (OuterPadding + SidebarWidth + Gap) or OuterPadding
	local ContentTop = TopBarHeight + ContentGap
	local ContentWidthOffset = HasSidebar and -(OuterPadding * 2 + SidebarWidth + Gap) or -(OuterPadding * 2)
	local ContentHeightOffset = -(ContentTop + OuterPadding)
	local ShowControls = Settings.Controls ~= false
	local ShowClose = ShowControls and Settings.CloseButton ~= false
	local ShowMinimize = ShowControls and Settings.MinimizeButton ~= false
	local ControlReserve = ShowControls and 90 or 16
	local TitleX = Settings.Logo == false and OuterPadding or (OuterPadding + 42)
	local MainAnchor = Settings.AnchorPoint or Vector2.new(0.5, 0.5)
	local MainPosition = Settings.Position or UDim2.new(0.5, 0, 0.5, 0)
	local Radius = Settings.Radius or CurrentTheme.CornerRadius

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

	local Shadow
	if Settings.Shadow ~= false then
		Shadow = Utility:Create("Frame", {
			Name = "Shadow",
			AnchorPoint = MainAnchor,
			Position = Settings.ShadowPosition or MainPosition,
			Size = Settings.ShadowSize or (WindowSize + UDim2.new(0, 22, 0, 22)),
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
		local AccentLine = Utility:Create("Frame", {
			Name = "AccentLine",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, Settings.AccentLineHeight or 1),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.AccentLineTransparency or 0.35,
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Theme:Register(AccentLine, "BackgroundColor3", "Accent")
		self.AccentLine = AccentLine
	end

	local Logo = Utility:Create("TextLabel", {
		Name = "Logo",
		BackgroundColor3 = CurrentTheme.Surface,
		Position = UDim2.new(0, OuterPadding, 0, math.floor((TopBarHeight - 32) / 2)),
		Size = UDim2.new(0, 32, 0, 32),
		Visible = Settings.Logo ~= false,
		Font = Settings.LogoFont or Enum.Font.GothamBold,
		Text = Settings.LogoText or "L",
		TextColor3 = CurrentTheme.AccentLight,
		TextSize = Settings.LogoTextSize or 18,
		Parent = TopBar,
	})
	Utility:Round(Logo, 10)
	Theme:Register(Logo, "BackgroundColor3", "Surface")
	Theme:Register(Logo, "TextColor3", "AccentLight")
	self.Logo = Logo

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 9),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 22),
		Font = Settings.TitleFont or Enum.Font.GothamBold,
		Text = Settings.Name or Settings.Title or "Locito Hub",
		TextColor3 = CurrentTheme.Text,
		TextSize = Settings.TitleSize or 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Title, "TextColor3", "Text")
	self.Title = Title

	local Subtitle = Utility:Create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 30),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 16),
		Visible = Settings.Subtitle ~= false,
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
		Position = UDim2.new(1, -OuterPadding, 0, math.floor((TopBarHeight - 28) / 2)),
		Size = UDim2.new(0, 28, 0, 28),
		Visible = ShowClose,
		BackgroundColor3 = CurrentTheme.Surface,
		Font = Enum.Font.GothamBold,
		Text = "X",
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
		Position = UDim2.new(1, ShowClose and -(OuterPadding + 34) or -OuterPadding, 0, math.floor((TopBarHeight - 28) / 2)),
		Size = UDim2.new(0, 28, 0, 28),
		Visible = ShowMinimize,
		BackgroundColor3 = CurrentTheme.Surface,
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
		Position = UDim2.new(0, OuterPadding, 0, ContentTop),
		Size = UDim2.new(0, SidebarWidth, 1, ContentHeightOffset),
		Visible = HasSidebar,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Utility:Round(Sidebar, Settings.PanelRadius or Radius)
	Theme:Register(Sidebar, "BackgroundColor3", "Secondary")
	self.Sidebar = Sidebar

	local SidebarList = Utility:Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -16, 1, -16),
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
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})
	Utility:Round(Content, Settings.PanelRadius or Radius)
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
	local FullSize = Main.Size
	local ShadowFullSize = Shadow and Shadow.Size
	if ShowMinimize then
		Minimize.MouseButton1Click:Connect(function()
			Minimized = not Minimized
			Animation:Play(Main, {
				Size = Minimized and UDim2.new(0, FullSize.X.Offset, 0, TopBarHeight) or FullSize,
			}, { Time = 0.22 })
			if Shadow and ShadowFullSize then
				Animation:Play(Shadow, {
					Size = Minimized and UDim2.new(0, FullSize.X.Offset + 22, 0, TopBarHeight + 22) or ShadowFullSize,
				}, { Time = 0.22 })
			end
		end)
	end

	for _, Button in ipairs({ Close, Minimize }) do
		Button.MouseEnter:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().Text }, { Time = 0.12 })
		end)
		Button.MouseLeave:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().SubText }, { Time = 0.12 })
		end)
	end

	if Settings.Animate == false then
		Main.Size = FullSize
	else
		Main.Size = UDim2.new(0, 0, 0, 0)
		Animation:Play(Main, { Size = FullSize }, { Time = 0.32 })
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

function Window:Toggle()
	self.Visible = not self.Visible
	self.Frame.Visible = self.Visible
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
	self.Frame.Size = Size
	if self.Shadow then
		self.Shadow.Size = Size + UDim2.new(0, 22, 0, 22)
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

function Window:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.DragDisconnect then
		self.DragDisconnect()
		self.DragDisconnect = nil
	end

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
