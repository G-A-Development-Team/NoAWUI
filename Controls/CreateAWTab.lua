local ControlName = 'awtab'
local FunctionName = 'CreateAWTab'

-- By: CarterPoe
function CreateAWTab(attributes)
    local Control = CreateControl()
    Control.ReferenceTab = nil

    Control.AllowedCases = {
        "category",
        "varname",
    }

    Control:DefaultCase(attributes)

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