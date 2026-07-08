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
		Track = Color3.fromRGB(66, 66, 88),
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
		Track = Color3.fromRGB(56, 58, 66),
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
		Track = Color3.fromRGB(42, 84, 116),
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
		Track = Color3.fromRGB(42, 88, 65),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(72, 210, 118),
		Warning = Color3.fromRGB(255, 186, 73),
		Error = Color3.fromRGB(255, 83, 83),
		CornerRadius = 12,
		AnimationSpeed = 0.22,
	},

	Noir = {
		Background = Color3.fromRGB(3, 3, 5),
		Secondary = Color3.fromRGB(8, 8, 10),
		Surface = Color3.fromRGB(13, 13, 16),
		SurfaceLight = Color3.fromRGB(28, 28, 32),
		Accent = Color3.fromRGB(242, 242, 242),
		AccentLight = Color3.fromRGB(255, 255, 255),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(184, 184, 190),
		Muted = Color3.fromRGB(102, 102, 110),
		Border = Color3.fromRGB(74, 74, 82),
		TabActive = Color3.fromRGB(32, 32, 36),
		TabHover = Color3.fromRGB(22, 22, 26),
		Track = Color3.fromRGB(48, 48, 54),
		Shadow = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(220, 255, 235),
		Warning = Color3.fromRGB(255, 232, 172),
		Error = Color3.fromRGB(255, 154, 154),
		CornerRadius = 10,
		AnimationSpeed = 0.18,
	},

	Phantom = {
		Background = Color3.fromRGB(8, 10, 14),
		Secondary = Color3.fromRGB(10, 12, 17),
		Surface = Color3.fromRGB(16, 19, 25),
		SurfaceLight = Color3.fromRGB(28, 32, 42),
		Accent = Color3.fromRGB(0, 218, 222),
		AccentLight = Color3.fromRGB(84, 255, 255),
		Text = Color3.fromRGB(240, 246, 252),
		SubText = Color3.fromRGB(143, 150, 162),
		Muted = Color3.fromRGB(91, 98, 111),
		Border = Color3.fromRGB(33, 38, 48),
		TabActive = Color3.fromRGB(8, 48, 52),
		TabHover = Color3.fromRGB(15, 28, 34),
		Track = Color3.fromRGB(28, 32, 40),
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
	Current.AccentLight = AccentLight or Color:Lerp(Color3.fromRGB(255, 255, 255), 0.35)
	Current.TabActive = Color:Lerp(Current.Background or Color3.fromRGB(0, 0, 0), 0.72)
	Current.TabHover = Color:Lerp(Current.Background or Color3.fromRGB(0, 0, 0), 0.86)
	self:Apply()

	for _, Listener in ipairs(self.Listeners) do
		task.spawn(Listener, Current, self.Current)
	end

	return true
end

function Theme:SetColor(Key, Color)
	if typeof(Key) ~= "string" or typeof(Color) ~= "Color3" then
		return false
	end

	if Key == "Accent" then
		return self:SetAccent(Color)
	end

	local Current = self:Get()
	Current[Key] = Color
	if Key == "Background" and Current.Accent then
		Current.TabActive = Current.Accent:Lerp(Color, 0.72)
		Current.TabHover = Current.Accent:Lerp(Color, 0.86)
	end
	self:Apply()

	for _, Listener in ipairs(self.Listeners) do
		task.spawn(Listener, Current, self.Current)
	end

	return true
end

function Theme:SetColors(Values)
	if typeof(Values) ~= "table" then
		return false
	end

	local Current = self:Get()
	local Changed = false
	for Key, Color in pairs(Values) do
		if typeof(Key) == "string" and typeof(Color) == "Color3" then
			Current[Key] = Color
			Changed = true
		end
	end

	if not Changed then
		return false
	end

	if Current.Accent and Current.Background then
		Current.TabActive = Current.Accent:Lerp(Current.Background, 0.72)
		Current.TabHover = Current.Accent:Lerp(Current.Background, 0.86)
	end

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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	self.Callback = Options.Callback or function() end
	self.Enabled = Options.Enabled ~= false
	local Style = Options.Style or (Options.Accent and "Accent") or "Secondary"
	local BackgroundKey = Style == "Accent" and "Accent" or "Secondary"
	local TextKey = Style == "Accent" and "Text" or "Text"

	local Object = Utility:Create("TextButton", {
		Name = "Button",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 40 or 38)),
		BackgroundColor3 = Options.BackgroundColor or CurrentTheme[BackgroundKey],
		BorderSizePixel = 0,
		Font = Options.Font or Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Button",
		TextColor3 = Options.TextColor or CurrentTheme[TextKey],
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextTransparency = self.Enabled and 0 or 0.45,
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Object, Options.Radius or (PreviewLayout and 8 or 9))
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
		Animation:Play(Object, {
			BackgroundColor3 = Style == "Accent" and Theme:Get().AccentLight or Theme:Get().SurfaceLight,
			TextSize = (Options.TextSize or (PreviewLayout and 13 or 14)) + 1,
		}, { Time = 0.12 })
	end)

	Object.MouseLeave:Connect(function()
		if not self.Enabled then return end
		Animation:Play(Object, {
			BackgroundColor3 = Options.BackgroundColor or Theme:Get()[BackgroundKey],
			TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		}, { Time = 0.12 })
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)
	local TrackOffColor = CurrentTheme.Track or CurrentTheme.Border

	local Row = Utility:Create("TextButton", {
		Name = "Toggle",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 40)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
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
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 36 or 44, 0, PreviewLayout and 20 or 22),
		BackgroundColor3 = self.Value and CurrentTheme.Accent or TrackOffColor,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)

	local Knob = Utility:Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = self.Value and UDim2.new(1, PreviewLayout and -18 or -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 16 or 18, 0, PreviewLayout and 16 or 18),
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
			BackgroundColor3 = self.Value and T.Accent or (T.Track or T.Border),
		}, { Time = 0.14 })

		Animation:Play(Knob, {
			Position = self.Value and UDim2.new(1, PreviewLayout and -18 or -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
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
		Animation:Play(Row, {
			BackgroundColor3 = Theme:Get().SurfaceLight,
			BackgroundTransparency = PreviewLayout and 0.82 or RowTransparency,
		}, { Time = 0.12 })
	end)

	Row.MouseLeave:Connect(function()
		Animation:Play(Row, {
			BackgroundColor3 = Theme:Get().Secondary,
			BackgroundTransparency = RowTransparency,
		}, { Time = 0.12 })
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "Slider",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 58 or 56)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 6),
		Size = UDim2.new(0.65, -12, 0, 20),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Slider",
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 6),
		Size = PreviewLayout and UDim2.new(0, 44, 0, 20) or UDim2.new(0.35, 0, 0, 20),
		BackgroundColor3 = CurrentTheme.SurfaceLight,
		BackgroundTransparency = PreviewLayout and 0 or 1,
		BorderSizePixel = 0,
		Font = PreviewLayout and Enum.Font.Code or Enum.Font.Gotham,
		Text = tostring(self.Value),
		TextColor3 = PreviewLayout and CurrentTheme.Accent or CurrentTheme.SubText,
		TextSize = PreviewLayout and 12 or 13,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = Row,
	})
	if PreviewLayout then
		Utility:Round(ValueLabel, 5)
	end
	Theme:Register(ValueLabel, "BackgroundColor3", "SurfaceLight")
	Theme:Register(ValueLabel, "TextColor3", PreviewLayout and "Accent" or "SubText")

	local Track = Utility:Create("Frame", {
		Name = "Track",
		Position = UDim2.new(0, 12, 0, 36),
		Size = UDim2.new(1, -24, 0, Options.TrackHeight or (PreviewLayout and 5 or 8)),
		BackgroundColor3 = CurrentTheme.Track or CurrentTheme.Border,
		BorderSizePixel = 0,
		Parent = Row,
	})
	Utility:Round(Track, 99)
	Theme:Register(Track, "BackgroundColor3", "Track")

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
		Size = UDim2.new(0, PreviewLayout and 12 or 16, 0, PreviewLayout and 12 or 16),
		BackgroundColor3 = PreviewLayout and CurrentTheme.Accent or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = Track,
	})
	Utility:Round(Knob, 99)
	if PreviewLayout then
		Theme:Register(Knob, "BackgroundColor3", "Accent")
	end

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
		Animation:Play(Fill, { Size = UDim2.new(VisualRatio, 0, 1, 0) }, { Time = PreviewLayout and 0.08 or 0.04 })
		Animation:Play(Knob, { Position = UDim2.new(VisualRatio, 0, 0.5, 0) }, { Time = PreviewLayout and 0.08 or 0.04 })
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "Textbox",
		Size = Options.Size or UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 42)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
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
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		ClearTextOnFocus = Options.ClearTextOnFocus == true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Box, "TextColor3", "Text")
	Theme:Register(Box, "PlaceholderColor3", "Muted")

	Box.Focused:Connect(function()
		Animation:Play(Stroke, { Transparency = 0 }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Accent }, { Time = 0.12 })
		Animation:Play(Row, { BackgroundTransparency = PreviewLayout and 0.82 or RowTransparency }, { Time = 0.12 })
	end)

	if Options.Live == true or Options.LiveUpdate == true then
		Box:GetPropertyChangedSignal("Text"):Connect(function()
			self.Value = Box.Text
			Utility:SafeCall(self.Changed, self.Value, false)
		end)
	end

	Box.FocusLost:Connect(function(EnterPressed)
		self.Value = Box.Text
		Animation:Play(Stroke, { Transparency = StrokeTransparency }, { Time = 0.12 })
		Animation:Play(Stroke, { Color = Theme:Get().Border }, { Time = 0.12 })
		Animation:Play(Row, { BackgroundTransparency = RowTransparency }, { Time = 0.12 })
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "Dropdown",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 42)),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Utility:Padding(Row, PreviewLayout and 0 or 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, PreviewLayout and 0 or 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, PreviewLayout and 45 or 28),
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
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Label.Position = UDim2.new(0, PreviewLayout and 12 or 0, 0, 0)
	Theme:Register(Label, "TextColor3", "Text")

	local ValueLabel = Utility:Create("TextLabel", {
		BackgroundColor3 = CurrentTheme.SurfaceLight,
		BackgroundTransparency = PreviewLayout and 0 or 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = PreviewLayout and UDim2.new(1, -12, 0.5, -15) or UDim2.new(1, 0, 0, 0),
		Size = PreviewLayout and UDim2.new(0, 78, 0, 30) or UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.Gotham,
		Text = tostring(self.Value or "None") .. "  v",
		TextColor3 = CurrentTheme.SubText,
		TextSize = PreviewLayout and 12 or 13,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = Header,
	})
	if PreviewLayout then
		Utility:Round(ValueLabel, 7)
	end
	Theme:Register(ValueLabel, "BackgroundColor3", "SurfaceLight")
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
			if PreviewLayout then
				OptionButton.TextXAlignment = Enum.TextXAlignment.Left
				Utility:Padding(OptionButton, 10)
			end
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
		if PreviewLayout then
			Animation:Play(ValueLabel, { TextColor3 = self.Open and Theme:Get().Accent or Theme:Get().SubText }, { Time = 0.12 })
		end
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "Keybind",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 40)),
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")

	local Label = Utility:Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -100, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = Options.Text or Options.Name or "Keybind",
		TextColor3 = CurrentTheme.Text,
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})
	Theme:Register(Label, "TextColor3", "Text")

	local Button = Utility:Create("TextButton", {
		Name = "BindButton",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 92 or 78, 0, PreviewLayout and 28 or 26),
		BackgroundColor3 = CurrentTheme.SurfaceLight,
		BorderSizePixel = 0,
		Font = PreviewLayout and Enum.Font.Code or Enum.Font.Gotham,
		Text = self.Key,
		TextColor3 = PreviewLayout and CurrentTheme.Accent or CurrentTheme.SubText,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = Row,
	})
	Utility:Round(Button, 7)
	Theme:Register(Button, "BackgroundColor3", "SurfaceLight")
	Theme:Register(Button, "TextColor3", PreviewLayout and "Accent" or "SubText")

	table.insert(self.Connections, Button.MouseButton1Click:Connect(function()
		self.Listening = true
		Button.Text = "..."
		Animation:Play(Button, { BackgroundColor3 = Theme:Get().Accent }, { Time = 0.12 })
		Animation:Play(Button, { TextColor3 = Theme:Get().Background }, { Time = 0.12 })
	end))

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
		if Processed then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

		if self.Listening then
			self.Key = Input.KeyCode.Name
			self.Listening = false
			Button.Text = self.Key
			Animation:Play(Button, { BackgroundColor3 = Theme:Get().SurfaceLight }, { Time = 0.12 })
			Animation:Play(Button, { TextColor3 = PreviewLayout and Theme:Get().Accent or Theme:Get().SubText }, { Time = 0.12 })
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
	local WindowSettings = Section.Tab and Section.Tab.Window and Section.Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local RowTransparency = Options.BackgroundTransparency or (PreviewLayout and 1 or 0)
	local StrokeTransparency = Options.StrokeTransparency or WindowSettings.RowStrokeTransparency or (PreviewLayout and 0.72 or 0.25)

	local Row = Utility:Create("Frame", {
		Name = "ColorPicker",
		Size = UDim2.new(1, 0, 0, Options.Height or (PreviewLayout and 45 or 42)),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Secondary,
		BackgroundTransparency = RowTransparency,
		BorderSizePixel = 0,
		Parent = Section.Body,
	})
	Utility:Round(Row, Options.Radius or (PreviewLayout and 0 or 9))
	local Stroke = Utility:Stroke(Row, CurrentTheme.Border, 1, StrokeTransparency)
	Utility:Padding(Row, PreviewLayout and 0 or 8)
	Theme:Register(Row, "BackgroundColor3", "Secondary")
	Theme:Register(Stroke, "Color", "Border")
	Utility:List(Row, PreviewLayout and 0 or 6)

	local Header = Utility:Create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, PreviewLayout and 45 or 28),
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
		TextSize = Options.TextSize or (PreviewLayout and 13 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	Label.Position = UDim2.new(0, PreviewLayout and 12 or 0, 0, 0)
	Theme:Register(Label, "TextColor3", "Text")

	local Preview = Utility:Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, PreviewLayout and -12 or 0, 0.5, 0),
		Size = UDim2.new(0, PreviewLayout and 36 or 32, 0, PreviewLayout and 24 or 22),
		BackgroundColor3 = self.Value,
		BorderSizePixel = 0,
		Parent = Header,
	})
	Utility:Round(Preview, 7)
	local PreviewStroke = Utility:Stroke(Preview, CurrentTheme.Border, 1, 0.2)
	Theme:Register(PreviewStroke, "Color", "Border")

	local Palette = Utility:Create("Frame", {
		Name = "Palette",
		Size = UDim2.new(1, PreviewLayout and -24 or 0, 0, 32),
		Position = UDim2.new(0, PreviewLayout and 12 or 0, 0, 0),
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
				local ThemeKey = Options.ThemeKey or Options.ColorKey or Options.ApplyToTheme
				if ThemeKey == true then
					ThemeKey = "Accent"
				end
				Theme:SetColor(ThemeKey, Color)
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
		if PreviewLayout then
			Animation:Play(Preview, { Size = self.Open and UDim2.new(0, 42, 0, 24) or UDim2.new(0, 36, 0, 24) }, { Time = 0.12 })
		end
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
	local WindowSettings = Tab.Window and Tab.Window.Settings or {}
	local PreviewLayout = WindowSettings.Layout == "Preview" or WindowSettings.Style == "Preview" or WindowSettings.PreviewLayout == true
	local TitleColorKey = Options.TitleColorKey or (PreviewLayout and "Accent" or "Text")
	local ShouldUppercase = Options.UppercaseTitle == true or (PreviewLayout and Options.UppercaseTitle ~= false)
	local SectionTitle = ShouldUppercase and string.upper(tostring(Name)) or Name
	local ShowDivider = Options.TitleDivider == true or (PreviewLayout and Options.TitleDivider ~= false)
	local TitleInset = Options.TitleInset or (PreviewLayout and 16 or 0)

	local Frame = Utility:Create("Frame", {
		Name = Name .. "Section",
		Size = Options.Size or UDim2.new(1, Options.WidthOffset or (PreviewLayout and 0 or -6), 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Options.Transparency or Options.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		Parent = Tab.Page,
	})
	Utility:Round(Frame, Options.Radius or CurrentTheme.CornerRadius or 12)
	local Stroke = Utility:Stroke(Frame, CurrentTheme.Border, 1, 0.15)
	Utility:Padding(Frame, Options.Padding or (PreviewLayout and 0 or 12))
	Theme:Register(Frame, "BackgroundColor3", "Surface")
	Theme:Register(Stroke, "Color", "Border")

	local Layout = Utility:List(Frame, Options.Spacing or (PreviewLayout and 0 or 8))

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Options.TitleHeight or (PreviewLayout and 38 or 20)),
		Visible = Options.ShowTitle ~= false,
		Font = Options.TitleFont or (PreviewLayout and Enum.Font.Code or Enum.Font.GothamBold),
		Text = SectionTitle,
		TextColor3 = CurrentTheme[TitleColorKey] or CurrentTheme.Text,
		TextSize = Options.TitleSize or (PreviewLayout and 12 or 14),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})
	if TitleInset > 0 then
		local TitlePadding = Instance.new("UIPadding")
		TitlePadding.PaddingLeft = UDim.new(0, TitleInset)
		TitlePadding.PaddingRight = UDim.new(0, TitleInset)
		TitlePadding.Parent = Title
	end
	Theme:Register(Title, "TextColor3", TitleColorKey)

	local Divider = Utility:Create("Frame", {
		Name = "TitleDivider",
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 1),
		Visible = ShowDivider and Options.ShowTitle ~= false,
		BackgroundColor3 = CurrentTheme.Border,
		BackgroundTransparency = Options.TitleDividerTransparency or (PreviewLayout and 0.45 or 0.65),
		BorderSizePixel = 0,
		Parent = Frame,
	})
	Theme:Register(Divider, "BackgroundColor3", "Border")

	local Body = Utility:Create("Frame", {
		Name = "Body",
		LayoutOrder = Options.ShowTitle == false and 1 or 3,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Frame,
	})
	Utility:Padding(Body, Options.BodyPadding or (PreviewLayout and 0 or 0))
	local BodyLayout = Utility:List(Body, Options.ItemSpacing or Options.Spacing or (PreviewLayout and 0 or 8))

	self.Frame = Frame
	self.Body = Body
	self.Layout = Layout
	self.BodyLayout = BodyLayout
	self.Title = Title
	self.Divider = Divider

	if Options.Animate ~= false and WindowSettings.SectionAnimation ~= false then
		local TargetTransparency = Frame.BackgroundTransparency
		Frame.BackgroundTransparency = 1
		task.defer(function()
			if Frame.Parent then
				Animation:Play(Frame, { BackgroundTransparency = TargetTransparency }, { Time = 0.18 })
			end
		end)
	end

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
	local PreviewLayout = Settings.Layout == "Preview" or Settings.Style == "Preview" or Settings.PreviewLayout == true
	local PillTabs = Settings.TabStyle == "Pill" or Settings.TabPills == true or PreviewLayout
	local TabHeight = Settings.TabHeight or (PreviewLayout and 40 or 38)
	local TabRadius = Settings.TabRadius or (PreviewLayout and 8 or 9)
	local TabTextInset = Settings.TabTextInset or (PreviewLayout and 38 or 12)
	local TabIconSize = Settings.TabIconSize or (PreviewLayout and 22 or 20)
	local IndicatorWidth = Settings.TabIndicatorWidth or 3
	local IndicatorHeight = Settings.TabIndicatorHeight or 22
	local UseIndicator = Settings.TabIndicator ~= false and not PillTabs
	local NormalSize = UDim2.new(1, 0, 0, TabHeight)
	local HoverSize = Settings.TabHoverGrow == false and NormalSize or UDim2.new(1, 0, 0, TabHeight + 2)
	local ActiveSize = Settings.TabActiveGrow == false and NormalSize or UDim2.new(1, 0, 0, TabHeight + 4)
	local LabelX = Icon and TabTextInset or 12

	local Button = Utility:Create("TextButton", {
		Name = Name .. "Tab",
		Size = NormalSize,
		BackgroundColor3 = PillTabs and (CurrentTheme.TabActive or CurrentTheme.Surface) or CurrentTheme.Surface,
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
		Visible = UseIndicator,
		BackgroundColor3 = CurrentTheme.Accent,
		BorderSizePixel = 0,
		Parent = Button,
	})
	Utility:Round(Indicator, 99)
	Theme:Register(Indicator, "BackgroundColor3", "Accent")

	local IconLabel = Utility:Create("TextLabel", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, PreviewLayout and 10 or TabTextInset, 0.5, -math.floor(TabIconSize / 2)),
		Size = UDim2.new(0, TabIconSize, 0, TabIconSize),
		Visible = Icon ~= nil,
		Font = Settings.TabIconFont or Enum.Font.GothamBold,
		Text = Icon or "",
		TextColor3 = CurrentTheme.Muted,
		TextSize = Settings.TabIconTextSize or (PreviewLayout and 15 or 13),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = Button,
	})
	Theme:Register(IconLabel, "TextColor3", "Muted")

	local Label = Utility:Create("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, LabelX, 0, 0),
		Size = UDim2.new(1, -LabelX - 8, 1, 0),
		Font = Settings.TabFont or Enum.Font.GothamMedium,
		Text = Name,
		TextColor3 = CurrentTheme.SubText,
		TextSize = Settings.TabTextSize or (PreviewLayout and 14 or 13),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Button,
	})

	local Page = Utility:Create("ScrollingFrame", {
		Name = Name .. "Page",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CurrentTheme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,
		Parent = Window.Content,
	})
	Theme:Register(Page, "ScrollBarImageColor3", "Accent")
	Utility:Padding(Page, Settings.PagePadding or (PreviewLayout and 0 or 10))
	local Layout = Utility:List(Page, Settings.PageGap or (PreviewLayout and 12 or 10))
	Utility:AutoCanvas(Page, Layout, Settings.PageCanvasPadding or (PreviewLayout and 14 or 22))

	self.Button = Button
	self.Indicator = Indicator
	self.IconLabel = IconLabel
	self.Label = Label
	self.Page = Page
	self.Layout = Layout
	self.IndicatorWidth = IndicatorWidth
	self.IndicatorHeight = IndicatorHeight
	self.UseIndicator = UseIndicator
	self.PillTabs = PillTabs
	self.NormalSize = NormalSize
	self.HoverSize = HoverSize
	self.ActiveSize = ActiveSize
	self.LabelX = LabelX
	self.PageSlideOffset = Settings.PageSlideOffset or (PreviewLayout and 8 or 0)
	self.PageAnimation = Settings.TabPageAnimation ~= false
	self.SelectedTransparency = Settings.TabSelectedTransparency or 0
	self.HoverTransparency = Settings.TabHoverTransparency or (PillTabs and 0.1 or 0.55)
	self.ThemeDisconnect = Theme:OnChanged(function()
		self:_SetSelected(Window.ActiveTab == self)
	end)

	Button.MouseButton1Click:Connect(function()
		Window:_SelectTab(self)
	end)

	Button.MouseEnter:Connect(function()
		if Window.ActiveTab == self then return end
		local ActiveTheme = Theme:Get()
		Animation:Play(Button, {
			BackgroundColor3 = ActiveTheme.TabHover or ActiveTheme.SurfaceLight,
			BackgroundTransparency = self.HoverTransparency,
			Size = self.HoverSize,
		}, { Time = 0.12 })
		Animation:Play(Label, {
			Position = UDim2.new(0, self.LabelX + 4, 0, 0),
			TextColor3 = ActiveTheme.Text,
		}, { Time = 0.12 })
		if IconLabel then
			Animation:Play(IconLabel, {
				Rotation = 14,
				TextColor3 = ActiveTheme.Accent,
			}, { Time = 0.12 })
		end
	end)

	Button.MouseLeave:Connect(function()
		if Window.ActiveTab == self then return end
		Animation:Play(Button, {
			BackgroundTransparency = 1,
			Size = self.NormalSize,
		}, { Time = 0.12 })
		Animation:Play(Label, {
			Position = UDim2.new(0, self.LabelX, 0, 0),
			TextColor3 = Theme:Get().SubText,
		}, { Time = 0.12 })
		if IconLabel then
			Animation:Play(IconLabel, {
				Rotation = 0,
				TextColor3 = Theme:Get().Muted,
			}, { Time = 0.12 })
		end
	end)

	return self
