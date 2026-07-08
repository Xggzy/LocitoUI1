-- LocitoUI Textbox Component
-- Version 0.2.0

local Textbox = {}
Textbox.__index = Textbox

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Textbox.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Textbox)
	self.Value = Options.Default or ""
	self.Changed = Options.Changed or Options.Callback or function() end

	local CurrentTheme = Theme:Get()
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "Textbox",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 42)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Box = Utility:Create("TextBox", {
		Name = "Box",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Font = Enum.Font.Gotham,
		Text = self.Value,
		PlaceholderText = Options.Placeholder or Options.Text or "Type here...",
		PlaceholderColor3 = CurrentTheme.Muted,
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		ClearTextOnFocus = Options.ClearTextOnFocus == true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Box, "TextColor3", "Text")
	Theme:Register(Box, "PlaceholderColor3", "Muted")

	Box.Focused:Connect(function()
		Animation:Play(Stroke, { Transparency = 0 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Accent }, { Time = 0.12 })
		Animation:Play(Row, { BackgroundTransparency = PreviewLayout and 0.82 or RowTransparency }, { Time = 0.12 })
	end)

	if Options.Live == true or Options.LiveUpdate == true then
		Box:GetPropertyChangedSignal("Text"):Connect(function()
			self.Value = Box.Text
			Utility:SafeCall(self.Changed, self.Value, false)
		end)
	end

	Box.FocusLost:Connect(function(EnterPressed)
		self.Value = Box.Text
		Animation:Play(Stroke, { Transparency = StrokeTransparency }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Border }, { Time = 0.12 })
		Animation:Play(Row, { BackgroundTransparency = RowTransparency }, { Time = 0.12 })
		Utility:SafeCall(self.Changed, self.Value, EnterPressed)
	end)

	self.Row = Row
	self.Box = Box
	return self
end

function Textbox:Set(Value)
	self.Value = Value
	self.Box.Text = Value
end

function Textbox:Get()
	return self.Box.Text
end

function Textbox:Destroy()
	self.Row:Destroy()
end

return Textbox
