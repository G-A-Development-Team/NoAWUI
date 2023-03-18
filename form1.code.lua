Form = {}

-- By: CarterPoe
function Form:Initialize()
    --[[Form:Tab1()

    local managelist = getControlByName("mainForm", "managelist")

    
    local text = "type=panel parent=managelist name=player3 width=750 height=156 x=10 y=10 background=70,70,70,200 roundness=7,7,7,7,7"
    local text2 = "type=panel parent=player3 name=manage_check width=50 height=50 x=15 y=50 background=0,0,0,200 roundness=7,7,7,7,7"
    local text3 = "type=panel parent=player3 name=manage_avatar width=120 height=120 x=80 y=18 background=0,0,0,200 roundness=7,7,7,7,7"
    local text4 = "type=panel parent=player3 name=manage_name x=230 y=65 text=AgentSix1 color=255,255,255,255 fontheight=25"
    local text5 = "type=panel parent=player3 name=manage_kit width=120 height=120 x=615 y=18 background=0,0,0,200 roundness=7,7,7,7,7"
    local text6 = "type=panel parent=player3 name=manage_kitname x=488 y=65 text=AgentSxi1 color=255,255,255,255 fontheight=25"

    local attributes = split(text, " ")
    local player3 = CreatePanel(attributes)

    attributes = split(text2, " ")
    local made1 = CreatePanel(attributes)
    player3.Children[#player3.Children+1] = made1

    attributes = split(text3, " ")
    local made2 = CreatePanel(attributes)
    player3.Children[#player3.Children+1] = made2

    attributes = split(text4, " ")
    local made3 = CreatePanel(attributes)
    player3.Children[#player3.Children+1] = made3

    attributes = split(text5, " ")
    local made4 = CreatePanel(attributes)
    player3.Children[#player3.Children+1] = made4

    attributes = split(text6, " ")
    local made5 = CreatePanel(attributes)
    player3.Children[#player3.Children+1] = made5

    managelist.Children[#managelist.Children+1] = player3]]--

    
end

-- By: CarterPoe
function Form:Click()
end

-- By: CarterPoe
function Form:Tab1()
    local sender = getControlByName("Main", "Tab2")
    local controls = getControlsByGroup("Main", "Tab2")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "Tab1")
    controls = getControlsByGroup("Main", "Tab1")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = true
    end
    sender.Active = true
end

-- By: CarterPoe
function Form:Tab2()
    local sender = getControlByName("Main", "Tab1")
    local controls = getControlsByGroup("Main", "Tab1")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "Tab2")
    controls = getControlsByGroup("Main", "Tab2")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
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
function Form:ClickedMLButton(parent, name)
	local sender = getControlByName(parent, name)
	panorama.RunScript([[
            SteamOverlayAPI.OpenURL("]] .. sender.URL .. [[")
        ]])
end

--local listbox = getControlByName("Test_Tab", "guns")

return Form