
-- KEY SYSTEM V1 | ROBLOX / XENO
-- GUI nhap key, kiem tra key va mo menu

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- CAU HINH
local CORRECT_KEY = "kjZzYz4Bnee6prJX","KoBd63iyUzQvPtyO","o96Vl9L5TTgGz9Bo","GrDilD2RPAyqFgxJ","rBxzUH1MDKlukDdy"

local old = pg:FindFirstChild("AppleKeySystem")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AppleKeySystem"
gui.ResetOnSpawn = false
gui.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(320, 220)
frame.Position = UDim2.new(0.5, -160, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 150, 255)
stroke.Thickness = 2
stroke.Parent = frame

local function label(text, y, h, size)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.fromOffset(290, h)
    l.Position = UDim2.fromOffset(15, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamBold
    l.TextSize = size
    l.Parent = frame
    return l
end

label("APPLE FARM | KEY SYSTEM", 15, 35, 18)
label("Nhap key de mo khoa", 50, 25, 12)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.fromOffset(280, 42)
keyBox.Position = UDim2.fromOffset(20, 87)
keyBox.BackgroundColor3 = Color3.fromRGB(36, 43, 58)
keyBox.PlaceholderText = "Nhap key tai day..."
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = frame
Instance.new("UICorner", keyBox).CornerRadius =
    UDim.new(0, 9)

local check = Instance.new("TextButton")
check.Size = UDim2.fromOffset(280, 40)
check.Position = UDim2.fromOffset(20, 140)
check.Text = "XAC NHAN KEY"
check.BackgroundColor3 = Color3.fromRGB(40, 135, 225)
check.TextColor3 = Color3.new(1,1,1)
check.Font = Enum.Font.GothamBold
check.TextSize = 14
check.Parent = frame
Instance.new("UICorner",check).CornerRadius =
    UDim.new(0, 9)

local status = label("Status: Waiting...", 187, 22, 12)

local function unlock()
    status.Text = "KEY DUNG - DA MO KHOA!"
    status.TextColor3 = Color3.fromRGB(65, 245, 130)

    task.wait(0.7)

    if frame.Parent then
        frame.Visible = false
    end

    -- THEM CODE CHAY SAU KHI KEY DUNG TAI DAY
    -- Vi du:
    -- startAppleFarm()
end

local checking = false

local function verify()
    if checking then return end
    checking = true

    local entered = keyBox.Text:match("^%s*(.-)%s*$")

    if entered == CORRECT_KEY then
        unlock()
    else
        status.Text = "KEY SAI! VUI LONG THU LAI."
        status.TextColor3 = Color3.fromRGB(255, 85, 85)
        checking = false
    end
end

check.MouseButton1Click:Connect(verify)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verify()
    end
end)

-- Nut mo lai menu
local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(65, 35)
reopen.Position = UDim2.fromOffset(10, 120)
reopen.Text = "KEY"
reopen.BackgroundColor3 = Color3.fromRGB(35, 110, 195)
reopen.TextColor3 = Color3.new(1,1,1)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 12
reopen.Parent = gui
Instance.new("UICorner",reopen).CornerRadius =
    UDim.new(0, 9)

reopen.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

print("[KEY SYSTEM] Loaded")
