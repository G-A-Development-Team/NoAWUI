Form = {}

-- By: CarterPoe
function Form:Initialize()
	--print("hello world")
    Form:Tab1()

    --[[local sender = getControlByName("Main", "plbChanger")
    sender.AddItem("jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg", "niiiiggaaa1")
    sender.AddItem("jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg", "niiiiggaaa2")
    sender.AddItem("jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg", "niiiiggaaa3")
    sender.AddItem("jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg", "niiiiggaaa4")
    sender.AddItem("jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg", "niiiiggaaa5")]]--

    --local managelist = getControlByName("mainForm", "managelist")

    --[[
    local text = "type=panel parent=mainForm name=tester width=750 height=156 x=10 y=10 background=70,70,70,200 roundness=7,7,7,7,7"
    local text2 = "type=panel parent=mainForm name=tester width=750 height=300 x=10 y=10 background=255,0,0,200 roundness=7,7,7,7,7"
    local text3 = "type=panel parent=mainForm name=tester width=750 height=110 x=10 y=10 background=0,255,0,200 roundness=7,7,7,7,7"
    local text4 = "type=panel parent=mainForm name=tester width=750 height=50 x=10 y=10 background=0,0,255,200 roundness=7,7,7,7,7"
    
    local attributes = split(text, " ")
    local made = CreatePanel(attributes)
    managelist.Children[#managelist.Children+1] = made

    attributes = split(text2, " ")
    made = CreatePanel(attributes)
    managelist.Children[#managelist.Children+1] = made

    attributes = split(text3, " ")
    made = CreatePanel(attributes)
    managelist.Children[#managelist.Children+1] = made

    attributes = split(text4, " ")
    made = CreatePanel(attributes)
    managelist.Children[#managelist.Children+1] = made]]--
end

-- By: CarterPoe
function Form:Click()
end

function Form:Exit()
    getFormByName("Main").Visible = false
end

function Form:Load()
	setManagerData()
end

function Form:Unload()
	setManagerData()
end

-- By: CarterPoe
function Form:Tab1()
    local sender = getControlByName("Main", "tManager")
    local controls = getControlsByGroup("Main", "tManager")
    for _, control in ipairs(controls) do
        --print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "tChanger")
    controls = getControlsByGroup("Main", "tChanger")
    for _, control in ipairs(controls) do
        --print(control.Group, control.Name)
        control.Visible = true
    end
    sender.Active = true
end

-- By: CarterPoe
function Form:Tab2()
    local sender = getControlByName("Main", "tChanger")
    local controls = getControlsByGroup("Main", "tChanger")
    for _, control in ipairs(controls) do
        --print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "tManager")
    controls = getControlsByGroup("Main", "tManager")
    for _, control in ipairs(controls) do
        --print(control.Group, control.Name)
        control.Visible = true
    end
    sender.Active = true
end

-- By: Agentsix1
function Form:ChangePictureBox(parent, name, url, ext)
	local sender = getControlByName(parent, name)
	sender.ChangeImage(sender, url, ext)
end

-- By: Agentsix1
function Form:plbChanger_Changed()
	-- Get the controls needed to be modified
	local plbChanger = getControlByName("Main", "plbChanger")
	local lblKitName = getControlByName("Main", "lblKitName")
	local mlMVP = getControlByName("Main", "mlMVP")
	local mlRoundLoss = getControlByName("Main", "mlRoundLoss")
	local mlDeathTheme = getControlByName("Main", "mlDeathTheme")

	-- Set the label to the name of the kit
	lblKitName.Text = kits[plbChanger.SelectedIndex]
	
	-- Set the urls for the play buttons
	mlMVP.URL = kits_details[kits[plbChanger.SelectedIndex]]['Round MVP anthem']
	mlRoundLoss.URL = kits_details[kits[plbChanger.SelectedIndex]]['Round Loss']
	mlDeathTheme.URL = kits_details[kits[plbChanger.SelectedIndex]]['Deathcam']
	
	-- Set the image for the Album Art
	Form:ChangePictureBox("Main", "pbKitPreview", kits_details[kits[plbChanger.SelectedIndex]]['img'], "png")
	plbChanger.ChangedStatus = true
end

function Form:mlMVP_Clicked()
	print("mlMVP_Clicked")
end

function Form:mlRoundLoss_Clicked()
	print("mlRoundLoss_Clicked")
end

function Form:mlDeathTheme_Clicked()
	print("mlDeathTheme_Clicked")
end



--local listbox = getControlByName("Test_Tab", "guns")

return Form