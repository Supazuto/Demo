local module = {}

--Services
--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")

--Folder
local WeaponSounds = SoundService:WaitForChild("SFX"):WaitForChild("Weapons")
local ReplicatedStorageModules = ReplicatedStorage:WaitForChild("Modules")
local ServerStorageModules = ServerStorage:WaitForChild("Modules")

--Events
local CombatEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local ServerCombatModule = require(ServerStorageModules.CombatModules)


function module.Normal_HitboxHit(player, character, weapon, Hitbox)
    Hitbox.OnHit:Connect(function(hit)
        if hit.Parent:FindFirstChild("Humanoid") and hit. Parent ~= character then
            
            local eCharacter = hit.Parent
            local eHumanoid = eCharacter:FindFirstChild("Humanoid")
            local eHumanoidRootPart = eCharacter:FindFirstChild("HumanoidRootPart")

            eHumanoid:TakeDamage(10)

            ServerCombatModule.stopAnimations(eHumanoid)
        end
    end)
    
end

return module