-- T-xpa TH - BY ตูน EXE
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ============ UI Setup ============
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.Name = "T-xpaTH"
screenGui.DisplayOrder = 999

-- ============ Main Frame ============
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 45)
mainFrame.Position = UDim2.new(0.5, -160, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(160, 80, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- ============ Title Button ============
local titleBtn = Instance.new("TextButton")
titleBtn.Size = UDim2.new(1, 0, 1, 0)
titleBtn.BackgroundTransparency = 1
titleBtn.Text = "✨ T-xpa TH ▼"
titleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBtn.TextSize = 16
titleBtn.Font = Enum.Font.GothamBold
titleBtn.Active = true
titleBtn.Parent = mainFrame

-- ============ Scroll Frame ============
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 0, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
scrollFrame.BackgroundTransparency = 0.1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 525)
scrollFrame.Visible = true
scrollFrame.Active = true
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 12)
scrollCorner.Parent = scrollFrame

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 8)
scrollPadding.PaddingBottom = UDim.new(0, 8)
scrollPadding.PaddingLeft = UDim.new(0, 8)
scrollPadding.PaddingRight = UDim.new(0, 8)
scrollPadding.Parent = scrollFrame

-- ============ ฟังก์ชันสร้างปุ่ม ============
local function CreateBtn(name, yPos, emoji)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = emoji .. " " .. name .. ": OFF"
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Active = true
    btn.Parent = scrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(160, 80, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = btn
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 80))
    })
    gradient.Rotation = 45
    gradient.Parent = btn
    
    return btn
end

-- ============ สร้างปุ่มเมนู ============
local speedBtn = CreateBtn("วิ่งเร็ว", 0, "⚡")
local scanItemBtn = CreateBtn("สแกนสิ่งของ", 55, "🔍")
local fpsBtn = CreateBtn("ลดเฟรมเรท", 110, "🎬")
local noclipBtn = CreateBtn("วิ่งทะลุ", 165, "🧱")
local rainbowBtn = CreateBtn("ตัวสีรุ้ง", 220, "🌈")
local growBtn = CreateBtn("แปลงร่างใหญ่", 275, "🦖")
local ghostViewBtn = CreateBtn("มุมมองผี", 330, "👁️")
local ghostScanBtn = CreateBtn("สแกนผี", 385, "🎯")

-- ============ State ============
local connections = {}
local scanHighlights = {}
local rainbowConnection = nil
local isMenuOpen = false

local ghostViewActive = false
local ghostViewConnection = nil
local selectedGhost = nil

local ghostScanActive = false
local ghostScanConnection = nil
local scannedGhosts = {}
local scannedGhostHighlights = {}

-- ============ ระบบลาก UI ============
local dragging = false
local dragStart = nil
local startPos = nil
local dragMoved = false
local DRAG_THRESHOLD = 5

local function updateDrag(input)
    local delta = input.Position - dragStart
    
    if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
        dragMoved = true
    end
    
    if dragMoved then
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

titleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragMoved = false
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

titleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragMoved = false
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ============ ฟังก์ชันพื้นฐาน ============
local function GetHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ============ ตรวจสอบว่าเป็นผู้เล่นหรือไม่ ============
local function IsPlayerCharacter(model)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character == model then
            return true
        end
    end
    return false
end

-- ============ สแกนหา NPC ทั้งหมดในแมพ (อัตโนมัติ) ============
local function ScanAllNPCs()
    local npcList = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            -- ต้องมี Humanoid
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if not humanoid then continue end
            
            -- ต้องมี RootPart/Torso
            local rootPart = obj:FindFirstChild("HumanoidRootPart") 
                          or obj:FindFirstChild("UpperTorso") 
                          or obj:FindFirstChild("Torso")
            if not rootPart then continue end
            
            -- ต้องไม่ใช่ตัวเรา
            if obj == player.Character then continue end
            
            -- ต้องไม่ใช่ผู้เล่นอื่น
            if IsPlayerCharacter(obj) then continue end
            
            -- ผ่านทุกเงื่อนไข = NPC
            local displayName = obj.Name
            if displayName == "" or displayName == " " then
                displayName = "ไม่มีชื่อ"
            end
            
            table.insert(npcList, {
                model = obj,
                name = displayName,
                humanoid = humanoid,
                rootPart = rootPart
            })
        end
    end
    
    return npcList
end

-- ============ เปิด/ปิดเมนู ============
local function ToggleMenu()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        titleBtn.Text = "✨ T-xpa TH ▲"
        scrollFrame.Size = UDim2.new(1, 0, 0, 440)
        mainFrame.Size = UDim2.new(0, 320, 0, 500)
    else
        titleBtn.Text = "✨ T-xpa TH ▼"
        scrollFrame.Size = UDim2.new(1, 0, 0, 0)
        mainFrame.Size = UDim2.new(0, 320, 0, 45)
    end
end

titleBtn.MouseButton1Click:Connect(function()
    if not dragMoved then
        ToggleMenu()
    end
    dragMoved = false
end)

-- ============ ไฟวิ่งรอบเมนูม่วง ============
task.spawn(function()
    local colors = {
        Color3.fromRGB(160, 80, 255),
        Color3.fromRGB(200, 100, 255),
        Color3.fromRGB(120, 60, 200),
        Color3.fromRGB(220, 130, 255)
    }
    local i = 1
    while true do
        i = i + 0.05
        if i > #colors then i = 1 end
        mainStroke.Color = colors[math.floor(i)]
        task.wait(0.05)
    end
end)

-- ============ 1. วิ่งเร็ว ============
speedBtn.MouseButton1Click:Connect(function()
    local state = speedBtn.Text:find("OFF")
    if state then
        speedBtn.Text = "⚡ วิ่งเร็ว: ON"
        speedBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 50 end
    else
        speedBtn.Text = "⚡ วิ่งเร็ว: OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)

-- ============ 2. สแกนสิ่งของ ============
local function ScanItems()
    for _, hl in pairs(scanHighlights) do
        if hl then hl:Destroy() end
    end
    scanHighlights = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local isPickup = false
            local name = obj.Name:lower()
            
            if name:find("item") or name:find("key") or name:find("tool") or 
               name:find("weapon") or name:find("pickup") or name:find("collect") or
               name:find("coin") or name:find("gem") or name:find("chest") or
               name:find("box") or name:find("door") or name:find("button") or
               name:find("lever") or name:find("switch") or name:find("note") or
               name:find("card") or name:find("badge") or name:find("pass") or
               name:find("food") or name:find("potion") or name:find("ammo") or
               name:find("clip") or name:find("mag") or name:find("flash") then
                isPickup = true
            end
            
            if obj:FindFirstChildOfClass("ProximityPrompt") then isPickup = true end
            if obj:FindFirstChildOfClass("ClickDetector") then isPickup = true end
            if obj:IsA("Tool") then isPickup = true end
            
            if isPickup and not scanHighlights[obj] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 200, 0)
                highlight.OutlineColor = Color3.fromRGB(160, 80, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
                scanHighlights[obj] = highlight
                
                if obj:IsA("BasePart") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 25)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = obj
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "✨ " .. obj.Name
                    label.TextColor3 = Color3.fromRGB(255, 200, 0)
                    label.TextSize = 12
                    label.Font = Enum.Font.GothamBold
                    label.TextStrokeTransparency = 0.5
                    label.Parent = billboard
                end
            end
        end
    end
end

scanItemBtn.MouseButton1Click:Connect(function()
    local state = scanItemBtn.Text:find("OFF")
    if state then
        scanItemBtn.Text = "🔍 สแกนสิ่งของ: ON"
        scanItemBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        ScanItems()
        
        connections.scan = task.spawn(function()
            while scanItemBtn.Text:find("ON") do
                task.wait(2)
                if scanItemBtn.Text:find("ON") then
                    ScanItems()
                end
            end
        end)
    else
        scanItemBtn.Text = "🔍 สแกนสิ่งของ: OFF"
        scanItemBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
        for _, hl in pairs(scanHighlights) do
            if hl then hl:Destroy() end
        end
        scanHighlights = {}
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local bb = obj:FindFirstChildOfClass("BillboardGui")
                if bb then bb:Destroy() end
            end
        end
    end
end)

-- ============ 3. ลดเฟรมเรท ============
fpsBtn.MouseButton1Click:Connect(function()
    local state = fpsBtn.Text:find("OFF")
    if state then
        fpsBtn.Text = "🎬 ลดเฟรมเรท: ON"
        fpsBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                local decal = obj:FindFirstChildOfClass("Decal")
                if decal then decal:Destroy() end
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or 
                   obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end
    else
        fpsBtn.Text = "🎬 ลดเฟรมเรท: OFF"
        fpsBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
    end
end)

