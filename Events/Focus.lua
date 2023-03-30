function Event_Focus(properties)
    if isMouseInRect(properties.X, properties.Y, properties.Width, properties.Height) then
        if input.IsButtonDown(1) or input.IsButtonPressed(1) or input.IsButtonReleased(1) then
            if not getSelected() then
                FocusForm(properties.Name)
            end
        end
    end
    return properties
end