return function(item, Hotbar)
	local length = #Hotbar.container:GetChildren() - 1
	
	if length > 0 then
		local padding = script.Padding:Clone()
		padding.Parent = Hotbar.container
		padding.LayoutOrder = length 
		length += 1
	end
	
	local widget = script.Widget:Clone()
	widget.Parent = Hotbar.container
	widget.LayoutOrder = length
	
	return widget
end