-- ============ 4. วิ่งทะลุ ============
noclipBtn.MouseButton1Click:Connect(function()
    local state = noclipBtn.Text:find("OFF")
    if state then
        noclipBtn.Text = "🧱 วิ่งทะลุ: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        
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
        noclipBtn.Text = "🧱 วิ่งทะลุ: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
    end
end)

-- ============ 5. ตัวสีรุ้ง ============
rainbowBtn.MouseButton1Click:Connect(function()
    local state = rainbowBtn.Text:find("OFF")
    if state then
        rainbowBtn.Text = "🌈 ตัวสีรุ้ง: ON"
        rainbowBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
        end
        
        rainbowConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            local hue = tick() % 1
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    for _, child in pairs(part:GetChildren()) do
                        if child:IsA("Texture") or child:IsA("Decal") then
                            child.Transparency = 1
                        end
                    end
                    
                    part.Color = Color3.fromHSV(hue, 1, 1)
                    part.Material = Enum.Material.Neon
                end
            end
        end)
    else
        rainbowBtn.Text = "🌈 ตัวสีรุ้ง: OFF"
        rainbowBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                    part.Color = Color3.fromRGB(255, 255, 0)
                end
            end
        end
    end
end)

-- ============ 6. แปลงร่างใหญ่ ============
growBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    
    local state = growBtn.Text:find("OFF")
    if state then
        growBtn.Text = "🦖 แปลงร่างใหญ่: ON"
        growBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.BodyDepthScale.Value = 3
            humanoid.BodyWidthScale.Value = 3
            humanoid.BodyHeightScale.Value = 3
            humanoid.HeadScale.Value = 3
            humanoid.WalkSpeed = 40
            humanoid.JumpPower = 100
        end
    else
        growBtn.Text = "🦖 แปลงร่างใหญ่: OFF"
        growBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.BodyDepthScale.Value = 1
            humanoid.BodyWidthScale.Value = 1
            humanoid.BodyHeightScale.Value = 1
            humanoid.HeadScale.Value = 1
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end)

-- ============ 7. มุมมองผี (สแกน NPC อัตโนมัติ) ============
local ghostHighlight = nil
local selfHighlight = nil
local ghostListGui = nil
local distanceGui = nil
local distanceLabel = nil

local function SetSelfRainbowHighlight()
    local char = player.Character
    if not char then return end
    
    if selfHighlight then selfHighlight:Destroy() end
    
    selfHighlight = Instance.new("Highlight")
    selfHighlight.Name = "SelfRainbow"
    selfHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    selfHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    selfHighlight.FillTransparency = 0.3
    selfHighlight.OutlineTransparency = 0
    selfHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    selfHighlight.Parent = char
    
    task.spawn(function()
        while ghostViewActive and selfHighlight and selfHighlight.Parent do
            local hue = tick() % 1
            selfHighlight.FillColor = Color3.fromHSV(hue, 1, 1)
            selfHighlight.OutlineColor = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
            task.wait(0.05)
        end
    end)
end

local function RemoveSelfHighlight()
    if selfHighlight then
        selfHighlight:Destroy()
        selfHighlight = nil
    end
end

local function SetGhostHighlight(ghost)
    if ghostHighlight then ghostHighlight:Destroy() end
    if not ghost then return end
    
    ghostHighlight = Instance.new("Highlight")
    ghostHighlight.Name = "GhostViewHighlight"
    ghostHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    ghostHighlight.OutlineColor = Color3.fromRGB(255, 100, 100)
    ghostHighlight.FillTransparency = 0.4
    ghostHighlight.OutlineTransparency = 0
    ghostHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    ghostHighlight.Parent = ghost
end

