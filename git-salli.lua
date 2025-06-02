-- Часть 1: Интерфейс
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

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
    tab.Size = UDim2.new(0.125, 0, 1, 0)
    tab.Position = position
    tab.BackgroundColor3 = name == "Tab1" and themeColors.dark.accent or themeColors.dark.button
    tab.TextColor3 = themeColors.dark.text
    tab.Font = Enum.Font.SourceSansBold
    tab.TextSize = 16
    tab.Parent = tabsFrame
    return tab
end

local tab1 = createTab("Tab1", "Player", UDim2.new(0, 0, 0, 0))
local tab2 = createTab("Tab2", "TP", UDim2.new(0.125, 0, 0, 0))
local tab3 = createTab("Tab3", "PvP", UDim2.new(0.25, 0, 0, 0))
local tab4 = createTab("Tab4", "ESP", UDim2.new(0.375, 0, 0, 0))
local tab5 = createTab("Tab5", "Visuals", UDim2.new(0.5, 0, 0, 0))
local tab6 = createTab("Tab6", "Scripts", UDim2.new(0.625, 0, 0, 0))
local tab7 = createTab("Tab7", "Settings", UDim2.new(0.75, 0, 0, 0))

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

-- Создание ползунка
local function createSlider(parent, name, text, position, minValue, maxValue, defaultValue)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name.."Frame"
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = position
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = name.."Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text..": "..defaultValue
    label.BackgroundTransparency = 1
    label.TextColor3 = themeColors.dark.text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Name = name.."Slider"
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = themeColors.dark.button
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Name = name.."Fill"
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = themeColors.dark.accent
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local handle = Instance.new("TextButton")
    handle.Name = name.."Handle"
    handle.Size = UDim2.new(0, 15, 0, 15)
    handle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -3, 0, -3)
    handle.BackgroundColor3 = Color3.new(1, 1, 1)
    handle.Text = ""
    handle.Parent = slider
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = handle
    
    local value = defaultValue
    local dragging = false
    
    local function updateValue(newValue)
        newValue = math.clamp(newValue, minValue, maxValue)
        value = newValue
        fill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
        handle.Position = UDim2.new((value - minValue) / (maxValue - minValue), -3, 0, -3)
        label.Text = text..": "..string.format("%.1f", value)
    end
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            updateValue(minValue + (maxValue - minValue) * relativeX)
        end
    end)
    
    return {
        frame = sliderFrame,
        getValue = function() return value end,
        setValue = updateValue
    }
end

-- Добавление индикатора
local function addIndicator(button, color)
    color = color or Color3.new(0.5, 0, 0)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -20, 0.5, -8)
    indicator.BackgroundColor3 = color
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
local speedHackButton = createButton(tab1Container, "SpeedHackButton", "Speed Hack", UDim2.new(0, 10, 0, 90))
local jumpHackButton = createButton(tab1Container, "JumpHackButton", "Jump Hack", UDim2.new(0, 10, 0, 135))
local freeCamButton = createButton(tab1Container, "FreeCamButton", "FreeCam (WASD+Shift+RMB)", UDim2.new(0, 10, 0, 180))
local rejoinButton = createButton(tab1Container, "RejoinButton", "Rejoin", UDim2.new(0, 10, 0, 225))
local resetButton = createButton(tab1Container, "ResetButton", "Reset", UDim2.new(0, 10, 0, 270))
local disableButton = createButton(tab1Container, "DisableButton", "Отключить скрипт", UDim2.new(0, 10, 0, 315))

-- Ползунки для Player
local speedSlider = createSlider(tab1Container, "SpeedSlider", "Speed", UDim2.new(0, 10, 0, 360), 0.1, 100, 16)
local jumpSlider = createSlider(tab1Container, "JumpSlider", "Jump Power", UDim2.new(0, 10, 0, 425), 0.1, 100, 50)

-- TP
local clickTpButton = createButton(tab2Container, "ClickTPButton", "Click TP", UDim2.new(0, 10, 0, 0))
local customTpButton = createButton(tab2Container, "CustomTPButton", "Custom TP (Coords)", UDim2.new(0, 10, 0, 45))

-- PvP
local boltRifleButton = createButton(tab3Container, "BoltRifleButton", "Винтовка болт", UDim2.new(0, 10, 0, 0))

-- ESP
local espButton = createButton(tab4Container, "ESPButton", "ESP Players", UDim2.new(0, 10, 0, 0))
local espColorButton = createButton(tab4Container, "ESPColorButton", "ESP Color", UDim2.new(0, 10, 0, 45))

-- Visuals
local fullBrightButton = createButton(tab5Container, "FullBrightButton", "Full Bright", UDim2.new(0, 10, 0, 0))
local removeFogButton = createButton(tab5Container, "RemoveFogButton", "Remove Fog", UDim2.new(0, 10, 0, 45))
local ambientButton = createButton(tab5Container, "AmbientButton", "Override Ambient", UDim2.new(0, 10, 0, 90))
local hideNamesButton = createButton(tab5Container, "HideNamesButton", "Hide Player Names", UDim2.new(0, 10, 0, 135))
local hidePlayersButton = createButton(tab5Container, "HidePlayersButton", "Hide Players", UDim2.new(0, 10, 0, 180))

-- Scripts
local buildBoatButton = createButton(tab6Container, "BuildBoatButton", "Build a Boat", UDim2.new(0, 10, 0, 0))
local deadRailsButton = createButton(tab6Container, "DeadRailsButton", "Dead Rails", UDim2.new(0, 10, 0, 45))
local infiniteYieldButton = createButton(tab6Container, "InfiniteYieldButton", "Infinite Yield", UDim2.new(0, 10, 0, 90))
local customScriptButton = createButton(tab6Container, "CustomScriptButton", "Custom Script (Ender)", UDim2.new(0, 10, 0, 135))

-- Settings
local themeButton = createButton(tab7Container, "ThemeButton", "Сменить тему", UDim2.new(0, 10, 0, 0))

-- Индикаторы
local noclipIndicator = addIndicator(noclipButton)
local flyIndicator = addIndicator(flyButton)
local speedHackIndicator = addIndicator(speedHackButton)
local jumpHackIndicator = addIndicator(jumpHackButton)
local freeCamIndicator = addIndicator(freeCamButton)
local clickTpIndicator = addIndicator(clickTpButton)
local boltRifleIndicator = addIndicator(boltRifleButton)
local espIndicator = addIndicator(espButton, Color3.new(1, 0, 0))
local fullBrightIndicator = addIndicator(fullBrightButton)
local removeFogIndicator = addIndicator(removeFogButton)
local ambientIndicator = addIndicator(ambientButton)
local hideNamesIndicator = addIndicator(hideNamesButton)
local hidePlayersIndicator = addIndicator(hidePlayersButton)

-- Звук кнопок
local buttonSound = Instance.new("Sound")
buttonSound.SoundId = "rbxassetid://5828817939"
buttonSound.Volume = 0.5
buttonSound.Parent = SoundService

-- Часть 2: Сложные функции
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

--=== [ FLY ] ===--
local flyEnabled = false
local flySpeed = 1
local flyConnection
local bodyVelocity

local function ToggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        buttonSound:Play()
        flyIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1000
                bodyVelocity.Parent = humanoidRootPart
                
                flyConnection = RunService.Heartbeat:Connect(function(dt)
                    if not character or not humanoidRootPart or not bodyVelocity then return end
                    
                    local camera = workspace.CurrentCamera
                    local moveVector = Vector3.new()
                    
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector + Vector3.new(0, -1, 0) end
                    
                    if moveVector.Magnitude > 0 then
                        bodyVelocity.Velocity = moveVector.Unit * flySpeed * 50
                    else
                        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    else
        buttonSound:Play()
        flyIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

flyButton.MouseButton1Click:Connect(ToggleFly)

--=== [ NOCLIP ] ===--
local noclipEnabled = false
local noclipConnection
local noclipParts = {}

local function ToggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        buttonSound:Play()
        noclipIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                    table.insert(noclipParts, part)
                end
            end
            
            noclipConnection = character.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                    table.insert(noclipParts, part)
                end
            end)
        end
    else
        buttonSound:Play()
        noclipIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        for _, part in pairs(noclipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        noclipParts = {}
    end
end

noclipButton.MouseButton1Click:Connect(ToggleNoClip)

--=== [ SPEED HACK ] ===--
local speedHackEnabled = false
local speedHackConnection
local originalWalkSpeed = 16

local function ToggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    
    if speedHackEnabled then
        buttonSound:Play()
        speedHackIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        speedHackConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedSlider.getValue()
                end
            end
        end)
    else
        buttonSound:Play()
        speedHackIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        if speedHackConnection then
            speedHackConnection:Disconnect()
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end
end

speedHackButton.MouseButton1Click:Connect(ToggleSpeedHack)

--=== [ JUMP HACK ] ===--
local jumpHackEnabled = false
local jumpHackConnection
local originalJumpPower = 50

local function ToggleJumpHack()
    jumpHackEnabled = not jumpHackEnabled
    
    if jumpHackEnabled then
        buttonSound:Play()
        jumpHackIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        jumpHackConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jumpSlider.getValue()
                end
            end
        end)
    else
        buttonSound:Play()
        jumpHackIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        if jumpHackConnection then
            jumpHackConnection:Disconnect()
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = originalJumpPower
            end
        end
    end
end

jumpHackButton.MouseButton1Click:Connect(ToggleJumpHack)

--=== [ CLICK TP ] ===--
local clickTpEnabled = false
local clickTpConnection

local function ToggleClickTp()
    clickTpEnabled = not clickTpEnabled
    
    if clickTpEnabled then
        buttonSound:Play()
        clickTpIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        clickTpConnection = mouse.Button1Down:Connect(function()
            if not player.Character then return end
            
            local target = mouse.Hit.Position
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(target.X, target.Y + 3, target.Z)
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

clickTpButton.MouseButton1Click:Connect(ToggleClickTp)

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

local function ToggleCustomTp()
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

exitButton.MouseButton1Click:Connect(ToggleCustomTp)
customTpButton.MouseButton1Click:Connect(ToggleCustomTp)

--=== [ BOLT RIFLE ] ===--
local boltRifleEnabled = false

local function ToggleBoltRifle()
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

boltRifleButton.MouseButton1Click:Connect(ToggleBoltRifle)

--=== [ ESP ] ===--
local espEnabled = false
local espHighlights = {}
local espColor = Color3.new(1, 0, 0)

local function CreateESP(player)
    if player == Players.LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = espColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    
    local function AttachHighlight(character)
        if character then
            highlight.Adornee = character
            highlight.Parent = character
            espHighlights[player] = highlight
        end
    end
    
    if player.Character then
        AttachHighlight(player.Character)
    end
    
    player.CharacterAdded:Connect(AttachHighlight)
    player.CharacterRemoving:Connect(function()
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
    end)
end

local function ToggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        buttonSound:Play()
        espIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        for _, player in ipairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        Players.PlayerAdded:Connect(CreateESP)
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

espButton.MouseButton1Click:Connect(ToggleESP)

--=== [ ESP COLOR PICKER ] ===--
local espColorGui = Instance.new("ScreenGui")
espColorGui.Name = "ESPColorGUI"
espColorGui.ResetOnSpawn = false
espColorGui.Enabled = false
espColorGui.Parent = player.PlayerGui

local espColorFrame = Instance.new("Frame")
espColorFrame.Size = UDim2.new(0, 300, 0, 200)
espColorFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
espColorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espColorFrame.BorderSizePixel = 0
espColorFrame.Parent = espColorGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ESP Color Picker"
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = espColorFrame

local colorPicker = Instance.new("ImageLabel")
colorPicker.Size = UDim2.new(0, 280, 0, 140)
colorPicker.Position = UDim2.new(0, 10, 0, 40)
colorPicker.Image = "rbxassetid://2615689005"
colorPicker.Parent = espColorFrame

local colorCursor = Instance.new("Frame")
colorCursor.Size = UDim2.new(0, 10, 0, 10)
colorCursor.AnchorPoint = Vector2.new(0.5, 0.5)
colorCursor.BackgroundColor3 = Color3.new(1, 1, 1)
colorCursor.BorderSizePixel = 2
colorCursor.BorderColor3 = Color3.new(0, 0, 0)
colorCursor.Parent = colorPicker

local function UpdateESPColor(color)
    espColor = color
    espIndicator.BackgroundColor3 = color
    
    for _, highlight in pairs(espHighlights) do
        if highlight then
            highlight.FillColor = color
        end
    end
end

colorPicker.MouseButton1Down:Connect(function(x, y)
    local relativeX = (x - colorPicker.AbsolutePosition.X) / colorPicker.AbsoluteSize.X
    local relativeY = (y - colorPicker.AbsolutePosition.Y) / colorPicker.AbsoluteSize.Y
    
    relativeX = math.clamp(relativeX, 0, 1)
    relativeY = math.clamp(relativeY, 0, 1)
    
    colorCursor.Position = UDim2.new(relativeX, 0, relativeY, 0)
    
    local hue = relativeX
    local saturation = 1 - relativeY
    local value = 1
    
    local color = Color3.fromHSV(hue, saturation, value)
    UpdateESPColor(color)
end)

local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(1, -20, 0, 30)
exitButton.Position = UDim2.new(0, 10, 1, -40)
exitButton.Text = "Exit"
exitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
exitButton.TextColor3 = Color3.new(1, 1, 1)
exitButton.Font = Enum.Font.SourceSansBold
exitButton.TextSize = 16
exitButton.Parent = espColorFrame

local function ToggleESPColorPicker()
    espColorGui.Enabled = not espColorGui.Enabled
    buttonSound:Play()
end

exitButton.MouseButton1Click:Connect(ToggleESPColorPicker)
espColorButton.MouseButton1Click:Connect(ToggleESPColorPicker)

-- Часть 3: Основные функции
--=== [ VISUALS ] ===--
-- Full Bright
local fullBrightEnabled = false
local originalBrightness

local function ToggleFullBright()
    fullBrightEnabled = not fullBrightEnabled
    
    if fullBrightEnabled then
        buttonSound:Play()
        fullBrightIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        originalBrightness = Lighting.Brightness
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        buttonSound:Play()
        fullBrightIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if originalBrightness then
            Lighting.Brightness = originalBrightness
        end
    end
end

fullBrightButton.MouseButton1Click:Connect(ToggleFullBright)

-- Remove Fog
local removeFogEnabled = false
local originalFogEnd

local function ToggleRemoveFog()
    removeFogEnabled = not removeFogEnabled
    
    if removeFogEnabled then
        buttonSound:Play()
        removeFogIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        originalFogEnd = Lighting.FogEnd
        Lighting.FogEnd = 100000
    else
        buttonSound:Play()
        removeFogIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if originalFogEnd then
            Lighting.FogEnd = originalFogEnd
        end
    end
end

removeFogButton.MouseButton1Click:Connect(ToggleRemoveFog)

-- Ambient
local ambientEnabled = false
local originalAmbient

local function ToggleAmbient()
    ambientEnabled = not ambientEnabled
    
    if ambientEnabled then
        buttonSound:Play()
        ambientIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        originalAmbient = Lighting.Ambient
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        buttonSound:Play()
        ambientIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        if originalAmbient then
            Lighting.Ambient = originalAmbient
        end
    end
end

ambientButton.MouseButton1Click:Connect(ToggleAmbient)

-- Hide Names
local hideNamesEnabled = false
local nameTags = {}

local function ToggleHideNames()
    hideNamesEnabled = not hideNamesEnabled
    
    if hideNamesEnabled then
        buttonSound:Play()
        hideNamesIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.DisplayName = ""
                        table.insert(nameTags, humanoid)
                    end
                end
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if hideNamesEnabled then
                player.CharacterAdded:Connect(function(character)
                    local humanoid = character:WaitForChildOfClass("Humanoid")
                    humanoid.DisplayName = ""
                    table.insert(nameTags, humanoid)
                end)
            end
        end)
    else
        buttonSound:Play()
        hideNamesIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        for _, humanoid in ipairs(nameTags) do
            if humanoid and humanoid.Parent then
                humanoid.DisplayName = humanoid.Name
            end
        end
        nameTags = {}
    end
end

hideNamesButton.MouseButton1Click:Connect(ToggleHideNames)

-- Hide Players
local hidePlayersEnabled = false
local hiddenPlayers = {}

local function ToggleHidePlayers()
    hidePlayersEnabled = not hidePlayersEnabled
    
    if hidePlayersEnabled then
        buttonSound:Play()
        hidePlayersIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local character = player.Character
                if character then
                    character.Archivable = true
                    local clone = character:Clone()
                    clone.Parent = workspace
                    hiddenPlayers[player] = {character = character, clone = clone}
                    character.Parent = nil
                end
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if hidePlayersEnabled then
                player.CharacterAdded:Connect(function(character)
                    character.Archivable = true
                    local clone = character:Clone()
                    clone.Parent = workspace
                    hiddenPlayers[player] = {character = character, clone = clone}
                    character.Parent = nil
                end)
            end
        end)
    else
        buttonSound:Play()
        hidePlayersIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
        
        for player, data in pairs(hiddenPlayers) do
            if data.clone then
                data.clone:Destroy()
            end
            if data.character and player.Character == data.character then
                data.character.Parent = workspace
            end
        end
        hiddenPlayers = {}
    end
end

hidePlayersButton.MouseButton1Click:Connect(ToggleHidePlayers)

--=== [ SCRIPTS ] ===--
-- Build a Boat
buildBoatButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Build%20A%20Boat%20For%20Treasure/Script.lua"))()
end)

-- Dead Rails
deadRailsButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Dead%20Rails/Script.lua"))()
end)

-- Infinite Yield
infiniteYieldButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Custom Script
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

local function ToggleCustomScript()
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

exitButton.MouseButton1Click:Connect(ToggleCustomScript)
customScriptButton.MouseButton1Click:Connect(ToggleCustomScript)

--=== [ SETTINGS ] ===--
local function UpdateTheme()
    local colors = lightTheme and themeColors.light or themeColors.dark
    
    mainMenu.BackgroundColor3 = colors.background
    titleFrame.BackgroundColor3 = colors.secondary
    tabsFrame.BackgroundColor3 = colors.secondary
    playerInfo.TextColor3 = colors.text
    
    -- Обновляем все кнопки
    local function UpdateButtons(container)
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
            UpdateButtons(container)
        end
    end
end

themeButton.MouseButton1Click:Connect(function()
    buttonSound:Play()
    lightTheme = not lightTheme
    UpdateTheme()
end)

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
    if noclipEnabled then ToggleNoClip() end
    if flyEnabled then ToggleFly() end
    if freeCamEnabled then DisableFreeCam() end
    if clickTpEnabled then ToggleClickTp() end
    if speedHackEnabled then ToggleSpeedHack() end
    if jumpHackEnabled then ToggleJumpHack() end
    if espEnabled then ToggleESP() end
    if fullBrightEnabled then ToggleFullBright() end
    if removeFogEnabled then ToggleRemoveFog() end
    if ambientEnabled then ToggleAmbient() end
    if hideNamesEnabled then ToggleHideNames() end
    if hidePlayersEnabled then ToggleHidePlayers() end
    
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
    espColorGui:Destroy()
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
        ToggleNoClip()
        ToggleNoClip()
    end
    if flyEnabled then
        task.wait(0.5)
        ToggleFly()
        ToggleFly()
    end
    if speedHackEnabled then
        task.wait(0.5)
        ToggleSpeedHack()
        ToggleSpeedHack()
    end
    if jumpHackEnabled then
        task.wait(0.5)
        ToggleJumpHack()
        ToggleJumpHack()
    end
    if espEnabled then
        task.wait(0.5)
        ToggleESP()
        ToggleESP()
    end
end)
