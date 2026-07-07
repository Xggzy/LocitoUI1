-- LocitoUI Animation System
-- Version 0.1.0

local Animation = {}

local TweenService = game:GetService("TweenService")


--------------------------------------------------
-- Default Settings
--------------------------------------------------

Animation.Default = {
	
	Time = 0.25,
	
	Style = Enum.EasingStyle.Quint,
	
	Direction = Enum.EasingDirection.Out
	
}


--------------------------------------------------
-- Create Tween
--------------------------------------------------

function Animation:Create(Object, Properties, Settings)

	Settings = Settings or {}

	local Info = TweenInfo.new(
		Settings.Time or self.Default.Time,
		Settings.Style or self.Default.Style,
		Settings.Direction or self.Default.Direction
	)

	local Tween = TweenService:Create(
		Object,
		Info,
		Properties
	)

	return Tween

end


--------------------------------------------------
-- Play Animation
--------------------------------------------------

function Animation:Play(Object, Properties, Settings)

	local Tween = self:Create(
		Object,
		Properties,
		Settings
	)

	Tween:Play()

	return Tween

end


--------------------------------------------------
-- Fade In
--------------------------------------------------

function Animation:FadeIn(Object)

	if Object:IsA("GuiObject") then
		
		Object.BackgroundTransparency = 1
		
		self:Play(
			Object,
			{
				BackgroundTransparency = 0
			}
		)
		
	end

end


--------------------------------------------------
-- Fade Out
--------------------------------------------------

function Animation:FadeOut(Object)

	if Object:IsA("GuiObject") then
		
		self:Play(
			Object,
			{
				BackgroundTransparency = 1
			}
		)
		
	end

end


--------------------------------------------------
-- Hover Effect
--------------------------------------------------

function Animation:Hover(Object, NormalSize)

	Object.MouseEnter:Connect(function()

		self:Play(
			Object,
			{
				Size = NormalSize + UDim2.new(
					0,
					4,
					0,
					4
				)
			},
			{
				Time = 0.15
			}
		)

	end)


	Object.MouseLeave:Connect(function()

		self:Play(
			Object,
			{
				Size = NormalSize
			},
			{
				Time = 0.15
			}
		)

	end)

end


return Animation