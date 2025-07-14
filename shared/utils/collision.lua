local collision = {}

function collision.pointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

function collision.rectRect(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function collision.circleCircle(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (r1 + r2)
end

function collision.pointInCircle(px, py, cx, cy, radius)
    local dx = px - cx
    local dy = py - cy
    return (dx * dx + dy * dy) < (radius * radius)
end

function collision.circleRect(cx, cy, radius, rx, ry, rw, rh)
    local nearestX = math.max(rx, math.min(cx, rx + rw))
    local nearestY = math.max(ry, math.min(cy, ry + rh))
    
    local dx = cx - nearestX
    local dy = cy - nearestY
    
    return (dx * dx + dy * dy) < (radius * radius)
end

function collision.linePoint(x1, y1, x2, y2, px, py, tolerance)
    tolerance = tolerance or 1
    
    local distance = collision.pointToLineDistance(px, py, x1, y1, x2, y2)
    return distance <= tolerance
end

function collision.pointToLineDistance(px, py, x1, y1, x2, y2)
    local A = px - x1
    local B = py - y1
    local C = x2 - x1
    local D = y2 - y1
    
    local dot = A * C + B * D
    local lenSq = C * C + D * D
    
    if lenSq == 0 then
        return math.sqrt(A * A + B * B)
    end
    
    local param = dot / lenSq
    
    local xx, yy
    
    if param < 0 then
        xx = x1
        yy = y1
    elseif param > 1 then
        xx = x2
        yy = y2
    else
        xx = x1 + param * C
        yy = y1 + param * D
    end
    
    local dx = px - xx
    local dy = py - yy
    
    return math.sqrt(dx * dx + dy * dy)
end

function collision.lineLine(x1, y1, x2, y2, x3, y3, x4, y4)
    local denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    
    if denom == 0 then
        return false
    end
    
    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
    local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom
    
    if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
        return true, x1 + t * (x2 - x1), y1 + t * (y2 - y1)
    end
    
    return false
end

function collision.lineRect(x1, y1, x2, y2, rx, ry, rw, rh)
    if collision.linePoint(x1, y1, x2, y2, rx, ry) or
       collision.linePoint(x1, y1, x2, y2, rx + rw, ry) or
       collision.linePoint(x1, y1, x2, y2, rx, ry + rh) or
       collision.linePoint(x1, y1, x2, y2, rx + rw, ry + rh) then
        return true
    end
    
    if collision.lineLine(x1, y1, x2, y2, rx, ry, rx + rw, ry) or
       collision.lineLine(x1, y1, x2, y2, rx + rw, ry, rx + rw, ry + rh) or
       collision.lineLine(x1, y1, x2, y2, rx + rw, ry + rh, rx, ry + rh) or
       collision.lineLine(x1, y1, x2, y2, rx, ry + rh, rx, ry) then
        return true
    end
    
    if collision.pointInRect(x1, y1, rx, ry, rw, rh) and collision.pointInRect(x2, y2, rx, ry, rw, rh) then
        return true
    end
    
    return false
end

return collision