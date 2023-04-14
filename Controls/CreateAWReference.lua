local ControlName = 'awreference'
local FunctionName = 'CreateAWReference'

-- By: CarterPoe
function CreateAWReference(attributes)
    local Control = CreateControl()
    Control.ReferenceText = nil
    Control.ReferenceObj = nil

    Control.AllowedCases = {
        "reference",
    }

    Control:DefaultCase(attributes)

    local refs = ""
    local sp = split(Control.ReferenceText, ",")
    for _, ref in ipairs(sp) do
        if _ == #sp then
            refs = refs .. '"' .. ref .. '"'
        else
            refs = refs .. '"' .. ref .. '",'
        end
    end
    print(refs)

    local gui_ref = assert(loadstring('return gui.Reference(' .. refs .. ')'))()

    Control.ReferenceObj = gui_ref

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName
WinFormControls[ControlName]['special'] = 'container'