local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Ожидаем загрузку игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Скрываем стандартный курсор
UIS.MouseIconEnabled = false

-- Создаем кастомный курсор
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

-- Анимация пульсации
local pulseTween = TweenService:Create(cursorInner, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.8,
    Size = UDim2.new(0, 12, 0, 12)
})
pulseTween:Play()

-- Обновляем позицию курсора
local cursorConnection
cursorConnection = RunService.RenderStepped:Connect(function()
    local mouseLocation = UIS:GetMouseLocation()
    cursorOuter.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y - 60)
end)

-- Тема интерфейса
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

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunctionalMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное меню
local mainMenu = Instance.new("Frame")
mainMenu.Name = "MainMenu"
mainMenu.Size = UDim2.new(0, 500, 1, -20)
mainMenu.Position = UDim2.new(0, 10, 0, 10)
mainMenu.BackgroundColor3 = themeColors.dark.background
mainMenu.BorderSizePixel = 0
mainMenu.ClipsDescendants = true
mainMenu.Parent = ScreenGui

-- Заголовок с информацией об игроке
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 80)
titleFrame.BackgroundColor3 = themeColors.dark.secondary
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainMenu

-- Аватар игрока
local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(0, 60, 0, 60)
avatar.Position = UDim2.new(0, 10, 0, 10)
avatar.BackgroundColor3 = themeColors.dark.button
avatar.BorderSizePixel = 0
avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatar.Parent = titleFrame

-- Информация об игроке
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

-- Вкладки меню
local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "Tabs"
tabsFrame.Size = UDim2.new(1, 0, 0, 30)
tabsFrame.Position = UDim2.new(0, 0, 0, 80)
tabsFrame.BackgroundColor3 = themeColors.dark.secondary
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = mainMenu

-- Функция создания вкладки
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

-- Создаем вкладки
local tab1 = createTab("Tab1", "Player", UDim2.new(0, 0, 0, 0))
local tab2 = createTab("Tab2", "TP", UDim2.new(0.166, 0, 0, 0))
local tab3 = createTab("Tab3", "PvP", UDim2.new(0.332, 0, 0, 0))
local tab4 = createTab("Tab4", "ESP", UDim2.new(0.498, 0, 0, 0))
local tab5 = createTab("Tab5", "Misc", UDim2.new(0.664, 0, 0, 0))
local tab6 = createTab("Tab6", "Scripts", UDim2.new(0.83, 0, 0, 0))

-- Контейнеры для вкладок
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

-- Функция переключения вкладок
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

-- Подключаем обработчики вкладок
tab1.MouseButton1Click:Connect(function() switchTab(tab1) end)
tab2.MouseButton1Click:Connect(function() switchTab(tab2) end)
tab3.MouseButton1Click:Connect(function() switchTab(tab3) end)
tab4.MouseButton1Click:Connect(function() switchTab(tab4) end)
tab5.MouseButton1Click:Connect(function() switchTab(tab5) end)
tab6.MouseButton1Click:Connect(function() switchTab(tab6) end)

-- Функция создания кнопки
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

-- Функция добавления индикатора
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

-- Создаем кнопки для вкладок
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
local customScriptButton = createButton(tab6Container, "CustomScriptButton", "Custom Script", UDim2.new(0, 10, 0, 135))

local boltRifleButton = createButton(tab3Container, "BoltRifleButton", "Bolt Rifle", UDim2.new(0, 10, 0, 0))

-- Добавляем индикаторы
local noclipIndicator = addIndicator(noclipButton)
local flyIndicator = addIndicator(flyButton)
local freeCamIndicator = addIndicator(freeCamButton)
local clickTpIndicator = addIndicator(clickTpButton)
local infiniteJumpIndicator = addIndicator(infiniteJumpButton)
local boltRifleIndicator = addIndicator(boltRifleButton)

-- Звук кнопок
local buttonSound = Instance.new("Sound")
buttonSound.SoundId = "rbxassetid://1319979230"
buttonSound.Volume = 0.5
buttonSound.Parent = SoundService

-- Функция FreeCam
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

