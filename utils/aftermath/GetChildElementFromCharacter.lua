local Players = game:GetService("Players")

local function printChildInfo(child)
    print("    Child Object:", child.Name)
    print("        Class:", child.ClassName)
end

for _, player in pairs(Players:GetPlayers()) do
    if player and player.Character then
        local character = player.Character
        local rootPart = character:FindFirstChild("ServerColliderHead")
        if rootPart then
            print(character, rootPart.Position)
            local characterChildren = character:GetChildren()
            for i, part in ipairs(characterChildren) do
                print("Body Part:", part.Name)
                print("    Class:", part.ClassName)
                
                for _, child in ipairs(part:GetChildren()) do
                    printChildInfo(child)
                end
                
                if i >= 2 then
                    break
                end
            end
        end
    else
        print("Player or character not found.")
    end
end