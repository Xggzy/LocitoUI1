-- LocitoUI private-game server hooks.
-- Put this in ServerScriptService in your own Roblox place.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ADMIN_USER_IDS = {
	-- Replace this with your Roblox UserId.
	-- [123456789] = true,
}

local Remote = ReplicatedStorage:FindFirstChild("LocitoAdminCommand")
if Remote and not Remote:IsA("RemoteEvent") then
	Remote:Destroy()
	Remote = nil
end

if not Remote then
	Remote = Instance.new("RemoteEvent")
	Remote.Name = "LocitoAdminCommand"
	Remote.Parent = ReplicatedStorage
end

local PlayerState = {}

local function IsAdmin(Player)
	if ADMIN_USER_IDS[Player.UserId] then
		return true
	end

	if game.CreatorType == Enum.CreatorType.User and Player.UserId == game.CreatorId then
		return true
	end

	return false
end

local function AttributeName(Command)
	return "Locito_" .. tostring(Command):gsub("[^%w_]", "_")
end

local function GetState(Player)
	PlayerState[Player] = PlayerState[Player] or {}
	return PlayerState[Player]
end

local function ApplyCharacterState(Player)
	local State = GetState(Player)
	local Character = Player.Character
	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end

	if typeof(State["Player.WalkSpeed"]) == "number" then
		Humanoid.WalkSpeed = math.clamp(State["Player.WalkSpeed"], 16, 120)
	end

	if typeof(State["Player.JumpPower"]) == "number" then
		pcall(function()
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = math.clamp(State["Player.JumpPower"], 50, 180)
		end)
	end
end

local function SetState(Player, Command, Value)
	local State = GetState(Player)
	State[Command] = Value
	Player:SetAttribute(AttributeName(Command), Value)

	if Command == "Player.WalkSpeed" or Command == "Player.JumpPower" then
		ApplyCharacterState(Player)
	end
end

Remote.OnServerEvent:Connect(function(Player, Command, Value)
	if not IsAdmin(Player) then
		return
	end

	if typeof(Command) ~= "string" or #Command > 80 then
		return
	end

	SetState(Player, Command, Value)
end)

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function()
		task.wait(0.2)
		ApplyCharacterState(Player)
	end)
end)

for _, Player in ipairs(Players:GetPlayers()) do
	Player.CharacterAdded:Connect(function()
		task.wait(0.2)
		ApplyCharacterState(Player)
	end)
end

Players.PlayerRemoving:Connect(function(Player)
	PlayerState[Player] = nil
end)

RunService.Heartbeat:Connect(function()
	for Player, State in pairs(PlayerState) do
		if State["Player.NoClip"] == true and Player.Character then
			for _, Object in ipairs(Player.Character:GetDescendants()) do
				if Object:IsA("BasePart") then
					Object.CanCollide = false
				end
			end
		end
	end
end)
