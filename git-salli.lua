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

-- Кастомный курсор
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

-- Цвета темы
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
        buttonHover = Color3.fromRGB(180, 180, 180),
        accent = Color3.fromRGB(0, 90, 180),
        inputField = Color3.fromRGB(180, 180, 180)
    }
}

-- Основное меню
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

-- Заголовок
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

-- Вкладки
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
    tab.Size = UDim2.new(0.142, 0, 1, 0)
    tab.Position = position
    tab.BackgroundColor3 = name == "Tab1" and themeColors.dark.accent or themeColors.dark.button
    tab.TextColor3 = themeColors.dark.text
    tab.Font = Enum.Font.SourceSansBold
    tab.TextSize = 16
    tab.Parent = tabsFrame
    return tab
end

local tab1 = createTab("Tab1", "Player", UDim2.new(0, 0, 0, 0))
local tab2 = createTab("Tab2", "TP", UDim2.new(0.142, 0, 0, 0))
local tab3 = createTab("Tab3", "PvP", UDim2.new(0.284, 0, 0, 0))
local tab4 = createTab("Tab4", "ESP", UDim2.new(0.426, 0, 0, 0))
local tab5 = createTab("Tab5", "Misc", UDim2.new(0.568, 0, 0, 0))
local tab6 = createTab("Tab6", "Scripts", UDim2.new(0.71, 0, 0, 0))
local tab7 = createTab("Tab7", "Color", UDim2.new(0.852, 0, 0, 0))

-- Контейнеры вкладок
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
local tab7Container = createTabContainer("Tab7")

-- Переключение вкладок
local function switchTab(tab)
    tab1.BackgroundColor3 = tab == tab1 and themeColors.dark.accent or themeColors.dark.button
    tab2.BackgroundColor3 = tab == tab2 and themeColors.dark.accent or themeColors.dark.button
    tab3.BackgroundColor3 = tab == tab3 and themeColors.dark.accent or themeColors.dark.button
    tab4.BackgroundColor3 = tab == tab4 and themeColors.dark.accent or themeColors.dark.button
    tab5.BackgroundColor3 = tab == tab5 and themeColors.dark.accent or themeColors.dark.button
    tab6.BackgroundColor3 = tab == tab6 and themeColors.dark.accent or themeColors.dark.button
    tab7.BackgroundColor3 = tab == tab7 and themeColors.dark.accent or themeColors.dark.button
    
    tab1Container.Visible = tab == tab1
    tab2Container.Visible = tab == tab2
    tab3Container.Visible = tab == tab3
    tab4Container.Visible = tab == tab4
    tab5Container.Visible = tab == tab5
    tab6Container.Visible = tab == tab6
    tab7Container.Visible = tab == tab7
end

tab1.MouseButton1Click:Connect(function() switchTab(tab1) end)
tab2.MouseButton1Click:Connect(function() switchTab(tab2) end)
tab3.MouseButton1Click:Connect(function() switchTab(tab3) end)
tab4.MouseButton1Click:Connect(function() switchTab(tab4) end)
tab5.MouseButton1Click:Connect(function() switchTab(tab5) end)
tab6.MouseButton1Click:Connect(function() switchTab(tab6) end)
tab7.MouseButton1Click:Connect(function() switchTab(tab7) end)

-- Создание кнопок
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

-- Добавление индикатора
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

-- Кнопки для вкладок
-- Player
local noclipButton = createButton(tab1Container, "NoclipButton", "NoClip", UDim2.new(0, 10, 0, 0))
local flyButton = createButton(tab1Container, "FlyButton", "Fly (WASD+E/Q)", UDim2.new(0, 10, 0, 45))
local freeCamButton = createButton(tab1Container, "FreeCamButton", "FreeCam (WASD+Shift+RMB)", UDim2.new(0, 10, 0, 90))
local rejoinButton = createButton(tab1Container, "RejoinButton", "Rejoin", UDim2.new(0, 10, 0, 135))
local resetButton = createButton(tab1Container, "ResetButton", "Reset", UDim2.new(0, 10, 0, 180))
local disableButton = createButton(tab1Container, "DisableButton", "Отключить скрипт", UDim2.new(0, 10, 0, 225))

-- TP
local clickTpButton = createButton(tab2Container, "ClickTPButton", "Click TP", UDim2.new(0, 10, 0, 0))
local customTpButton = createButton(tab2Container, "CustomTPButton", "Custom TP (Coords)", UDim2.new(0, 10, 0, 45))

-- PvP
local boltRifleButton = createButton(tab3Container, "BoltRifleButton", "Винтовка болт", UDim2.new(0, 10, 0, 0))

-- ESP
local espButton = createButton(tab4Container, "ESPButton", "ESP Players", UDim2.new(0, 10, 0, 0))

