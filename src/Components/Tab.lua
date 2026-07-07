-- LocitoUI Tab System
-- Version 0.2.0

local Tab = {}
Tab.__index = Tab

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Section = require(script.Parent.Section)

function Tab.new(Window, Name, Icon)
	local self = setmetatable({}, Tab)
	self.Window = Window
	self.Name = Name
	self.Icon = Icon
	self.Sections = {}

	local CurrentTheme = Theme:Get()
	local Settings = Window.Settings or {}
	local TabHeight = Settings.TabHeight or 38
	local TabRadius = Settings.TabRadius or 9
	local TabTextInset = Settings.TabTextInset or 12
	local IndicatorWidth = Settings.TabIndicatorWidth or 3
	local IndicatorHeight = Settings.TabIndicatorHeight or 22

	local Button = Utility:Create("TextButton", {
		Name = Name .. "Tab",
		Size = UDim2.new(1, 0, 0, TabHeight),
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Window.SidebarList,
	})
	Utility:Round(Button, TabRadius)
	Theme:Register(Button, "BackgroundColor3", "Surface")

	local Indicator = Utility:Create("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, IndicatorWidth, 0, 0),
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Button,
	})
	Utility:Round(Indicator, 99)
	Theme:Register(Indicator, "BackgroundColor3", "Accent")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TabTextInset, 0, 0),
		Size = UDim2.new(1, -TabTextInset - 4, 1, 0),
		Font = Settings.TabFont or Enum.Font.GothamMedium,
		Text = (Icon and (Icon .. "  ") or "") .. Name,
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.TabTextSize or 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Button,
	})

	local Page = Utility:Create("ScrollingFrame", {
		Name = Name .. "Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,
		Parent = Window.Content,
	})
	Theme:Register(Page, "ScrollBarImageColor3", "Accent")
	Utility:Padding(Page, 10)
	local Layout = Utility:List(Page, 10)
	Utility:AutoCanvas(Page, Layout, 22)

	self.Button = Button
	self.Indicator = Indicator
	self.Label = Label
	self.Page = Page
	self.Layout = Layout
	self.IndicatorWidth = IndicatorWidth
	self.IndicatorHeight = IndicatorHeight
	self.SelectedTransparency = Settings.TabSelectedTransparency or 0
	self.HoverTransparency = Settings.TabHoverTransparency or 0.55
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:_SetSelected(Window.ActiveTab == self)
	end)

	Button.MouseButton1Click:Connect(function()
		Window:_SelectTab(self)
	end)

	Button.MouseEnter:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = self.HoverTransparency }, { Time = 0.12 })
	end)

	Button.MouseLeave:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = 1 }, { Time = 0.12 })
	end)

	return self
end

function Tab:_SetSelected(IsSelected)
	if not self.Page or not self.Page.Parent then
		return
	end

	self.Page.Visible = IsSelected

	if IsSelected then
		Animation:Play(self.Button, { BackgroundTransparency = self.SelectedTransparency }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, self.IndicatorHeight) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().Text }, { Time = 0.15 })
	else
		Animation:Play(self.Button, { BackgroundTransparency = 1 }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, 0) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().SubText }, { Time = 0.15 })
	end
end

function Tab:CreateSection(Name, Options)
	local NewSection = Section.new(self, Name, Options)
	table.insert(self.Sections, NewSection)
	return NewSection
end

Tab.Section = Tab.CreateSection

function Tab:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.ThemeDisconnect then
		self.ThemeDisconnect()
		self.ThemeDisconnect = nil
	end

	for _, SectionObject in ipairs(self.Sections) do
		if SectionObject.Destroy then
			SectionObject:Destroy()
		end
	end
	self.Sections = {}

	if self.Button then
		self.Button:Destroy()
	end

	if self.Page then
		self.Page:Destroy()
	end
end

return Tab
