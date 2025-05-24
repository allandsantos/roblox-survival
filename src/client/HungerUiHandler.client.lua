local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnPlayerHungerUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerHungerUpdated

-- CONSTANTS
local BAR_FULL_COLOR = Color3.fromRGB(25, 190, 0)
local BAR_MID_COLOR = Color3.fromRGB(190, 114, 0)
local BAR_LOW_COLOR = Color3.fromRGB(190, 0, 0)

-- MEMBERS
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Hud: ScreenGui = PlayerGui:WaitForChild("HUD")
local LeftBar: Frame = Hud:WaitForChild("LeftBar")
local HungerUi: Frame = LeftBar:WaitForChild("Hunger")
local HungerBar: Frame = HungerUi:WaitForChild("Bar")
local HungerBarMaxSize = HungerBar.Size.X.Scale

local function ResizeHungerBar(hunger: number)
	hunger = hunger >= 0 and hunger or 0
	local size = (HungerBarMaxSize * hunger) / 100
	HungerBar.Size = UDim2.fromScale(size, HungerBar.Size.Y.Scale)
end

local function SetupHungerBarColor(hunger: number)
	if hunger > 60 then
		HungerBar.BackgroundColor3 = BAR_FULL_COLOR
	elseif hunger > 30 then
		HungerBar.BackgroundColor3 = BAR_MID_COLOR
	else
		HungerBar.BackgroundColor3 = BAR_LOW_COLOR
	end
end

OnPlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
	ResizeHungerBar(hunger)
	SetupHungerBarColor(hunger)
end)