end

function Tab:_SetSelected(IsSelected)
	if not self.Page or not self.Page.Parent then
		return
	end

	if IsSelected then
		self.Page.Visible = true
		if self.PageAnimation then
			self.Page.Position = UDim2.new(0, self.PageSlideOffset, 0, 0)
			Animation:Play(self.Page, { Position = UDim2.new(0, 0, 0, 0) }, { Time = 0.18 })
		end
	else
		self.Page.Visible = false
	end

	if IsSelected then
		local ActiveTheme = Theme:Get()
		Animation:Play(self.Button, {
			BackgroundColor3 = self.PillTabs and (ActiveTheme.TabActive or ActiveTheme.Surface) or ActiveTheme.Surface,
			BackgroundTransparency = self.SelectedTransparency,
			Size = self.ActiveSize,
		}, { Time = 0.15 })
		if self.UseIndicator then
			Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, self.IndicatorHeight) }, { Time = 0.15 })
		end
		Animation:Play(self.Label, {
			Position = UDim2.new(0, self.LabelX + 4, 0, 0),
			TextColor3 = self.PillTabs and ActiveTheme.Accent or ActiveTheme.Text,
		}, { Time = 0.15 })
		if self.IconLabel then
			self.IconLabel.Rotation = -18
			Animation:Play(self.IconLabel, {
				Rotation = 0,
				TextColor3 = ActiveTheme.Accent,
			}, { Time = 0.22, Style = Enum.EasingStyle.Back })
		end
	else
		Animation:Play(self.Button, {
			BackgroundTransparency = 1,
			Size = self.NormalSize,
		}, { Time = 0.15 })
		if self.UseIndicator then
			Animation:Play(self.Indicator, { Size = UDim2.new(0, self.IndicatorWidth, 0, 0) }, { Time = 0.15 })
		end
		Animation:Play(self.Label, {
			Position = UDim2.new(0, self.LabelX, 0, 0),
			TextColor3 = Theme:Get().SubText,
		}, { Time = 0.15 })
		if self.IconLabel then
			Animation:Play(self.IconLabel, {
				Rotation = 0,
				TextColor3 = Theme:Get().Muted,
			}, { Time = 0.15 })
		end
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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local function ResolveKeyCode(Key)
	if typeof(Key) == "EnumItem" then
		return Key
	end

	if typeof(Key) == "string" then
		local KeyName = Key:gsub("%s+", "")
		local Success, KeyCode = pcall(function()
			return Enum.KeyCode[KeyName]
		end)

		if Success and KeyCode then
			return KeyCode
		end

		local LowerKeyName = KeyName:lower()
		for _, EnumItem in ipairs(Enum.KeyCode:GetEnumItems()) do
			if EnumItem.Name:lower() == LowerKeyName then
				return EnumItem
			end
		end
	end

	return nil
end

local function ColorToHex(Color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(Color.R * 255 + 0.5),
		math.floor(Color.G * 255 + 0.5),
		math.floor(Color.B * 255 + 0.5)
	)
end

local function EscapeRichText(Text)
	local Escaped = tostring(Text)
	Escaped = Escaped:gsub("&", "&amp;")
	Escaped = Escaped:gsub("<", "&lt;")
	Escaped = Escaped:gsub(">", "&gt;")
	return Escaped
end

local function BuildTitleText(Settings, ThemeValues, TitleText)
	if typeof(Settings.TitleRichText) == "string" then
		return Settings.TitleRichText, true
	end

	local AccentWord = Settings.TitleAccent or Settings.AccentTitle or Settings.HighlightTitle
	local Version = Settings.Version or Settings.ScriptVersion
	if not AccentWord and not Version and Settings.TitleRichText ~= true then
		return TitleText, false
	end

	local Rendered = EscapeRichText(TitleText)
	local UsesRichText = Settings.TitleRichText == true

	if AccentWord then
		local Word = EscapeRichText(AccentWord)
		local StartIndex, EndIndex = Rendered:find(Word, 1, true)
		if StartIndex then
			local AccentColor = ColorToHex(Settings.TitleAccentColor or ThemeValues.Accent)
			Rendered = Rendered:sub(1, StartIndex - 1)
				.. "<font color=\"" .. AccentColor .. "\">"
				.. Rendered:sub(StartIndex, EndIndex)
				.. "</font>"
				.. Rendered:sub(EndIndex + 1)
			UsesRichText = true
		end
	end

	if Version then
		Rendered = Rendered
			.. " <font size=\"10\" color=\""
			.. ColorToHex(Settings.VersionColor or ThemeValues.Muted)
			.. "\">"
			.. EscapeRichText(Version)
			.. "</font>"
		UsesRichText = true
	end

	return Rendered, UsesRichText
end

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
	self.Connections = {}
	self.ActiveTab = nil
	self.Visible = true

	local CurrentTheme = Theme:Get()
	local Player = Players.LocalPlayer
	local ParentGui = Settings.Parent or (Player and Player:WaitForChild("PlayerGui"))
	local PreviewLayout = Settings.Layout == "Preview" or Settings.Style == "Preview" or Settings.PreviewLayout == true
	local WindowSize = Settings.Size or UDim2.new(0, Settings.Width or (PreviewLayout and 672 or 680), 0, Settings.Height or (PreviewLayout and 430 or 450))
	local TopBarHeight = Settings.TopBarHeight or Settings.TopbarHeight or (PreviewLayout and 54 or 56)
	local OuterPadding = Settings.Padding or (PreviewLayout and 12 or 14)
	local TopBarPadding = Settings.TopBarPadding or (PreviewLayout and 18 or OuterPadding)
	local Gap = Settings.Gap or (PreviewLayout and 14 or 14)
	local ContentGap = Settings.ContentGap or 10
	local SidebarWidth = Settings.SidebarWidth or (PreviewLayout and 160 or 160)
	local HasSidebar = Settings.Sidebar ~= false
	local ContentTop = TopBarHeight + ContentGap
	local ContentX = HasSidebar and ((PreviewLayout and SidebarWidth or OuterPadding + SidebarWidth) + Gap) or OuterPadding
	local ContentRightPadding = Settings.ContentRightPadding or (PreviewLayout and 12 or OuterPadding)
	local ContentBottomPadding = Settings.ContentBottomPadding or (PreviewLayout and 12 or OuterPadding)
	local ContentWidthOffset = -(ContentX + ContentRightPadding)
	local ContentHeightOffset = -(ContentTop + ContentBottomPadding)
	local SidebarX = Settings.SidebarX or (PreviewLayout and 0 or OuterPadding)
	local SidebarY = Settings.SidebarY or (PreviewLayout and TopBarHeight or ContentTop)
	local SidebarHeightOffset = Settings.SidebarHeightOffset or (PreviewLayout and -TopBarHeight or ContentHeightOffset)
	local ShowControls = Settings.Controls ~= false
	local ShowClose = ShowControls and Settings.CloseButton ~= false
	local ShowMinimize = ShowControls and Settings.MinimizeButton ~= false
	local ControlReserve = ShowControls and 90 or 16
	local LogoSize = Settings.LogoSize or (PreviewLayout and 28 or 32)
	local LogoRadius = Settings.LogoRadius or (PreviewLayout and 9 or 10)
	local TitleX = Settings.Logo == false and TopBarPadding or (TopBarPadding + LogoSize + 12)
	local MainAnchor = Settings.AnchorPoint or Vector2.new(0.5, 0.5)
	local MainPosition = Settings.Position or UDim2.new(0.5, 0, 0.5, 0)
	local Radius = Settings.Radius or CurrentTheme.CornerRadius
	local ShadowPadding = Settings.ShadowPadding or 22
	local ToggleTime = Settings.ToggleTime or Settings.ToggleAnimationTime or 0.2

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
	self.FullSize = WindowSize
	self.CustomHiddenSize = Settings.HiddenSize ~= nil
	self.HiddenSize = Settings.HiddenSize or UDim2.new(WindowSize.X.Scale, WindowSize.X.Offset, 0, 0)
	self.ToggleTime = ToggleTime
	self.ToggleKey = ResolveKeyCode(Settings.ToggleKey or Settings.ToggleKeybind or Settings.MenuKeybind)
	self.ShadowPadding = ShadowPadding

	local Shadow
	if Settings.Shadow ~= false then
		Shadow = Utility:Create("Frame", {
			Name = "Shadow",
			AnchorPoint = MainAnchor,
			Position = Settings.ShadowPosition or MainPosition,
			Size = Settings.ShadowSize or (WindowSize + UDim2.new(0, ShadowPadding, 0, ShadowPadding)),
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
	self.ShadowFullSize = Shadow and Shadow.Size
	self.ShadowHiddenSize = Shadow and UDim2.new(WindowSize.X.Scale, WindowSize.X.Offset + ShadowPadding, 0, ShadowPadding)

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

	if Settings.BackgroundLogo ~= false and (Settings.BackgroundLogo == true or PreviewLayout) then
		local BackgroundLogoSize = Settings.BackgroundLogoSize or (PreviewLayout and 176 or 150)
		local BackgroundLogoText = Settings.BackgroundLogoText or Settings.LogoText or "L"
		local BackgroundLogoSpeed = Settings.BackgroundLogoSpeed or Settings.BackgroundLogoRotationSpeed or 22
		local BackgroundLogoState = {
			Shape = Settings.BackgroundLogoShape or Settings.BackgroundShape or "Sword",
			Material = Settings.BackgroundLogoMaterial or Settings.BackgroundMaterial or "Noir",
			Speed = BackgroundLogoSpeed,
			Intensity = Settings.BackgroundLogoIntensity or Settings.BackgroundAnimationIntensity or 1.25,
			Transparency = Settings.BackgroundLogoTransparency or Settings.BackgroundSwordTransparency,
			PrimaryColor = Settings.BackgroundLogoPrimaryColor,
			SecondaryColor = Settings.BackgroundLogoSecondaryColor,
			StoneColor = Settings.BackgroundLogoStoneColor,
			OuterSword = Settings.OuterSword == true or Settings.OrbitSword == true or Settings.ExternalSword == true,
			OuterSwordSpeed = Settings.OuterSwordSpeed or Settings.OrbitSwordSpeed or 46,
			OuterSwordRadiusX = Settings.OuterSwordRadiusX or Settings.OrbitSwordRadiusX,
			OuterSwordRadiusY = Settings.OuterSwordRadiusY or Settings.OrbitSwordRadiusY,
			BackgroundVisible = true,
		}
		local BackgroundLogo = Utility:Create("Frame", {
			Name = "AnimatedBackgroundLogo",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Settings.BackgroundLogoPosition or (PreviewLayout and UDim2.new(0.66, 0, 0.58, 0) or UDim2.new(1, -126, 1, -80)),
			Size = UDim2.new(0, BackgroundLogoSize, 0, BackgroundLogoSize),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Main,
		})

		local OuterSwordLayer
		local OuterSwordGroup
		local OuterBlade
		local OuterTip
		local OuterGuard
		local OuterGrip
		local OuterPommel
		local OuterName

		if BackgroundLogoState.OuterSword then
			OuterSwordLayer = Utility:Create("Frame", {
				Name = "OuterSwordOrbitLayer",
				AnchorPoint = MainAnchor,
				Position = MainPosition,
				Size = WindowSize,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = Gui,
			})

			OuterSwordGroup = Utility:Create("Frame", {
				Name = "OuterOrbitSword",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = Settings.OuterSwordSize or UDim2.new(0, 72, 0, 146),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordLayer,
			})

			OuterBlade = Utility:Create("Frame", {
				Name = "OuterBlade",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.04, 0),
				Size = UDim2.new(0, 9, 0.58, 0),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterBlade, 5)

			OuterTip = Utility:Create("Frame", {
				Name = "OuterTip",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.04, 0),
				Size = UDim2.new(0, 21, 0, 21),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Rotation = 45,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterTip, 4)

			OuterGuard = Utility:Create("Frame", {
				Name = "OuterGuard",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.62, 0),
				Size = UDim2.new(0.66, 0, 0, 8),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.28,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterGuard, 8)

			OuterGrip = Utility:Create("Frame", {
				Name = "OuterGrip",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.62, 0),
				Size = UDim2.new(0, 14, 0.22, 0),
				BackgroundColor3 = CurrentTheme.SurfaceLight,
				BackgroundTransparency = 0.18,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterGrip, 6)

			OuterPommel = Utility:Create("Frame", {
				Name = "OuterPommel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.84, 0),
				Size = UDim2.new(0, 23, 0, 10),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.28,
				BorderSizePixel = 0,
				ZIndex = Settings.OuterSwordZIndex or 2,
				Parent = OuterSwordGroup,
			})
			Utility:Round(OuterPommel, 8)

			if Settings.OuterSwordName ~= false then
				OuterName = Utility:Create("TextLabel", {
					Name = "OuterName",
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBlack,
					Text = Settings.BackgroundLogoName or Settings.Name or "Locito",
					TextColor3 = CurrentTheme.Accent,
					TextTransparency = 0.34,
					TextScaled = true,
					ZIndex = Settings.OuterSwordZIndex or 2,
					Parent = OuterSwordGroup,
				})
			end

			self.OuterSwordLayer = OuterSwordLayer
			self.OuterSword = OuterSwordGroup
		end

		local GlowDisc = Utility:Create("Frame", {
			Name = "GlowDisc",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.82, 0, 0.82, 0),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.BackgroundLogoGlowTransparency or 0.92,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(GlowDisc, BackgroundLogoSize)
		Theme:Register(GlowDisc, "BackgroundColor3", "Accent")

		local OuterRing = Utility:Create("Frame", {
			Name = "OuterRing",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(OuterRing, BackgroundLogoSize)
		local OuterStroke = Utility:Stroke(OuterRing, CurrentTheme.Accent, 2, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(OuterStroke, "Color", "Accent")

		local InnerRing = Utility:Create("Frame", {
			Name = "InnerRing",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.68, 0, 0.68, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(InnerRing, BackgroundLogoSize)
		local InnerStroke = Utility:Stroke(InnerRing, CurrentTheme.AccentLight, 1, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(InnerStroke, "Color", "AccentLight")

		local Diamond = Utility:Create("Frame", {
			Name = "DiamondMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.46, 0, 0.46, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(Diamond, 10)
		local DiamondStroke = Utility:Stroke(Diamond, CurrentTheme.Accent, 2, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(DiamondStroke, "Color", "Accent")

		local InnerDiamond = Utility:Create("Frame", {
			Name = "InnerDiamondMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.28, 0, 0.28, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Utility:Round(InnerDiamond, 7)
		local InnerDiamondStroke = Utility:Stroke(InnerDiamond, CurrentTheme.AccentLight, 1, Settings.BackgroundLogoRingTransparency or 0.72)
		Theme:Register(InnerDiamondStroke, "Color", "AccentLight")

		local SparkGroup = Utility:Create("Frame", {
			Name = "SparkOrbit",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		local SparkDots = {}
		local SparkPositions = {
			{ X = 0.16, Y = 0.3, Size = 5 },
			{ X = 0.5, Y = 0.12, Size = 4 },
			{ X = 0.82, Y = 0.28, Size = 5 },
			{ X = 0.82, Y = 0.72, Size = 6 },
			{ X = 0.5, Y = 0.88, Size = 4 },
			{ X = 0.16, Y = 0.7, Size = 5 },
		}
		for Index, Data in ipairs(SparkPositions) do
			local Spark = Utility:Create("Frame", {
				Name = "Spark" .. Index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(Data.X, 0, Data.Y, 0),
				Size = UDim2.new(0, Data.Size, 0, Data.Size),
				BackgroundColor3 = CurrentTheme.AccentLight,
				BackgroundTransparency = 0.6,
				BorderSizePixel = 0,
				ZIndex = 0,
				Parent = SparkGroup,
			})
			Utility:Round(Spark, Data.Size)
			Theme:Register(Spark, "BackgroundColor3", "AccentLight")
			table.insert(SparkDots, Spark)
		end

		local CrossLine = Utility:Create("Frame", {
			Name = "CrossLine",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 2, 1, -18),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = 0.72,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(CrossLine, "BackgroundColor3", "Accent")

		local HexGroup = Utility:Create("Frame", {
			Name = "HexMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.7, 0, 0.7, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		local HexLines = {}
		for Index, Rotation in ipairs({ 0, 60, -60 }) do
			local HexLine = Utility:Create("Frame", {
				Name = "HexLine" .. Index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = CurrentTheme.Accent,
				BackgroundTransparency = 0.62,
				BorderSizePixel = 0,
				Rotation = Rotation,
				ZIndex = 0,
				Parent = HexGroup,
			})
			Theme:Register(HexLine, "BackgroundColor3", "Accent")
			table.insert(HexLines, HexLine)
		end

		local SwordBaseRotation = Settings.BackgroundSwordRotation or 0
		local SwordTransparency = Settings.BackgroundSwordTransparency or 0.44
		local SwordGroup = Utility:Create("Frame", {
			Name = "SwordStoneMark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, 0, 0.5, 0),
			Size = Settings.BackgroundSwordSize or UDim2.new(0.62, 0, 0.9, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Rotation = SwordBaseRotation,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})

		local Blade = Utility:Create("Frame", {
			Name = "Blade",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.06, 0),
			Size = UDim2.new(0, 10, 0.52, 0),
			BackgroundColor3 = CurrentTheme.AccentLight,
			BackgroundTransparency = SwordTransparency,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Blade, 5)
		Theme:Register(Blade, "BackgroundColor3", "AccentLight")

		local Tip = Utility:Create("Frame", {
			Name = "BladeTip",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.07, 0),
			Size = UDim2.new(0, 22, 0, 22),
			BackgroundColor3 = CurrentTheme.AccentLight,
			BackgroundTransparency = SwordTransparency,
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Tip, 4)
		Theme:Register(Tip, "BackgroundColor3", "AccentLight")

		local Guard = Utility:Create("Frame", {
			Name = "Guard",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.58, 0),
			Size = UDim2.new(0.5, 0, 0, 9),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = math.max(SwordTransparency - 0.04, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Guard, 8)
		Theme:Register(Guard, "BackgroundColor3", "Accent")

		local Grip = Utility:Create("Frame", {
			Name = "Grip",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.58, 0),
			Size = UDim2.new(0, 16, 0.2, 0),
			BackgroundColor3 = CurrentTheme.SurfaceLight,
			BackgroundTransparency = math.max(SwordTransparency - 0.16, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Grip, 6)
		Theme:Register(Grip, "BackgroundColor3", "SurfaceLight")

		local Pommel = Utility:Create("Frame", {
			Name = "Pommel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.78, 0),
			Size = UDim2.new(0, 24, 0, 10),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = math.max(SwordTransparency - 0.04, 0),
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Pommel, 8)
		Theme:Register(Pommel, "BackgroundColor3", "Accent")

		local Stone = Utility:Create("Frame", {
			Name = "Stone",
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, 0),
			Size = UDim2.new(0.62, 0, 0.2, 0),
			BackgroundColor3 = CurrentTheme.SurfaceLight,
			BackgroundTransparency = math.max(SwordTransparency - 0.12, 0),
			BorderSizePixel = 0,
			Rotation = -2,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Utility:Round(Stone, 14)
		Theme:Register(Stone, "BackgroundColor3", "SurfaceLight")

		local StoneStroke = Utility:Stroke(Stone, CurrentTheme.Accent, 1, 0.62)
		Theme:Register(StoneStroke, "Color", "Accent")

		local Inscription = Utility:Create("TextLabel", {
			Name = "Inscription",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.91, 0),
			Size = UDim2.new(0.68, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBlack,
			Text = Settings.BackgroundLogoName or Settings.Name or "Locito",
			TextColor3 = CurrentTheme.Accent,
			TextTransparency = math.max(SwordTransparency - 0.08, 0),
			TextScaled = true,
			ZIndex = 0,
			Parent = SwordGroup,
		})
		Theme:Register(Inscription, "TextColor3", "Accent")

		local Spoke = Utility:Create("Frame", {
			Name = "Spoke",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -18, 0, 2),
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = 0.74,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(Spoke, "BackgroundColor3", "Accent")

		local LogoWatermark = Utility:Create("TextLabel", {
			Name = "LogoWatermark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Settings.BackgroundLogoFont or Enum.Font.GothamBlack,
			Text = BackgroundLogoText,
			TextColor3 = CurrentTheme.Accent,
			TextStrokeColor3 = CurrentTheme.AccentLight,
			TextStrokeTransparency = Settings.BackgroundLogoTextStrokeTransparency or 0.88,
			TextTransparency = Settings.BackgroundLogoTextTransparency or 0.72,
			TextSize = Settings.BackgroundLogoTextSize or math.floor(BackgroundLogoSize * 0.42),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 0,
			Parent = BackgroundLogo,
		})
		Theme:Register(LogoWatermark, "TextColor3", "Accent")
		Theme:Register(LogoWatermark, "TextStrokeColor3", "AccentLight")

		local function ClampNumber(Value, Min, Max, Default)
			local Number = tonumber(Value)
			if not Number then
				return Default
			end
			return math.clamp(Number, Min, Max)
		end

		local function ReadColor(Value, Fallback)
			if typeof(Value) == "Color3" then
				return Value
			end
			return Fallback
		end

		local function ApplyFrame(Object, Color, Transparency)
			if Object then
				Object.BackgroundColor3 = Color
				if Transparency then
					Object.BackgroundTransparency = Transparency
				end
			end
		end

		local function ApplyStroke(Stroke, Color, Transparency, Thickness)
			if Stroke then
				Stroke.Color = Color
				if Transparency then
					Stroke.Transparency = Transparency
				end
				if Thickness then
					Stroke.Thickness = Thickness
				end
			end
		end

		local function GetMaterial()
			local ActiveTheme = Theme:Get()
			local Material = string.lower(tostring(BackgroundLogoState.Material or "Noir"))
			local Primary = ActiveTheme.Accent
			local Secondary = ActiveTheme.AccentLight
			local StoneColor = ActiveTheme.SurfaceLight
			local Transparency = 0.44
			local GlowTransparency = 0.86
			local StrokeTransparency = 0.48

			if Material == "neon" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.AccentLight or ActiveTheme.Accent
				StoneColor = ActiveTheme.Accent
				Transparency = 0.26
				GlowTransparency = 0.78
				StrokeTransparency = 0.22
			elseif Material == "glass" then
				Primary = ActiveTheme.AccentLight or Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.Accent
				StoneColor = ActiveTheme.SurfaceLight
				Transparency = 0.58
				GlowTransparency = 0.9
				StrokeTransparency = 0.6
			elseif Material == "ghost" or Material == "see through" or Material == "see-through" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = ActiveTheme.SubText or Color3.fromRGB(190, 190, 196)
				StoneColor = ActiveTheme.Background
				Transparency = 0.74
				GlowTransparency = 0.94
				StrokeTransparency = 0.72
			elseif Material == "wood" or Material == "wooden" then
				Primary = Color3.fromRGB(214, 170, 104)
				Secondary = Color3.fromRGB(104, 70, 38)
				StoneColor = Color3.fromRGB(61, 42, 27)
				Transparency = 0.36
				GlowTransparency = 0.88
				StrokeTransparency = 0.42
			elseif Material == "chrome" then
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = Color3.fromRGB(150, 150, 158)
				StoneColor = Color3.fromRGB(26, 26, 30)
				Transparency = 0.32
				GlowTransparency = 0.84
				StrokeTransparency = 0.3
			elseif Material == "custom" then
				Transparency = 0.42
				GlowTransparency = 0.84
				StrokeTransparency = 0.36
			else
				Primary = Color3.fromRGB(255, 255, 255)
				Secondary = Color3.fromRGB(18, 18, 22)
				StoneColor = Color3.fromRGB(8, 8, 10)
				Transparency = 0.4
				GlowTransparency = 0.88
				StrokeTransparency = 0.42
			end

			return {
				Primary = ReadColor(BackgroundLogoState.PrimaryColor, Primary),
				Secondary = ReadColor(BackgroundLogoState.SecondaryColor, Secondary),
				Stone = ReadColor(BackgroundLogoState.StoneColor, StoneColor),
				Transparency = ClampNumber(BackgroundLogoState.Transparency, 0.16, 0.9, Transparency),
				GlowTransparency = GlowTransparency,
				StrokeTransparency = StrokeTransparency,
			}
		end

		local function ApplyBackgroundLogoStyle()
			local Material = GetMaterial()
			local Shape = string.lower(tostring(BackgroundLogoState.Shape or "Sword"))
			local Intensity = ClampNumber(BackgroundLogoState.Intensity, 0, 2, 1.25)
			local Transparency = Material.Transparency
			local RingTransparency = math.clamp(Transparency - 0.14, 0.12, 0.92)
			local SoftTransparency = math.clamp(Transparency + 0.16, 0.22, 0.96)
			local HeavyTransparency = math.clamp(Transparency - 0.18, 0.08, 0.86)
			local GlowTransparency = math.clamp(Settings.BackgroundLogoGlowTransparency or (Material.GlowTransparency - Intensity * 0.05), 0.72, 1)
			local StrokeTransparency = math.clamp(Material.StrokeTransparency - Intensity * 0.08, 0.08, 0.88)

			local UsesOuterSword = OuterSwordGroup ~= nil and BackgroundLogoState.OuterSword ~= false
			local ShowsSword = not UsesOuterSword and (Shape == "sword" or Shape == "blade" or Shape == "shatter")
			local ShowsDiamond = Shape == "sword" or Shape == "diamond" or Shape == "cross" or Shape == "shatter"
			local ShowsHex = Shape == "hex" or Shape == "shatter"
			local ShowsCross = Shape == "cross" or Shape == "orbit"
			local ShowsSpoke = Shape ~= "blade" and Shape ~= "hex"

			SwordGroup.Visible = ShowsSword
			Diamond.Visible = ShowsDiamond
			InnerDiamond.Visible = ShowsDiamond
			HexGroup.Visible = ShowsHex
			CrossLine.Visible = ShowsCross
			Spoke.Visible = ShowsSpoke
			LogoWatermark.Visible = Shape ~= "blade"

			SwordGroup.Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, 0, 0.5, 0)
			SwordGroup.Size = Settings.BackgroundSwordSize or (Shape == "blade" and UDim2.new(0.48, 0, 0.92, 0) or UDim2.new(0.62, 0, 0.9, 0))
			Diamond.Size = Shape == "diamond" and UDim2.new(0.58, 0, 0.58, 0) or UDim2.new(0.46, 0, 0.46, 0)
			InnerDiamond.Size = Shape == "diamond" and UDim2.new(0.36, 0, 0.36, 0) or UDim2.new(0.28, 0, 0.28, 0)
			HexGroup.Size = Shape == "shatter" and UDim2.new(0.88, 0, 0.88, 0) or UDim2.new(0.7, 0, 0.7, 0)

			ApplyFrame(GlowDisc, Material.Primary, GlowTransparency)
			ApplyFrame(Blade, Material.Primary, HeavyTransparency)
			ApplyFrame(Tip, Material.Primary, HeavyTransparency)
			ApplyFrame(Guard, Material.Secondary, Transparency)
			ApplyFrame(Grip, Material.Stone, math.clamp(Transparency - 0.16, 0.04, 0.84))
			ApplyFrame(Pommel, Material.Secondary, Transparency)
			ApplyFrame(Stone, Material.Stone, math.clamp(Transparency - 0.1, 0.04, 0.86))
			ApplyFrame(Spoke, Material.Primary, SoftTransparency)
			ApplyFrame(CrossLine, Material.Primary, SoftTransparency)

			for _, Spark in ipairs(SparkDots) do
				ApplyFrame(Spark, Material.Primary, math.clamp(Transparency + 0.08, 0.22, 0.88))
			end

			for _, HexLine in ipairs(HexLines) do
				ApplyFrame(HexLine, Material.Primary, RingTransparency)
			end

			ApplyStroke(OuterStroke, Material.Primary, RingTransparency, Shape == "orbit" and 3 or 2)
			ApplyStroke(InnerStroke, Material.Secondary, SoftTransparency, Shape == "orbit" and 2 or 1)
			ApplyStroke(DiamondStroke, Material.Primary, StrokeTransparency, Shape == "diamond" and 3 or 2)
			ApplyStroke(InnerDiamondStroke, Material.Secondary, SoftTransparency, Shape == "diamond" and 2 or 1)
			ApplyStroke(StoneStroke, Material.Primary, SoftTransparency, 1)

			LogoWatermark.TextColor3 = Material.Primary
			LogoWatermark.TextStrokeColor3 = Material.Secondary
			LogoWatermark.TextTransparency = math.clamp(Transparency + 0.18, 0.42, 0.9)
			LogoWatermark.TextStrokeTransparency = math.clamp(Transparency + 0.28, 0.54, 0.95)
			Inscription.TextColor3 = Material.Primary
			Inscription.TextTransparency = math.clamp(Transparency + 0.02, 0.28, 0.9)

			if OuterSwordGroup then
				OuterSwordGroup.Visible = BackgroundLogoState.OuterSword ~= false
				ApplyFrame(OuterBlade, Material.Primary, math.clamp(Transparency - 0.24, 0.04, 0.78))
				ApplyFrame(OuterTip, Material.Primary, math.clamp(Transparency - 0.24, 0.04, 0.78))
				ApplyFrame(OuterGuard, Material.Secondary, math.clamp(Transparency - 0.1, 0.06, 0.82))
				ApplyFrame(OuterGrip, Material.Stone, math.clamp(Transparency - 0.18, 0.04, 0.82))
				ApplyFrame(OuterPommel, Material.Secondary, math.clamp(Transparency - 0.1, 0.06, 0.82))
				if OuterName then
					OuterName.TextColor3 = Material.Primary
					OuterName.TextTransparency = math.clamp(Transparency + 0.06, 0.22, 0.82)
				end
			end

			BackgroundLogoState._LastMaterial = Material
		end

		self.BackgroundLogo = BackgroundLogo
		self.BackgroundLogoText = LogoWatermark
		self.BackgroundLogoState = BackgroundLogoState
		self.BackgroundLogoStyleApplier = ApplyBackgroundLogoStyle
		ApplyBackgroundLogoStyle()

		local BackgroundThemeDisconnect = Theme:OnChanged(function()
			task.defer(ApplyBackgroundLogoStyle)
		end)
		table.insert(self.Connections, { Disconnect = BackgroundThemeDisconnect })

		table.insert(self.Connections, RunService.RenderStepped:Connect(function(DeltaTime)
			if not BackgroundLogo.Parent then
				return
			end

			local Speed = ClampNumber(BackgroundLogoState.Speed, 0, 90, BackgroundLogoSpeed)
			local Intensity = ClampNumber(BackgroundLogoState.Intensity, 0, 2, 1.25)
			local Material = BackgroundLogoState._LastMaterial or GetMaterial()
			local Transparency = Material.Transparency
			local Rotation = (BackgroundLogo.Rotation + DeltaTime * Speed) % 360
			local Pulse = math.sin(os.clock() * (2.4 + Intensity))
			local Shape = string.lower(tostring(BackgroundLogoState.Shape or "Sword"))
			BackgroundLogo.Rotation = Rotation
			InnerRing.Rotation = -Rotation * 1.35
			Diamond.Rotation = 45 - Rotation * 0.55
			InnerDiamond.Rotation = 45 + Rotation * 0.7
			HexGroup.Rotation = Rotation * 1.2
			CrossLine.Rotation = -Rotation * 1.6
			SparkGroup.Rotation = -Rotation * 1.8
			SwordGroup.Rotation = SwordBaseRotation + math.sin(os.clock() * (1.6 + Intensity * 0.4)) * (2 + Intensity * 3)
			SwordGroup.Position = Settings.BackgroundSwordPosition or UDim2.new(0.5, math.sin(os.clock() * 1.4) * Intensity * 2, 0.5, math.cos(os.clock() * 1.2) * Intensity * 2)
			Blade.BackgroundTransparency = math.clamp(Transparency - 0.18 + Pulse * 0.08, 0.08, 0.86)
			Tip.BackgroundTransparency = Blade.BackgroundTransparency
			for Index, Spark in ipairs(SparkDots) do
				local SparkPulse = math.sin(os.clock() * (3 + Intensity) + Index)
				local SparkSize = 4 + (Index % 3) + math.max(SparkPulse, 0) * Intensity * 3
				Spark.BackgroundTransparency = math.clamp(Transparency + 0.12 + SparkPulse * 0.22, 0.18, 0.9)
				Spark.Size = UDim2.new(0, SparkSize, 0, SparkSize)
			end
			GlowDisc.BackgroundTransparency = math.clamp((Settings.BackgroundLogoGlowTransparency or Material.GlowTransparency or 0.88) + Pulse * 0.05, 0.72, 1)
			GlowDisc.Size = UDim2.new(0.82 + Pulse * 0.04 * Intensity, 0, 0.82 + Pulse * 0.04 * Intensity, 0)
			LogoWatermark.Rotation = -Rotation
			LogoWatermark.TextTransparency = math.clamp(Transparency + 0.18 + Pulse * 0.04, 0.42, 0.9)
			if Shape == "shatter" then
				Spoke.Rotation = 24 + math.sin(os.clock() * 2.8) * 8
			else
				Spoke.Rotation = 0
			end

			if OuterSwordGroup then
				OuterSwordGroup.Visible = self.Visible and BackgroundLogoState.BackgroundVisible ~= false and BackgroundLogoState.OuterSword ~= false
				local OrbitSpeed = ClampNumber(BackgroundLogoState.OuterSwordSpeed, 0, 180, 46)
				local RadiusX = ClampNumber(BackgroundLogoState.OuterSwordRadiusX, 160, 620, (WindowSize.X.Offset / 2) + 78)
				local RadiusY = ClampNumber(BackgroundLogoState.OuterSwordRadiusY, 120, 460, (WindowSize.Y.Offset / 2) + 64)
				local Angle = math.rad(os.clock() * OrbitSpeed)
				local OffsetX = math.cos(Angle) * RadiusX
				local OffsetY = math.sin(Angle) * RadiusY
				local Tilt = math.sin(os.clock() * (2.2 + Intensity)) * (5 + Intensity * 3)

				OuterSwordGroup.Position = UDim2.new(0.5, OffsetX, 0.5, OffsetY)
				OuterSwordGroup.Rotation = math.deg(Angle) + 90 + Tilt
				OuterBlade.BackgroundTransparency = math.clamp(Transparency - 0.24 + Pulse * 0.05, 0.04, 0.78)
				OuterTip.BackgroundTransparency = OuterBlade.BackgroundTransparency
			end
		end))
	end

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
		local AccentLineThemeKey = Settings.AccentLineThemeKey or (PreviewLayout and "Border" or "Accent")
		local AccentLine = Utility:Create("Frame", {
			Name = "AccentLine",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, Settings.AccentLineHeight or 1),
			BackgroundColor3 = CurrentTheme[AccentLineThemeKey] or CurrentTheme.Accent,
			BackgroundTransparency = Settings.AccentLineTransparency or (PreviewLayout and 0.35 or 0.35),
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Theme:Register(AccentLine, "BackgroundColor3", AccentLineThemeKey)
		self.AccentLine = AccentLine
	end

	local LogoY = math.floor((TopBarHeight - LogoSize) / 2)
	if Settings.Logo ~= false and (Settings.LogoGlow == true or (PreviewLayout and Settings.LogoGlow ~= false)) then
		local LogoGlow = Utility:Create("Frame", {
			Name = "LogoGlow",
			BackgroundColor3 = CurrentTheme.Accent,
			BackgroundTransparency = Settings.LogoGlowTransparency or 0.84,
			Position = UDim2.new(0, TopBarPadding - 4, 0, LogoY - 4),
			Size = UDim2.new(0, LogoSize + 8, 0, LogoSize + 8),
			BorderSizePixel = 0,
			Parent = TopBar,
		})
		Utility:Round(LogoGlow, LogoRadius + 6)
		Theme:Register(LogoGlow, "BackgroundColor3", "Accent")
		self.LogoGlow = LogoGlow
	end

	local Logo = Utility:Create("TextLabel", {
		Name = "Logo",
		BackgroundColor3 = CurrentTheme.Surface,
		Position = UDim2.new(0, TopBarPadding, 0, LogoY),
		Size = UDim2.new(0, LogoSize, 0, LogoSize),
		Visible = Settings.Logo ~= false,
		Font = Settings.LogoFont or Enum.Font.GothamBold,
		Text = (Settings.LogoImage or Settings.LogoId) and "" or (Settings.LogoText or "L"),
		TextColor3 = CurrentTheme.AccentLight,
		TextSize = Settings.LogoTextSize or (PreviewLayout and 14 or 18),
		Parent = TopBar,
	})
	Utility:Round(Logo, LogoRadius)
	Theme:Register(Logo, "BackgroundColor3", "Surface")
	Theme:Register(Logo, "TextColor3", "AccentLight")
	self.Logo = Logo

	if Settings.LogoImage or Settings.LogoId then
		local LogoImage = Utility:Create("ImageLabel", {
			Name = "LogoImage",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			Image = Settings.LogoImage or Settings.LogoId,
			ImageColor3 = Settings.LogoImageColor or Color3.fromRGB(255, 255, 255),
			ScaleType = Settings.LogoScaleType or Enum.ScaleType.Fit,
			Parent = Logo,
		})
		self.LogoImage = LogoImage
	end

	local RawTitleText = Settings.Name or Settings.Title or "Locito Hub"
	local TitleText, TitleRichText = BuildTitleText(Settings, CurrentTheme, RawTitleText)
	local HasSubtitle = Settings.Subtitle ~= false and Settings.Subtitle ~= nil
	local TitleY = Settings.TitleY or (HasSubtitle and 9 or math.floor((TopBarHeight - 22) / 2))

	local Title = Utility:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, TitleY),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 22),
		Font = Settings.TitleFont or Enum.Font.GothamBold,
		Text = TitleText,
		TextColor3 = CurrentTheme.Text,
		TextSize = Settings.TitleSize or (PreviewLayout and 14 or 18),
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = TitleRichText,
		Parent = TopBar,
	})
	Theme:Register(Title, "TextColor3", "Text")
	self.Title = Title

	local Subtitle = Utility:Create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, TitleX, 0, 30),
		Size = UDim2.new(1, -TitleX - ControlReserve, 0, 16),
		Visible = HasSubtitle,
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
		Position = UDim2.new(1, -TopBarPadding, 0, math.floor((TopBarHeight - (Settings.ControlSize or (PreviewLayout and 24 or 28))) / 2)),
		Size = UDim2.new(0, Settings.ControlSize or (PreviewLayout and 24 or 28), 0, Settings.ControlSize or (PreviewLayout and 24 or 28)),
		Visible = ShowClose,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Settings.ControlTransparency or (PreviewLayout and 1 or 0),
		Font = Enum.Font.GothamBold,
		Text = Settings.CloseText or (PreviewLayout and "x" or "X"),
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
		Position = UDim2.new(1, ShowClose and -(TopBarPadding + 34) or -TopBarPadding, 0, math.floor((TopBarHeight - (Settings.ControlSize or (PreviewLayout and 24 or 28))) / 2)),
		Size = UDim2.new(0, Settings.ControlSize or (PreviewLayout and 24 or 28), 0, Settings.ControlSize or (PreviewLayout and 24 or 28)),
		Visible = ShowMinimize,
		BackgroundColor3 = CurrentTheme.Surface,
		BackgroundTransparency = Settings.ControlTransparency or (PreviewLayout and 1 or 0),
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
		Position = UDim2.new(0, SidebarX, 0, SidebarY),
		Size = UDim2.new(0, SidebarWidth, 1, SidebarHeightOffset),
		Visible = HasSidebar,
		BackgroundColor3 = CurrentTheme.Secondary,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Utility:Round(Sidebar, Settings.SidebarRadius or (PreviewLayout and 0 or Settings.PanelRadius or Radius))
	Theme:Register(Sidebar, "BackgroundColor3", "Secondary")
	self.Sidebar = Sidebar

	if HasSidebar and (Settings.SidebarDivider == true or (PreviewLayout and Settings.SidebarDivider ~= false)) then
		local SidebarDivider = Utility:Create("Frame", {
			Name = "SidebarDivider",
			Position = UDim2.new(0, SidebarWidth, 0, TopBarHeight),
			Size = UDim2.new(0, 1, 1, -TopBarHeight),
			BackgroundColor3 = CurrentTheme.Border,
			BackgroundTransparency = Settings.SidebarDividerTransparency or 0.45,
			BorderSizePixel = 0,
			Parent = Main,
		})
		Theme:Register(SidebarDivider, "BackgroundColor3", "Border")
		self.SidebarDivider = SidebarDivider
	end

	local SidebarListInset = Settings.SidebarListInset or (PreviewLayout and 8 or 8)
	local SidebarList = Utility:Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, SidebarListInset, 0, SidebarListInset),
		Size = UDim2.new(1, -(SidebarListInset * 2), 1, -(SidebarListInset * 2)),
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
		BackgroundTransparency = Settings.ContentTransparency or (PreviewLayout and 1 or 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})
	Utility:Round(Content, Settings.ContentRadius or Settings.PanelRadius or (PreviewLayout and 0 or Radius))
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
			if self.OuterSwordLayer then
				self.OuterSwordLayer.Position = Position
			end
		end)
	end

	if ShowClose then
		Close.MouseButton1Click:Connect(function()
			self:Destroy()
		end)
	end

	local Minimized = false
	if ShowMinimize then
		Minimize.MouseButton1Click:Connect(function()
			Minimized = not Minimized
			Animation:Play(Main, {
				Size = Minimized and UDim2.new(self.FullSize.X.Scale, self.FullSize.X.Offset, 0, TopBarHeight) or self.FullSize,
			}, { Time = 0.22 })
			if Shadow and self.ShadowFullSize then
				Animation:Play(Shadow, {
					Size = Minimized and UDim2.new(self.ShadowFullSize.X.Scale, self.ShadowFullSize.X.Offset, 0, TopBarHeight + ShadowPadding) or self.ShadowFullSize,
				}, { Time = 0.22 })
			end
		end)
	end

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
		if not self.ToggleKey then return end
		if Processed and Settings.ToggleIgnoresProcessedInput ~= true then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if Input.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end))

	for _, Button in ipairs({ Close, Minimize }) do
		Button.MouseEnter:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().Text }, { Time = 0.12 })
		end)
		Button.MouseLeave:Connect(function()
			Animation:Play(Button, { TextColor3 = Theme:Get().SubText }, { Time = 0.12 })
		end)
	end

	if Settings.Animate == false then
		Main.Size = self.FullSize
		if Shadow and self.ShadowFullSize then
			Shadow.Size = self.ShadowFullSize
		end
	else
		Main.Size = self.HiddenSize
		if Shadow and self.ShadowHiddenSize then
			Shadow.Size = self.ShadowHiddenSize
		end
		Animation:Play(Main, { Size = self.FullSize }, { Time = 0.32 })
		if Shadow and self.ShadowFullSize then
			Animation:Play(Shadow, { Size = self.ShadowFullSize }, { Time = 0.32 })
		end
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

function Window:SetVisible(Visible, Animated)
	if self.Destroyed or not self.Frame then
		return
	end

	if self.Visible == Visible then
		return
	end

	self.Visible = Visible
	local ShouldAnimate = Animated ~= false and self.Settings.ToggleAnimation ~= false

	if Visible then
		self.Frame.Visible = true
		self.Frame.Size = ShouldAnimate and self.HiddenSize or self.FullSize
		if self.OuterSwordLayer then
			self.OuterSwordLayer.Visible = not self.BackgroundLogoState or self.BackgroundLogoState.BackgroundVisible ~= false
		end
		if self.Shadow then
			self.Shadow.Visible = true
			self.Shadow.Size = ShouldAnimate and self.ShadowHiddenSize or self.ShadowFullSize
		end

		if ShouldAnimate then
			Animation:Play(self.Frame, { Size = self.FullSize }, { Time = self.ToggleTime })
			if self.Shadow and self.ShadowFullSize then
				Animation:Play(self.Shadow, { Size = self.ShadowFullSize }, { Time = self.ToggleTime })
			end
		end
	else
		if ShouldAnimate then
			Animation:Play(self.Frame, { Size = self.HiddenSize }, { Time = self.ToggleTime })
			if self.Shadow and self.ShadowHiddenSize then
				Animation:Play(self.Shadow, { Size = self.ShadowHiddenSize }, { Time = self.ToggleTime })
			end

			task.delay(self.ToggleTime + 0.03, function()
				if not self.Visible and self.Frame then
					self.Frame.Visible = false
				end
				if not self.Visible and self.Shadow then
					self.Shadow.Visible = false
				end
				if not self.Visible and self.OuterSwordLayer then
					self.OuterSwordLayer.Visible = false
				end
			end)
		else
			self.Frame.Visible = false
			if self.Shadow then
				self.Shadow.Visible = false
			end
			if self.OuterSwordLayer then
				self.OuterSwordLayer.Visible = false
			end
		end
	end
end

function Window:Show(Animated)
	self:SetVisible(true, Animated)
end

function Window:Hide(Animated)
	self:SetVisible(false, Animated)
end

function Window:Toggle(Animated)
	self:SetVisible(not self.Visible, Animated)
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
	self.FullSize = Size
	if not self.CustomHiddenSize then
		self.HiddenSize = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
	end
	self.Frame.Size = self.Visible and Size or self.HiddenSize
	if self.Shadow then
		self.ShadowFullSize = Size + UDim2.new(0, self.ShadowPadding, 0, self.ShadowPadding)
		self.ShadowHiddenSize = UDim2.new(Size.X.Scale, Size.X.Offset + self.ShadowPadding, 0, self.ShadowPadding)
		self.Shadow.Size = self.Visible and self.ShadowFullSize or self.ShadowHiddenSize
	end
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Size = Size
	end
end

function Window:SetPosition(Position)
	self.Frame.Position = Position
	if self.Shadow then
		self.Shadow.Position = Position
	end
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Position = Position
	end
end

function Window:SetTheme(Name)
	return Theme:Set(Name)
end

function Window:SetLogoText(Text)
	if self.Logo then
		self.Logo.Text = Text
		self.Logo.Visible = true
	end
	if self.LogoImage then
		self.LogoImage.Visible = false
	end
end

function Window:SetLogoImage(Image, Color)
	if not self.Logo then
		return
	end

	self.Logo.Visible = true
	self.Logo.Text = ""

	if not self.LogoImage then
		self.LogoImage = Utility:Create("ImageLabel", {
			Name = "LogoImage",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			ScaleType = Enum.ScaleType.Fit,
			Parent = self.Logo,
		})
	end

	self.LogoImage.Visible = true
	self.LogoImage.Image = Image
	if Color then
		self.LogoImage.ImageColor3 = Color
	end
end

function Window:SetBackgroundLogoVisible(Visible)
	if self.BackgroundLogoState then
		self.BackgroundLogoState.BackgroundVisible = Visible == true
	end
	if self.BackgroundLogo then
		self.BackgroundLogo.Visible = Visible == true
	end
	if self.OuterSwordLayer then
		self.OuterSwordLayer.Visible = Visible == true and self.Visible == true
	end
end

function Window:SetBackgroundAnimation(Options)
	if not self.BackgroundLogoState or typeof(Options) ~= "table" then
		return false
	end

	local State = self.BackgroundLogoState
	for Key, Value in pairs(Options) do
		if Key == "Shape" or Key == "Material" then
			if typeof(Value) == "string" and Value ~= "" then
				State[Key] = Value
				if Key == "Material" and string.lower(Value) ~= "custom" then
					State.PrimaryColor = nil
					State.SecondaryColor = nil
					State.StoneColor = nil
				end
			end
		elseif Key == "Speed" or Key == "Intensity" or Key == "Transparency" or Key == "OuterSwordSpeed" or Key == "OuterSwordRadiusX" or Key == "OuterSwordRadiusY" then
			local Number = tonumber(Value)
			if Number then
				State[Key] = Number
			end
		elseif Key == "OuterSword" then
			State.OuterSword = Value == true
		elseif Key == "PrimaryColor" or Key == "SecondaryColor" or Key == "StoneColor" then
			if typeof(Value) == "Color3" then
				State[Key] = Value
				State.Material = "Custom"
			end
		end
	end

	if self.BackgroundLogoStyleApplier then
		self.BackgroundLogoStyleApplier()
	end

	return true
end

function Window:SetBackgroundLogoShape(Shape)
	return self:SetBackgroundAnimation({ Shape = Shape })
end

function Window:SetBackgroundLogoMaterial(Material)
	return self:SetBackgroundAnimation({ Material = Material })
end

function Window:SetToggleKey(Key)
	self.ToggleKey = ResolveKeyCode(Key)
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

	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	self.Connections = {}

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

function LocitoUI:SetThemeColor(Key, Color)
	return Theme:SetColor(Key, Color)
end

function LocitoUI:SetThemeColors(Values)
	return Theme:SetColors(Values)
end

return LocitoUI
