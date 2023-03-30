function Event_MouseClick(properties, parent)
    if properties.MouseClick ~= nil then
        if input.IsButtonReleased(1) then
            if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
                if not getSelected() then
                    ExecuteLuaString(properties.MouseClick)
                end
            end
        end
    end
    return properties
end