local ControlName = 'form'
local FunctionName = 'CreateForm'


-- By: CarterPoe
function CreateForm(properties)
    local Control = CreateControl()
    Control.DragNow = false
    Control.Focused = false
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
            .case("drag", function() 
                if value == "false" then
                    Control.Drag = false
                else
                    Control.Drag = true
                end
            end)
            .case("visible", function() Control.Visible = value
                if value == "false" then
                    Control.Visible = false
                else
                    Control.Visible = true
                end
            end)
            .case("toggle", function() 
                Control.Toggle = tonumber(value) 
                Control.dummywindow = gui.Window("dummywindow", "", 0, 0, 0, 0)
                Control.dummywindow:SetPosX(-10)
                Control.dummywindow:SetPosY(-10)
                Control.dummywindow:SetInvisible(true)
                Control.dummywindow:SetOpenKey(tonumber(value))
            end)
            .case("ontoggle", function() 
                Control.OnToggle = value
            end)
            .case("unload", function() 
                Control.Unload = value
            end)
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
	
    Control.Render = function(properties)
        if properties.Toggle ~= nil then
            
            if input.IsButtonPressed(properties.Toggle) then
                properties.Visible = not properties.Visible
                if properties.OnToggle ~= nil and properties.Visible then
                    gui.Command('lua.run "' .. properties.OnToggle .. '" ')
                end
                if not properties.Visible then
                    if properties.Unload ~= nil then
                        gui.Command('lua.run "' .. properties.Unload .. '" ')
                    end
                end
            end
            properties.dummywindow:SetActive(properties.Visible)
        end

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

        if properties.ForceDrag ~= nil then
            properties.DragNow = properties.ForceDrag
        end

        if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
            if input.IsButtonDown(1) or input.IsButtonPressed(1) or input.IsButtonReleased(1) then
                if not getSelected() then
                    FocusForm(properties.Name)
                end
            end
        end
        
        if properties.Drag or properties.DragNow then
            --print(globaldragging)
            if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) or properties.DragNow then
                if not getSelected() or properties.Selected then
                    if true then
                        if input.IsButtonDown(1) then
                            FocusForm(properties.Name)
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
                            properties.Selected = true
                
                        else
                            -- stop dragging
                            properties.Selected = false
                            properties.isDragging = false
                        end 
                    else
                      
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
WinFormControls[ControlName]['special'] = 'container'