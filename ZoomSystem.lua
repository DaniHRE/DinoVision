local oldZoom = game.Workspace.CurrentCamera.FieldOfView

local Settings = {
    ZoomTime = 0.2,
    ZoomedAmount = 10
}

local function createZoom(time, amount)
    local Tween_Info = TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) 
    local Tween = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, Tween_Info, {FieldOfView = amount})
    return Tween
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        createZoom(Settings.ZoomTime, Settings.ZoomedAmount):Play()
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        createZoom(Settings.ZoomTime, oldZoom):Play()
    end
end)