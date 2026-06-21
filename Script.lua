-- ==========================================
-- mager1x Hub | Murder Mystery 2
-- Фикс загрузки интерфейса для Delta Executor
-- ==========================================

-- Подключаем стабильную библиотеку фиолетового интерфейса
local Material = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- Настройки чита (сюда сохраняются клики игрока)
local Settings = {
    SilentAim = false,
    Aimbot = false,
    AimPart = "Head"
}

-- Создаем главное окно чита
local Window = Material.Load({
    Title = "mager1x Hub ⚡ | MM2",
    Style = 3, -- Темно-фиолетовая тема
    SizeX = 350,
    SizeY = 300,
    Theme = "Purple"
})

-- ==========================================
-- ВКЛАДКА 1: COMBAT
-- ==========================================
local CombatTab = Window.NewTab({
    Title = "Combat"
})

-- Функция: Aim-Silent (Рейдж)
CombatTab.NewToggle({
    Title = "Aim-Silent ❌ (Рейдж режим)",
    Callback = function(Value)
        Settings.SilentAim = Value
        if Value then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "mager1x Hub",
                Text = "Внимание: режим для рейдж игры!",
                Duration = 4
            })
        end
    end
})

-- Функция: Aim-Bot (С автовыстрелом за 45 мс)
CombatTab.NewToggle({
    Title = "Aim-Bot (45 мс)",
    Callback = function(Value)
        Settings.Aimbot = Value
        if Value then
            task.spawn(function()
                while Settings.Aimbot do
                    task.wait(0.045) -- задержка 45 миллисекунд
                    
                    local players = game:GetService("Players")
                    for _, player in pairs(players:GetPlayers()) do
                        -- Ищем игрока с ножом (Мардера)
                        if player.Character and (player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")) then
                            local targetPart = player.Character:FindFirstChild(Settings.AimPart)
                            if targetPart then
                                -- Наводим камеру на выбранную часть тела
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                                
                                -- Авто-выстрел, если в руках пистолет Шерифа
                                local gun = game.Players.LocalPlayer.Character:FindFirstChild("Gun")
                                if gun then
                                    gun:Activate()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Выбираем куда стрелять
CombatTab.NewDropdown({
    Title = "Зона попадания (Кость)",
    List = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Random"},
    Callback = function(Value)
        if Value == "Head" then Settings.AimPart = "Head"
        elseif Value == "Torso" then Settings.AimPart = "HumanoidRootPart"
        elseif Value == "Left Arm" then Settings.AimPart = "LeftArm"
        elseif Value == "Right Arm" then Settings.AimPart = "RightArm"
        elseif Value == "Left Leg" then Settings.AimPart = "LeftLeg"
        elseif Value == "Right Leg" then Settings.AimPart = "RightLeg"
        elseif Value == "Random" then
            local parts = {"Head", "HumanoidRootPart", "LeftArm", "RightArm"}
            Settings.AimPart = parts[math.random(1, #parts)]
        end
    end
})

-- ==========================================
-- ВКЛАДКА 2: VISUAL (В разработке)
-- ==========================================
local VisualTab = Window.NewTab({
    Title = "Visual"
})

VisualTab.NewLabel({
    Text = "Данный раздел пока в разработке..."
})

-- ==========================================
-- ВКЛАДКА 3: SETTINGS (В разработке)
-- ==========================================
local SettingsTab = Window.NewTab({
    Title = "Settings"
})

SettingsTab.NewLabel({
    Text = "Данный раздел пока в разработке..."
})

-- Уведомление в игре о том, что всё загрузилось успешно
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "mager1x Hub Loaded!",
    Text = "Успешный запуск меню через Delta.",
    Duration = 5
})
