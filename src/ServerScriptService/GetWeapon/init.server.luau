
for i, parts in pairs(workspace:GetChildren()) do

    if parts:GetAttribute("GetWeapon") then
        
        parts.ProximityPrompt.Triggered:Connect(function(player)
            local stop = false

            for i, animations in pairs(player.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                if animations.Name == "Swing1" or animations.Name == "Swing2" or animations.Name == "Swing3" then
                    stop = true
                end
            end

            if player.Character:GetAttribute("Attacking") then stop = true end

            if stop then return end

            player.Character:SetAttribute("CurrentWeapon", parts:GetAttribute("GetWeapon"))
            
            
        end)

    end

end