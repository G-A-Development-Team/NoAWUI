local ControlName = 'picturelistbox'
local FunctionName = 'CreatePictureListBox'

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
    Control.Animations = {
        Selection = 0
    }

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x",
        "y",
        "width",
        "height",

        --Events:
        "mouseclick",
        "changeevent",

        --Visuals:
        "image",
        "background",
        "active",
        "border",
        "roundness",
    }

    Control = Control.DefaultCase(Control, properties)

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
            imageurl = picture
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
                properties.Children[3]:ResetFont() 
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


--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName