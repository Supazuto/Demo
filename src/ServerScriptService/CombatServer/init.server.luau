--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")

--Folder
local WeaponSounds = SoundService:WaitForChild("SFX"):WaitForChild("Weapons")
local ReplicatedStorageModules = ReplicatedStorage:WaitForChild("Modules")
local ServerStorageModules = ServerStorage:WaitForChild("Modules")
local WeaponsAnimations = ReplicatedStorage:WaitForChild("Animations"):WaitForChild("Weapons")

--Events
local CombatEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local ServerCombatModule = require(ServerStorageModules.CombatModules)
local HitServiceModule = require(ServerStorageModules.HitService)
local RaycastHitbox = require(ServerStorageModules.Hitboxes.RaycastHitboxV4)
--Stuff
local MaxCombo = 3

CombatEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")

    local attacking = character:GetAttribute("Attacking")
    local stunned = character:GetAttribute("Stunned")
    local equipped = character:GetAttribute("Equipped")

    if attacking or stunned or not equipped then
        return
    end
    
    local CurrentWeapon = character:GetAttribute("CurrentWeapon")

    character:SetAttribute("Attacking", true)
    character:SetAttribute("Swing", true)

    ServerCombatModule.ChangeCombo(character)
    ServerCombatModule.stopAnimations(humanoid)

    humanoid.WalkSpeed = 7
    humanoid.JumpHeight = 0


    local Hitbox = RaycastHitbox.new(character[CurrentWeapon])

    local SwingAnimation = ServerCombatModule.getSwingAnimation(character, CurrentWeapon)
    local playSwingAnimation = humanoid:LoadAnimation(SwingAnimation)

    playSwingAnimation:GetMarkerReachedSignal("HitStart"):Connect(function()
        --hitbox
        Hitbox:HitStart()
    end)

    playSwingAnimation:GetMarkerReachedSignal("HitEnd"):Connect(function()
        Hitbox:HitStop()
        character:SetAttribute("Swing", false)
        if character:GetAttribute("Combo") == MaxCombo then
            task.wait(1)
        else
            task.wait(.1)
        end
        character:SetAttribute("Attacking", false)
    end)

    playSwingAnimation.Stopped:Connect(function()
        if not character:GetAttribute("Swing") then
            humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
            humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight
        end
    end)

    playSwingAnimation:Play()

    SoundsModule.PlaySound(WeaponSounds[CurrentWeapon].Combat.Swing, character.Torso)

    local hitAnimation = WeaponsAnimations[CurrentWeapon].Hit["Hit" .. character:GetAttribute("Combo")]
    HitServiceModule.Normal_HitboxHit(player, character, CurrentWeapon, Hitbox, hitAnimation)
end)