-- T-xpa ZN - UI วงกลม (ลากได้ เลื่อนได้)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ============ ระบบคีย์ในตัว ============
local KEYS = {
    ["LQDVTVPK-JDBL-WYAH1WKN"] = { duration = 2 * 24 * 60 * 60, type = "normal" },
    ["WY6U54OC-ICBD-IRHDBHL7"] = { duration = 1 * 60 * 60, type = "vip" },
    ["KZHD3446-AUON-C8CG082A"] = { duration = 3 * 60, type = "normal" },
    ["AHOJBEX5-PJVT-5QNFGSYK"] = { duration = -1, type = "vip" },
    ["ARFX0V5Z-IB9K-XTJU7FTM"] = { duration = 9 * 24 * 60 * 60, type = "normal" },
    ["2QSXHKFQ-YJVQ-9I3LBH22"] = { duration = 3, type = "normal" },
    ["5UT3ERO5-T3XN-C192HWMG"] = { duration = 6 * 60, type = "vip" }
}

-- ============ UI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.Name = "T-xpaZN"

-- ============ วงกลมหลัก (ลากได้) ============
local mainCircle = Instance.new("Frame")
mainCircle.Size = UDim2.new(0, 60, 0, 60)
mainCircle.Position = UDim2.new(0.85, -30, 0.85, -30)
mainCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
mainCircle.BackgroundTransparency = 0.15
mainCircle.Active = true
mainCircle.Draggable = true
mainCircle.Parent = screenGui

-- ทำให้เป็นวงกลม
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = mainCircle

-- ขอบวงกลมเรืองแสง
local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(100, 50, 255)
circleStroke.Thickness = 3
circleStroke.Transparency = 0.3
circleStroke.Parent = mainCircle

-- ตัวอักษรในวงกลม
local circleLabel = Instance.new("TextLabel")
circleLabel.Size = UDim2.new(1, 0, 1, 0)
circleLabel.BackgroundTransparency = 1
circleLabel.Text = "⚡"
circleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
circleLabel.TextSize = 24
circleLabel.Font = Enum.Font.GothamBold
circleLabel.Parent = mainCircle

-- ============ หัวข้อแสดงเวลา (ย่อ) ============
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(0, 200, 0, 28)
topBar.Position = UDim2.new(0.5, -100, 0, 5)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
topBar.BackgroundTransparency = 0.7
topBar.Parent = screenGui

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(1, 0)
topCorner.Parent = topBar

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(1, 0, 1, 0)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "⏰ ยังไม่ใส่คีย์"
timeLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
timeLabel.TextSize = 12
timeLabel.Font = Enum.Font.GothamBold
timeLabel.Parent = topBar

-- ============ เมนูหลัก (วงกลม) ============
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.85, -30, 0.85, -30)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
mainFrame.BackgroundTransparency = 1
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- ทำให้เป็นวงกลมเมนู
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(1, 0)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 50, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- ============ Scroll Frame (เลื่อนได้) ============
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 255)
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 380)
scrollFrame.Parent = mainFrame

-- ============ Key Input UI (วงกลม) ============
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0.9, 0, 0, 100)
keyFrame.Position = UDim2.new(0.05, 0, 0, 10)
keyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyFrame.BackgroundTransparency = 0.3
keyFrame.Parent = scrollFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(1, 0)
keyCorner.Parent = keyFrame

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 25)
keyLabel.Position = UDim2.new(0, 0, 0, 5)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 ใส่คีย์"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.TextSize = 13
keyLabel.Font = Enum.Font.Gotham
keyLabel.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.7, 0, 0, 35)
keyInput.Position = UDim2.new(0.05, 0, 0, 35)
keyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "XXXX-XXXX-XXXXXXXX"
keyInput.Text = ""
keyInput.TextSize = 12
keyInput.Font = Enum.Font.Gotham
keyInput.Parent = keyFrame

local keyCorner2 = Instance.new("UICorner")
keyCorner2.CornerRadius = UDim.new(1, 0)
keyCorner2.Parent = keyInput

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0.2, 0, 0, 35)
keyBtn.Position = UDim2.new(0.75, 0, 0, 35)
keyBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBtn.Text = "ยืนยัน"
keyBtn.TextSize = 12
keyBtn.Font = Enum.Font.GothamBold
keyBtn.Parent = keyFrame

local keyCorner3 = Instance.new("UICorner")
keyCorner3.CornerRadius = UDim.new(1, 0)
keyCorner3.Parent = keyBtn

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, 0, 0, 25)
keyStatus.Position = UDim2.new(0, 0, 0, 75)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
keyStatus.TextSize = 11
keyStatus.Font = Enum.Font.Gotham
keyStatus.Parent = keyFrame

