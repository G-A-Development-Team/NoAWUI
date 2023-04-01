gui.Command("clear");

options = {
    panorama = true,
    logger = {
        info = true,
        debug = true,
    },
    ScriptLoaded = false,
}

controls = {}
tempDraw = {}
focuslist = {}
elapsedlist = {}

RunScript("WinForm/libs/api/Logger.lua")
RunScript("WinForm/libs/api/Misc.lua")
local ScriptElapsed = CreateElapsedTime("Script")

RunScript("WinForm/libs/api/Renderer.lua")
RunScript("WinForm/libs/api/manipulation.lua")
RunScript("WinForm/Controls.lua")

-- Load in all event files
loadFiles("WinForm/Events/", "Events")

-- Grab an element from the json
local function LoadJsonElements(jElements)
    local ControlsElapsed = CreateElapsedTime("Controls")
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
    ControlsElapsed.Done()
end

-- Set the json files to an array
local Jstartup = file.Open("WinForm/startup.txt", "r");
local JstartupText = Jstartup:Read();
JstartupText = cleanJsonComments(JstartupText)
local json_files = json.decode(JstartupText)

-- This is used to load all of the control data from json files
local DesignElapsed = CreateElapsedTime("Design")
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
        LogInfo("DesignJson", element.Json)
    end
    if element.Lua ~= nil then
        RunScript(element.Lua)
        LogInfo("DesignLua", element.Lua)
        if element.LuaInit ~= nil then
            gui.Command('lua.run "' .. element.LuaInit .. '" ') 
            LogInfo("DesignInit", element.LuaInit)
        end
    elseif element.LuaInit ~= nil then
		gui.Command('lua.run "' .. element.LuaInit .. '" ') 
        LogInfo("DesignInit", element.LuaInit)
	end
end
DesignElapsed.Done()

callbacks.Register("Draw", "Render", function()
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

    for _m, main in ipairs(tempDraw) do
        main.Render()
    end

end)

callbacks.Register("Unload", function()
    UnloadScript("WinForm/libs/api/Misc.lua")
    UnloadScript("WinForm/libs/api/manipulation.lua")
    UnloadScript("WinForm/libs/api/Logger.lua")
    UnloadScript("WinForm/libs/api/Theme.lua")
    UnloadScript("WinForm/libs/api/Renderer.lua")
    UnloadScript("WinForm/Controls.lua")
    UnloadScript("WinForm/Events/Drag.lua")
    UnloadScript("WinForm/Events/Focus.lua")
    UnloadScript("WinForm/Events/Toggle.lua")
    UnloadScript("WinForm/Events/MouseClick.lua")
    UnloadScript("WinForm/Events/MouseOutside.lua")
    UnloadScript("WinForm/Events/MouseHover.lua")
    UnloadScript("WinForm/Events/DragParent.lua")
end)

ScriptElapsed.Done()
LongestElapsedTime()
options.ScriptLoaded = true