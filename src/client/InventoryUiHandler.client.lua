local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnPlayerInventoryUpdated: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerInventoryUpdated

-- CONSTANTS

-- MEMBERS
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Hud: ScreenGui = PlayerGui:WaitForChild("HUD")
local LeftBar: Frame = Hud:WaitForChild("LeftBar")
local InventoryUi: Frame = LeftBar:WaitForChild("Inventory")
local InventoryButton: ImageButton = InventoryUi:WaitForChild("Button")
local InventoryWindow: Frame = Hud:WaitForChild("Inventory")
local InventoryOriginalPosition: number = InventoryWindow.Position.X.Scale
InventoryWindow.Position = UDim2.fromScale(-1, InventoryWindow.Position.Y.Scale)

-- OnPlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
-- 	ResizeHungerBar(hunger)
-- 	SetupHungerBarColor(hunger)
-- end)

-- InventoryButton.MouseEnter:Connect(function()
-- 	print("mouse entrou")
-- end)

-- InventoryButton.MouseLeave:Connect(function()
-- 	print("mouse saiu")
-- end)

InventoryButton.MouseButton1Click:Connect(function()
	InventoryWindow.Visible = not InventoryWindow.Visible
	if InventoryWindow.Visible then
		InventoryWindow:TweenPosition(UDim2.fromScale(InventoryOriginalPosition, InventoryWindow.Position.Y.Scale))
	else
		InventoryWindow:TweenPosition(UDim2.fromScale(-1, InventoryWindow.Position.Y.Scale))
	end
end)

OnPlayerInventoryUpdated.OnClientEvent:Connect(function(inventory)
	for key, value in inventory do
		local itemFrame: Frame = InventoryWindow:FindFirstChild(key)
		local itemAmmout: TextLabel = itemFrame:FindFirstChild("Ammount")
		itemAmmout.Text = value
	end
end)
