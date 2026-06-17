local p = game.Players.LocalPlayer
local pg = p:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

local mainGui = Instance.new("ScreenGui", pg)
mainGui.ResetOnSpawn = false
mainGui.Name = "N7x"

-- الدائرة الصغيرة
local circle = Instance.new("TextButton", mainGui)
circle.Size = UDim2.new(0, 50, 0, 50)
circle.Position = UDim2.new(0.5, -25, 0.5, -25)
circle.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
circle.TextColor3 = Color3.fromRGB(255, 255, 255)
circle.Text = "N7x"
circle.TextSize = 14
circle.BorderSizePixel = 0
circle.Draggable = true
circle.Active = true

-- اللوحة الرئيسية
local panel = Instance.new("Frame", mainGui)
panel.Size = UDim2.new(0, 600, 0, 700)
panel.Position = UDim2.new(0.5, -300, 0.5, -350)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderColor3 = Color3.fromRGB(147, 51, 234)
panel.BorderSizePixel = 2
panel.Visible = false
panel.Draggable = true
panel.Active = true

-- الرأس
local header = Instance.new("TextLabel", panel)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = "N7x Aim Bot"
header.TextSize = 16
header.BorderSizePixel = 0

-- زر الإغلاق
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0

local function makeBtn(parent, name, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    return btn
end

local function makeLabel(parent, text, y)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0.9, 0, 0, 25)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(147, 51, 234)
    lbl.Text = text
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function makeInputBox(parent, placeholder, y)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, 0, y)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    box.BorderSizePixel = 0
    return box
end

-- الأيم بوت
makeLabel(panel, "موقع الهدف", 50)
local headBtn = makeBtn(panel, "الرأس", 80)
local bodyBtn = makeBtn(panel, "البطن", 130)
local legBtn = makeBtn(panel, "القدم", 180)

-- FOV
makeLabel(panel, "FOV (مجال الرؤية)", 235)
local fovBox = makeInputBox(panel, "1-500", 260)
fovBox.Text = "100"

-- السرعة
makeLabel(panel, "سرعة الايم (1-199)", 310)
local speedBox = makeInputBox(panel, "1-199", 335)
speedBox.Text = "50"

-- كشف لاعبين
local espBtn = makeBtn(panel, "كشف لاعبين", 390)

-- طيران
local flyBtn = makeBtn(panel, "طيران", 440)

-- اختراق جدران
local noclipBtn = makeBtn(panel, "اختراق جدران", 490)

-- نط لا نهائي
local jumpBtn = makeBtn(panel, "نط لا نهائي", 540)

-- إيقاف
local stopBtn = Instance.new("TextButton", panel)
stopBtn.Size = UDim2.new(0.9, 0, 0, 40)
stopBtn.Position = UDim2.new(0.05, 0, 0, 590)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "إيقاف الكل"
stopBtn.TextSize = 12
stopBtn.BorderSizePixel = 0

local states = {aim = false, esp = false, fly = false, noclip = false, jump = false}
local targetPart = "Head"
local aimSpeed = 50
local fov = 100
local aimLoop = nil
local flyLoop = nil
local jumpLoop = nil

local function clampValue(val, min, max)
    if not val or val < min then return min end
    if val > max then return max end
    return math.floor(val)
end

circle.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
    circle.BackgroundColor3 = panel.Visible and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(147, 51, 234)
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    circle.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
end)

