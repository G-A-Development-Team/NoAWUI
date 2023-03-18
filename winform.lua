globaldragging = false

RunScript("WinForm/Misc.lua")
RunScript("WinForm/Renderer.lua")
RunScript("WinForm/Controls.lua")

RunScript("WinForm/xml/xml2lua.lua")
RunScript("WinForm/xml/xmlhandler/tree.lua")
local handler = tree:new()

local design = file.Open("WinForm/form1.design.xml", "r");

local designCode = file.Open("WinForm/form1.code.lua", "r");
RunScript("WinForm/form1.code.lua")

local designText = design:Read();
design:Close();

local parser = xml2lua.parser(tree)
parser:parse(designText)

local designCodeText = designCode:Read();
designCode:Close();

local designString = ""

local created = {}

local function CreateComponenetFromAttributes(type, attributes)
    local made = nil
    switch(type:lower())
        .case("panel", function() 
            made = CreatePanel(attributes)
        end)
        .case("flowlayout", function() 
            made = CreateFlowLayout(attributes)
        end)
        .case("picturebox", function() 
            made = CreatePictureBox(attributes)
        end)
        .case("mlbutton", function() 
            made = CreateMusicLinkButton(attributes)
        end)
        .case("checkbox", function() 
            made = CreateCheckbox(attributes)
        end)						
        .case("button", function() 
            made = CreateButton(attributes)
        end)
        .case("label", function() 
            made = CreateLabel(attributes)
        end)
        .case("form", function() 
            made = CreateForm(attributes)
        end)
        .case("awtab", function() 
            made = CreateAWTab(attributes)
        end)
        .default(function() print("Type not found.") end)
    .process()
    return made
end

function XMLToText(node, parent_key, grandparent_key, great_grandparent_key, great_grandparent_attr, great_grandparent_attr2)
    -- print attributes of current node
	local done = false
    for k, v in pairs(node) do
		if type(v) ~= "table" and done ~= true then

			local properties = ""

			for k, v in pairs(node) do
                
				if string.find(v, " ") and k:lower() == "text" then
					v = string.gsub(v, " ", "_")
				else
					v = string.gsub(v, " ", "")
				end
				properties = properties .. k:lower() .. "=" .. v .. " "
				
			end
            node.Bananas = "help"

            local usetype = ""
			if great_grandparent_key == nil then
				usetype = grandparent_key
			else
				usetype = great_grandparent_key
			end

            if type(usetype) == "number" then
                usetype = grandparent_key
            end
            --print(node.Name)
			--print("----------------------------------------------")
			--print("type=" .. usetype .. " " .. properties)

            designString = designString .. "type=" .. usetype:lower() .. " " .. properties .. "\n"
			--print(properties)
			--xml2lua.printable(node)
			--print("----------------------------------------------")
            local attributes = split(properties, " ")
            local made = CreateComponenetFromAttributes(usetype, attributes) 

            created[node.Name] = {
                node,
                Control = made,
            }
			done = true
		end
    end
    
    -- recursively print attributes of child nodes
	for k, v in pairs(node) do
		if type(v) == "table" then
			local attr = v._attr
			XMLToText(v, k, parent_key, grandparent_key, great_grandparent_key, node._attr)
		end
	end
end

local properties = ""

for k, v in pairs(tree.root.Form._attr) do
    
    if string.find(v, " ") and k:lower() == "text" then
        v = string.gsub(v, " ", "_")
    else
        v = string.gsub(v, " ", "")
    end
    properties = properties .. k:lower() .. "=" .. v .. " "
    
end

created[tree.root.Form._attr.Name] = {
    tree.root.Form,
    Control = CreateComponenetFromAttributes("form", split(properties, " ")) ,
}

XMLToText(tree.root, nil, nil, nil, nil, nil)

--xml2lua.printable(tree.root)

print(designString)
local elements = split(designString, "\n")

--xml2lua.printable(ntblv)
--print(outt)

local controls = {}
local unprocessedControls = {}

print("-------------------")

function traverse_tree(node)
    if node == nil then
        return
    end

    if type(node) == "table" then
        for key, value in pairs(node) do
            --print(value)
            if type(value) == "table" then
                traverse_tree(value)
            elseif type(value) == "string" then
                --node.element = {
                --    type = value
                --}
            end
        end
    end
end

-- assuming that `tree` is your XML document
for i, p in pairs(tree.root) do
    traverse_tree(p)
end
--xml2lua.printable(created)
--TablePrint(created)
print("-------------------")


