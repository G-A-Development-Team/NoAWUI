local ControlName = 'flowlayout'
local FunctionName = 'CreateFlowLayout'


-- By: CarterPoe
function CreateFlowLayout(properties)
    local Control = CreateControl()
    Control.ScrollHeight = 20
    Control.ScrollLength = 0
    Control.MaxScrollLength = 0
    Control.Scroll = true
    Control.Orientation = "vertical"
    Control.Shadow = {0,0,0,40,25}

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x",
        "y",
        "width",
        "height",
        "scrollheight",
        "orientation",

        --Events:
        "mousehover",
        "mouseoutside",
        "mouseclick",
        "mousescroll",

        --Visuals:
        "image",
        "background",
        "shadow",
        "border",
        "roundness",

        --State
        "scroll",
    }

    Control = Control.DefaultCase(Control, properties)

    Control.AddItem = function(item)
        table.insert(Control.Children, item)
        Control.ScrollLength = 0
        Control.MaxScrollLength = 0
    end

    Control.ScrollToEnd = function()
        Control.ScrollLength = Control.MaxScrollLength
    end

    Control.Clear = function(item)
        Control.Children = {}
        Control.ScrollLength = 0
        Control.MaxScrollLength = 0
    end

    Control.RemoveItem = function(key)
        Control.Children[key] = nil
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
        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {properties.Shadow[1], properties.Shadow[2], properties.Shadow[3], properties.Shadow[4]}, properties.Shadow[5])

        --Renderer:Scissor({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height});
        
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
            else
                local c = deepcopy(control)
                c.Width = properties.Width
                if c.Text ~= nil then
                    if c.Text ~= "" then
                        c.Text = ""
                    end
                end

                c.Render(c, properties)
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
        --Renderer:Scissor({0, 0}, {w, h});

        return properties
    end

    return Control
end


--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName