return function(Hotbar)

	local bar = script.Hotbar:Clone()
	local player = game:GetService("Players").LocalPlayer
	bar.Parent = player.PlayerGui
	bar.DisplayOrder = Hotbar.baseDisplayOrder
	
	Hotbar.baseDisplayOrderChanged:Connect(function()
		bar.DisplayOrder = Hotbar.baseDisplayOrder
	end)
	
	local container = bar.Container

	return container
end
