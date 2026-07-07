-- LocitoUI Theme System
-- Version 0.1.0

local Theme = {}

Theme.Current = "Nebula"

Theme.Themes = {

    Nebula = {
        Background = Color3.fromRGB(12, 12, 18),
        Secondary = Color3.fromRGB(20, 20, 30),
        Surface = Color3.fromRGB(28, 28, 42),

        Accent = Color3.fromRGB(155, 90, 255),
        AccentLight = Color3.fromRGB(190, 140, 255),

        Text = Color3.fromRGB(255,255,255),
        SubText = Color3.fromRGB(160,160,170),

        Border = Color3.fromRGB(70,70,90),

        CornerRadius = 12,

        AnimationSpeed = 0.25
    },

    Carbon = {
        Background = Color3.fromRGB(10,10,10),
        Secondary = Color3.fromRGB(20,20,20),
        Surface = Color3.fromRGB(30,30,30),

        Accent = Color3.fromRGB(255,80,80),
        AccentLight = Color3.fromRGB(255,130,130),

        Text = Color3.fromRGB(255,255,255),
        SubText = Color3.fromRGB(150,150,150),

        Border = Color3.fromRGB(60,60,60),

        CornerRadius = 12,

        AnimationSpeed = 0.25
    }

}


function Theme:Get()
    return self.Themes[self.Current]
end


function Theme:Set(Name)

    if self.Themes[Name] then
        self.Current = Name
        return true
    end

    return false
end


return Theme