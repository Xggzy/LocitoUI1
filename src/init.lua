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

function LocitoUI:GetThemes()
	return Theme:GetThemes()
end

function LocitoUI:AddTheme(Name, Values, BaseName)
	return Theme:Add(Name, Values, BaseName)
end

function LocitoUI:SetAccent(Color, AccentLight)
	return Theme:SetAccent(Color, AccentLight)
end

function LocitoUI:SetThemeColor(Key, Color)
	return Theme:SetColor(Key, Color)
end

function LocitoUI:SetThemeColors(Values)
	return Theme:SetColors(Values)
end

return LocitoUI
