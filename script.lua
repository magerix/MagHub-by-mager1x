-- =====================================================================
--               mager1x Hub | СВЕЖИЙ РАБОЧИЙ ШАБЛОН ⚡
-- =====================================================================

-- 1. ПОДКЛЮЧАЕМ НОВЫЙ ЗАЩИЩЕННЫЙ ДВИЖЕК ИНТЕРФЕЙСА (Orion Lib)
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

-- 2. ТАБЛИЦА НАСТРОЕК СИСТЕМЫ
local Config = {
    Aimbot = false,
    ESP = false
}

-- 3. СОЗДАЕМ ГЛАВНОЕ ОКНО ЧИТА (Черно-фиолетовая тема встроена по умолчанию)
local Window = OrionLib:MakeWindow({
    Name = "mager1x Hub ⚡ | MM2",
    HidePremium = true,
    SaveConfig = false,
    IntroText = "mager1x Hub Loading..." -- Красивый текст при запуске
})

-- 4. СОЗДАЕМ РАЗДЕЛЫ (Вкладки меню)
local CombatTab = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483345998" })
local VisualTab = Window:MakeTab({ Name = "Visual", Icon = "rbxassetid://4483345998" })

-- =====================================================================
-- КНОПКА ДЛЯ РАЗДЕЛА [COMBAT]
-- =====================================================================
CombatTab:AddToggle({
    Name = "Aim-Bot (Наведение)",
    Default = false,
    Callback = function(Value)
        Config.Aimbot = Value
        
        if Value then
            -- Этот код сработает, когда игрок ВКЛЮЧИТ кнопку
            OrionLib:MakeNotification({
                Name = "mager1x Hub",
                Content = "Аимбот успешно активирован!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            
            task.spawn(function()
                while Config.Aimbot do
                    task.wait(0.1)
                    -- Сюда позже добавим проверку стен и наводку
                end
            end)
        else
            print("Аимбот выключен")
        end
    end
})

-- =====================================================================
-- КНОПКА ДЛЯ РАЗДЕЛА [VISUAL]
-- =====================================================================
VisualTab:AddToggle({
    Name = "Включить ESP (ВХ)",
    Default = false,
    Callback = function(Value)
        Config.ESP = Value
        if Value then
            print("ВХ включено")
        else
            print("ВХ выключено")
        end
    end
})

-- 5. ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА (Обязательная команда для запуска)
OrionLib:Init()