for _, elementValue in ipairs(elements) do
    if not string.starts(elementValue, "*") then
        local attributes = split(elementValue, " ")
        for _, attributeValue in ipairs(attributes) do
            if string.find(attributeValue, "=") then
                local key = split(attributeValue, "=")[1]
                local value = split(attributeValue, "=")[2]
                if key:lower() == "type" then
                    switch(value:lower())
                       .case("panel", function() 
                            local made = CreatePanel(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
                        .case("flowlayout", function() 
                            local made = CreateFlowLayout(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
						.case("picturebox", function() 
                            local made = CreatePictureBox(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
						.case("mlbutton", function() 
                            local made = CreateMusicLinkButton(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
						.case("checkbox", function() 
                            local made = CreateCheckbox(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)						
                        .case("button", function() 
                            local made = CreateButton(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
                        .case("label", function() 
                            local made = CreateLabel(attributes)
                            for _, control in ipairs(controls) do
                                if made.Parent ~= "" then
                                    if addComponent(made, control) then
                                        return
                                    end
                                end
                            end
                            print("Parent not found for", made.Name)
                            table.insert(unprocessedControls, made)
                        end)
                        .case("form", function() 
                            controls[#controls +1] = CreateForm(attributes)
                        end)
                        .case("awtab", function() 
                            controls[#controls +1] = CreateAWTab(attributes)
                        end)
                        .default(function() print("Type not found.") end)
                    .process() 
                end
            end
        end
    end
end

print("Unprocessed Amount = " .. #unprocessedControls)

local max = 5
local function processLoop(attempt)
    if attempt >= max then
        return
    else
        for _, made in ipairs(unprocessedControls) do
            for _, control in ipairs(controls) do
                if made.Parent ~= "" then
                    if addComponent(made, control) then
                        return
                    end
                end
            end
            print("Unprocessed Parent not found for", made.Name)
            processLoop(attempt + 1)
        end
    end
end
processLoop(1)
--TablePrint(controls)
--gui.Command('lua.run "print("hello wlrd")"')

function getControlByName(form, name)
    for _m, main in ipairs(controls) do
        if main.Name == form then
            for _, control in ipairs(main.Children) do
                if control.Name == name then
                    return control
                end
            end
        end
    end
end

function getControlsByGroup(form, group)
    local list = {}
    for _m, main in ipairs(controls) do
        if main.Name == form then
            for _, control in ipairs(main.Children) do
                if control.Group == group then
                    table.insert(list, control)
                end
            end
        end
    end
    return list
end

function updateControlByName(form, name, controle)
    for _m, main in ipairs(controls) do
        if main.Name == form then
            for _, control in ipairs(main.Children) do
                if control.Name == name then
                    main.Children[_] = controle
                end
            end
            controls[_m] = main
        end
    end
end


function CreaControl(c)

end

Form:Initialize()


callbacks.Register("Draw", "Render", function()

    for _m, main in ipairs(controls) do
        if main.Type == "form" and not string.starts(main.Type, "aw") then
            local newcontrol = main.Render(main)
            for _, control in ipairs(main.Children) do
                local properties = control
                --print(#control.Children .. control.Name)
                main.Children[_] = control.Render(properties, main)
            end
            controls[_m] = newcontrol
        elseif string.starts(main.Type, "aw") then
            for _, control in ipairs(main.Children) do
                if control.Reference == nil then
                    local custom = gui.Custom(main.ReferenceTab, "asdasd", control.X, control.Y, control.Width, control.Height, function(x, y, x2, y2, active)
                        local properties = control
                        properties = properties.AWInit(properties, x, y, x2, y2)
                        main.Children[_] = control.Render(properties, main)
                        if main.Children[_].X ~= x then
                            main.Children[_].AdditionalX = main.Children[_].X - x
                            --main.Children[_].Reference:SetPosX(main.Children[_].AdditionalX)
                        end
                        if main.Children[_].Y ~= y then
                            main.Children[_].AdditionalY = main.Children[_].Y - y
                        end
                        if main.Children[_].Width ~= x2 -properties.X then
                            main.Children[_].AdditionalWidth = main.Children[_].Width - (x2 -properties.X)
                        end
                        if main.Children[_].Height ~= y2 -properties.Y then
                            main.Children[_].AdditionalHeight = main.Children[_].Height - (y2 -properties.Y)
                        end

                    end, function() end, function() end)
                    control.Reference = custom
                    main.Children[_] = control
                    controls[_m] = main
                else
                    --control.Reference:SetPosX(control.X + control.AdditionalX)
                end
            end
        end
    end
end)