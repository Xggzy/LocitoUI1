-- LocitoUI Notification System
-- Version 0.2.0

local Notification = {}

local Utility = require(script.Parent.Utility)
local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)

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

return Notification
