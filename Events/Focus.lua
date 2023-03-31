local Event_Name = "focus"
local Event_Function = "Event_Focus"

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

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 1
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)