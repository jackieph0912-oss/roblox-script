-- APPLE FARM | MODERN V8 + 5 KEY
-- Compact UI, drag by header, minimize, ON/OFF, speed, height, noclip.
-- Client-side key gate with local saved key (if executor file API is available).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local env = (getgenv and getgenv()) or _G

for _, key in ipairs({"AppleModernV8Stop", "AppleFarmV71Stop", "AppleFarmV8Stop", "AppleAutoBuyMinimalV7Stop"}) do
    if type(env[key]) == "function" then pcall(env[key]) end
end
for _, name in ipairs({"AppleModernV8", "AppleFarmKeyGate", "AppleFarmV71", "AppleAutoBuyMinimalV7"}) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- Admin: doi true -> false de khoa key trong BAN SCRIPT NAY.
-- Luu y: key bi khoa chi khi nguoi dung chay code moi.
local VALID_KEYS = {
    ["kjZzYz4Bnee6prJX"] = true,
    ["KoBd63iyUzQvPtyO"] = false,
    ["o96Vl9L5TTgGz9Bo"] = true,
    ["GrDilD2RPAyqFgxJ"] = true,
    ["pFCygj10Juhmum6H"] = true,
    ["wVPDSYnr4QyJj0kg"] = true,
    ["rBxzUH1MDKlukDdy"] = false,
}

-- Luu key tren MAY DANG CHAY script, khong phai tren server chung.
local SAVE_FILE = "AppleFarmV8_SavedKey.txt"
local function readSavedKey()
    if type(readfile) ~= "function" then return nil end
    local ok, content = pcall(readfile, SAVE_FILE)
    if not ok or type(content) ~= "string" then return nil end
    return content:match("^%s*(.-)%s*$")
end
local function saveKey(key)
    if type(writefile) ~= "function" then return false end
    return pcall(writefile, SAVE_FILE, key)
end

local C = {
    bg = Color3.fromRGB(15, 19, 29), panel = Color3.fromRGB(23, 29, 42),
    field = Color3.fromRGB(33, 41, 57), outline = Color3.fromRGB(58, 71, 91),
    text = Color3.fromRGB(239, 244, 252), muted = Color3.fromRGB(153, 169, 191),
    blue = Color3.fromRGB(79, 133, 255), green = Color3.fromRGB(41, 185, 119),
    red = Color3.fromRGB(224, 86, 100)
}

local gui = Instance.new("ScreenGui")
gui.Name = "AppleModernV8"
gui.ResetOnSpawn = false
gui.DisplayOrder = 150
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function round(obj, radius)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, radius or 10)
    u.Parent = obj
end
local function border(obj)
    local s = Instance.new("UIStroke")
    s.Color = C.outline
    s.Thickness = 1
    s.Transparency = 0.25
    s.Parent = obj
end
local function frame(parent, x,y,w,h,color)
    local f = Instance.new("Frame")
    f.Position = UDim2.fromOffset(x,y)
    f.Size = UDim2.fromOffset(w,h)
    f.BackgroundColor3 = color or C.panel
    f.BorderSizePixel = 0
    f.Parent = parent
    round(f,10)
    return f
end
local function text(parent, content, x,y,w,h,size,color,bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(x,y)
    t.Size = UDim2.fromOffset(w,h)
    t.Text = content
    t.TextColor3 = color or C.text
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize = size or 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTruncate = Enum.TextTruncate.AtEnd
    t.Parent = parent
    return t
end
local function button(parent, content,x,y,w,h,color)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(x,y)
    b.Size = UDim2.fromOffset(w,h)
    b.BackgroundColor3 = color or C.field
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Text = content
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    b.Parent = parent
    round(b,8)
    return b
end

local main = frame(gui,0,0,300,298,C.bg)
main.Position = UDim2.new(.5,-150,.28,0)
main.Active = true
border(main)
local heading = frame(main,0,0,300,46,C.panel)
heading.Active = true
text(heading,"APPLE FARM",15,8,185,21,16,C.text,true)
text(heading,"FARM + AUTO BUY | V9",16,27,180,12,10,C.muted,false)
local minimize = button(heading,"−",236,10,25,26,C.field)
local close = button(heading,"×",267,10,25,26,C.field)

local tabBar = frame(main,10,52,280,37,C.panel)
local farmTab = button(tabBar,"FARM",4,4,133,29,C.blue)
local buyTab = button(tabBar,"AUTO BUY",143,4,133,29,C.field)
local body = frame(main,0,96,300,189,C.bg)
body.BackgroundTransparency = 1
local statusBar = frame(body,12,8,276,50,C.panel)
text(statusBar,"FARM STATUS",12,6,155,14,10,C.muted,true)
local stateText = text(statusBar,"OFFLINE",12,21,160,24,15,C.red,true)
local power = button(statusBar,"OFF",211,10,54,30,C.red)
local speedRow = frame(body,12,67,276,52,C.panel)
text(speedRow,"Move speed",12,7,140,16,12,C.text,true)
local speedValue = text(speedRow,"65",13,27,100,18,13,C.muted)
local speedMinus = button(speedRow,"−",207,10,26,30,C.field)
local speedPlus = button(speedRow,"+",239,10,26,30,C.field)
local heightRow = frame(body,12,126,276,52,C.panel)
text(heightRow,"Height offset",12,7,145,16,12,C.text,true)
local heightValue = text(heightRow,"0.00",13,27,100,18,13,C.muted)
local heightMinus = button(heightRow,"−",207,10,26,30,C.field)
local heightPlus = button(heightRow,"+",239,10,26,30,C.field)
local mini = false
local buyTabActive = false
local buyPanel = nil
local function setMini(isMini)
    mini = isMini
    body.Visible = not mini and not buyTabActive
    if buyPanel then buyPanel.Visible = not mini and buyTabActive end
    tabBar.Visible = not mini
    main.Size = UDim2.fromOffset(300,mini and 46 or 298)
    minimize.Text = mini and "+" or "−"
end
minimize.MouseButton1Click:Connect(function() setMini(not mini) end)

-- Draggable ONLY from header; controls never compete with dragging.
local dragging, origin, initial = false, nil, nil
local moveConnection, endConnection
heading.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local p = UIS:GetMouseLocation()
    local objects = playerGui:GetGuiObjectsAtPosition(p.X,p.Y)
    if objects[1] and (objects[1] == close or objects[1] == minimize) then return end
    dragging = true
    origin = input.Position
    initial = main.Position
end)
moveConnection = UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position-origin
        main.Position = UDim2.new(initial.X.Scale,initial.X.Offset+d.X,initial.Y.Scale,initial.Y.Offset+d.Y)
    end
end)
endConnection = UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local unlocked = false
local enabled = false
local speed, heightOffset = 65,0
local arriveDistance, timeout = .8, 3
local current, elapsed = nil,0
local skipped = {}
local savedCollision = {}
local farmConn, noclipConn, respawnConn
local stopped = false
local validApples = {
    Apple_GreenStreak=true,Apple_Frost=true,Apple_GoldenSparkle=true,
    Apple_RedSpeckle=true,Apple_Flame=true,Apple_Candy=true,
    Apple_Rainbow=true,Apple_Diamond=true,Apple_Galaxy=true,
    Apple_Snowflake=true,Apple_Toxic=true,Apple_Shadow=true
}
local function getRoot()
    local c = player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if h and h.Health > 0 then return r,c end
end
local function getPart(m)
    if not m or not m.Parent then return nil end
    return m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart",true)
end
local function nearest(root)
    local folder = workspace:FindFirstChild("AutumnApples")
    if not folder then return nil,0 end
    local chosen,best,count = nil,math.huge,0
    for _,m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and validApples[m.Name] then
            local part = getPart(m)
            if part then
                count += 1
                local dist = (part.Position-root.Position).Magnitude
                if not skipped[m] and dist < best then
                    best=dist; chosen=m
                end
            end
        end
    end
    return chosen,count
end
local function restoreCollisions()
    for part,value in pairs(savedCollision) do
        if part and part.Parent then pcall(function() part.CanCollide=value end) end
    end
    table.clear(savedCollision)
end
local function stopFarm()
    enabled = false
    if farmConn then farmConn:Disconnect(); farmConn=nil end
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    restoreCollisions()
    current=nil; elapsed=0
    power.Text="OFF"; power.BackgroundColor3=C.red
    stateText.Text="OFFLINE"; stateText.TextColor3=C.red
end
local function startFarm()
    if not unlocked then return end
    if not workspace:FindFirstChild("AutumnApples") then
        warn("[APPLE FARM] AutumnApples not found")
        return
    end
    enabled=true
    skipped={}; current=nil; elapsed=0
    power.Text="ON"; power.BackgroundColor3=C.green
    stateText.Text="RUNNING"; stateText.TextColor3=C.green
    noclipConn=RunService.Stepped:Connect(function()
        if not enabled then return end
        local _,char=getRoot()
        if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if savedCollision[p]==nil then savedCollision[p]=p.CanCollide end
                p.CanCollide=false
            end
        end
    end)
    farmConn=RunService.Heartbeat:Connect(function(dt)
        if not enabled then return end
        local root=getRoot()
        if not root then return end
        if not getPart(current) then current=nil; elapsed=0 end
        if not current then
            local nxt=nearest(root)
            if not nxt then
                -- Retry after exhaustion in case models respawn.
                skipped={}
                return
            end
            current=nxt; elapsed=0
        end
        local part=getPart(current)
        if not part then current=nil; elapsed=0; return end
        elapsed += dt
        local pos=part.Position+Vector3.new(0,heightOffset,0)
        local delta=pos-root.Position
        local dist=delta.Magnitude
        if dist > arriveDistance then
            local step=math.min(speed*math.min(dt,.1),dist)
            local nextPos=root.Position+delta.Unit*step
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            root.CFrame=CFrame.new(nextPos)
        else
            skipped[current]=true
            current=nil; elapsed=0
        end
        if current and elapsed >= timeout then
            skipped[current]=true
            current=nil; elapsed=0
        end
    end)
end
power.MouseButton1Click:Connect(function()
    if not unlocked then return end
    if enabled then stopFarm() else startFarm() end
end)
speedMinus.MouseButton1Click:Connect(function()
    speed=math.max(10,speed-10); speedValue.Text=tostring(speed)
end)
speedPlus.MouseButton1Click:Connect(function()
    speed=math.min(2000,speed+10); speedValue.Text=tostring(speed)
end)
heightMinus.MouseButton1Click:Connect(function()
    heightOffset=math.max(-5,heightOffset-.25)
    heightValue.Text=string.format("%.2f",heightOffset)
end)
heightPlus.MouseButton1Click:Connect(function()
    heightOffset=math.min(4,heightOffset+.25)
    heightValue.Text=string.format("%.2f",heightOffset)
end)
respawnConn=player.CharacterAdded:Connect(function()
    restoreCollisions(); current=nil; elapsed=0; skipped={}
end)

-- ================================
-- APPLE AUTO BUY - integrated tab
-- ================================
local upgradeNames = {
    "Juicy Apples", "Faster Growth", "Bigger Harvest", "Lucky Apples",
    "Long Reach", "Double Pick", "Apple Combo", "Leaf Picker",
    "Apple Shower", "Rare Shine", "Mega Apples", "Apple Frenzy",
    "Orchard Mastery"
}
local buySelected = {}
for _, name in ipairs(upgradeNames) do buySelected[name] = true end
local buyEnabled, buyAlive, buyMax = false, true, true
local buyCount, buyDelay = 0, 5
local requestDelay = 0.35

