local ControlName = 'checkbox'
local FunctionName = 'CreateCheckbox'


-- By: Agentsix1
function CreateCheckbox(properties)
	-- Creates the control
    local Control = CreateControl()
	
	-- Set checkmark icon
	Control.CheckIcon = [[		
		<svg fill="#fff" version="1.1" id="Capa_1" width="800px" height="800px" viewBox="0 0 45.701 45.7">
			<path d="M20.687,38.332c-2.072,2.072-5.434,2.072-7.505,0L1.554,26.704c-2.072-2.071-2.072-5.433,0-7.504
				c2.071-2.072,5.433-2.072,7.505,0l6.928,6.927c0.523,0.522,1.372,0.522,1.896,0L36.642,7.368c2.071-2.072,5.433-2.072,7.505,0
				c0.995,0.995,1.554,2.345,1.554,3.752c0,1.407-0.559,2.757-1.554,3.752L20.687,38.332z"/>
		</svg>
	]]
	
	-- Create checkmark texture
	local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(Control.CheckIcon);
    local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
	
	-- Set Checkmark Texture
	Control.CheckTexture = texture
	
	-- Set default values
	Control.CheckState = false
	Control.CheckColor = {255,255,255,255}
	Control.OutlineColor = {150,150,150,255}
	Control.BackgroundColor = {56,56,56,190}
	Control.TextColor = {255,255,255,255}
	Control.HoverColor = {255,0,0,255}
	Control.TextWidth = 0
	Control.Text = ""

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Text:
        "text",
        --Events:
        "mouseclick",
        --State:
        "checkstate",
    }

    Control = Control.DefaultCase(Control, properties)

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)

    Control.RenderBase = function(properties, parent)
		Renderer:RoundedRectangleBorder({properties.X + parent.X, properties.Y + parent.Y}, {properties.Width, properties.Height}, properties.OutlineColor, properties.BackgroundColor, 6, 2)
    
        if properties.CheckState then
			local gap = 0.15
			draw.SetTexture(properties.CheckTexture)
			Renderer:FilledRectangle({properties.X + parent.X + (properties.Width*gap) , properties.Y + parent.Y + (properties.Width*gap)},
			                         {properties.Width - (properties.Width*gap*2), properties.Height - (properties.Width*gap*2)}, properties.CheckColor)
			draw.SetTexture(nil)
		end
        return properties
    end

    Control.RenderText = function(properties, parent)
		draw.SetFont(properties.Font)

		Renderer:TextP({properties.X + parent.X+(properties.Width)*1.3, properties.Y + parent.Y+(properties.Height)*0.28}, properties.TextColor, properties.Text)
        properties.TextWidth, _xx = draw.GetTextSize(properties.Text)
        return properties
    end

    Control.Render = function(properties, parent)
        if not properties.Visible or not parent.Visible then return properties end

        properties = properties.RenderBase(properties, parent)

        properties = properties.RenderText(properties, parent)

		
		-- Is used to check if the gui object has been clicked
        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width+properties.TextWidth, properties.Height) and not getSelected() then
					if properties.CheckState then
						properties.CheckState = false
					else
						properties.CheckState = true
					end
					gui.Command('lua.run "' .. properties.MouseClick .. '" ') 
                end
            end
        end
		
		if isMouseInRect(properties.X + parent.X, properties.Y + parent.Y, properties.Width+properties.TextWidth, properties.Height) and not getSelected() then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			properties.TextColor = { r, g, b, a }
        else
			properties.TextColor = {255,255,255,255}
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