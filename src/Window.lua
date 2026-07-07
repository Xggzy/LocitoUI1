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

	local self = setmetatable({}, Window)
	self.Settings = Settings
	self.Tabs = {}
	self.ActiveTab = nil
	self.Visible = true

	local CurrentTheme = Theme:Get()
	local Player = Players.LocalPlayer
	local ParentGui = Settings.Parent or (Player and Player:WaitForChild("PlayerGui"))

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

	local Main = Utility:Create("Frame", {
		Name = "MainWindow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, Settings.Width or 680, 0, Settings.Height or 450),
		BackgroundColor3 = CurrentTheme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Gui,
	})
	Utility:Round(Main, CurrentTheme.CornerRadius)
	local MainStroke = Utility:Stroke(Main, CurrentTheme.Border, 1)
	Theme:Register(Main, "BackgroundColor3", "Background")
	Theme:Register(MainStroke, "Color", "Border")
	self.Frame = Main

	local TopBar = Utility:Create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = CurrentTheme.Background,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Theme:Register(TopBar, "BackgroundColor3", "Background")
	self.TopBar = TopBar

	local Logo = Utility:Create("TextLabel", {
		Name = "Logo",
		BackgroundColor3 = CurrentTheme.Surface,
		Position = UDim2.new(0, 14, 0, 12),
		Size = UDim2.new(0, 32, 0, 32),
		Font = Enum.Font.GothamBold,
		Text = Settings.LogoText or "L",
		TextColor3 = CurrentTheme.AccentLight,
		TextSize = 18,
		Parent = TopBar,
	})
	Utility:Round(Logo, 10)
	Theme:Register(Logo, "BackgroundColor3", "Surface")
	Theme:Register(Logo, "TextColor3", "AccentLight")

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 9),
		Size = UDim2.new(1, -140, 0, 22),
		Font = Enum.Font.GothamBold,
		Text = Settings.Name or Settings.Title or "Locito Hub",
		TextColor3 = CurrentTheme.Text,
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Title, "TextColor3", "Text")

	local Subtitle = Utility:Create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 30),
		Size = UDim2.new(1, -140, 0, 16),
		Font = Enum.Font.Gotham,
		Text = Settings.Subtitle or "Original Roblox UI Library",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Subtitle, "TextColor3", "SubText")

	local Close = Utility:Create("TextButton", {
		Name = "Close",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 14),
		Size = UDim2.new(0, 28, 0, 28),
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
		Position = UDim2.new(1, -48, 0, 14),
		Size = UDim2.new(0, 28, 0, 28),
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
		Position = UDim2.new(0, 14, 0, 66),
		Size = UDim2.new(0, 160, 1, -80),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Utility:Round(Sidebar, 12)
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
		Position = UDim2.new(0, 188, 0, 66),
		Size = UDim2.new(1, -202, 1, -80),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})
	Utility:Round(Content, 12)
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

	self.DragDisconnect = Utility:MakeDraggable(TopBar, Main)

	Close.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	local Minimized = false
	local FullSize = Main.Size
	Minimize.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		Animation:Play(Main, {
			Size = Minimized and UDim2.new(0, FullSize.X.Offset, 0, 56) or FullSize,
		}, { Time = 0.22 })
	end)

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
end

return Window