buyPanel = frame(main,0,96,300,193,C.bg)
buyPanel.BackgroundTransparency = 1
buyPanel.Visible = false
local buyStatusBox = frame(buyPanel,12,2,276,54,C.panel)
local buyStatus = text(buyStatusBox,"READY",12,7,180,19,12,C.muted,true)
local buyCounter = text(buyStatusBox,"Purchased: 0",12,29,150,15,11,C.muted,false)
local buyPower = button(buyStatusBox,"OFF",211,10,54,32,C.red)
local buyMode = button(buyPanel,"MODE: MAX",12,63,135,30,C.field)
local buyAll = button(buyPanel,"CLEAR ALL",154,63,134,30,C.field)
local buyScroll = Instance.new("ScrollingFrame")
buyScroll.Name = "UpgradeList"
buyScroll.Position = UDim2.fromOffset(12,99)
buyScroll.Size = UDim2.fromOffset(276,91)
buyScroll.BackgroundColor3 = C.panel
buyScroll.BorderSizePixel = 0
buyScroll.ScrollBarThickness = 3
buyScroll.CanvasSize = UDim2.fromOffset(0,0)
buyScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
buyScroll.Parent = buyPanel
round(buyScroll,9)
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buyScroll
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0,5)
pad.PaddingBottom = UDim.new(0,5)
pad.PaddingLeft = UDim.new(0,5)
pad.PaddingRight = UDim.new(0,5)
pad.Parent = buyScroll
local chips = {}
local function redrawBuyRow(name)
    local ref = chips[name]
    if not ref then return end
    ref.chip.Text = buySelected[name] and "ON" or "OFF"
    ref.chip.TextColor3 = buySelected[name] and C.green or C.muted
    ref.row.BackgroundColor3 = buySelected[name] and C.field or C.panel
end
for i, name in ipairs(upgradeNames) do
    local row = button(buyScroll,"",0,0,261,34,C.field)
    row.Name = "Upgrade"..i
    row.Size = UDim2.new(1,-2,0,34)
    row.LayoutOrder = i
    text(row,name,10,6,196,23,12,C.text,true)
    local chip = text(row,"ON",207,6,39,23,11,C.green,true)
    chip.TextXAlignment = Enum.TextXAlignment.Right
    chips[name] = {row=row,chip=chip}
    row.MouseButton1Click:Connect(function()
        buySelected[name] = not buySelected[name]
        redrawBuyRow(name)
    end)
end
local function redrawBuy()
    buyPower.Text = buyEnabled and "ON" or "OFF"
    buyPower.BackgroundColor3 = buyEnabled and C.green or C.red
    buyMode.Text = buyMax and "MODE: MAX" or "MODE: x1"
    buyCounter.Text = "Purchased: "..buyCount
end
buyPower.MouseButton1Click:Connect(function()
    if not unlocked then return end
    buyEnabled = not buyEnabled
    buyStatus.Text = buyEnabled and "RUNNING" or "PAUSED"
    buyStatus.TextColor3 = buyEnabled and C.green or C.muted
    redrawBuy()
end)
buyMode.MouseButton1Click:Connect(function()
    buyMax = not buyMax
    redrawBuy()
end)
local allSelected = true
buyAll.MouseButton1Click:Connect(function()
    allSelected = not allSelected
    for _, name in ipairs(upgradeNames) do
        buySelected[name] = allSelected
        redrawBuyRow(name)
    end
    buyAll.Text = allSelected and "CLEAR ALL" or "SELECT ALL"
end)
local function showTab(buy)
    buyTabActive = buy
    body.Visible = not mini and not buy
    buyPanel.Visible = not mini and buy
    farmTab.BackgroundColor3 = buy and C.field or C.blue
    buyTab.BackgroundColor3 = buy and C.blue or C.field
end
farmTab.MouseButton1Click:Connect(function() showTab(false) end)
buyTab.MouseButton1Click:Connect(function() showTab(true) end)
local function findBuyRemote()
    local network = RS:FindFirstChild("Network")
    local service = network and network:FindFirstChild("AppleService")
    local rf = service and service:FindFirstChild("RF")
    local remote = rf and rf:FindFirstChild("BuyUpgrade")
    return remote and remote:IsA("RemoteFunction") and remote or nil
end
-- Single sequential worker, avoids overlapping InvokeServer calls.
task.spawn(function()
    while buyAlive and not stopped do
        if unlocked and buyEnabled then
            local remote = findBuyRemote()
            if not remote then
                buyStatus.Text = "REMOTE NOT FOUND"
                buyStatus.TextColor3 = C.red
            else
                for _, name in ipairs(upgradeNames) do
                    if not buyAlive or not buyEnabled or stopped then break end
                    if buySelected[name] then
                        local ok, success, msg = pcall(function()
                            return remote:InvokeServer(name,buyMax)
                        end)
                        if ok and success then
                            buyCount += 1
                            buyCounter.Text = "Purchased: "..buyCount
                            buyStatus.Text = "BOUGHT: "..name
                            buyStatus.TextColor3 = C.green
                        elseif not ok then
                            warn("[APPLE BUY]",name,success)
                            buyStatus.Text = "REQUEST ERROR"
                            buyStatus.TextColor3 = C.red
                        elseif msg ~= nil then
                            buyStatus.Text = tostring(msg):sub(1,28)
                            buyStatus.TextColor3 = C.muted
                        end
                        task.wait(requestDelay)
                    end
                end
            end
        end
        task.wait(buyDelay)
    end
end)

