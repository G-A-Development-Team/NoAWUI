function Event_Toggle(properties)
    if properties.Toggle ~= nil then
        if input.IsButtonPressed(properties.Toggle) then
            properties.Visible = not properties.Visible
            if properties.OnToggle ~= nil and properties.Visible then
                gui.Command('lua.run "' .. properties.OnToggle .. '" ')
            end
            if not properties.Visible then
                if properties.Unload ~= nil then
                    gui.Command('lua.run "' .. properties.Unload .. '" ')
                end
            end
        end
        properties.dummywindow:SetActive(properties.Visible)
    end
    return properties
end