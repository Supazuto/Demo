local module = {}

--Services
--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

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
local WeaponStatsModule = require(ServerStorageModules.Weapons.WeaponStats)
local StunHandler = require(ServerStorageModules.Other.StunHandlerV2)

function module.BodyVelocity(Parent, HumanoidRootPart, Knockback, stayTime)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
    BodyVelocity.P = 50000
    BodyVelocity.Velocity = HumanoidRootPart.CFrame.LookVector * Knockback
    BodyVelocity.Parent = Parent
    Debris:AddItem(BodyVelocity, stayTime)

    
end

function module.Normal_HitboxHit(player, character, weapon, Hitbox, ...)
    local hitAnimation = ...


    Hitbox.OnHit:Connect(function(hit)
        if hit.Parent:FindFirstChild("Humanoid") and hit. Parent ~= character then
            
            local eCharacter = hit.Parent
            local eHumanoid = eCharacter:FindFirstChild("Humanoid")
            local eHumanoidRootPart = eCharacter:FindFirstChild("HumanoidRootPart")

            if eHumanoid.Health > 0 and not  eCharacter:GetAttribute("iframes") then

                local WeaponStats = WeaponStatsModule.getStats(weapon)
                local damage = WeaponStats.Damage
                local knockback = WeaponStats.Knockback
                local stunTime = WeaponStats.StunTime
            
                eHumanoid:TakeDamage(damage)

                

                ServerCombatModule.stopAnimations(eHumanoid)

                VFX_Event:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat["Hit-01"], hit.CFrame, .3)

                SoundsModule.PlaySound(WeaponSounds[weapon].Combat.hitSound, eCharacter.Torso)

                eHumanoid.Animator:LoadAnimation(hitAnimation):Play()

                module.BodyVelocity(character.HumanoidRootPart, character.HumanoidRootPart, knockback, 0.2)

                if character:GetAttribute("Combo") >= 3 then
                    knockback = knockback * 5
                end

                module.BodyVelocity(eHumanoidRootPart, character.HumanoidRootPart, knockback, 0.2)

                StunHandler.Stun(eHumanoid, stunTime)
            end
        end
    end)
    
end

return module