Renderer = {}

local draw_Scissor, draw_Color, draw_FilledRect, draw_Text, draw_ShadowRect, draw_RoundedRectFill, draw_TextP, draw_OutlinedRect, draw_RoundedRect =  draw.SetScissorRect, draw.Color, draw.FilledRect, draw.TextShadow, draw.ShadowRect, draw.RoundedRectFill, draw.Text, draw.OutlinedRect, draw.RoundedRect

function Renderer:FilledRectangle(cord, size, color)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_FilledRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2]) -- Draw filled rectangle using the specified parameters
end

function Renderer:FilledRoundedRectangle(cord, size, color, roundness)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_RoundedRectFill(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], roundness[1], roundness[2], roundness[3], roundness[4], roundness[5]) -- Draw filled rectangle using the specified parameters
end

function Renderer:OutlinedRoundedRectangle(cord, size, color, roundness)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_RoundedRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], roundness[1], roundness[2], roundness[3], roundness[4], roundness[5]) -- Draw filled rectangle using the specified parameters
end

function Renderer:ShadowRectangle(cord, size, color, radius)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_ShadowRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2], radius) -- Draw filled rectangle using the specified parameters
end

function Renderer:OutlinedRectangle(cord, size, color, radius)
    draw_Color(color[1], color[2], color[3], color[4]) -- Set color to white
    draw_OutlinedRect(cord[1], cord[2], cord[1] + size[1], cord[2] + size[2]) -- Draw filled rectangle using the specified parameters
end

function Renderer:Text(cord, color, text)
    draw_Color(color[1], color[2], color[3], color[4])
    draw_Text(cord[1], cord[2], text);
end

function Renderer:TextP(cord, color, text)
    draw_Color(color[1], color[2], color[3], color[4])
    draw_TextP(cord[1], cord[2], text);
end

function Renderer:Scissor(cord, size)
    draw_Scissor(cord[1], cord[2], size[1], size[2]);
end


return Renderer