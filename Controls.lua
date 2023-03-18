
-- By: CarterPoe
function CreateControl()
    return {
        Type = "control",
        Group = "",
        Name = "",
        X = 0,
        Y = 0,
        SetX = 0,
        SetY = 0,
        AdditionalX = 0,
        AdditionalY = 0,
        AdditionalWidth = 0,
        AdditionalHeight = 0,
        Width = 0,
        Height = 0,
        Drag = false,
        Background = {0, 0, 0, 0},
        ActiveBackground = {0, 0, 0, 0},
        Color = {0, 0, 0, 0},
        BorderColor = {0, 0, 0, 0},
        Children = {},
        Parent = "",
        MouseDown = "",

        isDragging = false,
        dragOffsetX = 0,
        dragOffsetY = 0,
        lastMouseX = 0,
        lastMouseY = 0,
        MAX_DRAG_DISTANCE = 10,

        Roundness = {},
        Rounded = false,

        Text = "",
        FontFamily = "Arial",
        FontHeight = 21,
        FontWeight = 100,
        CreatedFont = nil,

        Reference = nil,

        Visible = true,
        Active = false,
        BackgroundImage = nil,
        CreatedBackgroundImage = false,

        Render = function(properties) end,
        AWInitV = false,
        AWInit = function(properties, x, y, x2, y2)
            if true then
                properties.X = x + properties.AdditionalX
                properties.Y = y + properties.AdditionalY
                properties.Width = x2 -properties.X + properties.AdditionalWidth
                properties.Height = y2 -properties.Y + properties.AdditionalHeight
                properties.AWInitV = true 
            end
            return properties
        end,
    }
end


-- By: CarterPoe
function CreateAWTab(properties)
    local Control = {
        X = 0,
        Y = 0,
        Width = 0,
        Height = 0,
        Type = "awtab",
        Name = "",
        Category = "",
        VarName = "",
        ReferenceTab = nil,
        Children = {},
    }

    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("category", function() Control.Category = value end)
            .case("varname", function() Control.VarName = value end)
            .default(function() print("Attribute not found. key=" .. key) end)
            .process() 
    end
    local gui_ref = gui.Reference(Control.Category)

    Control.ReferenceTab = gui.Tab(gui_ref, Control.VarName, Control.Name)

    return Control
end

-- By: CarterPoe
function CreateForm(properties)
    local Control = CreateControl()
    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("group", function() Control.Group = value end)
            .case("parent", function() Control.Parent = value end)
            .case("type", function() Control.Type = value end)
            .case("x", function() Control.X = value end)
            .case("y", function() Control.Y = value end)
            .case("width", function() Control.Width = value end)
            .case("height", function() Control.Height = value end)
            .case("drag", function() Control.Drag = value end)
            .case("image", function() 
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    print(src)
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
	
    Control.Render = function(properties)
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

        if properties.Drag then
            --print(globaldragging)
            if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
                if true then
                    if input.IsButtonDown(1) then
                        
                        local mouseX, mouseY = input.GetMousePos();
                        if not properties.isDragging then
                            -- start dragging
                            properties.isDragging = true
                            properties.dragOffsetX = mouseX - properties.X
                            properties.dragOffsetY = mouseY - properties.Y
         
                        else
                            local dx, dy = mouseX - properties.lastMouseX, mouseY - properties.lastMouseY
                            local distance = math.sqrt(dx * dx + dy * dy)
            
                            if distance > properties.MAX_DRAG_DISTANCE then
                                dx, dy = dx / distance * properties.MAX_DRAG_DISTANCE, dy / distance * properties.MAX_DRAG_DISTANCE
                            end
                            -- update window position
                            properties.X = mouseX - properties.dragOffsetX + dx
                            properties.Y = mouseY - properties.dragOffsetY + dy
                        end
                        properties.lastMouseX = mouseX
                        properties.lastMouseY = mouseY
            
                    else
                        -- stop dragging
                        properties.isDragging = false
                    end 
                else
                  
                end
            end
        end

        return properties
    end
	
    return Control
end

-- By: CarterPoe
function CreatePanel(properties)
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
            .case("drag", function() Control.Drag = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("image", function() 
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    print(src)
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

    Control.Render = function(properties, form)
        if not properties.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            print(properties.X + form.X)
            
        end

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,40}, 25)
        if properties.Rounded then
            Renderer:FilledRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background, properties.Roundness)
            Renderer:OutlinedRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)
        else
            if properties.BackgroundImage ~= nil then
                draw.SetTexture(properties.BackgroundImage)
            end
            Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background)
            draw.SetTexture(nil)
            Renderer:OutlinedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor)
        end

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    gui.Command('lua.run "' .. properties.MouseClick .. '" ')
                end
            end
        end

        for _, control in ipairs(properties.Children) do

            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY

            control.Render(control, properties)

        end

        if properties.Drag then
            --print(globaldragging)
            if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
                if true then
                    if input.IsButtonDown(1) then

                        local mouseX, mouseY = input.GetMousePos();
                        if not properties.isDragging then
                            -- start dragging
                            properties.isDragging = true
                            properties.dragOffsetX = mouseX - properties.X
                            properties.dragOffsetY = mouseY - properties.Y

                        else
                            local dx, dy = mouseX - properties.lastMouseX, mouseY - properties.lastMouseY
                            local distance = math.sqrt(dx * dx + dy * dy)

                            if distance > properties.MAX_DRAG_DISTANCE then
                                dx, dy = dx / distance * properties.MAX_DRAG_DISTANCE, dy / distance * properties.MAX_DRAG_DISTANCE
                            end
                            -- update window position
                            properties.X = mouseX - properties.dragOffsetX + dx
                            properties.Y = mouseY - properties.dragOffsetY + dy
                        end
                        properties.lastMouseX = mouseX
                        properties.lastMouseY = mouseY

                    else
                        -- stop dragging
                        properties.isDragging = false
                    end
                else

                end
            end
        end

        return properties
    end

    return Control
end

