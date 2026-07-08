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

	local function ResolveLogoImage()
		if typeof(writefile) ~= "function" or typeof(getcustomasset) ~= "function" then
			return nil
		end

		local FileName = "LocitoHubLogo.png"
		local LogoUrl = "https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/Assets/locito-hub-logo.png?v=" .. CacheBust
		local Downloaded, Body = pcall(function()
			return game:HttpGet(LogoUrl)
		end)

		if not Downloaded or typeof(Body) ~= "string" or #Body < 100 then
			return nil
		end

		local Wrote = pcall(function()
			writefile(FileName, Body)
		end)
		if not Wrote then
			return nil
		end

		local Loaded, Asset = pcall(function()
			return getcustomasset(FileName)
		end)

		if Loaded and typeof(Asset) == "string" and Asset ~= "" then
			return Asset
		end

		return nil
	end

	local LogoImage = ResolveLogoImage()

	local Existing = Parent:FindFirstChild("LocitoUI")
	if Existing then
		Existing:Destroy()
	end

	local Window = LocitoUI.new({
		Name = "Locito Hub",
		TitleAccent = "Hub",
		Version = "v2.0",
		Subtitle = false,
		LogoText = LogoImage and "" or "L",
		LogoImage = LogoImage,
		Theme = "Noir",
		Layout = "Preview",
		Parent = Parent,
		Width = 700,
		Height = 462,
		SidebarWidth = 160,
		TopBarHeight = 54,
		TabHeight = 40,
		TabStyle = "Pill",
		TabSelectedTransparency = 0.12,
		TabHoverTransparency = 0.34,
		PageSlideOffset = 8,
		BorderThickness = 1,
		RowStrokeTransparency = 0.82,
		SectionAnimation = true,
		SidebarDividerTransparency = 0.76,
		AccentLineThemeKey = "Border",
		AccentLineTransparency = 0.68,
		LogoGlow = false,
		ControlTransparency = 1,
		BackgroundLogo = true,
		BackgroundLogoText = LogoImage and "" or "LC",
		BackgroundLogoImage = LogoImage,
		BackgroundLogoImageSize = UDim2.new(1.46, 0, 1.46, 0),
		BackgroundLogoImageTransparency = LogoImage and 0.42 or 1,
		BackgroundLogoName = "Locito",
		BackgroundLogoSize = 190,
		BackgroundLogoPosition = UDim2.new(0.66, 0, 0.56, 0),
		BackgroundLogoShape = "Orbit",
		BackgroundLogoMaterial = "Noir",
		BackgroundLogoIntensity = 0.75,
		BackgroundLogoTransparency = 0.78,
		BackgroundLogoGlowTransparency = 0.99,
		BackgroundLogoRingTransparency = 0.88,
		BackgroundLogoTextTransparency = 0.86,
		BackgroundLogoTextStrokeTransparency = 0.94,
		BackgroundLogoRotationSpeed = 24,
		BackgroundSwordPosition = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundSwordSize = UDim2.new(0.62, 0, 0.9, 0),
		BackgroundSwordRotation = 0,
		BackgroundSwordTransparency = 0.42,
		OuterSword = true,
		OuterSwordSpeed = 42,
		OuterSwordRadiusX = 430,
		OuterSwordRadiusY = 296,
		OuterSwordSize = UDim2.new(0, 72, 0, 146),
		Shadow = true,
		ShadowTransparency = 0.74,
		ShadowPadding = 16,
		ToggleKey = "RightControl",
		ToggleAnimationTime = 0.18,
		DisplayOrder = 999999,
		Animate = true,
	})

	local FeatureIndex = {
		"Aimbot: Enabled",
		"Aimbot: Team Check",
		"Aimbot: FOV",
		"Aimbot: Smoothness",
		"Aimbot: Aim Part",
		"Rage: Silent Aim",
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
		"Player: Fly",
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
		"Theme: Background Shape",
		"Theme: Background Material",
		"Theme: Animation Speed",
		"Theme: Pulse Intensity",
		"Theme: See Through",
		"Theme: Logo Color",
		"Theme: Glow Color",
		"Theme: Stone Color",
		"Theme: Outside Sword",
		"Theme: Sword Orbit Speed",
		"Theme: Sword Orbit Width",
		"Theme: Sword Orbit Height",
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
		Text = "Aimbot",
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
	local RageMain = Rage:CreateSection("Rage Config")

	RageMain:Toggle({
		Text = "Silent Aim",
		Default = false,
	})

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
		Text = "Fly",
		Default = false,
	})

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
		Options = { "Noir", "Phantom", "Nebula", "Carbon", "Ocean", "Emerald" },
		Default = "Noir",
		Changed = function(Name)
			LocitoUI:SetTheme(Name)
			if Name == "Noir" then
				Window:SetBackgroundAnimation({ Material = "Noir" })
			end
		end,
	})

	ThemeSession:ColorPicker({
		Text = "Accent Color",
		ApplyToTheme = true,
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(210, 210, 220),
			Color3.fromRGB(0, 218, 222),
			Color3.fromRGB(255, 86, 146),
			Color3.fromRGB(136, 92, 255),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Accent Glow",
		ApplyToTheme = "AccentLight",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(185, 185, 194),
			Color3.fromRGB(84, 255, 255),
			Color3.fromRGB(255, 160, 205),
			Color3.fromRGB(190, 164, 255),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Background Color",
		ApplyToTheme = "Background",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(3, 3, 5),
			Color3.fromRGB(0, 0, 0),
			Color3.fromRGB(12, 12, 14),
			Color3.fromRGB(245, 245, 245),
			Color3.fromRGB(8, 10, 14),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Panel Color",
		ApplyToTheme = "Surface",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(13, 13, 16),
			Color3.fromRGB(20, 20, 24),
			Color3.fromRGB(245, 245, 245),
			Color3.fromRGB(16, 19, 25),
			Color3.fromRGB(27, 27, 42),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Panel Highlight",
		ApplyToTheme = "SurfaceLight",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(28, 28, 32),
			Color3.fromRGB(42, 42, 48),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(28, 32, 42),
			Color3.fromRGB(42, 38, 58),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Border Color",
		ApplyToTheme = "Border",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(236, 236, 242),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(82, 82, 90),
			Color3.fromRGB(0, 0, 0),
			Color3.fromRGB(33, 38, 48),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Text Color",
		ApplyToTheme = "Text",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(230, 230, 236),
			Color3.fromRGB(20, 20, 24),
			Color3.fromRGB(240, 246, 252),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Muted Text Color",
		ApplyToTheme = "SubText",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(184, 184, 190),
			Color3.fromRGB(130, 130, 140),
			Color3.fromRGB(82, 82, 90),
			Color3.fromRGB(143, 150, 162),
		},
	})

	ThemeSession:ColorPicker({
		Text = "Slider Track",
		ApplyToTheme = "Track",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(48, 48, 54),
			Color3.fromRGB(82, 82, 90),
			Color3.fromRGB(20, 20, 24),
			Color3.fromRGB(28, 32, 40),
		},
	})

	local AnimationStyle = ThemeTab:CreateSection("Background Animation")

	AnimationStyle:Dropdown({
		Text = "Shape",
		Options = { "Sword", "Diamond", "Orbit", "Hex", "Cross", "Shatter" },
		Default = "Orbit",
		Changed = function(Shape)
			Window:SetBackgroundLogoShape(Shape)
		end,
	})

	AnimationStyle:Dropdown({
		Text = "Material",
		Options = { "Noir", "Neon", "Glass", "Ghost", "Chrome", "Wood" },
		Default = "Noir",
		Changed = function(Material)
			Window:SetBackgroundLogoMaterial(Material)
		end,
	})

	AnimationStyle:Slider({
		Text = "Animation Speed",
		Min = 0,
		Max = 80,
		Default = 24,
		Step = 2,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ Speed = Value })
		end,
	})

	AnimationStyle:Slider({
		Text = "Pulse Intensity",
		Min = 0,
		Max = 2,
		Default = 0.75,
		Step = 0.05,
		Decimals = 2,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ Intensity = Value })
		end,
	})

	AnimationStyle:Slider({
		Text = "See Through",
		Min = 0.16,
		Max = 0.9,
		Default = 0.78,
		Step = 0.02,
		Decimals = 2,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ Transparency = Value })
		end,
	})

	AnimationStyle:ColorPicker({
		Text = "Logo Color",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(0, 255, 255),
			Color3.fromRGB(255, 0, 128),
			Color3.fromRGB(214, 170, 104),
		},
		Changed = function(Color)
			Window:SetBackgroundAnimation({ PrimaryColor = Color })
		end,
	})

	AnimationStyle:ColorPicker({
		Text = "Glow Color",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(18, 18, 22),
			Color3.fromRGB(84, 255, 255),
			Color3.fromRGB(255, 160, 205),
			Color3.fromRGB(104, 70, 38),
		},
		Changed = function(Color)
			Window:SetBackgroundAnimation({ SecondaryColor = Color })
		end,
	})

	AnimationStyle:ColorPicker({
		Text = "Stone Color",
		CloseOnSelect = true,
		Presets = {
			Color3.fromRGB(8, 8, 10),
			Color3.fromRGB(28, 28, 32),
			Color3.fromRGB(61, 42, 27),
			Color3.fromRGB(255, 255, 255),
		},
		Changed = function(Color)
			Window:SetBackgroundAnimation({ StoneColor = Color })
		end,
	})

	local SwordOrbit = ThemeTab:CreateSection("Outside Sword")

	SwordOrbit:Toggle({
		Text = "Outside Sword",
		Default = true,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ OuterSword = Value })
		end,
	})

	SwordOrbit:Slider({
		Text = "Orbit Speed",
		Min = 0,
		Max = 120,
		Default = 42,
		Step = 2,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ OuterSwordSpeed = Value })
		end,
	})

	SwordOrbit:Slider({
		Text = "Orbit Width",
		Min = 360,
		Max = 560,
		Default = 430,
		Step = 10,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ OuterSwordRadiusX = Value })
		end,
	})

	SwordOrbit:Slider({
		Text = "Orbit Height",
		Min = 240,
		Max = 360,
		Default = 296,
		Step = 8,
		Changed = function(Value)
			Window:SetBackgroundAnimation({ OuterSwordRadiusY = Value })
		end,
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
			Window:SetBackgroundAnimation({ OuterSword = Value })
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
