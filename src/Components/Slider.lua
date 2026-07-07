-- LocitoUI Slider Component
-- Version 0.2.0

local Slider = {}
Slider.__index = Slider

local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Slider.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Slider)

	local Min = Options.Min or Options.Minimum or 0
	local Max = Options.Max or Options.Maximum or 100
	if Max < Min then
		Min, Max = Max, Min
	end

	self.Min = Min
	self.Max = Max
	self.Value = math.clamp(Options.Default or Options.Value or self.Min, self.Min, self.Max)
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Decimals = Options.Decimals or 0
	self.Step = Options.Step or Options.Increment or 0
	self.Prefix = Options.Prefix or ""
	self.Suffix = Options.Suffix or ""
	self.Format = Options.Format
	self.Range = self.Max - self.Min
	self.Connections = {}

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Slider",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 56),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 6),
		Size = UDim2.new(0.65, -12, 0, 20),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Slider",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 6),
		Size = UDim2.new(0.35, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = tostring(self.Value),
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Row,
	})
	Theme:Register(ValueLabel, "TextColor3", "SubText")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		Position = UDim2.new(0, 12, 0, 36),
		Size = UDim2.new(1, -24, 0, Options.TrackHeight or 8),
		BackgroundColor3 = CurrentTheme.Border,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)
	Theme:Register(Track, "BackgroundColor3", "Border")

	local Fill = Utility:Create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Fill, 99)
	Theme:Register(Fill, "BackgroundColor3", "Accent")

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 16, 0, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Knob, 99)

	self.Row = Row
	self.Track = Track
	self.Fill = Fill
	self.Knob = Knob
	self.ValueLabel = ValueLabel

	local Dragging = false

	local function RoundValue(Value)
		if self.Step > 0 then
			Value = self.Min + math.floor(((Value - self.Min) / self.Step) + 0.5) * self.Step
		end

		local Multiplier = 10 ^ self.Decimals
		return math.floor(Value * Multiplier + 0.5) / Multiplier
	end

	local function FormatValue(Value)
		if typeof(self.Format) == "function" then
			return tostring(self.Format(Value))
		end

		return self.Prefix .. tostring(Value) .. self.Suffix
	end

	function self:UpdateFromRatio(Ratio, SkipCallback)
		Ratio = math.clamp(Ratio, 0, 1)
		self.Value = RoundValue(self.Min + self.Range * Ratio)
		local VisualRatio = self.Range == 0 and 0 or (self.Value - self.Min) / self.Range
		ValueLabel.Text = FormatValue(self.Value)
		Fill.Size = UDim2.new(VisualRatio, 0, 1, 0)
		Knob.Position = UDim2.new(VisualRatio, 0, 0.5, 0)
		if not SkipCallback then
			Utility:SafeCall(self.Changed, self.Value)
		end
	end

	function self:UpdateFromMouse(Input, SkipCallback)
		local Pos = Track.AbsolutePosition.X
		local Size = Track.AbsoluteSize.X
		if Size <= 0 then
			return
		end

		self:UpdateFromRatio((Input.Position.X - Pos) / Size, SkipCallback)
	end

	table.insert(self.Connections, Track.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			self:UpdateFromMouse(Input, false)
		end
	end))

	table.insert(self.Connections, UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			self:UpdateFromMouse(Input, false)
		end
	end))

	table.insert(self.Connections, UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end))

	self:UpdateFromRatio(self.Range == 0 and 0 or (self.Value - self.Min) / self.Range, true)
	return self
end

function Slider:Set(Value)
	Value = math.clamp(tonumber(Value) or self.Min, self.Min, self.Max)
	self:UpdateFromRatio(self.Range == 0 and 0 or (Value - self.Min) / self.Range, false)
end

function Slider:Get()
	return self.Value
end

function Slider:SetBounds(Min, Max)
	if Max < Min then
		Min, Max = Max, Min
	end

	self.Min = Min
	self.Max = Max
	self.Range = self.Max - self.Min
	self:Set(self.Value)
end

function Slider:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	self.Connections = {}
	if self.Row then
		self.Row:Destroy()
	end
end

return Slider
