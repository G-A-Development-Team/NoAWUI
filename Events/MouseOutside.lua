local Event_Name = "mouseoutside"
local Event_Function = "Event_MouseOutside"

function Event_MouseOutside(properties, parent)
    if properties.MouseOutside ~= nil then
        if not isMouseInRect(properties.X  + parent.X, properties.Y + parent.Y, properties.Width, properties.Height) then
            ExecuteLuaString(properties.MouseOutside)
        end 
    end
    return properties
end

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 2
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)