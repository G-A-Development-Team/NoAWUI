local Event_Name = "toggle"
local Event_Function = "Event_Toggle"

function Event_Toggle(properties)
    if properties.Toggle ~= nil then
        if input.IsButtonPressed(properties.Toggle) then
            properties.Visible = not properties.Visible
            if properties.OnToggle ~= nil and properties.Visible then
                ExecuteLuaString(properties.OnToggle)
            end
            if not properties.Visible then
                if properties.Unload ~= nil then
                    ExecuteLuaString(properties.Unload)
                end
            end
        end
        properties.dummywindow:SetActive(properties.Visible)
    end
    return properties
end

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 1
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)