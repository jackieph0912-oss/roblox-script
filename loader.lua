-- APPLE FARM V7.1 + KEY SYSTEM | XENO
-- Nhap dung 1 trong 5 key de mo Apple Farm
-- Luu y: Xac thuc key tren client chi la khoa giao dien.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local VALID_KEYS = {
    ["kjZzYz4Bnee6prJX"] = true,
    ["KoBd63iyUzQvPtyO"] = true,
    ["o96Vl9L5TTgGz9Bo"] = true,
    ["GrDilD2RPAyqFgxJ"] = true,
    ["rBxzUH1MDKlukDdy"] = true,
}

local previous = pg:FindFirstChild("AppleFarmKeyGate")
if previous then previous:Destroy() end

local function startAppleFarm()

    -- APPLE FARM V7.1 | XENO
    -- Tu di chuyen den Apple + Noclip
    -- Khong goi remote, khong cho nhat

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local env = getgenv and getgenv() or _G

    -- Dung cac ban cu khi chay lai
    for _, key in ipairs({
        "AppleFarmV71Stop",
        "AppleFarmV8Stop"
    }) do
        if type(env[key]) == "function" then
            pcall(env[key])
        end
    end

    -- CONFIG
    local SPEED = 65
    local HEIGHT_OFFSET = 0
    local ARRIVE_DISTANCE = 0.8
    local TARGET_TIMEOUT = 3

    local enabled = false
    local target = nil
    local targetTimer = 0
    local skipped = {}

    local farmConnection
    local noclipConnection
    local characterConnection
    local gui

    -- Luu trang thai va cham ban dau
    local originalCollision = {}

    local VALID_APPLES = {
        Apple_GreenStreak = true,
        Apple_Frost = true,
        Apple_GoldenSparkle = true,
        Apple_RedSpeckle = true,
        Apple_Flame = true,
        Apple_Candy = true,
        Apple_Rainbow = true,
        Apple_Diamond = true,
        Apple_Galaxy = true,
        Apple_Snowflake = true,
        Apple_Toxic = true,
        Apple_Shadow = true,
    }

    local function getRoot()
        local char = player.Character
        local hum = char and
            char:FindFirstChildOfClass("Humanoid")
        local root = char and
            char:FindFirstChild("HumanoidRootPart")

        if hum and hum.Health > 0 and root then
            return root, char, hum
        end
    end

    local function getFolder()
        return workspace:FindFirstChild("AutumnApples")
    end

    local function getPart(model)
        if not model or not model.Parent then
            return nil
        end

        return model.PrimaryPart
            or model:FindFirstChildWhichIsA(
                "BasePart", true
            )
    end

    local function nearestApple(root)
        local folder = getFolder()
        if not folder then return nil, 0 end

        local best
        local bestDist = math.huge
        local count = 0

        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model")
                and VALID_APPLES[model.Name] then

                local part = getPart(model)

                if part then
                    count = count + 1

                    if not skipped[model] then
                        local distance =
                            (root.Position - part.Position).Magnitude

                        if distance < bestDist then
                            bestDist = distance
                            best = model
                        end
                    end
                end
            end
        end

        return best, count
    end

    -- =========================
    -- NOCLIP
    -- =========================

    local function applyNoclip()
        if not enabled then return end

        local _, char = getRoot()
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollision[part] == nil then
                    originalCollision[part] = part.CanCollide
                end

                part.CanCollide = false
            end
        end
    end

    local function restoreCollision()
        for part, state in pairs(originalCollision) do
            if part and part.Parent then
                pcall(function()
                    part.CanCollide = state
                end)
            end
        end

        table.clear(originalCollision)
    end

    local function startNoclip()
        if noclipConnection then
            noclipConnection:Disconnect()
        end

        applyNoclip()

        noclipConnection = RunService.Stepped:Connect(function()
            if enabled then
                applyNoclip()
            end
        end)
    end

    local function stopNoclip()
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        restoreCollision()
    end

    -- =========================
    -- GUI
    -- =========================

    for _, name in ipairs({
        "AppleFarmV71",
        "AppleFarmV8",
        "AppleFarmV7",
        "AppleFarmV6",
        "AppleFarmV5"
    }) do
        local old = playerGui:FindFirstChild(name)
        if old then
            old:Destroy()
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "AppleFarmV71"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(270, 275)
    frame.Position = UDim2.new(0.5, -135, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(23,26,36)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius =
        UDim.new(0, 12)

    local function label(text, y)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.fromOffset(250, 24)
        l.Position = UDim2.fromOffset(10, y)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.new(1,1,1)
        l.Font = Enum.Font.Gotham
        l.TextSize = 12
        l.Parent = frame
        return l
    end

    local function button(text, x, y, w, h)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(w,h)
        b.Position = UDim2.fromOffset(x,y)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 =
            Color3.fromRGB(55,105,180)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.Parent = frame

        Instance.new("UICorner",b).CornerRadius =
            UDim.new(0,8)

        return b
    end

    local title = label("APPLE MOVE V7.1 | NOCLIP",8)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local toggle = button("OFF",15,38,240,40)
    toggle.BackgroundColor3 =
        Color3.fromRGB(185,45,45)

    local speedMinus = button("SPEED -",15,88,115,32)
    local speedPlus = button("SPEED +",140,88,115,32)

    local heightMinus = button("HEIGHT -",15,129,115,32)
    local heightPlus = button("HEIGHT +",140,129,115,32)

    local speedLabel = label("Speed: 65",170)
    local heightLabel = label("Height offset: 0",191)
    local noclipLabel = label("Noclip: OFF",211)
    local countLabel = label("Apples: 0",231)
    local status = label("Ready",251)

    local function resetTarget()
        target = nil
        targetTimer = 0
    end

    local function updateToggle()
        toggle.Text = enabled and "ON" or "OFF"

        toggle.BackgroundColor3 = enabled
            and Color3.fromRGB(35,175,80)
            or Color3.fromRGB(185,45,45)

        noclipLabel.Text = enabled
            and "Noclip: ON"
            or "Noclip: OFF"
    end

    local function stopFarm()
        enabled = false

        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end

        stopNoclip()
        resetTarget()

        updateToggle()
        status.Text = "Stopped"
    end

    local function startFarm()
        stopFarm()

        if not getFolder() then
            status.Text = "AutumnApples not found"
            return
        end

        enabled = true
        skipped = {}
        resetTarget()

        updateToggle()
        startNoclip()

        farmConnection = RunService.Heartbeat:Connect(function(dt)
            if not enabled then return end

            local root = getRoot()
            if not root then return end

            if not target or not getPart(target) then
                resetTarget()

                local nextApple, count = nearestApple(root)
                countLabel.Text = "Apples: "..count

                if not nextApple then
                    skipped = {}
                    status.Text = "Waiting for apples..."
                    return
                end

                target = nextApple
            end

            local part = getPart(target)
            if not part then
                resetTarget()
                return
            end

            targetTimer = targetTimer + dt

            -- Giu nguyen toa do cua V7
            local destination = Vector3.new(
                part.Position.X,
                part.Position.Y + HEIGHT_OFFSET,
                part.Position.Z
            )

            local delta = destination - root.Position
            local distance = delta.Magnitude

            status.Text = "Moving: "..target.Name

            if distance > ARRIVE_DISTANCE then
                local step = math.min(
                    SPEED * math.min(dt,0.1),
                    distance
                )

                local nextPosition =
                    root.Position + delta.Unit * step

                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                root.CFrame = CFrame.new(nextPosition)
            else
                -- Den vi tri Apple la chuyen qua khac
                -- Khong cho, khong goi remote
                skipped[target] = true
                resetTarget()
            end

            if targetTimer >= TARGET_TIMEOUT then
                if target then
                    skipped[target] = true
                end
                resetTarget()
            end
        end)
    end

    toggle.MouseButton1Click:Connect(function()
        if enabled then
            stopFarm()
        else
            startFarm()
        end
    end)

    speedMinus.MouseButton1Click:Connect(function()
        SPEED = math.max(10,SPEED-10)
        speedLabel.Text = "Speed: "..SPEED
    end)

    speedPlus.MouseButton1Click:Connect(function()
        SPEED = math.min(2000,SPEED+10)
        speedLabel.Text = "Speed: "..SPEED
    end)

    heightMinus.MouseButton1Click:Connect(function()
        HEIGHT_OFFSET = math.max(-5, HEIGHT_OFFSET-0.25)

        heightLabel.Text = string.format(
            "Height offset: %.2f", HEIGHT_OFFSET
        )
    end)

    heightPlus.MouseButton1Click:Connect(function()
        HEIGHT_OFFSET = math.min(4, HEIGHT_OFFSET+0.25)

        heightLabel.Text = string.format(
            "Height offset: %.2f", HEIGHT_OFFSET
        )
    end)

    characterConnection = player.CharacterAdded:Connect(function()
        restoreCollision()
        resetTarget()
        skipped = {}

        if enabled then
            task.wait(0.5)
            applyNoclip()
        end
    end)

    local function stopScript()
        stopFarm()

        if characterConnection then
            characterConnection:Disconnect()
            characterConnection = nil
        end

        if gui and gui.Parent then
            gui:Destroy()
        end
    end

    env.AppleFarmV71Stop = stopScript

    gui.Destroying:Connect(function()
        stopFarm()
    end)

    print("Apple Farm V7.1 loaded")

end -- startAppleFarm

local screen = Instance.new("ScreenGui")
screen.Name = "AppleFarmKeyGate"
screen.ResetOnSpawn = false
screen.DisplayOrder = 120
screen.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(335, 225)
frame.Position = UDim2.new(0.5, -167, 0.5, -112)
frame.BackgroundColor3 = Color3.fromRGB(22, 27, 39)
frame.Active = true
frame.Draggable = true
frame.Parent = screen
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 13)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 150, 255)
stroke.Thickness = 2
stroke.Parent = frame