-- ============ Menu Buttons (วงกลม) ============
local function CreateBtn(name, yPos, emoji)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = emoji .. " " .. name .. ": OFF"
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.Parent = scrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    
    return btn
end

local speedBtn = CreateBtn("วิ่งเร็ว", 130, "⚡")
local noclipBtn = CreateBtn("เดินทะลุ", 175, "🧱")
local scanBtn = CreateBtn("สแกนผี", 220, "👻")
local teleportBtn = CreateBtn("วาปเก็บของ", 265, "📦")
local ghostPosBtn = CreateBtn("บอกตำแหน่งผี", 310, "📍")

-- ============ State ============
local connections = {}
local isKeyValid = false
local isMenuOpen = false
local remainingTime = 0
local keyExpireTime = 0
local isExpired = false
local isDragging = false
local dragStart = nil
local dragStartPos = nil

-- ============ ระบบเวลา ============
local function FormatTime(seconds)
    if seconds < 0 then return "หมดเวลาแล้ว" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if days > 0 then
        return string.format("%dว %02dช %02dน %02ดว", days, hours, minutes, secs)
    elseif hours > 0 then
        return string.format("%02dช %02ดน %02ดว", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%02ดน %02ดว", minutes, secs)
    else
        return string.format("%02ดว", secs)
    end
end

-- ============ ฟังก์ชันพื้นฐาน ============
local function GetHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- ============ เปิด/ปิดเมนู (วงกลม) ============
local function ToggleMenu()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 280, 0, 380)
        mainFrame.Position = UDim2.new(0.85, -140, 0.85, -190)
        mainFrame.BackgroundTransparency = 0.1
        circleLabel.Text = "✕"
        circleStroke.Thickness = 2
    else
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        circleLabel.Text = "⚡"
        circleStroke.Thickness = 3
    end
end

-- ============ ตรวจสอบคีย์ ============
local function ValidateKey(key)
    if not key or key == "" then
        return false, "❌ กรุณาใส่คีย์"
    end
    
    key = string.gsub(key, "%s+", "")
    key = string.upper(key)
    
    local keyData = KEYS[key]
    if not keyData then
        return false, "❌ คีย์ไม่ถูกต้อง"
    end
    
    if keyData.duration == -1 then
        isKeyValid = true
        isExpired = false
        remainingTime = -1
        keyExpireTime = -1
        return true, "♾️ ถาวร!"
    end
    
    keyExpireTime = os.time() + keyData.duration
    remainingTime = keyData.duration
    isKeyValid = true
    isExpired = false
    
    return true, "✅ เหลือ: " .. FormatTime(remainingTime)
end

-- ============ อัพเดตเวลา ============
local function UpdateTimer()
    if not isKeyValid then
        timeLabel.Text = "⏰ ยังไม่ใส่คีย์"
        return
    end
    
    if remainingTime == -1 then
        timeLabel.Text = "♾️ ถาวร"
        return
    end
    
    remainingTime = keyExpireTime - os.time()
    
    if remainingTime <= 0 then
        isKeyValid = false
        isExpired = true
        timeLabel.Text = "⏰ หมดอายุ!"
        timeLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        keyStatus.Text = "⏰ คีย์หมดอายุแล้ว!"
        keyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        speedBtn.Text = "⚡ วิ่งเร็ว: OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        noclipBtn.Text = "🧱 เดินทะลุ: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        scanBtn.Text = "👻 สแกนผี: OFF"
        scanBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        teleportBtn.Text = "📦 วาปเก็บของ: OFF"
        teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        ghostPosBtn.Text = "📍 บอกตำแหน่งผี: OFF"
        ghostPosBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 16 end
        return
    end
    
    timeLabel.Text = "⏱️ " .. FormatTime(remainingTime)
    timeLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
end

-- ============ Key Button ============
keyBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    local valid, msg = ValidateKey(key)
    keyStatus.Text = msg
    
    if valid then
        keyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        keyFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        keyInput.Visible = false
        keyBtn.Visible = false
        keyLabel.Text = "✅ เปิดใช้งาน!"
        keyLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        keyStatus.Text = "✅ ใช้งานได้แล้ว!"
        UpdateMenuState()
    else
        keyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ============ Update Menu State ============
local function UpdateMenuState()
    local buttons = {speedBtn, noclipBtn, scanBtn, teleportBtn, ghostPosBtn}
    for _, btn in pairs(buttons) do
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.Text = btn.Text:gsub(": ON", ": OFF")
    end
end

