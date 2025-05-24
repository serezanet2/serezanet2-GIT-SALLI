local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

if not game:IsLoaded() then
    game.Loaded:Wait()
end

UIS.MouseIconEnabled = false

local cursorGui = Instance.new("ScreenGui")
cursorGui.Name = "CustomCursor"
cursorGui.DisplayOrder = 999999
cursorGui.ResetOnSpawn = false
cursorGui.Parent = player.PlayerGui

local cursorOuter = Instance.new("Frame")
cursorOuter.Name = "CursorOuter"
cursorOuter.Size = UDim2.new(0, 24, 0, 24)
cursorOuter.AnchorPoint = Vector2.new(0.5, 0.5)
cursorOuter.BackgroundColor3 = Color3.new(0, 0, 0)
cursorOuter.BackgroundTransparency = 0.3
cursorOuter.BorderSizePixel = 0
cursorOuter.ZIndex = 999999
cursorOuter.Parent = cursorGui

local UICornerOuter = Instance.new("UICorner")
UICornerOuter.CornerRadius = UDim.new(1, 0)
UICornerOuter.Parent = cursorOuter

local cursorInner = Instance.new("Frame")
cursorInner.Name = "CursorInner"
cursorInner.Size = UDim2.new(0, 16, 0, 16)
cursorInner.AnchorPoint = Vector2.new(0.5, 0.5)
cursorInner.Position = UDim2.new(0.5, 0, 0.5, 0)
cursorInner.BackgroundColor3 = Color3.new(0, 0.5, 1)
cursorInner.BackgroundTransparency = 0.5
cursorInner.BorderSizePixel = 0
cursorInner.ZIndex = 999999
cursorInner.Parent = cursorOuter

local UICornerInner = Instance.new("UICorner")
UICornerInner.CornerRadius = UDim.new(1, 0)
UICornerInner.Parent = cursorInner

local pulseTween = TweenService:Create(cursorInner, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.8,
    Size = UDim2.new(0, 12, 0, 12)
})
pulseTween:Play()

local cursorConnection
cursorConnection = RunService.RenderStepped:Connect(function()
    local mouseLocation = UIS:GetMouseLocation()
    cursorOuter.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y - 60)
end)

-- Тема и GUI
local lightTheme = false
local themeColors = {
    dark = {
        background = Color3.fromRGB(25, 25, 25),
        secondary = Color3.fromRGB(40, 40, 40),
        text = Color3.fromRGB(255, 255, 255),
        button = Color3.fromRGB(50, 50, 50),
        buttonHover = Color3.fromRGB(70, 70, 70),
        accent = Color3.fromRGB(0, 120, 215),
        inputField = Color3.fromRGB(20, 20, 20)
    },
    light = {
        background = Color3.fromRGB(240, 240, 240),
        secondary = Color3.fromRGB(220, 220, 220),
        text = Color3.fromRGB(0, 0, 0),
        button = Color3.fromRGB(200, 200, 200),
        buttonHover = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(0, 90, 180),
        inputField = Color3.fromRGB(180, 180, 180)
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunctionalMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local mainMenu = Instance.new("Frame")
mainMenu.Name = "MainMenu"
mainMenu.Size = UDim2.new(0, 500, 1, -20)
mainMenu.Position = UDim2.new(0, 10, 0, 10)
mainMenu.BackgroundColor3 = themeColors.dark.background
mainMenu.BorderSizePixel = 0
mainMenu.ClipsDescendants = true
mainMenu.Parent = ScreenGui

local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 80)
titleFrame.BackgroundColor3 = themeColors.dark.secondary
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainMenu

local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(0, 60, 0, 60)
avatar.Position = UDim2.new(0, 10, 0, 10)
avatar.BackgroundColor3 = themeColors.dark.button
avatar.BorderSizePixel = 0
avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatar.Parent = titleFrame

local playerInfo = Instance.new("TextLabel")
playerInfo.Name = "PlayerInfo"
playerInfo.Size = UDim2.new(1, -80, 1, -20)
playerInfo.Position = UDim2.new(0, 80, 0, 10)
playerInfo.BackgroundTransparency = 1
playerInfo.Text = "Ник: "..player.DisplayName.."\nЛогин: @"..player.Name
playerInfo.TextColor3 = themeColors.dark.text
playerInfo.Font = Enum.Font.SourceSansBold
playerInfo.TextSize = 16
playerInfo.TextXAlignment = Enum.TextXAlignment.Left
playerInfo.Parent = titleFrame

local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "Tabs"
tabsFrame.Size = UDim2.new(1, 0, 0, 30)
tabsFrame.Position = UDim2.new(0, 0, 0, 80)
tabsFrame.BackgroundColor3 = themeColors.dark.secondary
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = mainMenu

local function createTab(name, text, position)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Text = text
    tab.Size = UDim2.new(0.166, 0, 1, 0)
    tab.Position = position
    tab.BackgroundColor3 = name == "Tab1" and themeColors.dark.accent or themeColors.dark.button
    tab.TextColor3 = themeColors.dark.text
    tab.Font = Enum.Font.SourceSansBold
    tab.TextSize = 16
    tab.Parent = tabsFrame
    return tab
end

local tab1 = createTab("Tab1", "Player", UDim2.new(0, 0, 0, 0))
local tab2 = createTab("Tab2", "TP", UDim2.new(0.166, 0, 0, 0))
local tab3 = createTab("Tab3", "PvP", UDim2.new(0.332, 0, 0, 0))
local tab4 = createTab("Tab4", "ESP", UDim2.new(0.498, 0, 0, 0))
local tab5 = createTab("Tab5", "Misc", UDim2.new(0.664, 0, 0, 0))
local tab6 = createTab("Tab6", "Scripts", UDim2.new(0.83, 0, 0, 0))

local function createTabContainer(name)
    local container = Instance.new("Frame")
    container.Name = name.."Container"
    container.Size = UDim2.new(1, 0, 1, -110)
    container.Position = UDim2.new(0, 0, 0, 110)
    container.BackgroundTransparency = 1
    container.Visible = name == "Tab1"
    container.Parent = mainMenu
    return container
end

local tab1Container = createTabContainer("Tab1")
local tab2Container = createTabContainer("Tab2")
local tab3Container = createTabContainer("Tab3")
local tab4Container = createTabContainer("Tab4")
local tab5Container = createTabContainer("Tab5")
local tab6Container = createTabContainer("Tab6")

local function switchTab(tab)
    tab1.BackgroundColor3 = tab == tab1 and themeColors.dark.accent or themeColors.dark.button
    tab2.BackgroundColor3 = tab == tab2 and themeColors.dark.accent or themeColors.dark.button
    tab3.BackgroundColor3 = tab == tab3 and themeColors.dark.accent or themeColors.dark.button
    tab4.BackgroundColor3 = tab == tab4 and themeColors.dark.accent or themeColors.dark.button
    tab5.BackgroundColor3 = tab == tab5 and themeColors.dark.accent or themeColors.dark.button
    tab6.BackgroundColor3 = tab == tab6 and themeColors.dark.accent or themeColors.dark.button
    
    tab1Container.Visible = tab == tab1
    tab2Container.Visible = tab == tab2
    tab3Container.Visible = tab == tab3
    tab4Container.Visible = tab == tab4
    tab5Container.Visible = tab == tab5
    tab6Container.Visible = tab == tab6
end

tab1.MouseButton1Click:Connect(function() switchTab(tab1) end)
tab2.MouseButton1Click:Connect(function() switchTab(tab2) end)
tab3.MouseButton1Click:Connect(function() switchTab(tab3) end)
tab4.MouseButton1Click:Connect(function() switchTab(tab4) end)
tab5.MouseButton1Click:Connect(function() switchTab(tab5) end)
tab6.MouseButton1Click:Connect(function() switchTab(tab6) end)

local function createButton(parent, name, text, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = position
    button.BackgroundColor3 = themeColors.dark.button
    button.TextColor3 = themeColors.dark.text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = parent
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = lightTheme and themeColors.light.buttonHover or themeColors.dark.buttonHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = lightTheme and themeColors.light.button or themeColors.dark.button
    end)
    
    return button
end

local function addIndicator(button)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -20, 0.5, -8)
    indicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
    indicator.BorderSizePixel = 0
    indicator.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = indicator
    
    return indicator
end

local noclipButton = createButton(tab1Container, "NoclipButton", "NoClip", UDim2.new(0, 10, 0, 0))
local flyButton = createButton(tab1Container, "FlyButton", "Fly (WASD+E/Q)", UDim2.new(0, 10, 0, 45))
local freeCamButton = createButton(tab1Container, "FreeCamButton", "FreeCam (WASD+Shift+RMB)", UDim2.new(0, 10, 0, 90))
local themeButton = createButton(tab1Container, "ThemeButton", "Сменить тему", UDim2.new(0, 10, 0, 135))
local rejoinButton = createButton(tab1Container, "RejoinButton", "Rejoin", UDim2.new(0, 10, 0, 180))
local resetButton = createButton(tab1Container, "ResetButton", "Reset", UDim2.new(0, 10, 0, 225))
local disableButton = createButton(tab1Container, "DisableButton", "Отключить скрипт", UDim2.new(0, 10, 0, 270))

local clickTpButton = createButton(tab2Container, "ClickTPButton", "Click TP", UDim2.new(0, 10, 0, 0))

local infiniteJumpButton = createButton(tab5Container, "InfiniteJumpButton", "Infinite Jump", UDim2.new(0, 10, 0, 0))
local antiAfkButton = createButton(tab5Container, "AntiAfkButton", "Anti AFK", UDim2.new(0, 10, 0, 45))
local fpsBoostButton = createButton(tab5Container, "FpsBoostButton", "FPS Boost", UDim2.new(0, 10, 0, 90))

local buildBoatButton = createButton(tab6Container, "BuildBoatButton", "Build a Boat", UDim2.new(0, 10, 0, 0))
local deadRailsButton = createButton(tab6Container, "DeadRailsButton", "Dead Rails", UDim2.new(0, 10, 0, 45))
local infiniteYieldButton = createButton(tab6Container, "InfiniteYieldButton", "Infinite Yield", UDim2.new(0, 10, 0, 90))
local customScriptButton = createButton(tab6Container, "CustomScriptButton", "Custom Script (Ender)", UDim2.new(0, 10, 0, 135))

local boltRifleButton = createButton(tab3Container, "BoltRifleButton", "Винтовка болт", UDim2.new(0, 10, 0, 0))

local noclipIndicator = addIndicator(noclipButton)
local flyIndicator = addIndicator(flyButton)
local freeCamIndicator = addIndicator(freeCamButton)
local clickTpIndicator = addIndicator(clickTpButton)
local infiniteJumpIndicator = addIndicator(infiniteJumpButton)
local boltRifleIndicator = addIndicator(boltRifleButton)

local buttonSound = Instance.new("Sound")
buttonSound.SoundId = "rbxassetid://5828817939"
buttonSound.Volume = 0.5
buttonSound.Parent = SoundService

local noclipEnabled = false
local noclipConnection = nil

local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        buttonSound:Play()
        noclipIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        local function noclipCharacter(character)
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if noclipConnection then
            noclipConnection:Disconnect()
        end

        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        if player.Character then
            noclipCharacter(player.Character)
        end

        player.CharacterAdded:Connect(function(character)
            noclipCharacter(character)
        end)
    else
        buttonSound:Play()
        noclipIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)

        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

noclipButton.MouseButton1Click:Connect(toggleNoClip)

local function updateTheme()
    local colors = lightTheme and themeColors.light or themeColors.dark

    mainMenu.BackgroundColor3 = colors.background
    titleFrame.BackgroundColor3 = colors.secondary
    tabsFrame.BackgroundColor3 = colors.secondary
    avatar.BackgroundColor3 = colors.button
    playerInfo.TextColor3 = colors.text

    for _, tab in ipairs(tabsFrame:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = tab == tab1 and colors.accent or colors.button
            tab.TextColor3 = colors.text
        end
    end

    local function updateButtons(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = colors.button
                child.TextColor3 = colors.text

                child.MouseEnter:Connect(function()
                    child.BackgroundColor3 = colors.buttonHover
                end)
                
                child.MouseLeave:Connect(function()
                    child.BackgroundColor3 = colors.button
                end)
            end
        end
    end
    
    updateButtons(tab1Container)
    updateButtons(tab2Container)
    updateButtons(tab3Container)
    updateButtons(tab4Container)
    updateButtons(tab5Container)
    updateButtons(tab6Container)
end

themeButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    lightTheme = not lightTheme
    updateTheme()
end)

rejoinButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    TeleportService:Teleport(game.PlaceId, player)
end)

resetButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    if player.Character then
        player.Character:BreakJoints()
    end
end)
disableButton.MouseButton1Click:Connect(function()
    buttonSound:Play()

    if noclipEnabled then toggleNoClip() end
    if flyEnabled then toggleFly() end
    if freeCamEnabled then DisableFreeCam() end

    if cursorConnection then cursorConnection:Disconnect() end
    UIS.MouseIconEnabled = true

    if ScreenGui then ScreenGui:Destroy() end
    if cursorGui then cursorGui:Destroy() end
end)

local flyEnabled = false
local flySpeed = 50
local flyConnection
local bodyGyro, bodyVelocity
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        buttonSound:Play()
        flyIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                humanoid.PlatformStand = true
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 10000
                bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                bodyGyro.CFrame = rootPart.CFrame
                bodyGyro.Parent = rootPart
                
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = rootPart
                
                flyConnection = RunService.Heartbeat:Connect(function(dt)
                    if not character or not rootPart or not bodyGyro or not bodyVelocity then return end
                    
                    local camera = workspace.CurrentCamera
                    local moveDirection = Vector3.new()
                    
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.E) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.Q) then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
                    
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit * flySpeed
                    end
                    
                    bodyVelocity.Velocity = moveDirection
                    bodyGyro.CFrame = camera.CFrame
                end)
            end
        end
    else
        buttonSound:Play()
        flyIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end
end
flyButton.MouseButton1Click:Connect(toggleFly)

local freeCamEnabled = false
local freeCamSpeed = 5
local freeCamFastSpeed = 15
local freeCamSensitivity = 0.5
local originalCameraType, originalCameraSubject, originalHumanoidState
local originalCameraCFrame, originalCameraOffset
local yaw, pitch = 0, 0

local function EnableFreeCam()
    buttonSound:Play()
    freeCamEnabled = true
    freeCamIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
    
    originalCameraType = workspace.CurrentCamera.CameraType
    originalCameraSubject = workspace.CurrentCamera.CameraSubject
    originalCameraCFrame = workspace.CurrentCamera.CFrame
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            originalHumanoidState = humanoid:GetState()
            originalCameraOffset = humanoid.CameraOffset
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid.PlatformStand = true
        end
    end
    
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    workspace.CurrentCamera.CameraSubject = nil
    yaw = workspace.CurrentCamera.CFrame:ToEulerAnglesXYZ()
    pitch = 0
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end

local function DisableFreeCam()
    buttonSound:Play()
    freeCamEnabled = false
    freeCamIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
    
    workspace.CurrentCamera.CameraType = originalCameraType or Enum.CameraType.Custom
    workspace.CurrentCamera.CameraSubject = originalCameraSubject or player.Character:FindFirstChildOfClass("Humanoid")
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(originalHumanoidState or Enum.HumanoidStateType.Running)
            if originalCameraOffset then
                humanoid.CameraOffset = originalCameraOffset
            end
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.CFrame = CFrame.new(rootPart.Position)
        end
    end
    
    UIS.MouseBehavior = Enum.MouseBehavior.Default
end

local function UpdateFreeCam(dt)
    if not freeCamEnabled then return end
    
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new()
    local speed = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and freeCamFastSpeed or freeCamSpeed
    
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector + Vector3.new(0, -1, 0) end
    
    if moveVector.Magnitude > 0 then
        moveVector = moveVector.Unit * speed
        camera.CFrame = camera.CFrame + moveVector * dt * 60
    end
    
    local mouseDelta = UIS:GetMouseDelta()
    yaw = yaw - mouseDelta.X * freeCamSensitivity * math.pi/180
    pitch = math.clamp(pitch - mouseDelta.Y * freeCamSensitivity * math.pi/180, -math.pi/2 + 0.1, math.pi/2 - 0.1)
    
    local position = camera.CFrame.Position
    camera.CFrame = CFrame.new(position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
end

local function ToggleFreeCam()
    if freeCamEnabled then
        DisableFreeCam()
    else
        EnableFreeCam()
    end
end

freeCamButton.MouseButton1Click:Connect(ToggleFreeCam)
RunService.RenderStepped:Connect(UpdateFreeCam)

local clickTpEnabled = false
local clickTpConnection
local function toggleClickTp()
    clickTpEnabled = not clickTpEnabled
    
    if clickTpEnabled then
        buttonSound:Play()
        clickTpIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        clickTpConnection = mouse.Button1Down:Connect(function()
            if not player.Character then return end
            
            local target = mouse.Hit.Position
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                TweenService:Create(humanoidRootPart, tweenInfo, {
                    CFrame = CFrame.new(target.X, target.Y + 3, target.Z)
                }):Play()
            end
        end)
    else
        buttonSound:Play()
        clickTpIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if clickTpConnection then
            clickTpConnection:Disconnect()
        end
    end
end
clickTpButton.MouseButton1Click:Connect(toggleClickTp)

local infiniteJumpEnabled = false
local infiniteJumpConnection
local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        buttonSound:Play()
        infiniteJumpIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        infiniteJumpConnection = UIS.JumpRequest:Connect(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        buttonSound:Play()
        infiniteJumpIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end
    end
end
infiniteJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)

local boltRifleEnabled = false
local function toggleBoltRifle()
    boltRifleEnabled = not boltRifleEnabled
    
    if boltRifleEnabled then
        buttonSound:Play()
        boltRifleIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/serezanet2/serezanet2-GIT-SALLI/refs/heads/main/GIT-SALLI-%D0%92%D0%B8%D0%BD%D1%82%D0%BE%D0%B2%D0%BA%D0%B0%20%D0%B1%D0%BE%D0%BB%D1%82.lua"))()
        end)
        
        if not success then
            warn("Ошибка загрузки скрипта винтовки:", err)
            boltRifleEnabled = false
            boltRifleIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        end
    else
        buttonSound:Play()
        boltRifleIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
    end
end
boltRifleButton.MouseButton1Click:Connect(toggleBoltRifle)

local antiAfkEnabled = false
local antiAfkConnection
local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        buttonSound:Play()
        antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    else
        buttonSound:Play()
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
        end
    end
end
antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)

local fpsBoostEnabled = false
local function toggleFpsBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    
    if fpsBoostEnabled then
        buttonSound:Play()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshCacheSize = 0
        settings().Rendering.TextureCacheSize = 0
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FantasySky:Destroy()
    else
        buttonSound:Play()
        settings().Rendering.QualityLevel = 10
        settings().Rendering.MeshCacheSize = 100
        settings().Rendering.TextureCacheSize = 100
        game:GetService("Lighting").GlobalShadows = true
    end
end
fpsBoostButton.MouseButton1Click:Connect(toggleFpsBoost)

local function loadScript(url)
    buttonSound:Play()
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Ошибка загрузки скрипта:", err)
    end
end

infiniteYieldButton.MouseButton1Click:Connect(function()
    loadScript("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)

buildBoatButton.MouseButton1Click:Connect(function()
    loadScript('https://raw.githubusercontent.com/TheRealAsu/BABFT/main/Jan25_Source.lua')
end)

deadRailsButton.MouseButton1Click:Connect(function()
    loadScript("https://rawscripts.net/raw/Dead-Rails-Alpha-Dead-Rails-OP-KiciaHook-Script-Fastest-Auto-Farm-35961")
end)

local customScriptActive = false
local customScriptConnection
local function toggleCustomScriptMode()
    customScriptActive = not customScriptActive
    
    if customScriptActive then
        buttonSound:Play()
        customScriptButton.Text = "Custom Script (Active - LMB to exit)"
        
        local input = ""
        local inputActive = true
        
        customScriptConnection = UIS.InputBegan:Connect(function(key, processed)
            if key.KeyCode == Enum.KeyCode.Return then
                inputActive = false
            elseif inputActive then
                if key.KeyCode == Enum.KeyCode.Space then
                    input = input .. " "
                elseif key.KeyCode == Enum.KeyCode.Backspace then
                    input = input:sub(1, -2)
                else
                    local char = key.KeyCode.Name:lower()
                    if #char == 1 then
                        input = input .. char
                    end
                end
            end
        end)
        
        mouse.Button1Down:Wait()
        customScriptActive = false
        customScriptButton.Text = "Custom Script (Ender)"
        
        if customScriptConnection then
            customScriptConnection:Disconnect()
        end
        
        if input ~= "" then
            local success, err = pcall(loadstring(input))
            if not success then
                warn("Ошибка выполнения скрипта:", err)
            end
        end
    end
end
customScriptButton.MouseButton1Click:Connect(toggleCustomScriptMode)

local menuVisible = true
local function toggleMenu()
    buttonSound:Play()
    menuVisible = not menuVisible
    
    if menuVisible then
        TweenService:Create(mainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 10, 0, 10)
        }):Play()
    else
        TweenService:Create(mainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, -510, 0, 10)
        }):Play()
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.LeftShift then
            toggleMenu()
        elseif input.KeyCode == Enum.KeyCode.F and freeCamEnabled then
            DisableFreeCam()
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    if noclipEnabled then toggleNoClip() end
    if flyEnabled then 
        task.wait(0.5)
        toggleFly()
    end
end)

player.CharacterRemoving:Connect(function()
    if noclipEnabled then toggleNoClip() end
    if flyEnabled then toggleFly() end
end)
