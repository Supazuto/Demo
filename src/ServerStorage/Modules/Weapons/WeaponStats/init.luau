local module = {}

local info = {
    ["Durandal"] = {
        Damage = 10,
        Knockback = 10,
        SwingReset = .1,
        StunTime = 1,
    },
    ["NewDurandal"] = {
        Damage = 10,
        Knockback = 10,
        SwingReset = .1,
        StunTime = 1,
        BlockingWalkspeed = 5,
    },
    ["LUHOPE"] = {
        Damage = 20,
        Knockback = 25,
        SwingReset = .2,
        StunTime = 1.5,
        BlockingWalkspeed = 5,
    }
}

function module.getStats(weapon)
    return info[weapon]
    
end

return module