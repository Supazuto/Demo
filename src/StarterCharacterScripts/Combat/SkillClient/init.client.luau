--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

--Player
local player = game:GetService("Players").LocalPlayer
local character = player.Character

--Folder
local Events = ReplicatedStorage:WaitForChild("Events")

--Events
local skillEvent = Events:WaitForChild("Skill")

UserInputService.inputBegan:Connect(function(input, isTyping)
    if isTyping then return end

    if input.KeyCode == Enum.KeyCode.F then
        skillEvent:FireServer("Fire")
    end
end)