-- Floating reopen button. Hiding the GUI does NOT stop farming/buying.
local panelShown = true
local bubble = button(gui,"🍎",16,235,47,47,C.blue)
bubble.Visible = false
bubble.TextSize = 22
bubble.ZIndex = 5
local hideButton = button(heading,"▢",205,10,25,26,C.field)
local function setShown(shown)
    panelShown = shown
    main.Visible = shown and unlocked
    bubble.Visible = not shown and unlocked
end
hideButton.MouseButton1Click:Connect(function() setShown(false) end)
bubble.MouseButton1Click:Connect(function() setShown(true) end)

local keyOverlay=frame(gui,0,0,300,265,C.bg)
keyOverlay.Position=main.Position
keyOverlay.Active=true
border(keyOverlay)
main.Visible=false
local keyHeader=frame(keyOverlay,0,0,300,64,C.panel)
text(keyHeader,"APPLE FARM",18,13,260,25,19,C.text,true)
text(keyHeader,"Access key required",18,39,260,16,12,C.muted)
text(keyOverlay,"ENTER ACCESS KEY",18,90,260,20,11,C.muted,true)
local keyInput=Instance.new("TextBox")
keyInput.Size=UDim2.fromOffset(264,43)
keyInput.Position=UDim2.fromOffset(18,117)
keyInput.BackgroundColor3=C.field
keyInput.TextColor3=C.text
keyInput.PlaceholderColor3=C.muted
keyInput.PlaceholderText="Paste your key here"
keyInput.Text=""
keyInput.ClearTextOnFocus=false
keyInput.Font=Enum.Font.Gotham
keyInput.TextSize=13
keyInput.Parent=keyOverlay
round(keyInput,9)
local keyButton=button(keyOverlay,"UNLOCK FARM",18,177,264,42,C.blue)
local keyStatus=text(keyOverlay,"5 keys supported",18,218,264,19,12,C.muted)
text(keyOverlay,"Local key is remembered on this device",18,238,264,19,10,C.muted)
local checking=false
local function unlock(key, fromSaved)
    unlocked=true
    checking=false
    if not fromSaved then saveKey(key) end
    keyStatus.Text="Access granted"
    keyStatus.TextColor3=C.green
    keyButton.Text="UNLOCKED"
    keyOverlay:Destroy()
    main.Visible=true
end
local function verify()
    if checking or unlocked then return end
    checking=true
    local entered=keyInput.Text:match("^%s*(.-)%s*$")
    if VALID_KEYS[entered] ~= true then
        keyStatus.Text="Invalid or disabled key."
        keyStatus.TextColor3=C.red
        checking=false
        return
    end
    unlock(entered, false)
end
keyButton.MouseButton1Click:Connect(verify)
keyInput.FocusLost:Connect(function(enter)
    if enter then verify() end
end)

-- Tu mo khoa neu key da luu van dang duoc bat.
local savedKey=readSavedKey()
if savedKey and VALID_KEYS[savedKey] == true then
    unlock(savedKey, true)
elseif savedKey then
    keyStatus.Text="Saved key disabled. Enter another key."
    keyStatus.TextColor3=C.red
end

local function stopScript()
    if stopped then return end
    stopped=true
    stopFarm()
    buyEnabled=false
    buyAlive=false
    if respawnConn then respawnConn:Disconnect(); respawnConn=nil end
    if moveConnection then moveConnection:Disconnect(); moveConnection=nil end
    if endConnection then endConnection:Disconnect(); endConnection=nil end
    if gui.Parent then gui:Destroy() end
end
env.AppleModernV8Stop=stopScript
close.MouseButton1Click:Connect(stopScript)
gui.Destroying:Connect(function()
    if not stopped then stopScript() end
end)

print("[APPLE FARM + AUTO BUY V9] Loaded")
