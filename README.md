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

## Folder Structure

```text
LocitoUI
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
│   └── Test.lua
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

## Loadstring Usage

If you are running LocitoUI as one direct script instead of as a ModuleScript folder, use the standalone bundle:

```lua
local LocitoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/dist/LocitoUI.lua"))()
```

To run the included demo window directly:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Xggzy/LocitoUI1/main/Examples/Executor.lua"))()
```

See `Examples/Executor.lua` for a full window example.

## GitHub Usage

After this repository is pushed, you can download it from GitHub and place the `LocitoUI` folder into `ReplicatedStorage`.

This library is meant for Roblox LocalScripts. It does not depend on exploit-only file APIs.
