
-- By: CarterPoe
function CreateControl()
    return {
        --Hierarchy:
        Type = "control",
        Group = "",
        Name = "",
        Parent = "",
        Children = {},
        Reference = nil,

        --Positioning and Dimensions:
        X = 0,
        Y = 0,
        SetX = 0,
        SetY = 0,
        AdditionalX = 0,
        AdditionalY = 0,
        AdditionalWidth = 0,
        AdditionalHeight = 0,
        Width = 0,
        Height = 0,

        --Dragging:
        Drag = false,
        isDragging = false,
        dragOffsetX = 0,
        dragOffsetY = 0,
        lastMouseX = 0,
        lastMouseY = 0,
        MAX_DRAG_DISTANCE = 0,

        --Visuals:
        Background = {0, 0, 0, 0},
        ActiveBackground = {0, 0, 0, 0},
        Color = {0, 0, 0, 0},
        BorderColor = {0, 0, 0, 0},
        Roundness = {},
        Rounded = false,
        BackgroundImage = nil,
        CreatedBackgroundImage = false,

        --Events:
        MouseDown = "",

        --Text:
        Text = "",
        FontFamily = "Arial",
        FontHeight = 21,
        FontWeight = 100,
        CreatedFont = nil,

        --State:
        Visible = true,
        Active = false,
        Selected = false,
        AWInitV = false,

        --Functions:
        Render = function(properties) end,
        AWInit = function(properties, x, y, x2, y2)
            properties.X = x + properties.AdditionalX
            properties.Y = y + properties.AdditionalY
            properties.Width = x2 -properties.X + properties.AdditionalWidth
            properties.Height = y2 -properties.Y + properties.AdditionalHeight
            properties.AWInitV = true
            return properties
        end,
        DefaultCase = function(Control, properties)
            for key, value in pairs(properties) do
                key = key:lower()
                value = tostring(value)
                if tableContainsValue(Control.AllowedCases, key) then
                    switch(key)
                        --Positioning and Dimensions:
                        .case("x",            function() Control.X            = value Control.SetX = value end)
                        .case("y",            function() Control.Y            = value Control.SetY = value end)
                        .case("width",        function() Control.Width        = value end)
                        .case("height",       function() Control.Height       = value end)
                        .case("alignment",    function() Control.Alignment    = value:lower() end)
                        .case("orientation",  function() Control.Orientation  = value:lower() end)
                        .case("scrollheight", function() Control.ScrollHeight = value end)

                        --Events:
                        .case("mouseclick",     function() Control.MouseClick   = value end)
                        .case("mousescroll",    function() Control.MouseScroll  = value end)
                        .case("mousehover",     function() Control.MouseHover   = value end)
                        .case("mouseoutside",   function() Control.MouseOutside = value end)
                        .case("changeevent",    function() Control.ChangeEvent  = value end)
                        .case("dragparent",     function()
                            if value == "false" then
                                Control.DragParent = false
                            else
                                Control.DragParent = true
                            end
                        end)
                        .case("ontoggle",       function() Control.OnToggle     = value end)
                        .case("unload",         function() Control.Unload       = value end)

                        --Visuals:
                        .case("image",        function()
                            local args = split(value, ",")
                            local type = args[1]
                            local src = args[2]
                            local imgRGBA, imgWidth, imgHeight = nil, nil, nil
                            switch(type:lower())
                                .case("jpg", function() 
                                    local jpgData = http.Get(src);
                                    imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                                end)
                                .case("png", function() 
                                    local pngData = http.Get(src);
                                    imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                                end)
                                .case("svg", function() 
                                    local svgData = http.Get(src);
                                    imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                                end)
                                .case("svgdata", function() 
                                    imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(value);
                                end)
                                .case("base64png", function()
                                    value = dec(value)
                                    imgRGBA, imgWidth, imgHeight = common.DecodePNG(value);
                                end)
                                .default(function() LogWarn("ATTRIBUTES", "Image Type not found. type=" .. type) end)
                            .process() 
                            local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                            Control.BackgroundImage = texture
                        end)
                        .case("background",   function()
                            if type(value) ~= "table" and string.find(value, "theme") then
                                Control.Background = getThemeColor(value)
                            else
                                local args = nil
                                if type(value) == "table" then args = value else args = split(value, ",") end
                                Control.Background = textToTable(args)
                            end
                        end)
                        .case("shadow",       function()
                            if string.find(value, "theme") then
                                Control.Shadow = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                Control.Shadow = textToTable(args)
                            end
                        end)
                        .case("border",       function()
                            if string.find(value, "theme") then
                                Control.BorderColor = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                Control.BorderColor = textToTable(args)
                            end
                        end)
                        .case("roundness",    function()
                            local args = split(value, ",")
                            Control.Roundness = textToTable(args)
                            Control.Rounded = true
                        end)
                        .case("color",        function()
                            if string.find(value, "theme") then
                                Control.Color = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                Control.Color = textToTable(args)
                            end
                        end)
                        .case("active",       function()
                            if string.find(value, "theme") then
                                Control.ActiveBackground = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                Control.ActiveBackground = textToTable(args)
                            end
                        end)
                        .case("displaylines", function()
                            if value == "false" then
                                Control.DisplayLines = false
                            else
                                Control.DisplayLines = true
                            end
                        end)

                        --Listeners:
                        .case("toggle",     function()
                            Control.Toggle = tonumber(value) 
                            Control.dummywindow = gui.Window("dummywindow", "", 0, 0, 0, 0)
                            Control.dummywindow:SetPosX(-10)
                            Control.dummywindow:SetPosY(-10)
                            Control.dummywindow:SetInvisible(true)
                            Control.dummywindow:SetOpenKey(tonumber(value))
                        end)
                        .case("drag",       function()
                            if value == "false" then
                                Control.Drag = false
                            else
                                Control.Drag = true
                            end
                        end)

                        --Text:
                        .case("fontfamily", function() Control.FontFamily = value end)
                        .case("fontheight", function() Control.FontHeight = value end)
                        .case("fontweight", function() Control.FontWeight = value end)
                        .case("text",       function() Control.Text       = value end)

                        --Debug:
                        .case("showsquare", function()
                            if value == "true" then
                                Control.ShowSquare = true
                            elseif value == "false" then
                                Control.ShowSquare = false
                            end
                        end)

                        --State:
                        .case("checkstate", function()
                            if value == "true" then
                                value = true
                            elseif value == "false" then
                                value = false
                            end
                            Control.CheckState = value
                        end)
                        .case("scroll",     function()
                            if value == "false" then
                                Control.Scroll = false
                            else
                                Control.Scroll = true
                            end
                        end)
                        .case("visible",    function()
                            if value == "false" then
                                Control.Visible = false
                            else
                                Control.Visible = true
                            end
                        end)

                        --Values:
                        .case("url",        function() Control.URL   = value end)
                        .case("imageurl",   function() Control.Image = value end)

                        --Aimware GUI Compatibility:
                        .case("varname",    function() Control.VarName  = value end)
                        .case("category",   function() Control.Category = value end)

                        .default(function() LogWarn("ATTRIBUTES", "Attribute not found. key=" .. key) end)
                    .process() 
                end
            end

            for key, value in pairs(properties) do
                value = tostring(value)
                switch(key:lower())
                    .case("name",     function() Control.Name     = value end)
                    .case("group",    function() Control.Group    = value end)
                    .case("parent",   function() Control.Parent   = value end)
                    .case("type",     function() Control.Type     = value end)
                .process()
            end

            if Control.Name == nil or Control.Type == nil then
                LogFatal("ATTRIBUTES", "Missing Required Attributes For Control")
                return nil
            end

            return Control
        end,
    }
end

function HandleEvent(event, properties)
    if event == "drag" then
        return Event_Drag(properties)
    end
    if event == "focus" then
        return Event_Focus(properties)
    end
    if event == "toggle" then
        return Event_Toggle(properties)
    end
end

file.Enumerate(function(filepath)
    if string.starts(filepath, "WinForm/Controls/") then
        RunScript(filepath)
        LogInfo("Controls", filepath)
    end
end)