-- Misc
local infiniteJumpButton = createButton(tab5Container, "InfiniteJumpButton", "Infinite Jump", UDim2.new(0, 10, 0, 0))
local antiAfkButton = createButton(tab5Container, "AntiAfkButton", "Anti AFK", UDim2.new(0, 10, 0, 45))

-- Scripts
local buildBoatButton = createButton(tab6Container, "BuildBoatButton", "Build a Boat", UDim2.new(0, 10, 0, 0))
local deadRailsButton = createButton(tab6Container, "DeadRailsButton", "Dead Rails", UDim2.new(0, 10, 0, 45))
local infiniteYieldButton = createButton(tab6Container, "InfiniteYieldButton", "Infinite Yield", UDim2.new(0, 10, 0, 90))
local customScriptButton = createButton(tab6Container, "CustomScriptButton", "Custom Script (Ender)", UDim2.new(0, 10, 0, 135))

-- Color
local backgroundColorButton = createButton(tab7Container, "BackgroundColorButton", "Background Color", UDim2.new(0, 10, 0, 0))
local secondaryColorButton = createButton(tab7Container, "SecondaryColorButton", "Secondary Color", UDim2.new(0, 10, 0, 45))
local textColorButton = createButton(tab7Container, "TextColorButton", "Text Color", UDim2.new(0, 10, 0, 90))
local buttonColorButton = createButton(tab7Container, "ButtonColorButton", "Button Color", UDim2.new(0, 10, 0, 135))
local accentColorButton = createButton(tab7Container, "AccentColorButton", "Accent Color", UDim2.new(0, 10, 0, 180))
local themeButton = createButton(tab7Container, "ThemeButton", "Сменить тему", UDim2.new(0, 10, 0, 225))

-- Индикаторы
local noclipIndicator = addIndicator(noclipButton)
local flyIndicator = addIndicator(flyButton)
local freeCamIndicator = addIndicator(freeCamButton)
local clickTpIndicator = addIndicator(clickTpButton)
local infiniteJumpIndicator = addIndicator(infiniteJumpButton)
local boltRifleIndicator = addIndicator(boltRifleButton)
local espIndicator = addIndicator(espButton)
local antiAfkIndicator = addIndicator(antiAfkButton)

-- Звук кнопок
local buttonSound = Instance.new("Sound")
buttonSound.SoundId = "rbxassetid://5828817939"
buttonSound.Volume = 0.5
buttonSound.Parent = SoundService

--=== [ FREE CAM ] ===--
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

--=== [ CLICK TP ] ===--
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

--=== [ CUSTOM TP ] ===--
local customTpGui = Instance.new("ScreenGui")
customTpGui.Name = "CustomTPGUI"
customTpGui.ResetOnSpawn = false
customTpGui.Enabled = false
customTpGui.Parent = player.PlayerGui

local customTpFrame = Instance.new("Frame")
customTpFrame.Size = UDim2.new(0, 300, 0, 200)
customTpFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
customTpFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
customTpFrame.BorderSizePixel = 0
customTpFrame.Parent = customTpGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Custom Teleport"
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = customTpFrame

local xLabel = Instance.new("TextLabel")
xLabel.Size = UDim2.new(0.3, 0, 0, 30)
xLabel.Position = UDim2.new(0, 10, 0, 40)
xLabel.Text = "X:"
xLabel.BackgroundTransparency = 1
xLabel.TextColor3 = Color3.new(1, 1, 1)
xLabel.Font = Enum.Font.SourceSans
xLabel.TextSize = 16
xLabel.TextXAlignment = Enum.TextXAlignment.Left
xLabel.Parent = customTpFrame

local xBox = Instance.new("TextBox")
xBox.Size = UDim2.new(0.6, 0, 0, 30)
xBox.Position = UDim2.new(0.3, 10, 0, 40)
xBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
xBox.TextColor3 = Color3.new(1, 1, 1)
xBox.Text = ""
xBox.Parent = customTpFrame

local yLabel = Instance.new("TextLabel")
yLabel.Size = UDim2.new(0.3, 0, 0, 30)
yLabel.Position = UDim2.new(0, 10, 0, 80)
yLabel.Text = "Y:"
yLabel.BackgroundTransparency = 1
yLabel.TextColor3 = Color3.new(1, 1, 1)
yLabel.Font = Enum.Font.SourceSans
yLabel.TextSize = 16
yLabel.TextXAlignment = Enum.TextXAlignment.Left
yLabel.Parent = customTpFrame

local yBox = Instance.new("TextBox")
yBox.Size = UDim2.new(0.6, 0, 0, 30)
yBox.Position = UDim2.new(0.3, 10, 0, 80)
yBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
yBox.TextColor3 = Color3.new(1, 1, 1)
yBox.Text = ""
yBox.Parent = customTpFrame

local zLabel = Instance.new("TextLabel")
zLabel.Size = UDim2.new(0.3, 0, 0, 30)
zLabel.Position = UDim2.new(0, 10, 0, 120)
zLabel.Text = "Z:"
zLabel.BackgroundTransparency = 1
zLabel.TextColor3 = Color3.new(1, 1, 1)
zLabel.Font = Enum.Font.SourceSans
zLabel.TextSize = 16
zLabel.TextXAlignment = Enum.TextXAlignment.Left
zLabel.Parent = customTpFrame

local zBox = Instance.new("TextBox")
zBox.Size = UDim2.new(0.6, 0, 0, 30)
zBox.Position = UDim2.new(0.3, 10, 0, 120)
zBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
zBox.TextColor3 = Color3.new(1, 1, 1)
zBox.Text = ""
zBox.Parent = customTpFrame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.45, 0, 0, 30)
copyButton.Position = UDim2.new(0, 10, 0, 160)
copyButton.Text = "Copy Position"
copyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.Font = Enum.Font.SourceSansBold
copyButton.TextSize = 16
copyButton.Parent = customTpFrame

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0.45, 0, 0, 30)
tpButton.Position = UDim2.new(0.55, 10, 0, 160)
tpButton.Text = "Teleport"
tpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextSize = 16
tpButton.Parent = customTpFrame

local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(1, -20, 0, 30)
exitButton.Position = UDim2.new(0, 10, 1, -40)
exitButton.Text = "Exit"
exitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
exitButton.TextColor3 = Color3.new(1, 1, 1)
exitButton.Font = Enum.Font.SourceSansBold
exitButton.TextSize = 16
exitButton.Parent = customTpFrame

local function toggleCustomTp()
    customTpGui.Enabled = not customTpGui.Enabled
    buttonSound:Play()
end

copyButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        xBox.Text = string.format("%.2f", pos.X)
        yBox.Text = string.format("%.2f", pos.Y)
        zBox.Text = string.format("%.2f", pos.Z)
    end
end)

tpButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local x = tonumber(xBox.Text) or 0
        local y = tonumber(yBox.Text) or 0
        local z = tonumber(zBox.Text) or 0
        
        player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -20, 0, 20)
        statusLabel.Position = UDim2.new(0, 10, 0, 10)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Teleport successful!"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.Font = Enum.Font.SourceSansBold
        statusLabel.TextSize = 16
        statusLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        statusLabel.TextStrokeTransparency = 0
        statusLabel.Parent = customTpFrame
        
        delay(3, function()
            statusLabel:Destroy()
        end)
    end
end)

exitButton.MouseButton1Click:Connect(toggleCustomTp)
customTpButton.MouseButton1Click:Connect(toggleCustomTp)

--=== [ BOLT RIFLE ] ===--
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
            warn("Bolt Rifle script error:", err)
            boltRifleEnabled = false
            boltRifleIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        end
    else
        buttonSound:Play()
        boltRifleIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
    end
end

boltRifleButton.MouseButton1Click:Connect(toggleBoltRifle)

--=== [ ESP ] ===--
local espEnabled = false
local espHighlights = {}

local function createESP(player)
    if player == Players.LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    
    local function attachHighlight(character)
        if character then
            highlight.Adornee = character
            highlight.Parent = character
            espHighlights[player] = highlight
        end
    end
    
    if player.Character then
        attachHighlight(player.Character)
    end
    
    player.CharacterAdded:Connect(attachHighlight)
    player.CharacterRemoving:Connect(function()
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
    end)
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        buttonSound:Play()
        espIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        Players.PlayerAdded:Connect(createESP)
    else
        buttonSound:Play()
        espIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        for _, highlight in pairs(espHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        espHighlights = {}
    end
end

espButton.MouseButton1Click:Connect(toggleESP)

--=== [ INFINITE JUMP ] ===--
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

--=== [ ANTI AFK ] ===--
local antiAfkEnabled = false
local antiAfkConnection

local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        buttonSound:Play()
        antiAfkIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        antiAfkConnection = Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    else
        buttonSound:Play()
        antiAfkIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
        end
    end
end

antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)

--=== [ CUSTOM SCRIPT ] ===--
local customScriptGui = Instance.new("ScreenGui")
customScriptGui.Name = "CustomScriptGUI"
customScriptGui.ResetOnSpawn = false
customScriptGui.Enabled = false
customScriptGui.Parent = player.PlayerGui

local customScriptFrame = Instance.new("Frame")
customScriptFrame.Size = UDim2.new(0, 500, 0, 300)
customScriptFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
customScriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
customScriptFrame.BorderSizePixel = 0
customScriptFrame.Parent = customScriptGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Custom Script Input"
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = customScriptFrame

local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1, -20, 1, -100)
scriptBox.Position = UDim2.new(0, 10, 0, 40)
scriptBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scriptBox.TextColor3 = Color3.new(1, 1, 1)
scriptBox.Text = ""
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.Parent = customScriptFrame

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.45, 0, 0, 30)
executeButton.Position = UDim2.new(0, 10, 1, -60)
executeButton.Text = "Execute"
executeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 16
executeButton.Parent = customScriptFrame

local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0.45, 0, 0, 30)
exitButton.Position = UDim2.new(0.55, 10, 1, -60)
exitButton.Text = "Exit"
exitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
exitButton.TextColor3 = Color3.new(1, 1, 1)
exitButton.Font = Enum.Font.SourceSansBold
exitButton.TextSize = 16
exitButton.Parent = customScriptFrame

local function toggleCustomScript()
    customScriptGui.Enabled = not customScriptGui.Enabled
    buttonSound:Play()
end

executeButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    local scriptText = scriptBox.Text
    
    if scriptText ~= "" then
        local success, err = pcall(function()
            loadstring(scriptText)()
        end)
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -20, 0, 20)
        statusLabel.Position = UDim2.new(0, 10, 0, 10)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = success and "Script executed successfully!" or "Script error: "..tostring(err)
        statusLabel.TextColor3 = success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        statusLabel.Font = Enum.Font.SourceSansBold
        statusLabel.TextSize = 16
        statusLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        statusLabel.TextStrokeTransparency = 0
        statusLabel.Parent = customScriptFrame
        
        delay(3, function()
            statusLabel:Destroy()
        end)
    end
end)

exitButton.MouseButton1Click:Connect(toggleCustomScript)
customScriptButton.MouseButton1Click:Connect(toggleCustomScript)

--=== [ OTHER FUNCTIONS ] ===--
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
    
    -- Отключаем все активные функции
    if noclipEnabled then toggleNoClip() end
    if flyEnabled then toggleFly() end
    if freeCamEnabled then DisableFreeCam() end
    if clickTpEnabled then toggleClickTp() end
    if infiniteJumpEnabled then toggleInfiniteJump() end
    if espEnabled then toggleESP() end
    if antiAfkEnabled then toggleAntiAfk() end
    
    -- Восстанавливаем курсор
    if cursorConnection then
        cursorConnection:Disconnect()
    end
    UIS.MouseIconEnabled = true
    
    -- Удаляем GUI
    ScreenGui:Destroy()
    cursorGui:Destroy()
    customTpGui:Destroy()
    customScriptGui:Destroy()
end)

--=== [ THEME TOGGLE ] ===--
local function updateTheme()
    local colors = lightTheme and themeColors.light or themeColors.dark
    
    mainMenu.BackgroundColor3 = colors.background
    titleFrame.BackgroundColor3 = colors.secondary
    tabsFrame.BackgroundColor3 = colors.secondary
    playerInfo.TextColor3 = colors.text
    
    -- Обновляем все кнопки
    local function updateButtons(container)
        for _, child in ipairs(container:GetChildren()) do
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
    
    for _, container in ipairs(mainMenu:GetChildren()) do
        if container:IsA("Frame") and container.Name:match("Container") then
            updateButtons(container)
        end
    end
end

themeButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    lightTheme = not lightTheme
    updateTheme()
end)

--=== [ MENU TOGGLE ] ===--
local menuVisible = true
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftShift then
        buttonSound:Play()
        menuVisible = not menuVisible
        
        if menuVisible then
            TweenService:Create(mainMenu, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 10, 0, 10)
            }):Play()
        else
            TweenService:Create(mainMenu, TweenInfo.new(0.3), {
                Position = UDim2.new(0, -510, 0, 10)
            }):Play()
        end
    end
end)

-- Автоматическое применение FPS Boost
settings().Rendering.QualityLevel = 1
settings().Rendering.MeshCacheSize = 0
settings().Rendering.TextureCacheSize = 0
game:GetService("Lighting").GlobalShadows = false
if game:GetService("Lighting"):FindFirstChild("FantasySky") then
    game:GetService("Lighting").FantasySky:Destroy()
end

-- Обработка изменения персонажа
player.CharacterAdded:Connect(function(character)
    -- Восстанавливаем активные функции
    if noclipEnabled then
        task.wait()
        toggleNoClip()
    end
    if flyEnabled then
        task.wait(0.5)
        toggleFly()
    end
    if espEnabled then
        task.wait(0.5)
        toggleESP()
    end
end)
