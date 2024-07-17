local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Function to calculate the distance between two points
local function calculateDistance(point1, point2)
    return (point1 - point2).magnitude
end

-- Function to convert distance in studs to meters
local function studsToMeters(distanceInStuds)
    local metersPerStud = 0.28
    return distanceInStuds * metersPerStud
end

-- Function to obtain a player's camera position
local function getPlayerCameraPosition(player)
    local character = player.Character
    if character and character:IsDescendantOf(Workspace) and character:FindFirstChild("HumanoidRootPart") then
        return Camera.CFrame.Position
    end
    return nil
end

-- Loop through players
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
