-- LocitoUI Standalone Bundle
-- Version 0.2.0
-- Generated from src modules by tools/build_standalone.py.
-- Use this file with loadstring/game:HttpGet when a ModuleScript tree is not available.

if typeof(game) ~= "Instance" then
	error("LocitoUI must run inside Roblox")
end

-- src/Utility.lua
-- LocitoUI Utility System
-- Version 0.2.0

local Utility = {}

local UserInputService = game:GetService("UserInputService")

function Utility:GetService(ServiceName)
	return game:GetService(ServiceName)
end

function Utility:Create(ClassName, Properties, Children)
	local Object = Instance.new(ClassName)
	local Parent = Properties and Properties.Parent

	for Property, Value in pairs(Properties or {}) do
		if Property ~= "Parent" then
			Object[Property] = Value
		end
	end

	for _, Child in ipairs(Children or {}) do
		Child.Parent = Object
	end

	if Parent ~= nil then
		Object.Parent = Parent
	end

	return Object
end

function Utility:Round(Object, Radius)
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, Radius or 12)
	Corner.Parent = Object
	return Corner
end

function Utility:Stroke(Object, Color, Thickness, Transparency)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color or Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = Thickness or 1
	Stroke.Transparency = Transparency or 0
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = Object
	return Stroke
end

function Utility:Padding(Object, Amount)
	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, Amount or 0)
	Padding.PaddingBottom = UDim.new(0, Amount or 0)
	Padding.PaddingLeft = UDim.new(0, Amount or 0)
	Padding.PaddingRight = UDim.new(0, Amount or 0)
	Padding.Parent = Object
	return Padding
end

function Utility:List(Object, Padding, Direction)
	local Layout = Instance.new("UIListLayout")
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, Padding or 6)
	Layout.FillDirection = Direction or Enum.FillDirection.Vertical
	Layout.Parent = Object
	return Layout
end

function Utility:SafeCall(Callback, ...)
	if typeof(Callback) ~= "function" then
		return
	end

	local Success, Result = pcall(Callback, ...)
	if not Success then
		warn("[LocitoUI] Callback error:", Result)
	end
	return Result
end

function Utility:Callback(Callback, ...)
	return self:SafeCall(Callback, ...)
end

function Utility:Destroy(Object)
	if Object and Object.Destroy then
		Object:Destroy()
	end
end

function Utility:MakeDraggable(Handle, Target, OnMove)
	local Dragging = false
	local DragStart
	local StartPosition
	local Connections = {}

	table.insert(Connections, Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Target.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end))

	table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then return end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local Delta = Input.Position - DragStart
		Target.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)

		if OnMove then
			OnMove(Target.Position)
		end
	end))

	return function()
		for _, Connection in ipairs(Connections) do
			Connection:Disconnect()
		end
	end
end

function Utility:AutoCanvas(ScrollingFrame, Layout, Extra)
	local function Update()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + (Extra or 12))
	end

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Update)
	Update()
end

-- src/Theme.lua
-- LocitoUI Theme System
-- Version 0.2.0

local Theme = {}

Theme.Current = "Nebula"
Theme.Registry = {}
Theme.Listeners = {}

Theme.Themes = {
	Nebula = {
		Background = Color3.fromRGB(11, 11, 18),
		Secondary = Color3.fromRGB(18, 18, 28),
		Surface = Color3.fromRGB(27, 27, 42),
		SurfaceLight = Color3.fromRGB(35, 35, 54),
		Accent = Color3.fromRGB(155, 90, 255),
		AccentLight = Color3.fromRGB(198, 158, 255),
		Text = Color3.fromRGB(245, 245, 255),
		SubText = Color3.fromRGB(164, 164, 180),
		Muted = Color3.fromRGB(90, 90, 108),
		Border = Color3.fromRGB(66, 66, 88),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(72, 210, 118),
		Warning = Color3.fromRGB(255, 186, 73),
		Error = Color3.fromRGB(255, 83, 83),
		CornerRadius = 12,
		AnimationSpeed = 0.22,
	},

	Carbon = {
		Background = Color3.fromRGB(9, 10, 12),
		Secondary = Color3.fromRGB(18, 19, 23),
		Surface = Color3.fromRGB(27, 29, 35),
		SurfaceLight = Color3.fromRGB(38, 41, 49),
		Accent = Color3.fromRGB(255, 78, 95),
		AccentLight = Color3.fromRGB(255, 142, 153),
		Text = Color3.fromRGB(248, 248, 248),
		SubText = Color3.fromRGB(160, 160, 166),
		Muted = Color3.fromRGB(86, 86, 92),
		Border = Color3.fromRGB(56, 58, 66),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(72, 210, 118),
		Warning = Color3.fromRGB(255, 186, 73),
		Error = Color3.fromRGB(255, 83, 83),
		CornerRadius = 12,
		AnimationSpeed = 0.22,
	},

	Ocean = {
		Background = Color3.fromRGB(7, 18, 31),
		Secondary = Color3.fromRGB(10, 29, 49),
		Surface = Color3.fromRGB(16, 43, 70),
		SurfaceLight = Color3.fromRGB(21, 58, 94),
		Accent = Color3.fromRGB(0, 157, 255),
		AccentLight = Color3.fromRGB(104, 203, 255),
		Text = Color3.fromRGB(231, 245, 255),
		SubText = Color3.fromRGB(135, 174, 202),
		Muted = Color3.fromRGB(72, 105, 130),
		Border = Color3.fromRGB(42, 84, 116),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(72, 210, 118),
		Warning = Color3.fromRGB(255, 186, 73),
		Error = Color3.fromRGB(255, 83, 83),
		CornerRadius = 12,
		AnimationSpeed = 0.22,
	},

	Emerald = {
		Background = Color3.fromRGB(8, 18, 14),
		Secondary = Color3.fromRGB(13, 29, 22),
		Surface = Color3.fromRGB(20, 44, 33),
		SurfaceLight = Color3.fromRGB(27, 61, 45),
		Accent = Color3.fromRGB(39, 212, 121),
		AccentLight = Color3.fromRGB(135, 241, 183),
		Text = Color3.fromRGB(237, 255, 246),
		SubText = Color3.fromRGB(143, 186, 162),
		Muted = Color3.fromRGB(76, 110, 91),
		Border = Color3.fromRGB(42, 88, 65),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(72, 210, 118),
		Warning = Color3.fromRGB(255, 186, 73),
		Error = Color3.fromRGB(255, 83, 83),
		CornerRadius = 12,
		AnimationSpeed = 0.22,
	},

	Phantom = {
		Background = Color3.fromRGB(7, 8, 12),
		Secondary = Color3.fromRGB(12, 14, 20),
		Surface = Color3.fromRGB(17, 20, 29),
		SurfaceLight = Color3.fromRGB(25, 30, 42),
		Accent = Color3.fromRGB(96, 165, 250),
		AccentLight = Color3.fromRGB(147, 197, 253),
		Text = Color3.fromRGB(241, 245, 249),
		SubText = Color3.fromRGB(148, 163, 184),
		Muted = Color3.fromRGB(71, 85, 105),
		Border = Color3.fromRGB(31, 41, 55),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(52, 211, 153),
		Warning = Color3.fromRGB(251, 191, 36),
		Error = Color3.fromRGB(248, 113, 113),
		CornerRadius = 10,
		AnimationSpeed = 0.18,
	},
}

