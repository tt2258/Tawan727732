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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 470)
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
local scanBtn = CreateBtn("สแกนสิ่งของ", 55, "🔍")
local fpsBtn = CreateBtn("ลดเฟรมเรท", 110, "🎬")
local noclipBtn = CreateBtn("วิ่งทะลุ", 165, "🧱")
local rainbowBtn = CreateBtn("ตัวสีรุ้ง", 220, "🌈")
local growBtn = CreateBtn("แปลงร่างใหญ่", 275, "🦖")
local ghostViewBtn = CreateBtn("มุมมองผี", 330, "👁️")

-- ============ State ============
local connections = {}
local scanHighlights = {}
local rainbowConnection = nil
local isMenuOpen = false
local ghostViewActive = false
local ghostViewConnection = nil

-- ============ ระบบลาก UI (แยกคลิก/ลาก ชัดเจน) ============
local dragging = false
local dragStart = nil
local startPos = nil
local dragMoved = false
local DRAG_THRESHOLD = 5 -- ต้องลากเกิน 5 pixel ถึงจะนับว่าลาก

local function updateDrag(input)
    local delta = input.Position - dragStart
    
    -- เช็คว่าลากเกิน threshold หรือยัง
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

-- ผูกการลากกับ Title Button
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

-- ผูกการลากกับ Main Frame (เฉพาะพื้นที่ที่ไม่ใช่ปุ่ม)
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

-- หยุดลากเมื่อปล่อยเมาส์ทุกที่
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

-- ============ ตรวจสอบผู้เล่น ============
local function IsPlayerCharacter(model)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character == model then
            return true
        end
    end
    return false
end

-- ============ ค้นหาผีอัตโนมัติ ============
local function FindGhost()
    local myHRP = GetHRP()
    if not myHRP then return nil, 0 end
    
    local nearestGhost = nil
    local nearestDistance = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            
            local rootPart = obj:FindFirstChild("HumanoidRootPart") 
                          or obj:FindFirstChild("UpperTorso") 
                          or obj:FindFirstChild("Torso")
            if not rootPart then continue end
            
            if obj == player.Character then continue end
            if IsPlayerCharacter(obj) then continue end
            
            local distance = (myHRP.Position - rootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestGhost = obj
            end
        end
    end
    
    return nearestGhost, nearestDistance
end

-- ============ เปิด/ปิดเมนู ============
local function ToggleMenu()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        titleBtn.Text = "✨ T-xpa TH ▲"
        scrollFrame.Size = UDim2.new(1, 0, 0, 390)
        mainFrame.Size = UDim2.new(0, 320, 0, 450)
    else
        titleBtn.Text = "✨ T-xpa TH ▼"
        scrollFrame.Size = UDim2.new(1, 0, 0, 0)
        mainFrame.Size = UDim2.new(0, 320, 0, 45)
    end
end

-- ============ กดที่ Title เพื่อเปิด/ปิด (ถ้าไม่ได้ลาก) ============
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

scanBtn.MouseButton1Click:Connect(function()
    local state = scanBtn.Text:find("OFF")
    if state then
        scanBtn.Text = "🔍 สแกนสิ่งของ: ON"
        scanBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        ScanItems()
        
        connections.scan = task.spawn(function()
            while scanBtn.Text:find("ON") do
                task.wait(2)
                if scanBtn.Text:find("ON") then
                    ScanItems()
                end
            end
        end)
    else
        scanBtn.Text = "🔍 สแกนสิ่งของ: OFF"
        scanBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
        
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

-- ============ 7. มุมมองผี ============
local ghostHighlight = nil
local selfHighlight = nil
local distanceLabel = nil
local distanceGui = nil
local currentGhost = nil

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

local function CreateDistanceGui()
    if distanceGui then distanceGui:Destroy() end
    
    distanceGui = Instance.new("ScreenGui")
    distanceGui.Name = "GhostViewDistance"
    distanceGui.ResetOnSpawn = false
    distanceGui.DisplayOrder = 998
    distanceGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 35)
    frame.Position = UDim2.new(0.5, -140, 0, 5)
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
    distanceLabel.Text = "👁️ กำลังค้นหาผี..."
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 13
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Parent = frame
end

local function StartGhostView()
    ghostViewActive = true
    
    SetSelfRainbowHighlight()
    CreateDistanceGui()
    
    ghostViewConnection = RunService.RenderStepped:Connect(function()
        if not ghostViewActive then return end
        
        local camera = Workspace.CurrentCamera
        local ghost, distance = FindGhost()
        
        if ghost then
            currentGhost = ghost
            local ghostRoot = ghost:FindFirstChild("HumanoidRootPart") 
                           or ghost:FindFirstChild("UpperTorso") 
                           or ghost:FindFirstChild("Torso")
            
            if ghostRoot then
                local ghostPos = ghostRoot.Position
                camera.CFrame = CFrame.new(ghostPos + Vector3.new(0, 8, 15), ghostPos)
                camera.Focus = CFrame.new(ghostPos)
                
                if not ghostHighlight or ghostHighlight.Parent ~= ghost then
                    SetGhostHighlight(ghost)
                end
                
                if distanceLabel then
                    distanceLabel.Text = string.format("👁️ ผี: %s | ระยะ: %d m", ghost.Name, math.floor(distance))
                    
                    if distance < 20 then
                        distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    elseif distance < 50 then
                        distanceLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                    else
                        distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                    end
                end
            end
        else
            currentGhost = nil
            if distanceLabel then
                distanceLabel.Text = "👁️ ไม่พบผีในแมพ"
                distanceLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        end
    end)
end

local function StopGhostView()
    ghostViewActive = false
    
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
    
    currentGhost = nil
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

-- ============ รีเซ็ตเมื่อเกิดใหม่ ============
player.CharacterAdded:Connect(function()
    task.wait(1)
    
    speedBtn.Text = "⚡ วิ่งเร็ว: OFF"
    speedBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
    scanBtn.Text = "🔍 สแกนสิ่งของ: OFF"
    scanBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 75)
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
warn("📋 ฟีเจอร์: วิ่งเร็ว, สแกนสิ่งของ, ลดเฟรมเรท, วิ่งทะลุ, ตัวสีรุ้ง, แปลงร่างใหญ่, มุมมองผี")
warn("👁️ มุมมองผี: ค้นหาผีแบบอัตโนมัติ (ไม่พึ่งชื่อ)")
warn("💡 คลิกที่หัวข้อเพื่อเปิด/ปิด | ลากเพื่อย้ายตำแหน่ง")
