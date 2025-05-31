local module = {}

function module.CheckForStatus(echaracter, character,blockingdamge,CheckforBlocking)

    local stop = false
    if echaracter.Humanoid.Health <= 0 or echaracter:GetAttribute("iframes") then stop = true end

    return stop
end

function module.CheckForAttribute(character, attack, swing, stun, equipped, sprinting, dashing)
    local attacking = character:GetAttribute("Attacking")
    local swinging = character:GetAttribute("Swing")
    local stunned = character:GetAttribute("Stunned")
    local isEquipped = character:GetAttribute("Equipped")
    local isSprinting = character:GetAttribute("IsSprinting")
    local isDashing = character:GetAttribute("IsDashing")

    local stop = false

    if attacking and attack then stop = true end
    if swinging and swing then stop = true end
    if stunned and stun then stop = true end
    if sprinting and isSprinting then stop = true end
    if equipped and not isEquipped then stop = true end
    if dashing and isDashing then stop = true end
    
        return stop
    end

return module