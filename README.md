# LocitoUI

LocitoUI is an original Roblox UI library built from scratch. It is designed to be clean, modular, and easy to expand.

## Status

Current version: `0.2.0`

Built so far:

- Theme system
- Utility system
- Animation system
- Window system
- Tabs
- Sections
- Buttons
- Toggles
- Sliders
- Labels
- Paragraphs
- Dividers
- Textboxes
- Dropdowns
- Keybinds
- Simple color picker
- Notifications
- In-memory config module
- Premium `Phantom` and `Noir` style presets
- Animated background logo mark
- Image-backed background logo support
- Runtime theme color editing
- Runtime background animation controls

## Folder Structure

```text
LocitoUI
├── Assets
│   └── locito-hub-logo.png
├── src
│   ├── init.lua
│   ├── Window.lua
│   ├── Theme.lua
│   ├── Utility.lua
│   ├── Animation.lua
│   ├── Notification.lua
│   ├── Config.lua
│   └── Components
│       ├── Button.lua
│       ├── Toggle.lua
│       ├── Slider.lua
│       ├── Dropdown.lua
│       ├── Textbox.lua
│       ├── Keybind.lua
│       ├── ColorPicker.lua
│       ├── Label.lua
│       ├── Paragraph.lua
│       ├── Divider.lua
│       ├── Section.lua
│       └── Tab.lua
├── Examples
│   ├── Executor.lua
│   └── Test.lua
├── dist
│   └── LocitoUI.lua
├── tools
│   └── build_standalone.py
└── Docs
    └── API.md
```

## Basic Usage

Put the `LocitoUI` folder inside `ReplicatedStorage`, then require it from a LocalScript.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocitoUI = require(ReplicatedStorage:WaitForChild("LocitoUI"):WaitForChild("src"))

local Window = LocitoUI.new({
    Name = "Locito Hub",
    Subtitle = "Original UI library",
    LogoText = "L",
})

local Player = Window:CreateTab("Player")
local Movement = Player:CreateSection("Movement")

Movement:Button({
    Text = "Print hello",
    Callback = function()
        print("Hello from LocitoUI")
    end,
})
```

## Customization

You can add themes, adjust the window layout, and customize individual controls.

For a compact fancy black/white layout, use the built-in `Noir` theme with `Layout = "Preview"`:

```lua
local Window = LocitoUI.new({
    Name = "Locito Hub",
    TitleAccent = "Hub",
    Version = "v2.0",
    Subtitle = false,
    Theme = "Noir",
    Layout = "Preview",
    LogoText = "L",
    -- LogoImage = "rbxassetid://123456789",
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
    ToggleKey = "RightControl",
    ToggleAnimationTime = 0.18,
})
```

You can also change these at runtime:

```lua
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

The included demo also has a dedicated `Theme` tab, outside sword orbit controls, background shape/material animation controls, live status labels for ping/FPS/network, a `Menu key` keybind, an animated logo toggle, and a local feature search box.

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

local Window = LocitoUI.new({
    Name = "Custom Hub",
    Theme = "Candy",
    Width = 560,
    Height = 360,
    SidebarWidth = 130,
    Padding = 12,
    Gap = 10,
    Animate = false,
})

local Main = Window:CreateTab("Main"):CreateSection({
    Name = "Tuned Controls",
    Padding = 10,
    ItemSpacing = 6,
})

Main:Button({
    Text = "Accent button",
    Style = "Accent",
    Height = 34,
})

Main:Slider({
    Text = "Walk speed",
    Min = 16,
    Max = 100,
    Default = 32,
    Step = 2,
    Suffix = " studs",
})

Main:ColorPicker({
    Text = "Accent",
    ApplyToTheme = true,
    Presets = {
        Color3.fromRGB(255, 120, 210),
        Color3.fromRGB(0, 157, 255),
        Color3.fromRGB(39, 212, 121),
    },
})
```

## Loadstring Usage

If you are running LocitoUI as one direct script instead of as a ModuleScript folder, use the standalone bundle:

The GitHub repository must be public for `game:HttpGet` to download these files.

```lua
local LocitoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua"))()
```

To run the included demo window directly:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/Examples/Executor.lua?v=" .. tostring(os.time())))()
```

See `Examples/Executor.lua` for a full window example.

## GitHub Usage

After this repository is pushed, you can download it from GitHub and place the `LocitoUI` folder into `ReplicatedStorage`.

This library is meant for Roblox LocalScripts. It does not depend on exploit-only file APIs.