function Theme:Get()
	return self.Themes[self.Current] or self.Themes.Nebula
end

function Theme:GetTheme(Name)
	return self.Themes[Name]
end

function Theme:GetThemes()
	local Names = {}
	for Name in pairs(self.Themes) do
		table.insert(Names, Name)
	end
	table.sort(Names)
	return Names
end

function Theme:_Copy(Source)
	local Result = {}
	for Key, Value in pairs(Source or {}) do
		Result[Key] = Value
	end
	return Result
end

function Theme:Add(Name, Values, BaseName)
	if typeof(Name) ~= "string" or Name == "" or typeof(Values) ~= "table" then
		return false
	end

	local Base = self.Themes[BaseName] or self:Get()
	local NewTheme = self:_Copy(Base)
	for Key, Value in pairs(Values) do
		NewTheme[Key] = Value
	end

	self.Themes[Name] = NewTheme
	return true
end

function Theme:Set(Name)
	if not self.Themes[Name] then
		return false
	end

	self.Current = Name
	self:Apply()

	for _, Listener in ipairs(self.Listeners) do
		task.spawn(Listener, self:Get(), Name)
	end

	return true
end

function Theme:SetAccent(Color, AccentLight)
	local Current = self:Get()
	Current.Accent = Color
	Current.AccentLight = AccentLight or Color
	self:Apply()

	for _, Listener in ipairs(self.Listeners) do
		task.spawn(Listener, Current, self.Current)
	end

	return true
end

function Theme:Register(Object, Property, ThemeKey)
	if not Object then return end
	table.insert(self.Registry, {
		Object = Object,
		Property = Property,
		ThemeKey = ThemeKey,
	})

	local Current = self:Get()
	if Current[ThemeKey] ~= nil then
		Object[Property] = Current[ThemeKey]
	end
end

function Theme:Apply()
	local Current = self:Get()
	for Index = #self.Registry, 1, -1 do
		local Entry = self.Registry[Index]
		if not Entry.Object or not Entry.Object.Parent then
			table.remove(self.Registry, Index)
		else
			local Value = Current[Entry.ThemeKey]
			if Value ~= nil then
				Entry.Object[Entry.Property] = Value
			end
		end
	end
end

function Theme:OnChanged(Callback)
	table.insert(self.Listeners, Callback)
	return function()
		local Found = table.find(self.Listeners, Callback)
		if Found then
			table.remove(self.Listeners, Found)
		end
	end
end

-- src/Animation.lua
-- LocitoUI Animation System
-- Version 0.2.0

local Animation = {}
local TweenService = game:GetService("TweenService")

Animation.Default = {
	Time = 0.22,
	Style = Enum.EasingStyle.Quint,
	Direction = Enum.EasingDirection.Out,
}

function Animation:Create(Object, Properties, Settings)
	Settings = Settings or {}

	local Tween = TweenService:Create(
		Object,
		TweenInfo.new(
			Settings.Time or self.Default.Time,
			Settings.Style or self.Default.Style,
			Settings.Direction or self.Default.Direction
		),
		Properties
	)

	return Tween
end

function Animation:Play(Object, Properties, Settings)
	local Tween = self:Create(Object, Properties, Settings)
	Tween:Play()
	return Tween
end

function Animation:Pop(Object)
	local Original = Object.Size
	self:Play(Object, { Size = Original + UDim2.new(0, 4, 0, 4) }, { Time = 0.08 })
	task.delay(0.08, function()
		if Object and Object.Parent then
			self:Play(Object, { Size = Original }, { Time = 0.12 })
		end
	end)
end

function Animation:FadeObject(Object, Transparency, Time)
	local Props = {}

	if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
		Props.TextTransparency = Transparency
	end

	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		Props.ImageTransparency = Transparency
	end

	if Object:IsA("GuiObject") then
		Props.BackgroundTransparency = Transparency
	end

	return self:Play(Object, Props, { Time = Time or self.Default.Time })
end

-- src/Config.lua
-- LocitoUI Config System
-- Version 0.2.0
-- This is intentionally storage-agnostic. It does not use exploit-only filesystem APIs.

local Config = {}
Config.Store = {}

function Config:Save(Name, Data)
	self.Store[Name] = Data
	return true
end

function Config:Load(Name)
	return self.Store[Name]
end

function Config:Delete(Name)
	self.Store[Name] = nil
	return true
end

function Config:List()
	local Names = {}
	for Name in pairs(self.Store) do
		table.insert(Names, Name)
	end
	table.sort(Names)
	return Names
end

-- src/Notification.lua
-- LocitoUI Notification System
-- Version 0.2.0

local Notification = {}


function Notification.new(Window, Options)
	Options = Options or {}

	local CurrentTheme = Theme:Get()
	local Kind = Options.Kind or Options.Type or "Info"
	local Accent = CurrentTheme.Accent

	if Kind == "Success" then Accent = CurrentTheme.Success end
	if Kind == "Warning" then Accent = CurrentTheme.Warning end
	if Kind == "Error" then Accent = CurrentTheme.Error end

	local Card = Utility:Create("Frame", {
		Name = "Notification",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = CurrentTheme.Secondary,
		ClipsDescendants = true,
		Parent = Window.NotificationHolder,
	})
	Utility:Round(Card, 10)
	local Stroke = Utility:Stroke(Card, CurrentTheme.Border, 1)
	Theme:Register(Card, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	Utility:Create("Frame", {
		Name = "Accent",
		Size = UDim2.new(0, 4, 1, 0),
		BackgroundColor3 = Accent,
		BorderSizePixel = 0,
		Parent = Card,
	})

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 8),
		Size = UDim2.new(1, -24, 0, 18),
		Font = Enum.Font.GothamBold,
		Text = Options.Title or "LocitoUI",
		TextColor3 = CurrentTheme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Card,
	})
	Theme:Register(Title, "TextColor3", "Text")

	local Body = Utility:Create("TextLabel", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 28),
		Size = UDim2.new(1, -24, 0, 34),
		Font = Enum.Font.Gotham,
		Text = Options.Message or "Notification message",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Card,
	})
	Theme:Register(Body, "TextColor3", "SubText")

	local Progress = Utility:Create("Frame", {
		Name = "Progress",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 4, 1, 0),
		Size = UDim2.new(1, -4, 0, 3),
		BackgroundColor3 = Accent,
		BorderSizePixel = 0,
		Parent = Card,
	})

	Animation:Play(Card, { Size = UDim2.new(1, 0, 0, 72) }, { Time = 0.25 })
	Animation:Play(Progress, { Size = UDim2.new(0, 0, 0, 3) }, { Time = Options.Duration or 4, Style = Enum.EasingStyle.Linear })

	task.delay(Options.Duration or 4, function()
		if not Card or not Card.Parent then return end
		Animation:Play(Card, { Size = UDim2.new(1, 0, 0, 0) }, { Time = 0.2 })
		task.delay(0.22, function()
			if Card and Card.Parent then
				Card:Destroy()
			end
		end)
	end)

	return Card
