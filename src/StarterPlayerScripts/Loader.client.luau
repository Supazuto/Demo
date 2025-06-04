local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local allAnimations = {}

task.wait()

for i, animation in pairs(ReplicatedStorage:WaitForChild("Animations"):GetChildren()) do
    if animation:IsA("Animation") then
        table.insert(allAnimations, animation)
    end
end

ContentProvider:PreloadAsync(allAnimations)