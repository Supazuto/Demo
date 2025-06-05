local module = {}

function module.Blocking(echaracter, damage)
    if echaracter:GetAttribute("Blocking") <= 100 then
        
        echaracter:SetAttribute("Blocking", echaracter:GetAttribute("Blocking") + damage)

        if echaracter:GetAttribute("Blocking") >= 100 then
            print("guard break")
        end
    end
    
end

return module