end

-- src/Components/Button.lua
-- LocitoUI Button Component
-- Version 0.2.0

local Button = {}
Button.__index = Button


function Button.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Button)

	local CurrentTheme = Theme:Get()
	self.Callback = Options.Callback or function() end
	self.Enabled = Options.Enabled ~= false
	local Style = Options.Style or (Options.Accent and "Accent") or "Secondary"
	local BackgroundKey = Style == "Accent" and "Accent" or "Secondary"
	local TextKey = Style == "Accent" and "Text" or "Text"

	local Object = Utility:Create("TextButton", {
		Name = "Button",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 38),
		BackgroundColor3 = Options.BackgroundColor or CurrentTheme[BackgroundKey],
		BorderSizePixel = 0,
		Font = Options.Font or Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Button",
		TextColor3 = Options.TextColor or CurrentTheme[TextKey],
		TextSize = Options.TextSize or 14,
		TextTransparency = self.Enabled and 0 or 0.45,
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Object, Options.Radius or 9)
	local Stroke = Utility:Stroke(Object, CurrentTheme.Border, 1, 0.25)
	if not Options.BackgroundColor then
		Theme:Register(Object, "BackgroundColor3", BackgroundKey)
	end
	if not Options.TextColor then
		Theme:Register(Object, "TextColor3", TextKey)
	end
	Theme:Register(Stroke, "Color", "Border")

	Object.MouseEnter:Connect(function()
		if not self.Enabled then return end
		Animation:Play(Object, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
	end)

	Object.MouseLeave:Connect(function()
		if not self.Enabled then return end
		Animation:Play(Object, { BackgroundColor3 = Options.BackgroundColor or Theme:Get()[BackgroundKey] }, { Time = 0.12 })
	end)

	Object.MouseButton1Click:Connect(function()
		if not self.Enabled then return end
		Animation:Pop(Object)
		Utility:SafeCall(self.Callback)
	end)

	self.Object = Object
	return self
end

function Button:SetText(Text)
	self.Object.Text = Text
end

function Button:SetCallback(Callback)
	self.Callback = Callback
end

function Button:SetEnabled(Enabled)
	self.Enabled = Enabled == true
	self.Object.TextTransparency = self.Enabled and 0 or 0.45
end

function Button:Destroy()
	self.Object:Destroy()
end

-- src/Components/Toggle.lua
-- LocitoUI Toggle Component
-- Version 0.2.0

local Toggle = {}
Toggle.__index = Toggle


function Toggle.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Toggle)

	self.Value = Options.Default == true
	self.Changed = Options.Changed or Options.Callback or function() end

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("TextButton", {
		Name = "Toggle",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -74, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Toggle",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 44, 0, 22),
		BackgroundColor3 = self.Value and CurrentTheme.Accent or CurrentTheme.Border,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = self.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Knob, 99)

	self.Row = Row
	self.Track = Track
	self.Knob = Knob

	function self:Refresh(SkipCallback)
		if not Row.Parent then
			return
		end

		local T = Theme:Get()
		Animation:Play(Track, {
			BackgroundColor3 = self.Value and T.Accent or T.Border,
		}, { Time = 0.14 })

		Animation:Play(Knob, {
			Position = self.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}, { Time = 0.14 })

		if not SkipCallback then
			Utility:SafeCall(self.Changed, self.Value)
		end
	end

	self.ThemeDisconnect = Theme:OnChanged(function()
		self:Refresh(true)
	end)

	Row.MouseButton1Click:Connect(function()
		self.Value = not self.Value
		self:Refresh(false)
	end)

	Row.MouseEnter:Connect(function()
		Animation:Play(Row, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
	end)

	Row.MouseLeave:Connect(function()
		Animation:Play(Row, { BackgroundColor3 = Theme:Get().Secondary }, { Time = 0.12 })
	end)

	return self
end

function Toggle:Set(Value)
	self.Value = Value == true
	self:Refresh(false)
end

function Toggle:Get()
	return self.Value
end

function Toggle:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.ThemeDisconnect then
		self.ThemeDisconnect()
		self.ThemeDisconnect = nil
	end

	if self.Row then
		self.Row:Destroy()
	end
end

-- src/Components/Slider.lua
-- LocitoUI Slider Component
-- Version 0.2.0

local Slider = {}
Slider.__index = Slider

local UserInputService = game:GetService("UserInputService")

function Slider.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Slider)

	local Min = Options.Min or Options.Minimum or 0
	local Max = Options.Max or Options.Maximum or 100
	if Max < Min then
		Min, Max = Max, Min
	end

	self.Min = Min
	self.Max = Max
	self.Value = math.clamp(Options.Default or Options.Value or self.Min, self.Min, self.Max)
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Decimals = Options.Decimals or 0
	self.Step = Options.Step or Options.Increment or 0
	self.Prefix = Options.Prefix or ""
	self.Suffix = Options.Suffix or ""
	self.Format = Options.Format
	self.Range = self.Max - self.Min
	self.Connections = {}

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Slider",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 56),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 6),
		Size = UDim2.new(0.65, -12, 0, 20),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Slider",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 6),
		Size = UDim2.new(0.35, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = tostring(self.Value),
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Row,
	})
	Theme:Register(ValueLabel, "TextColor3", "SubText")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		Position = UDim2.new(0, 12, 0, 36),
		Size = UDim2.new(1, -24, 0, Options.TrackHeight or 8),
		BackgroundColor3 = CurrentTheme.Border,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)
	Theme:Register(Track, "BackgroundColor3", "Border")

	local Fill = Utility:Create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Fill, 99)
	Theme:Register(Fill, "BackgroundColor3", "Accent")

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 16, 0, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Knob, 99)

	self.Row = Row
	self.Track = Track
	self.Fill = Fill
	self.Knob = Knob
	self.ValueLabel = ValueLabel

	local Dragging = false

	local function RoundValue(Value)
		if self.Step > 0 then
			Value = self.Min + math.floor(((Value - self.Min) / self.Step) + 0.5) * self.Step
		end

		local Multiplier = 10 ^ self.Decimals
		return math.floor(Value * Multiplier + 0.5) / Multiplier
	end

	local function FormatValue(Value)
		if typeof(self.Format) == "function" then
			return tostring(self.Format(Value))
		end

		return self.Prefix .. tostring(Value) .. self.Suffix
	end

	function self:UpdateFromRatio(Ratio, SkipCallback)
		Ratio = math.clamp(Ratio, 0, 1)
		self.Value = RoundValue(self.Min + self.Range * Ratio)
		local VisualRatio = self.Range == 0 and 0 or (self.Value - self.Min) / self.Range
		ValueLabel.Text = FormatValue(self.Value)
		Fill.Size = UDim2.new(VisualRatio, 0, 1, 0)
		Knob.Position = UDim2.new(VisualRatio, 0, 0.5, 0)
		if not SkipCallback then
			Utility:SafeCall(self.Changed, self.Value)
		end
	end

	function self:UpdateFromMouse(Input, SkipCallback)
		local Pos = Track.AbsolutePosition.X
		local Size = Track.AbsoluteSize.X
		if Size <= 0 then
			return
		end

		self:UpdateFromRatio((Input.Position.X - Pos) / Size, SkipCallback)
	end

	table.insert(self.Connections, Track.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			self:UpdateFromMouse(Input, false)
		end
	end))

	table.insert(self.Connections, UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			self:UpdateFromMouse(Input, false)
		end
	end))

	table.insert(self.Connections, UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end))

	self:UpdateFromRatio(self.Range == 0 and 0 or (self.Value - self.Min) / self.Range, true)
	return self
