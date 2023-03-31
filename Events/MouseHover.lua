local Event_Name = "mousehover"
local Event_Function = "Event_MouseHover"

function Event_MouseHover(properties, parent)
    if properties.MouseHover ~= nil then
        if isMouseInRect(properties.X  + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
            ExecuteLuaString(properties.MouseHover)
        end
    end
    return properties
end

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 2
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)