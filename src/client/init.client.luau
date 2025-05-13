local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("Hello world, from client!")
-- This is a client-side script that runs when the game starts.
local hotbar = require(ReplicatedStorage.Shared.Hotbar)
local item = hotbar.new()
        :setText("Sword")
        :setLabel("1")
        :setName("Sword")
        :bindToggleKey("One")