
-- PLATFORM RIDE + INFINITE RING WORLD (PLS DONT MOVE FOR 3 SECONDS, MADY BY JOYFUL_PIZZAPARTYL)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- SETTINGS
local FAR_OFFSET = Vector3.new(0, 500, 0)
local TILE_SIZE = 50
local LOAD_RADIUS = 3
local LOAD_DELAY = 0.05

-- LIGHTING
Lighting.Brightness = 3
Lighting.ClockTime = 14
Lighting.Ambient = Color3.fromRGB(120,120,120)
Lighting.OutdoorAmbient = Color3.fromRGB(180,180,180)

-- diddy
local world = Instance.new("Folder")
world.Name = "ClientWorld"
world.Parent = workspace

local loadedTiles = {}
local WORLD_Y

-- best part, TOUCH SOME GRASS
local function createGround(origin)
	local ground = Instance.new("Part")
	ground.Size = Vector3.new(TILE_SIZE, 1, TILE_SIZE)
	ground.Position = origin
	ground.Anchored = true
	ground.Material = Enum.Material.Grass
	ground.Color = Color3.fromRGB(60,180,75)
	ground.Parent = world
end

local function createTrees(origin)
	local treeCount = math.random(1,4)
	for i = 1, treeCount do
		local ox = math.random(-20,20)
		local oz = math.random(-20,20)

		local trunk = Instance.new("Part")
		trunk.Size = Vector3.new(2,12,2)
		trunk.Anchored = true
		trunk.Material = Enum.Material.Wood
		trunk.Color = Color3.fromRGB(102,51,0)
		trunk.Position = origin + Vector3.new(ox, 6.5, oz)
		trunk.Parent = world

		local leaves = Instance.new("Part")
		leaves.Shape = Enum.PartType.Ball
		leaves.Size = Vector3.new(12,12,12)
		leaves.Anchored = true
		leaves.Material = Enum.Material.Grass
		leaves.Color = Color3.fromRGB(40,200,60)
		leaves.Position = trunk.Position + Vector3.new(0,9,0)
		leaves.Parent = world
	end
end

local function generateTile(tileX, tileZ)
	local key = tileX .. "," .. tileZ
	if loadedTiles[key] then return end
	loadedTiles[key] = true

	local origin = Vector3.new(
		tileX * TILE_SIZE,
		WORLD_Y,
		tileZ * TILE_SIZE
	)

	createGround(origin)
	createTrees(origin)
end

-- lets play minecraft
local function loadRings(cx, cz)
	for r = 1, LOAD_RADIUS do -- start at 1 (center already exists)
		for x = -r, r do
			for z = -r, r do
				if math.abs(x) == r or math.abs(z) == r then
					generateTile(cx + x, cz + z)
					task.wait(LOAD_DELAY)
				end
			end
		end
	end
end

-- hah
local function platformRide(character)
	local root = character:WaitForChild("HumanoidRootPart")

	-- SAFETY FLOOR
	local safety = Instance.new("Part")
	safety.Size = Vector3.new(20, 1, 20)
	safety.Anchored = true
	safety.Transparency = 1
	safety.CanCollide = true
	safety.Parent = workspace

	-- Elevator
	local platform = Instance.new("Part")
	platform.Size = Vector3.new(5,1,5)
	platform.Anchored = true
	platform.Material = Enum.Material.Metal
	platform.Position = root.Position - Vector3.new(0,3,0)
	platform.Parent = workspace

	local lastPos = platform.Position
	local followConn = RunService.RenderStepped:Connect(function()
		local delta = platform.Position - lastPos
		root.CFrame = root.CFrame + delta
		lastPos = platform.Position
	end)

	-- Lift
	TweenService:Create(
		platform,
		TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{Position = platform.Position + Vector3.new(0,10,0)}
	):Play()
	task.wait(3)

	-- Fly far
	local farPos = platform.Position + FAR_OFFSET
	TweenService:Create(
		platform,
		TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{Position = farPos}
	):Play()
	task.wait(6)

	followConn:Disconnect()
	platform:Destroy()

	-- WORLD HEIGHT
	WORLD_Y = farPos.Y - 3
	safety.Position = Vector3.new(farPos.X, WORLD_Y, farPos.Z)

	-- INSTANT CENTER TILE (NO DELAY)
	local tileX = math.floor(farPos.X / TILE_SIZE)
	local tileZ = math.floor(farPos.Z / TILE_SIZE)
	generateTile(tileX, tileZ)

	-- REMOVE SAFETY AFTER CONFIRM
	task.delay(0.2, function()
		safety:Destroy()
	end)

	-- START RING LOADING
	task.spawn(loadRings, tileX, tileZ)
end

-- INFINITE TRACKIN
local lastTileX, lastTileZ

RunService.Heartbeat:Connect(function()
	if not WORLD_Y then return end
	if not player.Character then return end

	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local tileX = math.floor(root.Position.X / TILE_SIZE)
	local tileZ = math.floor(root.Position.Z / TILE_SIZE)

	if tileX ~= lastTileX or tileZ ~= lastTileZ then
		lastTileX = tileX
		lastTileZ = tileZ
		task.spawn(loadRings, tileX, tileZ)
	end
end)

-- local Hello = Vector3.new local player.character then Hello.ride
if player.Character then
	platformRide(player.Character)
end
player.CharacterAdded:Connect(platformRide)
