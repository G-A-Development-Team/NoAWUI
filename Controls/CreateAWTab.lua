local ControlName = 'awtab'
local FunctionName = 'CreateAWTab'

-- By: CarterPoe
function CreateAWTab(properties)
    local Control = CreateControl()
    Control.ReferenceTab = nil

    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("type", function() Control.Type = value end)
            .case("category", function() Control.Category = value end)
            .case("varname", function() Control.VarName = value end)
            .default(function() print("Attribute not found. key=" .. key) end)
            .process() 
    end
    local gui_ref = gui.Reference(Control.Category)

    Control.ReferenceTab = gui.Tab(gui_ref, Control.VarName, Control.Name)

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName
WinFormControls[ControlName]['special'] = 'container'