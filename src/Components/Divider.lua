-- LocitoUI Divider Component
-- Version 0.2.0

local Divider = {}
Divider.__index = Divider

local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)

function Divider.new(Section)
	local self = setmetatable({}, Divider)
	local Object = Utility:Create("Frame", {
		Name = "Divider",
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme:Get().Border,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Theme:Register(Object, "BackgroundColor3", "Border")
	self.Object = Object
	return self
end

function Divider:Destroy()
	self.Object:Destroy()
end

return Divider
