Renderer = {}

local draw_Triangle, draw_Scissor, draw_Color, draw_FilledRect, draw_Text, draw_ShadowRect, draw_RoundedRectFill, draw_TextP, draw_OutlinedRect, draw_RoundedRect =  draw.Triangle, draw.SetScissorRect, draw.Color, draw.FilledRect, draw.TextShadow, draw.ShadowRect, draw.RoundedRectFill, draw.Text, draw.OutlinedRect, draw.RoundedRect

-- By: CarterPoe
function Renderer:FilledRectangle(cord, size, color)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_FilledRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2]) -- Draw filled rectangle using the specified parameters
end

-- By: CarterPoe
function Renderer:FilledRoundedRectangle(cord, size, color, roundness)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_RoundedRectFill(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], roundness[1], roundness[2], roundness[3], roundness[4], roundness[5]) -- Draw filled rectangle using the specified parameters
end

-- By: CarterPoe
function Renderer:OutlinedRoundedRectangle(cord, size, color, roundness)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_RoundedRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], roundness[1], roundness[2], roundness[3], roundness[4], roundness[5]) -- Draw filled rectangle using the specified parameters
end

-- By: CarterPoe
function Renderer:ShadowRectangle(cord, size, color, radius)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_ShadowRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], radius) -- Draw filled rectangle using the specified parameters
end

-- By: CarterPoe
function Renderer:OutlinedRectangle(cord, size, color)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_OutlinedRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2]) -- Draw filled rectangle using the specified parameters
end

-- By: CarterPoe
function Renderer:Text(cord, color, text)
    draw_Color(color[1], color[2], color[3], color[4])
    draw_Text(cord[1], cord[2], text);
end

-- By: CarterPoe
function Renderer:TextP(cord, color, text)
    draw_Color(color[1], color[2], color[3], color[4])
    draw_TextP(cord[1], cord[2], text);
end

-- By: CarterPoe
function Renderer:Scissor(cord, size)
    draw_Scissor(cord[1], cord[2], size[1], size[2]);
end

-- By: Agentsix1
function Renderer:RoundedRectangleBorder(cord, size, outer_color, inner_color, roundness, thickness)
    draw_Color(outer_color[1], outer_color[2], outer_color[3], outer_color[4]) -- Set color to white
    draw_RoundedRectFill(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], roundness) -- Draw filled rectangle using the specified parameters
	draw_Color(inner_color[1], inner_color[2], inner_color[3], inner_color[4]) -- Set color to white
    draw_RoundedRectFill(cord[1] + thickness, cord[2] + thickness, cord[1] + size[1] - thickness , cord[2] + size[2] - thickness, roundness) -- Draw filled rectangle using the specified parameters
end

-- By: Agentsix1
function Renderer:RectangleBorder(cord, size, outer_color, inner_color, thickness)
    draw_Color(outer_color[1], outer_color[2], outer_color[3], outer_color[4]) -- Set color to white
    draw_FilledRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2]) -- Draw filled rectangle using the specified parameters
	draw_Color(inner_color[1], inner_color[2], inner_color[3], inner_color[4]) -- Set color to white
    draw_FilledRect(cord[1] + thickness, cord[2] + thickness, cord[1] + size[1] - thickness , cord[2] + size[2] - thickness) -- Draw filled rectangle using the specified parameters
end

function Renderer:Triangle(cord1, cord2, cord3, color)
    draw_Color(color[1], color[2], color[3], color[4])
    draw_Triangle(cord1[1], cord1[2], cord2[1], cord2[2], cord3[1], cord3[2])
end


return Renderer