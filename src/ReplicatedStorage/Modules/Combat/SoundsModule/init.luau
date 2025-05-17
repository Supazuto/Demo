local module = {}

function module.PlaySound(Sound, Parent)
    local sound = Sound:Clone()
    sound.PlayOnRemove = true
    sound.Parent = Parent

    sound:Destroy()
end

return module