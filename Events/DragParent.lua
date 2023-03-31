function Event_DragParent(properties, parent)
    if properties.DragParent ~= nil then
        if properties.DragParent then
            if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
                if not getSelected() then
                    if input.IsButtonDown(1) then
                        parent.ForceDrag = true
                    else
                        parent.ForceDrag = false
                    end
                end
            end
        end
    end
    return properties
end