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

	local Button = Utility:Create("TextButton", {
		Name = Name .. "Tab",
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Window.SidebarList,
	})
	Utility:Round(Button, 9)
	Theme:Register(Button, "BackgroundColor3", "Surface")

	local Indicator = Utility:Create("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 3, 0, 0),
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Button,
	})
	Utility:Round(Indicator, 99)
	Theme:Register(Indicator, "BackgroundColor3", "Accent")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -16, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = (Icon and (Icon .. "  ") or "") .. Name,
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
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
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:_SetSelected(Window.ActiveTab == self)
	end)

	Button.MouseButton1Click:Connect(function()
		Window:_SelectTab(self)
	end)

	Button.MouseEnter:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = 0.55 }, { Time = 0.12 })
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
		Animation:Play(self.Button, { BackgroundTransparency = 0 }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, 3, 0, 22) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().Text }, { Time = 0.15 })
	else
		Animation:Play(self.Button, { BackgroundTransparency = 1 }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, 3, 0, 0) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().SubText }, { Time = 0.15 })
	end
end

function Tab:CreateSection(Name)
	local NewSection = Section.new(self, Name)
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
