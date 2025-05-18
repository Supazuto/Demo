local module = {}

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Folder
local AnimationsFolder = ReplicatedStorage:WaitForChild("Animations")
local WeaponsAnimations = AnimationsFolder:WaitForChild("Weapons")

--Stuff
local lastSwing = {}
local MaxCombo = 3

function module.stopAnimations(humanoid)
    for i, v in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if v.Name ~= "Idle" and v.Name ~= "Animation" then
            v:Stop()
        end
    end
end

function module.ChangeCombo(character)
    local combo = character:GetAttribute("Combo")

    if lastSwing[character] then
        local passedTime = tick() - lastSwing[character]
        if passedTime <= 2 then
            if combo >= MaxCombo then
                character:SetAttribute("Combo", 1)
            else
                character:SetAttribute("Combo", combo + 1)
            end
        else
            character:SetAttribute("Combo", 1)
        end
    end   
    
    lastSwing[character] = tick()
end


function module.getSwingAnimation(character, weaponName)
    local combo = character:GetAttribute("Combo")
    local currentAnimaton = WeaponsAnimations:WaitForChild(weaponName):WaitForChild("Combat"):WaitForChild("Swing" .. combo)
    
    return currentAnimaton
end
return module