-- [[ 1. INICIALIZAÇÃO SEGURA ]]
if not game:IsLoaded() then 
    pcall(function() game.Loaded:Wait() end)
end

-- [[ 2. CARREGA A BIBLIOTECA ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- [[ 3. CRIA A JANELA ]]
local Window = OrionLib:MakeWindow({
    Name = "Entrenched Neural v2", 
    HidePremium = false, 
    SaveConfig = false, -- Deixe False para evitar erro no Android
    IntroText = "Carregando Scripts..."
})

-- [[ 4. VARIÁVEIS ]]
_G.HitboxEnabled = false
_G.HitboxSize = 5

-- [[ 5. ABA E BOTÕES ]]
local Tab = Window:MakeTab({
    Name = "Combate",
    Icon = "rbxassetid://4483345998"
})

Tab:AddToggle({
    Name = "Ativar Hitbox",
    Default = false,
    Callback = function(Value)
        _G.HitboxEnabled = Value
    end    
})

Tab:AddSlider({
    Name = "Tamanho da Hitbox",
    Min = 2, Max = 15, Default = 5,
    Callback = function(Value) 
        _G.HitboxSize = Value 
    end    
})

-- [[ 6. LOOP DA HITBOX ]]
task.spawn(function()
    while task.wait(1) do
        if _G.HitboxEnabled then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team then
                    pcall(function()
                        local head = v.Character:FindFirstChild("Head")
                        if head then
                            head.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                            head.Transparency = 0.6
                            head.CanCollide = false
                        end
                    end)
                end
            end
        end
    end
end)

OrionLib:Init()
