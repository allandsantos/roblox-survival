local PlayerModule = {}

-- SERVICES
local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerLoadedBindableEvent: BindableEvent = ServerStorage.BindableEvents.PlayerLoaded
local playerUnloadedBindableEvent: BindableEvent = ServerStorage.BindableEvents.PlayerUnloaded

local OnPlayerHungerUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerHungerUpdated
local OnPlayerInventoryUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerInventoryUpdated
local OnPlayerLevelUp: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerLevelUp

-- CONSTANTS
local PLAYER_DEFAULT_DATA = {
	hunger = 100,
	inventory = {},
	level = 1,
	health = 100,
}

-- MEMBERS
local playersOnline = {}
local database = dataStoreService:GetDataStore("Players")

local function NormalizeHungerValue(hunger: number)
	if hunger < 0 then
		hunger = 0
	end

	if hunger > 100 then
		hunger = 100
	end

	return hunger
end

function PlayerModule.OnPlayerLoaded(): BindableEvent
	return playerLoadedBindableEvent
end

function PlayerModule.OnPlayerUnloaded(): BindableEvent
	return playerUnloadedBindableEvent
end

function PlayerModule.IsPlayerLoaded(player: Player)
	return playersOnline[player.UserId]
end

function PlayerModule.GetLocalPlayer(): Player
	return players.LocalPlayer
end

function PlayerModule.GetHunger(player: Player): number
	return NormalizeHungerValue(playersOnline[player.UserId].hunger)
end

function PlayerModule.IncrementHunger(player: Player, hunger: number): number
	hunger = NormalizeHungerValue(hunger)
	local playerHunger = NormalizeHungerValue(playersOnline[player.UserId].hunger)
	playersOnline[player.UserId].hunger = NormalizeHungerValue(playerHunger + hunger)
end

function PlayerModule.DecrementHunger(player: Player, hunger: number): number
	hunger = NormalizeHungerValue(hunger)
	local playerHunger = NormalizeHungerValue(playersOnline[player.UserId].hunger)
	playersOnline[player.UserId].hunger = NormalizeHungerValue(playerHunger - hunger)
end

function PlayerModule.AddToInventory(player: Player, key: string, value: number)
	local inventory = playersOnline[player.UserId].inventory
	if not inventory[key] then
		inventory[key] = 0
	end

	inventory[key] += value
end

function PlayerModule.GetInventory(player: Player)
	return playersOnline[player.UserId].inventory
end

function PlayerModule.GetLevel(player: Player)
	return playersOnline[player.UserId].level
end

function PlayerModule.SetLevel(player: Player, level: number)
	playersOnline[player.UserId].level = level
end

local function OnPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(_)
		local data = database:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		data.level = 1
		data.hunger = data.hunger > 0 and data.hunger or 100
		playersOnline[player.UserId] = data

		playerLoadedBindableEvent:Fire(player)
		OnPlayerHungerUpdated:FireClient(player, data.hunger)
		OnPlayerInventoryUpdated:FireClient(player, data.inventory)
		OnPlayerLevelUp:FireClient(player, data.level)
	end)
end

local function OnPlayerRemoving(player: Player)
	playerUnloadedBindableEvent:Fire(player)

	local userData = playersOnline[player.UserId]
	database:SetAsync(player.UserId, userData)

	playersOnline[player.UserId] = nil
end

players.PlayerAdded:Connect(OnPlayerAdded)
players.PlayerRemoving:Connect(OnPlayerRemoving)

return PlayerModule