end

function Slider:Set(Value)
	Value = math.clamp(tonumber(Value) or self.Min, self.Min, self.Max)
	self:UpdateFromRatio(self.Range == 0 and 0 or (Value - self.Min) / self.Range, false)
end

function Slider:Get()
	return self.Value
end

function Slider:SetBounds(Min, Max)
	if Max < Min then
		Min, Max = Max, Min
	end

	self.Min = Min
	self.Max = Max
	self.Range = self.Max - self.Min
	self:Set(self.Value)
end

function Slider:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	self.Connections = {}
	if self.Row then
		self.Row:Destroy()
	end
end

-- src/Components/Label.lua
-- LocitoUI Label Component
-- Version 0.2.0

local Label = {}
Label.__index = Label


function Label.new(Section, Text)
	local Options = typeof(Text) == "table" and Text or { Text = Text }
	local self = setmetatable({}, Label)
	local CurrentTheme = Theme:Get()

	local Object = Utility:Create("TextLabel", {
		Name = "Label",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or 22),
		BackgroundTransparency = 1,
		Font = Options.Font or Enum.Font.Gotham,
		Text = Options.Text or "Label",
		TextColor3 = Options.TextColor or CurrentTheme.SubText,
		TextSize = Options.TextSize or 13,
		TextXAlignment = Options.Alignment or Options.TextXAlignment or Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = Section.Body,
	})
	if not Options.TextColor then
		Theme:Register(Object, "TextColor3", Options.ThemeKey or "SubText")
	end

	self.Object = Object
	return self
end

function Label:Set(Text)
	self.Object.Text = Text
end

function Label:Get()
	return self.Object.Text
end

function Label:Destroy()
	self.Object:Destroy()
end

-- src/Components/Paragraph.lua
-- LocitoUI Paragraph Component
-- Version 0.2.0

local Paragraph = {}
Paragraph.__index = Paragraph


function Paragraph.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Paragraph)
	local CurrentTheme = Theme:Get()

	local Frame = Utility:Create("Frame", {
		Name = "Paragraph",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Section.Body,
	})
	Utility:List(Frame, 2)

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = Options.Title or "Paragraph",
		TextColor3 = CurrentTheme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	Theme:Register(Title, "TextColor3", "Text")

	local Body = Utility:Create("TextLabel", {
		Name = "Body",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = Options.Body or Options.Content or Options.Text or "Paragraph body",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	Theme:Register(Body, "TextColor3", "SubText")

	self.Frame = Frame
	self.Title = Title
	self.Body = Body
	return self
end

function Paragraph:Set(Title, Body)
	if Title then self.Title.Text = Title end
	if Body then self.Body.Text = Body end
end

function Paragraph:Destroy()
	self.Frame:Destroy()
end

-- src/Components/Divider.lua
-- LocitoUI Divider Component
-- Version 0.2.0

local Divider = {}
Divider.__index = Divider


function Divider.new(Section)
	local self = setmetatable({}, Divider)
	local Object = Utility:Create("Frame", {
		Name = "Divider",
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme:Get().Border,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Theme:Register(Object, "BackgroundColor3", "Border")
	self.Object = Object
	return self
end

function Divider:Destroy()
	self.Object:Destroy()
end

-- src/Components/Textbox.lua
-- LocitoUI Textbox Component
-- Version 0.2.0

local Textbox = {}
Textbox.__index = Textbox


function Textbox.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Textbox)
	self.Value = Options.Default or ""
	self.Changed = Options.Changed or Options.Callback or function() end

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Textbox",
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Box = Utility:Create("TextBox", {
		Name = "Box",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Font = Enum.Font.Gotham,
		Text = self.Value,
		PlaceholderText = Options.Placeholder or Options.Text or "Type here...",
		PlaceholderColor3 = CurrentTheme.Muted,
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		ClearTextOnFocus = Options.ClearTextOnFocus == true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Box, "TextColor3", "Text")
	Theme:Register(Box, "PlaceholderColor3", "Muted")

	Box.Focused:Connect(function()
		Animation:Play(Stroke, { Transparency = 0 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Accent }, { Time = 0.12 })
	end)

	Box.FocusLost:Connect(function(EnterPressed)
		self.Value = Box.Text
		Animation:Play(Stroke, { Transparency = 0.25 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Border }, { Time = 0.12 })
		Utility:SafeCall(self.Changed, self.Value, EnterPressed)
	end)

	self.Row = Row
	self.Box = Box
	return self
end

function Textbox:Set(Value)
	self.Value = Value
	self.Box.Text = Value
end

function Textbox:Get()
	return self.Box.Text
end

function Textbox:Destroy()
	self.Row:Destroy()
end

-- src/Components/Dropdown.lua
-- LocitoUI Dropdown Component
-- Version 0.2.0

local Dropdown = {}
Dropdown.__index = Dropdown


function Dropdown.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Dropdown)

	self.Options = Options.Options or Options.Values or {}
	self.Value = Options.Default or self.Options[1]
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Open = false

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Dropdown",
		Size = UDim2.new(1, 0, 0, 42),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Utility:Padding(Row, 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "",
		AutoButtonColor = false,
		Parent = Row,
	})

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Dropdown",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.Gotham,
		Text = tostring(self.Value or "None") .. "  v",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Header,
	})
	Theme:Register(ValueLabel, "TextColor3", "SubText")

	local OptionsFrame = Utility:Create("Frame", {
		Name = "Options",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Row,
	})
	Utility:List(OptionsFrame, 4)

	self.Row = Row
	self.Header = Header
	self.ValueLabel = ValueLabel
	self.OptionsFrame = OptionsFrame

	function self:Rebuild()
		if not Row.Parent then
			return
		end

		local ActiveTheme = Theme:Get()

		for _, Child in ipairs(OptionsFrame:GetChildren()) do
			if Child:IsA("TextButton") then
				Child:Destroy()
			end
		end

		for _, Option in ipairs(self.Options) do
			local OptionButton = Utility:Create("TextButton", {
				Name = tostring(Option),
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = Option == self.Value and ActiveTheme.SurfaceLight or ActiveTheme.Surface,
				BorderSizePixel = 0,
				Font = Enum.Font.Gotham,
				Text = tostring(Option),
				TextColor3 = ActiveTheme.Text,
				TextSize = 13,
				AutoButtonColor = false,
				Parent = OptionsFrame,
			})
			Utility:Round(OptionButton, 7)
			Theme:Register(OptionButton, "TextColor3", "Text")

			OptionButton.MouseEnter:Connect(function()
				Animation:Play(OptionButton, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.1 })
			end)

			OptionButton.MouseLeave:Connect(function()
				Animation:Play(OptionButton, { BackgroundColor3 = Option == self.Value and Theme:Get().SurfaceLight or Theme:Get().Surface }, { Time = 0.1 })
			end)

			OptionButton.MouseButton1Click:Connect(function()
				self:Set(Option)
				self:Toggle(false)
			end)
		end
	end

	function self:Toggle(Force)
		self.Open = Force ~= nil and Force or not self.Open
		OptionsFrame.Visible = self.Open
		ValueLabel.Text = tostring(self.Value or "None") .. (self.Open and "  ^" or "  v")
	end

	Header.MouseButton1Click:Connect(function()
		self:Toggle()
	end)

	self:Rebuild()
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:Rebuild()
	end)

	return self
