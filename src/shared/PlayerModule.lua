local PlayerModule = {}

-- SERVICES
local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local serverStorage = game:GetService("ServerStorage")
local playerLoadedBindableEvent: BindableEvent = serverStorage.BindableEvents.PlayerLoaded
local playerUnloadedBindableEvent: BindableEvent = serverStorage.BindableEvents.PlayerUnloaded

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

local function OnPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(_)
		playerLoadedBindableEvent:Fire(player)
		local data = database:GetAsync(player.UserId)
		-- if not data then
		data = PLAYER_DEFAULT_DATA
		-- end

		playersOnline[player.UserId] = data
		print(playersOnline[player.UserId])
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
