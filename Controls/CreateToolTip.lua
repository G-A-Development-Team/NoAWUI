local ControlName = 'tooltip'
local FunctionName = 'CreateToolTip'

local right_click_svg = [[
<svg id="Capa_1" width="800px" height="800px" viewBox="0 0 417.031 417.031">
	<path fil="#fff" d="M219.683,92.146c-0.279-0.315-0.52-0.627-0.849-0.925c-3.644-3.272-3.742-2.306,0.247-5.983
		c2.955-2.712,6.541-4.834,9.79-7.18c8.596-6.213,14.254-14.534,18.079-24.399c8.582-22.15-16.706-37.453-29.396-50.562
		c-9.168-9.485-23.603,4.982-14.444,14.447c7.076,7.325,16.19,13.264,22.349,21.407c6.897,9.116-3.613,19.174-10.814,24.249
		c-11.133,7.844-20.757,18.262-18.533,29.434c-49.964,4.668-96.16,32.052-96.16,80.327v135.51
		c0,59.862,48.698,108.562,108.564,108.562c59.863,0,108.566-48.7,108.566-108.562V172.95
		C317.085,120.247,268.05,94.723,219.683,92.146z M120.391,172.95c0-35.833,38.898-56.581,79.186-60.027v124.982
		c-36.751-1.85-66.589-10.222-79.186-14.309V172.95z M296.648,308.461c0,48.604-39.537,88.133-88.129,88.133
		c-48.59,0-88.128-39.529-88.128-88.133V245.08c18.249,5.516,52.6,13.882,93.202,13.882c26.003,0,54.556-3.479,83.056-13.286
		V308.461z M296.648,223.94c-25.844,9.883-52.237,13.746-76.635,14.271v-125.59c39.407,2.363,76.635,21.264,76.635,60.337V223.94z
		 M289.735,216.203c0,0-46.688,13.073-62.567,10.271V122.813C269.429,130.753,296.625,143.533,289.735,216.203z"/>
</svg>
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
                    else
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