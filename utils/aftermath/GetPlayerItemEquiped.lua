local Players = game:GetService("Players")

for _, player in pairs(Players:GetPlayers()) do
    local equipamentoSemSufixo
    local currentSlotSelected = player.CurrentSelected.Value
    local slotName = string.format("Slot%i", currentSlotSelected)
    local slot = player.GunInventory:FindFirstChild(slotName).Value

    print("")
    print("Player:", player)
    print("Slot Selecionado:", currentSlotSelected)
    print("Equipado:", slot)
    print("")
end