
local MinimizeMobile = loadstring(game:HttpGet("https://raw.githubusercontent.com/zezhub/Library/refs/heads/main/source/MinimizeMobile.lua"))()

MinimizeMobile.Create({
	Size = 60,
	DecalId = 6075448477, -- (ou outro decal válido)
	OnClick = function()
		print(Window.config.Title)
	end
})