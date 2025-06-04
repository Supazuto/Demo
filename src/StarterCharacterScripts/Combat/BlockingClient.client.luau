--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")


--character
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--folders
local events = ReplicatedStorage:WaitForChild("Events")

--events
local blockingEvent = events:WaitForChild("Blocking")

--values
local debounce = false

local function startBlocking()
    debounce = true
    blockingEvent:FireServer("Blocking")
    task.wait(1)
    debounce = false
end

local function stopBlocking()
    blockingEvent:FireServer("UnBlocking")
end

UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end

    if input.KeyCode == Enum.KeyCode.G and not debounce then
        startBlocking()
    end
end)

UserInputService.InputEnded:Connect(function(input, isTyping)
    if isTyping then return end

    if input.KeyCode == Enum.KeyCode.G and not debounce then
        stopBlocking()
    end
end)