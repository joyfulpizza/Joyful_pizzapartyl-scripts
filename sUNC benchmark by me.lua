-- made by me(joyful_pizzapartyl)

local envs = {
    _G,
    getgenv and getgenv() or nil,
    getrenv and getrenv() or nil
}

local function find(path)
    for _, env in pairs(envs) do
        if env then
            local current = env
            local ok = true

            for part in string.gmatch(path, "[^%.]+") do
                local success, value = pcall(function()
                    return current[part]
                end)

                if success and value ~= nil then
                    current = value
                else
                    ok = false
                    break
                end
            end

            if ok then
                return current
            end
        end
    end
    return nil
end

local tests = {

-- cores
{
name = "loadstring",
test = function()
    local f = find("loadstring")
    if not f then return false end
    local fn = f("return 5")
    return fn and fn() == 5
end
},

{
name = "getgenv",
test = function()
    return type(find("getgenv")) == "function"
end
},

{
name = "getrenv",
test = function()
    return type(find("getrenv")) == "function"
end
},

-- hooker
{
name = "hookfunction",
test = function()
    local hook = find("hookfunction")
    if not hook then return false end
    local a = function() return 1 end
    local b = hook(a, function() return 2 end)
    return a() == 2
end
},

{
name = "newcclosure",
test = function()
    return type(find("newcclosure")) == "function"
end
},

-- meta
{
name = "getrawmetatable",
test = function()
    return type(find("getrawmetatable")) == "function"
end
},

{
name = "setrawmetatable",
test = function()
    return type(find("setrawmetatable")) == "function"
end
},

-- most useless, caller(i dont use this a lot)
{
name = "checkcaller",
test = function()
    return type(find("checkcaller")) == "function"
end
},

{
name = "islclosure",
test = function()
    return type(find("islclosure")) == "function"
end
},

{
name = "iscclosure",
test = function()
    return type(find("iscclosure")) == "function"
end
},

-- https
{
name = "request",
test = function()
    return type(find("request") or find("http_request") or (find("syn") and find("syn").request)) == "function"
end
},

-- clipboards
{
name = "setclipboard",
test = function()
    return type(find("setclipboard")) == "function"
end
},

-- I hate drawing fr
{
name = "Drawing",
test = function()
    local D = find("Drawing")
    if not D then return false end
    local ok, obj = pcall(function()
        return D.new("Line")
    end)
    return ok and obj ~= nil
end
},

-- syn(not synapse)
{
name = "syn namespace",
test = function()
    return type(find("syn")) == "table"
end
},

{
name = "syn.protect_gui",
test = function()
    local s = find("syn")
    return s and type(s.protect_gui) == "function"
end
},

{
name = "syn.queue_on_teleport",
test = function()
    local s = find("syn")
    return s and type(s.queue_on_teleport) == "function"
end
},

{
name = "identifyexecutor",
test = function()
    local id = find("identifyexecutor")
    if not id then return false end
    local ok, name = pcall(id)
    return ok and name ~= nil
end
},

-- touch
{
name = "firetouchinterest",
test = function()
    return type(find("firetouchinterest")) == "function"
end
},

-- NC
{
name = "getnamecallmethod",
test = function()
    return type(find("getnamecallmethod")) == "function"
end
},

{
name = "setnamecallmethod",
test = function()
    return type(find("setnamecallmethod")) == "function"
end
}

}

local supported = 0
local failed = 0
local total = #tests

print("Running FULL sUNC benchmark...\n")

for _, t in ipairs(tests) do
    local ok, result = pcall(t.test)

    if ok and result then
        supported += 1
        print("(passed :D): " .. t.name)
    else
        failed += 1
        print("(not supported :c): " .. t.name)
    end
end

print("\nYour executor got:")
print("-===============-")
print("Supported: " .. supported .. " out of " .. total)
print("Failed: " .. failed)
print("follow @cloey_alt12(knifest2)!"
local percent = math.floor((supported/total)*100)
print("Compatibility: " .. percent .. "%")

-- grade(idk.. ive never seen s tier. im pretty sure they are either xeno, or paid.)
if percent >= 90 then
    print("Grade: S (Top-tier executor)")
elseif percent >= 75 then
    print("Grade: A (are you using delta?)")
elseif percent >= 60 then
    print("Grade: B (...what...")
elseif percent >= 40 then
    print("Grade: C (idk you need a new executor.")
else
    print("Grade: D / Limited support.(get a new executor nub)")
end
