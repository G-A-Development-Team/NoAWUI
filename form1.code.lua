Form = {}

-- By: CarterPoe
function Form:Initialize()
	--print("hello world")
    Form:Tab1()

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

-- By: CarterPoe
function Form:Tab1()
    local sender = getControlByName("Main", "Navigation_Tab2")
    local controls = getControlsByGroup("Main", "Navigation_Tab2")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "Navigation_Tab1")
    controls = getControlsByGroup("Main", "Navigation_Tab1")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = true
    end
    sender.Active = true
end

-- By: CarterPoe
function Form:Tab2()
    local sender = getControlByName("Main", "Navigation_Tab1")
    local controls = getControlsByGroup("Main", "Navigation_Tab1")
    for _, control in ipairs(controls) do
        print(control.Group, control.Name)
        control.Visible = false
    end
    sender.Active = false

    sender = getControlByName("Main", "Navigation_Tab2")
    controls = getControlsByGroup("Main", "Navigation_Tab2")
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

--local listbox = getControlByName("Test_Tab", "guns")

return Form