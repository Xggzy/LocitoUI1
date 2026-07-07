# LocitoUI API

## Create a Window

```lua
local Window = LocitoUI.new({
    Name = "Locito Hub",
    Subtitle = "Original UI library",
    LogoText = "L",
})
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
local Section = Tab:CreateSection("Main")
```

Alias:

```lua
Tab:Section("Main")
```

## Button

```lua
Section:Button({
    Text = "Click me",
    Callback = function()
        print("Clicked")
    end,
})
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
    Changed = function(Value)
        print(Value)
    end,
})
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
    Text = "Toggle UI",
    Default = "RightControl",
    Callback = function(Key, ChangedBind)
        if not ChangedBind then
            Window:Toggle()
        end
    end,
})
```

## Color Picker

```lua
Section:ColorPicker({
    Text = "Accent",
    Changed = function(Color)
        print(Color)
    end,
})
```

## Notifications

```lua
Window:Notify("Title", "Message", 4, "Success")
```

Kinds:

- `Info`
- `Success`
- `Warning`
- `Error`
