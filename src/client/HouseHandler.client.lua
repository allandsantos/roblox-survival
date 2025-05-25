local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HomeStorage = ReplicatedStorage.HomeStorage
local OnPlayerLevelUp: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerLevelUp

local function onPLayerLevelUp(level)
	local currentHome = workspace.Home:FindFirstChild(level - 1)
	if currentHome then
		currentHome:Destroy()
	end

	local home: Model = HomeStorage:FindFirstChild(level):Clone()
	home.Parent = workspace.Home
end

OnPlayerLevelUp.OnClientEvent:Connect(onPLayerLevelUp)
