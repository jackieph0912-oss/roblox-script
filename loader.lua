-- FAKE ROBLOX BAN SCREEN
-- Chi hien GUI troll, khong ban that

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local old = player.PlayerGui:FindFirstChild("FakeBanTroll")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FakeBanTroll"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = player.PlayerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
bg.Parent = gui

local message = Instance.new("TextLabel")
message.Size = UDim2.fromScale(0.85, 0.35)
message.Position = UDim2.fromScale(0.075, 0.25)
message.BackgroundTransparency = 1
message.TextColor3 = Color3.new(1, 1, 1)
message.TextScaled = true
message.TextWrapped = true
message.Font = Enum.Font.GothamBold
message.Text = "Account Banned\n\nReason: Stealing Scripts\n\nJust kidding! 😂"
message.Parent = bg

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(180, 45)
close.Position = UDim2.new(0.5, -90, 0.75, 0)
close.BackgroundColor3 = Color3.fromRGB(65, 120, 240)
close.TextColor3 = Color3.new(1, 1, 1)
close.Text = "OK 😂"
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.Parent = bg

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
