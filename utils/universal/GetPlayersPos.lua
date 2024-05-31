local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Função para calcular a distância entre dois pontos
local function calculateDistance(point1, point2)
    return (point1 - point2).magnitude
end

-- Função para converter distância em studs para metros
local function studsToMeters(distanceInStuds)
    local metersPerStud = 0.28
    return distanceInStuds * metersPerStud
end

-- Função para obter a posição da câmera de um jogador
local function getPlayerCameraPosition(player)
    local character = player.Character
    if character and character:IsDescendantOf(Workspace) and character:FindFirstChild("HumanoidRootPart") then
        return Camera.CFrame.Position
    end
    return nil
end

-- Loop através dos jogadores
for _, player in pairs(Players:GetPlayers()) do
    local cameraPosition = getPlayerCameraPosition(player)
    if cameraPosition then
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local distanceInStuds = calculateDistance(humanoidRootPart.Position, cameraPosition)
        local distanceInMeters = studsToMeters(distanceInStuds)
        print(character, distanceInMeters)
    end
end