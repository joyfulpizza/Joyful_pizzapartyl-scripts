--// SimpleAdminUI Library
--// Made by joyful_pizzapartyl

local SimpleAdminUI = {}

-------------------------------------------------
-- SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-------------------------------------------------
-- EXECUTOR DETECTION
-------------------------------------------------
function SimpleAdminUI:GetExecutor()
	local exec = "Unknown"

	pcall(function()
		if identifyexecutor then
			exec = identifyexecutor()
		elseif getexecutorname then
			exec = getexecutorname()
		elseif _G.DELTA_EXECUTOR then
			exec = "Delta"
		elseif _G.CodeX then
			exec = "CodeX"
		elseif _G.PunkX then
			exec = "Punk X"
		elseif _G.SOLARA_LOADED then
			exec = "Solara"
		elseif _G.XENO_LOADED then
			exec = "Xeno"
		elseif _G.SELIWARE_LOADED then
			exec = "Seliware"
		end
	end)

	return exec
end

-------------------------------------------------
-- LOADING SCREEN
-------------------------------------------------
function SimpleAdminUI:BootScreen(config)
	config = config or {}
	local delayTime = config.Delay or 0.5

	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "SimpleAdmin_Loading"
	loadingGui.ResetOnSpawn = false
	loadingGui.Parent = player.PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1,1)
	frame.BackgroundColor3 = Color3.new(0,0,0)
	frame.BorderSizePixel = 0
	frame.Parent = loadingGui

	local text = Instance.new("TextLabel")
	text.BackgroundTransparency = 1
	text.Size = UDim2.new(1, -40, 0, 40)
	text.Position = UDim2.fromScale(0.5, 0.5)
	text.AnchorPoint = Vector2.new(0.5, 0.5)
	text.Font = Enum.Font.Code
	text.TextSize = 16
	text.TextColor3 = Color3.new(1,1,1)
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.Text = ""
	text.Parent = frame

	task.wait(delayTime)

	local function typeText(msg, speed)
		text.Text = ""
		for i = 1, #msg do
			text.Text = msg:sub(1, i)
			task.wait(speed)
		end
	end

	local function deleteText(speed)
		for i = #text.Text, 0, -1 do
			text.Text = text.Text:sub(1, i)
			task.wait(speed)
		end
	end

	local msg1 =
		'[Simpleadmin.joyful_pizzapartyl/enjoyedplayer("' .. player.Name .. '")]'

	typeText(msg1, 0.03)
	task.wait(0.15)
	deleteText(0.02)

	local executor = self:GetExecutor()
	local msg2 =
		"File.executorname//" .. executor .. "...[IsSupported = True]"

	typeText(msg2, 0.03)
	task.wait(1)

	TweenService:Create(frame, TweenInfo.new(0.6), {
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(text, TweenInfo.new(0.6), {
		TextTransparency = 1
	}):Play()

	task.wait(0.6)
	loadingGui:Destroy()
end

-------------------------------------------------
-- WINDOW CREATION
-------------------------------------------------
function SimpleAdminUI:CreateWindow(options)
	options = options or {}

	local gui = Instance.new("ScreenGui")
	gui.Name = options.Name or "SimpleAdmin_Window"
	gui.ResetOnSpawn = false
	gui.Parent = player.PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = options.Size or UDim2.fromOffset(320, 230)
	frame.Position = options.Position or UDim2.fromScale(0.05, 0.28)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	frame.Parent = gui

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(220,220,220)
	stroke.Transparency = 0.5
	stroke.Parent = frame

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12,12,12)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45,45,45))
	}
	grad.Rotation = 90
	grad.Parent = frame

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(12, 8)
	title.Size = UDim2.new(1, -24, 0, 22)
	title.Text = options.Title or "Made.by = joyful_pizzapartyl :: user"
	title.Font = Enum.Font.Code
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = Color3.fromRGB(240,240,240)
	title.Parent = frame

	local subtitle = Instance.new("TextLabel")
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.fromOffset(12, 32)
	subtitle.Size = UDim2.new(1, -24, 0, 18)
	subtitle.Text =
		options.Subtitle
		or string.format("[ user::%s | id::%d ]", player.Name, player.UserId)
	subtitle.Font = Enum.Font.Code
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextColor3 = Color3.fromRGB(255,210,80)
	subtitle.Parent = frame

	return {
		Gui = gui,
		Frame = frame,
		NextY = 64
	}
end

-------------------------------------------------
-- BUTTON
-------------------------------------------------
function SimpleAdminUI:AddButton(window, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -28, 0, 36)
	btn.Position = UDim2.fromOffset(14, window.NextY)
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(212,175,55)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = window.Frame

	window.NextY += 46

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,30))
	}
	g.Parent = btn

	task.spawn(function()
		while btn.Parent do
			TweenService:Create(g, TweenInfo.new(1.1), {Rotation = 180}):Play()
			task.wait(1.1)
			TweenService:Create(g, TweenInfo.new(1.1), {Rotation = 0}):Play()
			task.wait(1.1)
		end
	end)

	if callback then
		btn.MouseButton1Click:Connect(callback)
	end

	return btn
end

-------------------------------------------------
return SimpleAdminUI
