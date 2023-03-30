function Event_Drag(properties)
    if properties.ForceDrag ~= nil then
        properties.DragNow = properties.ForceDrag
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