-- Функция смены темы
local function toggleTheme()
    buttonSound:Play()
    lightTheme = not lightTheme
    local colors = lightTheme and themeColors.light or themeColors.dark
    
    mainMenu.BackgroundColor3 = colors.background
    titleFrame.BackgroundColor3 = colors.secondary
    tabsFrame.BackgroundColor3 = colors.secondary
    avatar.BackgroundColor3 = colors.button
    playerInfo.TextColor3 = colors.text
    
    tab1.BackgroundColor3 = tab1.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    tab2.BackgroundColor3 = tab2.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    tab3.BackgroundColor3 = tab3.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    tab4.BackgroundColor3 = tab4.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    tab5.BackgroundColor3 = tab5.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    tab6.BackgroundColor3 = tab6.BackgroundColor3 == themeColors.dark.accent and colors.accent or colors.button
    
    for _, container in ipairs({tab1Container, tab2Container, tab3Container, tab4Container, tab5Container, tab6Container}) do
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = colors.button
                child.TextColor3 = colors.text
            end
        end
    end
end

themeButton.MouseButton1Click:Connect(toggleTheme)

-- Функция реджоина
local function rejoinGame()
    buttonSound:Play()
    TeleportService:Teleport(game.PlaceId, player)
end

rejoinButton.MouseButton1Click:Connect(rejoinGame)

-- Функция ресета персонажа
local function resetCharacter()
    buttonSound:Play()
    local character = player.Character
    if character then
        character:BreakJoints()
    end
end

resetButton.MouseButton1Click:Connect(resetCharacter)

-- Функция отключения скрипта
local function disableScript()
    buttonSound:Play()
    
    if freeCamEnabled then DisableFreeCam() end
    if cursorConnection then cursorConnection:Disconnect() end
    
    ScreenGui:Destroy()
    cursorGui:Destroy()
    UIS.MouseIconEnabled = true
    
    local character = player.Character
    if character then
        character:BreakJoints()
    end
end

disableButton.MouseButton1Click:Connect(disableScript)

-- Infinite Jump
local infiniteJumpEnabled = false
local infiniteJumpConnection
local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        buttonSound:Play()
        infiniteJumpIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        infiniteJumpConnection = UIS.JumpRequest:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
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

-- Custom Script
local customScriptInput = ""
local inputActive = false
local inputGui = nil

local function showScriptWindow()
    if inputGui then inputGui:Destroy() end
    
    inputGui = Instance.new("ScreenGui")
    inputGui.Name = "ScriptInputWindow"
    inputGui.ResetOnSpawn = false
    inputGui.Parent = player.PlayerGui
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 400, 0, 250)
    inputFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    inputFrame.BackgroundColor3 = themeColors.dark.inputField
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = inputGui
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 1, -60)
    textBox.Position = UDim2.new(0, 10, 0, 10)
    textBox.BackgroundColor3 = themeColors.dark.secondary
    textBox.TextColor3 = themeColors.dark.text
    textBox.Text = customScriptInput
    textBox.ClearTextOnFocus = false
    textBox.TextWrapped = true
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = Enum.TextYAlignment.Top
    textBox.Parent = inputFrame
    
    local executeButton = Instance.new("TextButton")
    executeButton.Name = "ExecuteButton"
    executeButton.Text = "Выполнить (Enter)"
    executeButton.Size = UDim2.new(0.5, -15, 0, 40)
    executeButton.Position = UDim2.new(0, 10, 1, -45)
    executeButton.BackgroundColor3 = themeColors.dark.button
    executeButton.TextColor3 = themeColors.dark.text
    executeButton.Font = Enum.Font.SourceSansBold
    executeButton.TextSize = 16
    executeButton.Parent = inputFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "Закрыть (ЛКМ)"
    closeButton.Size = UDim2.new(0.5, -15, 0, 40)
    closeButton.Position = UDim2.new(0.5, 5, 1, -45)
    closeButton.BackgroundColor3 = themeColors.dark.button
    closeButton.TextColor3 = themeColors.dark.text
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.Parent = inputFrame
    
    textBox:CaptureFocus()
    
    executeButton.MouseButton1Click:Connect(function()
        buttonSound:Play()
        local scriptText = textBox.Text
        if scriptText and scriptText ~= "" then
            pcall(function()
                loadstring(scriptText)()
            end)
        end
        inputGui:Destroy()
        inputActive = false
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        buttonSound:Play()
        inputGui:Destroy()
        inputActive = false
    end)
    
    local inputConnection
    inputConnection = UIS.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.Return then
                local scriptText = textBox.Text
                if scriptText and scriptText ~= "" then
                    pcall(function()
                        loadstring(scriptText)()
                    end)
                end
                inputGui:Destroy()
                inputActive = false
                inputConnection:Disconnect()
            end
        end
    end)
end

local function toggleCustomScript()
    buttonSound:Play()
    if inputActive then return end
    
    inputActive = true
    customScriptButton.Text = "[Введите скрипт]"
    customScriptInput = ""
    
    local hint = Instance.new("ScreenGui")
    hint.Name = "ScriptInputHint"
    hint.ResetOnSpawn = false
    hint.Parent = player.PlayerGui
    
    local hintText = Instance.new("TextLabel")
    hintText.Size = UDim2.new(0, 300, 0, 50)
    hintText.Position = UDim2.new(0.5, -150, 0.8, 0)
    hintText.BackgroundTransparency = 1
    hintText.Text = "Введите скрипт прямо на кнопке\n(Enter - подтвердить, ЛКМ - отмена)"
    hintText.TextColor3 = themeColors.dark.text
    hintText.Font = Enum.Font.SourceSansBold
    hintText.TextSize = 14
    hintText.TextWrapped = true
    hintText.Parent = hint
    
    local mouseButton1Connection
    mouseButton1Connection = UIS.InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
            hint:Destroy()
            customScriptButton.Text = "Custom Script"
            inputActive = false
            mouseButton1Connection:Disconnect()
        end
    end)
    
    local inputConnection
    inputConnection = UIS.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.Return then
                if customScriptInput ~= "" then
                    pcall(function()
                        loadstring(customScriptInput)()
                    end)
                end
                hint:Destroy()
                customScriptButton.Text = "Custom Script"
                inputActive = false
                inputConnection:Disconnect()
                mouseButton1Connection:Disconnect()
                
            elseif input.KeyCode == Enum.KeyCode.Backspace then
                customScriptInput = customScriptInput:sub(1, -2)
                customScriptButton.Text = "[Введите скрипт]\n"..customScriptInput
                
            elseif input.KeyCode == Enum.KeyCode.Space then
                customScriptInput = customScriptInput.." "
                customScriptButton.Text = "[Введите скрипт]\n"..customScriptInput
                
            elseif #input.KeyCode.Name == 1 then
                customScriptInput = customScriptInput..input.KeyCode.Name:lower()
                customScriptButton.Text = "[Введите скрипт]\n"..customScriptInput
                
                if #customScriptInput > 20 then
                    hint:Destroy()
                    showScriptWindow()
                    inputConnection:Disconnect()
                    mouseButton1Connection:Disconnect()
                end
            end
        end
    end)
end

customScriptButton.MouseButton1Click:Connect(toggleCustomScript)

-- Остальные функции
local function toggleAntiAfk() buttonSound:Play() end
local function toggleFpsBoost() buttonSound:Play() end
local function toggleBoltRifle() buttonSound:Play() end
local function toggleClickTp() buttonSound:Play() end

antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)
fpsBoostButton.MouseButton1Click:Connect(toggleFpsBoost)
boltRifleButton.MouseButton1Click:Connect(toggleBoltRifle)
clickTpButton.MouseButton1Click:Connect(toggleClickTp)

-- Респавн персонажа
player.CharacterAdded:Connect(function(character)
    if freeCamEnabled then
        DisableFreeCam()
        EnableFreeCam()
    end
    if infiniteJumpEnabled then
        toggleInfiniteJump()
        toggleInfiniteJump()
    end
end)

-- Управление меню
local menuVisible = true
local function toggleMenu()
    buttonSound:Play()
    menuVisible = not menuVisible
    
    if menuVisible then
        TweenService:Create(mainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 10)
        }):Play()
    else
        TweenService:Create(mainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -510, 0, 10)
        }):Play()
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftShift then
        toggleMenu()
    end
    if not processed and input.KeyCode == Enum.KeyCode.F and freeCamEnabled then
        DisableFreeCam()
    end
end)

toggleMenu()
