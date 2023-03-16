function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function TablePrint(t)
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(k)
            TablePrint(v)
        else
            print("\t", k, v)
        end
    end
end

function switch(element)
    local Table = {
        ["Value"] = element,
        ["DefaultFunction"] = nil,
        ["Functions"] = {}
    }

    Table.case = function(testElement, callback)
        Table.Functions[testElement] = callback
        return Table
    end

    Table.default = function(callback)
        Table.DefaultFunction = callback
        return Table
    end

    Table.process = function()
        local Case = Table.Functions[Table.Value]
        if Case then
            Case()
        elseif Table.DefaultFunction then
            Table.DefaultFunction()
        end
    end

    return Table
end

function isMouseInRect(rectX, rectY, rectWidth, rectHeight)
    rectX = tonumber(rectX)
    rectY = tonumber(rectY)
    rectWidth = tonumber(rectWidth)
    rectHeight = tonumber(rectHeight)
    local mouseX, mouseY = input.GetMousePos();
    if (mouseX >= rectX) and (mouseX <= rectX + rectWidth) and
       (mouseY >= rectY) and (mouseY <= rectY + rectHeight) then
        return true
    else
        return false
    end
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function centerTextOnRectangle(cords, size, text)
    -- Set the font

    local textWidth, textHeight = draw.GetTextSize(text);
    
    -- Calculate the center point of the rectangle
    local centerX = cords[1] + (size[1] / 2)
    local centerY = cords[2] + (size[2] / 2)
    
    -- Calculate the position of the text
    local textX = centerX - (textWidth / 2)
    local textY = centerY - (textHeight / 2)
    
    -- Draw the text
    return {X = textX, Y = textY}
end

function addComponent(component, parent)
    -- Check if the parent is the correct one
    if parent.Name == component.Parent then
        table.insert(parent.Children, component)
        return
    end
    
    -- Try to find the correct parent in the children of the current parent
    for _, child in ipairs(parent.Children) do
        addComponent(component, child)
    end
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end