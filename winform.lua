globaldragging = false

RunScript("WinForm/Misc.lua")
RunScript("WinForm/Renderer.lua")
RunScript("WinForm/Controls.lua")

local design = file.Open("WinForm/form1.design.txt", "r");

local designCode = file.Open("WinForm/form1.code.lua", "r");
RunScript("WinForm/form1.code.lua")

local designText = design:Read();
design:Close();

local designCodeText = designCode:Read();
designCode:Close();

-- Begin comment removal
local CommentLines = split(designText, "\n")

-- Reset DesignText
designText = ""

-- For each line check if it starts with *
for _, cl in ipairs(CommentLines) do
	if not string.starts(cl, "*") then
		if designText == "" then
			designText = cl
		else
			designText = designText .. cl
		end
	end
end


-- Get the Elements from json
local jsonElements = json.decode(designText)

local controls = {}

function getDefaultAtts(je)
	local atts = {}
		for key, jElement in pairs(je['details']) do
			atts[key] = jElement
		end
		
		for key, jElement in pairs(je['dimensions']) do
			atts[key] = jElement
		end
		
		for key, jElement in pairs(je['optional']) do
			for subKey, subjElement in pairs(je['optional'][key]) do 
				atts[subKey] = subjElement
			end
		
		end
	return atts
end

-- Grab an element from the json
for _, jElement in ipairs(jsonElements) do
	
	-- Get the attributes from the element
	local attributes = getDefaultAtts(jElement)
	
	print (jElement['details']['type'])
	
	-- Get the type and add the component
	switch(jElement['details']['type']:lower())
        .case("panel", function() 
            local made = CreatePanel(attributes)
                for _, control in ipairs(controls) do
                    if made.Parent ~= "" then
                        addComponent(made, control)
                    end
                end
            end)
		.case("flowlayout", function() 
			local made = CreateFlowLayout(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
		end)
		.case("picturebox", function() 
			local made = CreatePictureBox(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
		end)
		.case("mlbutton", function() 
			local made = CreateMusicLinkButton(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
		end)
		.case("checkbox", function() 
			local made = CreateCheckbox(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
		end)						
		.case("button", function() 
			local made = CreateButton(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
		end)
		.case("label", function() 
			local made = CreateLabel(attributes)
			for _, control in ipairs(controls) do
				if made.Parent ~= "" then
					addComponent(made, control)
				end
			end
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

Form:Initialize()


callbacks.Register("Draw", "Render", function()
    if input.IsButtonDown(1) then
        globaldragging = true
    end
    if input.IsButtonReleased(1) then
        globaldragging = false
    end

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