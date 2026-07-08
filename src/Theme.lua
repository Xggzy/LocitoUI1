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

return Theme
