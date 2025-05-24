-- Универсальный скрипт для винтовки "Болт" (Мёртвые рельсы)
-- Версия с корректным отключением при повторной активации

-- Проверка на повторное выполнение
if _G.BoltRifleSystem then
    -- Удаляем все созданные элементы
    if _G.BoltRifleSystem.ScreenGui then
        _G.BoltRifleSystem.ScreenGui:Destroy()
    end
    if _G.BoltRifleSystem.Tool then
        _G.BoltRifleSystem.Tool:Destroy()
    end
    if _G.BoltRifleSystem.Connections then
        for _, connection in pairs(_G.BoltRifleSystem.Connections) do
            connection:Disconnect()
        end
    end
    _G.BoltRifleSystem = nil
    return
end

-- Ожидание загрузки игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Настройки оружия
local settings = {
    WeaponName = "Болт (Убийца)",
    Damage = math.huge,
    FireRate = 0.1,
    MaxDistance = 1000,
    MaxAmmo = 6,
    ReloadTime = 1.5,
    BulletColor = Color3.new(1, 0, 0),
    BulletTransparency = 0.5,
    BulletSize = 0.2,
    BulletDuration = 0.2,
    BulletSpeed = 2000,
    DestroyBlocks = true,
    BlockDestroyRadius = 3
}

-- Состояние оружия
local weaponState = {
    Ammo = settings.MaxAmmo,
    IsReloading = false,
    IsShooting = false,
    Equipped = false
}

-- Локальные переменные
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local mouse = localPlayer:GetMouse()
local camera = workspace.CurrentCamera

-- Создание системы управления
_G.BoltRifleSystem = {
    ScreenGui = nil,
    Tool = nil,
    Connections = {}
}

-- Создание интерфейса
local function createAmmoDisplay()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoltRifleUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.Enabled = false
    _G.BoltRifleSystem.ScreenGui = screenGui

    local frame = Instance.new("Frame")
    frame.Name = "AmmoDisplay"
    frame.Size = UDim2.new(0, 200, 0, 80)
    frame.Position = UDim2.new(0, 20, 1, -100)
    frame.AnchorPoint = Vector2.new(0, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local ammoText = Instance.new("TextLabel")
    ammoText.Name = "AmmoCount"
    ammoText.Size = UDim2.new(1, 0, 0, 60)
    ammoText.Position = UDim2.new(0, 0, 0, 0)
    ammoText.BackgroundTransparency = 1
    ammoText.TextColor3 = Color3.new(1, 1, 1)
    ammoText.TextStrokeColor3 = Color3.new(0, 0, 0)
    ammoText.TextStrokeTransparency = 0.5
    ammoText.Font = Enum.Font.SciFi
    ammoText.TextSize = 48
    ammoText.TextXAlignment = Enum.TextXAlignment.Left
    ammoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoText.Parent = frame

    local reloadText = Instance.new("TextLabel")
    reloadText.Name = "ReloadStatus"
    reloadText.Size = UDim2.new(1, 0, 0, 20)
    reloadText.Position = UDim2.new(0, 0, 0, 60)
    reloadText.BackgroundTransparency = 1
    reloadText.TextColor3 = Color3.new(1, 1, 1)
    reloadText.TextStrokeTransparency = 0.5
    reloadText.Font = Enum.Font.SciFi
    reloadText.TextSize = 16
    reloadText.TextXAlignment = Enum.TextXAlignment.Left
    reloadText.Text = "[R] Перезарядка"
    reloadText.Visible = false
    reloadText.Parent = frame

    return {
        AmmoText = ammoText,
        ReloadText = reloadText
    }
end

local ammoDisplay = createAmmoDisplay()

local function updateAmmoDisplay()
    ammoDisplay.AmmoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoDisplay.AmmoText.TextColor3 = weaponState.Ammo == 0 and Color3.new(1, 0.3, 0.3) or Color3.new(1, 1, 1)
end

local function reload()
    if weaponState.IsReloading or weaponState.Ammo == settings.MaxAmmo then return end
    
    weaponState.IsReloading = true
    ammoDisplay.ReloadText.Visible = true
    
    local startTime = tick()
    while tick() - startTime < settings.ReloadTime and weaponState.IsReloading do
        ammoDisplay.ReloadText.Text = "[R] Перезарядка: " .. math.floor((tick() - startTime)/settings.ReloadTime * 100) .. "%"
        RunService.Heartbeat:Wait()
    end
    
    weaponState.Ammo = settings.MaxAmmo
    updateAmmoDisplay()
    weaponState.IsReloading = false
    ammoDisplay.ReloadText.Visible = false
end

local function destroyBlocks(position)
    if not settings.DestroyBlocks then return end
    
    for _, part in ipairs(workspace:GetPartsInRadius(position, settings.BlockDestroyRadius)) do
        if part:IsA("BasePart") and part.Parent ~= character then
            part:Destroy()
        end
    end
end

local function createBullet(startPos, direction)
    local bullet = Instance.new("Part")
    bullet.Size = Vector3.new(settings.BulletSize, settings.BulletSize, settings.BulletSize)
    bullet.CFrame = CFrame.new(startPos, startPos + direction)
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.Color = settings.BulletColor
    bullet.Transparency = settings.BulletTransparency
    bullet.Material = Enum.Material.Neon
    bullet.Shape = Enum.PartType.Ball
    bullet.Velocity = direction.Unit * settings.BulletSpeed
    bullet.Parent = workspace
    
    game.Debris:AddItem(bullet, settings.MaxDistance/settings.BulletSpeed)
    
    bullet.Touched:Connect(function(hit)
        if not hit or not hit.Parent then return end
        
        destroyBlocks(hit.Position)
        
        local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid") or 
                       (hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid"))
        
        if humanoid and humanoid ~= character:FindFirstChildOfClass("Humanoid") then
            humanoid:TakeDamage(settings.Damage)
            
            local explosion = Instance.new("Explosion")
            explosion.Position = hit.Position
            explosion.BlastPressure = 0
            explosion.BlastRadius = 5
            explosion.Parent = workspace
        end
        
        bullet:Destroy()
    end)
end

-- Создание оружия
local function createWeapon()
    local tool = Instance.new("Tool")
    tool.Name = settings.WeaponName
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    _G.BoltRifleSystem.Tool = tool

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 3)
    handle.Transparency = 0
    handle.CanCollide = false
    handle.Parent = tool

    local gunMesh = Instance.new("SpecialMesh")
    gunMesh.MeshId = "rbxassetid://430285422"
    gunMesh.TextureId = "rbxassetid://430285425"
    gunMesh.Scale = Vector3.new(0.8, 0.8, 0.8)
    gunMesh.Parent = handle

    local shootSound = Instance.new("Sound")
    shootSound.SoundId = "rbxassetid://132575072"
    shootSound.Volume = 1
    shootSound.Parent = handle

    local reloadSound = Instance.new("Sound")
    reloadSound.SoundId = "rbxassetid://269159528"
    reloadSound.Volume = 0.5
    reloadSound.Parent = handle

    -- Функция стрельбы
    local function shoot()
        if weaponState.Ammo <= 0 then
            reload()
            return
        end
        
        if weaponState.IsShooting or weaponState.IsReloading or not weaponState.Equipped then return end
        weaponState.IsShooting = true
        
        local muzzlePos = handle.Position + handle.CFrame.LookVector * 3
        local direction = (mouse.Hit.Position - muzzlePos).Unit * settings.MaxDistance
        
        createBullet(muzzlePos, direction)
        weaponState.Ammo = weaponState.Ammo - 1
        updateAmmoDisplay()
        shootSound:Play()
        
        local originalPos = handle.Position
        handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.2)
        task.wait(0.05)
        handle.CFrame = CFrame.new(originalPos) * handle.CFrame.Rotation
        
        task.wait(settings.FireRate)
        weaponState.IsShooting = false
    end

    -- Подключение событий
    table.insert(_G.BoltRifleSystem.Connections, tool.Activated:Connect(shoot))
    
    table.insert(_G.BoltRifleSystem.Connections, tool.Equipped:Connect(function()
        weaponState.Equipped = true
        _G.BoltRifleSystem.ScreenGui.Enabled = true
        tool.Grip = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end))
    
    table.insert(_G.BoltRifleSystem.Connections, tool.Unequipped:Connect(function()
        weaponState.Equipped = false
        _G.BoltRifleSystem.ScreenGui.Enabled = false
    end))

    tool.Parent = localPlayer.Backpack
end

-- Перезарядка по R
table.insert(_G.BoltRifleSystem.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end))

-- Автоперезарядка
local function autoReload()
    while _G.BoltRifleSystem do
        if weaponState.Ammo <= 0 and not weaponState.IsReloading then
            reload()
        end
        task.wait(0.1)
    end
end

coroutine.wrap(autoReload)()

-- Создание оружия
createWeapon()

-- Уведомление
local notification = Instance.new("ScreenGui")
notification.Name = "BoltRifleNotification"
notification.Parent = game:GetService("CoreGui")

local notifyFrame = Instance.new("Frame")
notifyFrame.Size = UDim2.new(0, 300, 0, 50)
notifyFrame.Position = UDim2.new(0.5, -150, 1, -150)
notifyFrame.AnchorPoint = Vector2.new(0.5, 1)
notifyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notifyFrame.BackgroundTransparency = 0.5
notifyFrame.BorderSizePixel = 0
notifyFrame.Parent = notification

local notifyText = Instance.new("TextLabel")
notifyText.Size = UDim2.new(1, 0, 1, 0)
notifyText.Text = "Винтовка 'Болт' активирована! (R - перезарядка)"
notifyText.TextColor3 = Color3.new(1, 1, 1)
notifyText.BackgroundTransparency = 1
notifyText.Font = Enum.Font.SciFi
notifyText.TextSize = 16
notifyText.Parent = notifyFrame

notifyFrame:TweenPosition(UDim2.new(0.5, -150, 1, -180), "Out", "Quad", 0.5, true)
task.wait(3)
notifyFrame:TweenPosition(UDim2.new(0.5, -150, 1, -150), "Out", "Quad", 0.5, true)
task.wait(0.5)
notification:Destroy()
