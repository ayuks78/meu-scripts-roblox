-- [[ CONFIGURAÇÕES AUTOMÁTICAS ]]
local HitboxSize = 6          -- Tamanho da cabeça do inimigo
local HitboxTransparency = 0.6 -- Transparência da cabeça
local ShowESP = true           -- Ativar nomes e vida

-- [[ MENSAGEM DE ATIVAÇÃO NO CHAT ]]
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Entrenched Neural v3.0";
    Text = "Versão Ghost Ativada! Tudo pronto.";
    Duration = 5;
})

-- [[ FUNÇÃO DE ESP (NOMES E VIDA) ]]
local function AplicarESP(plr)
    if plr == game.Players.LocalPlayer then return end

    local function CriarInterface()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 10)
        if not head then return end

        local bbg = Instance.new("BillboardGui", head)
        bbg.Name = "GhostESP"
        bbg.Size = UDim2.new(0, 200, 0, 50)
        bbg.AlwaysOnTop = true
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", bbg)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14

        task.spawn(function()
            while char:IsDescendantOf(game.Workspace) do
                local dist = math.floor((game.Players.LocalPlayer.Character.Head.Position - head.Position).Magnitude)
                local hum = char:FindFirstChild("Humanoid")
                local hp = hum and math.floor(hum.Health) or 0
                
                if plr.Team == game.Players.LocalPlayer.Team then
                    label.TextColor3 = Color3.fromRGB(0, 150, 255) -- Azul Amigo
                    label.Text = string.format("%s\n%d studs", plr.Name, dist)
                else
                    label.TextColor3 = Color3.fromRGB(255, 50, 50) -- Vermelho Inimigo
                    label.Text = string.format("%s\nHP: %d | %d studs", plr.Name, hp, dist)
                end
                task.wait(1)
            end
        end)
    end
    CriarInterface()
    plr.CharacterAdded:Connect(CriarInterface)
end

-- [[ LOOP PRINCIPAL: HITBOX E ANTI-LAG ]]
task.spawn(function()
    while true do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                -- Anti-Lag Simplificado
                settings().Network.IncomingReplicationLag = 0
                
                -- Hitbox Inimiga
                if v.Team ~= game.Players.LocalPlayer.Team then
                    pcall(function()
                        local head = v.Character:FindFirstChild("Head")
                        if head then
                            head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                            head.Transparency = HitboxTransparency
                            head.CanCollide = false
                        end
                    end)
                end
                
                -- Ativar ESP se não existir
                if not v.Character:FindFirstChild("Head"):FindFirstChild("GhostESP") then
                    AplicarESP(v)
                end
            end
        end
        task.wait(2)
    end
end)
