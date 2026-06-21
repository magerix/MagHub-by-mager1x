-- =====================================================================
--                        mager1x Hub | MM2 ⚡
-- =====================================================================
-- АВТОНОМНЫЙ СКРИПТ v1.4.2 С ПОЛНЫМ НАБОРОМ ФУНКЦИЙ И ПОДДЕРЖКОЙ ЯЗЫКОВ

-- Загрузка стабильной библиотеки интерфейса Vape UI
local Library = loadstring(game:HttpGet("https://github.com/magerix/MagHub-by-mager1x"))()

-- Глобальная конфигурация (Настройки чита)
local Config = {
    Language = "RU",     -- Язык по умолчанию
    Theme = "Purple",    -- Тема по умолчанию
    Aimbot = false,
    SilentAim = false,
    KnifeAimbot = false,
    AimPart = "Head",
    ESP = false,
    ESPColor = Color3.fromRGB(123, 44, 191)
}

-- База данных текстов для переключения языков (RU / EN)
local TextData = {
    RU = {
        Title = "mager1x Hub ⚡ | MM2",
        Combat = "Combat",
        Visual = "Visual",
        Settings = "Settings",
        Aimbot = "Aim-Bot (45 мс)",
        SilentAim = "Silent Aim ❌ (Рейдж режим)",
        KnifeAim = "Knife Kill-Aura (Для Убийцы)",
        Bone = "Зона попадания (Кость)",
        ESP = "Включить ESP (ВХ)",
        Color = "Цвет подсветки ESP",
        LangToggle = "Язык меню / Language",
        ThemeToggle = "Тема интерфейса",
        NotifyTitle = "mager1x Hub v1.4.2",
        NotifyText = "Скрипт успешно запущен!",
        RageWarn = "Внимание: режим для РЕЙДЖ игры! (Высокий шанс бана)",
        UpdateTitle = "📢 ОБНОВЛЕНИЕ v1.4.2",
        UpdateDesc = "• Добавлен обход стен для Аима\n• Добавлена Аура для Убийцы\n• Добавлен выбор цвета ESP\n• Полная поддержка RU/EN языков"
    },
    EN = {
        Title = "mager1x Hub ⚡ | MM2",
        Combat = "Combat",
        Visual = "Visual",
        Settings = "Settings",
        Aimbot = "Aim-Bot (45 ms)",
        SilentAim = "Silent Aim ❌ (Rage Mode)",
        KnifeAim = "Knife Kill-Aura (For Murderer)",
        Bone = "Target Bone",
        ESP = "Enable ESP (Wallhack)",
        Color = "ESP Highlight Color",
        LangToggle = "Language / Язык меню",
        ThemeToggle = "UI Theme",
        NotifyTitle = "mager1x Hub v1.4.2",
        NotifyText = "Script executed successfully!",
        RageWarn = "Warning: Rage Mode activated! (High ban risk)",
        UpdateTitle = "📢 UPDATE v1.4.2",
        UpdateDesc = "• Added Wall-Check for Aimbot\n• Added Knife Aura for Murderer\n• Added ESP Color picker\n• Full RU/EN Language support"
    }
}

