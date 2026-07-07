-- LocitoUI Window System
-- Version 0.1.0

local Window = {}
Window.__index = Window


local Players = game:GetService("Players")

local Utility = require(script.Parent.Utility)
local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Tab = require(script.Parent.Components.Tab)

--------------------------------------------------
-- Create Window
--------------------------------------------------

function Window.new(Settings)

	local self = setmetatable({}, Window)


	self.Settings = Settings or {}

	self.Tabs = {}


	--------------------------------------------------
	-- Screen GUI
	--------------------------------------------------

	local Player = Players.LocalPlayer

	local Gui = Instance.new("ScreenGui")

	Gui.Name = "LocitoUI"

	Gui.ResetOnSpawn = false

	Gui.Parent = Player.PlayerGui


	self.Gui = Gui


	--------------------------------------------------
	-- Main Window
	--------------------------------------------------

	local Frame = Instance.new("Frame")

	Frame.Name = "MainWindow"

	Frame.Size = UDim2.new(
		0,
		650,
		0,
		420
	)

	Frame.Position = UDim2.new(
		0.5,
		-325,
		0.5,
		-210
	)

	Frame.BackgroundColor3 =
		Theme:Get().Background


	Frame.Parent = Gui


	Utility:Round(
		Frame,
		Theme:Get().CornerRadius
	)


	Utility:Stroke(
		Frame,
		Theme:Get().Border
	)


	self.Frame = Frame


	--------------------------------------------------
	-- Title Bar
	--------------------------------------------------

	local Title = Instance.new("TextLabel")

	Title.Size = UDim2.new(
		1,
		0,
		0,
		50
	)

	Title.BackgroundTransparency = 1

	Title.Text =
		self.Settings.Name or "LocitoUI"

	Title.TextColor3 =
		Theme:Get().Text

	Title.TextSize = 22

	Title.Font =
		Enum.Font.GothamBold


	Title.Parent = Frame


	--------------------------------------------------
	-- Sidebar
	--------------------------------------------------

	local Sidebar = Instance.new("Frame")

	Sidebar.Name = "Sidebar"

	Sidebar.Position =
		UDim2.new(
			0,
			10,
			0,
			60
		)

	Sidebar.Size =
		UDim2.new(
			0,
			150,
			1,
			-70
		)

	Sidebar.BackgroundColor3 =
		Theme:Get().Secondary


	Sidebar.Parent = Frame


	Utility:Round(
		Sidebar,
		10
	)


	self.Sidebar = Sidebar


	--------------------------------------------------
	-- Content
	--------------------------------------------------

	local Content = Instance.new("Frame")

	Content.Name = "Content"

	Content.Position =
		UDim2.new(
			0,
			170,
			0,
			60
		)

	Content.Size =
		UDim2.new(
			1,
			-180,
			1,
			-70
		)


	Content.BackgroundTransparency = 1

	Content.Parent = Frame


	self.Content = Content


	--------------------------------------------------
	-- Dragging
	--------------------------------------------------

	local Dragging = false
	local Start
	local StartPos


	Title.InputBegan:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = true

			Start = Input.Position

			StartPos = Frame.Position

		end

	end)


	Title.InputEnded:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = false

		end

	end)


	game:GetService("UserInputService")
	.InputChanged:Connect(function(Input)

		if Dragging and
			Input.UserInputType ==
			Enum.UserInputType.MouseMovement then


			local Delta =
				Input.Position - Start


			Frame.Position =
				StartPos +
				UDim2.new(
					0,
					Delta.X,
					0,
					Delta.Y
				)

		end

	end)


	Animation:FadeIn(Frame)
function Window:CreateTab(Name, Icon)

    return Tab.new(
        self,
        Name,
        Icon
    )

end

	return self

end


return Window