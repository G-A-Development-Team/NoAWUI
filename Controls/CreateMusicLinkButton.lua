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

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x",
        "y",
        "width",
        "height",

        --Events:
        "mouseclick",

        --Values:
        "url",

        --Text:
        "text",

        --Visuals:
        "image",
        "background",
        "roundness",
    }

    Control = Control.DefaultCase(Control, properties)

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