end

function Dropdown:Set(Value)
	self.Value = Value
	self.ValueLabel.Text = tostring(Value or "None") .. (self.Open and "  ^" or "  v")
	self:Rebuild()
	Utility:SafeCall(self.Changed, Value)
end

function Dropdown:Get()
	return self.Value
end

function Dropdown:SetOptions(Options)
	self.Options = Options or {}
	self:Rebuild()
end

function Dropdown:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.ThemeDisconnect then
		self.ThemeDisconnect()
		self.ThemeDisconnect = nil
	end

	if self.Row then
		self.Row:Destroy()
	end
end

-- src/Components/Keybind.lua
-- LocitoUI Keybind Component
-- Version 0.2.0

local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")

function Keybind.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, Keybind)

	self.Key = Options.Default or Options.Key or "None"
	self.Callback = Options.Callback or Options.Changed or function() end
	self.Listening = false
	self.Connections = {}

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "Keybind",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -100, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Keybind",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Button = Utility:Create("TextButton", {
		Name = "BindButton",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 78, 0, 26),
		BackgroundColor3 = CurrentTheme.Surface,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		Text = self.Key,
		TextColor3 = CurrentTheme.SubText,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = Row,
	})
	Utility:Round(Button, 7)
	Theme:Register(Button, "BackgroundColor3", "Surface")
	Theme:Register(Button, "TextColor3", "SubText")

	table.insert(self.Connections, Button.MouseButton1Click:Connect(function()
		self.Listening = true
		Button.Text = "..."
		Animation:Play(Button, { BackgroundColor3 = Theme:Get().Accent }, { Time = 0.12 })
	end))

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
		if Processed then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		if self.Listening then
			self.Key = Input.KeyCode.Name
			self.Listening = false
			Button.Text = self.Key
			Animation:Play(Button, { BackgroundColor3 = Theme:Get().Surface }, { Time = 0.12 })
			Utility:SafeCall(self.Callback, self.Key, true)
		elseif Input.KeyCode.Name == self.Key then
			Utility:SafeCall(self.Callback, self.Key, false)
		end
	end))

	self.Row = Row
	self.Button = Button
	return self
end

function Keybind:Set(Key)
	self.Key = Key
	self.Button.Text = Key
end

function Keybind:Get()
	return self.Key
end

function Keybind:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	self.Connections = {}
	if self.Row then
		self.Row:Destroy()
	end
end

-- src/Components/ColorPicker.lua
-- LocitoUI ColorPicker Component
-- Version 0.2.0
-- Simple preset-based picker for v0.2. A full color wheel can be added later.

local ColorPicker = {}
ColorPicker.__index = ColorPicker


local Presets = {
	Color3.fromRGB(155, 90, 255),
	Color3.fromRGB(0, 157, 255),
	Color3.fromRGB(39, 212, 121),
	Color3.fromRGB(255, 78, 95),
	Color3.fromRGB(255, 186, 73),
	Color3.fromRGB(255, 120, 210),
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(40, 40, 48),
}

function ColorPicker.new(Section, Options)
	Options = Options or {}
	local self = setmetatable({}, ColorPicker)
	self.Presets = Options.Presets or Options.Colors or Presets
	if #self.Presets == 0 then
		self.Presets = Presets
	end
	self.Value = Options.Default or self.Presets[1]
	self.Changed = Options.Changed or Options.Callback or function() end
	self.Open = false

	local CurrentTheme = Theme:Get()

	local Row = Utility:Create("Frame", {
		Name = "ColorPicker",
		Size = UDim2.new(1, 0, 0, 42),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, 9)
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, 0.25)
	Utility:Padding(Row, 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = Row,
	})

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -44, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Color",
		TextColor3 = CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Preview = Utility:Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 32, 0, 22),
		BackgroundColor3 = self.Value,
		BorderSizePixel = 0,
		Parent = Header,
	})
	Utility:Round(Preview, 7)
	local PreviewStroke = Utility:Stroke(Preview, CurrentTheme.Border, 1, 0.2)
	Theme:Register(PreviewStroke, "Color", "Border")

	local Palette = Utility:Create("Frame", {
		Name = "Palette",
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Row,
	})
	Utility:List(Palette, 6, Enum.FillDirection.Horizontal)

	for _, Color in ipairs(self.Presets) do
		local Swatch = Utility:Create("TextButton", {
			Size = UDim2.new(0, Options.SwatchSize or 28, 0, Options.SwatchSize or 28),
			BackgroundColor3 = Color,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Parent = Palette,
		})
		Utility:Round(Swatch, 8)
		local SwatchStroke = Utility:Stroke(Swatch, CurrentTheme.Border, 1, 0.2)
		Theme:Register(SwatchStroke, "Color", "Border")

		Swatch.MouseButton1Click:Connect(function()
			self:Set(Color)
			if Options.ApplyToTheme then
				Theme:SetAccent(Color)
			end
			if Options.CloseOnSelect then
				self.Open = false
				Palette.Visible = false
			end
		end)
	end

	Header.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		Palette.Visible = self.Open
	end)

	self.Row = Row
	self.Preview = Preview
	self.Palette = Palette
	return self
end

function ColorPicker:Set(Color)
	self.Value = Color
	self.Preview.BackgroundColor3 = Color
	Utility:SafeCall(self.Changed, Color)
end

function ColorPicker:Get()
	return self.Value
end

function ColorPicker:Destroy()
	self.Row:Destroy()
end

-- src/Components/Section.lua
-- LocitoUI Section System
-- Version 0.2.0

local Section = {}
Section.__index = Section



function Section.new(Tab, Name, Options)
	if typeof(Name) == "table" then
		Options = Name
		Name = Options.Name or Options.Title or "Section"
	end
	Options = Options or {}

	local self = setmetatable({}, Section)
	self.Tab = Tab
	self.Name = Name
	self.Elements = {}

	local CurrentTheme = Theme:Get()

	local Frame = Utility:Create("Frame", {
		Name = Name .. "Section",
		Size = Options.Size or UDim2.new(1, Options.WidthOffset or -6, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Options.Transparency or Options.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		Parent = Tab.Page,
	})
	Utility:Round(Frame, Options.Radius or CurrentTheme.CornerRadius or 12)
	local Stroke = Utility:Stroke(Frame, CurrentTheme.Border, 1, 0.15)
	Utility:Padding(Frame, Options.Padding or 12)
	Theme:Register(Frame, "BackgroundColor3", "Surface")
	Theme:Register(Stroke, "Color", "Border")

	local Layout = Utility:List(Frame, Options.Spacing or 8)

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Options.TitleHeight or 20),
		Visible = Options.ShowTitle ~= false,
		Font = Options.TitleFont or Enum.Font.GothamBold,
		Text = Name,
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TitleSize or 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	Theme:Register(Title, "TextColor3", "Text")

	local Body = Utility:Create("Frame", {
		Name = "Body",
		LayoutOrder = Options.ShowTitle == false and 1 or 2,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Frame,
	})
	local BodyLayout = Utility:List(Body, Options.ItemSpacing or Options.Spacing or 8)

	self.Frame = Frame
	self.Body = Body
	self.Layout = Layout
	self.BodyLayout = BodyLayout

	return self
end

function Section:_Track(Element)
	table.insert(self.Elements, Element)
	return Element
end

function Section:Button(Options)
	return self:_Track(Button.new(self, Options))
end

function Section:Toggle(Options)
	return self:_Track(Toggle.new(self, Options))
end

function Section:Slider(Options)
	return self:_Track(Slider.new(self, Options))
end

function Section:Label(Text)
	return self:_Track(Label.new(self, Text))
end

function Section:Paragraph(Options)
	return self:_Track(Paragraph.new(self, Options))
end

function Section:Divider()
	return self:_Track(Divider.new(self))
end

function Section:Textbox(Options)
	return self:_Track(Textbox.new(self, Options))
end

function Section:Dropdown(Options)
	return self:_Track(Dropdown.new(self, Options))
end

function Section:Keybind(Options)
	return self:_Track(Keybind.new(self, Options))
end

function Section:ColorPicker(Options)
	return self:_Track(ColorPicker.new(self, Options))
end

function Section:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Element in ipairs(self.Elements) do
		if Element.Destroy then
			Element:Destroy()
		end
	end
	self.Elements = {}

	if self.Frame then
		self.Frame:Destroy()
	end
end

-- src/Components/Tab.lua
-- LocitoUI Tab System
-- Version 0.2.0

local Tab = {}
Tab.__index = Tab


function Tab.new(Window, Name, Icon)
	local self = setmetatable({}, Tab)
	self.Window = Window
	self.Name = Name
	self.Icon = Icon
	self.Sections = {}

	local CurrentTheme = Theme:Get()
	local Settings = Window.Settings or {}
	local TabHeight = Settings.TabHeight or 38
	local TabRadius = Settings.TabRadius or 9
	local TabTextInset = Settings.TabTextInset or 12
	local IndicatorWidth = Settings.TabIndicatorWidth or 3
	local IndicatorHeight = Settings.TabIndicatorHeight or 22

	local Button = Utility:Create("TextButton", {
		Name = Name .. "Tab",
		Size = UDim2.new(1, 0, 0, TabHeight),
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Window.SidebarList,
	})
	Utility:Round(Button, TabRadius)
	Theme:Register(Button, "BackgroundColor3", "Surface")

	local Indicator = Utility:Create("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, IndicatorWidth, 0, 0),
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Button,
	})
	Utility:Round(Indicator, 99)
	Theme:Register(Indicator, "BackgroundColor3", "Accent")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TabTextInset, 0, 0),
		Size = UDim2.new(1, -TabTextInset - 4, 1, 0),
		Font = Settings.TabFont or Enum.Font.GothamMedium,
		Text = (Icon and (Icon .. "  ") or "") .. Name,
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.TabTextSize or 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Button,
	})

	local Page = Utility:Create("ScrollingFrame", {
		Name = Name .. "Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,
		Parent = Window.Content,
	})
	Theme:Register(Page, "ScrollBarImageColor3", "Accent")
	Utility:Padding(Page, 10)
	local Layout = Utility:List(Page, 10)
	Utility:AutoCanvas(Page, Layout, 22)

	self.Button = Button
	self.Indicator = Indicator
	self.Label = Label
	self.Page = Page
	self.Layout = Layout
	self.IndicatorWidth = IndicatorWidth
	self.IndicatorHeight = IndicatorHeight
	self.SelectedTransparency = Settings.TabSelectedTransparency or 0
	self.HoverTransparency = Settings.TabHoverTransparency or 0.55
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:_SetSelected(Window.ActiveTab == self)
	end)

	Button.MouseButton1Click:Connect(function()
		Window:_SelectTab(self)
	end)

	Button.MouseEnter:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = self.HoverTransparency }, { Time = 0.12 })
	end)

	Button.MouseLeave:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, { BackgroundTransparency = 1 }, { Time = 0.12 })
	end)

	return self
end

