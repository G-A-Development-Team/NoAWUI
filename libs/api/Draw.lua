Draw = {}

-- By: Agentsix1
function Draw:Point(x, y)
    return { x, y }
end

-- By: Agentsix1
function Draw:Size(width, height)
    return { width, height }
end

-- By: Agentsix1
function Draw:Color(r, g, b, a)
    return { r, g, b, a }
end


return Draw