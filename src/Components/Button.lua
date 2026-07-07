-- LocitoUI Button Component
-- Version 0.1.0

local Button = {}

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Button.new(Section, Options)

	Options = Options or {}

	local Btn = Instance.new("TextButton")
	Btn.Name = "Button"
	Btn.Size = UDim2.new(1, 0, 0, 36)
	Btn.BackgroundColor3 = Theme:Get().Surface
	Btn.Text = Options.Text or "Button"
	Btn.TextColor3 = Theme:Get().Text
	Btn.TextSize = 14
	Btn.Font = Enum.Font.GothamMedium
	Btn.AutoButtonColor = false
	Btn.Parent = Section.Frame

	Utility:Round(Btn, 8)
	Utility:Stroke(Btn, Theme:Get().Border, 1)

	Btn.MouseEnter:Connect(function()
		Animation:Play(Btn, {
			BackgroundColor3 = Theme:Get().Accent
		}, { Time = 0.15 })
	end)

	Btn.MouseLeave:Connect(function()
		Animation:Play(Btn, {
			BackgroundColor3 = Theme:Get().Surface
		}, { Time = 0.15 })
	end)

	Btn.MouseButton1Click:Connect(function()
		Utility:Callback(Options.Callback)
	end)

	return Btn

end

return Button