local module = {}

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--Folder
local AnimationsFolder = ReplicatedStorage:WaitForChild("Animations")
local SkillsAnimations = AnimationsFolder:WaitForChild("Skills")

--Stuff
local lastUsed = {}

function module.getSkillAnimation(character, skillName)
    local skill = character:GetAttribute("Fire")
    local currentAnimation = SkillsAnimations:WaitForChild(skillName)
	return currentAnimation
    
end

function module.stopAnimations(humanoid)
	for i, v in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
		if v.Name ~= "Idle" and v.Name ~= "Animation" then
			v:Stop()
		end
	end
end

function module.ShrinkPart(part, distance, duration)
	if not part or not part:IsA("BasePart") then
		warn("ShrinkModule: You must pass a valid BasePart.")
		return
	end

	distance = distance or -180 -- Move back by default 180 studs
	duration = duration or 1    -- Default animation duration

	local goal = {
		CFrame = part.CFrame * CFrame.new(0, 0, distance)
	}

	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(part, tweenInfo, goal)
	tween:Play()
end

return module