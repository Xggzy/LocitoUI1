-- LocitoUI Dropdown Component
-- Version 0.2.0

local Dropdown = {}
Dropdown.__index = Dropdown

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

function Dropdown.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Dropdown)

	self.Options = Options.Options or Options.Values or {}
	self.Value = Options.Default or self.Options[1]
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Open = false

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Dropdown",
		Size = UDim2.new(1, 0, 0, 42),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Utility:Padding(Row, 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "",
		AutoButtonColor = false,
		Parent = Row,
	})

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Dropdown",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.Gotham,
		Text = tostring(self.Value or "None") .. "  v",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Header,
	})
	Theme:Register(ValueLabel, "TextColor3", "SubText")

	local OptionsFrame = Utility:Create("Frame", {
		Name = "Options",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Row,
	})
	Utility:List(OptionsFrame, 4)

	self.Row = Row
	self.Header = Header
	self.ValueLabel = ValueLabel
	self.OptionsFrame = OptionsFrame

	function self:Rebuild()
		if not Row.Parent then
			return
		end

		local ActiveTheme = Theme:Get()

		for _, Child in ipairs(OptionsFrame:GetChildren()) do
			if Child:IsA("TextButton") then
				Child:Destroy()
			end
		end

		for _, Option in ipairs(self.Options) do
			local OptionButton = Utility:Create("TextButton", {
				Name = tostring(Option),
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = Option == self.Value and ActiveTheme.SurfaceLight or ActiveTheme.Surface,
				BorderSizePixel = 0,
				Font = Enum.Font.Gotham,
				Text = tostring(Option),
				TextColor3 = ActiveTheme.Text,
				TextSize = 13,
				AutoButtonColor = false,
				Parent = OptionsFrame,
			})
			Utility:Round(OptionButton, 7)
			Theme:Register(OptionButton, "TextColor3", "Text")

			OptionButton.MouseEnter:Connect(function()
				Animation:Play(OptionButton, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.1 })
			end)

			OptionButton.MouseLeave:Connect(function()
				Animation:Play(OptionButton, { BackgroundColor3 = Option == self.Value and Theme:Get().SurfaceLight or Theme:Get().Surface }, { Time = 0.1 })
			end)

			OptionButton.MouseButton1Click:Connect(function()
				self:Set(Option)
				self:Toggle(false)
			end)
		end
	end

	function self:Toggle(Force)
		self.Open = Force ~= nil and Force or not self.Open
		OptionsFrame.Visible = self.Open
		ValueLabel.Text = tostring(self.Value or "None") .. (self.Open and "  ^" or "  v")
	end

	Header.MouseButton1Click:Connect(function()
		self:Toggle()
	end)

	self:Rebuild()
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:Rebuild()
	end)

	return self
end

function Dropdown:Set(Value)
	self.Value = Value
	self.ValueLabel.Text = tostring(Value or "None") .. (self.Open and "  ^" or "  v")
	self:Rebuild()
	Utility:SafeCall(self.Changed, Value)
end

function Dropdown:Get()
	return self.Value
end

function Dropdown:SetOptions(Options)
	self.Options = Options or {}
	self:Rebuild()
end

function Dropdown:Destroy()
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

return Dropdown
