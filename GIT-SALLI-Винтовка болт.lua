-- Универсальный скрипт для винтовки "Болт" (Мёртвые рельсы)
-- Работает в любом плейсе через эксплойт

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Настройки оружия
local settings = {
    WeaponName = "Болт (Мёртвые рельсы)",
    Damage = 100,
    FireRate = 0.1,
    MaxDistance = 1000,
    MaxAmmo = 6,
    ReloadTime = 1.5,
    BulletColor = Color3.new(1, 1, 1),
    BulletTransparency = 0.7,
    BulletSize = 0.1,
    AmmoDisplayOffset = 50,
    BulletSpeed = 500
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

-- Создаем GUI для отображения патронов
local function createAmmoDisplay()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoltRifleUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    _G.BoltRifleUI = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 80)
    frame.Position = UDim2.new(0, 20, 1, -settings.AmmoDisplayOffset - 80)
    frame.AnchorPoint = Vector2.new(0, 1)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local ammoText = Instance.new("TextLabel")
    ammoText.Size = UDim2.new(1, 0, 0, 60)
    ammoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoText.TextColor3 = Color3.new(1, 1, 1)
    ammoText.TextStrokeTransparency = 0.5
    ammoText.Font = Enum.Font.SciFi
    ammoText.TextSize = 48
    ammoText.Parent = frame

    local reloadText = Instance.new("TextLabel")
    reloadText.Size = UDim2.new(1, 0, 0, 20)
    reloadText.Position = UDim2.new(0, 0, 0, 60)
    reloadText.Text = "[R] Перезарядка"
    reloadText.Visible = false
    reloadText.Parent = frame

    return {
        ScreenGui = screenGui,
        AmmoText = ammoText,
        ReloadText = reloadText
    }
end

-- Инициализация GUI
local ammoUI = createAmmoDisplay()

-- Функция обновления GUI
local function updateAmmoDisplay()
    ammoUI.AmmoText.Text = weaponState.Ammo .. "|" .. settings.MaxAmmo
    ammoUI.AmmoText.TextColor3 = weaponState.Ammo == 0 and not weaponState.IsReloading 
        and Color3.new(1, 0.3, 0.3) or Color3.new(1, 1, 1)
end

-- Функция перезарядки
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

-- Функция создания эффекта пули
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
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid") or 
                           (hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid"))
            
            if humanoid and humanoid ~= character:FindFirstChildOfClass("Humanoid") and humanoid.Health > 0 then
                humanoid:TakeDamage(settings.Damage)
                
                if humanoid.Health <= 0 then
                    local explosion = Instance.new("Explosion")
                    explosion.Position = hit.Position
                    explosion.BlastPressure = 0
                    explosion.BlastRadius = 5
                    explosion.Parent = workspace
                end
            end
        end
        bulletPart:Destroy()
    end)
end

-- Создаем модель винтовки
local function createWeaponModel()
    local tool = Instance.new("Tool")
    tool.Name = settings.WeaponName
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    _G.BoltRifleTool = tool

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 3)
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
        if weaponState.Ammo <= 0 then reload() return end
        if weaponState.IsShooting or weaponState.IsReloading or not weaponState.Equipped then return end
        
        weaponState.IsShooting = true
        local muzzlePos = handle.Position + handle.CFrame.LookVector * 3
        createBullet(muzzlePos, (mouse.Hit.Position - muzzlePos).Unit * settings.MaxDistance)
        
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
        tool.Grip = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end)
    tool.Unequipped:Connect(function() weaponState.Equipped = false end)

    tool.Parent = localPlayer.Backpack
    return tool
end

-- Основная инициализация
if not _G.BoltRifleLoaded then
    _G.BoltRifleLoaded = true
    
    if not localPlayer.Character then
        localPlayer.CharacterAdded:Wait()
    end
    character = localPlayer.Character

    createWeaponModel()

    -- Обработка перезарядки
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
            reload()
        end
    end)

    -- Авто-перезарядка
    coroutine.wrap(function()
        while _G.BoltRifleLoaded do
            if weaponState.Ammo <= 0 and not weaponState.IsReloading then
                reload()
            end
            task.wait(0.1)
        end
    end)()
    
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
end
-- Функция Bolt Rifle
local boltRifleEnabled = false
local boltRifleConnection
local function toggleBoltRifle()
    boltRifleEnabled = not boltRifleEnabled
    
    if boltRifleEnabled then
        buttonSound:Play()
        boltRifleIndicator.BackgroundColor3 = Color3.new(0, 0.5, 0)
        
        -- Запускаем скрипт винтовки "Болт"
        coroutine.wrap(function()
            -- Универсальный скрипт для винтовки "Болт"
            if not game:IsLoaded() then game.Loaded:Wait() end

            local Players = game:GetService("Players")
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            local Debris = game:GetService("Debris")

            -- Настройки оружия
            local settings = {
                WeaponName = "Болт (Мёртвые рельсы)",
                Damage = 100,
                FireRate = 0.1,
                MaxDistance = 1000,
                MaxAmmo = 6,
                ReloadTime = 1.5,
                BulletColor = Color3.new(1, 1, 1),
                BulletTransparency = 0.7,
                BulletSize = 0.1,
                AmmoDisplayOffset = 50,
                BulletSpeed = 500
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

            -- Создаем GUI для отображения патронов
            local ammoUI = {}
            local function createAmmoDisplay()
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "BoltRifleUI"
                screenGui.ResetOnSpawn = false
                screenGui.Parent = player.PlayerGui

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 200, 0, 80)
                frame.Position = UDim2.new(0, 20, 1, -settings.AmmoDisplayOffset - 80)
                frame.AnchorPoint = Vector2.new(0, 1)
                frame.BackgroundTransparency = 1
                frame.Parent = screenGui

                local ammoText = Instance.new("TextLabel")
                ammoText.Size = UDim2.new(1, 0, 0, 60)
                ammoText.Text = weaponState.Ammo.."|"..settings.MaxAmmo
                ammoText.TextColor3 = Color3.new(1, 1, 1)
                ammoText.Font = Enum.Font.SciFi
                ammoText.TextSize = 24
                ammoText.Parent = frame

                local reloadText = Instance.new("TextLabel")
                reloadText.Size = UDim2.new(1, 0, 0, 20)
                reloadText.Position = UDim2.new(0, 0, 0, 60)
                reloadText.Text = "[R] Перезарядка"
                reloadText.Visible = false
                reloadText.Parent = frame

                ammoUI = {
                    ScreenGui = screenGui,
                    AmmoText = ammoText,
                    ReloadText = reloadText
                }
            end

            -- Функция обновления GUI
            local function updateAmmoDisplay()
                ammoUI.AmmoText.Text = weaponState.Ammo.."|"..settings.MaxAmmo
                ammoUI.AmmoText.TextColor3 = weaponState.Ammo == 0 and Color3.new(1, 0.3, 0.3) or Color3.new(1, 1, 1)
            end

            -- Функция перезарядки
            local function reload()
                if weaponState.IsReloading or weaponState.Ammo == settings.MaxAmmo then return end
                
                weaponState.IsReloading = true
                ammoUI.ReloadText.Visible = true
                
                local startTime = tick()
                while tick() - startTime < settings.ReloadTime do
                    ammoUI.ReloadText.Text = "[R] Перезарядка: "..math.floor((tick()-startTime)/settings.ReloadTime*100).."%"
                    RunService.Heartbeat:Wait()
                end
                
                weaponState.Ammo = settings.MaxAmmo
                updateAmmoDisplay()
                weaponState.IsReloading = false
                ammoUI.ReloadText.Visible = false
            end

            -- Функция создания пули
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
                
                Debris:AddItem(bullet, settings.MaxDistance/settings.BulletSpeed)
                
                bullet.Touched:Connect(function(hit)
                    if hit and hit.Parent then
                        local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid") or 
                                       (hit.Parent.Parent and hit.Parent.Parent:FindFirstChildOfClass("Humanoid"))
                        
                        if humanoid and humanoid ~= character:FindFirstChildOfClass("Humanoid") and humanoid.Health > 0 then
                            humanoid:TakeDamage(settings.Damage)
                        end
                    end
                    bullet:Destroy()
                end)
            end

            -- Создаем модель винтовки
            local function createWeaponModel()
                local tool = Instance.new("Tool")
                tool.Name = settings.WeaponName
                tool.RequiresHandle = true
                tool.CanBeDropped = false

                local handle = Instance.new("Part")
                handle.Name = "Handle"
                handle.Size = Vector3.new(1, 1, 3)
                handle.CanCollide = false
                handle.Parent = tool

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshId = "rbxassetid://430285422"
                mesh.TextureId = "rbxassetid://430285425"
                mesh.Scale = Vector3.new(0.8, 0.8, 0.8)
                mesh.Parent = handle

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
                    if weaponState.Ammo <= 0 then reload() return end
                    if weaponState.IsShooting or weaponState.IsReloading or not weaponState.Equipped then return end
                    
                    weaponState.IsShooting = true
                    local muzzlePos = handle.Position + handle.CFrame.LookVector * 3
                    createBullet(muzzlePos, (mouse.Hit.Position - muzzlePos).Unit * settings.MaxDistance)
                    
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
                    tool.Grip = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                end)
                tool.Unequipped:Connect(function() weaponState.Equipped = false end)

                tool.Parent = localPlayer.Backpack
                return tool
            end

            -- Инициализация
            createAmmoDisplay()
            local weapon = createWeaponModel()

            -- Обработка перезарядки
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
                    reload()
                end
            end)

            -- Авто-перезарядка
            while boltRifleEnabled do
                if weaponState.Ammo <= 0 and not weaponState.IsReloading then
                    reload()
                end
                task.wait(0.1)
            end

            -- Очистка при отключении
            if ammoUI.ScreenGui then ammoUI.ScreenGui:Destroy() end
            if weapon then weapon:Destroy() end
        end)()
    else
        buttonSound:Play()
        boltRifleIndicator.BackgroundColor3 = Color3.new(0.5, 0, 0)
    end
end

boltRifleButton.MouseButton1Click:Connect(toggleBoltRifle)
