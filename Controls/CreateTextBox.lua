local ControlName = 'textbox'
local FunctionName = 'CreateTextBox'


function CreateTextBox(properties)
    local Control = CreateControl()
    Control.ActiveBackground = {240, 240, 240, 255}
    Control.Background = {200, 200, 200, 255}
    Control.Roundness = {6, 6, 6, 6, 6}
    Control.Rounded = true
    Control.Width = 350
    Control.Height = 45
    Control.BorderColor = {50,50,50,120}
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

    local Font = draw.CreateFont(Control.FontFamily, Control.FontHeight, Control.FontWeight)

    Control.CreatedFont = Font
    Control.DefaultFont = Font

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
            scrollheight = 2,
        }),
    }

    --[[Control.Children[2] = CreatePanel({
        type = "panel",
        name = "apanel",
        parent = Control.Name,
        x = 44,
        y = 1,
        width = Control.Width - 10,
        height = 20,
        background = "0,0,0,0"
    })]]--

    --local a = centerTextOnRectangle({Control.Children[2].X, Control.Children[2].Y}, {Control.Children[2].Width, Control.Height}, "")
    Control.Lines = {

    }
    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)

        end

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,40}, 25)
        if properties.Rounded then            
            if properties.Selected or isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) or properties.Active then
                Renderer:FilledRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.ActiveBackground, properties.Roundness)
            else
                Renderer:FilledRoundedRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background, properties.Roundness)
            end
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

        if input.IsButtonReleased(1) then

			if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
				if not getSelected() then
					properties.Selected = not properties.Selected

				end
			else 
				properties.Selected = false
			end
		end

        Renderer:Scissor({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height});

        for _, control in ipairs(properties.Children) do

            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY

            control.Render(control, properties)

        end

        if true then

            for jkey, jvalue in ipairs(properties.Lines) do
                local Tw, Th = draw.GetTextSize(jvalue)

                if tonumber(Tw) >= tonumber(properties.Children[1].Children[1].Children[1].Width) then
                    properties.Children[1].Children[1].Width = Tw
                    properties.Children[1].Children[1].Children[1].Width = Tw
                end

                if tonumber(Th) >= tonumber(properties.Children[1].Children[1].Children[1].ScrollHeight) then
                    --properties.Children[1].Children[1].ScrollHeight = Th
                    --properties.Children[1].Children[1].Children[1].ScrollHeight = Th
                end

                local foundLine = false
                local foundIndex = 0
                for ckey, cvalue in ipairs(properties.Children[1].Children[1].Children[1].Children) do
                    if cvalue.Name == "line="..jkey then
                        foundLine = true
                        foundIndex = ckey
                    end
                end

                if foundLine == false then
                    local p = CreateLabel({
                        type = "panel",
                        name = "line="..jkey,
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
                else
                    if properties.Children[1].Children[1].Children[1].Children[foundIndex].Text ~= jvalue then
                        
                    end
                    if not string.find(jvalue, "*") then
                        properties.Children[1].Children[1].Children[1].Children[foundIndex].Text = jvalue
                        properties.Children[1].Children[1].Children[1].Children[foundIndex].Width = properties.Children[1].Children[1].Children[1].Width
                        --properties.Children[1].Children[1].Children[1].Children[foundIndex].Height = Th + 5
    
                        --properties.Children[1].Children[1].Height = properties.Children[1].Children[1].Height + Th + 5
                        --properties.Children[1].Children[1].Children[1].Height = properties.Children[1].Children[1].Children[1].Height + Th + 5
                        --properties.Children[1].Children[1].Children[1].AddItem(p)
        
                        properties.Children[1].Width = properties.Children[1].Children[1].Width + (properties.Children[1].Children[1].SetX*2) 
                        properties.Lines[jkey] = properties.Lines[jkey] .. "*"
                    end
                    --properties.Children[1].Height = properties.Children[1].Children[1].Height + (properties.Children[1].Children[1].SetY*2) 
                end

                --table.remove(properties.Lines, jkey)
                --properties.Children[1].Children[2].SetX = properties.Children[1].Width - properties.Children[1].Children[2].Width - 5
                --properties.Children[1].Children[2].Background = {255,255,255,255}

            end
            --properties.Init = true
            
        end

        if properties.Selected then
            for i = 3, 255, 1 do
                if input.IsButtonReleased(i) then
                    local maxlength = #properties.Lines
                    
                    if maxlength == 0 then
                        properties.Lines[1] = ""
                        maxlength = 1
                    end
                    
                    if properties.Lines[maxlength] == nil then
                        properties.Lines[maxlength] = ""
                    end

                    local Tw, Th = draw.GetTextSize(properties.Lines[maxlength]:gsub("*", "") .. TranslateKeyCode(i))

                    local Twl, Thl = nil, nil
                    if properties.Lines[maxlength - 1] ~= nil then
                        local Twlc, Thlc = draw.GetTextSize(properties.Lines[maxlength - 1]:gsub("*", "") .. TranslateKeyCode(i)) 
                        Twl = Twlc
                        Thl = Thlc
                    end

                    if TranslateKeyCode(i):lower() == "backspace" then
                        if properties.Lines[maxlength]:gsub("*", "") == "" then
                            properties.Lines[maxlength - 1] = properties.Lines[maxlength - 1]:gsub("*", ""):sub(1, -2)
                            properties.Lines[maxlength] = nil
                        else
                            properties.Lines[maxlength] = properties.Lines[maxlength]:gsub("*", ""):sub(1, -2)
                        end
                        break
                    end
                    if Tw >= (properties.Width-9) then
                        if properties.Lines[maxlength + 1] == nil then
                            properties.Lines[maxlength + 1] = ""
                        end
                        properties.Lines[maxlength + 1] = properties.Lines[maxlength + 1]:gsub("*", "") .. TranslateKeyCode(i)
                    else
                        if Twl ~= nil then
                            if Twl <= (properties.Width-9) then
                                properties.Lines[maxlength - 1] = properties.Lines[maxlength - 1]:gsub("*", "") .. TranslateKeyCode(i)
                                --properties.Lines[maxlength] = nil
                            else
                                properties.Lines[maxlength] = properties.Lines[maxlength]:gsub("*", "") .. TranslateKeyCode(i)
                            end
                        else
                            properties.Lines[maxlength] = properties.Lines[maxlength]:gsub("*", "") .. TranslateKeyCode(i)
                        end
                    end
                    --table.insert(properties.Lines, TranslateKeyCode(i))
                    --[[print(TranslateKeyCode(i))
                    
                    local Tw, Th = draw.GetTextSize(TranslateKeyCode(i))
                    local panel = CreatePanel({
                        type = "panel",
                        name = tostring(math.random(1, 342)).."apanel",
                        parent = properties.Children[1].Name,
                        x = 0,
                        y = 0,
                        width = Tw,
                        height = Th,
                        background = "0,0,0,0",
                    })


                    panel.Children[1] = CreateLabel({
                        type = "label",
                        name = tostring(math.random(1, 342)).."alabel",
                        parent = panel.Name,
                        x = 0,
                        y = 0,
                        color = "0,0,0,255",
                        text = TranslateKeyCode(i)
                    })

                    properties.Children[1].AddItem(panel)
                    if Tw ~= nil then
                        print("TW", Tw)
                        properties.Children[1].ScrollLength = properties.Children[1].ScrollLength + Tw
                    end--]]
                    
                    --Control.Children[1].ScrollLength = Control.Children[1].ScrollLength + 1                
                end
            end
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
