--[[
hi skids welcome to my script
☆ made by joyful_pizzapartyl ☆
I bet you are gonna use chatgpt to fix it and post it on your page
well I have a detector that detects that and breaks itself..
]]--
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Executor services (may not exist in all executors)
local VIM = game:GetService("VirtualInputManager")
local VU = game:GetService("VirtualUser")


local gui = Instance.new("ScreenGui")
gui.Name = "AutoClickerGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", frame)
UIListLayout.Padding = UDim.new(0, 6)

local function createLabel(text, size)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, size or 30)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.SourceSans
	lbl.Text = text
	lbl.Parent = frame
	return lbl
end

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSans
	btn.Text = text
	btn.Parent = frame
	return btn
end


createLabel("enter click per second..",25)

local cpsBox = Instance.new("TextBox")
cpsBox.Size = UDim2.new(1, -10, 0, 35)
cpsBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
cpsBox.TextColor3 = Color3.new(1,1,1)
cpsBox.TextScaled = true
cpsBox.Font = Enum.Font.SourceSans
cpsBox.PlaceholderText = "e.g. 10"
cpsBox.Text = ""
cpsBox.Parent = frame


local selectedButton = "MouseButton1"

local buttonDropdown = createButton("mousebutton1 (right)")

buttonDropdown.MouseButton1Click:Connect(function()
	if selectedButton == "MouseButton1" then
		selectedButton = "MouseButton2"
		buttonDropdown.Text = "mousebutton2 (left)"
	else
		selectedButton = "MouseButton1"
		buttonDropdown.Text = "mousebutton1 (right)"
	end
end)


local selectedMethod = "VIM"

local methodDropdown = createButton("VirtualInputManager (default, recommended)")

methodDropdown.MouseButton1Click:Connect(function()
	if selectedMethod == "VIM" then
		selectedMethod = "VU"
		methodDropdown.Text = "VirtualUser (doesnt support most clicking games)"
	else
		selectedMethod = "VIM"
		methodDropdown.Text = "VirtualInputManager (default, recommended)"
	end
end)


createLabel("you need executor that supports VirtualInputManager to use it.",40)
createLabel("click on mousebutton1 to change to mousebutton2(left)",20)
createLabel("click on virtualinputmanager to switch to virtualuser",20)

local clicking = false
local toggleBtn = createButton("autoclick: OFF")

toggleBtn.MouseButton1Click:Connect(function()
	clicking = not clicking
	toggleBtn.Text = "autoclick: " .. (clicking and "ON" or "OFF")
end)


createLabel("made by joyful_pizzapartyl",25)


task.spawn(function()
	while true do
		if clicking then
			local cps = tonumber(cpsBox.Text) or 1
			if cps < 1 then cps = 1 end
			local delayTime = 1 / cps

			if selectedMethod == "VIM" and VIM then
				VIM:SendMouseButtonEvent(0, 0,
					selectedButton == "MouseButton1" and 0 or 1,
					true, game, 0)
				VIM:SendMouseButtonEvent(0, 0,
					selectedButton == "MouseButton1" and 0 or 1,
					false, game, 0)

			elseif selectedMethod == "VU" and VU then
				VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				VU:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end

			task.wait(delayTime)
		else
			task.wait()
		end
	end
end)
