local ControlName = 'button'
local FunctionName = 'CreateButton'

-- By: CarterPoe
function CreateButton(properties)
    local Control = CreateControl()
    Control.Background = {50, 50, 50, 255}
    Control.ActiveBackground = {65, 65, 65, 255}
    Control.Color = {255, 255, 255, 255}
    Control.Height = 26
    Control.Width = 124
    Control.FontWeight = 600
    Control.FontHeight = 14
    Control.FontFamily = "Segoe UI"

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Text:
        "fontfamily", "fontheight", "fontweight", "text",
        --Events:
        "mouseclick",
        --Visuals:
        "background", "active", "border", "roundness",
    }

    Control = Control.DefaultCase(Control, properties)

    Control.RegisterFont = function(properties)
        local Font = draw.CreateFont(properties.FontFamily, properties.FontHeight, properties.FontWeight)
        Control.CreatedFont = Font
        return properties
    end

    Control = Control.RegisterFont(Control)

    Control.RenderBase = function(properties, parent, backgroundColor)
        Renderer:ShadowRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, {0,0,0,25}, 25)

        if properties.Rounded then
            Renderer:FilledRoundedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, backgroundColor, properties.Roundness)
            Renderer:OutlinedRoundedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)
        end

        if not properties.Rounded then
            Renderer:FilledRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, backgroundColor)
            Renderer:OutlinedRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.BorderColor)
        end
        return properties
    end

    Control.RenderText = function(properties, parent)
        draw.SetFont(properties.CreatedFont)

        local textLocation = centerTextOnRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.Text)
        Renderer:Text({textLocation.X, textLocation.Y}, properties.Color, properties.Text)
        return properties
    end

    Control.Render = function(properties, parent)
        if not properties.Visible or not parent.Visible then return properties end
        
        properties = HandleEvent("mouseclick", properties, parent)

        if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
            if input.IsButtonDown(1) and not getSelected() then
                properties = properties.RenderBase(properties, parent, properties.ActiveBackground)
            else
                properties = properties.RenderBase(properties, parent, {properties.ActiveBackground[1], properties.ActiveBackground[2], properties.ActiveBackground[3], 100})
            end
        else properties = properties.RenderBase(properties, parent, properties.Background) end

        if properties.Active then properties = properties.RenderBase(properties, parent, properties.ActiveBackground) end

        properties = properties.RenderText(properties, parent)
        return properties
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName