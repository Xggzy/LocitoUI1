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

	local Row = Utility:Create("TextButton", {
		Name = "Toggle",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
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
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 44, 0, 22),
		BackgroundColor3 = self.Value and CurrentTheme.Accent or CurrentTheme.Border,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = self.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 18),
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
			BackgroundColor3 = self.Value and T.Accent or T.Border,
		}, { Time = 0.14 })

		Animation:Play(Knob, {
			Position = self.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
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
		Animation:Play(Row, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
	end)

	Row.MouseLeave:Connect(function()
		Animation:Play(Row, { BackgroundColor3 = Theme:Get().Secondary }, { Time = 0.12 })
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
