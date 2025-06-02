local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local WeaponSounds = SoundService:WaitForChild("SFX"):WaitForChild("Weapons")
local ReplicatedStorageModules = ReplicatedStorage:WaitForChild("Modules")
local ServerStorageModules = ServerStorage:WaitForChild("Modules")

local CombatEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Combat")
local VFX_Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("VFX")

local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local ServerCombatModule = require(ServerStorageModules.CombatModules)
local WeaponStatsModule = require(ServerStorageModules.Weapons.WeaponStats)
local StunHandler = require(ServerStorageModules.Other.StunHandlerV2)
local HelpfulModule = require(ServerStorageModules.Other.Helpful)
local SkillStatsModule = require(ServerStorageModules.Skills.SkillStats)

function module.TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 15)
	Creator_Tag.Parent = humanoid
end

function module.UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end

function module.CheckIfAlive(character)
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
	return humanoid and humanoid.Parent and humanoid.Health > 0 and rootPart and rootPart.Parent
end

function module.BodyVelocity(Parent, HumanoidRootPart, Knockback, stayTime)
	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
	BodyVelocity.P = 50000
	BodyVelocity.Velocity = HumanoidRootPart.CFrame.LookVector * Knockback
	BodyVelocity.Parent = Parent
	Debris:AddItem(BodyVelocity, stayTime)
end

function module.Normal_HitboxHit(player, character, weapon, skill, Hitbox, ...)
	local hitAnimation = ...
	Hitbox.OnHit:Connect(function(hit, eHumanoid)
		if eHumanoid and hit.Parent ~= character then
			local eCharacter = hit.Parent
			local eTorso = eCharacter:FindFirstChild("UpperTorso") or eCharacter:FindFirstChild("Torso")
			local eHumanoid = eCharacter:FindFirstChild("Humanoid")
			local eHumanoidRootPart = eCharacter:FindFirstChild("HumanoidRootPart")

			local WeaponStats = WeaponStatsModule.getStats(weapon) or SkillStatsModule.getStats(skill)
			local damage = WeaponStats.Damage
			local knockback = WeaponStats.Knockback
			local stunTime = WeaponStats.StunTime

			if HelpfulModule.CheckForStatus(eCharacter, character, damage, true) then return end

			module.UntagHumanoid(eHumanoid)
			module.TagHumanoid(eHumanoid, player)

			eHumanoid:TakeDamage(damage)

			ServerCombatModule.stopAnimations(eHumanoid)

			VFX_Event:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat["Hit-01"], hit.CFrame, .3)
			SoundsModule.PlaySound(WeaponSounds[weapon].Combat.hitSound, eTorso)

			eHumanoid.Animator:LoadAnimation(hitAnimation):Play()

			if character:GetAttribute("Combo") >= 3 then
				knockback = knockback * 5
			end

			module.BodyVelocity(eHumanoidRootPart, character.HumanoidRootPart, knockback, 0.2)

			StunHandler.Stun(eHumanoid, stunTime)
		end
	end)
end

return module
