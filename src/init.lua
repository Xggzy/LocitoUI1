-- LocitoUI Main Loader
-- Version 0.2.0

local LocitoUI = {}

local Window = require(script.Parent.Window)
local Theme = require(script.Parent.Theme)
local Config = require(script.Parent.Config)

LocitoUI.Version = "0.2.0"
LocitoUI.Theme = Theme
LocitoUI.Config = Config

function LocitoUI.new(Settings)
	return Window.new(Settings)
end

function LocitoUI:Create(Settings)
	return Window.new(Settings)
end

function LocitoUI:SetTheme(Name)
	return Theme:Set(Name)
end

function LocitoUI:GetTheme()
	return Theme:Get()
end

return LocitoUI
