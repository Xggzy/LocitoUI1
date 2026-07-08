-- LocitoUI Toggle Component
-- Version 0.2.0

local Toggle = {}
Toggle.__index = Toggle

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Toggle.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Toggle)

	self.Value = Options.Default == true
	self.Changed = Options.Changed or Options.Callback or function() end

	local CurrentTheme = Theme:Get()
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)
	local TrackOffColor = CurrentTheme.Track or CurrentTheme.Border

	local Row = Utility:Create("TextButton", {
		Name = "Toggle",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 40)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -74, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Toggle",
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 36 or 44, 0, PreviewLayout and 20 or 22),
		BackgroundColor3 = self.Value and CurrentTheme.Accent or TrackOffColor,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = self.Value and UDim2.new(1, PreviewLayout and -18 or -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 16 or 18, 0, PreviewLayout and 16 or 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Knob, 99)

	self.Row = Row
	self.Track = Track
	self.Knob = Knob

	function self:Refresh(SkipCallback)
		if not Row.Parent then
			return
		end

		local T = Theme:Get()
		Animation:Play(Track, {
			BackgroundColor3 = self.Value and T.Accent or (T.Track or T.Border),
		}, { Time = 0.14 })

		Animation:Play(Knob, {
			Position = self.Value and UDim2.new(1, PreviewLayout and -18 or -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}, { Time = 0.14 })

		if not SkipCallback then
			Utility:SafeCall(self.Changed, self.Value)
		end
	end

	self.ThemeDisconnect = Theme:OnChanged(function()
		self:Refresh(true)
	end)

	Row.MouseButton1Click:Connect(function()
		self.Value = not self.Value
		self:Refresh(false)
	end)

	Row.MouseEnter:Connect(function()
		Animation:Play(Row, {
			BackgroundColor3 = Theme:Get().SurfaceLight,
			BackgroundTransparency = PreviewLayout and 0.82 or RowTransparency,
		}, { Time = 0.12 })
	end)

	Row.MouseLeave:Connect(function()
		Animation:Play(Row, {
			BackgroundColor3 = Theme:Get().Secondary,
			BackgroundTransparency = RowTransparency,
		}, { Time = 0.12 })
	end)

	return self
end

function Toggle:Set(Value)
	self.Value = Value == true
	self:Refresh(false)
end

function Toggle:Get()
	return self.Value
end

function Toggle:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.ThemeDisconnect then
		self.ThemeDisconnect()
		self.ThemeDisconnect = nil
	end

	if self.Row then
		self.Row:Destroy()
	end
end

return Toggle
