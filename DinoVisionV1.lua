local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera

local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint

local ESP = {}

local Headoff = Vector3.new(0, 0.5, 0)
local Legoff = Vector3.new(0, 3, 0)

local ESPEnabled = false -- Inicializa o ESP como desligado
local ChamsEnabled = false

local Options = {
    LineTracer = false,
    PlayerEquipment = false,
}

-- Função para calcular a distância entre dois pontos
local function calculateDistance(point1, point2)
    return (point1 - point2).magnitude
end

local function studsToMeters(distanceInStuds)
    local metersPerStud = 0.28
    return distanceInStuds * metersPerStud
end
local function removeESP(player)
    if ESP[player] then
        if ESP[player].PlayerEquipment then ESP[player].PlayerEquipment:Remove() end
        if ESP[player].BoxOutline then ESP[player].BoxOutline:Remove() end
        if ESP[player].Box then ESP[player].Box:Remove() end
        if ESP[player].PlayerInfo then ESP[player].PlayerInfo:Remove() end
        if ESP[player].lineTracer then ESP[player].lineTracer:Remove() end
        if ESP[player].highlight then ESP[player].highlight:Destroy() end
        ESP[player] = nil
    end
end

local function createESP(player)
    if player == Players.LocalPlayer then
        return
    end

    local function characterAdded(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        if not humanoidRootPart then
            return
        end

        -- Monitorar a existência do HumanoidRootPart
        humanoidRootPart.AncestryChanged:Connect(function(_, parent)
            if not parent then
                removeESP(player)
            end
        end)
        local PlayerEquipment = Drawing.new("Text")
        PlayerEquipment.Color = Color3.fromRGB(255, 255, 255)
        PlayerEquipment.Size = 12
        PlayerEquipment.Visible = false
        PlayerEquipment.Center = true
        PlayerEquipment.Outline = true
        PlayerEquipment.Font = 2

        local BoxOutline = Drawing.new("Square")
        BoxOutline.Visible = false
        BoxOutline.Color = Color3.new(0, 0, 0)
        BoxOutline.Thickness = 3
        BoxOutline.Transparency = 1
        BoxOutline.Filled = false

        local Box = Drawing.new("Square")
        Box.Visible = false
        Box.Color = Color3.new(1, 1, 1)
        Box.Thickness = 1
        Box.Transparency = 1
        Box.Filled = false

        local PlayerInfo = Drawing.new("Text")
        PlayerInfo.Text = player.Name
        PlayerInfo.Color = Color3.new(1, 1, 1)
        PlayerInfo.Size = 12
        PlayerInfo.Visible = false
        PlayerInfo.Outline = true
        PlayerInfo.Center = true
        PlayerInfo.Font = 2

        local lineTracer = Drawing.new("Line")
        lineTracer.Visible = false
        lineTracer.Color = Color3.new(1, 1, 1)
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.Enabled = false
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)

        ESP[player] = {
            PlayerEquipment = PlayerEquipment,
            BoxOutline = BoxOutline,
            Box = Box,
            PlayerInfo = PlayerInfo,
            highlight = highlight,
        }
    end

    if player.Character then
        characterAdded(player.Character)
    end
    player.CharacterAdded:Connect(characterAdded)
end

