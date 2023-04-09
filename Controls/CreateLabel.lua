local ControlName = 'label'
local FunctionName = 'CreateLabel'

-- By: CarterPoe
function CreateLabel(attributes)
    local Control = CreateControl()
    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height", "alignment",
        --Text:
        "fontfamily", "fontheight", "fontweight", "text",
        --Events:
        "mouseclick",
        --Visuals:
        "color",
        --Debug:
        "showsquare",
    }

    Control:DefaultCase(attributes)

    Control.RegisterFont = function(self)
        local Font = draw.CreateFont(self.FontFamily, self.FontHeight, self.FontWeight)
        self.CreatedFont = Font
        self.DefaultFont = Font
        return self
    end

    Control:RegisterFont()

    Control.ResetFont = function(self)
        if self.CreatedFont ~= self.DefaultFont then
            self.CreatedFont = self.DefaultFont
        end
        return self
    end

    Control.RenderDefaultBase = function(self, parent)
        draw.SetFont(self.CreatedFont)
        Renderer:Text({self.X + parent.X, self.Y + parent.Y}, self.Color, self.Text)
        return self
    end

    Control.RenderRightAlignment = function (self, parent)
        draw.SetFont(self.CreatedFont)

        local Tw, Th = draw.GetTextSize(self.Text)
        Renderer:Text({self.X + parent.X - Tw, self.Y + parent.Y}, self.Color, self.Text) 

        if self.ShowSquare then Renderer:FilledRectangle({self.X + parent.X, self.Y + parent.Y}, {5,5}, {255,0,0,255}) end
        return self
    end

    Control.RenderAutoSize = function (self, parent)
        draw.SetFont(self.CreatedFont)

        local Tw, Th = draw.GetTextSize(self.Text)

        if tonumber(Tw) >= tonumber(self.Width) then
            Renderer:Text({self.X + parent.X, self.Y + parent.Y}, self.Color, "Loading..")
            if self.Multipler == nil then self.Multipler = .1 else self.Multipler = self.Multipler + .1 end

            local Font = draw.CreateFont(self.FontFamily, self.FontHeight - self.Multipler, self.FontWeight)
            self.CreatedFont = Font
        else
            Renderer:Text({self.X + parent.X, self.Y + parent.Y}, self.Color, self.Text) 
        end

        if self.ShowSquare then Renderer:FilledRectangle({self.X + parent.X, self.Y + parent.Y}, {self.Width,self.Height}, {255,0,0,255}) end
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end

        if self.Alignment == nil then self:RenderDefaultBase(parent) end
        if self.Alignment == "right" then self:RenderRightAlignment(parent) end
        if self.Alignment == "autosize" then self:RenderAutoSize(parent) end
        return self
    end

    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName