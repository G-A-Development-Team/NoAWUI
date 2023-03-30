function getTotalX(control)
    local parent = getParentControl(control)
    
    if parent == nil then
        LogError("getTotalX", "Parent not found.")
        print("Parent not found.")
        return
    end

    return parent.X + control.X
end

function getTotalY(control)
    local parent = getParentControl(control)
    
    if parent == nil then
        LogError("getTotalY", "Parent not found.")
        return
    end

    return parent.Y + control.Y
end

function getControlByName(form, name)
    for _, main in ipairs(controls) do
        if main.Name == form then
            local function findControl(control)
                if control.Name == name then
                    return control
                else
                    for _, child in ipairs(control.Children or {}) do
                        local result = findControl(child)
                        if result then
                            return result
                        end
                    end
                end
            end
            return findControl(main)
        end
    end
    return nil
end

function getParents(control)
    local parents = {}
    local parent = getParentControl(control)
    while parent do
        if parent.Type:lower() == "form" then
            table.insert(parents, 1, parent) 
        end
        parent = getParentControl(parent)
    end
    return parents
end

function getControl(name)
    for _, main in ipairs(controls) do
        local function findControl(control)
            if control.Name == name then
                return control
            else
                for _, child in ipairs(control.Children or {}) do
                    local result = findControl(child)
                    if result then
                        return result
                    end
                end
            end
        end
        return findControl(main)
    end
    return nil
end

function getSelected()
    for _, main in ipairs(controls) do
        local function findControl(control)
            if control.Selected then
                return true
            else
                for _, child in ipairs(control.Children or {}) do
                    local result = findControl(child)
                    if result then
                        return result
                    end
                end
            end
        end
        local result = findControl(main)
        if result then
            return result
        end
    end
    return false
end

function getParentControl(control)
    return getControl(control.Parent)
end

function getFormByName(form)
    for _, main in ipairs(controls) do
        if main.Name == form then
            return main
        end
    end
end


function getControlsByGroup(form, group)
    local list = {}
    for _, main in ipairs(controls) do
        if main.Name == form then
            local function searchChildren(children)
                for _, control in ipairs(children) do
                    if control.Group == group then
                        table.insert(list, control)
                    end
                    if control.Children then
                        searchChildren(control.Children)
                    end
                end
            end
            searchChildren(main.Children)
        end
    end
    return list
end


function updateControlByName(form, name, controle)
    for _m, main in ipairs(controls) do
        if main.Name == form then
            for _, control in ipairs(main.Children) do
                if control.Name == name then
                    main.Children[_] = controle
                end
            end
            controls[_m] = main
        end
    end
end



function addTempDraw(func)
    table.insert(tempDraw, func)
end

function removeTempDraw(name)
    for _m, main in ipairs(tempDraw) do
        if main.Name == name then
            table.remove(tempDraw, _m)
        end
    end
end

function FocusForm(name)
    table.remove(focuslist, 1)
    if #focuslist == 0 then
        local found = false
        for _, _name in ipairs(focuslist) do
            if _name == name then
                found = true
            end
        end
        if not found then
            table.insert(focuslist, name) 
        end
    end
end

function getCurrentFocus()
    return focuslist[1]
end

function AmIAllowed(control)
    local name = getParents(control)[1].Name
    if name:lower() == getCurrentFocus():lower() then
        return true
    end
    return false
end