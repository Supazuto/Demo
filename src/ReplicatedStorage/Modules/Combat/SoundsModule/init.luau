local module = {}

local Debris = game:GetService("Debris")

function module.PlaySound(Sound, Parent)
    local sound = Sound:Clone()
    sound.Parent = Parent
    sound:Play()

    Debris:AddItem(sound, 2)
end

return module