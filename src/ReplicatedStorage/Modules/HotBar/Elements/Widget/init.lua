return function(item, Hotbar)
	local length = #Hotbar.container:GetChildren() - 1
	
	local holder = script.Holder:Clone()
	local widget = holder.Widget
	local padding = holder.Padding
	local button = widget.TextButton
	
	holder.Size = widget.Size + padding.Size
	holder.Parent = Hotbar.container
	holder.LayoutOrder = length
	
	button.Size = widget.Size
	
	if length == 0 then
		padding.Visible = false
		holder.Size = widget.Size
	end
	
	
	return holder, widget
end
