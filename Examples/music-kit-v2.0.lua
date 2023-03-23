file.Write("\\Cache/CustomObject.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/custom-object.lua"))
LoadScript("\\Cache/CustomObject.lua")
file.Write("\\Cache/Renderer.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/Renderer.lua"))
LoadScript("\\Cache/Renderer.lua")

-- Create the visuals for the script
RunScript("WinForm/winform.lua")

Form:ChangePictureBox("Main", "pbKitPreview","https://static.wikia.nocookie.net/cswikia/images/7/7b/Csgo-musickit-matt_lange_01.png/revision/latest?cb=20150213193222", "png")

-- Grab the current domain being used by this script
local domain = http.Get("https://raw.githubusercontent.com/G-A-Development-Team/libs/main/mkc_domain")
	  domain = 'http://agentsix1.net/aw/new/'

-- Loading the sorted music kit list from the server
local kits_sorted = http.Get('https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/music_kits.json')
local kits = json.decode(kits_sorted)['kits']['kits']

-- Loading teh detailed version of the music kit from the server
local kit_details = http.Get('https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/kit_details.json')
local kits_details = json.decode(kit_details)['details']

-- Populate the Changer Drop Down Box

-- Grab the drop down box
local sender = getControlByName("Main", "plbChanger")
TablePrint(kits)
for i = 1, table.getn(kits), 1 do
	-- Add the item
	TablePrint(kits_details[kits[i]])
    sender.AddItem("png," .. kits_details[kits[i]]['img'], kits[i])
end