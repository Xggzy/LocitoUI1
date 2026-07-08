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
	local PreviewLayout = Settings.Layout == "Preview" or Settings.Style == "Preview" or Settings.PreviewLayout == true
	local PillTabs = Settings.TabStyle == "Pill" or Settings.TabPills == true or PreviewLayout
	local TabHeight = Settings.TabHeight or (PreviewLayout and 40 or 38)
	local TabRadius = Settings.TabRadius or (PreviewLayout and 8 or 9)
	local TabTextInset = Settings.TabTextInset or (PreviewLayout and 38 or 12)
	local TabIconSize = Settings.TabIconSize or (PreviewLayout and 22 or 20)
	local IndicatorWidth = Settings.TabIndicatorWidth or 3
	local IndicatorHeight = Settings.TabIndicatorHeight or 22
	local UseIndicator = Settings.TabIndicator ~= false and not PillTabs

	local Button = Utility:Create("TextButton", {
		Name = Name .. "Tab",
		Size = UDim2.new(1, 0, 0, TabHeight),
		BackgroundColor3 = PillTabs and (CurrentTheme.TabActive or CurrentTheme.Surface) or CurrentTheme.Surface,
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
		Visible = UseIndicator,
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Button,
	})
	Utility:Round(Indicator, 99)
	Theme:Register(Indicator, "BackgroundColor3", "Accent")

	local IconLabel = Utility:Create("TextLabel", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, PreviewLayout and 10 or TabTextInset, 0.5, -math.floor(TabIconSize / 2)),
		Size = UDim2.new(0, TabIconSize, 0, TabIconSize),
		Visible = Icon ~= nil,
		Font = Settings.TabIconFont or Enum.Font.GothamBold,
		Text = Icon or "",
		TextColor3 = CurrentTheme.Muted,
		TextSize = Settings.TabIconTextSize or (PreviewLayout and 15 or 13),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = Button,
	})
	Theme:Register(IconLabel, "TextColor3", "Muted")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, Icon and TabTextInset or 12, 0, 0),
		Size = UDim2.new(1, -(Icon and TabTextInset or 12) - 8, 1, 0),
		Font = Settings.TabFont or Enum.Font.GothamMedium,
		Text = Name,
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.TabTextSize or (PreviewLayout and 14 or 13),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Button,
	})

	local Page = Utility:Create("ScrollingFrame", {
		Name = Name .. "Page",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,
		Parent = Window.Content,
	})
	Theme:Register(Page, "ScrollBarImageColor3", "Accent")
	Utility:Padding(Page, Settings.PagePadding or (PreviewLayout and 0 or 10))
	local Layout = Utility:List(Page, Settings.PageGap or (PreviewLayout and 12 or 10))
	Utility:AutoCanvas(Page, Layout, Settings.PageCanvasPadding or (PreviewLayout and 14 or 22))

	self.Button = Button
	self.Indicator = Indicator
	self.IconLabel = IconLabel
	self.Label = Label
	self.Page = Page
	self.Layout = Layout
	self.IndicatorWidth = IndicatorWidth
	self.IndicatorHeight = IndicatorHeight
	self.UseIndicator = UseIndicator
	self.PillTabs = PillTabs
	self.PageSlideOffset = Settings.PageSlideOffset or (PreviewLayout and 8 or 0)
	self.PageAnimation = Settings.TabPageAnimation ~= false
	self.SelectedTransparency = Settings.TabSelectedTransparency or 0
	self.HoverTransparency = Settings.TabHoverTransparency or (PillTabs and 0.1 or 0.55)
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:_SetSelected(Window.ActiveTab == self)
	end)

	Button.MouseButton1Click:Connect(function()
		Window:_SelectTab(self)
	end)

	Button.MouseEnter:Connect(function()
		if Window.ActiveTab == self then return end
		local ActiveTheme = Theme:Get()
		Animation:Play(Button, {
			BackgroundColor3 = ActiveTheme.TabHover or ActiveTheme.SurfaceLight,
			BackgroundTransparency = self.HoverTransparency,
		}, { Time = 0.12 })
		Animation:Play(Label, { TextColor3 = ActiveTheme.Text }, { Time = 0.12 })
		if IconLabel then
			Animation:Play(IconLabel, { TextColor3 = ActiveTheme.Accent }, { Time = 0.12 })
		end
	end)

	Button.MouseLeave:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = 1 }, { Time = 0.12 })
		Animation:Play(Label, { TextColor3 = Theme:Get().SubText }, { Time = 0.12 })
		if IconLabel then
			Animation:Play(IconLabel, { TextColor3 = Theme:Get().Muted }, { Time = 0.12 })
		end
	end)

	return self
end

function Tab:_SetSelected(IsSelected)
	if not self.Page or not self.Page.Parent then
		return
	end

	if IsSelected then
		self.Page.Visible = true
		if self.PageAnimation then
			self.Page.Position = UDim2.new(0, self.PageSlideOffset, 0, 0)
			Animation:Play(self.Page, { Position = UDim2.new(0, 0, 0, 0) }, { Time = 0.18 })
		end
	else
		self.Page.Visible = false
	end

	if IsSelected then
		local ActiveTheme = Theme:Get()
		Animation:Play(self.Button, {
			BackgroundColor3 = self.PillTabs and (ActiveTheme.TabActive or ActiveTheme.Surface) or ActiveTheme.Surface,
			BackgroundTransparency = self.SelectedTransparency,
		}, { Time = 0.15 })
		if self.UseIndicator then
			Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, self.IndicatorHeight) }, { Time = 0.15 })
		end
		Animation:Play(self.Label, { TextColor3 = self.PillTabs and ActiveTheme.Accent or ActiveTheme.Text }, { Time = 0.15 })
		if self.IconLabel then
			Animation:Play(self.IconLabel, { TextColor3 = ActiveTheme.Accent }, { Time = 0.15 })
		end
	else
		Animation:Play(self.Button, { BackgroundTransparency = 1 }, { Time = 0.15 })
		if self.UseIndicator then
			Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, 0) }, { Time = 0.15 })
		end
		Animation:Play(self.Label, { TextColor3 = Theme:Get().SubText }, { Time = 0.15 })
		if self.IconLabel then
			Animation:Play(self.IconLabel, { TextColor3 = Theme:Get().Muted }, { Time = 0.15 })
		end
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
