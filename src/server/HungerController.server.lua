-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerModule = require(ReplicatedStorage.Shared.PlayerModule)
local OnPlayerLoadedEvent = PlayerModule.OnPlayerLoaded().Event
local OnPlayerUnloadedEvent = PlayerModule.OnPlayerUnloaded().Event
local OnPlayerHungerUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerHungerUpdated

-- CONSTANTS
local CORE_LOOP_INTERVAL = 1
local HUNGER_DECREMENT = 1

OnPlayerLoadedEvent:Connect(function(player: Player)
	task.spawn(function()
		local isRunning = true

		OnPlayerUnloadedEvent:Connect(function(playerUnloaded)
			if playerUnloaded == playerUnloaded then
				isRunning = false
			end
		end)

		while isRunning do
			pcall(function()
				if PlayerModule.IsPlayerLoaded(player) then
					PlayerModule.DecrementHunger(player, HUNGER_DECREMENT)
					print(PlayerModule.GetHunger(player))
					OnPlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
				end
			end)

			task.wait(CORE_LOOP_INTERVAL)
		end
	end)
end)
