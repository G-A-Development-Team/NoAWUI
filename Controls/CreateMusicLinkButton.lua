local ControlName = 'mlbutton'
local FunctionName = 'CreateMusicLinkButton'

-- By: Agentsix1
function CreateMusicLinkButton(attributes)
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
        "x", "y", "width", "height",
        --Events:
        "mouseclick",
        --Values:
        "url",
        --Text:
        "text",
        --Visuals:
        "image", "background", "roundness",
    }

    Control:DefaultCase(attributes)

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)

    Control.RenderBase = function(self, parent)
        Renderer:RoundedRectangleBorder({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.ForeColor, {0,0,0,255}, 6, 2)
        draw.SetTexture(self.PlayIconTexture)
		Renderer:FilledRectangle({self.X + parent.X+(self.Width)*0.04, self.Y + parent.Y+(self.Height)*0.12}, {self.Width*0.24, self.Height*0.75}, {255,255,255,255})
        draw.SetTexture(nil)
        return self
    end

    Control.RenderText = function(self, parent)
        draw.SetFont(self.Font)
        Renderer:TextP({self.X + parent.X+(self.Width)*0.31, self.Y + parent.Y+(self.Height)*0.36}, self.ForeColor, self.Text)
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end
		
        self:RenderBase(parent)
        self:RenderText(parent)

        HandleEvent("mouseclick", self, parent)

		if isMouseInRect(self.X + parent.X, self.Y + parent.Y, self.Width, self.Height) and not getSelected() then
            if input.IsButtonReleased(1) then
                panorama.RunScript([[
                    SteamOverlayAPI.OpenURL("]] .. self.URL .. [[")
                ]])
            end
            local r,g,b,a = gui.GetValue("theme.nav.active")
			Control.ForeColor = { r, g, b, a }
        else Control.ForeColor = {255,255,255,255} end
        return self
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName