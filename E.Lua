-- last crash script didn't work on better pc's. so I made it uhhhh better
local PART_COUNT = 100099999999999999999999899999999999999999998988887878776766565654554434342313132434356465768e99999999999999999999999999999 -- change this (999999999999999e999999999999999999999 for example)
local SPAWN_RADIUS = 100 

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

for i = 1, PART_COUNT do
    task.spawn(function()
        local part = Instance.new("Part")
        part.Size = Vector3.new(2,2,2)
        part.Anchored = false
        part.Position = root.Position + Vector3.new(
            math.random(-SPAWN_RADIUS, SPAWN_RADIUS),
            math.random(5, SPAWN_RADIUS),
            math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
        )
        part.Color = Color3.fromRGB(
            math.random(0,255),
            math.random(0,255),
            math.random(0,255)
        )
        part.Parent = workspace

        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0,100,0,50)
        billboard.AlwaysOnTop = true
        billboard.Parent = part

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.Text = "this is an easter egg, you cannot see this in game. so, hello script kiddies!"
        text.TextScaled = true
        text.TextColor3 = Color3.new(1,1,1)
        text.Parent = billboard
    end)
end
