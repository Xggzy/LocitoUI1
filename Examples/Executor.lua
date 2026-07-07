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
		Subtitle = "Executor test",
		LogoText = "L",
		Parent = Parent,
		Width = 560,
		Height = 360,
		DisplayOrder = 999999,
		Animate = false,
	})

	local Home = Window:CreateTab("Home", "H")
	local Main = Home:CreateSection("Main")

	Main:Paragraph({
		Title = "LocitoUI loaded",
		Body = "If you can see this, the standalone bundle is working.",
	})

	Main:Button({
		Text = "Show notification",
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
