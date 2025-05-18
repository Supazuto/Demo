--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

--Player
local player = game:GetService("Players").LocalPlayer
local character = player.Character

--Folder
local Events = ReplicatedStorage:WaitForChild("Events")

--Events
local combatEvent = Events:WaitForChild("Combat")

UserInputService.inputBegan:Connect(function(input, isTyping)
    if isTyping then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        combatEvent:FireServer("Swing")
    end
end)