function Tab:_SetSelected(IsSelected)
	if not self.Page or not self.Page.Parent then
		return
	end

	self.Page.Visible = IsSelected

	if IsSelected then
		Animation:Play(self.Button, { BackgroundTransparency = self.SelectedTransparency }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, self.IndicatorHeight) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().Text }, { Time = 0.15 })
	else
		Animation:Play(self.Button, { BackgroundTransparency = 1 }, { Time = 0.15 })
		Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, 0) }, { Time = 0.15 })
		Animation:Play(self.Label, { TextColor3 = Theme:Get().SubText }, { Time = 0.15 })
	end
end

function Tab:CreateSection(Name, Options)
	local NewSection = Section.new(self, Name, Options)
	table.insert(self.Sections, NewSection)
	return NewSection
end

Tab.Section = Tab.CreateSection

function Tab:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.ThemeDisconnect then
		self.ThemeDisconnect()
		self.ThemeDisconnect = nil
	end

	for _, SectionObject in ipairs(self.Sections) do
		if SectionObject.Destroy then
			SectionObject:Destroy()
		end
	end
	self.Sections = {}

	if self.Button then
		self.Button:Destroy()
	end

	if self.Page then
		self.Page:Destroy()
	end
end

-- src/Window.lua
-- LocitoUI Window System
-- Version 0.2.0

local Window = {}
Window.__index = Window

local Players = game:GetService("Players")


function Window.new(Settings)
	Settings = Settings or {}

	if Settings.CustomTheme then
		local ThemeName = Settings.Theme or Settings.ThemeName or "Custom"
		Theme:Add(ThemeName, Settings.CustomTheme, Settings.BaseTheme)
		Theme:Set(ThemeName)
	elseif Settings.Theme then
		Theme:Set(Settings.Theme)
	end

	local self = setmetatable({}, Window)
	self.Settings = Settings
	self.Tabs = {}
	self.ActiveTab = nil
	self.Visible = true

	local CurrentTheme = Theme:Get()
	local Player = Players.LocalPlayer
	local ParentGui = Settings.Parent or (Player and Player:WaitForChild("PlayerGui"))
	local WindowSize = Settings.Size or UDim2.new(0, Settings.Width or 680, 0, Settings.Height or 450)
	local TopBarHeight = Settings.TopBarHeight or Settings.TopbarHeight or 56
	local OuterPadding = Settings.Padding or 14
	local Gap = Settings.Gap or 14
	local ContentGap = Settings.ContentGap or 10
	local SidebarWidth = Settings.SidebarWidth or 160
	local HasSidebar = Settings.Sidebar ~= false
	local ContentX = HasSidebar and (OuterPadding + SidebarWidth + Gap) or OuterPadding
	local ContentTop = TopBarHeight + ContentGap
	local ContentWidthOffset = HasSidebar and -(OuterPadding * 2 + SidebarWidth + Gap) or -(OuterPadding * 2)
	local ContentHeightOffset = -(ContentTop + OuterPadding)
	local ShowControls = Settings.Controls ~= false
	local ShowClose = ShowControls and Settings.CloseButton ~= false
	local ShowMinimize = ShowControls and Settings.MinimizeButton ~= false
	local ControlReserve = ShowControls and 90 or 16
	local TitleX = Settings.Logo == false and OuterPadding or (OuterPadding + 42)
	local MainAnchor = Settings.AnchorPoint or Vector2.new(0.5, 0.5)
	local MainPosition = Settings.Position or UDim2.new(0.5, 0, 0.5, 0)
	local Radius = Settings.Radius or CurrentTheme.CornerRadius

	local Gui = Utility:Create("ScreenGui", {
		Name = Settings.GuiName or "LocitoUI",
		Enabled = true,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = Settings.DisplayOrder or 999999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = ParentGui,
	})
	self.Gui = Gui

	local Shadow
	if Settings.Shadow ~= false then
		Shadow = Utility:Create("Frame", {
			Name = "Shadow",
			AnchorPoint = MainAnchor,
			Position = Settings.ShadowPosition or MainPosition,
			Size = Settings.ShadowSize or (WindowSize + UDim2.new(0, 22, 0, 22)),
			BackgroundColor3 = CurrentTheme.Shadow or Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = Settings.ShadowTransparency or 0.48,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Gui,
		})
		Utility:Round(Shadow, Radius + 8)
		Theme:Register(Shadow, "BackgroundColor3", "Shadow")
	end
	self.Shadow = Shadow

	local Main = Utility:Create("Frame", {
		Name = "MainWindow",
		AnchorPoint = MainAnchor,
		Position = MainPosition,
		Size = WindowSize,
		BackgroundColor3 = CurrentTheme.Background,
		BackgroundTransparency = Settings.Transparency or Settings.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = Gui,
	})
	Utility:Round(Main, Radius)
	local MainStroke = Utility:Stroke(Main, CurrentTheme.Border, Settings.BorderThickness or 1)
	Theme:Register(Main, "BackgroundColor3", "Background")
	Theme:Register(MainStroke, "Color", "Border")
	self.Frame = Main

	local TopBar = Utility:Create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, TopBarHeight),
		BackgroundColor3 = CurrentTheme.Background,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Theme:Register(TopBar, "BackgroundColor3", "Background")
	self.TopBar = TopBar

	if Settings.AccentLine ~= false then
		local AccentLine = Utility:Create("Frame", {
			Name = "AccentLine",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, Settings.AccentLineHeight or 1),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.AccentLineTransparency or 0.35,
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Theme:Register(AccentLine, "BackgroundColor3", "Accent")
		self.AccentLine = AccentLine
	end

	local Logo = Utility:Create("TextLabel", {
		Name = "Logo",
		BackgroundColor3 = CurrentTheme.Surface,
		Position = UDim2.new(0, OuterPadding, 0, math.floor((TopBarHeight - 32) / 2)),
		Size = UDim2.new(0, 32, 0, 32),
		Visible = Settings.Logo ~= false,
		Font = Settings.LogoFont or Enum.Font.GothamBold,
		Text = Settings.LogoText or "L",
		TextColor3 = CurrentTheme.AccentLight,
		TextSize = Settings.LogoTextSize or 18,
		Parent = TopBar,
	})
	Utility:Round(Logo, 10)
	Theme:Register(Logo, "BackgroundColor3", "Surface")
	Theme:Register(Logo, "TextColor3", "AccentLight")
	self.Logo = Logo

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 9),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 22),
		Font = Settings.TitleFont or Enum.Font.GothamBold,
		Text = Settings.Name or Settings.Title or "Locito Hub",
		TextColor3 = CurrentTheme.Text,
		TextSize = Settings.TitleSize or 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Title, "TextColor3", "Text")
	self.Title = Title

	local Subtitle = Utility:Create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 30),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 16),
		Visible = Settings.Subtitle ~= false,
		Font = Settings.SubtitleFont or Enum.Font.Gotham,
		Text = Settings.Subtitle or "Original Roblox UI Library",
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.SubtitleSize or 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})
	Theme:Register(Subtitle, "TextColor3", "SubText")
	self.Subtitle = Subtitle

	local Close = Utility:Create("TextButton", {
		Name = "Close",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -OuterPadding, 0, math.floor((TopBarHeight - 28) / 2)),
		Size = UDim2.new(0, 28, 0, 28),
		Visible = ShowClose,
		BackgroundColor3 = CurrentTheme.Surface,
		Font = Enum.Font.GothamBold,
		Text = "X",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 16,
		AutoButtonColor = false,
		Parent = TopBar,
	})
	Utility:Round(Close, 8)
	Theme:Register(Close, "BackgroundColor3", "Surface")
	Theme:Register(Close, "TextColor3", "SubText")

	local Minimize = Utility:Create("TextButton", {
		Name = "Minimize",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, ShowClose and -(OuterPadding + 34) or -OuterPadding, 0, math.floor((TopBarHeight - 28) / 2)),
		Size = UDim2.new(0, 28, 0, 28),
		Visible = ShowMinimize,
		BackgroundColor3 = CurrentTheme.Surface,
		Font = Enum.Font.GothamBold,
		Text = "-",
		TextColor3 = CurrentTheme.SubText,
		TextSize = 16,
		AutoButtonColor = false,
		Parent = TopBar,
	})
	Utility:Round(Minimize, 8)
	Theme:Register(Minimize, "BackgroundColor3", "Surface")
	Theme:Register(Minimize, "TextColor3", "SubText")

	local Sidebar = Utility:Create("Frame", {
		Name = "Sidebar",
		Position = UDim2.new(0, OuterPadding, 0, ContentTop),
		Size = UDim2.new(0, SidebarWidth, 1, ContentHeightOffset),
		Visible = HasSidebar,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Utility:Round(Sidebar, Settings.PanelRadius or Radius)
	Theme:Register(Sidebar, "BackgroundColor3", "Secondary")
	self.Sidebar = Sidebar

	local SidebarList = Utility:Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -16, 1, -16),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = Sidebar,
	})
	Theme:Register(SidebarList, "ScrollBarImageColor3", "Accent")
	local SidebarLayout = Utility:List(SidebarList, 6)
	Utility:AutoCanvas(SidebarList, SidebarLayout, 12)
	self.SidebarList = SidebarList

	local Content = Utility:Create("Frame", {
		Name = "Content",
		Position = UDim2.new(0, ContentX, 0, ContentTop),
		Size = UDim2.new(1, ContentWidthOffset, 1, ContentHeightOffset),
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})
	Utility:Round(Content, Settings.PanelRadius or Radius)
	Theme:Register(Content, "BackgroundColor3", "Secondary")
	self.Content = Content

	local NotificationHolder = Utility:Create("Frame", {
		Name = "NotificationHolder",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 290, 1, -32),
		BackgroundTransparency = 1,
		Parent = Gui,
	})
	local NotificationLayout = Utility:List(NotificationHolder, 8)
	NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	self.NotificationHolder = NotificationHolder

	if Settings.Draggable ~= false then
		self.DragDisconnect = Utility:MakeDraggable(TopBar, Main, function(Position)
			if Shadow then
				Shadow.Position = Position
			end
		end)
	end

	if ShowClose then
		Close.MouseButton1Click:Connect(function()
			self:Destroy()
		end)
	end

	local Minimized = false
	local FullSize = Main.Size
	local ShadowFullSize = Shadow and Shadow.Size
	if ShowMinimize then
		Minimize.MouseButton1Click:Connect(function()
			Minimized = not Minimized
			Animation:Play(Main, {
				Size = Minimized and UDim2.new(0, FullSize.X.Offset, 0, TopBarHeight) or FullSize,
			}, { Time = 0.22 })
			if Shadow and ShadowFullSize then
				Animation:Play(Shadow, {
					Size = Minimized and UDim2.new(0, FullSize.X.Offset + 22, 0, TopBarHeight + 22) or ShadowFullSize,
				}, { Time = 0.22 })
			end
		end)
	end

	for _, Button in ipairs({ Close, Minimize }) do
		Button.MouseEnter:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().Text }, { Time = 0.12 })
		end)
		Button.MouseLeave:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().SubText }, { Time = 0.12 })
		end)
	end

	if Settings.Animate == false then
		Main.Size = FullSize
	else
		Main.Size = UDim2.new(0, 0, 0, 0)
		Animation:Play(Main, { Size = FullSize }, { Time = 0.32 })
	end

	return self
