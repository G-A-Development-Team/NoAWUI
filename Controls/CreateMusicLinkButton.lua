local ControlName = 'mlbutton'
local FunctionName = 'CreateMusicLinkButton'


-- By: Agentsix1
function CreateMusicLinkButton(properties)
	-- Creates the control
    local Control = CreateControl()
	
	Control.ForeColor = {255,255,255,255}
	
	-- Setting the Player icon to the control
	Control.PlayIcon = [[
						<svg x="0px" y="0px" viewBox="0 0 1000 1000" width="40" height="40"><title>Layer 1</title>
						<path fill="#fff"  id="svg_1"  d="M393.9,770.4L720.7,500L393.9,229.7V770.4z M501.1,7.8C218.3,7.8,10,217.3,10,500.2c0,282.9,199.9,492,482.8,492c282.8,0,497.2-209.2,497.2-492C990,217.3,784,7.8,501.1,7.8z M501.1,929.3C264,929.3,71.9,737.2,71.9,500.1C71.9,263,264,70.9,501.1,70.9c237.1,0,429.2,192.1,429.2,429.2C930.4,737.2,738.2,929.3,501.1,929.3z"/>
						</svg>
					   ]]
		-- Converting Play Icon to Texture
		local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(Control.PlayIcon);
        local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
	-- Setting the PlayIconTexture to the control
	Control.PlayIconTexture = texture
	
    -- Loading setting from design to Control
	for key, value in pairs(properties) do
		value = tostring(value)
            switch(key:lower())
            .case("name", function() Control.Name = value end)
            .case("group", function() Control.Group = value end)
            .case("parent", function() Control.Parent = value end)
            .case("type", function() Control.Type = value end)
            .case("x", function() Control.X = value Control.SetX = value end)
            .case("y", function() Control.Y = value Control.SetY = value end)
            .case("width", function() Control.Width = value end)
            .case("height", function() Control.Height = value end)
            .case("drag", function() Control.Drag = value end)
            .case("mouseclick", function() Control.MouseClick = value end)
            .case("url", function() Control.URL = value end)
            .case("text", function() 
				value = value:gsub("_", " ")
				Control.Text = value 
			end)
            .case("image", function()
				-- Loads the image url from design and loads it to BackgroundImage
                local args = split(value, ",")
                local type = args[1]
                local src = args[2]
                switch(type:lower())
                .case("jpg", function() 
                    local jpgData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .case("png", function() 
                    local pngData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .case("svg", function() 
                    local svgData = http.Get(src);
                    local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    Control.BackgroundImage = texture
                end)
                .default(function() print("Image Type not found. key=" .. key) end)
                .process() 
            end)
            .case("background", function() 
				-- Sets the Control Background color
                if string.find(value, "theme") then
                    local r,g,b,a = gui.GetValue(value)
                    Control.Background[1] = r
                    Control.Background[2] = g
                    Control.Background[3] = b
                    Control.Background[4] = a
                else
                    local args = split(value, ",")
                    Control.Background[1] = args[1]
                    Control.Background[2] = args[2]
                    Control.Background[3] = args[3]
                    Control.Background[4] = args[4]
                end
            end)
            .case("roundness", function() 
				-- This is used to define the roundness of a rect
                local args = split(value, ",")
                Control.Roundness[1] = args[1]
                Control.Roundness[2] = args[2]
                Control.Roundness[3] = args[3]
                Control.Roundness[4] = args[4]
                Control.Roundness[5] = args[5]
                Control.Rounded = true
            end)
			-- Processes the switch bs above
            .default(function() print("Attribute not found. key=" .. key) end)
            .process() 
    end

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)
	-- This is used to create the actual gui object
    Control.Render = function(properties, form)
		-- Checks if the object should be visual
        if not properties.Visible or not form.Visible then
            return properties
        end
		
		-- Drag function
        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
        end
		
		-- Start drawing the gui object
		
		draw.SetFont(Control.Font)
		
		-- Draw the outline of the box
		--(cord, size, outer_color, inner_color, roundness, thickness)
		Renderer:RoundedRectangleBorder({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, Control.ForeColor, {0,0,0,255}, 6, 2)
		-- Set the texture for the image
		draw.SetTexture(Control.PlayIconTexture)
		-- Draw the image
		Renderer:FilledRectangle({properties.X + form.X+(properties.Width)*0.04, properties.Y + form.Y+(properties.Height)*0.12}, {properties.Width*0.24, properties.Height*0.75}, {255,255,255,255})
		-- Remove the texture for future draws
        draw.SetTexture(nil)
		-- Draw the text values
		Renderer:TextP({properties.X + form.X+(properties.Width)*0.31, properties.Y + form.Y+(properties.Height)*0.36}, Control.ForeColor, Control.Text)
		
		-- Is used to check if the gui object has been clicked
        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    if not getSelected() then
                        panorama.RunScript([[
                            SteamOverlayAPI.OpenURL("]] .. properties.URL .. [[")
                       ]])
						
						gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
						
                    end
                end
            end
        end
		
		-- Renders the children of the current gui object
        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end
		
		if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) and not getSelected() then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			Control.ForeColor = { r, g, b, a }
        else
			Control.ForeColor = {255,255,255,255}
		end
		
        return properties
    end

    return Control
end



--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName