--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--Folder
local Events = ReplicatedStorage:WaitForChild("Events")

--Events
local WeaponEvent = Events:WaitForChild("WeaponEvent")
local SkillEvent = Events:WaitForChild("Skill")
print("Hello world, from client!!")
-- This is a client-side script that runs when the game starts.
--Modules
local hotbar = require(ReplicatedStorage.Modules.HotBar)

--function
local function toggled()
	print("Toggled")
	WeaponEvent:FireServer("Equip/Unequip")
end


--Items
local item = hotbar.new()
	:setText("Sword")
	:setLabel("1")
	:setName("Sword")
	:bindToggleKey("E")



item:bindEvent("toggled", toggled)