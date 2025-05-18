--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--Folder
local Events = ReplicatedStorage:WaitForChild("Events")

--Events
local WeaponEvent = Events:WaitForChild("WeaponEvent")
print("Hello world, from client!!")
-- This is a client-side script that runs when the game starts.
local hotbar = require(ReplicatedStorage.Modules.HotBar)
local item = hotbar.new()
        :setText("Sword")
        :setLabel("q")
        :setName("Sword")
        :bindToggleKey("Q")

local function selected()
        print("Selected")
        WeaponEvent:FireServer("Equip/Unequip")
end
item:bindEvent("selected", selected)

local function deselected()
        print("Deselected")
        WeaponEvent:FireServer("Equip/Unequip")
        
end
item:bindEvent("deselected", deselected)
