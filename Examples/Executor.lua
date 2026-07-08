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
		Name = "Locito Hub",
		TitleAccent = "Hub",
		Version = "v1.0",
		Subtitle = false,
		LogoText = "L",
		Theme = "Phantom",
		Layout = "Preview",
		Parent = Parent,
		Width = 672,
		Height = 430,
		SidebarWidth = 160,
		TopBarHeight = 54,
		TabHeight = 40,
		TabStyle = "Pill",
		TabSelectedTransparency = 0,
		TabHoverTransparency = 0.15,
		PageSlideOffset = 8,
		Shadow = true,
		ShadowTransparency = 0.42,
		ToggleKey = "RightControl",
		ToggleAnimationTime = 0.18,
		DisplayOrder = 999999,
		Animate = true,
	})

	local Main = Window:CreateTab("Main", "+")
	local Combat = Main:CreateSection("Combat")

	Combat:Toggle({
		Text = "Silent Aim",
		Default = false,
		Changed = function(Value)
			Window:Notify("Silent Aim", "Value: " .. tostring(Value), 2, "Info")
		end,
	})

	Combat:Slider({
		Text = "FOV",
		Min = 0,
		Max = 240,
		Default = 120,
		Step = 5,
	})

	Combat:Toggle({
		Text = "Team Check",
		Default = true,
	})

	Combat:Dropdown({
		Text = "Aim Part",
		Options = { "Head", "Torso", "HumanoidRootPart" },
		Default = "Head",
	})

	local Visuals = Main:CreateSection("Visuals")

	Visuals:Toggle({
		Text = "ESP",
		Default = false,
	})

	Visuals:Toggle({
		Text = "Chams",
		Default = false,
	})

	Visuals:ColorPicker({
		Text = "Accent",
		ApplyToTheme = true,
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(0, 218, 222),
			Color3.fromRGB(255, 86, 146),
			Color3.fromRGB(39, 212, 121),
			Color3.fromRGB(251, 191, 36),
		},
	})

	local Player = Window:CreateTab("Player", "P")
	local Movement = Player:CreateSection("Movement")

	Movement:Slider({
		Text = "Walk Speed",
		Min = 16,
		Max = 120,
		Default = 32,
		Step = 2,
	})

	Movement:Slider({
		Text = "Jump Power",
		Min = 50,
		Max = 180,
		Default = 70,
		Step = 5,
	})

	Movement:Toggle({
		Text = "Auto Sprint",
		Default = true,
	})

	local Misc = Window:CreateTab("Misc", "=")
	local Settings = Misc:CreateSection("Settings")

	Settings:Dropdown({
		Text = "Theme",
		Options = { "Phantom", "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Phantom",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
		end,
	})

	Settings:Keybind({
		Text = "Menu key",
		Default = "RightControl",
		Changed = function(Key, IsNewBind)
			if IsNewBind then
				Window:SetToggleKey(Key)
				Window:Notify("Menu key", "Toggle key set to " .. Key, 2, "Success")
			end
		end,
	})

	Settings:Button({
		Text = "Hide Menu",
		Style = "Accent",
		Callback = function()
			Window:Hide()
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
