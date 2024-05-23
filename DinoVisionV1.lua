local DinoVision = {
	esp = {
		CharacterSize = Vector2.new(5,6);
		Box = {
			TeamCheck = false;
			Box = true;
			Name = true;
			Distance = true;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = true;
			OutlineColor = Color3.fromRGB(0,0,0);	
		};

		Tracer = {
			TeamCheck = false;
			TeamColor = false;
			Tracer = true;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = true;
			OutlineColor = Color3.fromRGB(0, 0, 0);
		};

		Highlights = {
			TeamCheck = false;
			Highlights = true;
			AllWaysVisible = true;
			OutlineTransparency = 0.5;
			FillTransparency = 0.5;
			OutlineColor = Color3.fromRGB(255, 0, 0);
			FillColor = Color3.fromRGB(255, 255, 255);
		};
	};
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local CurrentCamera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local ESPHolder = Instance.new("Folder", CoreGui)
ESPHolder.Name = "ESPHolder"

local function IsAlive(Player)
    return Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
end

local function GetTeam(Player)
    return Player and Player.Team
end

local function LoadESP(Player)
    local PlayerESP = Instance.new("Folder", ESPHolder)
    PlayerESP.Name = Player.Name .. "ESP"

    -- Box
    local BoxHolder = Instance.new("ScreenGui", PlayerESP)
    BoxHolder.Name = "Box"
    BoxHolder.DisplayOrder = 2

    local TracerHolder = Instance.new("ScreenGui", PlayerESP)
    TracerHolder.Name = "Tracer"

    local HilightHolder = Instance.new("Folder", PlayerESP)
    HilightHolder.Name = "Hilight"

    local LeftOutline = Instance.new("Frame", BoxHolder)
    LeftOutline.BackgroundColor3 = DinoVision.esp.Box.OutlineColor
    LeftOutline.Visible = false
    LeftOutline.BorderSizePixel = 1

    local RightOutline = Instance.new("Frame", BoxHolder)
    RightOutline.BackgroundColor3 = DinoVision.esp.Box.OutlineColor
    RightOutline.Visible = false
    RightOutline.BorderSizePixel = 1

    local TopOutline = Instance.new("Frame", BoxHolder)
    TopOutline.BackgroundColor3 = DinoVision.esp.Box.OutlineColor
    TopOutline.Visible = false
    TopOutline.BorderSizePixel = 1

    local BottomOutline = Instance.new("Frame", BoxHolder)
    BottomOutline.BackgroundColor3 = DinoVision.esp.Box.OutlineColor
    BottomOutline.Visible = false
    BottomOutline.BorderSizePixel = 1

    local Left = Instance.new("Frame", BoxHolder)
    Left.BackgroundColor3 = DinoVision.esp.Box.Color
    Left.Visible = false
    Left.BorderSizePixel = 0

    local Right = Instance.new("Frame", BoxHolder)
    Right.BackgroundColor3 = DinoVision.esp.Box.Color
    Right.Visible = false
    Right.BorderSizePixel = 0

    local Top = Instance.new("Frame", BoxHolder)
    Top.BackgroundColor3 = DinoVision.esp.Box.Color
    Top.Visible = false
    Top.BorderSizePixel = 0

    local Bottom = Instance.new("Frame", BoxHolder)
    Bottom.BackgroundColor3 = DinoVision.esp.Box.Color
    Bottom.Visible = false
    Bottom.BorderSizePixel = 0

    local Name = Instance.new("TextLabel", BoxHolder)
    Name.BackgroundTransparency = 1
    Name.Text = Player.Name
    Name.Visible = false
    Name.AnchorPoint = Vector2.new(0.5, 0.5)
    Name.TextSize = 12
    Name.Font = Enum.Font.SourceSansBold
    Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    Name.TextStrokeTransparency = 0

    local Distance = Instance.new("TextLabel", BoxHolder)
    Distance.BackgroundTransparency = 1
    Distance.Text = ""
    Distance.Visible = false
    Distance.AnchorPoint = Vector2.new(0.5, 0.5)
    Distance.TextSize = 12
    Distance.Font = Enum.Font.SourceSansBold
    Distance.TextColor3 = Color3.fromRGB(255, 255, 255)
    Distance.TextStrokeTransparency = 0

    local HealthBackground = Instance.new("Frame", BoxHolder)
    HealthBackground.Visible = false
    HealthBackground.BorderSizePixel = 1
    HealthBackground.BorderColor3 = DinoVision.esp.Box.OutlineColor

    -- local HealthBar = Instance.new("Frame", BoxHolder)
    -- HealthBar.Visible = false
    -- HealthBar.BorderSizePixel = 0
    -- HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    -- local Health = Instance.new("TextLabel", BoxHolder)
    -- Health.BackgroundTransparency = 1
    -- Health.Text = ""
    -- Health.Visible = false
    -- Health.AnchorPoint = Vector2.new(0.5, 0.5)
    -- Health.TextSize = 12
    -- Health.Font = Enum.Font.SourceSansBold
    -- Health.TextColor3 = Color3.fromRGB(255, 255, 255)
    -- Health.TextStrokeTransparency = 0

    -- Tracer
    local TracerOutline = Instance.new("Frame", TracerHolder)
    TracerOutline.BackgroundColor3 = DinoVision.esp.Tracer.OutlineColor
    TracerOutline.Visible = false
    TracerOutline.BorderSizePixel = 1
    TracerOutline.AnchorPoint = Vector2.new(0.5, 0.5)

    local Tracer = Instance.new("Frame", TracerHolder)
    Tracer.BackgroundColor3 = DinoVision.esp.Tracer.Color
    Tracer.Visible = false
    Tracer.BorderSizePixel = 0
    Tracer.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Hilight
    local Hilight = Instance.new("Highlight", HilightHolder)
    Hilight.Enabled = false

    local co = coroutine.create(function()
        RunService.Heartbeat:Connect(function()
            if IsAlive(Player) then
                local screen, onScreen = CurrentCamera:WorldToScreenPoint(Player.Character:FindFirstChild("WorldCharacter").UpperTorso.Position)
                local frustumHeight = math.tan(math.rad(CurrentCamera.FieldOfView * 0.5)) * 2 * screen.Z
                local size = CurrentCamera.ViewportSize.Y / frustumHeight * DinoVision.esp.CharacterSize
                local position = Vector2.new(screen.X, screen.Y) - (size / 2 - Vector2.new(0, size.Y) / 20)

                if onScreen then
                    -- Box
                    if DinoVision.esp.Box.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                        -- local health = Player.Character.Humanoid.Health
                        -- local healthScale = health / Player.Character.Humanoid.MaxHealth
                        -- local healthSizeY = size.Y * healthScale

                        LeftOutline.Visible = DinoVision.esp.Box.Box and DinoVision.esp.Box.Outline
                        RightOutline.Visible = DinoVision.esp.Box.Box and DinoVision.esp.Box.Outline
                        TopOutline.Visible = DinoVision.esp.Box.Box and DinoVision.esp.Box.Outline
                        BottomOutline.Visible = DinoVision.esp.Box.Box and DinoVision.esp.Box.Outline
                        HealthBackground.Visible = DinoVision.esp.Box.HealthBar

                        Left.Visible = DinoVision.esp.Box.Box
                        Right.Visible = DinoVision.esp.Box.Box
                        Top.Visible = DinoVision.esp.Box.Box
                        Bottom.Visible = DinoVision.esp.Box.Box
                        -- HealthBar.Visible = DinoVision.esp.Box.HealthBar
                        Name.Visible = DinoVision.esp.Box.Name
                        Distance.Visible = DinoVision.esp.Box.Distance and not DinoVision.esp.Box.Name
                        -- Health.Visible = DinoVision.esp.Box.Health

                        Left.Size = UDim2.fromOffset(size.X, 1)
                        Right.Size = UDim2.fromOffset(size.X, 1)
                        Top.Size = UDim2.fromOffset(1, size.Y)
                        Bottom.Size = UDim2.fromOffset(1, size.Y)

                        LeftOutline.Size = Left.Size
                        RightOutline.Size = Right.Size
                        TopOutline.Size = Top.Size
                        BottomOutline.Size = Bottom.Size
                        HealthBackground.Size = UDim2.fromOffset(4, size.Y)
                        -- HealthBar.Size = UDim2.fromOffset(2, -healthSizeY)

                        Left.Position = UDim2.fromOffset(position.X, position.Y)
                        Right.Position = UDim2.fromOffset(position.X, position.Y + size.Y - 1)
                        Top.Position = UDim2.fromOffset(position.X, position.Y)
                        Bottom.Position = UDim2.fromOffset(position.X + size.X - 1, position.Y)
                        Name.Position = UDim2.fromOffset(screen.X, screen.Y - (size.Y + Name.TextBounds.Y + 14) / 2)
                        Distance.Position = UDim2.fromOffset(screen.X, screen.Y - (size.Y + Name.TextBounds.Y + 19) / 2)
                        HealthBackground.Position = UDim2.fromOffset(position.X - 8, position.Y)
                        -- HealthBar.Position = UDim2.fromOffset(position.X - 7, position.Y + size.Y)
                        -- Health.Position = DinoVision.esp.Box.HealthBar and UDim2.fromOffset(position.X - 25, position.Y + size.Y - healthSizeY) or UDim2.fromOffset(position.X - 25, position.Y + size.Y)

                        LeftOutline.Position = Left.Position
                        RightOutline.Position = Right.Position
                        TopOutline.Position = Top.Position
                        BottomOutline.Position = Bottom.Position

                        LeftOutline.BorderColor3 = DinoVision.esp.Box.OutlineColor
                        RightOutline.BorderColor3 = DinoVision.esp.Box.OutlineColor
                        TopOutline.BorderColor3 = DinoVision.esp.Box.OutlineColor
                        BottomOutline.BorderColor3 = DinoVision.esp.Box.OutlineColor
                        -- HealthBackground.BackgroundColor3 = DinoVision.esp.Box.OutlineColor
                        -- HealthBackground.BorderColor3 = DinoVision.esp.Box.OutlineColor

                        Left.BackgroundColor3 = DinoVision.esp.Box.Color
                        Right.BackgroundColor3 = DinoVision.esp.Box.Color
                        Top.BackgroundColor3 = DinoVision.esp.Box.Color
                        Bottom.BackgroundColor3 = DinoVision.esp.Box.Color
                        LeftOutline.BackgroundColor3 = DinoVision.esp.Box.Color
                        RightOutline.BackgroundColor3 = DinoVision.esp.Box.Color
                        TopOutline.BackgroundColor3 = DinoVision.esp.Box.Color
                        BottomOutline.BackgroundColor3 = DinoVision.esp.Box.Color

                        Distance.Text = math.floor(0.5 + (CurrentCamera.CFrame.Position - Player.Character.HumanoidRootPart.Position).magnitude)
                        Name.Text = DinoVision.esp.Box.Name and DinoVision.esp.Box.Distance and Player.Name .. " (" .. math.floor(0.5 + (CurrentCamera.CFrame.Position - Player.Character.HumanoidRootPart.Position).magnitude) .. ")" or Player.Name
                        -- Health.Text = math.floor(Player.Character.Humanoid.Health)
                    else
                        LeftOutline.Visible = false
                        RightOutline.Visible = false
                        TopOutline.Visible = false
                        BottomOutline.Visible = false
                        Left.Visible = false
                        Right.Visible = false
                        Top.Visible = false
                        Bottom.Visible = false
                        Name.Visible = false
                        Distance.Visible = false
                        -- HealthBackground.Visible = false
                        -- HealthBar.Visible = false
                        -- Health.Visible = false
                    end

                    -- Tracer
                    if DinoVision.esp.Tracer.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                        local ScreenVec2 = Vector2.new(screen.X, screen.Y + size.Y / 2 + size.Y / 20)
                        local Origin = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y - 1)
                        local TracerPosition = (Origin + ScreenVec2) / 2

                        TracerOutline.Visible = DinoVision.esp.Tracer.Outline and DinoVision.esp.Tracer.Tracer
                        Tracer.Visible = DinoVision.esp.Tracer.Tracer

                        Tracer.Rotation = math.deg(math.atan2(ScreenVec2.Y - Origin.Y, ScreenVec2.X - Origin.X))
                        Tracer.Position = UDim2.new(0, TracerPosition.X, 0, TracerPosition.Y)
                        Tracer.Size = UDim2.fromOffset((Origin - ScreenVec2).Magnitude, 1)

                        TracerOutline.Rotation = Tracer.Rotation
                        TracerOutline.Position = Tracer.Position
                        TracerOutline.Size = Tracer.Size

                        TracerOutline.BorderColor3 = DinoVision.esp.Tracer.OutlineColor
                        Tracer.BackgroundColor3 = DinoVision.esp.Tracer.Color
                    else
                        TracerOutline.Visible = false
                        Tracer.Visible = false
                    end

                    -- Hilight
                    if DinoVision.esp.Highlights.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                        Hilight.Enabled = DinoVision.esp.Highlights.Highlights
                        Hilight.Adornee = Player.Character

                        Hilight.OutlineColor = DinoVision.esp.Highlights.OutlineColor
                        Hilight.FillColor = DinoVision.esp.Highlights.FillColor

                        Hilight.FillTransparency = DinoVision.esp.Highlights.FillTransparency
                        Hilight.OutlineTransparency = DinoVision.esp.Highlights.OutlineTransparency

                        Hilight.DepthMode = DinoVision.esp.Highlights.AllWaysVisible and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                    else
                        Hilight.Enabled = false
                        Hilight.Adornee = nil
                    end
                else
                    LeftOutline.Visible = false
                    RightOutline.Visible = false
                    TopOutline.Visible = false
                    BottomOutline.Visible = false
                    Left.Visible = false
                    Right.Visible = false
                    Top.Visible = false
                    Bottom.Visible = false
                    TracerOutline.Visible = false
                    Tracer.Visible = false
                    Name.Visible = false
                    Distance.Visible = false
                    -- HealthBackground.Visible = false
                    -- HealthBar.Visible = false
                    -- Health.Visible = false
                end
            else
                LeftOutline.Visible = false
                RightOutline.Visible = false
                TopOutline.Visible = false
                BottomOutline.Visible = false
                Left.Visible = false
                Right.Visible = false
                Top.Visible = false
                Bottom.Visible = false
                TracerOutline.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                Distance.Visible = false
                HealthBackground.Visible = false
                -- HealthBar.Visible = false
                -- Health.Visible = false
                -- Hilight.Adornee = nil
            end
        end)
        if not Players:FindFirstChild(Player.Name) then
            PlayerESP:Destroy()
            coroutine.yield()
        end
    end)
    coroutine.resume(co)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        LoadESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    LoadESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local esp = ESPHolder:FindFirstChild(player.Name .. "ESP")
    if esp then
        esp:Destroy()
    end
end)