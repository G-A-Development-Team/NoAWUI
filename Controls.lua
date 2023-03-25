
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
        MAX_DRAG_DISTANCE = 0,

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
        Selected = false,
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
    local Control = CreateControl()
    Control.ReferenceTab = nil

    for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("type", function() Control.Type = value end)
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

-- By: CarterPoe
function CreatePictureListBox(properties)
    local Control = CreateControl()
    Control.ActiveBackground = {240, 240, 240, 255}
    Control.Background = {200, 200, 200, 255}
    Control.Roundness = {6, 6, 6, 6, 6}
    Control.Rounded = true
    Control.Width = 350
    Control.StartWidth = 350
    Control.Height = 45
    Control.StartHeight = 45
    Control.BorderColor = {50,50,50,120}
    Control.ItemHoverColor = {60,60,60,150}
    Control.ItemBackground = {30,30,30,120}
    Control.ItemHeight = 70
    Control.ListHeight = 215
	Control.PreviousIndex = 0
	Control.SelectedIndex = 0
	Control.ChangedStatus = false
    for key, value in pairs(properties) do
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("group", function() Control.Group = value end)
            .case("parent", function() Control.Parent = value end)
            .case("type", function() Control.Type = value end)
            .case("x", function() Control.X = value Control.SetX = value end)
            .case("y", function() Control.Y = value Control.SetY = value end)
            .case("width", function() Control.Width = value Control.StartWidth = value end)
            .case("height", function() Control.Height = value Control.StartHeight = value  end)
            .case("dragparent", function() 
                if value == "false" then
                    Control.DragParent = false
                else
                    Control.DragParent = true
                end
            end)
            .case("mouseclick", function() Control.MouseClick = value end)
			.case("changeevent", function() Control.ChangeEvent = value end)
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
        --end
    end

    local Font = draw.CreateFont(Control.FontFamily, Control.FontHeight, Control.FontWeight)

    Control.CreatedFont = Font
    Control.DefaultFont = Font

    if Control.Parent ~= nil then
        Control.FormName = "" 
    end

    Control.Children = {
        [1] = CreateFlowLayout({
            type = "flowlayout",
            name = tostring(math.random(1, 342)) .. Control.Name .. "flowlayout",
            parent = Control.Name,
            x = 1,
            y = Control.StartHeight,
            width = Control.Width - 2,
            height =  Control.ListHeight,
            background = "15,15,15,255",
            roundness = "6,0,0,6,6",
            scrollheight = Control.ItemHeight + 1,
        }),
    }

    Control.Children[2] = CreatePanel({
        type = "panel",
        name = "apanel",
        parent = Control.Name,
        x = 44,
        y = 1,
        width = Control.Width - 55,
        height = 20,
        background = "0,0,0,0"
    })

    local a = centerTextOnRectangle({Control.Children[2].X, Control.Children[2].Y}, {Control.Children[2].Width, Control.Height}, "")


    Control.Children[3] = CreateLabel({
        type = "label",
        name = "alabel",
        parent = Control.Name,
        x = 44,
        y = a.Y - 4,
        width = Control.Width - 55,
        height = 20,
        color = "0,0,0,255",
        alignment = "autosize",
        text = ""
    })

    ListBox = {}

    function ListBox:Event(args)
        local type = split(args, ",")[3]
        local child = getControl(dec(split(args, ",")[1]))
        local flow_parent = getControl(dec(split(args, ",")[2]))
        local parent = getParentControl(flow_parent)
        switch(type:lower())
            .case("inside", function() child.Background = parent.ItemHoverColor end)
            .case("outside", function() child.Background = parent.ItemBackground end)
            .case("click", function()
                local Index = 0
                for i, childr in ipairs(flow_parent.Children) do
                    if childr.Name == child.Name then
                        Index = i
                    end
                end
				parent.SelectedIndex = Index
                parent.SelectedItem = {
                    Index = Index,
                    Name = child.Children[1].Text,
                    Image = child.Children[2].Image,
                    ImageData = child.Children[2].BackgroundImage
                }
                --print(parent.GetSelectedItem().Index, parent.GetSelectedItem().Name, parent.GetSelectedItem().Image)
                parent.Selected = false
                --Control.RemoveItem(parent.GetSelectedItem().Index)
            
            end)
        .default(function() print("Attribute not found.") end)
        .process() 
    end

    Control.GetSelectedItem = function()
        return Control.SelectedItem
    end

    Control.RemoveItem = function(index)
        if index == Control.SelectedItem.Index then
            Control.SelectedItem = nil
        end
        table.remove(Control.Children[1].Children, index)
    end

    Control.AddItem = function(picture, title)
        local panel = CreatePanel({
            type = "panel",
            name = "item_" .. title,
            parent = Control.Children[1].Name,
            x = 1,
            y = 1,
            width = Control.Children[1].Width - 2,
            height = Control.ItemHeight,
            background = Control.ItemBackground,
            border = "50,50,50,0",
            mousehover = "ListBox:Event('" .. enc("item_" .. title) .. "," .. enc(Control.Children[1].Name) .. ",inside')",
            mouseoutside = "ListBox:Event('" .. enc("item_" .. title) .. "," .. enc(Control.Children[1].Name) .. ",outside')",
            mouseclick = "ListBox:Event('" .. enc("item_" .. title) .. "," .. enc(Control.Children[1].Name) .. ",click')",
        })


        panel.Children[3] = CreatePanel({
            type = "panel",
            name = "textholder" .. title,
            parent = "item_" .. title,
            background = "0,0,0,0",
            width = Control.Children[1].Width - 100,
            height = 10,
            x = 65,
            y = centerTextOnRectangle({panel.X, panel.Y}, {panel.Width, panel.Height}, title).Y - 3,

        })
        local a = centerTextOnRectangle({panel.Children[3].X, panel.Children[3].Y}, {panel.Children[3].Width, panel.Children[3].Height}, title)
        panel.Children[1] = CreateLabel({
            type = "label",
            name = "label_" .. title,
            parent = "item_" .. title,
            color = "255,255,255,255",
            x = 75,
            y = a.Y,
            text = title,
            alignment = "autosize",
            width = panel.Children[3].Width,
            height = panel.Children[3].Height
        })

        panel.Children[2] = CreatePictureBox({
            type = "picturebox",
            name = "picturebox" .. title,
            parent = "item_" .. title,
            background = "255,255,255,255",
            x = 5,
            y = 5,
            width = 60,
            height = 60,
            image = picture
        })
        

        Control.Children[1].Children[#Control.Children[1].Children+1] = panel
    end

    if properties["items"] ~= nil then
        for jkey, jvalue in ipairs(properties["items"]) do
            Control.AddItem(jvalue["image"], jvalue["name"])
        end
    end
    --[[
    for i = 1,69 do
        local panel = CreatePanel({
            type = "panel",
            name = "paneltest" .. i,
            parent = Control.Children[1].Name,
            x = 1,
            y = 1,
            width = Control.Children[1].Width - 2,
            height = Control.ItemHeight,
            background = Control.ItemBackground,
            border = "50,50,50,0",
            mousehover = "ListBox:Event('" .. "paneltest" .. i .. "," .. Control.Children[1].Name .. ",inside')",
            mouseoutside = "ListBox:Event('" .. "paneltest" .. i .. "," .. Control.Children[1].Name .. ",outside')"
        })
        panel.Children[1] = CreateLabel({
            type = "label",
            name = "labeltest" .. i,
            parent = "paneltest" .. i,
            color = "255,255,255,255",
            x = centerTextOnRectangle({panel.X, panel.Y}, {panel.Width, panel.Height}, "Item" .. i).X,
            y = centerTextOnRectangle({panel.X, panel.Y}, {panel.Width, panel.Height}, "Item" .. i).Y - 3,
            text = "Item" .. i
        })

        panel.Children[2] = CreatePictureBox({
            type = "picturebox",
            name = "pictureboxtest" .. i,
            parent = "paneltest" .. i,
            background = "255,255,255,255",
            x = 5,
            y = 5,
            width = 60,
            height = 60,
            image = "jpg,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg"
        })
        

        Control.Children[1].Children[#Control.Children[1].Children+1] = panel
    end]]--


    Control.Render = function(properties, form)
        --print(getTopmostParent(properties.Name).Name)
        
        --print(AmIAllowed(properties))
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
        draw.SetFont(properties.CreatedFont);
        if properties.SelectedItem ~= nil then
            if properties.SelectedItem.DidReset == nil then
                properties.Children[3].ResetFont() 
                properties.SelectedItem.DidReset = true
            end

            local a = centerTextOnRectangle({properties.Children[2].X, properties.Children[2].Y}, {properties.Children[2].Width, properties.Height}, properties.SelectedItem.Name)
            
            properties.Children[3].Y = a.Y - 4
            properties.Children[3].Text = properties.SelectedItem.Name

            draw.SetTexture(properties.SelectedItem.ImageData)
            Renderer:FilledRectangle({properties.X + form.X + 4, properties.Y + form.Y + 3}, {40, properties.StartHeight - 5}, properties.Background)
            draw.SetTexture(nil)


        end
		
		--[[
        if input.IsButtonReleased(2) then
            if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height)  then
                properties.Selected = not properties.Selected
            else
                --properties.Selected = false
            end
        end
		]]--
        if properties.Selected then
            properties.Height = properties.Children[1].Height + properties.StartHeight + 1
            properties.Children[1].Visible = true
        else
            properties.Height = properties.StartHeight
            properties.Children[1].Visible = false
        end

        for _, control in ipairs(properties.Children) do

            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY

            --local newproperties = deepcopy(properties)
            --newproperties.X = newproperties.X + form.X
            --newproperties.Y = newproperties.Y + form.Y

            control.Render(control, properties)

        end

        if properties.DragParent ~= nil then
            if properties.DragParent then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) and not getSelected() then
                    if input.IsButtonDown(1) then
                        form.ForceDrag = true
                    else
                        form.ForceDrag = false
                    end
                end 
            end
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
		
		-- Runs the Changed Picture code if the previous index was not the same
		if properties.PreviousIndex ~= properties.SelectedIndex then
			properties.PreviousIndex = properties.SelectedIndex
			print(properties.ChangeEvent)
			gui.Command('lua.run "' .. properties.ChangeEvent .. '" ')
		end
		
        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h});

        return properties
    end

    return Control
end

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

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h});

        local c = getParentControl(form)

        if isMouseInRect(form.X + c.X, form.Y + c.Y, form.Width, form.Height) and not getSelected() then
            local mouseX, mouseY = input.GetMousePos()
            --properties.Children[1].X = mouseX
            --properties.Children[1].Y = mouseY
            if properties.Alignment == "dynamic" then
                for _, control in ipairs(properties.Children) do
                    control.X = mouseX
                    control.Y = mouseY
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

-- By: CarterPoe
function CreateFlowLayout(properties)
    local Control = CreateControl()
    Control.ScrollHeight = 20
    Control.ScrollLength = 0
    Control.MaxScrollLength = 0
    Control.Scroll = true
    Control.Orientation = "vertical"
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
            .case("scrollheight", function() Control.ScrollHeight = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("mousescroll", function() Control.MouseScroll = value end)
            .case("mousehover", function() Control.MouseHover = value end)
            .case("mouseoutside", function() Control.MouseOutside = value end)
            .case("scroll", function() 
                if value == "false" then
                    Control.Scroll = false
                else
                    Control.Scroll = true
                end
             end)
            .case("orientation", function() Control.Orientation = value:lower() end)
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
    end

    Control.AddItem = function(item)
        table.insert(Control.Children, item)
        Control.ScrollLength = 0
        Control.MaxScrollLength = 0
    end

    Control.Clear = function(item)
        Control.Children = {}
        Control.ScrollLength = 0
        Control.MaxScrollLength = 0
    end

    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
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

        if input.GetMouseWheelDelta() ~= 0 and isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) and properties.Scroll then
            if properties.MouseScroll ~= nil then
                gui.Command('lua.run "' .. properties.MouseScroll .. '" ')
            end
            if input.GetMouseWheelDelta() == -1 then
                local future = properties.ScrollLength - properties.ScrollHeight
                --print(future, properties.MaxScrollLength)
                if future < properties.MaxScrollLength then

                else
                    if future ~= properties.MaxScrollLength then
                        if properties.Orientation == "vertical" then
                            properties.Children[1].SetY = properties.Children[1].SetY - properties.ScrollHeight
                        elseif properties.Orientation == "horizontal" then

                            properties.Children[1].SetX = properties.Children[1].SetX - properties.ScrollHeight 
                        end
                        properties.ScrollLength = properties.ScrollLength - properties.ScrollHeight 
                    end
                end
            elseif properties.ScrollLength ~= 0 then
                if properties.Orientation == "vertical" then
                    properties.Children[1].SetY = properties.Children[1].SetY + properties.ScrollHeight
                elseif properties.Orientation == "horizontal" then
                    properties.Children[1].SetX = properties.Children[1].SetX + properties.ScrollHeight
                end
                properties.ScrollLength = properties.ScrollLength + properties.ScrollHeight
            end
        end

        local total = 0
        for _, control in ipairs(properties.Children) do
            control.X = form.X + control.SetX
            control.Y = form.Y + control.SetY
            
            if properties.Children[_-1] ~= nil then
                if properties.Orientation == "vertical" then
                    control.Y = control.SetY + properties.Children[_-1].Height + properties.Children[_-1].Y
                elseif properties.Orientation == "horizontal" then
                    control.X = control.SetX + properties.Children[_-1].Width + properties.Children[_-1].X
                end
            end
            if properties.Orientation == "vertical" then
                total = total + control.Height + control.SetY
            elseif properties.Orientation == "horizontal" then
                total = total + control.Width + control.SetX
            end

            local controlViewing = isRectInRect(control.X + properties.X, control.Y + properties.Y, control.Width, control.Height, properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height)
            --local controlPartial = isRectInRectPartial(control.X + properties.X, control.Y + properties.Y, control.Width, control.Height, properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height)

            if controlViewing then
                control.Render(control, properties)
            --elseif controlPartial then
            end
        end
        
        if properties.MaxScrollLength == 0 then
            properties.MaxScrollLength = -total
        end

        --Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {5, properties.Height}, {255,255,255,255})
        --Renderer:FilledRectangle({properties.X + form.X + 1, properties.Y + form.Y + 1}, {3, properties.Height * (properties.Height / math.abs(properties.MaxScrollLength))}, {0,0,0,255})
        --print(properties.MaxScrollLength)

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

-- By: Agentsix1
function CreatePictureBox(properties)
    local Control = CreateControl()
    Control.BackgroundImage = nil
	
	Control.ChangeImage = function (properties, src, img)
		
		switch(img:lower())
            .case("jpg", function() 
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
                Control.Image = value
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
        if not properties.Visible or not form.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
        end

        if properties.BackgroundImage == nil then
            local args = split(properties.Image, ",")
            local src = args[2]
            local imgtype = args[1]
            switch(imgtype:lower())
                .case("jpg", function() 
                    
                    local jpgData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                        Control.BackgroundImage = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    
                    
                end)
                .case("png", function() 
                    local pngData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                        Control.BackgroundImage = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    
                end)
                .case("svg", function() 
                    local svgData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                        Control.BackgroundImage =  draw.CreateTexture(imgRGBA, imgWidth, imgHeight);			
                end)
                .default(function() print("Attribute not found. key=" .. key) end)
                .process()
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
        if not properties.Visible or not form.Visible then
            return properties
        end
		
		-- Drag function
        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
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
                    if not getSelected() then
                        panorama.RunScript([[
                            SteamOverlayAPI.OpenURL("]] .. properties.URL .. [[")
                       ]])
						
						gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
						
                    end
                end
            end
        end
		
		-- Renders the children of the current gui object
        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end
		
		if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) and not getSelected() then
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
        if not properties.Visible or not form.Visible then
            return properties
        end
		
		-- Drag function
        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
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
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width+properties.TextWidth, properties.Height) and not getSelected() then
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
		
		if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width+properties.TextWidth, properties.Height) and not getSelected() then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			properties.TextColor = { r, g, b, a }
        else
			properties.TextColor = {255,255,255,255}
		end
		
		return properties
    end

    return Control
end