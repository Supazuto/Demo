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
    }
}

function module.getStats(weapon)
    return info[weapon]
    
end

return module