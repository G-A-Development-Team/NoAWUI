local ControlName = 'button'
local FunctionName = 'CreateButton'

-- By: CarterPoe
function CreateButton(attributes)
    local Control = CreateControl()
    Control.Background = {50, 50, 50, 255}
    Control.ActiveBackground = {65, 65, 65, 255}
    Control.Color = {255, 255, 255, 255}
    Control.Height = 26
    Control.Width = 124
    Control.FontWeight = 600
    Control.FontHeight = 14
    Control.FontFamily = "Segoe UI"

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Text:
        "fontfamily", "fontheight", "fontweight", "text",
        --Events:
        "mouseclick",
        --Visuals:
        "background", "active", "border", "roundness",
    }

    Control:DefaultCase(attributes)

    Control.RegisterFont = function(self)
        local Font = draw.CreateFont(self.FontFamily, self.FontHeight, self.FontWeight)
        Control.CreatedFont = Font
        return self
    end

    Control:RegisterFont()

    Control.RenderBase = function(self, parent, backgroundColor)
        Renderer:ShadowRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, {0,0,0,25}, 25)

        if self.Rounded then
            Renderer:FilledRoundedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, backgroundColor, self.Roundness)
            Renderer:OutlinedRoundedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.BorderColor, self.Roundness)
        end

        if not self.Rounded then
            Renderer:FilledRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, backgroundColor)
            Renderer:OutlinedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.BorderColor)
        end
        return self
    end

    Control.RenderText = function(self, parent)
        draw.SetFont(self.CreatedFont)

        local textLocation = centerTextOnRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.Text)
        Renderer:Text({textLocation.X, textLocation.Y}, self.Color, self.Text)
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end
        
        HandleEvent("mouseclick", self, parent)

        if isMouseInRect(self.X + parent.X, self.Y + parent.Y, self.Width, self.Height) then
            if input.IsButtonDown(1) and not getSelected() then
                self:RenderBase(parent, self.ActiveBackground)
            else
                self:RenderBase(parent, {self.ActiveBackground[1], self.ActiveBackground[2], self.ActiveBackground[3], 100})
            end
        else self:RenderBase(parent, self.Background) end

        if self.Active then self:RenderBase(parent, self.ActiveBackground) end

        self:RenderText(parent)
        return self
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName