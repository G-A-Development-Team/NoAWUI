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
        properties = HandleEvent("toggle", properties)

        if not properties.Visible then return properties end
        
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
        
        properties = HandleEvent("focus", properties)
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