local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function printBodyPartInfo(part)
    print("Body Part:", part.Name)
    print("    Class:", part.ClassName)
    print("    ---")
end

if LocalPlayer and LocalPlayer.Character then
    local character = LocalPlayer.Character
    local characterChildren = character:GetChildren()

    local maxPartsToPrint = math.min(#characterChildren, 20)

    for i = 1, maxPartsToPrint do
        local part = characterChildren[i]
        printBodyPartInfo(part)
    end

    if #characterChildren > 20 then
        print("... and more not showable parts.")
    end
else
    print("Player or character not found.")
end
