local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerModule = require(ReplicatedStorage.Shared.PlayerModule)
local OnPlayerInventoryUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerInventoryUpdated

-- CONSTANT
local PROXIMITY_ACTION = "Mining"
local MINING_SOUND_ID = "rbxassetid://8766809464"
local PICKAXE_SOUND_ID = "rbxassetid://7650217335"

-- MEMBERS
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://101002567023789"

local isPressing = false

local function playMiningSound()
	local miningSound = Instance.new("Sound", game.Workspace)
	miningSound.SoundId = MINING_SOUND_ID
	local random = Random.new()
	local value = random:NextNumber(0.5, 1)

	miningSound.Pitch = value
	miningSound:Play()
end

local function playPickaxeSound()
	local pickaxeSound = Instance.new("Sound", game.Workspace)
	pickaxeSound.SoundId = PICKAXE_SOUND_ID
	local random = Random.new()
	local value = random:NextNumber(1, 1.2)

	pickaxeSound.Pitch = value
	pickaxeSound:Play()
end

local function onPromptHoldBegan(promptObject: ProximityPrompt, player: Player)
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	local humanoid = player.Character.Humanoid
	local humanoidAnimator = humanoid.Animator
	local animationTrack = humanoidAnimator:LoadAnimation(animation)

	isPressing = true
	while isPressing do
		animationTrack:Play(nil, nil, 1.5)
		playPickaxeSound()
		task.wait(0.5)
	end
end

local function onPromptHoldEnded(promptObject: ProximityPrompt, player: Player)
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	isPressing = false
end

local function onPromptTriggered(promptObject: ProximityPrompt, player: Player)
	if promptObject.Name ~= PROXIMITY_ACTION then
		return
	end

	local miningModel = promptObject.Parent

	PlayerModule.AddToInventory(player, miningModel.Name, miningModel.Amount.Value)

	playMiningSound()
	task.wait(0.5)

	local inventory = PlayerModule.GetInventory(player)
	print(PlayerModule.GetInventory(player))
	OnPlayerInventoryUpdated:FireClient(player, inventory)

	miningModel:Destroy()
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
ProximityPromptService.PromptButtonHoldBegan:Connect(onPromptHoldBegan)
ProximityPromptService.PromptButtonHoldEnded:Connect(onPromptHoldEnded)
