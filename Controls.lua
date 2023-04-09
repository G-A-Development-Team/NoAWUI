
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
        AddChild = function(Control, child)
            table.insert(Control.Children, child)
            return Control
        end,
        AddControl = function(self, control)
            table.insert(self.Children, control)
            return self
        end,
        DefaultCase = function(self, properties)
            for key, value in pairs(properties) do
                key = key:lower()
                value = tostring(value)
                if tableContainsValue(self.AllowedCases, key) then
                    switch(key)
                        --Positioning and Dimensions:
                        .case("x",            function() self.X            = value self.SetX = value end)
                        .case("y",            function() self.Y            = value self.SetY = value end)
                        .case("width",        function() self.Width        = value end)
                        .case("height",       function() self.Height       = value end)
                        .case("alignment",    function() self.Alignment    = value:lower() end)
                        .case("orientation",  function() self.Orientation  = value:lower() end)
                        .case("scrollheight", function() self.ScrollHeight = value end)

                        --Events:
                        .case("mouseclick",     function() self.MouseClick   = value end)
                        .case("mousescroll",    function() self.MouseScroll  = value end)
                        .case("mousehover",     function() self.MouseHover   = value end)
                        .case("mouseoutside",   function() self.MouseOutside = value end)
                        .case("changeevent",    function() self.ChangeEvent  = value end)
                        .case("dragparent",     function()
                            if value == "false" then
                                self.DragParent = false
                            else
                                self.DragParent = true
                            end
                        end)
                        .case("ontoggle",       function() self.OnToggle     = value end)
                        .case("unload",         function() self.Unload       = value end)

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
                            self.BackgroundImage = texture
                        end)
                        .case("background",   function()
                            if type(value) ~= "table" and string.find(value, "theme") then
                                self.Background = getThemeColor(value)
                            else
                                local args = nil
                                if type(value) == "table" then args = value else args = split(value, ",") end
                                self.Background = textToTable(args)
                            end
                        end)
                        .case("shadow",       function()
                            if string.find(value, "theme") then
                                self.Shadow = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                self.Shadow = textToTable(args)
                            end
                        end)
                        .case("border",       function()
                            if string.find(value, "theme") then
                                self.BorderColor = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                self.BorderColor = textToTable(args)
                            end
                        end)
                        .case("roundness",    function()
                            local args = split(value, ",")
                            self.Roundness = textToTable(args)
                            self.Rounded = true
                        end)
                        .case("color",        function()
                            if string.find(value, "theme") then
                                self.Color = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                self.Color = textToTable(args)
                            end
                        end)
                        .case("active",       function()
                            if string.find(value, "theme") then
                                self.ActiveBackground = getThemeColor(value)
                            else
                                local args = split(value, ",")
                                self.ActiveBackground = textToTable(args)
                            end
                        end)
                        .case("displaylines", function()
                            if value == "false" then
                                self.DisplayLines = false
                            else
                                self.DisplayLines = true
                            end
                        end)

                        --Listeners:
                        .case("toggle",     function()
                            self.Toggle = tonumber(value) 
                            self.dummywindow = gui.Window("dummywindow", "", 0, 0, 0, 0)
                            self.dummywindow:SetPosX(-10)
                            self.dummywindow:SetPosY(-10)
                            self.dummywindow:SetInvisible(true)
                            self.dummywindow:SetOpenKey(tonumber(value))
                        end)
                        .case("drag",       function()
                            if value == "false" then
                                self.Drag = false
                            else
                                self.Drag = true
                            end
                        end)

                        --Text:
                        .case("fontfamily", function() self.FontFamily = value end)
                        .case("fontheight", function() self.FontHeight = value end)
                        .case("fontweight", function() self.FontWeight = value end)
                        .case("text",       function() self.Text       = value end)

                        --Debug:
                        .case("showsquare", function()
                            if value == "true" then
                                self.ShowSquare = true
                            elseif value == "false" then
                                self.ShowSquare = false
                            end
                        end)

                        --State:
                        .case("checkstate", function()
                            if value == "true" then
                                value = true
                            elseif value == "false" then
                                value = false
                            end
                            self.CheckState = value
                        end)
                        .case("scroll",     function()
                            if value == "false" then
                                self.Scroll = false
                            else
                                self.Scroll = true
                            end
                        end)
                        .case("visible",    function()
                            if value == "false" then
                                self.Visible = false
                            else
                                self.Visible = true
                            end
                        end)

                        --Values:
                        .case("url",        function() self.URL   = value end)
                        .case("imageurl",   function() self.Image = value end)

                        --Aimware GUI Compatibility:
                        .case("varname",    function() self.VarName  = value end)
                        .case("category",   function() self.Category = value end)

                        .default(function() LogWarn("ATTRIBUTES", "Attribute not found. key=" .. key) end)
                    .process() 
                end
            end

            for key, value in pairs(properties) do
                value = tostring(value)
                switch(key:lower())
                    .case("name",     function() self.Name     = value end)
                    .case("group",    function() self.Group    = value end)
                    .case("parent",   function() self.Parent   = value end)
                    .case("type",     function() self.Type     = value end)
                .process()
            end

            if self.Name == nil or self.Type == nil then
                LogFatal("ATTRIBUTES", "Missing Required Attributes For Control")
                return nil
            end

            -- Create a global variable with the same name as the component's name
            _G[self.Name] = self

            return self
        end,
    }
end

-- Grab some info from the Events
Events_Objects = json.decode("{}")
Events_Details = json.decode("{}")

-- Process the events
function HandleEvent(event, self, parent)
	-- Set event name to lowercase
	event = event:lower()
	-- Loop through the possible objects (array of object names)
	for _, value in ipairs(Events_Objects) do
		-- check if its the right object name
		if event == value then
			-- see if it has 1 parm or 2
			if Events_Details[event]['parms'] == 1 then
				-- Run the event function asscotiated with the event
				local temp = assert(loadstring('return ' .. Events_Details[event]['function']..'(...)'))(self)
				return temp
			-- see if it has 2 parms
			elseif Events_Details[event]['parms'] == 2 then
				-- Run the event function asscotiated with the event
				local temp = assert(loadstring('return ' .. Events_Details[event]['function']..'(...)'))(self, parent)
				return temp
			end
		end
	end
end

-- Grab some info from the Animations
Animations_Objects = json.decode("{}")
Animations_Details = json.decode("{}")

-- Process the events
function HandleAnimation(animation, self, parent)
	-- Set event name to lowercase
	animation = animation:lower()
	-- Loop through the possible objects (array of object names)
	for _, value in ipairs(Animations_Objects) do
		-- check if its the right object name
		if animation == value then
			-- see if it has 1 parm or 2
			if Animations_Details[animation]['parms'] == 1 then
				-- Run the event function asscotiated with the event
				local temp = assert(loadstring('return ' .. Animations_Details[animation]['function']..'(...)'))(self)
				return temp
			-- see if it has 2 parms
			elseif Animations_Details[animation]['parms'] == 2 then
				-- Run the event function asscotiated with the event
				local temp = assert(loadstring('return ' .. Animations_Details[animation]['function']..'(...)'))(self, parent)
				return temp
			end
		end
	end
end

loadFiles('WinForm/Controls/', 'Controls')
