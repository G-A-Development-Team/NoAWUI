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
        "x",
        "y",
        "width",
        "height",

        --Text:
        "fontfamily",
        "fontheight",
        "fontweight",
        "text",

        --Events:
        "mouseclick",

        --Visuals:
        "background",
        "active",
        "border",
        "roundness",
    }

    Control = Control.DefaultCase(Control, properties)

    local Font = draw.CreateFont(Control.FontFamily, Control.FontHeight, Control.FontWeight)

    Control.CreatedFont = Font

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        local drawing = {
            background = function(color)
                if properties.Rounded then
                    Renderer:FilledRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, color, properties.Roundness)
                    Renderer:OutlinedRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)

                else
                    Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, color)
                    Renderer:OutlinedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor)
                end
            end,
        }

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,25}, 25)

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    if not getSelected() then
                        gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
                    end
                end
            end
        end
        

        if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
            if input.IsButtonDown(1) and not getSelected() then
                drawing.background(properties.ActiveBackground)
            else
                drawing.background({properties.ActiveBackground[1], properties.ActiveBackground[2], properties.ActiveBackground[3], 100})
            end
        else
            drawing.background(properties.Background)
        end

        if properties.Active then
            --Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {255,0,0,255}, 30)
            drawing.background(properties.ActiveBackground)
        end

        draw.SetFont(properties.CreatedFont);
        local textLoc = centerTextOnRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Text)
        Renderer:Text({textLoc.X, textLoc.Y}, properties.Color, properties.Text)

        return properties
    end

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName