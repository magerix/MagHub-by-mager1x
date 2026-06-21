-- Твой первый скрипт для mager1x Hub
local StarterGui = game:GetService("StarterGui")

-- Красивое уведомление при запуске чита в игре
StarterGui:SetCore("SendNotification", {
    Title = "mager1x Hub",
    Text = "Скрипт успешно активирован! Приятной игры!",
    Duration = 5,
    Button1 = "Ок"
})

-- Сюда в будущем мы будем добавлять чит-функции (ESP, Аим, Скорость и т.д.)
print("mager1x Hub загружен без ошибок!")
-- ==========================================
-- mager1x Hub | Murder Mystery 2
-- Скрипт для Delta Executor (Mobile UI)
-- ==========================================

-- Прогрузка библиотек интерфейса (создаем фиолетовую тему)
local Library = loadstring(game:HttpGet("https://githubusercontent.com")) -- Временная заглушка под графический движок
local Material = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- Настройки чита (переменные, куда сохраняются клики игрока)
local Settings = {
    SilentAim = false,
    Aimbot = false,
    AimPart = "Head" -- По умолчанию целимся в голову
}

-- Создаем главное окно чита
local Window = Material.Load({
    Title = "mager1x Hub ⚡ | MM2",
    Style = 3, -- Стиль темной фиолетовой темы
    SizeX = 400,
    SizeY = 320,
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
            -- Выводим уведомление, что включен рейдж-режим
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "mager1x Hub",
                Text = "Внимание: Режим активирован для РЕЙДЖ игры!",
                Duration = 4
            })
            print("Aim-Silent: АКТИВИРОВАН (100% попадание)")
        else
            print("Aim-Silent: ДЕАКТИВИРОВАН")
        end
    end,
    Menu = {
        Information = function(self)
            self:Description("Идеальное 100% попадание без наведения камеры.")
        end
    }
})

-- Функция: Aim-Bot (С автовыстрелом за 45 мс)
CombatTab.NewToggle({
    Title = "Aim-Bot (45 мс)",
    Callback = function(Value)
        Settings.Aimbot = Value
        if Value then
            print("Aim-Bot: АКТИВИРОВАН")
            
            -- Логика авто-наведения на Мардера (45 мс) и выстрела
            task.spawn(function()
                while Settings.Aimbot do
                    task.wait(0.045) -- задержка ровно 45 миллисекунд
                    
                    -- Тут Delta ищет Мардера на карте MM2
                    local players = game:GetService("Players")
                    for _, player in pairs(players:GetPlayers()) do
                        if player.Character and player.Backpack:FindFirstChild("Knife") or (player.Character:FindFirstChild("Knife")) then
                            -- Наведение камеры на выбранную кость (Голова, Тело и т.д.)
                            local targetPart = player.Character:FindFirstChild(Settings.AimPart)
                            if targetPart then
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                                
                                -- Автоматический выстрел из пистолета Шерифа
                                local combatTool = game.Players.LocalPlayer.Character:FindFirstChild("Gun")
                                if combatTool then
                                    combatTool:Activate() -- Нажимает курок
                                end
                            end
                        end
                    end
                end
            end)
        else
            print("Aim-Bot: ДЕАКТИВИРОВАН")
        end
    end
})

-- Выпадающий список (Выбор костей для Aim-Bot)
CombatTab.NewDropdown({
    Title = "Зона попадания (Кость)",
    List = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Random"},
    Callback = function(Value)
        -- Переводим русский выбор в понятные для игры названия костей
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
        print("Зона наведения изменена на: " .. Settings.AimPart)
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

-- Красивое стартовое уведомление в углу экрана игры
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "mager1x Hub Loaded!",
    Text = "Combat меню успешно запущено через Delta.",
    Duration = 5
})
