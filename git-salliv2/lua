-- Удаляем старые копии GUI
if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("GitSalliMenu") then
	game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui").GitSalliMenu:Destroy()
end

-- Создание основного окна
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local DragHandle = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ActiveTabTitle = Instance.new("TextLabel")
local TabsFrame = Instance.new("Frame")
local Tabs = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local PlayersTab = Instance.new("TextButton")
local TPTab = Instance.new("TextButton")
local VisualsTab = Instance.new("TextButton")
local ESPTab = Instance.new("TextButton")
local CustomScriptTab = Instance.new("TextButton")
local SettingsTab = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local RightButtonsFrame = Instance.new("Frame")

-- Настройка GUI
ScreenGui.Name = "GitSalliMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.Size = UDim2.new(0, 600, 0, 350)

-- Панель перемещения
DragHandle.Name = "DragHandle"
DragHandle.Parent = MainFrame
DragHandle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DragHandle.BorderSizePixel = 0
DragHandle.Size = UDim2.new(1, 0, 0, 30)

Title.Name = "Title"
Title.Parent = DragHandle
Title.BackgroundTransparency = 1.0
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "GIT-SALLI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20.0
Title.TextXAlignment = Enum.TextXAlignment.Left

ActiveTabTitle.Name = "ActiveTabTitle"
ActiveTabTitle.Parent = DragHandle
ActiveTabTitle.BackgroundTransparency = 1.0
ActiveTabTitle.Position = UDim2.new(0, 210, 0, 0)
ActiveTabTitle.Size = UDim2.new(0, 380, 1, 0)
ActiveTabTitle.Font = Enum.Font.SourceSans
ActiveTabTitle.Text = "Players"
ActiveTabTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ActiveTabTitle.TextSize = 18.0
ActiveTabTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Функция перемещения окна
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

DragHandle.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

-- Вкладки
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabsFrame.BorderSizePixel = 0
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.Size = UDim2.new(0, 120, 0, 320)

Tabs.Name = "Tabs"
Tabs.Parent = TabsFrame
Tabs.BackgroundTransparency = 1.0
Tabs.Size = UDim2.new(1, 0, 1, 0)

UIListLayout.Parent = Tabs
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Функция создания вкладок с полоской-индикатором
local function createTab(name, hasIcon, iconId)
	local tab = Instance.new("TextButton")
	tab.Name = name .. "Tab"
	tab.Parent = Tabs
	tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tab.BorderSizePixel = 0
	tab.Size = UDim2.new(0.9, 0, 0, 35)
	tab.Font = Enum.Font.SourceSans
	tab.Text = hasIcon and "  "..name or name
	tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.TextSize = 14.0
	tab.TextXAlignment = Enum.TextXAlignment.Left

	-- Добавляем иконку если указано
	if hasIcon and iconId then
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Parent = tab
		icon.BackgroundTransparency = 1
		icon.Position = UDim2.new(0, 80, 0.5, -10)
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Image = "rbxassetid://"..iconId
	end

	-- Полоска-индикатор активной вкладки (как в оригинале)
	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Parent = tab
	indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	indicator.BorderSizePixel = 0
	indicator.Position = UDim2.new(0, 0, 1, -3)
	indicator.Size = UDim2.new(1, 0, 0, 3)
	indicator.Visible = false

	return tab
end

-- Создаем вкладки с иконками
PlayersTab = createTab("Players", true, "7992557358")
TPTab = createTab("TP", true, "123358713103625")
VisualsTab = createTab("Visuals", true, "78134819718605")
ESPTab = createTab("ESP", true, "138304533480574")
CustomScriptTab = createTab("Custom Script", true, "130521044774541")
SettingsTab = createTab("Settings", true, "17124529105")

-- Контентная область
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.Size = UDim2.new(0, 480, 0, 320)

-- Правая панель для скриптов
RightButtonsFrame.Name = "RightButtonsFrame"
RightButtonsFrame.Parent = MainFrame
RightButtonsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RightButtonsFrame.BorderSizePixel = 0
RightButtonsFrame.Position = UDim2.new(0, 475, 0, 30)
RightButtonsFrame.Size = UDim2.new(0, 125, 0, 300)
RightButtonsFrame.Visible = false

-- Кнопки скриптов
local function createScriptButton(name, posY, scriptUrl)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Parent = RightButtonsFrame
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.BorderSizePixel = 0
	button.Position = UDim2.new(0.1, 0, 0, posY)
	button.Size = UDim2.new(0.8, 0, 0, 30)
	button.Font = Enum.Font.SourceSans
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14.0

	if scriptUrl then
		button.MouseButton1Click:Connect(function()
			loadstring(game:HttpGet(scriptUrl))()
		end)
	end

	return button
end

createScriptButton("Dead Reils", 20, "https://rawscripts.net/raw/Dead-Rails-Alpha-Dead-Rails-OP-KiciaHook-Script-Fastest-Auto-Farm-35961")
createScriptButton("BABFT", 60, "https://raw.githubusercontent.com/TheRealAsu/BABFT/main/Jan25_Source.lua")
createScriptButton("Menu MOD", 100, "https://raw.githubusercontent.com/serezanet2/serezanet2-GIT-SALLI/main/Menu-MOD")

-- Кастомный скрипт
local CustomContent = Instance.new("Frame")
CustomContent.Name = "CustomContent"
CustomContent.Parent = ContentFrame
CustomContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CustomContent.BorderSizePixel = 0
CustomContent.Position = UDim2.new(0, 10, 0, 10)
CustomContent.Size = UDim2.new(1, -20, 1, -20)
CustomContent.Visible = false

local ScriptInput = Instance.new("TextBox")
ScriptInput.Name = "ScriptInput"
ScriptInput.Parent = CustomContent
ScriptInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScriptInput.BorderSizePixel = 0
ScriptInput.Position = UDim2.new(0, 0, 0, 0)
ScriptInput.Size = UDim2.new(1, 0, 0.7, -5)
ScriptInput.Font = Enum.Font.Code
ScriptInput.Text = ""
ScriptInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptInput.TextSize = 14.0
ScriptInput.TextWrapped = true
ScriptInput.TextXAlignment = Enum.TextXAlignment.Left
ScriptInput.TextYAlignment = Enum.TextYAlignment.Top
ScriptInput.ClearTextOnFocus = false
ScriptInput.MultiLine = true

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Parent = CustomContent
ExecuteButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Position = UDim2.new(0, 0, 0.7, 5)
ExecuteButton.Size = UDim2.new(1, 0, 0.15, 0)
ExecuteButton.Font = Enum.Font.SourceSans
ExecuteButton.Text = "Execute Script"
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextSize = 16.0

ExecuteButton.MouseButton1Click:Connect(function()
	local scriptText = ScriptInput.Text
	if scriptText == "" then
		warn("Script field is empty!")
		return
	end

	local success, err = pcall(function()
		local fn, loadErr = loadstring(scriptText)
		if not fn then error(loadErr) end
		fn()
	end)

	if not success then
		warn("Script Error: " .. tostring(err))
	end
end)

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Parent = CustomContent
ClearButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0, 0, 0.85, 5)
ClearButton.Size = UDim2.new(1, 0, 0.15, 0)
ClearButton.Font = Enum.Font.SourceSans
ClearButton.Text = "Clear Script"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 16.0

ClearButton.MouseButton1Click:Connect(function()
	ScriptInput.Text = ""
end)

-- Контент для вкладки Settings
local SettingsContent = Instance.new("Frame")
SettingsContent.Name = "SettingsContent"
SettingsContent.Parent = ContentFrame
SettingsContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsContent.BorderSizePixel = 0
SettingsContent.Position = UDim2.new(0, 10, 0, 10)
SettingsContent.Size = UDim2.new(1, -20, 1, -20)
SettingsContent.Visible = false

-- Функция создания кнопки с круглым индикатором
local function createToggleButton(name, posY, initialState)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = name .. "Frame"
	buttonFrame.Parent = SettingsContent
	buttonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Position = UDim2.new(0.05, 0, 0, posY)
	buttonFrame.Size = UDim2.new(0.9, 0, 0, 35)

	local button = Instance.new("TextButton")
	button.Name = name .. "Button"
	button.Parent = buttonFrame
	button.BackgroundTransparency = 1.0
	button.BorderSizePixel = 0
	button.Position = UDim2.new(0, 0, 0, 0)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Font = Enum.Font.SourceSans
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 16.0
	button.TextXAlignment = Enum.TextXAlignment.Left

	-- Круглый индикатор для переключателей
	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "ToggleIndicator"
	toggleIndicator.Parent = buttonFrame
	toggleIndicator.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	toggleIndicator.BorderSizePixel = 0
	toggleIndicator.Position = UDim2.new(0.85, 0, 0.5, -10)
	toggleIndicator.Size = UDim2.new(0, 20, 0, 20)

	-- Делаем индикатор круглым
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = toggleIndicator

	local isToggled = initialState

	button.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		toggleIndicator.BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		print(name .. " toggled:", isToggled)
	end)

	return button, toggleIndicator
end

-- Создаем кнопки с переключателями
createToggleButton("No Clip", 30, false)
createToggleButton("Speed Hack", 80, true)
createToggleButton("Anti-AFK", 130, false)
createToggleButton("Fly Mode", 180, false)

-- Переключение вкладок
local activeTab = PlayersTab

local function showTab(tab)
	-- Сбрасываем стиль всех вкладок
	for _, child in ipairs(Tabs:GetChildren()) do
		if child:IsA("TextButton") then
			child.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			child.TextColor3 = Color3.fromRGB(255, 255, 255)
			child.Indicator.Visible = false
		end
	end

	-- Устанавливаем стиль для активной вкладки
	activeTab = tab
	tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab.Indicator.Visible = true

	ActiveTabTitle.Text = tab.Text

	-- Очищаем контент
	for _, child in ipairs(ContentFrame:GetChildren()) do
		if child.Name ~= "SettingsContent" and child.Name ~= "CustomContent" then
			child:Destroy()
		end
	end

	RightButtonsFrame.Visible = (tab == CustomScriptTab)

	if tab == CustomScriptTab then
		ContentFrame.Size = UDim2.new(0, 355, 0, 320)
		CustomContent.Visible = true
		SettingsContent.Visible = false
	elseif tab == SettingsTab then
		ContentFrame.Size = UDim2.new(0, 480, 0, 320)
		CustomContent.Visible = false
		SettingsContent.Visible = true
	else
		ContentFrame.Size = UDim2.new(0, 480, 0, 320)
		CustomContent.Visible = false
		SettingsContent.Visible = false

		-- Пример контента для других вкладок
		local label = Instance.new("TextLabel")
		label.Parent = ContentFrame
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(1, 0, 1, 0)
		label.Text = "Content for " .. tab.Text .. " tab"
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 20
	end
end

-- Подключение вкладок
PlayersTab.MouseButton1Click:Connect(function() showTab(PlayersTab) end)
TPTab.MouseButton1Click:Connect(function() showTab(TPTab) end)
VisualsTab.MouseButton1Click:Connect(function() showTab(VisualsTab) end)
ESPTab.MouseButton1Click:Connect(function() showTab(ESPTab) end)
CustomScriptTab.MouseButton1Click:Connect(function() showTab(CustomScriptTab) end)
SettingsTab.MouseButton1Click:Connect(function() showTab(SettingsTab) end)

-- Инициализация
showTab(PlayersTab)

-- Добавляем в начало скрипта (после создания ScreenGui)
local CustomCursorEnabled = true
local cursorCircle = Instance.new("Frame")
local cursorPulse = Instance.new("Frame")

-- Функция создания кастомного курсора
local function createCustomCursor()
	cursorCircle.Name = "CursorCircle"
	cursorCircle.Parent = ScreenGui
	cursorCircle.BackgroundColor3 = Color3.new(0, 0, 0)
	cursorCircle.BackgroundTransparency = 0.5
	cursorCircle.BorderSizePixel = 0
	cursorCircle.Size = UDim2.new(0, 20, 0, 20)
	cursorCircle.ZIndex = 9999

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = cursorCircle

	cursorPulse.Name = "CursorPulse"
	cursorPulse.Parent = cursorCircle
	cursorPulse.AnchorPoint = Vector2.new(0.5, 0.5)
	cursorPulse.BackgroundColor3 = Color3.new(1, 0, 0)
	cursorPulse.BackgroundTransparency = 0.7
	cursorPulse.BorderSizePixel = 0
	cursorPulse.Position = UDim2.new(0.5, 0, 0.5, 0)
	cursorPulse.Size = UDim2.new(0, 10, 0, 10)
	cursorPulse.ZIndex = 10000

	local pulseCorner = Instance.new("UICorner")
	pulseCorner.CornerRadius = UDim.new(1, 0)
	pulseCorner.Parent = cursorPulse

	-- Анимация пульсации
	local pulseTween = game:GetService("TweenService"):Create(
		cursorPulse,
		TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 0.9}
	)
	pulseTween:Play()

	-- Скрываем системный курсор
	UserInputService.MouseIconEnabled = false

	-- Обновление позиции курсора (с поднятием на 60 пикселей)
	local connection
	connection = UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation()
			cursorCircle.Position = UDim2.new(0, mousePos.X - 10, 0, mousePos.Y - 70) -- Поднятие на 60px
		end
	end)

	return connection
end

-- Остальной код остается без изменений
local cursorConnection

local function toggleCustomCursor(enabled)
	CustomCursorEnabled = enabled
	if enabled then
		if not cursorConnection then
			cursorConnection = createCustomCursor()
		end
		cursorCircle.Visible = true
		UserInputService.MouseIconEnabled = false
	else
		if cursorConnection then
			cursorConnection:Disconnect()
			cursorConnection = nil
		end
		cursorCircle.Visible = false
		UserInputService.MouseIconEnabled = true
	end
end

-- Изначально создаем курсор
toggleCustomCursor(CustomCursorEnabled)

-- Добавляем переключатель в настройки
local cursorToggleBtn, cursorToggleIndicator = createToggleButton("Custom Cursor", 230, CustomCursorEnabled)
cursorToggleBtn.MouseButton1Click:Connect(function()
	CustomCursorEnabled = not CustomCursorEnabled
	cursorToggleIndicator.BackgroundColor3 = CustomCursorEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	toggleCustomCursor(CustomCursorEnabled)
end)

ScreenGui.Destroying:Connect(function()
	toggleCustomCursor(false)
end)
