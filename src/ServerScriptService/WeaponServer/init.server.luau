--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local Debirs = game:GetService("Debris")
local StarterPlayer = game:GetService("StarterPlayer")

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
local blockingEvent = Events:WaitForChild("Blocking")

--Modules
local SoundsModule = require(ReplicatedStorageModules.Combat.SoundsModule)
local HelpfulModule = require(ServerStorageModules.Other.Helpful)

--Object
local Welds = {}

--Animations
local EquippedAnimation = {}
local UnequippedAnimation = {}
local IdleAnimation = {}
local BlockingAnimation = {}

--Values
local EquipDebounce = {}


local function ChangeWeapon(player, character, torso)

	character:SetAttribute("Equipped", false)
	character:SetAttribute("Combo", 1)
	character:SetAttribute("Stunned", false)
	character:SetAttribute("Swing", false)
	character:SetAttribute("Attacking", false)
	character:SetAttribute("iframes", false)
	character:SetAttribute("isBlocking", false)
	character:SetAttribute("Blocking", 0)

	local CurrentWeapon = character:GetAttribute("CurrentWeapon")

	local Weapon = WeaponModels[CurrentWeapon]:Clone()
	Weapon.Parent = character

	Welds[player] = WeaponsWeld[CurrentWeapon].IdleWeaponWeld:Clone()
	Welds[player].Parent = torso
	Welds[player].Part0 = torso
	Welds[player].Part1 = Weapon

	if EquippedAnimation[player] then
		EquippedAnimation[player]:Stop()
	end
	if IdleAnimation[player] then
		IdleAnimation[player]:Stop()
	end
	if  UnequippedAnimation[player] then
		UnequippedAnimation[player]:Stop()
	end

	EquipDebounce[player] = false
	
end



Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local torso = character:WaitForChild("UpperTorso")

		
		character:SetAttribute("CurrentWeapon", "NewDurandal")

		character:SetAttribute("CurrentSkill", "AirSlash")
		character:SetAttribute("Fire", false)
		character:SetAttribute("SkillActive", false)

		

		--character.Parent = workspace.Characters

		ChangeWeapon(player, character, torso)

		character:GetAttributeChangedSignal("CurrentWeapon"):Connect(function()
			for i, weapons in pairs(WeaponModels:GetChildren()) do
				if character:FindFirstChild(weapons.Name) then
					character:FindFirstChild(weapons.Name):Destroy()
				end
			end

			ChangeWeapon(player, character, torso)
			
		end)

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


	if HelpfulModule.CheckForAttribute(character, false, true, true, nil, true) then return end

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

		character:SetAttribute("Equipped", false)

		SoundsModule.PlaySound(WeaponsSound[CurrentWeapon].Main.UnEquip, torso)

		IdleAnimation[player]:Stop()

		UnequippedAnimation[player] = humanoid:LoadAnimation(WeaponsAnimations[CurrentWeapon].Main.Unequip)
		UnequippedAnimation[player]:Play()

		UnequippedAnimation[player]:GetMarkerReachedSignal("Weld"):Connect(function()

			Welds[player].Part0 = torso
			Welds[player].C1 = WeaponsWeld[CurrentWeapon].IdleWeaponWeld.C1
		end)

		UnequippedAnimation[player]:GetMarkerReachedSignal("UnEquipped"):Connect(function()
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

blockingEvent.OnServerEvent:Connect(function(player, action)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	local torso = character:WaitForChild("UpperTorso")
	local rightArm = character:WaitForChild("RH")

	local CurrentWeapon = character:GetAttribute("CurrentWeapon")
	


	if HelpfulModule.CheckForAttribute(character, false, true, true, true) then return end

	if action == "Blocking"  then --equipping

		--Events.VFX:FireAllClients("CombatEffects", ReplicatedStorage.Effects.Combat.Slash, character.Torso.CFrame, 3)

		SoundsModule.PlaySound(WeaponsSound[CurrentWeapon].Blocking.BlockingStart, torso)

		BlockingAnimation[player] = humanoid:LoadAnimation(WeaponsAnimations[CurrentWeapon].Blocking.Blocking)
		BlockingAnimation[player]:Play()

		character:SetAttribute("isBlocking", true)
		humanoid.WalkSpeed = 4
		humanoid.JumpHeight = 0

	elseif action == "UnBlocking" and character:GetAttribute("isBlocking") then  --unequipping

		SoundsModule.PlaySound(WeaponsSound[CurrentWeapon].Blocking.BlockingStop, torso)
		BlockingAnimation[player]:Stop()

		character:SetAttribute("isBlocking", false)
		humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
		humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight


end

end)