local function updateESP()
    if not ESPEnabled then
        for player, elements in pairs(ESP) do
            elements.PlayerEquipment.Visible = false
            elements.BoxOutline.Visible = false
            elements.Box.Visible = false
            elements.PlayerInfo.Visible = false
            elements.lineTracer.Visible = false
        end
        return
    end

    for player, elements in pairs(ESP) do
        local character = player.Character
        if character and character:IsDescendantOf(workspace) and character:FindFirstChild("HumanoidRootPart") then
            local RootPart = character:FindFirstChild("HumanoidRootPart")
            local Head = character:FindFirstChild("Head") or RootPart
            local screenPosition, isVisible = Camera:WorldToViewportPoint(RootPart.Position)

            local RootPosition = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + Headoff)
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - Legoff)

            local CameraPosition = Camera.CFrame.Position
            local DistanceInMeters = studsToMeters(calculateDistance(RootPart.Position, CameraPosition))

            if isVisible then
                elements.PlayerEquipment.Visible = Options.PlayerEquipment
                if  Options.PlayerEquipment then
                    local CurrentSlotSelected = player.CurrentSelected.Value
                    local SlotName = string.format("Slot%i", CurrentSlotSelected)
                    local Slot = player.GunInventory:FindFirstChild(SlotName).Value or "None"

                    Slot = tostring(Slot)

                    elements.PlayerEquipment.Position = Vector2.new(elements.Box.Position.X + elements.Box.Size.X / 2, elements.Box.Position.Y + elements.Box.Size.Y - 15)
                    elements.PlayerEquipment.Text = Slot
                end

                elements.BoxOutline.Size = Vector2.new(1000 / RootPosition.Z * 2, HeadPosition.Y - LegPosition.Y)
                elements.BoxOutline.Position = Vector2.new(RootPosition.X - elements.BoxOutline.Size.X / 2, RootPosition.Y - elements.BoxOutline.Size.Y / 2)
                elements.BoxOutline.Visible = true

                elements.Box.Size = Vector2.new(1000 / RootPosition.Z * 2, HeadPosition.Y - LegPosition.Y)
                elements.Box.Position = Vector2.new(RootPosition.X - elements.Box.Size.X / 2, RootPosition.Y - elements.Box.Size.Y / 2)
                elements.Box.Visible = true

                local NameAndDistanceText = string.format("%s (%.1fm)", player.Name, DistanceInMeters)
                elements.PlayerInfo.Visible = true
                elements.PlayerInfo.Position = Vector2.new(LegPosition.X, LegPosition.Y)
                elements.PlayerInfo.Text = NameAndDistanceText

                elements.lineTracer.Visible = Options.LineTracer
                if Options.LineTracer then
                    elements.lineTracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elements.lineTracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
                end
            else
                elements.PlayerEquipment.Visible = false
                elements.BoxOutline.Visible = false
                elements.Box.Visible = false
                elements.PlayerInfo.Visible = false
                elements.lineTracer.Visible = false
                end

                elements.highlight.Enabled = ChamsEnabled
            else
                elements.PlayerEquipment.Visible = false
                elements.BoxOutline.Visible = false
                elements.Box.Visible = false
                elements.PlayerInfo.Visible = false
                elements.lineTracer.Visible = false
                elements.highlight.Enabled = false
            end
        else
            removeESP(player)
        end
    end
end

-- Cria ESPs para todos os jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

-- Connect the PlayerAdded event to create ESP for new players
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    updateESP()
end)

-- Adiciona uma função para ligar/desligar o ESP
local function toggleESP()
    ESPEnabled = not ESPEnabled
end

local function toggleChams()
    ChamsEnabled = not ChamsEnabled
end
local function toggleOption(option)
    if Options[option] ~= nil then
        Options[option] = not Options[option]
    end
end

-- INTERFACE
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ESPButton = Instance.new("TextButton")
local LineTracerButton = Instance.new("TextButton")
local PlayerEquipmentButton = Instance.new("TextButton")

-- Função para fechar ou abrir a interface com a tecla ShiftDireita
local function ToggleInterface()
    IsOpen = not IsOpen
    MainFrame.Visible = IsOpen
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleInterface()
    end
end)

-- Criação da GUI
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)

ESPButton.Size = UDim2.new(0, 200, 0, 50)
ESPButton.Position = UDim2.new(0, 0, 0, 10)
ESPButton.Text = "Toggle ESP"
ESPButton.Parent = MainFrame

LineTracerButton.Size = UDim2.new(0, 200, 0, 50)
LineTracerButton.Position = UDim2.new(0, 0, 0, 70)
LineTracerButton.Text = "Toggle Line Tracer"
LineTracerButton.Parent = MainFrame

PlayerEquipmentButton.Size = UDim2.new(0, 200, 0, 50)
PlayerEquipmentButton.Position = UDim2.new(0, 0, 0, 130)
PlayerEquipmentButton.Text = "Toggle Player Equipment"
PlayerEquipmentButton.Parent = MainFrame
ChamsButton.Size = UDim2.new(0, 200, 0, 50)
ChamsButton.Position = UDim2.new(0, 0, 0, 310)
ChamsButton.Text = "Toggle Chams"
ChamsButton.Parent = MainFrame

ESPButton.MouseButton1Click:Connect(function()
    toggleESP()
    ESPButton.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
end)

LineTracerButton.MouseButton1Click:Connect(function()
    toggleOption("LineTracer")
    LineTracerButton.Text = "Line Tracer: " .. (Options.LineTracer and "ON" or "OFF")
end)

PlayerEquipmentButton.MouseButton1Click:Connect(function()
    toggleOption("PlayerEquipment")
    PlayerEquipmentButton.Text = "Player Equipment: " .. (Options.PlayerEquipment and "ON" or "OFF")
end)
ChamsButton.MouseButton1Click:Connect(function()
    toggleChams()
    ChamsButton.Text = "Chams: " .. (ChamsEnabled and "ON" or "OFF")
end)
