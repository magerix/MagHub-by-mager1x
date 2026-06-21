-- =====================================================================
--                        mager1x Hub | MM2 ⚡
-- =====================================================================

local Material = loadstring(game:HttpGet("https://githubusercontent.com"))()

local Config = {
    Language = "RU", Theme = "Purple",
    Aimbot = false, SilentAim = false, KnifeAimbot = false, AimPart = "Head",
    ESP = false, ESPColor = Color3.fromRGB(123, 44, 191)
}

local TextData = {
    RU = {
        Title = "mager1x Hub ⚡ | MM2", Combat = "Combat", Visual = "Visual", Settings = "Settings",
        Aimbot = "Aim-Bot (45 мс)", SilentAim = "Silent Aim ❌ (Рейдж)", KnifeAim = "Knife Aura (Для Убийцы)",
        Bone = "Зона попадания (Кость)", ESP = "Включить ESP (ВХ)", Color = "Цвет подсветки ESP",
        LangToggle = "Язык меню / Language", ThemeToggle = "Тема интерфейса"
    }
}

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
        if raycastResult then return true end
    end
    return false
end

local Window = Material.Load({Title = TextData[Config.Language].Title, Style = 3, SizeX = 390, SizeY = 350, Theme = Config.Theme})
local CombatTab = Window.NewTab({ Title = TextData[Config.Language].Combat })
local VisualTab = Window.NewTab({ Title = TextData[Config.Language].Visual })
local SettingsTab = Window.NewTab({ Title = TextData[Config.Language].Settings })

CombatTab.NewToggle({
    Title = TextData[Config.Language].Aimbot,
    Callback = function(Value)
        Config.Aimbot = Value
        if Value then
            task.spawn(function()
                while Config.Aimbot do task.wait(0.045)
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                                if not isBehindWall(player) then
                                    local targetPart = player.Character:FindFirstChild(Config.AimPart)
                                    if targetPart then
                                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
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

CombatTab.NewToggle({
    Title = TextData[Config.Language].SilentAim,
    Callback = function(Value)
        Config.SilentAim = Value
        if Value then
            task.spawn(function()
                local Hook
                Hook = hookmetamethod(game, "__index", function(Self, Key)
                    if not Config.SilentAim then return Hook(Self, Key) end
                    if tostring(Self) == "Gun" and Key == "Hit" then
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Knife") then
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

CombatTab.NewToggle({
    Title = TextData[Config.Language].KnifeAim,
    Callback = function(Value)
        Config.KnifeAimbot = Value
        if Value then
            task.spawn(function()
                while Config.KnifeAimbot do task.wait(0.1)
                    local knife = game.Players.LocalPlayer.Character:FindFirstChild("Knife")
                    if knife then
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player ~= game.Players.LocalPlayer and player.Character then
                                if not isBehindWall(player) then
                                    local targetPart = player.Character:FindFirstChild("HumanoidRootPart")
                                    if targetPart then
                                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                                        if distance < 25 then knife:Activate() end
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

CombatTab.NewDropdown({
    Title = TextData[Config.Language].Bone,
    List = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Random"},
    Callback = function(Value)
        if Value == "Torso" then Config.AimPart = "HumanoidRootPart" else Config.AimPart = Value end
    end
})

VisualTab.NewToggle({
    Title = TextData[Config.Language].ESP,
    Callback = function(Value)
        Config.ESP = Value
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if Value then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "MagHub_ESP"
                    highlight.FillColor = Config.ESPColor
                    highlight.Parent = p.Character
                else
                    if p.Character:FindFirstChild("MagHub_ESP") then p.Character.MagHub_ESP:Destroy() end
                end
            end
        end
    end
})

VisualTab.NewDropdown({
    Title = TextData[Config.Language].Color,
    List = {"Purple", "Red", "Green", "Blue", "Yellow"},
    Callback = function(Value)
        if Value == "Purple" then Config.ESPColor = Color3.fromRGB(123, 44, 191)
        elseif Value == "Red" then Config.ESPColor = Color3.fromRGB(255, 71, 87)
        elseif Value == "Green" then Config.ESPColor = Color3.fromRGB(46, 213, 115)
        elseif Value == "Blue" then Config.ESPColor = Color3.fromRGB(84, 160, 255)
        elseif Value == "Yellow" then Config.ESPColor = Color3.fromRGB(255, 242, 0)
        end
        if Config.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("MagHub_ESP") then p.Character.MagHub_ESP.FillColor = Config.ESPColor end
            end
        end
    end
})

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "mager1x Hub", Text = "Скрипт успешно запущен!", Duration = 5})
