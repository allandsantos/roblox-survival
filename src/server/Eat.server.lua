local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerModule = require(ReplicatedStorage.Shared.PlayerModule)
local OnPlayerHungerUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerHungerUpdated

-- CONSTANT
local PROXIMITY_ACTION = "Eat"
local EATING_SOUND_ID = "rbxassetid://5363075887"

local function playEatingSound()
	local eatingSound = Instance.new("Sound", game.Workspace)
	eatingSound.SoundId = EATING_SOUND_ID
	local random = Random.new()
	local value = random:NextNumber(0.5, 1)

	eatingSound.Pitch = value
	eatingSound:Play()
end

local function onPromptTriggered(promptObject: ProximityPrompt, player)
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	local foodModel = promptObject.Parent
	local foodValue = foodModel.Food.Value

	playEatingSound()

	PlayerModule.IncrementHunger(player, foodValue)
	local hunger = PlayerModule.GetHunger(player)
	OnPlayerHungerUpdated:FireClient(player, hunger)

	print(foodModel.Name)
	print(foodValue)

	foodModel:Destroy()
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
