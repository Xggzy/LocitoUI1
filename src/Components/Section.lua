-- LocitoUI Section System
-- Version 0.2.0

local Section = {}
Section.__index = Section

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Button = require(script.Parent.Button)
local Toggle = require(script.Parent.Toggle)
local Slider = require(script.Parent.Slider)
local Label = require(script.Parent.Label)
local Paragraph = require(script.Parent.Paragraph)
local Divider = require(script.Parent.Divider)
local Textbox = require(script.Parent.Textbox)
local Dropdown = require(script.Parent.Dropdown)
local Keybind = require(script.Parent.Keybind)
local ColorPicker = require(script.Parent.ColorPicker)

function Section.new(Tab, Name, Options)
	if typeof(Name) == "table" then
		Options = Name
		Name = Options.Name or Options.Title or "Section"
	end
	Options = Options or {}

	local self = setmetatable({}, Section)
	self.Tab = Tab
	self.Name = Name
	self.Elements = {}

	local CurrentTheme = Theme:Get()
	local WindowSettings = Tab.Window and Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local TitleColorKey = Options.TitleColorKey or (PreviewLayout and "Accent" or "Text")
	local ShouldUppercase = Options.UppercaseTitle == true or (PreviewLayout and Options.UppercaseTitle ~= false)
	local SectionTitle = ShouldUppercase and string.upper(tostring(Name)) or Name
	local ShowDivider = Options.TitleDivider == true or (PreviewLayout and Options.TitleDivider ~= false)
	local TitleInset = Options.TitleInset or (PreviewLayout and 16 or 0)

	local Frame = Utility:Create("Frame", {
		Name = Name .. "Section",
		Size = Options.Size or UDim2.new(1, Options.WidthOffset or (PreviewLayout and 0 or -6), 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Options.Transparency or Options.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		Parent = Tab.Page,
	})
	Utility:Round(Frame, Options.Radius or CurrentTheme.CornerRadius or 12)
	local Stroke = Utility:Stroke(Frame, CurrentTheme.Border, 1, 0.15)
	Utility:Padding(Frame, Options.Padding or (PreviewLayout and 0 or 12))
	Theme:Register(Frame, "BackgroundColor3", "Surface")
	Theme:Register(Stroke, "Color", "Border")

	local Layout = Utility:List(Frame, Options.Spacing or (PreviewLayout and 0 or 8))

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Options.TitleHeight or (PreviewLayout and 38 or 20)),
		Visible = Options.ShowTitle ~= false,
		Font = Options.TitleFont or (PreviewLayout and Enum.Font.Code or Enum.Font.GothamBold),
		Text = SectionTitle,
		TextColor3 = CurrentTheme[TitleColorKey] or CurrentTheme.Text,
		TextSize = Options.TitleSize or (PreviewLayout and 12 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	if TitleInset > 0 then
		local TitlePadding = Instance.new("UIPadding")
		TitlePadding.PaddingLeft = UDim.new(0, TitleInset)
		TitlePadding.PaddingRight = UDim.new(0, TitleInset)
		TitlePadding.Parent = Title
	end
	Theme:Register(Title, "TextColor3", TitleColorKey)

	local Divider = Utility:Create("Frame", {
		Name = "TitleDivider",
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 1),
		Visible = ShowDivider and Options.ShowTitle ~= false,
		BackgroundColor3 = CurrentTheme.Border,
		BackgroundTransparency = Options.TitleDividerTransparency or (PreviewLayout and 0.45 or 0.65),
		BorderSizePixel = 0,
		Parent = Frame,
	})
	Theme:Register(Divider, "BackgroundColor3", "Border")

	local Body = Utility:Create("Frame", {
		Name = "Body",
		LayoutOrder = Options.ShowTitle == false and 1 or 3,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Frame,
	})
	Utility:Padding(Body, Options.BodyPadding or (PreviewLayout and 0 or 0))
	local BodyLayout = Utility:List(Body, Options.ItemSpacing or Options.Spacing or (PreviewLayout and 0 or 8))

	self.Frame = Frame
	self.Body = Body
	self.Layout = Layout
	self.BodyLayout = BodyLayout
	self.Title = Title
	self.Divider = Divider

	if Options.Animate ~= false and WindowSettings.SectionAnimation ~= false then
		local TargetTransparency = Frame.BackgroundTransparency
		Frame.BackgroundTransparency = 1
		task.defer(function()
			if Frame.Parent then
				Animation:Play(Frame, { BackgroundTransparency = TargetTransparency }, { Time = 0.18 })
			end
		end)
	end

	return self
end

function Section:_Track(Element)
	table.insert(self.Elements, Element)
	return Element
end

function Section:Button(Options)
	return self:_Track(Button.new(self, Options))
end

function Section:Toggle(Options)
	return self:_Track(Toggle.new(self, Options))
end

function Section:Slider(Options)
	return self:_Track(Slider.new(self, Options))
end

function Section:Label(Text)
	return self:_Track(Label.new(self, Text))
end

function Section:Paragraph(Options)
	return self:_Track(Paragraph.new(self, Options))
end

function Section:Divider()
	return self:_Track(Divider.new(self))
end

function Section:Textbox(Options)
	return self:_Track(Textbox.new(self, Options))
end

function Section:Dropdown(Options)
	return self:_Track(Dropdown.new(self, Options))
end

function Section:Keybind(Options)
	return self:_Track(Keybind.new(self, Options))
end

function Section:ColorPicker(Options)
	return self:_Track(ColorPicker.new(self, Options))
end

function Section:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Element in ipairs(self.Elements) do
		if Element.Destroy then
			Element:Destroy()
		end
	end
	self.Elements = {}

	if self.Frame then
		self.Frame:Destroy()
	end
end

return Section
