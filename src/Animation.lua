-- LocitoUI Animation System
-- Version 0.2.0

local Animation = {}
local TweenService = game:GetService("TweenService")

Animation.Default = {
	Time = 0.22,
	Style = Enum.EasingStyle.Quint,
	Direction = Enum.EasingDirection.Out,
}

function Animation:Create(Object, Properties, Settings)
	Settings = Settings or {}

	local Tween = TweenService:Create(
		Object,
		TweenInfo.new(
			Settings.Time or self.Default.Time,
			Settings.Style or self.Default.Style,
			Settings.Direction or self.Default.Direction
		),
		Properties
	)

	return Tween
end

function Animation:Play(Object, Properties, Settings)
	local Tween = self:Create(Object, Properties, Settings)
	Tween:Play()
	return Tween
end

function Animation:Pop(Object)
	local Original = Object.Size
	self:Play(Object, { Size = Original + UDim2.new(0, 4, 0, 4) }, { Time = 0.08 })
	task.delay(0.08, function()
		if Object and Object.Parent then
			self:Play(Object, { Size = Original }, { Time = 0.12 })
		end
	end)
end

function Animation:FadeObject(Object, Transparency, Time)
	local Props = {}

	if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
		Props.TextTransparency = Transparency
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		Props.ImageTransparency = Transparency
	end

	if Object:IsA("GuiObject") then
		Props.BackgroundTransparency = Transparency
	end

	return self:Play(Object, Props, { Time = Time or self.Default.Time })
end

return Animation
