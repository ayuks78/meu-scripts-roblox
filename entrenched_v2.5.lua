-- [[ BIBLIOTECA KAVO ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Entrenched Neural v4", "DarkScene")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.HitboxEnabled = false
_G.HitboxSize = 6
_G.ESPEnabled = false
_G.AimbotEnabled = false
_G.AntiLag = true

-- [[ ABA DE COMBATE ]]
local Tab1 = Window:NewTab("Combate")
local Section1 = Tab1:NewSection("Ajustes de Combate")

Section1:NewToggle("Ativar Hitbox + Soft Aim", "Hitbox e ajuda de mira suave", function(state)
    _G.HitboxEnabled = state
    _G.AimbotEnabled = state
end)

Section1:NewSlider("Tamanho da Hitbox", "Aumenta a precisão", 12, 2, function(s)
    _G.HitboxSize = s
end)

-- [[ ABA DE SISTEMA ]]
local Tab3 = Window:NewTab("Sistema")
local Section3 = Tab3:NewSection("Proteções")

Section3:NewToggle("Anti-Lag / Anti-Kick", "Evita ban por Wi-Fi ruim", function(state)
    _G.AntiLag = state
end)

-- [[ ABA DE VISUAL (ESP) ]]
local Tab2 = Window:NewTab("Visual (ESP)")
local Section2 = Tab2:NewSection("ESP Completo")

Section2:NewToggle("Ativar ESP Inimigo/Amigo", "Vermelho p/ Inimigo, Azul p/ Amigo", function(state)
    _G.ESPEnabled = state
end)

-- [[ LÓGICA DO ANTI-LAG ]]
task.spawn(function()
    while task.wait(5) do
        if _G.AntiLag then
            pcall(function()
                -- Limpa efeitos de lag que podem causar kick
                settings().Network.IncomingReplicationLag = 0
            end)
        end
    end
end)

-- [[ LÓGICA DO ESP ]]
local function CreateESP(plr)
    local Billboard = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    Billboard.Name = "ESP_Neural"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    
    TextLabel.Parent = Billboard
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 14
    TextLabel.TextStrokeTransparency = 0

    task.spawn(function()
        while plr.Character and plr.Character:FindFirstChild("Head") and _G.ESPEnabled do
            local head = plr.Character.Head
            Billboard.Adornee = head
            Billboard.Parent = head
            
            local dist = math.floor((game.Players.LocalPlayer.Character.Head.Position - head.Position).Magnitude)
            local hum = plr.Character:FindFirstChild("Humanoid")
            
            if plr.Team == game.Players.LocalPlayer.Team then
                TextLabel.TextColor3 = Color3.fromRGB(0, 100, 255) -- Azul
                TextLabel.Text = string.format("[Amigo] %s\n%d studs", plr.Name, dist)
            else
                local hp = hum and math.floor((hum.Health / hum.MaxHealth) * 100) or 0
                TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho
                TextLabel.Text = string.format("%s\nHP: %d%% | %d studs", plr.Name, hp, dist)
            end
            task.wait(0.5)
        end
        Billboard:Destroy()
    end)
end

-- [[ LOOP PRINCIPAL ]]
task.spawn(function()
    while task.wait(1.5) do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                -- Hitbox
                if _G.HitboxEnabled and v.Team ~= game.Players.LocalPlayer.Team then
                    pcall(function()
                        local head = v.Character.Head
                        head.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                        head.Transparency = 0.6
                        head.CanCollide = false
                    end)
                end
                -- ESP
                if _G.ESPEnabled and not v.Character.Head:FindFirstChild("ESP_Neural") then
                    CreateESP(v)
                end
            end
        end
    end
end)
