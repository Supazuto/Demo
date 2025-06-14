local module = {}

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

--Folders
local Events = ReplicatedStorage.Events
local ReplicatedStorageModules = ReplicatedStorage.Modules
local WeaponSounds = SoundService.SFX.Weapons
local WeaponAnimsFolder = ReplicatedStorage.Animations.Weapons

--Events
local VFX_Event = Events.VFX

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)

--Model




function module.Blocking(echaracter, damage, hitposition)
    if echaracter:GetAttribute("Blocking") <= 100 then
        local Torso = echaracter:FindFirstChild("UpperTorso") or echaracter:FindFirstChild("Torso")
        
        echaracter:SetAttribute("Blocking", echaracter:GetAttribute("Blocking") + damage)
 
       VFX_Event:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat.Block, hitposition, .3)

       SoundsModule.PlaySound(WeaponSounds[echaracter:GetAttribute("CurrentWeapon")].Blocking.Blocked, Torso)

       echaracter.Humanoid.Animator:LoadAnimation(WeaponAnimsFolder(echaracter:GetAttribute("CurrentWeapon")).Blocking.Blocking):Play()

        if echaracter:GetAttribute("Blocking") >= 100 then
            print("guard break")
            echaracter:SetAttribute("Blocking", 0)
        end
    end
    
end

return module