-- LocitoUI Section System
-- Version 0.1.0

local Section = {}
Section.__index = Section

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Button = require(script.Parent.Button)
function Section.new(Tab, Name)

	local self = setmetatable({}, Section)

	self.Tab = Tab
	self.Name = Name

	local Frame = Instance.new("Frame")
	Frame.Name = Name .. "_Section"
	Frame.Size = UDim2.new(1, -10, 0, 80)
	Frame.BackgroundColor3 = Theme:Get().Secondary
	Frame.Parent = Tab.Page
	Frame.AutomaticSize = Enum.AutomaticSize.Y

	Utility:Round(Frame, 10)
	Utility:Stroke(Frame, Theme:Get().Border, 1)
	Utility:Padding(Frame, 10)

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 25)
	Title.BackgroundTransparency = 1
	Title.Text = Name
	Title.TextColor3 = Theme:Get().Text
	Title.TextSize = 15
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Frame

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 8)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Frame

	self.Frame = Frame
	self.Layout = Layout

	return self

end
function Section:Button(Options)
	return Button.new(self, Options)
end
return Section