local function ShowGhostList()
    if ghostListGui then ghostListGui:Destroy() end
    
    ghostListGui = Instance.new("ScreenGui")
    ghostListGui.Name = "GhostViewSelector"
    ghostListGui.ResetOnSpawn = false
    ghostListGui.DisplayOrder = 1000
    ghostListGui.Parent = player.PlayerGui
    
    -- สแกน NPC ทั้งหมด
    local npcList = ScanAllNPCs()
    
    -- Frame หลัก
    local listFrame = Instance.new("Frame")
    local frameHeight = math.min(500, 100 + (#npcList * 50))
    listFrame.Size = UDim2.new(0, 280, 0, frameHeight)
    listFrame.Position = UDim2.new(0.5, -140, 0.5, -frameHeight/2)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    listFrame.BorderSizePixel = 0
    listFrame.Active = true
    listFrame.Parent = ghostListGui
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = listFrame
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(160, 80, 255)
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    
    -- หัวข้อ
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(45, 25, 80)
    header.BorderSizePixel = 0
    header.Text = "👁️ เลือก NPC ที่ต้องการดู (" .. #npcList .. " ตัว)"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 14
    header.Font = Enum.Font.GothamBold
    header.Parent = listFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- ปุ่มปิด
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = listFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        ghostListGui:Destroy()
        ghostListGui = nil
    end)
    
    -- Scroll Frame
    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -20, 1, -60)
    listScroll.Position = UDim2.new(0, 10, 0, 50)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 4
    listScroll.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
    listScroll.CanvasSize = UDim2.new(0, 0, 0, (#npcList + 1) * 50 + 10)
    listScroll.Parent = listFrame
    
    -- ปุ่ม "ตัวเรา"
    local selfBtn = Instance.new("TextButton")
    selfBtn.Size = UDim2.new(1, 0, 0, 45)
    selfBtn.Position = UDim2.new(0, 0, 0, 0)
    selfBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    selfBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selfBtn.Text = "🎮 ตัวเรา (กลับมุมมองตัวเอง)"
    selfBtn.TextSize = 13
    selfBtn.Font = Enum.Font.GothamBold
    selfBtn.Parent = listScroll
    
    local selfCorner = Instance.new("UICorner")
    selfCorner.CornerRadius = UDim.new(0, 8)
    selfCorner.Parent = selfBtn
    
    local selfStroke = Instance.new("UIStroke")
    selfStroke.Color = Color3.fromRGB(100, 150, 255)
    selfStroke.Thickness = 2
    selfStroke.Parent = selfBtn
    
    selfBtn.MouseButton1Click:Connect(function()
        selectedGhost = nil
        
        if ghostHighlight then
            ghostHighlight:Destroy()
            ghostHighlight = nil
        end
        
        local camera = Workspace.CurrentCamera
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                camera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 10, 20), hrp.Position)
                camera.Focus = CFrame.new(hrp.Position)
            end
        end
        
        selfBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(0.3)
        selfBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
        
        if distanceLabel then
            distanceLabel.Text = "🎮 กลับมาที่ตัวเราแล้ว"
            distanceLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
        end
    end)
    
    -- ถ้าไม่มี NPC
    if #npcList == 0 then
        local noNpcLabel = Instance.new("TextLabel")
        noNpcLabel.Size = UDim2.new(1, 0, 0, 50)
        noNpcLabel.Position = UDim2.new(0, 0, 0, 50)
        noNpcLabel.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        noNpcLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
        noNpcLabel.Text = "❌ ไม่พบ NPC ในแมพนี้"
        noNpcLabel.TextSize = 13
        noNpcLabel.Font = Enum.Font.GothamBold
        noNpcLabel.Parent = listScroll
        
        local noNpcCorner = Instance.new("UICorner")
        noNpcCorner.CornerRadius = UDim.new(0, 8)
        noNpcCorner.Parent = noNpcLabel
    end
    
    -- ปุ่ม NPC แต่ละตัว
    for i, npcData in ipairs(npcList) do
        local npcBtn = Instance.new("TextButton")
        npcBtn.Size = UDim2.new(1, 0, 0, 45)
        npcBtn.Position = UDim2.new(0, 0, 0, i * 50)
        npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        npcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        npcBtn.Text = "👻 " .. npcData.name
        npcBtn.TextSize = 13
        npcBtn.Font = Enum.Font.GothamBold
        npcBtn.Parent = listScroll
        
        local npcCorner = Instance.new("UICorner")
        npcCorner.CornerRadius = UDim.new(0, 8)
        npcCorner.Parent = npcBtn
        
        local npcStroke = Instance.new("UIStroke")
        npcStroke.Color = Color3.fromRGB(160, 80, 255)
        npcStroke.Thickness = 1.5
        npcStroke.Parent = npcBtn
        
        npcBtn.MouseButton1Click:Connect(function()
            -- เช็คว่า NPC ยังอยู่หรือไม่
            if not npcData.model.Parent then
                npcBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                if distanceLabel then
                    distanceLabel.Text = "❌ NPC หมดแล้ว"
                    distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
                task.wait(0.5)
                npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
                return
            end
            
            selectedGhost = npcData.model
            SetGhostHighlight(npcData.model)
            
            npcBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(0.3)
            npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
            
            if distanceLabel then
                distanceLabel.Text = "👁️ กำลังติดตาม: " .. npcData.name
                distanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
    end
end

local function CreateDistanceGui()
    if distanceGui then distanceGui:Destroy() end
    
    distanceGui = Instance.new("ScreenGui")
    distanceGui.Name = "GhostViewDistance"
    distanceGui.ResetOnSpawn = false
    distanceGui.DisplayOrder = 998
    distanceGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 35)
    frame.Position = UDim2.new(0.5, -160, 0, 5)
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = distanceGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 100)
    stroke.Thickness = 2
    stroke.Parent = frame
    
    distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "👁️ เลือก NPC ที่ต้องการดู"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 13
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Parent = frame
end

