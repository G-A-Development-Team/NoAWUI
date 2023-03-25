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
            .case("fontheight", function() Control.FontHeight = tonumber(value) end)
            .case("fontweight", function() Control.FontWeight = tonumber(value) end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("text", function() 
                if string.find(value, "_") then
                    Control.Text = string.gsub(value, "_", " ")
                else
                    Control.Text = value
                end
            end)
            .case("background", function() 
                if string.find(value, "theme") then
                    local r,g,b,a = gui.GetValue(value)
                    Control.Background[1] = r
                    Control.Background[2] = g
                    Control.Background[3] = b
                    Control.Background[4] = a
                else
                    local args = split(value, ",")
                    Control.Background[1] = args[1]
                    Control.Background[2] = args[2]
                    Control.Background[3] = args[3]
                    Control.Background[4] = args[4]
                end
            end)
            .case("active", function() 
                if string.find(value, "theme") then
                    local r,g,b,a = gui.GetValue(value)
                    Control.ActiveBackground[1] = r
                    Control.ActiveBackground[2] = g
                    Control.ActiveBackground[3] = b
                    Control.ActiveBackground[4] = a
                else
                    local args = split(value, ",")
                    Control.ActiveBackground[1] = args[1]
                    Control.ActiveBackground[2] = args[2]
                    Control.ActiveBackground[3] = args[3]
                    Control.ActiveBackground[4] = args[4]
                end
            end)
            .case("border", function() 
                if string.find(value, "theme") then
                    local r,g,b,a = gui.GetValue(value)
                    Control.BorderColor[1] = r
                    Control.BorderColor[2] = g
                    Control.BorderColor[3] = b
                    Control.BorderColor[4] = a
                else
                    local args = split(value, ",")
                    Control.BorderColor[1] = args[1]
                    Control.BorderColor[2] = args[2]
                    Control.BorderColor[3] = args[3]
                    Control.BorderColor[4] = args[4]
                end
            end)
            .case("roundness", function() 
                local args = split(value, ",")
                Control.Roundness[1] = args[1]
                Control.Roundness[2] = args[2]
                Control.Roundness[3] = args[3]
                Control.Roundness[4] = args[4]
                Control.Roundness[5] = args[5]
                Control.Rounded = true
            end)
            .default(function() print("Attribute not found. key=" .. key) end)
            .process()
    end

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