-- اختيار جزء الجسم
headBtn.MouseButton1Click:Connect(function()
    targetPart = "Head"
    headBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    bodyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    legBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

bodyBtn.MouseButton1Click:Connect(function()
    targetPart = "Torso"
    bodyBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    headBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    legBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

legBtn.MouseButton1Click:Connect(function()
    targetPart = "LeftFoot"
    legBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    headBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bodyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- تحديث FOV
fovBox.FocusLost:Connect(function()
    local val = tonumber(fovBox.Text)
    if val then
        val = clampValue(val, 1, 500)
        fov = val
        fovBox.Text = tostring(val)
    else
        fovBox.Text = "100"
        fov = 100
    end
end)

-- تحديث السرعة
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        val = clampValue(val, 1, 199)
        aimSpeed = val / 100
        speedBox.Text = tostring(val)
    else
        speedBox.Text = "50"
        aimSpeed = 0.5
    end
end)

-- الأيم بوت
headBtn.MouseButton1Click:Connect(function()
    if not states.aim then
        states.aim = true
        if aimLoop then aimLoop:Disconnect() end
        
        aimLoop = game:GetService("RunService").RenderStepped:Connect(function()
            if not states.aim then
                aimLoop:Disconnect()
                return
            end
            
            local target = nil
            local closestDistance = math.huge
            
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= p and otherPlayer.Character then
                    local targetPos = otherPlayer.Character:FindFirstChild(targetPart)
                    if targetPos then
                        local distance = (targetPos.Position - cam.CFrame.Position).Magnitude
                        if distance < closestDistance and distance < fov then
                            closestDistance = distance
                            target = targetPos
                        end
                    end
                end
            end
            
            if target then
                local targetCFrame = CFrame.new(cam.CFrame.Position, target.Position)
                cam.CFrame = cam.CFrame:Lerp(targetCFrame, aimSpeed)
            end
        end)
    end
end)

-- كشف لاعبين
espBtn.MouseButton1Click:Connect(function()
    states.esp = not states.esp
    espBtn.BackgroundColor3 = states.esp and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(50, 50, 50)
    
    for _, pl in pairs(game.Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            for _, part in pairs(pl.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local box = part:FindFirstChild("EspBox")
                    if states.esp then
                        if not box then
                            local newBox = Instance.new("SelectionBox", part)
                            newBox.Name = "EspBox"
                            newBox.Adornee = part
                            newBox.Color3 = Color3.fromRGB(147, 51, 234)
                        end
                    else
                        if box then box:Destroy() end
                    end
                end
            end
        end
    end
end)

-- طيران
flyBtn.MouseButton1Click:Connect(function()
    states.fly = not states.fly
    flyBtn.BackgroundColor3 = states.fly and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(50, 50, 50)
    
    if states.fly then
        local c = p.Character
        if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        local hu = c:FindFirstChild("Humanoid")
        if not r or not hu then return end
        
        local bv = Instance.new("BodyVelocity", r)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = Instance.new("BodyGyro", r)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        if flyLoop then flyLoop:Disconnect() end
        flyLoop = game:GetService("RunService").RenderStepped:Connect(function()
            if not states.fly then
                flyLoop:Disconnect()
                bv:Destroy()
                bg:Destroy()
                return
            end
            
            local move = Vector3.new(0, 0, 0)
            local ui = game:GetService("UserInputService")
            
            if ui:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if ui:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if ui:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if ui:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if ui:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            
            if move.Magnitude > 0 then move = move.Unit end
            bv.Velocity = move * 50
            bg.CFrame = cam.CFrame
        end)
    end
end)

-- اختراق جدران
noclipBtn.MouseButton1Click:Connect(function()
    states.noclip = not states.noclip
    noclipBtn.BackgroundColor3 = states.noclip and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(50, 50, 50)
    
    local c = p.Character
    if c then
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not states.noclip
            end
        end
    end
end)

-- نط لا نهائي
jumpBtn.MouseButton1Click:Connect(function()
    states.jump = not states.jump
    jumpBtn.BackgroundColor3 = states.jump and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(50, 50, 50)
    
    if states.jump then
        if jumpLoop then jumpLoop:Disconnect() end
        jumpLoop = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space and states.jump then
                local hu = p.Character:FindFirstChild("Humanoid")
                if hu then
                    hu:Jump()
                end
            end
        end)
    end
end)

-- إيقاف الكل
stopBtn.MouseButton1Click:Connect(function()
    states.aim = false
    states.esp = false
    states.fly = false
    states.noclip = false
    states.jump = false
    
    headBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    if aimLoop then aimLoop:Disconnect() end
    if flyLoop then flyLoop:Disconnect() end
    if jumpLoop then jumpLoop:Disconnect() end
    
    local c = p.Character
    if c then
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

print("N7x Aim Bot تم التحميل!")
