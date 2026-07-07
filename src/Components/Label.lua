-- LocitoUI Label Component
-- Version 0.2.0

local Label = {}
Label.__index = Label

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)

function Label.new(Section, Text)
	local self = setmetatable({}, Label)
	local CurrentTheme = Theme:Get()

	local Object = Utility:Create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = typeof(Text) == "table" and (Text.Text or "Label") or (Text or "Label"),
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = Section.Body,
	})
	Theme:Register(Object, "TextColor3", "SubText")

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
