-- LocitoUI Example
-- Put LocitoUI in ReplicatedStorage, then run this from a LocalScript.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocitoUI = require(ReplicatedStorage:WaitForChild("LocitoUI"):WaitForChild("src"))

local Window = LocitoUI.new({
	Name = "Locito Hub",
	Subtitle = "Original UI library test",
	LogoText = "L",
})

local Home = Window:CreateTab("Home", "⌂")
local Controls = Window:CreateTab("Controls", "◆")
local Settings = Window:CreateTab("Settings", "⚙")

local Intro = Home:CreateSection("Welcome")
Intro:Paragraph({
	Title = "LocitoUI v" .. LocitoUI.Version,
	Body = "This is a clean, original Roblox UI library with tabs, sections, components, themes, and notifications.",
})
Intro:Button({
	Text = "Show notification",
	Callback = function()
		Window:Notify("LocitoUI", "The notification system is working.", 4, "Success")
	end,
})

local Demo = Controls:CreateSection("Components")
Demo:Label("Basic controls")
Demo:Button({
	Text = "Click me",
	Callback = function()
		Window:Notify("Button", "You clicked the button.", 3, "Info")
	end,
})
Demo:Toggle({
	Text = "Demo toggle",
	Default = false,
	Changed = function(Value)
		Window:Notify("Toggle", "Value: " .. tostring(Value), 2, "Info")
	end,
})
Demo:Slider({
	Text = "Demo slider",
	Min = 0,
	Max = 100,
	Default = 50,
	Changed = function(Value)
		print("Slider:", Value)
	end,
})
Demo:Textbox({
	Placeholder = "Type a status...",
	Changed = function(Text)
		Window:Notify("Textbox", Text, 3, "Info")
	end,
})
Demo:Dropdown({
	Text = "Select option",
	Options = { "Alpha", "Beta", "Gamma" },
	Default = "Alpha",
	Changed = function(Value)
		print("Dropdown:", Value)
	end,
})
Demo:Keybind({
	Text = "Toggle UI",
	Default = "RightControl",
	Callback = function(Key, ChangedBind)
		if not ChangedBind then
			Window:Toggle()
		end
	end,
})
Demo:ColorPicker({
	Text = "Accent preview",
	Changed = function(Color)
		print("Color:", Color)
	end,
})

local ThemeSection = Settings:CreateSection("Themes")
ThemeSection:Dropdown({
	Text = "Theme",
	Options = { "Nebula", "Carbon", "Ocean", "Emerald" },
	Default = "Nebula",
	Changed = function(Name)
		LocitoUI:SetTheme(Name)
		Window:Notify("Theme", "Changed to " .. Name, 3, "Success")
	end,
})
ThemeSection:Button({
	Text = "Destroy UI",
	Callback = function()
		Window:Destroy()
	end,
})
