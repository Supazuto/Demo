--Settings
local DecreaseBlockingTime = 3
local DecreaseAmount = 2

--Tables
local connetionRunning = {}


local function onBlockingChanged(character)
    if character:GetAttribute("Blocking") > 0 and connetionRunning[character]  == nil then
        connetionRunning[character] = true

        local signalConnection = nil
        signalConnection = character:GetAttributeChangedSignal("Blocking"):Connect(function()
            onBlockingChanged(character)
            end)

        task.spawn(function()
            while character:GetAttriute("Blocking") > 0 do
                task.wait(1)
                for i, humanoids in character:GetChildren() do
                    if humanoids:IsA("Humanoid") then
                        local character = humanoids.Parent
                        if character then
                            local isBlocking = character:GetAttribute("Blocking")
                            local lastStopTime = character:GetAttribute("LastStopTime") or 0
                            local currentTime = tick()

                            if not isBlocking and currentTime - lastStopTime >= DecreaseBlockingTime then
                                character:SetAttribue("Blocking", math.max(character:GetAttribute("Blocking") - DecreaseAmount))
                            end

                        end
                    end
                end
                connetionRunning[character] = nil
                signalConnection:Disconnect()
            end
        end)
    end
end



game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:GetAttributeChangedSignal("Blocking"):Connect(function()
        
            onBlockingChanged(character)
        end)
    end)
end)

for i,v in workspace.Npcs do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
        v:GetAttributeChangedSignal("Blocking"):Connect(function()
            onBlockingChanged(v)
            
        end)
    end
end

workspace.Npcs.ChildAdded:Connect(function(child)
    if child:GetAttributeChangedSignal("Blocking") then
        child:GetAttributeChangedSignal("Blocking"):Connect(function()
            onBlockingChanged(child)
        end)
    end
end)