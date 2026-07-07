-- LocitoUI Paragraph Component
-- Version 0.2.0

local Paragraph = {}
Paragraph.__index = Paragraph

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)

function Paragraph.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Paragraph)
	local CurrentTheme = Theme:Get()

	local Frame = Utility:Create("Frame", {
		Name = "Paragraph",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Section.Body,
	})
	Utility:List(Frame, 2)

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = Options.Title or "Paragraph",
		TextColor3 = CurrentTheme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	Theme:Register(Title, "TextColor3", "Text")

	local Body = Utility:Create("TextLabel", {
		Name = "Body",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = Options.Body or Options.Content or Options.Text or "Paragraph body",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	Theme:Register(Body, "TextColor3", "SubText")

	self.Frame = Frame
	self.Title = Title
	self.Body = Body
	return self
end

function Paragraph:Set(Title, Body)
	if Title then self.Title.Text = Title end
	if Body then self.Body.Text = Body end
end

function Paragraph:Destroy()
	self.Frame:Destroy()
end

return Paragraph
