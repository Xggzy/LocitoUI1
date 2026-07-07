-- LocitoUI Keybind Component
-- Version 0.2.0

local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Keybind.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Keybind)

	self.Key = Options.Default or Options.Key or "None"
	self.Callback = Options.Callback or Options.Changed or function() end
	self.Listening = false
	self.Connections = {}

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Keybind",
		Size = UDim2.new(1, 0, 0, 40),
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
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -100, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Keybind",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Button = Utility:Create("TextButton", {
		Name = "BindButton",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 78, 0, 26),
		BackgroundColor3 = CurrentTheme.Surface,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		Text = self.Key,
		TextColor3 = CurrentTheme.SubText,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = Row,
	})
	Utility:Round(Button, 7)
	Theme:Register(Button, "BackgroundColor3", "Surface")
	Theme:Register(Button, "TextColor3", "SubText")

	table.insert(self.Connections, Button.MouseButton1Click:Connect(function()
		self.Listening = true
		Button.Text = "..."
		Animation:Play(Button, { BackgroundColor3 = Theme:Get().Accent }, { Time = 0.12 })
	end))

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
		if Processed then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		if self.Listening then
			self.Key = Input.KeyCode.Name
			self.Listening = false
			Button.Text = self.Key
			Animation:Play(Button, { BackgroundColor3 = Theme:Get().Surface }, { Time = 0.12 })
			Utility:SafeCall(self.Callback, self.Key, true)
		elseif Input.KeyCode.Name == self.Key then
			Utility:SafeCall(self.Callback, self.Key, false)
		end
	end))

	self.Row = Row
	self.Button = Button
	return self
end

function Keybind:Set(Key)
	self.Key = Key
	self.Button.Text = Key
end

function Keybind:Get()
	return self.Key
end

function Keybind:Destroy()
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

return Keybind
