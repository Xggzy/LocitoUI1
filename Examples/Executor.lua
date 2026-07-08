-- LocitoUI executor/loadstring example.
-- Run this whole file from your executor.

local Success, ErrorMessage = xpcall(function()
	local CacheBust = tostring(os.time())
	local Source = game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua?v=" .. CacheBust)
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
		Version = "v2.0",
		Subtitle = false,
		LogoText = "L",
		Theme = "Phantom",
		Layout = "Preview",
		Parent = Parent,
		Width = 700,
		Height = 462,
		SidebarWidth = 160,
		TopBarHeight = 54,
		TabHeight = 40,
		TabStyle = "Pill",
		TabSelectedTransparency = 0,
		TabHoverTransparency = 0.15,
		PageSlideOffset = 8,
		BackgroundLogo = true,
		BackgroundLogoText = "LC",
		BackgroundLogoSize = 190,
		BackgroundLogoRotationSpeed = 28,
		Shadow = true,
		ShadowTransparency = 0.42,
		ToggleKey = "RightControl",
		ToggleAnimationTime = 0.18,
		DisplayOrder = 999999,
		Animate = true,
	})

	local Aimbot = Window:CreateTab("Aimbot", "A")
	local Aim = Aimbot:CreateSection("Aimbot")

	Aim:Toggle({
		Text = "Silent Aim",
		Default = false,
	})

	Aim:Toggle({
		Text = "Team Check",
		Default = true,
	})

	Aim:Slider({
		Text = "FOV",
		Min = 0,
		Max = 240,
		Default = 120,
		Step = 5,
	})

	Aim:Slider({
		Text = "Smoothness",
		Min = 1,
		Max = 20,
		Default = 8,
		Step = 1,
	})

	Aim:Dropdown({
		Text = "Aim Part",
		Options = { "Head", "Torso", "HumanoidRootPart" },
		Default = "Head",
	})

	local Rage = Window:CreateTab("Rage", "R")
	local RageMain = Rage:CreateSection("Rage")

	RageMain:Toggle({
		Text = "Rapid Fire",
		Default = false,
	})

	RageMain:Toggle({
		Text = "No Recoil",
		Default = true,
	})

	RageMain:Toggle({
		Text = "Auto Peek",
		Default = false,
	})

	RageMain:Slider({
		Text = "Rage FOV",
		Min = 0,
		Max = 360,
		Default = 180,
		Step = 10,
	})

	RageMain:Dropdown({
		Text = "Target Mode",
		Options = { "Closest", "Lowest Health", "Crosshair" },
		Default = "Closest",
	})

	local Visual = Window:CreateTab("Visual", "V")
	local Esp = Visual:CreateSection("ESP")

	Esp:Toggle({
		Text = "Box ESP",
		Default = false,
		Changed = function(Value)
			Window:Notify("Visual", "Box ESP: " .. tostring(Value), 2, "Info")
		end,
	})

	Esp:Toggle({
		Text = "Name ESP",
		Default = true,
	})

	Esp:Toggle({
		Text = "Health Bar",
		Default = true,
	})

	Esp:Toggle({
		Text = "Chams",
		Default = false,
	})

	local VisualStyle = Visual:CreateSection("Visual Style")

	VisualStyle:Dropdown({
		Text = "Tracer Origin",
		Options = { "Bottom", "Center", "Mouse" },
		Default = "Bottom",
	})

	VisualStyle:ColorPicker({
		Text = "ESP Color",
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

	local UtilitySection = Player:CreateSection("Utility")

	UtilitySection:Toggle({
		Text = "No Clip",
		Default = false,
	})

	UtilitySection:Toggle({
		Text = "Infinite Jump",
		Default = false,
	})

	local Settings = Window:CreateTab("Settings", "S")
	local Menu = Settings:CreateSection("Menu")

	Menu:Dropdown({
		Text = "Theme",
		Options = { "Phantom", "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Phantom",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
		end,
	})

	Menu:ColorPicker({
		Text = "Theme Color",
		ApplyToTheme = true,
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(0, 218, 222),
			Color3.fromRGB(255, 86, 146),
			Color3.fromRGB(136, 92, 255),
			Color3.fromRGB(39, 212, 121),
			Color3.fromRGB(251, 191, 36),
		},
	})

	Menu:Keybind({
		Text = "Menu key",
		Default = "RightControl",
		Changed = function(Key, IsNewBind)
			if IsNewBind then
				Window:SetToggleKey(Key)
				Window:Notify("Menu key", "Toggle key set to " .. Key, 2, "Success")
			end
		end,
	})

	Menu:Toggle({
		Text = "Animated Logo",
		Default = true,
		Changed = function(Value)
			Window:SetBackgroundLogoVisible(Value)
		end,
	})

	Menu:Button({
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
