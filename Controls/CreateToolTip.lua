local ControlName = 'tooltip'
local FunctionName = 'CreateToolTip'

local right_click_svg = [[
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20px" height="20px" viewBox="0,0,256,256"><g fill="#ffdf00" fill-rule="nonzero" stroke="none" stroke-width="1" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10" stroke-dasharray="" stroke-dashoffset="0" font-family="none" font-weight="none" font-size="none" text-anchor="none" style="mix-blend-mode: normal"><g transform="scale(5.12,5.12)"><path d="M38.84375,0c-0.41016,0.05469 -0.74219,0.35547 -0.83984,0.75781c-0.09766,0.39844 0.0625,0.82031 0.40234,1.05469c4.85938,3.65234 8.27344,9.08594 9.28125,15.34375c0.02734,0.375 0.26563,0.70313 0.61328,0.84766c0.34766,0.14453 0.75,0.08203 1.03516,-0.16406c0.28516,-0.24609 0.41016,-0.62891 0.32031,-0.99609c-1.08984,-6.78125 -4.79687,-12.70312 -10.0625,-16.65625c-0.21484,-0.16016 -0.48437,-0.22656 -0.75,-0.1875zM24,3c-9.92578,0 -18,8.07422 -18,18v11c0,9.92578 8.07422,18 18,18c9.92578,0 18,-8.07422 18,-18v-11c0,-9.92578 -8.07422,-18 -18,-18zM37.0625,3.625c-0.41797,0.03125 -0.77344,0.32422 -0.88672,0.73047c-0.10937,0.40625 0.04297,0.83984 0.38672,1.08203c3.60547,2.90625 6.15234,7.02734 7.0625,11.75c0.10547,0.54297 0.62891,0.90234 1.17188,0.79688c0.54297,-0.10547 0.90234,-0.62891 0.79688,-1.17187c-1.00391,-5.19922 -3.81641,-9.74219 -7.78125,-12.9375c-0.17969,-0.16016 -0.41406,-0.25 -0.65625,-0.25c-0.03125,0 -0.0625,0 -0.09375,0zM23,5.0625v20.9375h-15v-5c0,-8.48437 6.64453,-15.41797 15,-15.9375zM8,28h32v4c0,8.82031 -7.17969,16 -16,16c-8.82031,0 -16,-7.17969 -16,-16z"></path></g></g></svg>
]]

