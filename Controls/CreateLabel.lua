local ControlName = 'label'
local FunctionName = 'CreateLabel'


-- By: CarterPoe
function CreateLabel(properties)
    local Control = CreateControl()
    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height", "alignment",
        --Text:
        "fontfamily", "fontheight", "fontweight", "text",
        --Events:
        "mouseclick",
        --Visuals:
        "color",
        --Debug:
        "showsquare",
    }

    Control = Control.DefaultCase(Control, properties)

    Control.RegisterFont = function(properties)
        local Font = draw.CreateFont(properties.FontFamily, properties.FontHeight, properties.FontWeight)
        properties.CreatedFont = Font
        properties.DefaultFont = Font
        return properties
    end

    Control = Control.RegisterFont(Control)

    Control.ResetFont = function()
        if Control.CreatedFont ~= Control.DefaultFont then
            Control.CreatedFont = Control.DefaultFont
        end
    end

    Control.RenderDefaultBase = function(properties, parent)
        draw.SetFont(properties.CreatedFont)
        Renderer:Text({properties.X + parent.X, properties.Y + parent.Y}, properties.Color, properties.Text)
        return properties
    end

    Control.RenderRightAlignment = function (properties, parent)
        draw.SetFont(properties.CreatedFont)

        local Tw, Th = draw.GetTextSize(properties.Text)
        Renderer:Text({properties.X + parent.X - Tw, properties.Y + parent.Y}, properties.Color, properties.Text) 

        if properties.ShowSquare then Renderer:FilledRectangle({properties.X + parent.X, properties.Y + parent.Y}, {5,5}, {255,0,0,255}) end
        return properties
    end

    Control.RenderAutoSize = function (properties, parent)
        draw.SetFont(properties.CreatedFont)

        local Tw, Th = draw.GetTextSize(properties.Text)

        if tonumber(Tw) >= tonumber(properties.Width) then
            Renderer:Text({properties.X + parent.X, properties.Y + parent.Y}, properties.Color, "Loading..")
            if properties.Multipler == nil then properties.Multipler = .1 else properties.Multipler = properties.Multipler + .1 end

            local Font = draw.CreateFont(properties.FontFamily, properties.FontHeight - properties.Multipler, properties.FontWeight)
            properties.CreatedFont = Font
        else
            Renderer:Text({properties.X + parent.X, properties.Y + parent.Y}, properties.Color, properties.Text) 
        end

        if properties.ShowSquare then Renderer:FilledRectangle({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width,properties.Height}, {255,0,0,255}) end
        return properties
    end

    Control.Render = function(properties, parent)
        if not properties.Visible or not parent.Visible then return properties end

        if properties.Alignment == nil then properties = properties.RenderDefaultBase(properties, parent) end

        if properties.Alignment == "right" then properties = properties.RenderRightAlignment(properties, parent) end

        if properties.Alignment == "autosize" then properties = properties.RenderAutoSize(properties, parent) end

        return properties
    end

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName