local ControlName = 'form'
local FunctionName = 'CreateForm'


-- By: CarterPoe
function CreateForm(properties)
    local Control = CreateControl()
    Control.DragNow = false
    Control.Focused = false

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x",
        "y",
        "width",
        "height",

        --Listeners:
        "drag",
        "toggle",

        --State:
        "visible",

        --Events:
        "ontoggle",
        "unload",

        --Visuals:
        "image",
        "background",
        "border",
        "roundness",
    }

    Control = Control.DefaultCase(Control, properties)
	
    Control.Render = function(properties)
        if properties.Toggle ~= nil then
            
            if input.IsButtonPressed(properties.Toggle) then
                properties.Visible = not properties.Visible
                if properties.OnToggle ~= nil and properties.Visible then
                    gui.Command('lua.run "' .. properties.OnToggle .. '" ')
                end
                if not properties.Visible then
                    if properties.Unload ~= nil then
                        gui.Command('lua.run "' .. properties.Unload .. '" ')
                    end
                end
            end
            properties.dummywindow:SetActive(properties.Visible)
        end

        if not properties.Visible then
            return properties
        end
        
        Renderer:ShadowRectangle({properties.X, properties.Y}, {properties.Width, properties.Height}, {0,0,0,70}, 25)

        if properties.Rounded then
            
            Renderer:FilledRoundedRectangle({properties.X, properties.Y}, {properties.Width, properties.Height}, properties.Background, properties.Roundness)
            Renderer:OutlinedRoundedRectangle({properties.X, properties.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)
        else
            if properties.BackgroundImage ~= nil then
                draw.SetTexture(properties.BackgroundImage)
            end
            Renderer:FilledRectangle({properties.X, properties.Y}, {properties.Width, properties.Height}, properties.Background)
            draw.SetTexture(nil)
            Renderer:OutlinedRectangle({properties.X, properties.Y}, {properties.Width, properties.Height}, properties.BorderColor)
        end

        if properties.ForceDrag ~= nil then
            properties.DragNow = properties.ForceDrag
        end

        if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
            if input.IsButtonDown(1) or input.IsButtonPressed(1) or input.IsButtonReleased(1) then
                if not getSelected() then
                    FocusForm(properties.Name)
                end
            end
        end
        
        properties = HandleEvent("drag", properties)

        return properties
    end
	
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName
WinFormControls[ControlName]['special'] = 'container'