globaldragging = false

RunScript("WinForm/libs/Timer.lua")
RunScript("WinForm/Misc.lua")
RunScript("WinForm/Renderer.lua")
RunScript("WinForm/Controls.lua")

local controls = {}
local tempDraw = {}
local focuslist = {}

-- Grab an element from the json
local function LoadJsonElements(jElements)
    
	for _, jElement in ipairs(jElements) do
	
        -- Get the attributes from the element
        local attributes = getDefaultAtts(jElement)
		
		-- Cycle through all the possible winform controls
		for _, wfControl in pairs(WinFormControls) do
		
			-- See if the control is the right one
			if jElement['details']['type']:lower() == wfControl['name'] then
			
				-- Getting the create function to made
				local made = assert(loadstring('return ' .. wfControl['function']..'(...)'))(attributes)
				
				-- Check if the special category is set
				if wfControl['special']=="container" then
					
					controls[#controls +1] = made
				else
					-- if not then just add the component
					for _, control in ipairs(controls) do
						if made.Parent ~= "" then
							addComponent(made, control)
						end
					end
				end
			end
		end
    end
end

function getTotalX(control)
    local parent = getParentControl(control)
    
    return parent.X + control.X
end

function getTotalY(control)
    local parent = getParentControl(control)
    
    return parent.Y + control.Y
end

function getControlByName(form, name)
    for _, main in ipairs(controls) do
        if main.Name == form then
            local function findControl(control)
                if control.Name == name then
                    return control
                else
                    for _, child in ipairs(control.Children or {}) do
                        local result = findControl(child)
                        if result then
                            return result
                        end
                    end
                end
            end
            return findControl(main)
        end
    end
    return nil
end

function getParents(control)
    local parents = {}
    local parent = getParentControl(control)
    while parent do
        if parent.Type:lower() == "form" then
            table.insert(parents, 1, parent) 
        end
        parent = getParentControl(parent)
    end
    return parents
end

function getControl(name)
    for _, main in ipairs(controls) do
        local function findControl(control)
            if control.Name == name then
                return control
            else
                for _, child in ipairs(control.Children or {}) do
                    local result = findControl(child)
                    if result then
                        return result
                    end
                end
            end
        end
        return findControl(main)
    end
    return nil
end

function getSelected()
    for _, main in ipairs(controls) do
        local function findControl(control)
            if control.Selected then
                return true
            else
                for _, child in ipairs(control.Children or {}) do
                    local result = findControl(child)
                    if result then
                        return result
                    end
                end
            end
        end
        local result = findControl(main)
        if result then
            return result
        end
    end
    return false
end

function getParentControl(control)
    return getControl(control.Parent)
end

function getFormByName(form)
    for _, main in ipairs(controls) do
        if main.Name == form then
            return main
        end
    end
end


function getControlsByGroup(form, group)
    local list = {}
    for _, main in ipairs(controls) do
        if main.Name == form then
            local function searchChildren(children)
                for _, control in ipairs(children) do
                    if control.Group == group then
                        table.insert(list, control)
                    end
                    if control.Children then
                        searchChildren(control.Children)
                    end
                end
            end
            searchChildren(main.Children)
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



function addTempDraw(func)
    table.insert(tempDraw, func)
end

function removeTempDraw(name)
    for _m, main in ipairs(tempDraw) do
        if main.Name == name then
            table.remove(tempDraw, _m)
        end
    end
end

function FocusForm(name)
    table.remove(focuslist, 1)
    if #focuslist == 0 then
        local found = false
        for _, _name in ipairs(focuslist) do
            if _name == name then
                found = true
            end
        end
        if not found then
            table.insert(focuslist, name) 
        end
    end
end

function getCurrentFocus()
    return focuslist[1]
end

function AmIAllowed(control)
    local name = getParents(control)[1].Name
    if name:lower() == getCurrentFocus():lower() then
        return true
    end
    return false
end

-- Set the json files to an array
local Jstartup = file.Open("WinForm/startup.txt", "r");
local JstartupText = Jstartup:Read();
JstartupText = cleanJsonComments(JstartupText)
local json_files = json.decode(JstartupText)

-- This is used to load all of the control data from json files
for _, element in ipairs(json_files) do
    if element.Json ~= nil then
            -- Open the file
        local jFile = file.Open(element.Json, "r");
        
        -- Read the file and set to var
        local jText = jFile:Read();
        
        -- Close the file
        jFile:Close();
        
        -- Clean the json of comments
        local jCleanText = cleanJsonComments(jText)
        
        -- Create json object from text
        local jElement = json.decode(jCleanText)
        
        -- Load the json data into script
        LoadJsonElements(jElement)
    end
    if element.Lua ~= nil then
        RunScript(element.Lua)
        if element.LuaInit ~= nil then
            gui.Command('lua.run "' .. element.LuaInit .. '" ') 
        end
    elseif element.LuaInit ~= nil then
		gui.Command('lua.run "' .. element.LuaInit .. '" ') 
	end
end

callbacks.Register("Draw", "Render", function()
    if input.IsButtonDown(1) then
        globaldragging = true
    end
    if input.IsButtonReleased(1) then
        globaldragging = false
    end
    --TablePrint(focuslist)
    for _m, main in ipairs(controls) do
        if getCurrentFocus() ~= main.Name then
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
                            --[[
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
                            end]]
    
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
    end

    for _, _name in ipairs(focuslist) do
        local main = getFormByName(_name)
        local newcontrol = main.Render(main)
        for _, control in ipairs(main.Children) do
            local properties = control
            --print(#control.Children .. control.Name)
            main.Children[_] = control.Render(properties, main)
        end
        main = newcontrol

    end

    --local sender = getControlByName("Main", "plbChanger")
    --print(sender.GetSelectedItem().Name)
    for _m, main in ipairs(tempDraw) do
        main.Render()
    end

end)

callbacks.Register("Unload", function()
    UnloadScript("WinForm/Misc.lua")
    UnloadScript("WinForm/Renderer.lua")
    UnloadScript("WinForm/Controls.lua")
end)