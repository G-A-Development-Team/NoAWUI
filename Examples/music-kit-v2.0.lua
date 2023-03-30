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
RunScript("WinForm/main.lua")

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

kits_unsorted_get = http.Get('https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/kits_unsorted.json')
kits_unsorted = json.decode(kits_unsorted_get)['kits']

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

--------------------
-- Create Manager --
--------------------
--
-- flTogglePlayers.Children = {} Clears all children
--
-- Get the Toggle Players Control
local flTogglePlayers = getControlByName("Main", "flTogglePlayers")
--
-- Load the attributes to an array
local jsonatts = GetMultipleAttributesFromFile("WinForm/Design/tManager.Flowlayout.Child.design.txt")
	
-- Split the array into objects
local dcplPanel = GetAttributesFromArrayByName(jsonatts, "flplManager_")
local dcchkToggle = GetAttributesFromArrayByName(jsonatts, "flchkmToggle_")
local dcpbAvatar = GetAttributesFromArrayByName(jsonatts, "flpbmAvatar_")
local dcpbKit = GetAttributesFromArrayByName(jsonatts, "flpbmKit_")
local dctxtName = GetAttributesFromArrayByName(jsonatts, "fltxtmName_")
local dctxtKit = GetAttributesFromArrayByName(jsonatts, "fltxtmKit_")

local chkManager = json.decode('{}')
chkManager['count'] = 0

function Form:chkToggle_Changed(box)
	local toggle = getControlByName("Main", "flchkmToggle_" .. box)
	print(tostring(toggle.CheckState) .. box)
end

function setManagerData()
	local chkManager_temp = json.decode('{}')
	local steamidslist = {}
	--flTogglePlayers.Clear()
	local lp_event = entities.GetLocalPlayer()
	
	-- checks if the lp is not nil
	if lp_event ~= nil then
		lp_data = client.GetPlayerInfo(lp_event:GetIndex())
		-- Create an empty array we will use to get players avatars
		local avatar_array = {}
		
		-- Gets the full list of players in the game
		local players = entities.FindByClass("CCSPlayer")
		
		-- Cycles through the entire list of players in the server
		for i = 1, #players do
		
			-- Sets the variable player to the player
			player = players[i]
			
			-- Gets the player info of the current player
			data = client.GetPlayerInfo(player:GetIndex())
			
			-- Ensures we arent gonna be including the lp in this array
			if data['SteamID'] ~= lp_data['SteamID'] then
				-- Ensures we aren't grabbing GOTV
				if player:GetName() ~= "GOTV" then
					
					-- This makes sure we aren't selecting any of the bots
					if data['SteamID'] >= 5000 then
						-- Setting the value steamid32 to the value of the players steamid
						local steamid32 = tostring(data['SteamID'])
						
						table.insert(steamidslist, steamid32)
						
						-- Checks if we have added this user in the past
						if chkManager[steamid32] == nil then
							-- We are adding to the array the information for the steamid32 and kitid
							chkManager[steamid32] = {}
							chkManager[steamid32]['steamid32'] = steamid32
							chkManager[steamid32]['kitid'] = entities.GetPlayerResources():GetPropInt("m_nMusicID", players[i]:GetIndex())
							TablePrint(chkManager[steamid32])
							-- We are adding the players steamid32 to an array for grabbing their avatar
							table.insert(avatar_array, steamid32)
						end
					end
				end
			end
		end
		
		-- We are setting the url for grabbing the avatar
		local url = domain .. 'getavatar.php?id=' .. id .. '&json=' .. json.encode(avatar_array)
		-- We are taking the url and getting the information back to process it
		local httpreturn = http.Get(url)
			-- Taking the returned  text value from the website and adding it to a json
			httpreturn = json.decode(httpreturn)
			
			-- With the avatar data we are going to update the players chkManager data
			for _, v in pairs(avatar_array) do
				-- v = the players steamid32
				v = tostring(v)
				-- Adding avatar and steamid64 to the chkmanager json
				chkManager[v]['avatar'] = httpreturn[v]['avatar']
				chkManager[v]['steamid64'] = httpreturn[v]['steamid64']
			end	
			
			-- Cycles through the entire list of players in the server
			for i = 1, #players do
			
				-- Sets the variable player to the player
				player = players[i]
				
				-- Gets the player info of the current player
				data = client.GetPlayerInfo(player:GetIndex())
				
				-- Ensures we arent gonna be including the lp in this array
				if data['SteamID'] ~= lp_data['SteamID'] then
				
					-- Ensures we aren't grabbing GOTV
					if player:GetName() ~= "GOTV" then
						
						-- This makes sure we aren't selecting any of the bots
						if data['SteamID'] >= 5000 then
							
							-- Setting the value steamid32 to the value of the players steamid
							local steamid32 = tostring(data['SteamID'])
							
							if chkManager[steamid32]['plPanel'] == nil then
								print(steamid32)
								chkManager['count'] = chkManager['count'] + 1
								
								-- Set the panels to the default save value
								plPanel = deepcopy(dcplPanel)
								chkToggle = deepcopy(dcchkToggle)
								pbAvatar = deepcopy(dcpbAvatar)
								pbKit = deepcopy(dcpbKit)
								txtName = deepcopy(dctxtName)
								txtKit = deepcopy(dctxtKit)
								
								-- Add the id to the name of the object and create the panel
								plPanel['name'] = plPanel['name'] .. chkManager['count']
								local panel = CreatePanel(plPanel)
								
								-- add the id to the name and parent of the object and create the Picture Box
								pbAvatar['name'] = pbAvatar['name'] .. chkManager['count']
								pbAvatar['parent'] = pbAvatar['parent'] .. chkManager['count']
								pbAvatar['imageurl'] = 'jpg,' .. chkManager[steamid32]['avatar']
								panel.Children[#panel.Children+1] = CreatePictureBox(pbAvatar)
								
								-- add the id to the name and parent of the object and create the Picture Box
								pbKit['name'] = pbKit['name'] .. chkManager['count']
								pbKit['parent'] = pbKit['parent'] .. chkManager['count']
								pbKit['imageurl'] = 'png,' .. kits_details[kits_unsorted[entities.GetPlayerResources():GetPropInt("m_nMusicID", player:GetIndex())]]['img']
								panel.Children[#panel.Children+1] = CreatePictureBox(pbKit)
								
								-- add the id to the name and parent of the object and create the Checkbox
								chkToggle['name'] = chkToggle['name'] .. chkManager['count']
								chkToggle['parent'] = chkToggle['parent'] .. chkManager['count']
								chkToggle['mouseclick'] = str_replace(chkToggle['mouseclick'], "_id_", chkManager['count'])
								panel.Children[#panel.Children+1] = CreateCheckbox(chkToggle)
								
								-- add the id to the name and parent of the object and create the Label
								txtKit['name'] = txtKit['name'] .. chkManager['count']
								txtKit['parent'] = txtKit['parent'] .. chkManager['count']
								txtKit['text'] = kits_unsorted[entities.GetPlayerResources():GetPropInt("m_nMusicID", player:GetIndex())]
								panel.Children[#panel.Children+1] = CreateLabel(txtKit)
								
								-- add the id to the name and parent of the object and create the Label
								txtName['name'] = txtName['name'] .. chkManager['count']
								txtName['parent'] = txtName['parent'] .. chkManager['count']
								txtName['text'] = player:GetName()
								panel.Children[#panel.Children+1] = CreateLabel(txtName)
								
								-- add all the objects to the panels and complete the process
								flTogglePlayers.AddItem(panel)

								-- Set the gui objects to the json
								chkManager[steamid32]['plPanel'] = getControlByName('Main', 'flplManager_' .. chkManager['count'])
								chkManager[steamid32]['chkToggle'] = getControlByName('Main', 'flchkmToggle_' .. chkManager['count'])
								chkManager[steamid32]['pbAvatar'] = getControlByName('Main', 'flpbmAvatar_' .. chkManager['count'])
								chkManager[steamid32]['pbKit'] = getControlByName('Main', 'flpbmKit_' .. chkManager['count'])
								chkManager[steamid32]['txtName'] = getControlByName('Main', 'fltxtmName_' .. chkManager['count'])
								chkManager[steamid32]['txtKit'] = getControlByName('Main', 'fltxtmKit_' .. chkManager['count'])
								
							end
						end
					end
				end
			end	
		
		local chopping_block = json.decode('{}')
		for index, obj in ipairs(flTogglePlayers.Children) do
			if obj.Type == 'panel' then
				chopping_block[obj.Name] = {}
				chopping_block[obj.Name]['name'] = obj.Name
				chopping_block[obj.Name]['index'] = index
			end
		end
		for _, steamid_temp in ipairs(steamidslist) do
			for index, chop_item in pairs(chopping_block) do
				if chkManager[steamid_temp]['plPanel'].Name == chop_item['name'] then
					chopping_block[chop_item['name']] = {}
				end
			end
		end

		for name, obj in pairs(chopping_block) do
			if obj['index'] ~= nil then
				flTogglePlayers.RemoveItem(obj['index'])
			end
		end
		
		--  cycle through steamid list. add the chkmanager objects to temp. set checkmanager to temp
	end
end

setManagerData()


local setkits = true
queue_tick = 100
queue_last = 0
local pcb_lastselected = 0
callbacks.Register("Draw", "Default_Execution", function()
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

local objPlayers = json.decode('{}') -- Json Object

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
		--setkits = true
	--end
end)

callbacks.Register("Draw", function()
	
	
end)


callbacks.Register("Unload", function()
    UnloadScript("WinForm/main.lua")
    UnloadScript("WinForm/libs/api/Misc.lua")
    UnloadScript("WinForm/libs/api/manipulation.lua")
    UnloadScript("WinForm/libs/api/Logger.lua")
    UnloadScript("WinForm/libs/api/Theme.lua")
    UnloadScript("WinForm/libs/api/Renderer.lua")
    UnloadScript("WinForm/Controls.lua")
end)