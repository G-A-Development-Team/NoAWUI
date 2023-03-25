
-- By: CarterPoe
function CreateControl()
    return {
        Type = "control",
        Group = "",
        Name = "",
        X = 0,
        Y = 0,
        SetX = 0,
        SetY = 0,
        AdditionalX = 0,
        AdditionalY = 0,
        AdditionalWidth = 0,
        AdditionalHeight = 0,
        Width = 0,
        Height = 0,
        Drag = false,
        Background = {0, 0, 0, 0},
        ActiveBackground = {0, 0, 0, 0},
        Color = {0, 0, 0, 0},
        BorderColor = {0, 0, 0, 0},
        Children = {},
        Parent = "",
        MouseDown = "",

        isDragging = false,
        dragOffsetX = 0,
        dragOffsetY = 0,
        lastMouseX = 0,
        lastMouseY = 0,
        MAX_DRAG_DISTANCE = 0,

        Roundness = {},
        Rounded = false,

        Text = "",
        FontFamily = "Arial",
        FontHeight = 21,
        FontWeight = 100,
        CreatedFont = nil,

        Reference = nil,

        Visible = true,
        Active = false,
        Selected = false,
        BackgroundImage = nil,
        CreatedBackgroundImage = false,

        Render = function(properties) end,
        AWInitV = false,
        AWInit = function(properties, x, y, x2, y2)
            if true then
                properties.X = x + properties.AdditionalX
                properties.Y = y + properties.AdditionalY
                properties.Width = x2 -properties.X + properties.AdditionalWidth
                properties.Height = y2 -properties.Y + properties.AdditionalHeight
                properties.AWInitV = true 
            end
            return properties
        end,
    }
end

file.Enumerate(function(filepath)
		if string.starts(filepath, "WinForm/Controls/") then
			RunScript(filepath)
			print(filepath)
		end
	end)