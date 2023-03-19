file.Write("\\Cache/CustomObject.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/custom-object.lua"))
LoadScript("\\Cache/CustomObject.lua")
file.Write("\\Cache/Renderer.lua", http.Get("https://raw.githubusercontent.com/G-A-Development-Team/SharedMusicKitChanger/main/Renderer.lua"))
LoadScript("\\Cache/Renderer.lua")

RunScript("WinForm/winform.lua")

Form:ChangePictureBox("Main", "KitPreview","https://static.wikia.nocookie.net/cswikia/images/7/7b/Csgo-musickit-matt_lange_01.png/revision/latest?cb=20150213193222", "png")


local managelist = getControlByName("Main", "Tab2_flowlayout")
    
	-- Load the attributes to an array
	local jsonatts = GetMultipleAttributesFromFile("WinForm/json.txt")
	
	-- Split the array into objects
	local plPanel = GetAttributesFromArrayByName(jsonatts, "flowlayout_panel_")
	local chkToggle = GetAttributesFromArrayByName(jsonatts, "flowlayout_child1_check_")
	local pbAvatar = GetAttributesFromArrayByName(jsonatts, "flowlayout_child1_avatar_")
	local pbKit = GetAttributesFromArrayByName(jsonatts, "flowlayout_child1_kit_")
	local txtName = GetAttributesFromArrayByName(jsonatts, "flowlayout_child1_name_")
	local txtKit = GetAttributesFromArrayByName(jsonatts, "flowlayout_child1_kitname_")
	
	-- Save the object arrays as strings because lua is retarded
	local save_data = {}
		save_data[1] = json.encode(plPanel)
		save_data[2] = json.encode(chkToggle)
		save_data[3] = json.encode(pbAvatar)
		save_data[4] = json.encode(pbKit)
		save_data[5] = json.encode(txtName)
		save_data[6] = json.encode(txtKit)

-- This is to create 20 entries
for i = 1,50,1 do 
	
	-- Set the panels to the default save value
	plPanel = json.decode(save_data[1])
	chkToggle = json.decode(save_data[2])
	pbAvatar = json.decode(save_data[3])
	pbKit = json.decode(save_data[4])
	txtName = json.decode(save_data[5])
	txtKit = json.decode(save_data[6])
	
	-- Add the id to the name of the object and create the panel
	plPanel['name'] = plPanel['name'] .. i
    local panel = CreatePanel(plPanel)
	
	-- add the id to the name and parent of the object and create the Picture Box
	pbAvatar['name'] = pbAvatar['name'] .. i
	pbAvatar['parent'] = pbAvatar['parent'] .. i
	panel.Children[#panel.Children+1] = CreatePictureBox(pbAvatar)
	
	-- add the id to the name and parent of the object and create the Picture Box
	pbKit['name'] = pbKit['name'] .. i
	pbKit['parent'] = pbKit['parent'] .. i
	panel.Children[#panel.Children+1] = CreatePictureBox(pbKit)
	
	-- add the id to the name and parent of the object and create the Checkbox
	chkToggle['name'] = chkToggle['name'] .. i
	chkToggle['parent'] = chkToggle['parent'] .. i
	panel.Children[#panel.Children+1] = CreateCheckbox(chkToggle)
	
	-- add the id to the name and parent of the object and create the Label
	txtKit['name'] = txtKit['name'] .. i
	txtKit['parent'] = txtKit['parent'] .. i
	panel.Children[#panel.Children+1] = CreateLabel(txtKit)
	
	-- add the id to the name and parent of the object and create the Label
	txtName['name'] = txtName['name'] .. i
	txtName['parent'] = txtName['parent'] .. i
	txtName['text'] = txtName['text'] .. i
	panel.Children[#panel.Children+1] = CreateLabel(txtName)
	
	-- add all the objects to the panels and complete the process
	managelist.Children[#managelist.Children+1] = panel
end

Form:ChangePictureBox("Main", "flowlayout_child1_kit_12","https://static.wikia.nocookie.net/cswikia/images/7/7b/Csgo-musickit-matt_lange_01.png/revision/latest?cb=20150213193222", "png")