-- ============ ระบบลาก UI (จริง) ============
local function StartDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        -- ตรวจสอบว่ากดที่วงกลมหลักหรือไม่
        local circlePos = mainCircle.AbsolutePosition
        local circleSize = mainCircle.AbsoluteSize
        if pos.X >= circlePos.X and pos.X <= circlePos.X + circleSize.X and
           pos.Y >= circlePos.Y and pos.Y <= circlePos.Y + circleSize.Y then
            isDragging = true
            dragStart = pos
            dragStartPos = mainCircle.Position
        end
    end
end

local function UpdateDrag(input)
    if isDragging then
        local delta = input.Position - dragStart
        local scaleX = 1 / mainCircle.Parent.AbsoluteSize.X
        local scaleY = 1 / mainCircle.Parent.AbsoluteSize.Y
        mainCircle.Position = UDim2.new(
            dragStartPos.X.Scale + delta.X * scaleX,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale + delta.Y * scaleY,
            dragStartPos.Y.Offset + delta.Y
        )
        -- ถ้าเมนูเปิดอยู่ ให้ขยับตาม
        if isMenuOpen then
            mainFrame.Position = UDim2.new(
                mainCircle.Position.X.Scale - 0.5,
                mainCircle.Position.X.Offset - 140,
                mainCircle.Position.Y.Scale - 0.5,
                mainCircle.Position.Y.Offset - 190
            )
        end
    end
end

local function EndDrag(input)
    isDragging = false
end

-- เชื่อมต่อระบบลาก
UserInputService.InputBegan:Connect(StartDrag)
UserInputService.InputChanged:Connect(UpdateDrag)
UserInputService.InputEnded:Connect(EndDrag)

-- ============ Button Events ============
mainCircle.MouseButton1Click:Connect(ToggleMenu)

-- 1. Speed Hack
speedBtn.MouseButton1Click:Connect(function()
    if not isKeyValid then
        keyStatus.Text = "⚠️ กรุณาใส่คีย์"
        return
    end
    local state = speedBtn.Text:find("OFF")
    if state then
        speedBtn.Text = "⚡ วิ่งเร็ว: ON"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 50 end
    else
        speedBtn.Text = "⚡ วิ่งเร็ว: OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)

-- 2. Noclip
noclipBtn.MouseButton1Click:Connect(function()
    if not isKeyValid then
        keyStatus.Text = "⚠️ กรุณาใส่คีย์"
        return
    end
    local state = noclipBtn.Text:find("OFF")
    if state then
        noclipBtn.Text = "🧱 เดินทะลุ: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        connections.noclip = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "🧱 เดินทะลุ: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
    end
end)

-- 3. Scan Ghost
scanBtn.MouseButton1Click:Connect(function()
    if not isKeyValid then
        keyStatus.Text = "⚠️ กรุณาใส่คีย์"
        return
    end
    local state = scanBtn.Text:find("OFF")
    if state then
        scanBtn.Text = "👻 สแกนผี: ON"
        scanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        scanBtn.Text = "👻 สแกนผี: OFF"
        scanBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

-- 4. Teleport Item
teleportBtn.MouseButton1Click:Connect(function()
    if not isKeyValid then
        keyStatus.Text = "⚠️ กรุณาใส่คีย์"
        return
    end
    local state = teleportBtn.Text:find("OFF")
    if state then
        teleportBtn.Text = "📦 วาปเก็บของ: ON"
        teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        teleportBtn.Text = "📦 วาปเก็บของ: OFF"
        teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

-- 5. Ghost Position
ghostPosBtn.MouseButton1Click:Connect(function()
    if not isKeyValid then
        keyStatus.Text = "⚠️ กรุณาใส่คีย์"
        return
    end
    local state = ghostPosBtn.Text:find("OFF")
    if state then
        ghostPosBtn.Text = "📍 บอกตำแหน่งผี: ON"
        ghostPosBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ghostPosBtn.Text = "📍 บอกตำแหน่งผี: OFF"
        ghostPosBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

-- ============ ตัวนับเวลา ============
task.spawn(function()
    while true do
        UpdateTimer()
        task.wait(1)
    end
end)

-- ============ Reset ============
player.CharacterAdded:Connect(function()
    task.wait(1)
    if connections.noclip then
        connections.noclip:Disconnect()
        connections.noclip = nil
    end
    local humanoid = GetHumanoid()
    if humanoid then humanoid.WalkSpeed = 16 end
end)

-- ============ Load Complete ============
warn("⚡ T-xpa ZN (วงกลม) โหลดสำเร็จ!")
warn("🔑 แตะวงกลม⚡เพื่อเปิดเมนู")
warn("🔄 ลากวงกลมเพื่อย้ายตำแหน่ง")
warn("📋 คีย์: LQDVTVPK-JDBL-WYAH1WKN (2วัน)")
