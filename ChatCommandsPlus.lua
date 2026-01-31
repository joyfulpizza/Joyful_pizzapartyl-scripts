--[[
Features implemented

Replace /n → new line

( ) #random [number] → random alphanumeric string

>impersonate

>translate ko/en/ja/je (stub ready)

/spd, /jp (with reset)

$mimic player / stop

!console

!execute

?toxic

?funnydadjokes

_sitdown on/off

_complaintsaboutnewchat

^math
]]--
-- Chat+ for NEW TextChatService( I hate roblox for this )
-- add more features because I'm sure im too lazy to add more

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local WalkSpeedDefault = 16
local JumpPowerDefault = 50

local mimicTarget = nil
local sitToggle = false

-- utilities
local function randomString(len)
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local s = ""
	for i = 1, len do
		local r = math.random(1, #chars)
		s ..= chars:sub(r, r)
	end
	return s
end

local function say(msg)
	TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

local toxicLines = {
	"EZ","kid","haha","LOLLLL",
	"bro is a kid lol","EZ KID HAHAHAHAHHA",
	"who asked? Lol","bro is NOT an adult fr"
}

local dadJokes = {
	"What is a united states bee? A USB",
	"What if a fly loses its wings? oh no! It's a walk!",
	"I used to hate facial hair, but then it grew on me.",
	"Why don’t skeletons fight each other? They don’t have the guts."
}

local complaintLines = {
	"Bro new chat sucks",
	"I hate new chat!",
	"Dude why did roblox lock chats"
}

-- TRANSLATION STUB (replace with real API if you want)
local function translate(text, lang)
	return "[Translated-"..lang.."]: "..text
end

-- handle outgoing
TextChatService.OnIncomingMessage = function(message)
	if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
		local txt = message.Text

		-- /n replacement
		txt = txt:gsub("/n", "\n")

		-- #random
		txt = txt:gsub("#random%s+(%d+)", function(n)
			return randomString(tonumber(n))
		end)

		-- >impersonate
		if txt:sub(1,12) == ">impersonate" then
			local _,_,plr,msg = txt:find(">impersonate%s+(%S+)%s+(.+)")
			if plr and msg then
				txt = "a.\n\n\n\n\n["..plr.."]: "..msg
			end
		end

		-- >translate
		if txt:sub(1,10) == ">translate" then
			local _,_,lang,msg = txt:find(">translate%s+(%S+)%s+(.+)")
			if lang and msg then
				txt = translate(msg, lang)
			end
		end

		-- /spd
		if txt:sub(1,4) == "/spd" then
			local arg = txt:sub(6)
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				if arg == "re" then
					hum.WalkSpeed = WalkSpeedDefault
				else
					hum.WalkSpeed = tonumber(arg) or hum.WalkSpeed
				end
			end
			return nil
		end

		-- /jp
		if txt:sub(1,3) == "/jp" then
			local arg = txt:sub(5)
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				if arg == "re" then
					hum.JumpPower = JumpPowerDefault
				else
					hum.JumpPower = tonumber(arg) or hum.JumpPower
				end
			end
			return nil
		end

		-- $mimic
		if txt:sub(1,6) == "$mimic" then
			local target = txt:sub(8)
			if target == "stop" then
				mimicTarget = nil
			else
				for _,p in ipairs(Players:GetPlayers()) do
					if p.Name:lower() == target:lower() then
						mimicTarget = p
					end
				end
			end
			return nil
		end

		-- !console
		if txt:sub(1,8) == "!console" then
			print(txt:sub(10))
			return nil
		end

		-- !execute
		if txt:sub(1,8) == "!execute" then
			local code = txt:sub(10)
			loadstring(code)()
			return nil
		end

		-- ?toxic
		if txt == "?toxic" then
			txt = toxicLines[math.random(#toxicLines)]
		end

		-- ?funnydadjokes
		if txt == "?funnydadjokes" then
			txt = dadJokes[math.random(#dadJokes)]
		end

		-- _sitdown
		if txt:sub(1,8) == "_sitdown" then
			local mode = txt:sub(10)
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				sitToggle = (mode == "on")
				hum.Sit = sitToggle
			end
			return nil
		end

		-- complaints
		if txt == "_complaintsaboutnewchat" then
			txt = complaintLines[math.random(#complaintLines)]
		end

		-- ^math
		if txt:sub(1,5) == "^math" then
			local expr = txt:sub(7)
			local result = loadstring("return "..expr)
			if result then
				txt = expr.." = "..tostring(result())
			end
		end

		message.Text = txt
	end

	-- mimic incoming
	if mimicTarget and message.TextSource and message.TextSource.UserId == mimicTarget.UserId then
		say(message.Text)
	end

	return message
end