-- By: CarterPoe
function CreateToolTip(attributes)
    local Control = CreateControl()
    Control.Lines = {}
    Control.Toggled = false
    Control.Initialized = false
    Control.CreatedComponentNames = {
        BaseFrame = "",
        InnerFrame = "",
        HelpFrame = "",
        TextLayout = "",
    }

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x", "y", "width", "height", "alignment",
        --Text:
        "text",
        --Visuals:
        "image", "background", "border", "roundness",
    }

    Control:DefaultCase(attributes)

    Control.LoadLines = function(self, attributes)
        if attributes["lines"] ~= nil then
            for jkey, jvalue in ipairs(attributes["lines"]) do
                if string.find(jvalue, '\n') then
                    local arry = split(jvalue, '\n')
                    for skey, svalue in ipairs(arry) do
                        table.insert(self.Lines, svalue)
                    end
                else table.insert(self.Lines, jvalue) end
            end
        end
        return self
    end

    Control:LoadLines(attributes)

    Control.CreateComponentBase = function(self)
        local uid = math.random(1, 342)
        local BaseFrame = CreatePanel({
            type = "panel",
            name = uid .. "BaseFrame",
            parent = self.Name,
            background = "50,50,50,200",
            roundness = "6,6,6,6,6",
        })

        if BaseFrame == nil then return end

        local InnerFrame = CreatePanel({
            type = "panel",
            name = uid .. "InnerFrame",
            parent = BaseFrame.Name,
            x = 5, y = 5,
            background = "0,0,0,0",
        })

        local HelpFrame = CreatePanel({
            type = "panel",
            name = uid .. "HelpFrame",
            parent = BaseFrame.Name,
            y = 5, width = 20, height =  20,
            background = "0,0,0,0",
            image = "svgdata," .. right_click_svg
        })

        if InnerFrame == nil then return end

        local TextLayout = CreateFlowLayout({
            type = "flowlayout",
            name = uid .. "TextLayout",
            parent = InnerFrame.Name,
            background = "0,0,0,0",
            roundness = "6,6,6,6,6",
            scrollheight = 15,
            shadow = "0,0,0,0,0"
        })

        self.CreatedComponentNames.BaseFrame = uid .. "BaseFrame"
        self.CreatedComponentNames.InnerFrame = uid .. "InnerFrame"
        self.CreatedComponentNames.HelpFrame = uid .. "HelpFrame"
        self.CreatedComponentNames.TextLayout = uid .. "TextLayout"

        
        InnerFrame:AddControl(TextLayout)
        BaseFrame:AddControl(InnerFrame)
        BaseFrame:AddControl(HelpFrame)
        self:AddControl(BaseFrame)
        return self
    end

    Control.Initialize = function(self)
        if self.Initialized then return end
        for jkey, jvalue in ipairs(self.Lines) do
            local Tw, Th = draw.GetTextSize(jvalue)
            local BaseFrame = findControlByParent(self, self.CreatedComponentNames.BaseFrame)
            local InnerFrame = findControlByParent(self, self.CreatedComponentNames.InnerFrame)
            local HelpFrame = findControlByParent(self, self.CreatedComponentNames.HelpFrame)
            local TextLayout = findControlByParent(self, self.CreatedComponentNames.TextLayout)

            if BaseFrame == nil or InnerFrame == nil or HelpFrame == nil or TextLayout == nil then return end

            if tonumber(Tw) >= tonumber(TextLayout.Width) then
                InnerFrame.Width = Tw
                TextLayout.Width = Tw
            end

            if tonumber(Th) >= tonumber(TextLayout.ScrollHeight) then
                TextLayout.ScrollHeight = Th
            end

            local TextComponent = CreateLabel({
                type = "panel",
                name = enc(jvalue),
                parent = self.CreatedComponentNames.TextLayout,
                x = 0,
                y = 0,
                width = TextLayout.Width,
                height = Th + 5,
                text = jvalue,
                color = "255,255,255,255"
            })

            InnerFrame.Height = InnerFrame.Height + Th + 5
            TextLayout.Height = TextLayout.Height + Th + 5
            TextLayout.AddItem(TextComponent)

            BaseFrame.Width = InnerFrame.Width + (InnerFrame.SetX*2)
            BaseFrame.Height = InnerFrame.Height + (InnerFrame.SetY*2)

            HelpFrame.SetX = BaseFrame.Width - HelpFrame.Width - 5
            HelpFrame.Background = {255,255,255,255}
        end
        self.Initialized = true
        return self
    end

    Control:CreateComponentBase()

    Control.RenderDynamicBase = function(self)
        local mouseX, mouseY = input.GetMousePos()
        for _, control in ipairs(self.Children) do
            if self.Toggled then
                if control.X ~= 0 and control.Y ~= 0 and self.Toggled then
                    control.X = control.X
                    control.Y = control.Y
                else
                    control.X = mouseX
                    control.Y = mouseY
                end
                findControlByParent(self, self.CreatedComponentNames.HelpFrame).Visible = false
            else
                findControlByParent(self, self.CreatedComponentNames.HelpFrame).Visible = true
                control.X = mouseX
                control.Y = mouseY
            end
            if input.IsButtonPressed(2) then
                self.Toggled = not self.Toggled
            end
            if input.IsButtonDown(1) then
                self.Toggled = false
            end
            control.Render(control, self)
        end
        return self
    end

    Control.Render = function(self, parent)
        if not self.Visible or not parent.Visible then return self end

        local w, h = draw.GetScreenSize()
        Renderer:Scissor({0, 0}, {w, h})

        local grandparent = getParentControl(parent)
        if grandparent == nil then return end

        if isMouseInRect(parent.X + grandparent.X, parent.Y + grandparent.Y, parent.Width, parent.Height) and not getSelected() or self.Toggled then
            if self.Alignment == "dynamic" then
                self:RenderDynamicBase()
                self:Initialize()
            end
        end
        return self
    end
    return Control
end

--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName