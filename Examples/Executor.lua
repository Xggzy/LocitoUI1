-- LocitoUI executor/loadstring example.
-- Run this whole file from your executor.

local Success, ErrorMessage = xpcall(function()
	local Source = game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua")
	local Loader, CompileError = loadstring(Source)
	if not Loader then
		error(CompileError)
	end

	local LocitoUI = Loader()

	LocitoUI:AddTheme("Candy", {
		Background = Color3.fromRGB(18, 12, 20),
		Secondary = Color3.fromRGB(28, 19, 31),
		Surface = Color3.fromRGB(39, 27, 44),
		SurfaceLight = Color3.fromRGB(53, 35, 61),
		Accent = Color3.fromRGB(255, 120, 210),
		AccentLight = Color3.fromRGB(255, 174, 230),
		Text = Color3.fromRGB(255, 246, 252),
		SubText = Color3.fromRGB(214, 178, 204),
		Muted = Color3.fromRGB(116, 82, 108),
		Border = Color3.fromRGB(92, 58, 86),
	}, "Nebula")

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
		Subtitle = "Executor test",
		LogoText = "L",
		Theme = "Candy",
		Parent = Parent,
		Width = 560,
		Height = 360,
		SidebarWidth = 130,
		Padding = 12,
		Gap = 10,
		DisplayOrder = 999999,
		Animate = false,
	})

	local Home = Window:CreateTab("Home", "H")
	local Main = Home:CreateSection({
		Name = "Main",
		Padding = 10,
		ItemSpacing = 6,
	})

	Main:Paragraph({
		Title = "LocitoUI loaded",
		Body = "If you can see this, the standalone bundle is working.",
	})

	Main:Button({
		Text = "Show notification",
		Style = "Accent",
		Height = 34,
		Callback = function()
			Window:Notify("LocitoUI", "Notifications are working.", 4, "Success")
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
		Options = { "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Nebula",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
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
