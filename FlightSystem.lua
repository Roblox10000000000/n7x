-- الجلوس في الفم (حركة أفقية داخل وخارج)
sit_mouth_btn.MouseButton1Click:Connect(function()
    if not currentTarget or not currentTarget.Character then return end
    
    if states.sit and sitType == "mouth" then
        states.sit = false
        if sitLoop then sitLoop:Disconnect() sitLoop = nil end
        sit_mouth_btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        mouthBasePos = nil
        return
    end
    
    states.sit = true
    sitType = "mouth"
    sit_mouth_btn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    sit_knee_btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local myRoot = p.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    if sitLoop then sitLoop:Disconnect() end
    
    sitLoop = game:GetService("RunService").RenderStepped:Connect(function()
        if not states.sit or not currentTarget or not currentTarget.Character or sitType ~= "mouth" then
            if sitLoop then sitLoop:Disconnect() sitLoop = nil end
            mouthBasePos = nil
            return
        end
        
        local targetHead = currentTarget.Character:FindFirstChild("Head")
        myRoot = p.Character:FindFirstChild("HumanoidRootPart")
        
        if targetHead and myRoot then
            -- تحديد الموضع الأساسي عند البدء
            if not mouthBasePos then
                mouthBasePos = targetHead.CFrame
            end
            
            -- حركة أفقية (داخل وخارج من الفم)
            local time = tick()
            local depthOffset = math.sin(time * sitSpeed / 10) * 1.2
            
            myRoot.CFrame = mouthBasePos * CFrame.new(depthOffset, 0, 0)
        end
    end)
end)
