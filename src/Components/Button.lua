-- LocitoUI Button Component
-- Version 0.2.0

local Button = {}
Button.__index = Button

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Button.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Button)

	local CurrentTheme = Theme:Get()
	self.Callback = Options.Callback or function() end

	local Object = Utility:Create("TextButton", {
		Name = "Button",
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Button",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Object, 9)
	local Stroke = Utility:Stroke(Object, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Object, "BackgroundColor3", "Secondary")
	Theme:Register(Object, "TextColor3", "Text")
	Theme:Register(Stroke, "Color", "Border")

	Object.MouseEnter:Connect(function()
		Animation:Play(Object, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
	end)

	Object.MouseLeave:Connect(function()
		Animation:Play(Object, { BackgroundColor3 = Theme:Get().Secondary }, { Time = 0.12 })
	end)

	Object.MouseButton1Click:Connect(function()
		Animation:Pop(Object)
		Utility:SafeCall(self.Callback)
	end)

	self.Object = Object
	return self
end

function Button:SetText(Text)
	self.Object.Text = Text
end

function Button:Destroy()
	self.Object:Destroy()
end

return Button
