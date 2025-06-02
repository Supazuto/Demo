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
local WeaponsAnimations = ReplicatedStorage:WaitForChild("Animations"):WaitForChild("Weapons")

--Events
local CombatEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat")
local SkillEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Skill")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local ServerCombatModule = require(ServerStorageModules.CombatModules)
local ServerSkillModule = require(ServerStorageModules.SkillModules)
local HitServiceModule = require(ServerStorageModules.HitService)
local RaycastHitbox = require(ServerStorageModules.Hitboxes.RaycastHitboxV4)
local WeaponStatsModule = require(ServerStorageModules.Weapons.WeaponStats)
local SkillStatsModule = require(ServerStorageModules.Skills.SkillStats)
local HelpfulModule = require(ServerStorageModules.Other.Helpful)
--Stuff
local MaxCombo = 1

SkillEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	if HelpfulModule.CheckForAttribute(character, true, true, true, true, true, true, true) then return end

	local CurrentSkill = character:GetAttribute("CurrentSkill")
	local CurrentWeapon = character:GetAttribute("CurrentWeapon")


	character:SetAttribute("SkillActive", true)
	character:SetAttribute("Fire", true)

	ServerSkillModule.stopAnimations(humanoid)
	--ServerCombatModule.ChangeCombo(character)

	humanoid.WalkSpeed = 7
	humanoid.JumpHeight = 0

	local skillClone = ReplicatedStorage.Models.Skills[CurrentSkill]:Clone()
	local Hitbox = RaycastHitbox.new(skillClone)

	local Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local skillAnimation = ServerSkillModule.getSkillAnimation(character, CurrentSkill)
	local playskillAnimation = humanoid:LoadAnimation(skillAnimation)
	
	playskillAnimation:GetMarkerReachedSignal("HitStart"):Connect(function()
		--hitbox
		skillClone.Parent = workspace.Characters
		skillClone.CFrame = humanoidRootPart.CFrame * CFrame.new(0,0,-1) * CFrame.Angles(0,math.rad(0),0)
		ServerSkillModule.ShrinkPart(skillClone, -180, 2)
		Hitbox:HitStart()
		
	end)
	
	
	
	playskillAnimation:GetMarkerReachedSignal("HitEnd"):Connect(function()
		
		Debris:AddItem(skillClone, .1)
		Hitbox:HitStop()

		local SkillStats = SkillStatsModule.getStats(CurrentSkill)
		local swingReset = SkillStats.SwingReset

		character:SetAttribute("Fire", false)
		if character:GetAttribute("Combo") == MaxCombo then
			task.wait(1)
		else
			task.wait(swingReset)
		end
		character:SetAttribute("SkillActive", false)
	end)

	playskillAnimation.Stopped:Connect(function()
		if not character:GetAttribute("Fire") then
			humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
			humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight
		end
	end)

	playskillAnimation:Play()

	SoundsModule.PlaySound(WeaponSounds[CurrentWeapon].Combat.Swing, Torso)

	local hitAnimation = WeaponsAnimations[CurrentWeapon].Hit["Hit" .. character:GetAttribute("Combo")]
	HitServiceModule.Normal_HitboxHit(player, character, CurrentSkill , CurrentSkill, Hitbox, hitAnimation)
end)