local function label(text, y, h, size)
    local obj = Instance.new("TextLabel")
    obj.Size = UDim2.fromOffset(305, h)
    obj.Position = UDim2.fromOffset(15, y)
    obj.BackgroundTransparency = 1
    obj.Text = text
    obj.TextColor3 = Color3.fromRGB(240, 245, 255)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = size
    obj.Parent = frame
    return obj
end
label("APPLE FARM | KEY SYSTEM", 13, 32, 17)
label("Nhap 1 trong 5 key de mo menu farm", 46, 25, 12)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.fromOffset(295, 42)
keyBox.Position = UDim2.fromOffset(20, 83)
keyBox.BackgroundColor3 = Color3.fromRGB(36, 43, 58)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.PlaceholderText = "Nhap key tai day..."
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = frame
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(295, 42)
button.Position = UDim2.fromOffset(20, 137)
button.BackgroundColor3 = Color3.fromRGB(40, 135, 225)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "XAC NHAN KEY"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

local status = label("Status: Dang cho key", 187, 25, 12)
local unlocked = false

local function verify()
    if unlocked then return end
    local entered = keyBox.Text:match("^%s*(.-)%s*$")
    if not VALID_KEYS[entered] then
        status.Text = "KEY SAI! Thu lai."
        status.TextColor3 = Color3.fromRGB(255, 85, 85)
        return
    end
    unlocked = true
    status.Text = "Key dung! Dang mo Apple Farm..."
    status.TextColor3 = Color3.fromRGB(80, 245, 140)
    button.Text = "DA XAC NHAN"
    task.defer(function()
        local ok, err = pcall(startAppleFarm)
        if ok then
            if screen.Parent then screen:Destroy() end
        else
            warn("[APPLE FARM KEY] Failed to start:", err)
            status.Text = "Loi mo farm: xem console"
            status.TextColor3 = Color3.fromRGB(255, 85, 85)
            unlocked = false
            button.Text = "THU LAI"
        end
    end)
end
button.MouseButton1Click:Connect(verify)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then verify() end
end)