-- Скрытая легитная проверка на стены (Raycast)
local function isBehindWall(target)
    if not game.Players.LocalPlayer.Character or not target.Character then return true end
    local localOrigin = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetPart = target.Character:FindFirstChild(Config.AimPart)
    
    if localOrigin and targetPart then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterResultInstances = {game.Players.LocalPlayer.Character, target.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local direction = (targetPart.Position - localOrigin.Position)
        local raycastResult = workspace:Raycast(localOrigin.Position, direction, raycastParams)
        
        if raycastResult then
            return true -- За стенкой
        end
    end
    return false -- Виден в упор
end

-- Создаем главное окно чита (Темно-фиолетовая тема по умолчанию)
local Window = Library.Load({
    Title = TextData[Config.Language].Title,
    Style = 3,
    SizeX = 390,
    SizeY = 350,
    Theme = Config.Theme
})

-- Создаем линейные вкладки сверху
local CombatTab = Window.NewTab({ Title = TextData[Config.Language].Combat })
local VisualTab = Window.NewTab({ Title = TextData[Config.Language].Visual })
local SettingsTab = Window.NewTab({ Title = TextData[Config.Language].Settings })

-- =====================================================================
-- ВЛАДКА 1: COMBAT (БОЙ)
-- =====================================================================

-- 1. Aim-Bot (45 мс) + Проверка на стены + Автовыстрел
CombatTab.NewToggle({
    Title = TextData[Config.Language].Aimbot,
    Callback = function(Value)
        Config.Aimbot = Value
        if Value then
            task.spawn(function()
                while Config.Aimbot do
                    task.wait(0.045) -- Задержка ровно 45 мс
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            -- Проверяем, Мардер ли это (держит нож или он в рюкзаке)
                            if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                                -- Секретная проверка: аимбот НЕ работает, если Мардер спрятался за стену
                                if not isBehindWall(player) then
                                    local targetPart = player.Character:FindFirstChild(Config.AimPart)
                                    if targetPart then
                                        -- Моментальный разворот камеры на цель
                                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                                        
                                        -- Автовыстрел, если в руках Шерифский Пистолет
                                        local gun = game.Players.LocalPlayer.Character:FindFirstChild("Gun")
                                        if gun then gun:Activate() end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- 2. Silent Aim (Скрытый, без наводки камеры + Проверка на стены)
CombatTab.NewToggle({
    Title = TextData[Config.Language].SilentAim,
    Callback = function(Value)
        Config.SilentAim = Value
        if Value then
            -- Вывод текста о рейдж-игре
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "mager1x Hub",
                Text = TextData[Config.Language].RageWarn,
                Duration = 5
            })
            
            task.spawn(function()
                local Hook
                Hook = hookmetamethod(game, "__index", function(Self, Key)
                    if not Config.SilentAim then return Hook(Self, Key) end
                    if tostring(Self) == "Gun" and Key == "Hit" then
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Knife") then
                                -- Скрытый аимбот НЕ сработает, если цель за стеной
                                if not isBehindWall(p) then
                                    local t = p.Character:FindFirstChild(Config.AimPart)
                                    if t then return t.CFrame end
                                end
                            end
                        end
                    end
                    return Hook(Self, Key)
                end)
            end)
        end
    end
})

-- 3. Knife Kill-Aura (Для убийцы + Бьет только тех, кто НЕ за стенкой)
CombatTab.NewToggle({
    Title = TextData[Config.Language].KnifeAim,
    Callback = function(Value)
        Config.KnifeAimbot = Value
        if Value then
            task.spawn(function()
                while Config.KnifeAimbot do
                    task.wait(0.1)
                    local knife = game.Players.LocalPlayer.Character:FindFirstChild("Knife")
                    if knife then
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player ~= game.Players.LocalPlayer and player.Character then
                                -- Секретный триггер: не бьет и не кидает нож, если игрок за препятствием
                                if not isBehindWall(player) then
                                    local targetPart = player.Character:FindFirstChild("HumanoidRootPart")
                                    if targetPart then
                                        -- Проверка дистанции для удара/броска (в радиусе 25 studs)
                                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                                        if distance < 25 then
                                            knife:Activate() -- Автоматический взмах/бросок ножа
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- 4. Выбор костей наведения для Аимбота
CombatTab.NewDropdown({
    Title = TextData[Config.Language].Bone,
    List = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Random"},
    Callback = function(Value)
        if Value == "Torso" then 
            Config.AimPart = "HumanoidRootPart" 
        elseif Value == "Random" then
            local parts = {"Head", "HumanoidRootPart", "LeftArm", "RightArm"}
            Config.AimPart = parts[math.random(1, #parts)]
        else 
            Config.AimPart = Value 
        end
    end
})

-- =====================================================================
-- ВЛАДКА 2: VISUAL (ВИЗУАЛЫ)
-- =====================================================================

-- 1. Включение обычного ESP (ВХ)
VisualTab.NewToggle({
    Title = TextData[Config.Language].ESP,
    Callback = function(Value)
        Config.ESP = Value
        for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer and p.Character thenif Value then-- Создаем красивую неоновую подсветку силуэтаlocal highlight = Instance.new("Highlight")highlight.Name = "MagHub_ESP"highlight.FillColor = Config.ESPColorhighlight.OutlineColor = Color3.fromRGB(255, 255, 255)highlight.Parent = p.Characterelseif p.Character:FindFirstChild("MagHub_ESP") thenp.Character.MagHub_ESP:Destroy()endendendendend})-- 2. Выбор цвета для ESP на летуVisualTab.NewDropdown({Title = TextData[Config.Language].Color,List = {"Purple", "Red", "Green", "Blue", "Yellow"},Callback = function(Value)if Value == "Purple" then Config.ESPColor = Color3.fromRGB(123, 44, 191)elseif Value == "Red" then Config.ESPColor = Color3.fromRGB(255, 71, 87)elseif Value == "Green" then Config.ESPColor = Color3.fromRGB(46, 213, 115)elseif Value == "Blue" then Config.ESPColor = Color3.fromRGB(84, 160, 255)elseif Value == "Yellow" then Config.ESPColor = Color3.fromRGB(255, 242, 0)end-- Сразу перекрашиваем уже включенные ESP в игреif Config.ESP thenfor _, p in pairs(game.Players:GetPlayers()) doif p.Character and p.Character:FindFirstChild("MagHub_ESP") thenp.Character.MagHub_ESP.FillColor = Config.ESPColorendendendend})-- =====================================================================-- ВЛАДКА 3: SETTINGS & LOGS (НАСТРОЙКИ И ОБНОВЛЕНИЯ)-- =====================================================================-- Текст со списком обновлений и версией (Встроен прямо в интерфейс)SettingsTab.NewLabel({ Text = TextData[Config.Language].UpdateTitle })SettingsTab.NewLabel({ Text = TextData[Config.Language].UpdateDesc })-- 1. Переключатель языков интерфейса (RU / EN)SettingsTab.NewDropdown({Title = TextData[Config.Language].LangToggle,List = {"RU", "EN"},Callback = function(Value)Config.Language = Valuegame:GetService("StarterGui"):SetCore("SendNotification", {Title = "mager1x Hub",Text = (Value == "RU" and "Язык будет изменен при следующем запуске!" or "Language will change on next execution!"),Duration = 4})end})-- 2. Смена кастомных тем менюSettingsTab.NewDropdown({Title = TextData[Config.Language].ThemeToggle,List = {"Purple", "Dark", "Aqua", "Red"},Callback = function(Value)Config.Theme = Valueprint("Выбрана тема: " .. Value)end})-- Приветственное стартовое уведомление в углу экрана игрыgame:GetService("StarterGui"):SetCore("SendNotification", {Title = TextData[Config.Language].NotifyTitle,Text = TextData[Config.Language].NotifyText,Duration = 5})
