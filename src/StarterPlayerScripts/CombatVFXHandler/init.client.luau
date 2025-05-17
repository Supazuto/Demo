--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Folder
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")

--Modules
local CombatEffectsModule = require(ReplicatedStorage.Modules.Combat.EffectsModule)

Events.VFX.OnClientEvent:Connect(function(action, ...)
    if action == "CombatEffects" then
        local effect, cframe, destroyTime = ...

        CombatEffectsModule.EmitEffect(effect, cframe, destroyTime)
    end
    
end)