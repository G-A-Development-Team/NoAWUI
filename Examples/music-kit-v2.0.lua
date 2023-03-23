e,f = string.char,math.random
s,t,u,v,w,x,cu = string.char,math.random,globals.TickCount(),globals.RealTime(),globals.CurTime(),globals.FrameTime(),cheat.GetUserID()
-------------
-- Visuals --
-------------
file.Write("\\Cache/CustomObject.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/custom-object.lua"))
LoadScript("\\Cache/CustomObject.lua")
file.Write("\\Cache/Renderer.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/Renderer.lua"))
LoadScript("\\Cache/Renderer.lua")

-- Create the visuals for the script
RunScript("WinForm/winform.lua")

Form:ChangePictureBox("Main", "pbKitPreview","", "png")


---------------
-- Variables --
---------------
-- Grab the current domain being used by this script
local domain = http.Get("https://raw.githubusercontent.com/G-A-Development-Team/libs/main/mkc_domain")
	  domain = 'http://agentsix1.net/aw/new/'

-- Loading the sorted music kit list from the server
kits_sorted = http.Get('https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/music_kits.json')
kits = json.decode(kits_sorted)['kits']['kits']

-- Loading the detailed version of the music kit from the server
kit_details = http.Get('https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/kit_details.json')
kits_details = json.decode(kit_details)['details']


---------------
-- Load Data --
---------------
-- Populate the Changer Drop Down Box
-- Grab the drop down box
local plbChanger = getControlByName("Main", "plbChanger")

-- Loop through all the kits
for i = 1, table.getn(kits), 1 do
	-- Add the kit to the plbChanger
	plbChanger.AddItem("png," .. kits_details[kits[i]]['img'], kits[i])
end


-----------
-- Users --
-----------

local id = 0
function e(c)
	local a = ""
	for b = 1, c do
		a = a .. s(t(97, 122))
	end
	return a
end
local v = 0

function d(g)
	return v .. e(g) .. v
end
function f()
	g = v+u+v+w
	return g
end

local exists = false
-- Creates the gateam.dat
file.Enumerate(function(c)
		if c == 'mkc_gateam.dat' then
			v = v + f()
			exists = true
		end
	end)

-- if it does not exists it creates it. Otherwise it loads the data
if not exists then
	b = math.random(10000, 99999)
	v = v + f()
	h = d(32) .. '.' .. cu;
	file.Write("mkc_gateam.dat", h)
	id = h
	http.Get(domain .. 'createuser.php?id='.. id)
else
	id = file.Read("mkc_gateam.dat", "r")
end

exists = false
-- Checks if the queue file has been created
file.Enumerate(function(c)
		if c == 'mkc_queue.dat' then
			exists = true
		end
	end)
if not exists then
	h = ''
	file.Write("mkc_queue.dat", h)
end

local setkits = true
queue_tick = 100
queue_last = 0
local pcb_lastselected = 0
callbacks.Register("Draw", function()
   -- Shared checkbox listener
   --[[if gui_shared_value ~= gui_shared:GetValue() then
        gui_shared_value = gui_shared:GetValue()
        gui_shared_Changed();
    end]]--
	
	lp = entities.GetLocalPlayer()
	
	if lp ~= nil then
		if setkits == true then
			setkits = false	   -- Set Kits
			getSteamIDs()
			getAWUsers()
	    end
	   -- Change kit if needed
		if plbChanger.ChangedStatus then
			plbChanger.ChangedStatus = false
			if (lp ~= nil) then
				lp_data = client.GetPlayerInfo(lp:GetIndex())
				kitid = kits_details[kits[plbChanger.SelectedIndex]]['id']
				steamid = lp_data['SteamID']
				url = domain
				url = url .. 'setkitv2.php?id='
				url = url .. id
				url = url .. '&steamid='
				url = url .. steamid
				url = url .. '&kit='
				url = url .. kitid
				http.Get(url,  function(data)
									print(kits[plbChanger.SelectedIndex] .. ": " .. kitid)
									entities.GetPlayerResources():SetPropInt(kitid, "m_nMusicID", lp:GetIndex())
								end)
				
			end
		end
	end
end)

-- Function for retrieving a player via a steamid32 string
function getPlayerBySteamID(steamid)
	local players = entities.FindByClass("CCSPlayer")
	for i = 1, #players do
		local player = players[i]
		if player:GetName() ~= "GOTV" then
			data = client.GetPlayerInfo(player:GetIndex())
			if tostring(data['SteamID']) == steamid then
				return player
			end
		end
	end
end

local objPlayers = '{}' -- Json Object
objPlayers = json.decode(objPlayers)
-- objPlayers[SteamID32]['name'] --> String --> client.GetPlayerInfo(index)['Name']
-- objPlayers[SteamID32]['aw'] --> Boolean
-- objPlayers[SteamID32]['kit'] --> Integer


-- Function for taking all users in game and placing them into a readable form with details needed
function getSteamIDs()
	local players = entities.FindByClass("CCSPlayer")
	for i = 1, #players do
		player = players[i]
		if player:GetName() ~= "GOTV" then
			data = client.GetPlayerInfo(player:GetIndex())
			steamid = tostring(data['SteamID'])
			objPlayers[steamid] = {}
			objPlayers[steamid]['name'] = player:GetName()
			
		end
	end
end

-- Function for getting others who are ingame with you kits
function getAWUsers()
	lp = entities.GetLocalPlayer()
	lp_data = client.GetPlayerInfo(lp:GetIndex())
	steamid = lp_data['SteamID']
	-- Create request url
	local get = domain .. 'getkitv3.php?id=' .. id .. '&steamid=' .. steamid .. '&request='
	local steamids = ''
	-- Steamids to request format
	for k,v in pairs(objPlayers) do
		if steamids == '' then
			steamids = k
		else
			steamids = steamids .. ',' .. k
		end		
	end	-- Send web request for kits 'NA' means not a user
	http.Get(get .. steamids, function (data)
	
		print(data)
		if request == 'Nope' then return false end
		players = json.decode(data)
		for k,v in pairs(players) do
			if v == "NA" then
				-- Set aw value and music kit id if non aw user
				if string.len(k) > 4 then
					local player = getPlayerBySteamID(k)
					if player ~= nil then
						objPlayers[k]['aw'] = 'false'
						
						objPlayers[k]['kit'] = entities.GetPlayerResources():GetPropInt("m_nMusicID", player:GetIndex())
					end
				end
			else
				if string.len(k) > 4 then
					-- Set aw value music kit value
					objPlayers[k]['aw'] = 'true'
					objPlayers[k]['kit'] = v
					local player = getPlayerBySteamID(k)
					if player ~= nil then
						pdata = client.GetPlayerInfo(player:GetIndex())
						psteam = pdata['SteamID']
						entities.GetPlayerResources():SetPropInt(v, "m_nMusicID", player:GetIndex())
					end
				end
			end
		end
		
	end)
end



client.AllowListener("round_start")

callbacks.Register("FireGameEvent", function(e)
	--if gui_shared:GetValue() then
		if e == nil then return end
		if e:GetName() ~= "round_start" then
			return
		end
		setkits = true
	--end
end)