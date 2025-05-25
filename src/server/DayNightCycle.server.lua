-- CONSTANTS
local WAIT_INTERVAL = 1 / 60

-- MEMBERS
local MinutesAfterMidnight: number

while true do
	MinutesAfterMidnight = game.Lighting:GetMinutesAfterMidnight() + 0.3
	game.Lighting:SetMinutesAfterMidnight(MinutesAfterMidnight)

	task.wait(WAIT_INTERVAL)
end
