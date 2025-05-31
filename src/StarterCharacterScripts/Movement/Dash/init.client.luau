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
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--Instances
local Velocity = Instance.new("LinearVelocity", character.HumanoidRootPart)
local Attachment = Instance.new("Attachment", humanoidRootPart)


--Values
local DashSpeed = 50
local CoolDownTime = 1.5
local DashTrack = nil
local DashAnimation = nil
local isDashing = false
local debounce = false
local DashCooldown = false


local function DashCheck()
    return not character:GetAttribute("Attacking") and not character:GetAttribute("Stunned")

end

local function selectAnimation()
    if DashAnimation then DashAnimation:Stop() end
    if character:GetAttribute("Equipped") == true then
        DashTrack = ReplicatedStorage.Animations.Weapons[character:GetAttribute("CurrentWeapon")].Main.Sprint
    else
        DashTrack = ReplicatedStorage.Animations.Player.Main.Sprint
    end
    
    if character:GetAttribute("Sprinting") then
        DashAnimation = humanoid:LoadAnimation(DashTrack)
        DashTrack:Play()
    end
end

local function Dash(direction)
    if isDashing or DashCooldown then return end
    isDashing = true
	DashCooldown = true

	local dashAnim = ""
	local dashVelocity = Vector3.zero

	if direction == "Front" then
		dashVelocity = humanoidRootPart.CFrame.LookVector * DashSpeed
        print("Dashing Front")
		--dashAnim = "Front"
	elseif direction == "Left" then
		dashVelocity = -humanoidRootPart.CFrame.RightVector * DashSpeed
        print("Dashing Left")
		--dashAnim = "Left"
	elseif direction == "Right" then
		dashVelocity = humanoidRootPart.CFrame.RightVector * DashSpeed
        print("Dashing Right")
		-- dashAnim = "Right"
	elseif direction == "Back" then
		dashVelocity = -humanoidRootPart.CFrame.LookVector * DashSpeed
        print("Dashing Back")
		-- dashAnim = "Back"
    end
	-- Play the animation
	 --Animations["Dash" .. dashAnim]:Play()

	-- Apply the velocity
	local DashVelocity = Instance.new("BodyVelocity")
	DashVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
	DashVelocity.Velocity = dashVelocity
	DashVelocity.P = 9e9
	DashVelocity.Parent = humanoidRootPart

	-- Dash duration
	task.wait(0.4)

	-- Cleanup
	DashVelocity:Destroy()
	--Animations["Dash" .. dashAnim]:Stop()
	isDashing = false

	-- Start cooldown timer
	task.delay(CoolDownTime, function()
	DashCooldown = false

        end)
end

local function DashActive()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        Dash("Front")
    elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
        Dash("Left")
    elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
        Dash("Right")
    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
        Dash("Back")
    end
end

local function onKeyPress(key, isTyping)
    if isTyping then
        return
    end
    if key.KeyCode == Enum.KeyCode.E then
        DashActive()
    end
end

--Connections
UserInputService.InputBegan:Connect(onKeyPress)