local function StartGhostView()
    ghostViewActive = true
    SetSelfRainbowHighlight()
    CreateDistanceGui()
    ShowGhostList()
    
    ghostViewConnection = RunService.RenderStepped:Connect(function()
        if not ghostViewActive then return end
        
        local camera = Workspace.CurrentCamera
        
        if selectedGhost then
            if not selectedGhost.Parent then
                selectedGhost = nil
                if ghostHighlight then
                    ghostHighlight:Destroy()
                    ghostHighlight = nil
                end
                return
            end
            
            local ghostRoot = selectedGhost:FindFirstChild("HumanoidRootPart") 
                           or selectedGhost:FindFirstChild("UpperTorso") 
                           or selectedGhost:FindFirstChild("Torso")
            
            if ghostRoot then
                local myHRP = GetHRP()
                local ghostPos = ghostRoot.Position
                
                camera.CFrame = CFrame.new(ghostPos + Vector3.new(0, 8, 15), ghostPos)
                camera.Focus = CFrame.new(ghostPos)
                
                if myHRP and distanceLabel then
                    local distance = (myHRP.Position - ghostPos).Magnitude
                    distanceLabel.Text = string.format("👁️ %s | ระยะ: %d m", selectedGhost.Name, math.floor(distance))
                    
                    if distance < 20 then
                        distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    elseif distance < 50 then
                        distanceLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                    else
                        distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                    end
                end
            end
        end
    end)
end

local function StopGhostView()
    ghostViewActive = false
    selectedGhost = nil
    
    if ghostViewConnection then
        ghostViewConnection:Disconnect()
        ghostViewConnection = nil
    end
    
    local camera = Workspace.CurrentCamera
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            camera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 10, 20), hrp.Position)
            camera.Focus = CFrame.new(hrp.Position)
        end
    end
    
    RemoveSelfHighlight()
    if ghostHighlight then
        ghostHighlight:Destroy()
        ghostHighlight = nil
    end
    
    if distanceGui then
        distanceGui:Destroy()
        distanceGui = nil
        distanceLabel = nil
    end
    
    if ghostListGui then
        ghostListGui:Destroy()
        ghostListGui = nil
    end
end

ghostViewBtn.MouseButton1Click:Connect(function()
    local state = ghostViewBtn.Text:find("OFF")
    if state then
        ghostViewBtn.Text = "👁️ มุมมองผี: ON"
        ghostViewBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 80)
        StartGhostView()
    else
        ghostViewBtn.Text = "👁️ มุมมองผี: OFF"
        ghostViewBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        StopGhostView()
    end
end)

-- ============ 8. สแกนผี (สแกน NPC อัตโนมัติ) ============
local function SetGhostRainbowScan(ghost)
    if not ghost then return end
    
    local oldHl = ghost:FindFirstChild("GhostScanHighlight")
    if oldHl then oldHl:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "GhostScanHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = ghost
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GhostScanBillboard"
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ghost
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🎯 " .. ghost.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 100, 200)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistanceLabel"
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0 m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0
    distLabel.Parent = billboard
    
    scannedGhostHighlights[ghost] = {
        highlight = highlight,
        billboard = billboard,
        distanceLabel = distLabel
    }
end

local function ClearGhostScan()
    for ghost, data in pairs(scannedGhostHighlights) do
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
    end
    scannedGhostHighlights = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GhostScanHighlight" then obj:Destroy() end
        if obj.Name == "GhostScanBillboard" then obj:Destroy() end
    end
end

local ghostScanListGui = nil

local function ShowGhostScanList()
    if ghostScanListGui then ghostScanListGui:Destroy() end
    
    ghostScanListGui = Instance.new("ScreenGui")
    ghostScanListGui.Name = "GhostScanSelector"
    ghostScanListGui.ResetOnSpawn = false
    ghostScanListGui.DisplayOrder = 1000
    ghostScanListGui.Parent = player.PlayerGui
    
    -- สแกน NPC ทั้งหมด
    local npcList = ScanAllNPCs()
    
    local listFrame = Instance.new("Frame")
    local frameHeight = math.min(500, 100 + (#npcList * 50))
    listFrame.Size = UDim2.new(0, 280, 0, frameHeight)
    listFrame.Position = UDim2.new(0.5, -140, 0.5, -frameHeight/2)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    listFrame.BorderSizePixel = 0
    listFrame.Active = true
    listFrame.Parent = ghostScanListGui
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = listFrame
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(255, 100, 200)
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(80, 25, 60)
    header.BorderSizePixel = 0
    header.Text = "🎯 เลือก NPC ที่ต้องการสแกน (" .. #npcList .. " ตัว)"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 14
    header.Font = Enum.Font.GothamBold
    header.Parent = listFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = listFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        ghostScanListGui:Destroy()
        ghostScanListGui = nil
    end)
    
    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -20, 1, -60)
    listScroll.Position = UDim2.new(0, 10, 0, 50)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 4
    listScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 200)
    listScroll.CanvasSize = UDim2.new(0, 0, 0, (#npcList + 2) * 50 + 10)
    listScroll.Parent = listFrame
    
    -- ปุ่ม "ล้างทั้งหมด"
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1, 0, 0, 45)
    clearBtn.Position = UDim2.new(0, 0, 0, 0)
    clearBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.Text = "🗑️ ล้างการสแกนทั้งหมด"
    clearBtn.TextSize = 13
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = listScroll
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearBtn
    
    local clearStroke = Instance.new("UIStroke")
    clearStroke.Color = Color3.fromRGB(255, 100, 100)
    clearStroke.Thickness = 2
    clearStroke.Parent = clearBtn
    
    clearBtn.MouseButton1Click:Connect(function()
        ClearGhostScan()
        clearBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(0.3)
        clearBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    end)
    
    -- ถ้าไม่มี NPC
    if #npcList == 0 then
        local noNpcLabel = Instance.new("TextLabel")
        noNpcLabel.Size = UDim2.new(1, 0, 0, 50)
        noNpcLabel.Position = UDim2.new(0, 0, 0, 50)
        noNpcLabel.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        noNpcLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
        noNpcLabel.Text = "❌ ไม่พบ NPC ในแมพนี้"
        noNpcLabel.TextSize = 13
        noNpcLabel.Font = Enum.Font.GothamBold
        noNpcLabel.Parent = listScroll
        
        local noNpcCorner = Instance.new("UICorner")
        noNpcCorner.CornerRadius = UDim.new(0, 8)
        noNpcCorner.Parent = noNpcLabel
    end
    
    -- ปุ่ม NPC แต่ละตัว
    for i, npcData in ipairs(npcList) do
        local npcBtn = Instance.new("TextButton")
        npcBtn.Size = UDim2.new(1, 0, 0, 45)
        npcBtn.Position = UDim2.new(0, 0, 0, i * 50)
        npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        npcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        npcBtn.Text = "🎯 " .. npcData.name
        npcBtn.TextSize = 13
        npcBtn.Font = Enum.Font.GothamBold
        npcBtn.Parent = listScroll
        
        local npcCorner = Instance.new("UICorner")
        npcCorner.CornerRadius = UDim.new(0, 8)
        npcCorner.Parent = npcBtn
        
        local npcStroke = Instance.new("UIStroke")
        npcStroke.Color = Color3.fromRGB(255, 100, 200)
        npcStroke.Thickness = 1.5
        npcStroke.Parent = npcBtn
        
        npcBtn.MouseButton1Click:Connect(function()
            if not npcData.model.Parent then
                npcBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                task.wait(0.5)
                npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
                return
            end
            
            SetGhostRainbowScan(npcData.model)
            
            npcBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(0.3)
            npcBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        end)
    end
end

local function StartGhostScan()
    ghostScanActive = true
    ShowGhostScanList()
    
    ghostScanConnection = RunService.Heartbeat:Connect(function()
        if not ghostScanActive then return end
        
        local myHRP = GetHRP()
        local hue = tick() % 1
        
        for ghost, data in pairs(scannedGhostHighlights) do
            if not ghost.Parent then
                if data.highlight then data.highlight:Destroy() end
                if data.billboard then data.billboard:Destroy() end
                scannedGhostHighlights[ghost] = nil
                continue
            end
            
            if data.highlight then
                data.highlight.FillColor = Color3.fromHSV(hue, 1, 1)
                data.highlight.OutlineColor = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
            end
            
            local ghostRoot = ghost:FindFirstChild("HumanoidRootPart") 
                           or ghost:FindFirstChild("UpperTorso") 
                           or ghost:FindFirstChild("Torso")
            
            if ghostRoot and myHRP and data.distanceLabel then
                local distance = (myHRP.Position - ghostRoot.Position).Magnitude
                data.distanceLabel.Text = string.format("%d m", math.floor(distance))
                
                if distance < 20 then
                    data.distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif distance < 50 then
                    data.distanceLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                else
                    data.distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                end
            end
        end
    end)
end

local function StopGhostScan()
    ghostScanActive = false
    
    if ghostScanConnection then
        ghostScanConnection:Disconnect()
        ghostScanConnection = nil
    end
    
    ClearGhostScan()
    
    if ghostScanListGui then
        ghostScanListGui:Destroy()
        ghostScanListGui = nil
    end
end

ghostScanBtn.MouseButton1Click:Connect(function()
    local state = ghostScanBtn.Text:find("OFF")
    if state then
        ghostScanBtn.Text = "🎯 สแกนผี: ON"
        ghostScanBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 80)
        StartGhostScan()
    else
        ghostScanBtn.Text = "🎯 สแกนผี: OFF"
        ghostScanBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        StopGhostScan()
    end
end)

