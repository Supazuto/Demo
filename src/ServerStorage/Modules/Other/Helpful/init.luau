local module = {}

function module.CheckForAttribute(character, attack, stun, equipped)
    local attacking = character:GetAttribute("Attacking")
    local stunned = character:GetAttribute("Stunned")
    local isEquipped = character:GetAttribute("Equipped")

    local stop = false

    if attacking and attack then stop = true end
    if stunned and stun then stop = true end
    if equipped ~= nil and not isEquipped then stop = true end
    
        return stop
    end

return module