end

function Window:_SelectTab(TabObject)
	if self.ActiveTab == TabObject then return end

	if self.ActiveTab then
		self.ActiveTab:_SetSelected(false)
	end

	self.ActiveTab = TabObject
	TabObject:_SetSelected(true)
end

function Window:CreateTab(Name, Icon)
	local NewTab = Tab.new(self, Name, Icon)
	table.insert(self.Tabs, NewTab)

	if #self.Tabs == 1 then
		self:_SelectTab(NewTab)
	end

	return NewTab
end

Window.Tab = Window.CreateTab
Window.Page = Window.CreateTab

function Window:Notify(Title, Message, Duration, Kind)
	return Notification.new(self, {
		Title = Title,
		Message = Message,
		Duration = Duration,
		Kind = Kind,
	})
end

function Window:Toggle()
	self.Visible = not self.Visible
	self.Frame.Visible = self.Visible
end

function Window:SetTitle(Text)
	if self.Title then
		self.Title.Text = Text
	end
end

function Window:SetSubtitle(Text)
	if self.Subtitle then
		self.Subtitle.Text = Text
	end
end

function Window:SetSize(Size)
	self.Frame.Size = Size
	if self.Shadow then
		self.Shadow.Size = Size + UDim2.new(0, 22, 0, 22)
	end
end

function Window:SetPosition(Position)
	self.Frame.Position = Position
	if self.Shadow then
		self.Shadow.Position = Position
	end
end

function Window:SetTheme(Name)
	return Theme:Set(Name)
end

function Window:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	if self.DragDisconnect then
		self.DragDisconnect()
		self.DragDisconnect = nil
	end

	for _, TabObject in ipairs(self.Tabs) do
		if TabObject.Destroy then
			TabObject:Destroy()
		end
	end
	self.Tabs = {}
	self.ActiveTab = nil

	if self.Gui then
		self.Gui:Destroy()
		self.Gui = nil
	end

	self.Shadow = nil
end

-- src/init.lua
-- LocitoUI Main Loader
-- Version 0.2.0

local LocitoUI = {}


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

return LocitoUI