-- ============ รีเซ็ตเมื่อเกิดใหม่ ============
player.CharacterAdded:Connect(function()
    task.wait(1)
    
    speedBtn.Text = "⚡ วิ่งเร็ว: OFF"
    speedBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    scanItemBtn.Text = "🔍 สแกนสิ่งของ: OFF"
    scanItemBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    fpsBtn.Text = "🎬 ลดเฟรมเรท: OFF"
    fpsBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    noclipBtn.Text = "🧱 วิ่งทะลุ: OFF"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    rainbowBtn.Text = "🌈 ตัวสีรุ้ง: OFF"
    rainbowBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    growBtn.Text = "🦖 แปลงร่างใหญ่: OFF"
    growBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    ghostViewBtn.Text = "👁️ มุมมองผี: OFF"
    ghostViewBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    ghostScanBtn.Text = "🎯 สแกนผี: OFF"
    ghostScanBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    
    if connections.noclip then
        connections.noclip:Disconnect()
        connections.noclip = nil
    end
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
    
    ghostViewActive = false
    if ghostViewConnection then
        ghostViewConnection:Disconnect()
        ghostViewConnection = nil
    end
    RemoveSelfHighlight()
    if ghostHighlight then
        ghostHighlight:Destroy()
        ghostHighlight = nil
    end
    if distanceGui then
        distanceGui:Destroy()
        distanceGui = nil
    end
    if ghostListGui then
        ghostListGui:Destroy()
        ghostListGui = nil
    end
    
    ghostScanActive = false
    if ghostScanConnection then
        ghostScanConnection:Disconnect()
        ghostScanConnection = nil
    end
    ClearGhostScan()
    if ghostScanListGui then
        ghostScanListGui:Destroy()
        ghostScanListGui = nil
    end
    
    for _, hl in pairs(scanHighlights) do
        if hl then hl:Destroy() end
    end
    scanHighlights = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local bb = obj:FindFirstChildOfClass("BillboardGui")
            if bb then bb:Destroy() end
        end
    end
end)

-- ============ Load Complete ============
warn("✨ T-xpa TH โหลดสำเร็จ!")
warn("🎨 BY ตูน EXE")
warn("🎯 ระบบสแกน NPC อัตโนมัติ - ใช้ได้ทุกแมพ!")
