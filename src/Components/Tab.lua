-- LocitoUI Tab System
-- Version 0.1.0

local Tab = {}
Tab.__index = Tab


local Utility = require(script.Parent.Parent.Utility)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Section = require(script.Parent.Section)

function Tab.new(Window, Name, Icon)

	local self = setmetatable({}, Tab)


	self.Window = Window
	self.Name = Name
	self.Icon = Icon


	--------------------------------------------------
	-- Sidebar Button
	--------------------------------------------------

	local Button = Instance.new("TextButton")

	Button.Name = Name .. "_Tab"

	Button.Size = UDim2.new(
		1,
		-20,
		0,
		40
	)

	Button.BackgroundColor3 =
		Theme:Get().Surface

	Button.Text =
		Name

	Button.TextColor3 =
		Theme:Get().Text

	Button.Font =
		Enum.Font.GothamMedium

	Button.TextSize = 14

	Button.Parent =
		Window.Sidebar


	Utility:Round(Button, 8)


	self.Button = Button


	--------------------------------------------------
	-- Page Container
	--------------------------------------------------

	local Page = Instance.new("ScrollingFrame")

	Page.Name = Name .. "_Page"

	Page.Size =
		UDim2.new(
			1,
			0,
			1,
			0
		)

	Page.BackgroundTransparency = 1

	Page.ScrollBarThickness = 2

	Page.Visible = false

	Page.Parent =
		Window.Content


	local Layout =
		Instance.new("UIListLayout")


	Layout.Padding =
		UDim.new(
			0,
			10
		)


	Layout.Parent = Page


	self.Page = Page


	--------------------------------------------------
	-- Tab Switching
	--------------------------------------------------

	Button.MouseButton1Click:Connect(function()

		for _, Existing in pairs(Window.Tabs) do

			Existing.Page.Visible = false

		end


		Page.Visible = true


		Animation:FadeIn(Page)


	end)


	table.insert(
		Window.Tabs,
		self
	)


	--------------------------------------------------
	-- First Tab Opens
	--------------------------------------------------

	if #Window.Tabs == 1 then

		Page.Visible = true

	end

function Tab:CreateSection(Name)

	return Section.new(
		self,
		Name
	)

end
	return self

end


return Tab