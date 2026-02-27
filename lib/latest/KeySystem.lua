local lib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local HTTPBIN_URL = "https://httpbin.org/headers"
local DEFAULT_TITLE = "Key System"
local DEFAULT_VERSION = "v1.0"
local DEFAULT_CHANGELOG = "None"
local DEFAULT_DISCORD = ""
local DEFAULT_ENDPOINT = ""

local theme = {
	Accent = Color3.fromRGB(72, 138, 182),
	AcrylicMain = Color3.fromRGB(30, 30, 30),
	AcrylicBorder = Color3.fromRGB(60, 60, 60),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(15, 15, 15)),
	Element = Color3.fromRGB(70, 70, 70),
	InElementBorder = Color3.fromRGB(55, 55, 55),
}

local function copyToClipboard(text)
	if setclipboard then setclipboard(text) end
end

local function getFingerprint()
	local success, result = pcall(function()
		local response = HttpService:GetAsync(HTTPBIN_URL)
		local data = HttpService:JSONDecode(response)
		for header, value in pairs(data.headers or {}) do
			if header:lower():find("fingerprint") then
				return value
			end
		end
		return (data.headers and data.headers["User-Agent"]) or tostring(player.UserId)
	end)
	if success and result then
		return result
	else
		return tostring(player.UserId)
	end
end

function lib:CreatePanel(config)
	config = config or {}
	local titleText = config.Title or DEFAULT_TITLE
	local versionText = config.Version or DEFAULT_VERSION
	local changelogText = config.ChangeLog or DEFAULT_CHANGELOG
	local discordLink = config.Discord or DEFAULT_DISCORD
	local endpoint = config.Endpoint or DEFAULT_ENDPOINT
	local callback = config.Callback
	local verifyEndpoint = endpoint .. "/api/verify"

	local gui = Instance.new("ScreenGui")
	gui.Name = "KeySystemUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")
	gui.IgnoreGuiInset = true

	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting

	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	background.BackgroundTransparency = 0.15
	background.Parent = gui

	local bgGradient = Instance.new("UIGradient")
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
	})
	bgGradient.Rotation = 45
	bgGradient.Parent = background

	local particles = Instance.new("Frame")
	particles.Size = UDim2.fromScale(1, 1)
	particles.BackgroundTransparency = 1
	particles.Parent = gui
	for i = 1, 30 do
		local star = Instance.new("Frame")
		star.Size = UDim2.fromOffset(math.random(1, 2), math.random(1, 2))
		star.Position = UDim2.fromScale(math.random(), math.random())
		star.AnchorPoint = Vector2.new(0.5, 0.5)
		star.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
		star.BackgroundTransparency = 0.6 + math.random() * 0.4
		star.Parent = particles
		local tweenInfo = TweenInfo.new(math.random(4, 7), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
		local goal = {BackgroundTransparency = 0.1}
		TweenService:Create(star, tweenInfo, goal):Play()
	end

	local main = Instance.new("Frame")
	main.Name = "MainPanel"
	main.Size = UDim2.fromOffset(0, 0)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = theme.AcrylicMain
	main.BackgroundTransparency = 0.1
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = gui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 20)
	mainCorner.Parent = main

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Thickness = 1
	mainStroke.Color = theme.AcrylicBorder
	mainStroke.Transparency = 0.6
	mainStroke.Parent = main

	local mainGradient = Instance.new("UIGradient")
	mainGradient.Color = theme.AcrylicGradient
	mainGradient.Rotation = 90
	mainGradient.Parent = main

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 45)
	title.Position = UDim2.fromScale(0, 0.1)
	title.BackgroundTransparency = 1
	title.Text = "WHITELIST ACCESS"
	title.TextColor3 = Color3.fromRGB(250, 250, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 26
	title.TextStrokeTransparency = 0.8
	title.Parent = main

	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0, 0, 22)
	subtitle.Position = UDim2.fromScale(0, 0.26)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "ENTER YOUR KEY TO CONTINUE"
	subtitle.TextColor3 = Color3.fromRGB(180, 180, 190)
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 14
	subtitle.TextTransparency = 0.2
	subtitle.Parent = main

	local input = Instance.new("TextBox")
	input.Size = UDim2.fromOffset(380, 48)
	input.Position = UDim2.fromScale(0.5, 0.48)
	input.AnchorPoint = Vector2.new(0.5, 0.5)
	input.BackgroundColor3 = theme.Element
	input.BackgroundTransparency = 0.2
	input.PlaceholderText = "Your key..."
	input.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
	input.Text = ""
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.Font = Enum.Font.Gotham
	input.TextSize = 20
	input.ClearTextOnFocus = false
	input.Parent = main

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 14)
	inputCorner.Parent = input

	local inputStroke = Instance.new("UIStroke")
	inputStroke.Thickness = 1
	inputStroke.Color = theme.InElementBorder
	inputStroke.Transparency = 0.6
	inputStroke.Parent = input

	local buttonContainer = Instance.new("Frame")
	buttonContainer.Size = UDim2.fromOffset(420, 55)
	buttonContainer.Position = UDim2.fromScale(0.5, 0.72)
	buttonContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = main

	local verifyBtn = Instance.new("TextButton")
	verifyBtn.Name = "VerifyButton"
	verifyBtn.Size = UDim2.fromOffset(200, 50)
	verifyBtn.Position = UDim2.fromScale(0.25, 0.5)
	verifyBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	verifyBtn.BackgroundColor3 = theme.Element
	verifyBtn.Text = "VERIFY"
	verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	verifyBtn.Font = Enum.Font.GothamBold
	verifyBtn.TextSize = 22
	verifyBtn.AutoButtonColor = false
	verifyBtn.Parent = buttonContainer

	local verifyCorner = Instance.new("UICorner")
	verifyCorner.CornerRadius = UDim.new(0, 25)
	verifyCorner.Parent = verifyBtn

	local verifyStroke = Instance.new("UIStroke")
	verifyStroke.Thickness = 1.5
	verifyStroke.Color = theme.InElementBorder
	verifyStroke.Transparency = 0.5
	verifyStroke.Parent = verifyBtn

	local verifyGradient = Instance.new("UIGradient")
	verifyGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, theme.Element),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
	})
	verifyGradient.Rotation = 90
	verifyGradient.Parent = verifyBtn

	local getKeyBtn = Instance.new("TextButton")
	getKeyBtn.Name = "GetKeyButton"
	getKeyBtn.Size = UDim2.fromOffset(180, 50)
	getKeyBtn.Position = UDim2.fromScale(0.75, 0.5)
	getKeyBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	getKeyBtn.BackgroundColor3 = theme.Element
	getKeyBtn.Text = "GET KEY"
	getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	getKeyBtn.Font = Enum.Font.GothamBold
	getKeyBtn.TextSize = 20
	getKeyBtn.AutoButtonColor = false
	getKeyBtn.Parent = buttonContainer

	local getKeyCorner = Instance.new("UICorner")
	getKeyCorner.CornerRadius = UDim.new(0, 25)
	getKeyCorner.Parent = getKeyBtn

	local getKeyStroke = Instance.new("UIStroke")
	getKeyStroke.Thickness = 1.5
	getKeyStroke.Color = theme.InElementBorder
	getKeyStroke.Transparency = 0.5
	getKeyStroke.Parent = getKeyBtn

	local getKeyGradient = Instance.new("UIGradient")
	getKeyGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, theme.Element),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
	})
	getKeyGradient.Rotation = 90
	getKeyGradient.Parent = getKeyBtn

	local footer = Instance.new("TextLabel")
	footer.Size = UDim2.new(1, 0, 0, 30)
	footer.Position = UDim2.fromScale(0, 0.9)
	footer.BackgroundTransparency = 1
	footer.Text = titleText
	footer.TextColor3 = Color3.fromRGB(150, 150, 160)
	footer.Font = Enum.Font.Gotham
	footer.TextSize = 14
	footer.TextTransparency = 0.4
	footer.Parent = main

	local changelog = Instance.new("Frame")
	changelog.Name = "ChangelogPanel"
	changelog.Size = UDim2.fromOffset(0, 0)
	changelog.Position = UDim2.fromScale(0.5, 0.5)
	changelog.AnchorPoint = Vector2.new(0.5, 0.5)
	changelog.BackgroundColor3 = theme.AcrylicMain
	changelog.BackgroundTransparency = 0.1
	changelog.BorderSizePixel = 0
	changelog.ClipsDescendants = true
	changelog.Parent = gui

	local changelogCorner = Instance.new("UICorner")
	changelogCorner.CornerRadius = UDim.new(0, 20)
	changelogCorner.Parent = changelog

	local changelogStroke = Instance.new("UIStroke")
	changelogStroke.Thickness = 1
	changelogStroke.Color = theme.AcrylicBorder
	changelogStroke.Transparency = 0.6
	changelogStroke.Parent = changelog

	local changelogGradient = Instance.new("UIGradient")
	changelogGradient.Color = theme.AcrylicGradient
	changelogGradient.Rotation = 90
	changelogGradient.Parent = changelog

	local versionLabel = Instance.new("TextLabel")
	versionLabel.Size = UDim2.new(1, 0, 0, 35)
	versionLabel.Position = UDim2.fromScale(0.5, 0.08)
	versionLabel.AnchorPoint = Vector2.new(0.5, 0)
	versionLabel.BackgroundTransparency = 1
	versionLabel.Text = versionText
	versionLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
	versionLabel.Font = Enum.Font.GothamBold
	versionLabel.TextSize = 24
	versionLabel.Parent = changelog

	local changelogTitle = Instance.new("TextLabel")
	changelogTitle.Size = UDim2.new(1, 0, 0, 25)
	changelogTitle.Position = UDim2.fromScale(0.5, 0.2)
	changelogTitle.AnchorPoint = Vector2.new(0.5, 0)
	changelogTitle.BackgroundTransparency = 1
	changelogTitle.Text = "📋 What's New"
	changelogTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
	changelogTitle.Font = Enum.Font.Gotham
	changelogTitle.TextSize = 16
	changelogTitle.TextTransparency = 0.2
	changelogTitle.Parent = changelog

	local changesScroller = Instance.new("ScrollingFrame")
	changesScroller.Size = UDim2.new(1, -20, 0, 140)
	changesScroller.Position = UDim2.fromScale(0.5, 0.28)
	changesScroller.AnchorPoint = Vector2.new(0.5, 0)
	changesScroller.BackgroundTransparency = 1
	changesScroller.BorderSizePixel = 0
	changesScroller.ScrollBarThickness = 4
	changesScroller.ScrollBarImageColor3 = theme.AcrylicBorder
	changesScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	changesScroller.Parent = changelog

	local changesList = Instance.new("TextLabel")
	changesList.Size = UDim2.new(1, -10, 0, 120)
	changesList.Position = UDim2.fromScale(0.5, 0)
	changesList.AnchorPoint = Vector2.new(0.5, 0)
	changesList.BackgroundTransparency = 1
	changesList.Text = changelogText
	changesList.TextColor3 = Color3.fromRGB(200, 200, 210)
	changesList.Font = Enum.Font.Gotham
	changesList.TextSize = 15
	changesList.TextXAlignment = Enum.TextXAlignment.Center
	changesList.TextYAlignment = Enum.TextYAlignment.Top
	changesList.RichText = true
	changesList.Parent = changesScroller
	changesScroller.CanvasSize = UDim2.new(0, 0, 0, changesList.TextBounds.Y + 10)

	local discordBtn = Instance.new("ImageButton")
	discordBtn.Size = UDim2.fromOffset(32, 32)
	discordBtn.Position = UDim2.fromScale(0.5, 0.85)
	discordBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	discordBtn.BackgroundTransparency = 1
	discordBtn.Image = "rbxassetid://4483345998"
	discordBtn.ImageColor3 = theme.Accent
	discordBtn.Parent = changelog

	local discordLabel = Instance.new("TextLabel")
	discordLabel.Size = UDim2.new(1, 0, 0, 20)
	discordLabel.Position = UDim2.fromScale(0.5, 0.93)
	discordLabel.AnchorPoint = Vector2.new(0.5, 0)
	discordLabel.BackgroundTransparency = 1
	discordLabel.Text = "Join Discord"
	discordLabel.TextColor3 = theme.Accent
	discordLabel.Font = Enum.Font.Gotham
	discordLabel.TextSize = 12
	discordLabel.Parent = changelog

	local gap = 20
	local mainHalf = 520/2
	local changelogHalf = 260/2
	main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(changelogHalf + gap/2, 0)
	changelog.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(mainHalf + gap/2, 0)

	blur.Size = 0
	TweenService:Create(blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 10}):Play()
	main.Size = UDim2.fromOffset(0, 0)
	changelog.Size = UDim2.fromOffset(0, 0)
	main.BackgroundTransparency = 1
	changelog.BackgroundTransparency = 1
	TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(520, 360)}):Play()
	TweenService:Create(main, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(changelog, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(260, 360)}):Play()
	TweenService:Create(changelog, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()

	local function buttonHover(btn, stroke, originalSize, hoverSize)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = hoverSize, BackgroundColor3 = Color3.fromRGB(85, 85, 95)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = originalSize, BackgroundColor3 = theme.Element}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
		end)
	end
	buttonHover(verifyBtn, verifyStroke, UDim2.fromOffset(200, 50), UDim2.fromOffset(210, 54))
	buttonHover(getKeyBtn, getKeyStroke, UDim2.fromOffset(180, 50), UDim2.fromOffset(190, 54))

	discordBtn.MouseEnter:Connect(function()
		TweenService:Create(discordBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(36, 36)}):Play()
	end)
	discordBtn.MouseLeave:Connect(function()
		TweenService:Create(discordBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(32, 32)}):Play()
	end)

	local function buttonClickFeedback(btn, originalText, callback)
		btn.MouseButton1Click:Connect(function()
			local oldText = btn.Text
			btn.Text = "COPIED!"
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Accent}):Play()
			callback()
			task.wait(0.8)
			TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = theme.Element}):Play()
			btn.Text = oldText
		end)
	end

	if discordLink ~= "" then
		local fullDiscordLink = discordLink:match("^https?://") and discordLink or ("https://discord.gg/" .. discordLink)
		buttonClickFeedback(getKeyBtn, getKeyBtn.Text, function() copyToClipboard(fullDiscordLink) end)
		discordBtn.MouseButton1Click:Connect(function()
			local oldColor = discordBtn.ImageColor3
			discordBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
			TweenService:Create(discordBtn, TweenInfo.new(0.15), {Size = UDim2.fromOffset(38, 38)}):Play()
			copyToClipboard(fullDiscordLink)
			task.wait(0.3)
			TweenService:Create(discordBtn, TweenInfo.new(0.3), {Size = UDim2.fromOffset(32, 32), ImageColor3 = oldColor}):Play()
			local oldLabel = discordLabel.Text
			discordLabel.Text = "COPIED!"
			task.wait(0.8)
			discordLabel.Text = oldLabel
		end)
	else
		getKeyBtn.Visible = false
		discordBtn.Visible = false
		discordLabel.Visible = false
	end

	local isLoading = false
	local function setLoading(state)
		isLoading = state
		if state then
			TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 110)}):Play()
			verifyBtn.Text = "VERIFYING..."
		else
			TweenService:Create(verifyBtn, TweenInfo.new(0.3), {BackgroundColor3 = theme.Element}):Play()
			verifyBtn.Text = "VERIFY"
		end
	end

	local function callAPI(payload)
		local success, result = pcall(function()
			local body = HttpService:JSONEncode(payload)
			local response = HttpService:PostAsync(verifyEndpoint, body, Enum.HttpContentType.ApplicationJson)
			return HttpService:JSONDecode(response)
		end)
		if success and result then return result else return {success = false, error = "Connection error"} end
	end

	local function checkExistingKey()
		local fingerprint = getFingerprint()
		return callAPI({identifier = fingerprint})
	end

	local function validateKey(key)
		local fingerprint = getFingerprint()
		return callAPI({key = key, identifier = fingerprint})
	end

	local function fadeOutElements(panel)
		for _, child in ipairs(panel:GetChildren()) do
			if child:IsA("GuiObject") and child ~= panel then
				TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1, ImageTransparency = 1, BackgroundTransparency = 1}):Play()
			end
		end
	end

	local function exitAnimation(cb)
		fadeOutElements(main)
		fadeOutElements(changelog)
		task.wait(0.3)
		TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(520, 0)}):Play()
		TweenService:Create(changelog, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(260, 0)}):Play()
		task.wait(0.4)
		TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
		TweenService:Create(changelog, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
		TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0}):Play()
		task.wait(0.3)
		gui:Destroy()
		blur:Destroy()
		if cb then
			task.spawn(cb)
		end
	end

	local function successFeedback(key)
		TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 130, 90)}):Play()
		TweenService:Create(verifyGradient, TweenInfo.new(0.2), {Color = ColorSequence.new(Color3.fromRGB(60, 130, 90))}):Play()
		verifyBtn.Text = "GRANTED"
		player:SetAttribute("SavedWhitelistKey", key)
		task.wait(0.5)
		exitAnimation(callback)
	end

	local function errorFeedback(message)
		TweenService:Create(verifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 70, 70)}):Play()
		TweenService:Create(verifyGradient, TweenInfo.new(0.15), {Color = ColorSequence.new(Color3.fromRGB(160, 70, 70))}):Play()
		verifyBtn.Text = message or "INVALID"
		task.wait(0.3)
		TweenService:Create(verifyBtn, TweenInfo.new(0.3), {BackgroundColor3 = theme.Element}):Play()
		TweenService:Create(verifyGradient, TweenInfo.new(0.3), {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.Element),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
			})
		}):Play()
		verifyBtn.Text = "VERIFY"
	end

	verifyBtn.MouseButton1Click:Connect(function()
		if isLoading or endpoint == "" then
			if endpoint == "" then errorFeedback("NO API") end
			return
		end
		local key = input.Text:gsub("^%s+", ""):gsub("%s+$", "")
		if key == "" then errorFeedback("EMPTY") return end
		setLoading(true)
		task.spawn(function()
			local result = validateKey(key)
			setLoading(false)
			if result and result.success then
				successFeedback(key)
			else
				errorFeedback(result and result.error or "ERROR")
			end
		end)
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == Enum.KeyCode.Return and not isLoading and endpoint ~= "" then
			verifyBtn.MouseButton1Click:Fire()
		end
	end)

	if endpoint ~= "" then
		task.spawn(function()
			local result = checkExistingKey()
			if result and result.success then
				local savedKey = result.key
				input.Text = savedKey
				task.wait(0.6)
				successFeedback(savedKey)
			else
				local saved = player:GetAttribute("SavedWhitelistKey")
				if saved then
					input.Text = saved
					task.wait(0.6)
					local res = validateKey(saved)
					if res and res.success then
						successFeedback(saved)
					else
						input.Text = ""
						player:SetAttribute("SavedWhitelistKey", nil)
					end
				end
			end
		end)
	end

	TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.4}):Play()
	TweenService:Create(changelogStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.4}):Play()

	return {
		Destroy = function()
			gui:Destroy()
			blur:Destroy()
		end
	}
end

return lib
