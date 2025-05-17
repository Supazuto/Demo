--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Folders
local Models = ReplicatedStorage.Models
local Weapons = Models:WaitForChild("Weapons")
local WeaponsWeld = script.Welds.Weapons
local Events = ReplicatedStorage:WaitForChild("Events")

--Events
local WeaponsEvent = Events:WaitForChild("WeaponEvent")

--Object
local Welds = {}

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local torso = character:WaitForChild("Torso")

        character:SetAttribute("Equipped", false)

        local Weapon = Weapons.Durandal
        Weapons.Parent = character

        Welds[player] = WeaponsWeld.Durandal.IdleWeaponWeld:Clone()
        Welds[player].Parent = torso
        Welds[player].Part0 = torso
        Welds[player].Part1 = Weapon
        
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if Welds[player] then
        table.remove(Welds, table.find(Welds, Welds[player]))
    end
end)

WeaponsEvent.OnServerEvent:Connect(function(player, action)
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    local torso = character:WaitForChild("Torso")
    local rightArm = character:WaitForChild("Right Arm")

    if action == "Equip/Unequip" and not character:GetAttribute("Equipped") then --equipping
        character:SetAttribute("Equipped", true)

        Welds[player].Part0 = rightArm
        Welds[player].C1 = WeaponsWeld.Durandal.HoldingWeaponWeld.C1
elseif action == "Equip/Unequip" and character:GetAttribute("Equipped") then --unequipping
        character:SetAttribute("Equipped", false)

        Welds[player].Part0 = torso
        Welds[player].C1 = WeaponsWeld.Durandal.IdleWeaponWeld.C1
    end
end)