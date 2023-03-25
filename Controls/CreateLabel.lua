local ControlName = 'label'
local FunctionName = 'CreateLabel'


-- By: CarterPoe
function CreateLabel(properties)
    local Control = CreateControl()
    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("group", function() Control.Group = value end)
            .case("parent", function() Control.Parent = value end)
            .case("type", function() Control.Type = value end)
            .case("x", function() Control.X = value Control.SetX = value end)
            .case("y", function() Control.Y = value Control.SetY = value end)
            .case("width", function() Control.Width = value end)
            .case("height", function() Control.Height = value end)
            .case("fontfamily", function() Control.FontFamily = value end)
            .case("fontheight", function() Control.FontHeight = value end)
            .case("fontweight", function() Control.FontWeight = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("alignment", function() Control.Alignment = value:lower() end)
            .case("showsquare", function() 
                if value == "true" then
                    Control.ShowSquare = true
                elseif value == "false" then
                    Control.ShowSquare = false
                end
            end)
            .case("color", function()
                if string.find(value, "theme") then
                    --print("-" .. enc(tostring(value)) .. "-")
                    --print("-" .. enc("theme.header.text") .. "-")
                    local r,g,b,a = gui.GetValue(value)
                    Control.Color[1] = r
                    Control.Color[2] = g
                    Control.Color[3] = b
                    Control.Color[4] = a
                else
                    local args = split(value, ",")
                    Control.Color[1] = args[1]
                    Control.Color[2] = args[2]
                    Control.Color[3] = args[3]
                    Control.Color[4] = args[4]
                end
            end)
            .case("text", function() 
                if string.find(value, "_") then
                    Control.Text = string.gsub(value, "_", " ")
                else
                    Control.Text = value
                end
            end)
            .default(function() print("Attribute not found. key=" .. key) end)
            .process()
    end

    local Font = draw.CreateFont(Control.FontFamily, Control.FontHeight, Control.FontWeight)

    Control.CreatedFont = Font
    Control.DefaultFont = Font

    Control.ResetFont = function()
        if Control.CreatedFont ~= Control.DefaultFont then
            Control.CreatedFont = Control.DefaultFont
        end
    end

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        draw.SetFont(properties.CreatedFont);
        if properties.Alignment == nil then
            Renderer:Text({properties.X + form.X, properties.Y + form.Y}, properties.Color, properties.Text) 
        end

        if properties.Alignment == "right" then
            local Tw, Th = draw.GetTextSize(properties.Text)
            Renderer:Text({properties.X + form.X - Tw, properties.Y + form.Y}, properties.Color, properties.Text) 
        
            if properties.ShowSquare then
                Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {5,5}, {255,0,0,255})
            end
        end
        if properties.Alignment == "autosize" then
            local Tw, Th = draw.GetTextSize(properties.Text)

            if tonumber(Tw) >= tonumber(properties.Width) then
                Renderer:Text({properties.X + form.X, properties.Y + form.Y}, properties.Color, "Loading..")
                if properties.Multipler == nil then
                    properties.Multipler = .1
                else
                    properties.Multipler = properties.Multipler + .1
                end
                local Font = draw.CreateFont(properties.FontFamily, properties.FontHeight - properties.Multipler, properties.FontWeight)

                properties.CreatedFont = Font
            else
                Renderer:Text({properties.X + form.X, properties.Y + form.Y}, properties.Color, properties.Text) 
            end

            if properties.ShowSquare then
                Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width,properties.Height}, {255,0,0,255})
            end
        end

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                draw.SetFont(properties.CreatedFont);
                local Tw, Th = draw.GetTextSize(properties.Text);
                properties.Width = Tw
                properties.Height = Th

                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    if not getSelected() then
                        gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
                    end
                end
            end
        end

        return properties
    end

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName