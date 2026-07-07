-- LocitoUI Main Loader
-- Version 0.1.0

local LocitoUI = {}


local Window = require(script.Parent.Window)
local Theme = require(script.Parent.Theme)


--------------------------------------------------
-- Create UI
--------------------------------------------------

function LocitoUI.new(Settings)

	local UI = Window.new(Settings)

	return UI

end


--------------------------------------------------
-- Theme Access
--------------------------------------------------

function LocitoUI:SetTheme(Name)

	return Theme:Set(Name)

end


function LocitoUI:GetTheme()

	return Theme:Get()

end


--------------------------------------------------
-- Version
--------------------------------------------------

LocitoUI.Version = "0.1.0"


return LocitoUI