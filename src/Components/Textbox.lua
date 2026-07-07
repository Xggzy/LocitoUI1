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

	local Row = Utility:Create("Frame", {
		Name = "Textbox",
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
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
		TextSize = 14,
		ClearTextOnFocus = Options.ClearTextOnFocus == true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Box, "TextColor3", "Text")
	Theme:Register(Box, "PlaceholderColor3", "Muted")

	Box.Focused:Connect(function()
		Animation:Play(Stroke, { Transparency = 0 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Accent }, { Time = 0.12 })
	end)

	Box.FocusLost:Connect(function(EnterPressed)
		self.Value = Box.Text
		Animation:Play(Stroke, { Transparency = 0.25 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Border }, { Time = 0.12 })
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
