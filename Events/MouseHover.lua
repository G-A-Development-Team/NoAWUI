function Event_MouseHover(properties, parent)
    if properties.MouseHover ~= nil then
        if isMouseInRect(properties.X  + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
            ExecuteLuaString(properties.MouseHover)
        end
    end
    return properties
end