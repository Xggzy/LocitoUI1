-- LocitoUI Utility System
-- Version 0.1.0

local Utility = {}

--------------------------------------------------
-- Roblox Services
--------------------------------------------------

function Utility:GetService(Service)
	return game:GetService(Service)
end


--------------------------------------------------
-- Instance Creator
--------------------------------------------------

function Utility:Create(Class, Properties)

	local Object = Instance.new(Class)

	for Property, Value in pairs(Properties or {}) do
		Object[Property] = Value
	end

	return Object
end


--------------------------------------------------
-- Rounded Corners
--------------------------------------------------

function Utility:Round(Object, Radius)

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(
		0,
		Radius or 12
	)

	Corner.Parent = Object

	return Corner
end


--------------------------------------------------
-- UI Stroke
--------------------------------------------------

function Utility:Stroke(Object, Color, Thickness)

	local Stroke = Instance.new("UIStroke")

	Stroke.Color = Color or Color3.fromRGB(255,255,255)

	Stroke.Thickness = Thickness or 1

	Stroke.Parent = Object

	return Stroke
end


--------------------------------------------------
-- Padding
--------------------------------------------------

function Utility:Padding(Object, Amount)

	local Padding = Instance.new("UIPadding")

	Padding.PaddingTop = UDim.new(0,Amount)
	Padding.PaddingBottom = UDim.new(0,Amount)
	Padding.PaddingLeft = UDim.new(0,Amount)
	Padding.PaddingRight = UDim.new(0,Amount)

	Padding.Parent = Object

	return Padding
end


--------------------------------------------------
-- Cleanup
--------------------------------------------------

function Utility:Destroy(Object)

	if Object then
		Object:Destroy()
	end

end


--------------------------------------------------
-- Safe Callback
--------------------------------------------------

function Utility:Callback(Function, ...)

	if typeof(Function) == "function" then

		local Success, ErrorMessage = pcall(
			Function,
			...
		)

		if not Success then
			warn(
				"LocitoUI Error:",
				ErrorMessage
			)
		end

	end

end


return Utility