local ControlName = 'panel'
local FunctionName = 'CreatePanel'


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
            .case("mousehover", function() Control.MouseHover = value end)
            .case("mouseoutside", function() Control.MouseOutside = value end)
            .case("width", function() Control.Width = value end)
            .case("height", function() Control.Height = value end)
            .case("dragparent", function() 
                if value == "false" then
                    Control.DragParent = false
                else
                    Control.DragParent = true
                end
            end)
            .case("mouseclick", function() Control.MouseClick = value end)
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

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
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

        Renderer:Scissor({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height});

        for _, control in ipairs(properties.Children) do

            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY

            control.Render(control, properties)

        end

        if properties.DragParent ~= nil then
            if properties.DragParent then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    if not getSelected() then
                        if input.IsButtonDown(1) then
                            form.ForceDrag = true
                        else
                            form.ForceDrag = false
                        end
                    end
                end 
            end
        end

        if properties.MouseHover ~= nil then
            if isMouseInRect(properties.X  + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                gui.Command('lua.run "' .. properties.MouseHover .. '" ')
            end
        end

        if properties.MouseOutside ~= nil then
            if isMouseInRect(properties.X  + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
            else
                gui.Command('lua.run "' .. properties.MouseOutside .. '" ')
            end
        end

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
                end
            end
        end

        if properties.Drag then
            --print(globaldragging)
            if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
                if not getSelected() then
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
        end

        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h});

        return properties
    end

    return Control
end


--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName