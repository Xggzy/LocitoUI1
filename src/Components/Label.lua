-- LocitoUI Label Component
-- Version 0.2.0

local Label = {}
Label.__index = Label

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)

function Label.new(Section, Text)
	local Options = typeof(Text) == "table" and Text or { Text = Text }
	local self = setmetatable({}, Label)
	local CurrentTheme = Theme:Get()

	local Object = Utility:Create("TextLabel", {
		Name = "Label",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 22),
		BackgroundTransparency = 1,
		Font = Options.Font or Enum.Font.Gotham,
		Text = Options.Text or "Label",
		TextColor3 = Options.TextColor or CurrentTheme.SubText,
		TextSize = Options.TextSize or 13,
		TextXAlignment = Options.Alignment or Options.TextXAlignment or Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = Section.Body,
	})
	if not Options.TextColor then
		Theme:Register(Object, "TextColor3", Options.ThemeKey or "SubText")
	end

	self.Object = Object
	return self
end

function Label:Set(Text)
	self.Object.Text = Text
end

function Label:Get()
	return self.Object.Text
end

function Label:Destroy()
	self.Object:Destroy()
end

return Label
