local ControlName = 'panel'
local FunctionName = 'CreatePanel'

-- By: CarterPoe
function CreatePanel(attributes)
    local Control = CreateControl()
    Control.Shadow = {0,0,0,40,25}

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Events:
        "mousehover", "mouseoutside", "mouseclick", "dragparent",
        --Visuals:
        "image", "background", "shadow", "border", "roundness",
    }

    Control:DefaultCase(attributes)

    Control.RenderBase = function(self, parent)
        Renderer:ShadowRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, {self.Shadow[1], self.Shadow[2], self.Shadow[3], self.Shadow[4]}, self.Shadow[5])

        if self.Rounded then
            Renderer:FilledRoundedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.Background, self.Roundness)
            Renderer:OutlinedRoundedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.BorderColor, self.Roundness)
        end

        if not self.Rounded then
            if self.BackgroundImage ~= nil then draw.SetTexture(self.BackgroundImage) end

            Renderer:FilledRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.Background)
            draw.SetTexture(nil)

            Renderer:OutlinedRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height}, self.BorderColor)
        end
        return self
    end

    Control.RenderChildren = function(self, parent)
        Renderer:Scissor({self.X + parent.X, self.Y + parent.Y}, {self.Width, self.Height})
        for _, control in ipairs(self.Children) do
            control.X = parent.X + control.SetX
            control.Y = parent.Y + control.SetY
            control.Render(control, self)
        end
        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h})
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end
        self:RenderBase(parent)

        self:RenderChildren(parent)
        HandleEvent("dragparent", self, parent)
        HandleEvent("mousehover", self, parent)
        HandleEvent("mouseoutside", self, parent)
        HandleEvent("mouseclick", self, parent)
        return self
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName