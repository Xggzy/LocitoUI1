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
	local RunService = game:GetService("RunService")
	local Stats = game:GetService("Stats")
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
		BackgroundLogoName = "Locito",
		BackgroundLogoSize = 190,
		BackgroundLogoTextTransparency = 0.68,
		BackgroundLogoTextStrokeTransparency = 0.86,
		BackgroundLogoRotationSpeed = 28,
		BackgroundSwordPosition = UDim2.new(0.64, 0, 0.58, 0),
		BackgroundSwordRotation = -26,
		BackgroundSwordTransparency = 0.56,
		Shadow = true,
		ShadowTransparency = 0.42,
		ToggleKey = "RightControl",
		ToggleAnimationTime = 0.18,
		DisplayOrder = 999999,
		Animate = true,
	})

	local FeatureIndex = {
		"Aimbot: Silent Aim",
		"Aimbot: Team Check",
		"Aimbot: FOV",
		"Aimbot: Smoothness",
		"Aimbot: Aim Part",
		"Rage: Rapid Fire",
		"Rage: No Recoil",
		"Rage: Auto Peek",
		"Rage: Rage FOV",
		"Rage: Target Mode",
		"Visual: Box ESP",
		"Visual: Name ESP",
		"Visual: Health Bar",
		"Visual: Chams",
		"Visual: Tracer Origin",
		"Visual: ESP Color",
		"Player: Walk Speed",
		"Player: Jump Power",
		"Player: Auto Sprint",
		"Player: No Clip",
		"Player: Infinite Jump",
		"Theme: Preset",
		"Theme: Accent Color",
		"Theme: Accent Glow",
		"Theme: Background Color",
		"Theme: Panel Color",
		"Theme: Panel Highlight",
		"Theme: Border Color",
		"Theme: Text Color",
		"Theme: Muted Text Color",
		"Theme: Slider Track",
		"Settings: Status",
		"Settings: Ping",
		"Settings: FPS",
		"Settings: Network",
		"Settings: Connection",
		"Settings: Menu Key",
		"Settings: Animated Logo",
	}

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

	local ThemeTab = Window:CreateTab("Theme", "T")
	local ThemeSession = ThemeTab:CreateSection("Theme Session")

	ThemeSession:Dropdown({
		Text = "Theme Preset",
		Options = { "Phantom", "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Phantom",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
		end,
	})

	ThemeSession:ColorPicker({
		Text = "Accent Color",
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

	ThemeSession:ColorPicker({
		Text = "Accent Glow",
		ApplyToTheme = "AccentLight",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(84, 255, 255),
			Color3.fromRGB(255, 160, 205),
			Color3.fromRGB(190, 164, 255),
			Color3.fromRGB(135, 241, 183),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Background Color",
		ApplyToTheme = "Background",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(8, 10, 14),
			Color3.fromRGB(14, 10, 18),
			Color3.fromRGB(7, 18, 31),
			Color3.fromRGB(8, 18, 14),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Panel Color",
		ApplyToTheme = "Surface",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(16, 19, 25),
			Color3.fromRGB(27, 27, 42),
			Color3.fromRGB(20, 44, 33),
			Color3.fromRGB(16, 43, 70),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Panel Highlight",
		ApplyToTheme = "SurfaceLight",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(28, 32, 42),
			Color3.fromRGB(42, 38, 58),
			Color3.fromRGB(27, 61, 45),
			Color3.fromRGB(21, 58, 94),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Border Color",
		ApplyToTheme = "Border",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(33, 38, 48),
			Color3.fromRGB(66, 66, 88),
			Color3.fromRGB(42, 88, 65),
			Color3.fromRGB(42, 84, 116),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Text Color",
		ApplyToTheme = "Text",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(240, 246, 252),
			Color3.fromRGB(255, 246, 252),
			Color3.fromRGB(237, 255, 246),
			Color3.fromRGB(231, 245, 255),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Muted Text Color",
		ApplyToTheme = "SubText",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(143, 150, 162),
			Color3.fromRGB(180, 160, 185),
			Color3.fromRGB(143, 186, 162),
			Color3.fromRGB(135, 174, 202),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Slider Track",
		ApplyToTheme = "Track",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(28, 32, 40),
			Color3.fromRGB(56, 58, 66),
			Color3.fromRGB(42, 88, 65),
			Color3.fromRGB(42, 84, 116),
		},
	})

	local Settings = Window:CreateTab("Settings", "S")
	local Status = Settings:CreateSection("Status")
	local ConnectionLabel = Status:Label({
		Text = "Connection: checking...",
		Height = 20,
	})
	local PingLabel = Status:Label({
		Text = "Ping: checking...",
		Height = 20,
	})
	local FpsLabel = Status:Label({
		Text = "FPS: checking...",
		Height = 20,
	})
	local NetworkLabel = Status:Label({
		Text = "Network: checking...",
		Height = 20,
	})

	local function ReadStatsItem(Name)
		local Display = "N/A"
		local Value

		pcall(function()
			local Network = Stats:FindFirstChild("Network")
			local ServerStatsItem = Network and Network:FindFirstChild("ServerStatsItem")
			local Item = ServerStatsItem and ServerStatsItem:FindFirstChild(Name)
			if Item then
				Display = Item:GetValueString()
				Value = Item:GetValue()
			end
		end)

		return Display, Value
	end

	local function ReadDataRate(Property)
		local Value = 0
		pcall(function()
			Value = Stats[Property] or 0
		end)
		if typeof(Value) ~= "number" then
			Value = 0
		end
		return Value
	end

	local StatusTimer = 0
	local StatusConnection
	StatusConnection = RunService.RenderStepped:Connect(function(DeltaTime)
		if not Window.Gui or not Window.Gui.Parent then
			if StatusConnection then
				StatusConnection:Disconnect()
			end
			return
		end

		StatusTimer += DeltaTime
		if StatusTimer < 0.65 then
			return
		end
		StatusTimer = 0

		local FrameTime = DeltaTime
		pcall(function()
			if Stats.FrameTime and Stats.FrameTime > 0 then
				FrameTime = Stats.FrameTime
			end
		end)

		local Fps = FrameTime > 0 and math.floor((1 / FrameTime) + 0.5) or 0
		local PingText, PingValue = ReadStatsItem("Data Ping")
		local Receive = ReadDataRate("DataReceiveKbps")
		local Send = ReadDataRate("DataSendKbps")
		local ConnectionText = "Online"

		if PingValue and PingValue <= 80 then
			ConnectionText = "Good"
		elseif PingValue and PingValue <= 180 then
			ConnectionText = "Stable"
		elseif PingValue then
			ConnectionText = "High ping"
		elseif Receive <= 0 and Send <= 0 then
			ConnectionText = "Waiting for data"
		end

		ConnectionLabel:Set("Connection: " .. ConnectionText)
		PingLabel:Set("Ping: " .. PingText)
		FpsLabel:Set("FPS: " .. tostring(Fps))
		NetworkLabel:Set(("Network: %.1f in / %.1f out kbps"):format(Receive, Send))
	end)

	local Menu = Settings:CreateSection("Menu")

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

	local Search = Settings:CreateSection("Feature Search")
	local SearchResults = Search:Label({
		Text = "Type a feature name to search this script.",
	})

	Search:Textbox({
		Placeholder = "Search tabs and features...",
		Live = true,
		Changed = function(Text)
			local Query = string.lower(Text or "")
			if Query == "" then
				SearchResults:Set("Type a feature name to search this script.")
				return
			end

			local Matches = {}
			for _, Feature in ipairs(FeatureIndex) do
				if string.find(string.lower(Feature), Query, 1, true) then
					table.insert(Matches, Feature)
				end
			end

			if #Matches == 0 then
				SearchResults:Set("No matches for: " .. Text)
			else
				SearchResults:Set("Found: " .. table.concat(Matches, " | "))
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
