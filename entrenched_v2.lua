-- [[ PROTEÇÃO ANTI-DETECÇÃO E CRASH ]]
if not game:IsLoaded() then game.Loaded:Wait() end

-- [[ CARREGA A INTERFACE ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Entrenched Neural v2", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "AcodeScripts"
})

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.HitboxEnabled = false
_G.HitboxSize = 5

-- [[ ABA DE COMBATE ]]
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

-- [[ LOOP DE EXECUÇÃO EM SEGUNDO PLANO ]]
task.spawn(function()
    while task.wait(1) do
        if _G.HitboxEnabled then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                -- Verifica se é inimigo e se o personagem está vivo/carregado
                if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team then
                    pcall(function()
                        local character = v.Character
                        if character and character:FindFirstChild("Head") then
                            local head = character.Head
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
