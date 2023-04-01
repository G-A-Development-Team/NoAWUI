function split(inputstr, sep)
    if inputstr == nil or sep == nil then
        return
    end
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function str_replace(subject, search, replace)
	return subject:gsub(search, replace)
end

function TablePrint(t)
    for k, v in pairs(t) do
        if type(v) == "table" then
            LogInfo("TablePrint", tostring(k))
            TablePrint(v)
        else
            LogInfo("TablePrint", "\t   " .. tostring(k) .. "    " .. tostring(v))
        end
    end
end

function deepcopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
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

function isRectInRect(x1, y1, w1, h1, x2, y2, w2, h2)
    x1 = tonumber(x1)
    y1 = tonumber(y1)
    w1 = tonumber(w1)
    h1 = tonumber(h1)
    x2 = tonumber(x2)
    y2 = tonumber(y2)
    w2 = tonumber(w2)
    h2 = tonumber(h2)
    -- Calculate the boundaries of the first rectangle
    local left1 = x1
    local right1 = x1 + w1
    local top1 = y1
    local bottom1 = y1 + h1
    
    -- Calculate the boundaries of the second rectangle
    local left2 = x2
    local right2 = x2 + w2
    local top2 = y2
    local bottom2 = y2 + h2
    
    -- Check if the first rectangle is fully contained within the second rectangle
    if left1 >= left2 and right1 <= right2 and top1 >= top2 and bottom1 <= bottom2 then
      return true
    else
      return false
    end
end

function isRectInRectPartial(x1, y1, w1, h1, x2, y2, w2, h2)
    x1 = tonumber(x1)
    y1 = tonumber(y1)
    w1 = tonumber(w1)
    h1 = tonumber(h1)
    x2 = tonumber(x2)
    y2 = tonumber(y2)
    w2 = tonumber(w2)
    h2 = tonumber(h2)
    -- Calculate the boundaries of the first rectangle
    local left1 = x1
    local right1 = x1 + w1
    local top1 = y1
    local bottom1 = y1 + h1
    
    -- Calculate the boundaries of the second rectangle
    local left2 = x2
    local right2 = x2 + w2
    local top2 = y2
    local bottom2 = y2 + h2
    
    -- Check if the two rectangles overlap at all
    if left1 > right2 or right1 < left2 or top1 > bottom2 or bottom1 < top2 then
        return false
    else
        return true
    end
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

function set_scissor_rect(x1, y1, w1, h1, x2, y2, w2, h2)
    x1 = tonumber(x1)
    y1 = tonumber(y1)
    w1 = tonumber(w1)
    h1 = tonumber(h1)
    x2 = tonumber(x2)
    y2 = tonumber(y2)
    w2 = tonumber(w2)
    h2 = tonumber(h2)
    -- Calculate the boundaries of the first rectangle
    local left1 = x1
    local right1 = x1 + w1
    local top1 = y1
    local bottom1 = y1 + h1
    
    -- Calculate the boundaries of the second rectangle
    local left2 = x2
    local right2 = x2 + w2
    local top2 = y2
    local bottom2 = y2 + h2
    
    -- Calculate the visible portion of the first rectangle
    local scissor_left, scissor_top, scissor_width, scissor_height
    if left1 < left2 then
      scissor_left = left1
      scissor_width = left2 - left1
    else
      scissor_left = left2 + w2
      scissor_width = right1 - scissor_left
    end
    
    if top1 < top2 then
      scissor_top = top1
      scissor_height = top2 - top1
    else
      scissor_top = top2 + h2
      scissor_height = bottom1 - scissor_top
    end
    
    -- Set the scissor rectangle to the non-visible portion of the rectangle
    draw.SetScissorRect(scissor_left, scissor_top, scissor_width, scissor_height)
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

function centerRect(innerWidth, innerHeight, outerX, outerY, outerWidth, outerHeight)
    local newX = outerX + (outerWidth - innerWidth) / 2
    local newY = outerY + (outerHeight - innerHeight) / 2
    return {X = newX, Y = newY, Width = innerWidth, Height = innerHeight}
end

function centerTriangleInRect(x1, y1, x2, y2, x3, y3, rectX, rectY, rectWidth, rectHeight)
    -- Calculate the center of the rectangle
    local centerX = rectX + rectWidth / 2
    local centerY = rectY + rectHeight / 2
    
    -- Calculate the offset of each triangle vertex from the center of the rectangle
    local dx1 = x1 - centerX
    local dy1 = y1 - centerY
    local dx2 = x2 - centerX
    local dy2 = y2 - centerY
    local dx3 = x3 - centerX
    local dy3 = y3 - centerY
    
    -- Return the coordinates of the triangle vertices relative to the center of the rectangle
    return {X1 = centerX + dx1, Y1 = centerY + dy1, X2 = centerX + dx2, Y2 = centerY + dy2, X3 = centerX + dx3, Y3 = centerY + dy3}
end

function centerRectAbovePoint(x, y, width, height)
    local rectX = x - width / 2
    local rectY = y - height / 2 - height
    return {X = rectX, Y = rectY}
end

function loadFiles(path, logname)
    local Elapsed = CreateElapsedTime(logname)
	file.Enumerate(function(filepath)
		if string.starts(filepath, path) then
			RunScript(filepath)
			LogInfo(logname, filepath)
		end
	end)
    Elapsed.Done()
end

function addComponent(component, parent)
    -- Check if the parent is the correct one
    if parent.Name == component.Parent then
        LogInfo("component", "Name=" .. component.Name .. " Type=" .. component.Type)
        table.insert(parent.Children, component)
        return
    end
    
    -- Try to find the correct parent in the children of the current parent
    for _, child in ipairs(parent.Children) do
        addComponent(component, child)
    end
end

function cleanJsonComments(jsontext)
	-- Output text
	local out = ""
	
	-- Begin comment removal
	local CommentLines = split(jsontext, "\n")

	-- Reset DesignText
	out = ""

	-- For each line check if it starts with *
	for _, cl in ipairs(CommentLines) do
		if not string.starts(cl, "*") then
			if out == "" then
				out = cl
			else
				out = out .. cl
			end
		end
	end
	
	return out
end

-- Returns the attributes
function getDefaultAtts(je)
	local atts = {}
		for key, jElement in pairs(je['details']) do
			atts[key] = jElement
		end
		
		for key, jElement in pairs(je['dimensions']) do
			atts[key] = jElement
		end
		
		for key, jElement in pairs(je['optional']) do
			for subKey, subjElement in pairs(je['optional'][key]) do 
				atts[subKey] = subjElement
			end
		
		end
	return atts
end

-- Returns an array of attributes
function GetAttributesFromFile(jsonfilepath)
	local jsontextobj = file.Open(jsonfilepath, "r");
	jsontext = jsontextobj:Read();
	jsontextobj:Close();
	jsontext = cleanJsonComments(jsontext)
	jsonobject = json.decode(jsontext)
	return getDefaultAtts(jsonobject)
end

function GetAttributesFromArrayByName(json, name)
	
	for _, jElement in pairs(json) do
		if jElement['name'] == name then
			return jElement
		end
	end
	return nil
end

function GetMultipleAttributesFromFile(jsonfilepath)
local jsontextobj = file.Open(jsonfilepath, "r");
	jsontext = jsontextobj:Read();
	jsontextobj:Close();
	jsontext = cleanJsonComments(jsontext)
	jsonobject = json.decode(jsontext)
	out_array = {}
	for _, jElement in pairs(jsonobject) do
		table.insert(out_array, getDefaultAtts(jElement))
	end
	return out_array
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

function tableContainsValue(table, value)
    for _, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
end

function textToTable(value)
    local tbl = {}
    for key, value in ipairs(value) do
        tbl[key] = value
    end
    return tbl
end

function getThemeColor(value)
    local r,g,b,a = gui.GetValue(value)
    return {r,g,b,a}
end

function ExecuteLuaString(text)
    gui.Command('lua.run "' .. text .. '" ')
end

function CreateElapsedTime(name)
    return {
        Current = common.Time(),
        Done = function()
            local donetime = common.Time()
            LogInfo(name, "Finished in " .. donetime .. " seconds")
            table.insert(elapsedlist, {Name = name, Time = donetime})
        end,
    }
end

function LongestElapsedTime()
    local longest = 0
    local longestName = ""
    local total = 0

    for i, elapsed in ipairs(elapsedlist) do
        if elapsed.Name:lower() ~= "script" then
            total = total + elapsed.Time
            if elapsed.Time > longest then
                longest = elapsed.Time
                longestName = elapsed.Name
            end 
        end
    end

    LogInfo("Elapsed - " .. longestName, "Longest duration " .. longest .. " seconds")
    --LogInfo("Elapsed - total", "Total duration " .. total .. " seconds")
end


--------------------------------------------
--          READ JSON EXECUTION           --
-- Credit To: Chicken4676                 --
-- Credit To: tg021 (Github)              --
--------------------------------------------

local json_lib_installed = false
file.Enumerate(function(filename)
    if filename == "WinForm/libs/json.lua" then
        json_lib_installed = true
    end
end)

if not json_lib_installed then
    local body = http.Get("https://raw.githubusercontent.com/G-A-Development-Team/libs/main/json.lua")
    file.Write("WinForm/libs/json.lua", body)
end
RunScript("WinForm/libs/json.lua")

jsonkeycodes = json.decode(http.Get("https://raw.githubusercontent.com/G-A-Development-Team/libs/main/keycodes.json"))

function TranslateKeyCode(int)
    local key_json = jsonkeycodes
    for i = 1, #key_json, 1 do
        if key_json[i]["Key Code"] == tostring(int) then
            return key_json[i]["Key"]
        end
    end
end

WinFormControls = '{}'
WinFormControls = json.decode(WinFormControls)