local module = {}

--services
local Debirs = game:GetService("Debris")

function module.EmitEffect(effect, cframe, destroyTime)
    local effect = effect:Clone()
    effect.Parent = workspace.VFX
    effect.CFrame = cframe

    for i, v in pairs(effect:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(v:GetAttribute("EmitCount"))
        end
    end

    Debirs:AddItem(effect, destroyTime)    
end

return module