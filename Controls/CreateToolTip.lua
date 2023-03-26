local ControlName = 'tooltip'
local FunctionName = 'CreateToolTip'

local right_click_svg = [[
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20px" height="20px" viewBox="0,0,256,256"><g fill="#ffdf00" fill-rule="nonzero" stroke="none" stroke-width="1" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10" stroke-dasharray="" stroke-dashoffset="0" font-family="none" font-weight="none" font-size="none" text-anchor="none" style="mix-blend-mode: normal"><g transform="scale(5.12,5.12)"><path d="M38.84375,0c-0.41016,0.05469 -0.74219,0.35547 -0.83984,0.75781c-0.09766,0.39844 0.0625,0.82031 0.40234,1.05469c4.85938,3.65234 8.27344,9.08594 9.28125,15.34375c0.02734,0.375 0.26563,0.70313 0.61328,0.84766c0.34766,0.14453 0.75,0.08203 1.03516,-0.16406c0.28516,-0.24609 0.41016,-0.62891 0.32031,-0.99609c-1.08984,-6.78125 -4.79687,-12.70312 -10.0625,-16.65625c-0.21484,-0.16016 -0.48437,-0.22656 -0.75,-0.1875zM24,3c-9.92578,0 -18,8.07422 -18,18v11c0,9.92578 8.07422,18 18,18c9.92578,0 18,-8.07422 18,-18v-11c0,-9.92578 -8.07422,-18 -18,-18zM37.0625,3.625c-0.41797,0.03125 -0.77344,0.32422 -0.88672,0.73047c-0.10937,0.40625 0.04297,0.83984 0.38672,1.08203c3.60547,2.90625 6.15234,7.02734 7.0625,11.75c0.10547,0.54297 0.62891,0.90234 1.17188,0.79688c0.54297,-0.10547 0.90234,-0.62891 0.79688,-1.17187c-1.00391,-5.19922 -3.81641,-9.74219 -7.78125,-12.9375c-0.17969,-0.16016 -0.41406,-0.25 -0.65625,-0.25c-0.03125,0 -0.0625,0 -0.09375,0zM23,5.0625v20.9375h-15v-5c0,-8.48437 6.64453,-15.41797 15,-15.9375zM8,28h32v4c0,8.82031 -7.17969,16 -16,16c-8.82031,0 -16,-7.17969 -16,-16z"></path></g></g></svg>
]]

-- By: CarterPoe
function CreateToolTip(properties)
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
            .case("text", function() Control.Text = value end)
            .case("alignment", function() Control.Alignment = value:lower() end)
            .case("image", function() 
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    local jpgData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .case("png", function() 
                    local pngData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .case("svg", function() 
                    local svgData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .default(function() print("Image Type not found. key=" .. key) end)
                .process() 
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
        --end
    end
    Control.Lines = {}
    if properties["lines"] ~= nil then
        for jkey, jvalue in ipairs(properties["lines"] ) do
            if string.find(jvalue, '\n') then
                local arry = split(jvalue, '\n')
                for skey, svalue in ipairs(arry) do
                    table.insert(Control.Lines, svalue)
                end
            else
                table.insert(Control.Lines, jvalue)
            end
        end
        --Control.Lines = properties["lines"]
        TablePrint(Control.Lines)
    end

    Control.Children = {
        [1] = CreatePanel({
            type = "panel",
            name = tostring(math.random(1, 342)) .. Control.Name .. "panel",
            parent = Control.Name,
            x = 0,
            y = 0,
            width = 0,
            height =  0,
            background = "50,50,50,200",
            roundness = "6,6,6,6,6",
        })
    }
    Control.Children[1].Children = {
        [1] = CreatePanel({
            type = "panel",
            name = tostring(math.random(1, 342)) .. Control.Name .. "panel2",
            parent = Control.Children[1].Name,
            x = 5,
            y = 5,
            width = 0,
            height =  0,
            background = "0,0,0,0",
        }),
        [2] = CreatePanel({
            type = "panel",
            name = tostring(math.random(1, 342)) .. Control.Name .. "panelmousehelp",
            parent = Control.Children[1].Name,
            x = 0,
            y = 5,
            width = 20,
            height =  20,
            background = "0,0,0,0",
            image = "svgdata," .. right_click_svg
        })
    }
    
    Control.Children[1].Children[1].Children = {
        [1] = CreateFlowLayout({
            type = "flowlayout",
            name = tostring(math.random(1, 342)) .. Control.Children[1].Name .. "flowlayout",
            parent = Control.Children[1].Children[1].Name,
            x = 0,
            y = 0,
            width = 0,
            height =  0,
            background = "0,0,0,0",
            roundness = "6,6,6,6,6",
            scrollheight = 15,
            shadow = "0,0,0,0,0"
        }),
    }

    Control.Toggled = false

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h});

        local c = getParentControl(form)

        if isMouseInRect(form.X + c.X, form.Y + c.Y, form.Width, form.Height) and not getSelected() or properties.Toggled then
            local mouseX, mouseY = input.GetMousePos()
            --properties.Children[1].X = mouseX
            --properties.Children[1].Y = mouseY
            if properties.Alignment == "dynamic" then
                for _, control in ipairs(properties.Children) do
                    if properties.Toggled then
                        if control.X ~= 0 and control.Y ~= 0 and properties.Toggled then
                            control.X = control.X
                            control.Y = control.Y
                        else
                            control.X = mouseX
                            control.Y = mouseY
                        end
                        properties.Children[1].Children[2].Visible = false
                    else
                        properties.Children[1].Children[2].Visible = true
                        control.X = mouseX
                        control.Y = mouseY
                    end
                    if input.IsButtonPressed(2) then
                        properties.Toggled = not properties.Toggled
                    end
                    if input.IsButtonDown(1) then
                        properties.Toggled = false
                    end
                    control.Render(control, properties)
                end


                if properties.Init == nil then
                    for jkey, jvalue in ipairs(properties.Lines) do
                        local Tw, Th = draw.GetTextSize(jvalue)

                        if tonumber(Tw) >= tonumber(properties.Children[1].Children[1].Children[1].Width) then
                            properties.Children[1].Children[1].Width = Tw
                            properties.Children[1].Children[1].Children[1].Width = Tw
                        end

                        if tonumber(Th) >= tonumber(properties.Children[1].Children[1].Children[1].ScrollHeight) then
                            properties.Children[1].Children[1].ScrollHeight = Th
                            properties.Children[1].Children[1].Children[1].ScrollHeight = Th
                        end

                        local p = CreateLabel({
                            type = "panel",
                            name = enc(jvalue),
                            parent = properties.Children[1].Children[1].Children[1].Name,
                            x = 0,
                            y = 0,
                            width = properties.Children[1].Children[1].Children[1].Width,
                            height = Th + 5,
                            text = jvalue,
                            color = "255,255,255,255"
                        })
                        properties.Children[1].Children[1].Height = properties.Children[1].Children[1].Height + Th + 5
                        properties.Children[1].Children[1].Children[1].Height = properties.Children[1].Children[1].Children[1].Height + Th + 5
                        properties.Children[1].Children[1].Children[1].AddItem(p)

                        properties.Children[1].Width = properties.Children[1].Children[1].Width + (properties.Children[1].Children[1].SetX*2)
                        properties.Children[1].Height = properties.Children[1].Children[1].Height + (properties.Children[1].Children[1].SetY*2)

                        properties.Children[1].Children[2].SetX = properties.Children[1].Width - properties.Children[1].Children[2].Width - 5
                        properties.Children[1].Children[2].Background = {255,255,255,255}

                    end
                    properties.Init = true
                    
                end

                --local cords = centerRectAbovePoint(mouseX, mouseY, Tw + 10, Th)
                --Renderer:FilledRoundedRectangle({cords.X, cords.Y}, {Tw + 10, Th}, {60,60,60,220}, {3,3,3,3,3})
            end
            if properties.Alignment == "static" then
                local Tw, Th = draw.GetTextSize(properties.Text)

                local cords = centerRect(Tw + 10, Th + 10, form.X + c.X, form.Y + c.Y, form.Width, form.Height)
                --local cordsT = centerTriangleInRect(cords.X + 9, cords.Y - 5, cords.X - 9, cords.Y - 5, cords.X, cords.Y + 5, cords.X, (cords.Y - cords.Height) - 25, cords.Width, cords.Height)

                Renderer:FilledRoundedRectangle({cords.X, (cords.Y - cords.Height) - 25}, {cords.Width, cords.Height}, {60,60,60,220}, {3,3,3,3,3})
                --Renderer:Triangle({cords.X + 9 , cords.Y - 5}, {cords.X - 9, cords.Y - 5}, {cords.X, cords.Y + 5}, {60,60,60,220})
                --Renderer:Triangle({cordsT.X1, cordsT.Y1}, {cordsT.X2, cordsT.Y2}, {cordsT.X3, cordsT.Y3}, {60,60,60,220})

                --Renderer:FilledRoundedRectangle({form.X + c.X, form.Y + c.Y - 35}, {Tw + 10, Th + 10}, {60,60,60,220}, {3,3,3,3,3})
                Renderer:Text({cords.X + 5, (cords.Y - cords.Height) - 22}, {255,255,255,255}, properties.Text)
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