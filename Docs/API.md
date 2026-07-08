# LocitoUI API

## Create a Window

```lua
local Window = LocitoUI.new({
    Name = "Locito Hub",
    Subtitle = "Original UI library",
    LogoText = "L",
    -- LogoImage = "rbxassetid://123456789",
    Width = 680,
    Height = 450,
    SidebarWidth = 160,
    Padding = 14,
    Gap = 14,
    Draggable = true,
    CloseButton = true,
    MinimizeButton = true,
    ToggleKey = "RightControl",
    ToggleAnimationTime = 0.2,
})
```

Runtime helpers:

```lua
Window:SetTitle("New title")
Window:SetSubtitle("New subtitle")
Window:SetSize(UDim2.new(0, 560, 0, 360))
Window:SetPosition(UDim2.new(0.5, 0, 0.5, 0))
Window:SetTheme("Ocean")
Window:SetLogoText("LC")
Window:SetLogoImage("rbxassetid://123456789")
Window:SetToggleKey("RightControl")
Window:SetBackgroundLogoVisible(true)
Window:SetBackgroundLogoShape("Hex")
Window:SetBackgroundLogoMaterial("Neon")
Window:SetBackgroundAnimation({
    Speed = 24,
    Intensity = 0.75,
    Transparency = 0.78,
    OuterSword = true,
    OuterSwordSpeed = 42,
    OuterSwordRadiusX = 430,
    OuterSwordRadiusY = 296,
    PrimaryColor = Color3.fromRGB(255, 255, 255),
})
LocitoUI:SetAccent(Color3.fromRGB(0, 218, 222))
LocitoUI:SetThemeColor("Background", Color3.fromRGB(8, 10, 14))
LocitoUI:SetThemeColors({
    Surface = Color3.fromRGB(16, 19, 25),
    SurfaceLight = Color3.fromRGB(28, 32, 42),
    Border = Color3.fromRGB(33, 38, 48),
})
Window:Hide()
Window:Show()
Window:Toggle()
```

## Themes

Built-in themes:

- `Nebula`
- `Carbon`
- `Ocean`
- `Emerald`
- `Noir`
- `Phantom`

```lua
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

LocitoUI:SetTheme("Candy")
LocitoUI:SetAccent(Color3.fromRGB(0, 157, 255))
print(table.concat(LocitoUI:GetThemes(), ", "))
```

Compact dark preset:

```lua
local Window = LocitoUI.new({
    Name = "Locito Hub",
    TitleAccent = "Hub",
    Version = "v2.0",
    Subtitle = false,
    Theme = "Noir",
    Layout = "Preview",
    LogoText = "L",
    ToggleKey = "RightControl",
    Width = 672,
    Height = 430,
    SidebarWidth = 160,
    TopBarHeight = 54,
    TabHeight = 40,
    TabStyle = "Pill",
    PageSlideOffset = 8,
    BorderThickness = 1,
    RowStrokeTransparency = 0.82,
    SidebarDividerTransparency = 0.76,
    AccentLineThemeKey = "Border",
    AccentLineTransparency = 0.68,
    LogoGlow = false,
    BackgroundLogo = true,
    BackgroundLogoText = "LC",
    BackgroundLogoImage = "rbxassetid://123456789",
    BackgroundLogoImageTransparency = 0.42,
    BackgroundLogoName = "Locito",
    BackgroundLogoSize = 190,
    BackgroundLogoPosition = UDim2.new(0.66, 0, 0.56, 0),
    BackgroundLogoShape = "Orbit",
    BackgroundLogoMaterial = "Noir",
    BackgroundLogoIntensity = 0.75,
    BackgroundLogoTransparency = 0.78,
    BackgroundLogoGlowTransparency = 0.99,
    BackgroundLogoTextTransparency = 0.86,
    BackgroundLogoTextStrokeTransparency = 0.94,
    BackgroundLogoRotationSpeed = 24,
    BackgroundSwordPosition = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundSwordRotation = 0,
    BackgroundSwordTransparency = 0.42,
    OuterSword = true,
    OuterSwordSpeed = 42,
    OuterSwordRadiusX = 430,
    OuterSwordRadiusY = 296,
    Shadow = true,
    ShadowTransparency = 0.74,
})
```

Background animation options:

- Shapes: `Sword`, `Diamond`, `Orbit`, `Hex`, `Cross`, `Shatter`
- Materials: `Noir`, `Neon`, `Glass`, `Ghost`, `Chrome`, `Wood`
- Outside sword: `OuterSword`, `OuterSwordSpeed`, `OuterSwordRadiusX`, `OuterSwordRadiusY`

## Loadstring

Use the standalone bundle when you do not have the full ModuleScript folder available:

The GitHub repository must be public for `game:HttpGet` to download these files.

```lua
local LocitoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua"))()
```

To show the included demo window directly:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/Examples/Executor.lua?v=" .. tostring(os.time())))()
```

## Tabs

```lua
local Tab = Window:CreateTab("Home", "⌂")
```

Aliases:

```lua
Window:Tab("Home")
Window:Page("Home")
```

## Sections

```lua
local Section = Tab:CreateSection({
    Name = "Main",
    Padding = 10,
    ItemSpacing = 6,
    ShowTitle = true,
})
```

Alias:

```lua
Tab:Section("Main")
```

## Button

```lua
Section:Button({
    Text = "Click me",
    Height = 34,
    Style = "Accent",
    Callback = function()
        print("Clicked")
    end,
})
```

Methods:

```lua
Button:SetText("New text")
Button:SetCallback(function() end)
Button:SetEnabled(false)
```

## Toggle

```lua
local Toggle = Section:Toggle({
    Text = "Enabled",
    Default = false,
    Changed = function(Value)
        print(Value)
    end,
})

Toggle:Set(true)
print(Toggle:Get())
```

## Slider

```lua
local Slider = Section:Slider({
    Text = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Step = 5,
    Suffix = "%",
    Changed = function(Value)
        print(Value)
    end,
})
```

Methods:

```lua
Slider:Set(75)
Slider:SetBounds(0, 200)
print(Slider:Get())
```

## Textbox

```lua
Section:Textbox({
    Placeholder = "Type here...",
    Changed = function(Text, EnterPressed)
        print(Text, EnterPressed)
    end,
})
```

## Dropdown

```lua
Section:Dropdown({
    Text = "Theme",
    Options = { "Nebula", "Carbon", "Ocean", "Emerald" },
    Default = "Nebula",
    Changed = function(Value)
        LocitoUI:SetTheme(Value)
    end,
})
```

## Keybind

```lua
Section:Keybind({
    Text = "Menu key",
    Default = "RightControl",
    Callback = function(Key, ChangedBind)
        if ChangedBind then
            Window:SetToggleKey(Key)
        end
    end,
})
```

## Color Picker

```lua
Section:ColorPicker({
    Text = "Accent",
    ApplyToTheme = true,
    Presets = {
        Color3.fromRGB(155, 90, 255),
        Color3.fromRGB(0, 157, 255),
        Color3.fromRGB(39, 212, 121),
    },
    Changed = function(Color)
        print(Color)
    end,
})
```

Use `ApplyToTheme = "Background"` or any other theme color key to make a color picker update that part of the active theme directly.

## Notifications

```lua
Window:Notify("Title", "Message", 4, "Success")
```

Kinds:

- `Info`
- `Success`
- `Warning`
- `Error`
