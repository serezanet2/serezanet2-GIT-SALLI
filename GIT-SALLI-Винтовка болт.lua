-- Универсальный скрипт для винтовки "Болт" (Мёртвые рельсы)
-- Полная версия с разрушением блоков и мгновенным убийством

if _G.BoltRifleLoaded then
    _G.BoltRifleLoaded:Destroy()
    _G.BoltRifleLoaded = nil
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Настройки оружия
local settings = {
    WeaponName = "Болт (Убийца)",
    Damage = math.huge, -- Мгновенное убийство
    FireRate = 0.1,
    MaxDistance = 1000,
    MaxAmmo = 6,
    ReloadTime = 1.5,
    BulletColor = Color3.new(1, 0, 0),
    BulletTransparency = 0.5,
    BulletSize = 0.2,
    BulletDuration = 0.2,
    BulletSpeed = 2000,
    DestroyBlocks = true, -- Разрушение блоков
    BlockDestroyRadius = 3 -- Радиус разрушения блоков
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

-- Создаем GUI для отображения патронов
local ammoUI = {
    ScreenGui = Instance.new("ScreenGui"),
    AmmoText = Instance.new("TextLabel"),
    ReloadText = Instance.new("TextLabel")
}

local function createAmmoDisplay()
    ammoUI.ScreenGui.Name = "BoltRifleUI"
    ammoUI.ScreenGui.ResetOnSpawn = false
    ammoUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ammoUI.ScreenGui.Parent = game:GetService("CoreGui")
    ammoUI.ScreenGui.Enabled = false

    local frame = Instance.new("Frame")
    frame.Name = "AmmoDisplay"
    frame.Size = UDim2.new(0, 200, 0, 80)
    frame.Position = UDim2.new(0, 20, 1, -settings.AmmoDisplayOffset - 80)
    frame.AnchorPoint = Vector2.new(0, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = ammoUI.ScreenGui

    ammoUI.AmmoText.Name = "AmmoCount"
    ammoUI.AmmoText.Size = UDim2.new(1, 0, 0, 60)
    ammoUI.AmmoText.Position = UDim2.new(0, 0, 0, 0)
    ammoUI.AmmoText.BackgroundTransparency = 1
    ammoUI.AmmoText.TextColor3 = Color3.new(1, 1, 1)
    ammoUI.AmmoText.TextStrokeColor3 = Color3.new(0, 0, 0)
    ammoUI.AmmoText.TextStrokeTransparency = 0.5
    ammoUI.AmmoText.Font = Enum.Font.SciFi
    ammoUI.AmmoText.TextSize = 48
    ammoUI.AmmoText.TextXAlignment = Enum.TextXAlignment.Left
    ammoUI.AmmoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoUI.AmmoText.Parent = frame

    ammoUI.ReloadText.Name = "ReloadStatus"
    ammoUI.ReloadText.Size = UDim2.new(1, 0, 0, 20)
    ammoUI.ReloadText.Position = UDim2.new(0, 0, 0, 60)
    ammoUI.ReloadText.BackgroundTransparency = 1
    ammoUI.ReloadText.TextColor3 = Color3.new(1, 1, 1)
    ammoUI.ReloadText.TextStrokeTransparency = 0.5
    ammoUI.ReloadText.Font = Enum.Font.SciFi
    ammoUI.ReloadText.TextSize = 16
    ammoUI.ReloadText.TextXAlignment = Enum.TextXAlignment.Left
    ammoUI.ReloadText.Text = "[R] Перезарядка"
    ammoUI.ReloadText.Visible = false
    ammoUI.ReloadText.Parent = frame
end

createAmmoDisplay()

local function updateAmmoDisplay()
    ammoUI.AmmoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoUI.AmmoText.TextColor3 = weaponState.Ammo == 0 and Color3.new(1, 0.3, 0.3) or Color3.new(1, 1, 1)
end

local function reload()
    if weaponState.IsReloading or weaponState.Ammo == settings.MaxAmmo then return end
    
    weaponState.IsReloading = true
    ammoUI.ReloadText.Visible = true
    
    local startTime = tick()
    while tick() - startTime < settings.ReloadTime do
        ammoUI.ReloadText.Text = "[R] Перезарядка: " .. math.floor((tick() - startTime)/settings.ReloadTime * 100) .. "%"
        RunService.Heartbeat:Wait()
    end
    
    weaponState.Ammo = settings.MaxAmmo
    updateAmmoDisplay()
    weaponState.IsReloading = false
    ammoUI.ReloadText.Visible = false
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
    local bulletPart = Instance.new("Part")
    bulletPart.Size = Vector3.new(settings.BulletSize, settings.BulletSize, settings.BulletSize)
    bulletPart.CFrame = CFrame.new(startPos, startPos + direction)
    bulletPart.Anchored = false
    bulletPart.CanCollide = false
    bulletPart.Color = settings.BulletColor
    bulletPart.Transparency = settings.BulletTransparency
    bulletPart.Material = Enum.Material.Neon
    bulletPart.Shape = Enum.PartType.Ball
    bulletPart.Velocity = direction.Unit * settings.BulletSpeed
    bulletPart.Parent = workspace
    
    game.Debris:AddItem(bulletPart, settings.MaxDistance/settings.BulletSpeed)
    
    bulletPart.Touched:Connect(function(hit)
        if hit and hit.Parent then
            -- Уничтожение блоков
            destroyBlocks(hit.Position)
            
            -- Убийство игроков
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid") or 
                           (hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid"))
            
            if humanoid and humanoid ~= character:FindFirstChildOfClass("Humanoid") then
                humanoid:TakeDamage(settings.Damage)
                
                -- Эффект убийства
                local explosion = Instance.new("Explosion")
                explosion.Position = hit.Position
                explosion.BlastPressure = 0
                explosion.BlastRadius = 5
                explosion.Parent = workspace
            end
        end
        bulletPart:Destroy()
    end)
end

local function createWeaponModel()
    local tool = Instance.new("Tool")
    tool.Name = settings.WeaponName
    tool.RequiresHandle = true
    tool.CanBeDropped = false

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
        
        -- Эффект отдачи
        local originalPos = handle.Position
        handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.2)
        task.wait(0.05)
        handle.CFrame = CFrame.new(originalPos) * handle.CFrame.Rotation
        
        task.wait(settings.FireRate)
        weaponState.IsShooting = false
    end

    tool.Activated:Connect(shoot)

    tool.Equipped:Connect(function()
        weaponState.Equipped = true
        ammoUI.ScreenGui.Enabled = true
        tool.Grip = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end)

    tool.Unequipped:Connect(function()
        weaponState.Equipped = false
        ammoUI.ScreenGui.Enabled = false
    end)

    tool.Parent = localPlayer.Backpack
    
    return tool
end

-- Основная инициализация
_G.BoltRifleLoaded = ammoUI.ScreenGui

local weapon = createWeaponModel()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end)

local function autoReload()
    while true do
        if weaponState.Ammo <= 0 and not weaponState.IsReloading then
            reload()
        end
        task.wait(0.1)
    end
end

coroutine.wrap(autoReload)()

-- Уведомление
local notification = Instance.new("ScreenGui")
notification.Name = "BoltRifleNotification"
notification.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 50)
frame.Position = UDim2.new(0.5, -150, 1, -settings.AmmoDisplayOffset - 130)
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = notification

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, 0, 1, 0)
text.Text = "Винтовка 'Болт' активирована! (R - перезарядка)"
text.TextColor3 = Color3.new(1, 1, 1)
text.BackgroundTransparency = 1
text.Font = Enum.Font.SciFi
text.TextSize = 16
text.Parent = frame

frame:TweenPosition(UDim2.new(0.5, -150, 1, -settings.AmmoDisplayOffset - 160), "Out", "Quad", 0.5, true)
task.wait(3)
frame:TweenPosition(UDim2.new(0.5, -150, 1, -settings.AmmoDisplayOffset - 130), "Out", "Quad", 0.5, true)
task.wait(0.5)
notification:Destroy()
