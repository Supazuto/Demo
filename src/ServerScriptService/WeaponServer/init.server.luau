--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local Debirs = game:GetService("Debris")

--Folders
local Models = ReplicatedStorage.Models
local WeaponModels = Models:WaitForChild("Weapons")
local WeaponsWeld = script.Welds.Weapons
local Events = ReplicatedStorage:WaitForChild("Events")
local AnimationsFolder = ReplicatedStorage:WaitForChild("Animations")
local WeaponsAnimations = AnimationsFolder:WaitForChild("Weapons")
local WeaponsSound = SoundService:WaitForChild("SFX"):WaitForChild("Weapons")
local ReplicatedStorageModules = ReplicatedStorage:WaitForChild("Modules")
local ServerStorageModules = ServerStorage:WaitForChild("Modules")

--Events
local WeaponsEvent = Events:WaitForChild("WeaponEvent")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local HelpfulModule = require(ServerStorageModules.Other.Helpful)

--Object
local Welds = {}

--Animations
local EquippedAnimation = {}
local UnequippedAnimation = {}
local IdleAnimation = {}

--Values
local EquipDebounce = {}

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local torso = character:WaitForChild("UpperTorso")

		character:SetAttribute("Equipped", false)
		character:SetAttribute("CurrentWeapon", "NewDurandal")

		character:SetAttribute("Combo", 1)
		character:SetAttribute("Stunned", false)
		character:SetAttribute("Swing", false)
		character:SetAttribute("Attacking", false)

		character:SetAttribute("Fire", false)
		character:SetAttribute("SkillActive", false)
		character:SetAttribute("CurrentSkill", "AirSlash")

		--character.Parent = workspace.Characters

		local CurrentWeapon = character:GetAttribute("CurrentWeapon")

		local Weapon = WeaponModels[CurrentWeapon]:Clone()
		Weapon.Parent = character

		Welds[player] = WeaponsWeld[CurrentWeapon].IdleWeaponWeld:Clone()
		Welds[player].Parent = torso
		Welds[player].Part0 = torso
		Welds[player].Part1 = Weapon

	end)

	player.CharacterAppearanceLoaded:Connect(function(character)
		for i, v in pairs(character:GetDescendants()) do
			if v.Parent:IsA("Accessory") and v:IsA("Part") then
				v.CanTouch = false
				v.CanQuery = false
			end
		end

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
	local torso = character:WaitForChild("UpperTorso")
	local rightArm = character:WaitForChild("RH")

	local CurrentWeapon = character:GetAttribute("CurrentWeapon")


	if HelpfulModule.CheckForAttribute(character, false, true, true) then return end

	if action == "Equip/Unequip" and not character:GetAttribute("Equipped") and not EquipDebounce[player] then --equipping
		EquipDebounce[player] = true

		--Events.VFX:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat.Slash, character.Torso.CFrame, 3)

		SoundsModule.PlaySound(WeaponsSound[CurrentWeapon].Main.Equip, torso)

		IdleAnimation[player] = humanoid:LoadAnimation(WeaponsAnimations[CurrentWeapon].Main.Idle)
		EquippedAnimation[player] = humanoid:LoadAnimation(WeaponsAnimations[CurrentWeapon].Main.Equip)
		EquippedAnimation[player]:Play()

		EquippedAnimation[player]:GetMarkerReachedSignal("Weld"):Connect(function()

			Welds[player].Part0 = rightArm
			Welds[player].C1 = WeaponsWeld[CurrentWeapon].HoldingWeaponWeld.C1
		end)

		EquippedAnimation[player]:GetMarkerReachedSignal("Equipped"):Connect(function()

			IdleAnimation[player]:Play()
			character:SetAttribute("Equipped", true)
			EquipDebounce[player] = false
		end)

		EquippedAnimation[player].Stopped:Connect(function()
			if character:GetAttribute("Stunned") then
				Welds[player].Part0 = rightArm
				Welds[player].C1 = WeaponsWeld[CurrentWeapon].HoldingWeaponWeld.C1
				IdleAnimation[player]:Play()
				character:SetAttribute("Equipped", true)
				EquipDebounce[player] = false
			end     
		end)


	elseif action == "Equip/Unequip" and character:GetAttribute("Equipped") and not EquipDebounce[player]then  --unequipping
		EquipDebounce[player] = true

		SoundsModule.PlaySound(WeaponsSound[CurrentWeapon].Main.UnEquip, torso)

		IdleAnimation[player]:Stop()

		UnequippedAnimation[player] = humanoid:LoadAnimation(WeaponsAnimations[CurrentWeapon].Main.Unequip)
		UnequippedAnimation[player]:Play()

		UnequippedAnimation[player]:GetMarkerReachedSignal("Weld"):Connect(function()

			Welds[player].Part0 = torso
			Welds[player].C1 = WeaponsWeld[CurrentWeapon].IdleWeaponWeld.C1
		end)

		UnequippedAnimation[player]:GetMarkerReachedSignal("UnEquipped"):Connect(function()
			character:SetAttribute("Equipped", false)
			EquipDebounce[player] = false

			UnequippedAnimation[player].Stopped:Connect(function()
				if character:GetAttribute("Stunned") then
					Welds[player].Part0 = torso
					Welds[player].C1 = WeaponsWeld[CurrentWeapon].IdleWeaponWeld.C1
					character:SetAttribute("Equipped", false)
					EquipDebounce[player] = false
				end     
			end)
		end)
	end
end)