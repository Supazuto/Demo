local module = {}

local info = {
    ["AirSlash"] = {
        Damage = 35,
        Knockback = 25,
        SwingReset = .8,
        StunTime = 2,
        ExtraInfo = {}
    },
}

function module.getStats(skill)
    return info[skill]
    
end

return module