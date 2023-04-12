local ControlName = 'form'
local FunctionName = 'CreateForm'

-- By: CarterPoe
function CreateForm(attributes)
    local Control = CreateControl()
    Control.DragNow = false
    Control.Focused = false
    Control.Animation = false

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height",
        --Listeners:
        "drag", "toggle",
        --State:
        "visible",
        --Events:
        "ontoggle", "unload",
        --Visuals:
        "image", "background", "border", "roundness",
    }

    Control:DefaultCase(attributes)

    Control.RenderBase = function(self)
        Renderer:ShadowRectangle({self.X, self.Y}, {self.Width, self.Height}, {0,0,0,70}, 25)

        if self.Rounded then
            Renderer:FilledRoundedRectangle({self.X, self.Y}, {self.Width, self.Height}, self.Background, self.Roundness)
            Renderer:OutlinedRoundedRectangle({self.X, self.Y}, {self.Width, self.Height}, self.BorderColor, self.Roundness)
        end

        if not self.Rounded then
            if self.BackgroundImage ~= nil then draw.SetTexture(self.BackgroundImage) end
            Renderer:FilledRectangle({self.X, self.Y}, {self.Width, self.Height}, self.Background)
            draw.SetTexture(nil)
            Renderer:OutlinedRectangle({self.X, self.Y}, {self.Width, self.Height}, self.BorderColor)
        end
        return self
    end

    Control.Render = function(self)
        HandleEvent("toggle", self)

        HandleAnimation("FadeIn", self, {
            MaxOpacity = 255,
            IncrementOpacity = 17,
            Reference = self.Background,
            Ignore = true,
        })

        if not self.Visible then return self end

        self:RenderBase()
        
        HandleEvent("focus", self)
        HandleEvent("drag", self)
        return self
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName
WinFormControls[ControlName]['special'] = 'container'