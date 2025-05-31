--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

--Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

--Variables
local runSpeend = 18
local walkSpeed = StarterPlayer.CharacterWalkSpeed
local doubletapThreshold = 0.3


--Values
local SprintTrack = nil
local SpringAnimation = nil

local isSprinting = false
local debounce = false
local lastKeyPressTime = 0


local function canSpring()
    return not (character:GetAttribute("Stunned") or character:GetAttribute("Attacking"))
    
end

local function resetSpeedCheck()
    return not character:GetAttribute("Attacking") and not character:GetAttribute("Stunned")

end

local function selectAnimation()
    if SpringAnimation then SpringAnimation:Stop() end
    if character:GetAttribute("Equipped") == true then
        SprintTrack = ReplicatedStorage.Animations.Weapons[character:GetAttribute("CurrentWeapon")].Main.Sprint
    else
        SprintTrack = ReplicatedStorage.Animations.Player.Main.Sprint
    end
    
    if character:GetAttribute("Sprinting") then
        SpringAnimation = humanoid:LoadAnimation(SprintTrack)
        SpringAnimation:Play()
    end
end

local function toggleSpringState()
    if isSprinting and not debounce then
        debounce = true
        print("Not IsSprinting")

        if resetSpeedCheck() then humanoid.WalkSpeed = walkSpeed end
        TweenService:Create(
            camera,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {FieldOfView = 70}
        ):Play()
        isSprinting = false

        if SpringAnimation then SpringAnimation:Stop() end

        character:SetAttribute("Sprinting", false)

        task.wait(.5)
        debounce = false
    elseif not isSprinting and not debounce then
        print("IsSprinting")

        character:SetAttribute("Sprinting", true)
        humanoid.WalkSpeed = runSpeend
        TweenService:Create(
            camera,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {FieldOfView = 90}
        ):Play()
        isSprinting = true

        selectAnimation()
    end
    
end

local function onKeyPress(key, isTyping)
    if isTyping then
        return
    end
    if key.KeyCode == Enum.KeyCode.W then
        local currentTime = tick()
        if currentTime - lastKeyPressTime <= doubletapThreshold then
            --triggersprint
            toggleSpringState()
        end
        lastKeyPressTime = currentTime
    end
    
end

local function onKeyRelease(key, isTyping)
    if isTyping then
        return
    end
    if key.KeyCode == Enum.KeyCode.W and isSprinting then
            toggleSpringState()
    end
    
end

--Connections
UserInputService.InputBegan:Connect(onKeyPress)
UserInputService.InputEnded:Connect(onKeyRelease)

