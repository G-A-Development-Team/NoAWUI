local ControlName = 'checkbox'
local FunctionName = 'CreateCheckbox'

-- By: Agentsix1
function CreateCheckbox(attributes)
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
		"statechange",
        --State:
        "checkstate",
    }

    Control:DefaultCase(attributes)

	Control.Font = draw.CreateFont("Bahnschrift", 20, 100)

    Control.RenderBase = function(self, parent)
		Renderer:RoundedRectangleBorder({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.OutlineColor, self.BackgroundColor, 6, 2)
    
        if self.CheckState then
			local gap = 0.15
			draw.SetTexture(self.CheckTexture)
			Renderer:FilledRectangle({self.X + parent.X + (self.Width*gap) , self.Y + parent.Y + (self.Width*gap)},
			                         {self.Width - (self.Width*gap*2), self.Height - (self.Width*gap*2)}, self.CheckColor)
			draw.SetTexture(nil)
		end
        return self
    end

    Control.RenderText = function(self, parent)
		draw.SetFont(self.Font)

		Renderer:TextP({self.X + parent.X+(self.Width)*1.3, self.Y + parent.Y+(self.Height)*0.28}, self.TextColor, self.Text)
        self.TextWidth, _xx = draw.GetTextSize(self.Text)
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end

        self:RenderBase(parent)
        self:RenderText(parent)
        HandleEvent("mouseclick", self, parent)
		self.CheckState = HandleEvent("statechange", self, {
            State = self.CheckState,
            Parent = parent,
        })

		if isMouseInRect(self.X + parent.X, self.Y + parent.Y, self.Width+self.TextWidth, self.Height) and not getSelected() then
            local r,g,b,a = gui.GetValue("theme.nav.active")
			self.TextColor = { r, g, b, a }
        else self.TextColor = {255,255,255,255} end
		return self
    end

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName