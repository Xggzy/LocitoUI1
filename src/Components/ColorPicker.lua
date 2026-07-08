-- LocitoUI ColorPicker Component
-- Version 0.2.0
-- Simple preset-based picker for v0.2. A full color wheel can be added later.

local ColorPicker = {}
ColorPicker.__index = ColorPicker

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Presets = {
	Color3.fromRGB(155, 90, 255),
	Color3.fromRGB(0, 157, 255),
	Color3.fromRGB(39, 212, 121),
	Color3.fromRGB(255, 78, 95),
	Color3.fromRGB(255, 186, 73),
	Color3.fromRGB(255, 120, 210),
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(40, 40, 48),
}

function ColorPicker.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, ColorPicker)
	self.Presets = Options.Presets or Options.Colors or Presets
	if #self.Presets == 0 then
		self.Presets = Presets
	end
	self.Value = Options.Default or self.Presets[1]
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Open = false

	local CurrentTheme = Theme:Get()
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "ColorPicker",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 42)),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Utility:Padding(Row, PreviewLayout and 0 or 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, PreviewLayout and 0 or 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, PreviewLayout and 45 or 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = Row,
	})

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -44, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Color",
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Label.Position = UDim2.new(0, PreviewLayout and 12 or 0, 0, 0)
	Theme:Register(Label, "TextColor3", "Text")

	local Preview = Utility:Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, PreviewLayout and -12 or 0, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 36 or 32, 0, PreviewLayout and 24 or 22),
		BackgroundColor3 = self.Value,
		BorderSizePixel = 0,
		Parent = Header,
	})
	Utility:Round(Preview, 7)
	local PreviewStroke = Utility:Stroke(Preview, CurrentTheme.Border, 1, 0.2)
	Theme:Register(PreviewStroke, "Color", "Border")

	local Palette = Utility:Create("Frame", {
		Name = "Palette",
		Size = UDim2.new(1, PreviewLayout and -24 or 0, 0, 32),
		Position = UDim2.new(0, PreviewLayout and 12 or 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Row,
	})
	Utility:List(Palette, 6, Enum.FillDirection.Horizontal)

	for _, Color in ipairs(self.Presets) do
		local Swatch = Utility:Create("TextButton", {
			Size = UDim2.new(0, Options.SwatchSize or 28, 0, Options.SwatchSize or 28),
			BackgroundColor3 = Color,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Parent = Palette,
		})
		Utility:Round(Swatch, 8)
		local SwatchStroke = Utility:Stroke(Swatch, CurrentTheme.Border, 1, 0.2)
		Theme:Register(SwatchStroke, "Color", "Border")

		Swatch.MouseButton1Click:Connect(function()
			self:Set(Color)
			if Options.ApplyToTheme then
				local ThemeKey = Options.ThemeKey or Options.ColorKey or Options.ApplyToTheme
				if ThemeKey == true then
					ThemeKey = "Accent"
				end
				Theme:SetColor(ThemeKey, Color)
			end
			if Options.CloseOnSelect then
				self.Open = false
				Palette.Visible = false
			end
		end)
	end

	Header.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		Palette.Visible = self.Open
		if PreviewLayout then
			Animation:Play(Preview, { Size = self.Open and UDim2.new(0, 42, 0, 24) or UDim2.new(0, 36, 0, 24) }, { Time = 0.12 })
		end
	end)

	self.Row = Row
	self.Preview = Preview
	self.Palette = Palette
	return self
end

function ColorPicker:Set(Color)
	self.Value = Color
	self.Preview.BackgroundColor3 = Color
	Utility:SafeCall(self.Changed, Color)
end

function ColorPicker:Get()
	return self.Value
end

function ColorPicker:Destroy()
	self.Row:Destroy()
end

return ColorPicker
