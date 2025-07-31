local MinimizeMobile = {}

function MinimizeMobile.Create(props)
	local gui = props.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local sq = Instance.new("ImageButton", gui)
	sq.Size = UDim2.fromOffset(props.Size or 60, props.Size or 60)
	sq.Position = props.Position or UDim2.fromScale(0.5, 0.5)
	sq.AnchorPoint = Vector2.new(0.5, 0.5)
	sq.BackgroundColor3 = Color3.new(1, 1, 1)
	sq.BorderSizePixel = 0
	sq.AutoButtonColor = false
	sq.Image = "rbxassetid://" .. tostring(props.DecalId or 0)
	Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 10)

	local dragging, dragStart, startPos, moved = false, nil, nil, false
	local threshold = props.Threshold or 6

	sq.InputBegan:Connect(function(i)
		if i.UserInputType.Name == "MouseButton1" or i.UserInputType.Name == "Touch" then
			dragging, dragStart, startPos, moved = true, i.Position, sq.Position, false
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	sq.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType.Name == "MouseMovement" or i.UserInputType.Name == "Touch") then
			local delta = i.Position - dragStart
			if not moved and (math.abs(delta.X) > threshold or math.abs(delta.Y) > threshold) then moved = true end
			if moved then
				sq.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)

	sq.MouseButton1Click:Connect(function()
		if not moved and typeof(props.OnClick) == "function" then
			props.OnClick()
		end
	end)

	return sq
end

return MinimizeMobile