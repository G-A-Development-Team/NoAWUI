function Event_MouseOutside(properties, parent)
    if properties.MouseOutside ~= nil then
        if not isMouseInRect(properties.X  + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
            ExecuteLuaString(properties.MouseOutside)
        end 
    end
    return properties
end