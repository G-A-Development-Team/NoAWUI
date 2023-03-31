local ControlName = 'panel'
local FunctionName = 'CreatePanel'

-- By: CarterPoe
function CreatePanel(properties)
    local Control = CreateControl()
    Control.Shadow = {0,0,0,40,25}

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Events:
        "mousehover", "mouseoutside", "mouseclick", "dragparent",
        --Visuals:
        "image", "background", "shadow", "border", "roundness",
    }

    Control = Control.DefaultCase(Control, properties)

    Control.RenderBase = function(properties, parent)
        Renderer:ShadowRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, {properties.Shadow[1], properties.Shadow[2], properties.Shadow[3], properties.Shadow[4]}, properties.Shadow[5])

        if properties.Rounded then
            Renderer:FilledRoundedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.Background, properties.Roundness)
            Renderer:OutlinedRoundedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)
        end

        if not properties.Rounded then
            if properties.BackgroundImage ~= nil then draw.SetTexture(properties.BackgroundImage) end

            Renderer:FilledRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.Background)
            draw.SetTexture(nil)

            Renderer:OutlinedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.BorderColor)
        end
        return properties
    end

    Control.RenderChildren = function(properties, parent)
        Renderer:Scissor({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height})
        for _, control in ipairs(properties.Children) do
            control.X = parent.X + control.SetX
            control.Y = parent.Y + control.SetY
            control.Render(control, properties)
        end
        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h})
        return properties
    end

    Control.Render = function(properties, parent)
        if not properties.Visible or not parent.Visible then return properties end
        properties = properties.RenderBase(properties, parent)

        properties = properties.RenderChildren(properties, parent)
        properties = HandleEvent("dragparent", properties, parent)
        properties = HandleEvent("mousehover", properties, parent)
        properties = HandleEvent("mouseoutside", properties, parent)
        properties = HandleEvent("mouseclick", properties, parent)

        return properties
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName