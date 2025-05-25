local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerModule = require(ReplicatedStorage.Shared.PlayerModule)
local OnPlayerLevelUp: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerLevelUp

-- CONSTANT
local PROXIMITY_ACTION = "Upgrade"
local MAX_LEVEL = 3
local UPGRADE_REQUIRED = {
	[2] = {
		Stone = 1,
	},
	[3] = {
		Wood = 1,
		Copper = 1,
	},
}

-- MEMBERS

local function onPromptTriggered(promptObject: ProximityPrompt, player: Player)
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	local currentPlayerLevel = PlayerModule.GetLevel(player)
	if currentPlayerLevel == MAX_LEVEL then
		return
	end

	local nextLevel = currentPlayerLevel + 1
	local inventory = PlayerModule.GetInventory(player)
	local itemsRequiredToUpgrade = UPGRADE_REQUIRED[nextLevel]
	for key, value in itemsRequiredToUpgrade do
		local inventoryAmmount = inventory[key]
		if value > inventoryAmmount then
			return
		end
	end

	for key, value in itemsRequiredToUpgrade do
		inventory[key] -= value
	end

	PlayerModule.SetLevel(player, nextLevel)
	OnPlayerLevelUp:FireClient(player, nextLevel)
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
