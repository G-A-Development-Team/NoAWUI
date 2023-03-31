local Event_Name = "mouseclick"
local Event_Function = "Event_MouseClick"

function Event_MouseClick(properties, parent)
    if properties.MouseClick ~= nil then
        if input.IsButtonReleased(1) then
            if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
                ExecuteLuaString(properties.MouseClick)
            end
        end
    end
    return properties
end

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 2
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)