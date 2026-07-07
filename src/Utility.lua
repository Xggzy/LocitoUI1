-- LocitoUI Utility System
-- Version 0.2.0

local Utility = {}

local UserInputService = game:GetService("UserInputService")

function Utility:GetService(ServiceName)
	return game:GetService(ServiceName)
end

function Utility:Create(ClassName, Properties, Children)
	local Object = Instance.new(ClassName)
	local Parent = Properties and Properties.Parent

	for Property, Value in pairs(Properties or {}) do
		if Property ~= "Parent" then
			Object[Property] = Value
		end
	end

	for _, Child in ipairs(Children or {}) do
		Child.Parent = Object
	end

	if Parent ~= nil then
		Object.Parent = Parent
	end

	return Object
end

function Utility:Round(Object, Radius)
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, Radius or 12)
	Corner.Parent = Object
	return Corner
end

function Utility:Stroke(Object, Color, Thickness, Transparency)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color or Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = Thickness or 1
	Stroke.Transparency = Transparency or 0
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = Object
	return Stroke
end

function Utility:Padding(Object, Amount)
	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, Amount or 0)
	Padding.PaddingBottom = UDim.new(0, Amount or 0)
	Padding.PaddingLeft = UDim.new(0, Amount or 0)
	Padding.PaddingRight = UDim.new(0, Amount or 0)
	Padding.Parent = Object
	return Padding
end

function Utility:List(Object, Padding, Direction)
	local Layout = Instance.new("UIListLayout")
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, Padding or 6)
	Layout.FillDirection = Direction or Enum.FillDirection.Vertical
	Layout.Parent = Object
	return Layout
end

function Utility:SafeCall(Callback, ...)
	if typeof(Callback) ~= "function" then
		return
	end

	local Success, Result = pcall(Callback, ...)
	if not Success then
		warn("[LocitoUI] Callback error:", Result)
	end
	return Result
end

function Utility:Callback(Callback, ...)
	return self:SafeCall(Callback, ...)
end

function Utility:Destroy(Object)
	if Object and Object.Destroy then
		Object:Destroy()
	end
end

function Utility:MakeDraggable(Handle, Target, OnMove)
	local Dragging = false
	local DragStart
	local StartPosition
	local Connections = {}

	table.insert(Connections, Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Target.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end))

	table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then return end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local Delta = Input.Position - DragStart
		Target.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)

		if OnMove then
			OnMove(Target.Position)
		end
	end))

	return function()
		for _, Connection in ipairs(Connections) do
			Connection:Disconnect()
		end
	end
end

function Utility:AutoCanvas(ScrollingFrame, Layout, Extra)
	local function Update()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + (Extra or 12))
	end

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Update)
	Update()
end

return Utility
