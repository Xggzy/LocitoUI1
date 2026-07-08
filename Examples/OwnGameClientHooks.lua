-- LocitoUI private-game client hooks.
-- Put this in StarterPlayerScripts in your own Roblox place.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local KeysDown = {}
local FlyVelocity
local FlyGyro

local function GetCharacterParts()
	local Character = LocalPlayer.Character
	if not Character then
		return nil, nil, nil
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Root = Character:FindFirstChild("HumanoidRootPart")
	return Character, Humanoid, Root
end

local function IsEnabled(Attribute)
	return LocalPlayer:GetAttribute(Attribute) == true
end

local function StopFly()
	local _, Humanoid = GetCharacterParts()
	if Humanoid then
		Humanoid.PlatformStand = false
	end

	if FlyVelocity then
		FlyVelocity:Destroy()
		FlyVelocity = nil
	end

	if FlyGyro then
		FlyGyro:Destroy()
		FlyGyro = nil
	end
end

local function EnsureFly(Root)
	if FlyVelocity and FlyVelocity.Parent == Root then
		return
	end

	StopFly()

	FlyVelocity = Instance.new("BodyVelocity")
	FlyVelocity.MaxForce = Vector3.new(90000, 90000, 90000)
	FlyVelocity.Velocity = Vector3.zero
	FlyVelocity.Parent = Root

	FlyGyro = Instance.new("BodyGyro")
	FlyGyro.MaxTorque = Vector3.new(90000, 90000, 90000)
	FlyGyro.P = 9000
	FlyGyro.CFrame = Root.CFrame
	FlyGyro.Parent = Root
end

UserInputService.InputBegan:Connect(function(Input, Processed)
	if Processed then
		return
	end
	KeysDown[Input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(Input)
	KeysDown[Input.KeyCode] = nil
end)

UserInputService.JumpRequest:Connect(function()
	if not IsEnabled("Locito_Player_InfiniteJump") then
		return
	end

	local _, Humanoid = GetCharacterParts()
	if Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

RunService.RenderStepped:Connect(function()
	local _, Humanoid, Root = GetCharacterParts()
	if not Humanoid or not Root then
		StopFly()
		return
	end

	if not IsEnabled("Locito_Player_Fly") then
		StopFly()
		return
	end

	EnsureFly(Root)

	local Camera = workspace.CurrentCamera
	local Direction = Vector3.zero
	if KeysDown[Enum.KeyCode.W] then Direction += Camera.CFrame.LookVector end
	if KeysDown[Enum.KeyCode.S] then Direction -= Camera.CFrame.LookVector end
	if KeysDown[Enum.KeyCode.D] then Direction += Camera.CFrame.RightVector end
	if KeysDown[Enum.KeyCode.A] then Direction -= Camera.CFrame.RightVector end
	if KeysDown[Enum.KeyCode.Space] then Direction += Vector3.yAxis end
	if KeysDown[Enum.KeyCode.LeftControl] then Direction -= Vector3.yAxis end

	local Speed = LocalPlayer:GetAttribute("Locito_Player_WalkSpeed") or 48
	if Direction.Magnitude > 0 then
		FlyVelocity.Velocity = Direction.Unit * math.clamp(Speed, 16, 120)
	else
		FlyVelocity.Velocity = Vector3.zero
	end

	FlyGyro.CFrame = Camera.CFrame
	Humanoid.PlatformStand = true
end)

LocalPlayer.CharacterAdded:Connect(function()
	StopFly()
end)
