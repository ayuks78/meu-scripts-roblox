-- [[ CRIA UM AVISO NA TELA PARA VOCÊ SABER SE CARREGOU ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StatusLabel = Instance.new("TextLabel", ScreenGui)
StatusLabel.Size = UDim2.new(1, 0, 0.05, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.Text = "Neural v3.3: Carregando..."

-- [[ FUNÇÃO DE ESP ]]
local function CriarVisual(Player)
    if Player == game.Players.LocalPlayer then return end
    
    local function AdicionarTags()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Head = Char:WaitForChild("Head", 10)
        
        if Head and not Head:FindFirstChild("NeuralTag") then
            -- Nome e Vida
            local Billboard = Instance.new("BillboardGui", Head)
            Billboard.Name = "NeuralTag"
            Billboard.Size = UDim2.new(0, 100, 0, 50)
            Billboard.AlwaysOnTop = true
            Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
            
            local Text = Instance.new("TextLabel", Billboard)
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.BackgroundTransparency = 1
            Text.TextColor3 = (Player.Team == game.Players.LocalPlayer.Team) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
            Text.Text = Player.Name
            Text.Font = Enum.Font.SourceSansBold
            Text.TextSize = 14
        end
    end
    AdicionarTags()
    Player.CharacterAdded:Connect(AdicionarTags)
end

-- TENTATIVA DE RODAR
local sucesso, erro = pcall(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        CriarVisual(v)
    end
    game.Players.PlayerAdded:Connect(CriarVisual)
end)

if sucesso then
    StatusLabel.Text = "Neural v3.3: ATIVO (ESP RODANDO)"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    task.wait(5)
    StatusLabel:Destroy() -- Some depois de 5 segundos se der certo
else
    StatusLabel.Text = "ERRO: " .. tostring(erro)
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
end
