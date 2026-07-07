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
	self.Enabled = Options.Enabled ~= false
	local Style = Options.Style or (Options.Accent and "Accent") or "Secondary"
	local BackgroundKey = Style == "Accent" and "Accent" or "Secondary"
	local TextKey = Style == "Accent" and "Text" or "Text"

	local Object = Utility:Create("TextButton", {
		Name = "Button",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 38),
		BackgroundColor3 = Options.BackgroundColor or CurrentTheme[BackgroundKey],
		BorderSizePixel = 0,
		Font = Options.Font or Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Button",
		TextColor3 = Options.TextColor or CurrentTheme[TextKey],
		TextSize = Options.TextSize or 14,
		TextTransparency = self.Enabled and 0 or 0.45,
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Object, Options.Radius or 9)
	local Stroke = Utility:Stroke(Object, CurrentTheme.Border, 1, 0.25)
	if not Options.BackgroundColor then
		Theme:Register(Object, "BackgroundColor3", BackgroundKey)
	end
	if not Options.TextColor then
		Theme:Register(Object, "TextColor3", TextKey)
	end
	Theme:Register(Stroke, "Color", "Border")

	Object.MouseEnter:Connect(function()
		if not self.Enabled then return end
		Animation:Play(Object, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
	end)

	Object.MouseLeave:Connect(function()
		if not self.Enabled then return end
		Animation:Play(Object, { BackgroundColor3 = Options.BackgroundColor or Theme:Get()[BackgroundKey] }, { Time = 0.12 })
	end)

	Object.MouseButton1Click:Connect(function()
		if not self.Enabled then return end
		Animation:Pop(Object)
		Utility:SafeCall(self.Callback)
	end)

	self.Object = Object
	return self
end

function Button:SetText(Text)
	self.Object.Text = Text
end

function Button:SetCallback(Callback)
	self.Callback = Callback
end

function Button:SetEnabled(Enabled)
	self.Enabled = Enabled == true
	self.Object.TextTransparency = self.Enabled and 0 or 0.45
end

function Button:Destroy()
	self.Object:Destroy()
end

return Button
