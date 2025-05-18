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
local VFX_Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("VFX")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local ServerCombatModule = require(ServerStorageModules.CombatModules)


function module.Normal_HitboxHit(player, character, weapon, Hitbox, ...)
    local hitAnimation = ...


    Hitbox.OnHit:Connect(function(hit)
        if hit.Parent:FindFirstChild("Humanoid") and hit. Parent ~= character then
            
            local eCharacter = hit.Parent
            local eHumanoid = eCharacter:FindFirstChild("Humanoid")
            local eHumanoidRootPart = eCharacter:FindFirstChild("HumanoidRootPart")

            if eHumanoid.Health > 0 then
            
                eHumanoid:TakeDamage(10)

                

                ServerCombatModule.stopAnimations(eHumanoid)

                VFX_Event:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat["Hit-01"], hit.CFrame, .3)

                SoundsModule.PlaySound(WeaponSounds[weapon].Combat.hitSound, eCharacter.Torso)

                eHumanoid.Animator:LoadAnimation(hitAnimation):Play()
            end
        end
    end)
    
end

return module