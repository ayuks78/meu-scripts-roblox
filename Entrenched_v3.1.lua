-- [[ CONFIGURAÇÕES ]]
local ESP_ATIVO = true
local AIMBOT_ATIVO = true
local DISTANCIA_MAXIMA = 1000

-- Cores
local CorInimigo = Color3.fromRGB(255, 0, 0)
local CorAliado = Color3.fromRGB(0, 0, 255)

-- [[ FUNÇÃO DE ESP (CAIXA E INFO) ]]
function CriarESP(Player)
    Player.CharacterAdded:Connect(function(Character)
        local Gui = Instance.new("BillboardGui", Character:WaitForChild("HumanoidRootPart"))
        Gui.Name = "NeuralESP"
        Gui.AlwaysOnTop = true
        Gui.Size = UDim2.new(4, 0, 5, 0)
        
        local Frame = Instance.new("Frame", Gui)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 0.7
        Frame.BorderSizePixel = 2
        
        local Info = Instance.new("TextLabel", Gui)
        Info.Size = UDim2.new(1, 0, 0.2, 0)
        Info.Position = UDim2.new(0, 0, -0.3, 0)
        Info.BackgroundTransparency = 1
        Info.TextStrokeTransparency = 0
        Info.TextSize = 12
        Info.Font = Enum.Font.SourceSansBold

        task.spawn(function()
            while Character:Parent() do
                local Hum = Character:FindFirstChild("Humanoid")
                if Hum and Player.Team then
                    local Vida = math.floor((Hum.Health / Hum.MaxHealth) * 100)
                    Info.Text = string.format("%s | %d%%", Player.Name, Vida)
                    
                    if Player.Team == game.Players.LocalPlayer.Team then
                        Frame.BackgroundColor3 = CorAliado
                        Info.TextColor3 = CorAliado
                    else
                        Frame.BackgroundColor3 = CorInimigo
                        Info.TextColor3 = CorInimigo
                    end
                end
                task.wait(1)
            end
        end)
    end)
end

-- [[ LÓGICA DO AIMBOT (TRONCO) ]]
local function GetClosestPlayer()
    local Target = nil
    local ShortestDistance = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local Pos, OnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if OnScreen then
                local MousePos = game:GetService("UserInputService"):GetMouseLocation()
                local Magnitude = (Vector2.new(Pos.X, Pos.Y) - MousePos).Magnitude
                if Magnitude < ShortestDistance then
                    Target = v.Character.HumanoidRootPart
                    ShortestDistance = Magnitude
                end
            end
        end
    end
    return Target
end

-- Hook para o tiro (Aimbot Suave)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    if Method == "FindPartOnRayWithIgnoreList" and AIMBOT_ATIVO then
        local T = GetClosestPlayer()
        if T then
            Args[1] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (T.Position - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return OldNamecall(Self, unpack(Args))
        end
    end
    return OldNamecall(Self, ...)
end)

-- Iniciar para jogadores atuais
for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then CriarESP(v) end
end
game.Players.PlayerAdded:Connect(CriarESP)

print("Script Entrenched v3.1 Carregado!")