-- By: CarterPoe
function CreateFlowLayout(properties)
    local Control = CreateControl()
    Control.ScrollHeight = 20
    Control.ScrollLength = 0
    Control.MaxScrollLength = 0
    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("group", function() Control.Group = value end)
            .case("parent", function() Control.Parent = value end)
            .case("type", function() Control.Type = value end)
            .case("x", function() Control.X = value end)
            .case("y", function() Control.Y = value end)
            .case("width", function() Control.Width = value end)
            .case("height", function() Control.Height = value end)
            .case("drag", function() Control.Drag = value end)
            .case("scrollheight", function() Control.ScrollHeight = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("image", function() 
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    print(src)
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
    end

    Control.Render = function(properties, form)
        if not properties.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            print(properties.X + form.X)
            
        end

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,40}, 25)
        Renderer:Scissor({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height});
        
        if properties.Rounded then
            Renderer:FilledRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background, properties.Roundness)
            Renderer:OutlinedRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor, properties.Roundness)
        else
            if properties.BackgroundImage ~= nil then
                draw.SetTexture(properties.BackgroundImage)
            end
            Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background)
            draw.SetTexture(nil)
            Renderer:OutlinedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.BorderColor)
        end
        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    gui.Command('lua.run "' .. properties.MouseClick .. '" ')
                end
            end
        end

        if input.GetMouseWheelDelta() ~= 0 and isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
            if input.GetMouseWheelDelta() == -1 then
                local future = properties.ScrollLength - properties.ScrollHeight
                print(future, properties.MaxScrollLength)
                if future < properties.MaxScrollLength then

                else
                    if future ~= properties.MaxScrollLength then
                        properties.Children[1].SetY = properties.Children[1].SetY - properties.ScrollHeight
                        properties.ScrollLength = properties.ScrollLength - properties.ScrollHeight 
                    end
                end
            elseif properties.ScrollLength ~= 0 then
                properties.Children[1].SetY = properties.Children[1].SetY + properties.ScrollHeight
                properties.ScrollLength = properties.ScrollLength + properties.ScrollHeight
            end
        end

        local total = 0
        for _, control in ipairs(properties.Children) do
            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY
            
            if properties.Children[_-1] ~= nil then
                control.Y = control.SetY + properties.Children[_-1].Height + properties.Children[_-1].Y
            end

            total = total + control.Height + control.SetY

            control.Render(control, properties)
        end
        
        if properties.MaxScrollLength == 0 then
            properties.MaxScrollLength = -total
        end

        Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {5, properties.Height}, {255,255,255,255})
        Renderer:FilledRectangle({properties.X + form.X + 1, properties.Y + form.Y + 1}, {3, properties.Height * (properties.Height / math.abs(properties.MaxScrollLength))}, {0,0,0,255})
        --print(properties.MaxScrollLength)

        if properties.Drag then
            --print(globaldragging)
            if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
                if true then
                    if input.IsButtonDown(1) then

                        local mouseX, mouseY = input.GetMousePos();
                        if not properties.isDragging then
                            -- start dragging
                            properties.isDragging = true
                            properties.dragOffsetX = mouseX - properties.X
                            properties.dragOffsetY = mouseY - properties.Y

                        else
                            local dx, dy = mouseX - properties.lastMouseX, mouseY - properties.lastMouseY
                            local distance = math.sqrt(dx * dx + dy * dy)

                            if distance > properties.MAX_DRAG_DISTANCE then
                                dx, dy = dx / distance * properties.MAX_DRAG_DISTANCE, dy / distance * properties.MAX_DRAG_DISTANCE
                            end
                            -- update window position
                            properties.X = mouseX - properties.dragOffsetX + dx
                            properties.Y = mouseY - properties.dragOffsetY + dy
                        end
                        properties.lastMouseX = mouseX
                        properties.lastMouseY = mouseY

                    else
                        -- stop dragging
                        properties.isDragging = false
                    end
                else

                end
            end
        end
        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h});

        return properties
    end

    return Control
end

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
            .case("fontheight", function() Control.FontHeight = value end)
            .case("fontweight", function() Control.FontWeight = value end)
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
        if not properties.Visible then
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
                    gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
                end
            end
        end
        

        if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
            if input.IsButtonDown(1) then
                drawing.background({35, 35, 35, 255})
            else
                drawing.background({65, 65, 65, 255})
            end
        else
            drawing.background(properties.Background)
        end

        if properties.Active then
            drawing.background(Control.ActiveBackground)
        end

        draw.SetFont(properties.CreatedFont);
        local textLoc = centerTextOnRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Text)
        Renderer:Text({textLoc.X, textLoc.Y}, properties.Color, properties.Text)

        return properties
    end

    return Control
end

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
            .case("fontfamily", function() Control.FontFamily = value end)
            .case("fontheight", function() Control.FontHeight = value end)
            .case("fontweight", function() Control.FontWeight = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("color", function()
                if string.find(value, "theme") then
                    print("-" .. enc(tostring(value)) .. "-")
                    print("-" .. enc("theme.header.text") .. "-")
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

    Control.Render = function(properties, form)
        if not properties.Visible then
            return properties
        end

        draw.SetFont(properties.CreatedFont);
        Renderer:Text({properties.X + form.X, properties.Y + form.Y}, properties.Color, properties.Text)

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                draw.SetFont(properties.CreatedFont);
                local Tw, Th = draw.GetTextSize(properties.Text);
                properties.Width = Tw
                properties.Height = Th

                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    gui.Command('lua.run "' .. properties.MouseClick .. '" ')
                end
            end
        end

        return properties
    end

    return Control
end

-- By: Agentsix1
function CreatePictureBox(properties)
    local Control = CreateControl()
	
	Control.ChangeImage = function (properties, src, img)
		
		switch(img:lower())
            .case("jpg", function() 
                print(src)
                local jpgData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
            .case("png", function() 
				local pngData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
            .case("svg", function() 
				local svgData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
			.default(function() print("Image Type not found. key=" .. key) end)
            .process()
			
	end
    
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
            .case("drag", function() Control.Drag = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("image", function() 
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    print(src)
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

    Control.Render = function(properties, form)
        if not properties.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            print(properties.X + form.X)
            
        end

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,40}, 25)
        
        if properties.BackgroundImage ~= nil then
            draw.SetTexture(properties.BackgroundImage)
		end
        Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background)
        draw.SetTexture(nil)

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    --gui.Command('lua.run "' .. properties.MouseClick .. '" ')
                end
            end
        end

        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end

        return properties
    end

    return Control
end

-- By: Agentsix1
function CreateMusicLinkButton(properties)
	-- Creates the control
    local Control = CreateControl()
	
	Control.ForeColor = {255,255,255,255}
	
	-- Setting the Player icon to the control
	Control.PlayIcon = [[
						<svg x="0px" y="0px" viewBox="0 0 1000 1000" width="40" height="40"><title>Layer 1</title>
						<path fill="#fff"  id="svg_1"  d="M393.9,770.4L720.7,500L393.9,229.7V770.4z M501.1,7.8C218.3,7.8,10,217.3,10,500.2c0,282.9,199.9,492,482.8,492c282.8,0,497.2-209.2,497.2-492C990,217.3,784,7.8,501.1,7.8z M501.1,929.3C264,929.3,71.9,737.2,71.9,500.1C71.9,263,264,70.9,501.1,70.9c237.1,0,429.2,192.1,429.2,429.2C930.4,737.2,738.2,929.3,501.1,929.3z"/>
						</svg>
					   ]]
		-- Converting Play Icon to Texture
		local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(Control.PlayIcon);
        local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
	-- Setting the PlayIconTexture to the control
	Control.PlayIconTexture = texture
	
    -- Loading setting from design to Control
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
            .case("drag", function() Control.Drag = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("url", function() Control.URL = value end)
            .case("text", function() 
				value = value:gsub("_", " ")
				Control.Text = value 
			end)
            .case("image", function()
				-- Loads the image url from design and loads it to BackgroundImage
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    print(src)
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
				-- Sets the Control Background color
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
            .case("roundness", function() 
				-- This is used to define the roundness of a rect
                local args = split(value, ",")
                Control.Roundness[1] = args[1]
                Control.Roundness[2] = args[2]
                Control.Roundness[3] = args[3]
                Control.Roundness[4] = args[4]
                Control.Roundness[5] = args[5]
                Control.Rounded = true
            end)
			-- Processes the switch bs above
            .default(function() print("Attribute not found. key=" .. key) end)
            .process() 
    end

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)
	-- This is used to create the actual gui object
    Control.Render = function(properties, form)
		-- Checks if the object should be visual
        if not properties.Visible then
            return properties
        end
		
		-- Drag function
        if string.find(properties.Name, "example_paneldrag3") then
            print(properties.X + form.X)
            
        end
		
		-- Start drawing the gui object
		
		draw.SetFont(Control.Font)
		
		-- Draw the outline of the box
		--(cord, size, outer_color, inner_color, roundness, thickness)
		Renderer:RoundedRectangleBorder({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, Control.ForeColor, {0,0,0,255}, 6, 2)
		-- Set the texture for the image
		draw.SetTexture(Control.PlayIconTexture)
		-- Draw the image
		Renderer:FilledRectangle({properties.X + form.X+(properties.Width)*0.04, properties.Y + form.Y+(properties.Height)*0.12}, {properties.Width*0.24, properties.Height*0.75}, {255,255,255,255})
		-- Remove the texture for future draws
        draw.SetTexture(nil)
		-- Draw the text values
		Renderer:TextP({properties.X + form.X+(properties.Width)*0.31, properties.Y + form.Y+(properties.Height)*0.36}, Control.ForeColor, Control.Text)
		
		-- Is used to check if the gui object has been clicked
        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    Form:ClickedMLButton(properties.Parent, properties.Name)
                end
            end
        end
		
		-- Renders the children of the current gui object
        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end
		
		if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			Control.ForeColor = { r, g, b, a }
        else
			Control.ForeColor = {255,255,255,255}
		end
		
        return properties
    end

    return Control
end

-- By: Agentsix1
function CreateCheckbox(properties)
	-- Creates the control
    local Control = CreateControl()
	
	-- Set checkmark icon
	Control.CheckIcon = [[		
		<svg fill="#fff" version="1.1" id="Capa_1" width="800px" height="800px" viewBox="0 0 45.701 45.7">
			<path d="M20.687,38.332c-2.072,2.072-5.434,2.072-7.505,0L1.554,26.704c-2.072-2.071-2.072-5.433,0-7.504
				c2.071-2.072,5.433-2.072,7.505,0l6.928,6.927c0.523,0.522,1.372,0.522,1.896,0L36.642,7.368c2.071-2.072,5.433-2.072,7.505,0
				c0.995,0.995,1.554,2.345,1.554,3.752c0,1.407-0.559,2.757-1.554,3.752L20.687,38.332z"/>
		</svg>
	]]
	
	-- Create checkmark texture
	local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(Control.CheckIcon);
    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
	
	-- Set Checkmark Texture
	Control.CheckTexture = texture
	
	-- Set default values
	Control.CheckState = false
	Control.CheckColor = {255,255,255,255}
	Control.OutlineColor = {150,150,150,255}
	Control.BackgroundColor = {56,56,56,190}
	Control.TextColor = {255,255,255,255}
	Control.HoverColor = {255,0,0,255}
	Control.TextWidth = 0
	Control.Text = ""
	
    -- Loading setting from design to Control
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
            .case("drag", function() Control.Drag = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("text", function() 
				value = value:gsub("_", " ")
				Control.Text = value 
			end)
			.case("checkstate", function() 
				if value == "true" then
					value = true
				elseif value == "false" then
					value = false
				end
				Control.CheckState = value
			end)
			-- Processes the switch bs above
            .default(function() print("Attribute not found. key=" .. key) end)
            .process() 
    end

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)
	-- This is used to create the actual gui object
    Control.Render = function(properties, form)
		-- Checks if the object should be visual
        if not properties.Visible then
            return properties
        end
		
		-- Drag function
        if string.find(properties.Name, "example_paneldrag3") then
            print(properties.X + form.X)
            
        end
		
		-- Start drawing the gui object
		
		-- Sets the font used by draw_TextP
		draw.SetFont(properties.Font)
		
		-- Draw the outline of the box
		Renderer:RoundedRectangleBorder({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.OutlineColor, properties.BackgroundColor, 6, 2)
		
		if properties.CheckState then
			local gap = 0.15
			draw.SetTexture(properties.CheckTexture)
			Renderer:FilledRectangle({properties.X + form.X + (properties.Width*gap) , properties.Y + form.Y + (properties.Width*gap)},
											{properties.Width - (properties.Width*gap*2), properties.Height - (properties.Width*gap*2)}, properties.CheckColor)
			draw.SetTexture(nil)
		end
		
		-- Renders the text values next to the checkbox
		Renderer:TextP({properties.X + form.X+(properties.Width)*1.3, properties.Y + form.Y+(properties.Height)*0.28}, properties.TextColor, properties.Text)
		
		-- Sets the textwidth for mouse click and mouse hover
		properties.TextWidth, _xx = draw.GetTextSize(properties.Text)
		
		-- Is used to check if the gui object has been clicked
        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width+properties.TextWidth, properties.Height) then
					if properties.CheckState then
						properties.CheckState = false
					else
						properties.CheckState = true
					end
                end
            end
        end
		
		-- Renders the children of the current gui object
        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end
		
		if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width+properties.TextWidth, properties.Height) then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			properties.TextColor = { r, g, b, a }
        else
			properties.TextColor = {255,255,255,255}
		end
		
		return properties
    end

    return Control
end