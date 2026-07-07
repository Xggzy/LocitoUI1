-- LocitoUI executor/loadstring example.
-- Run this whole file from your executor.

local Success, ErrorMessage = xpcall(function()
	local Source = game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua")
	local Loader, CompileError = loadstring(Source)
	if not Loader then
		error(CompileError)
	end

	local LocitoUI = Loader()

	local Players = game:GetService("Players")
	local Parent = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")
	local TestGui = Instance.new("ScreenGui")
	local CanUseParent = pcall(function()
		TestGui.Parent = Parent
	end)
	TestGui:Destroy()

	if not CanUseParent then
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local Existing = Parent:FindFirstChild("LocitoUI")
	if Existing then
		Existing:Destroy()
	end

	local Window = LocitoUI.new({
		Name = "Locito",
		Subtitle = "RightControl toggles menu",
		LogoText = "LC",
		Theme = "Phantom",
		Parent = Parent,
		Width = 620,
		Height = 390,
		SidebarWidth = 138,
		Padding = 10,
		Gap = 8,
		ContentGap = 8,
		TopBarHeight = 52,
		PanelRadius = 10,
		TabHeight = 34,
		TabIndicatorHeight = 18,
		TabSelectedTransparency = 0.08,
		TabHoverTransparency = 0.55,
		Shadow = true,
		ShadowTransparency = 0.5,
		ToggleKey = "RightControl",
		ToggleAnimationTime = 0.18,
		DisplayOrder = 999999,
		Animate = true,
	})

	local Home = Window:CreateTab("Home", "H")
	local Main = Home:CreateSection({
		Name = "Dashboard",
		Padding = 10,
		ItemSpacing = 6,
		Radius = 10,
	})

	Main:Paragraph({
		Title = "LocitoUI loaded",
		Body = "RightControl toggles this menu. The logo, theme, tabs, and animation are all customizable.",
	})

	Main:Button({
		Text = "Hide menu",
		Style = "Accent",
		Height = 34,
		Callback = function()
			Window:Hide()
		end,
	})

	Main:Toggle({
		Text = "Demo toggle",
		Default = false,
		Changed = function(Value)
			Window:Notify("Toggle", "Value: " .. tostring(Value), 2, "Info")
		end,
	})

	Main:Slider({
		Text = "Demo slider",
		Min = 0,
		Max = 100,
		Default = 50,
		Step = 5,
		Suffix = "%",
	})

	Main:ColorPicker({
		Text = "Live accent",
		ApplyToTheme = true,
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(255, 120, 210),
			Color3.fromRGB(0, 157, 255),
			Color3.fromRGB(39, 212, 121),
			Color3.fromRGB(255, 186, 73),
		},
	})

	local Settings = Window:CreateTab("Settings", "S")
	local ThemeSection = Settings:CreateSection("Theme")

	ThemeSection:Dropdown({
		Text = "Theme",
		Options = { "Phantom", "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Phantom",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
		end,
	})

	ThemeSection:Keybind({
		Text = "Menu key",
		Default = "RightControl",
		Changed = function(Key, IsNewBind)
			if IsNewBind then
				Window:SetToggleKey(Key)
				Window:Notify("Menu key", "Toggle key set to " .. Key, 2, "Success")
			end
		end,
	})
end, function(Message)
	if debug and debug.traceback then
		return debug.traceback(Message)
	end

	return tostring(Message)
end)

if not Success then
	warn("[LocitoUI] Executor example failed:", ErrorMessage)
end
