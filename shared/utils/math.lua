local mathutils = {}

function mathutils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function mathutils.lerp(a, b, t)
    return a + (b - a) * t
end

function mathutils.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

function mathutils.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function mathutils.normalize(x, y)
    local length = math.sqrt(x * x + y * y)
    if length == 0 then
        return 0, 0
    end
    return x / length, y / length
end

function mathutils.randomFloat(min, max)
    return min + math.random() * (max - min)
end

function mathutils.randomInt(min, max)
    return math.floor(mathutils.randomFloat(min, max + 1))
end

function mathutils.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

function mathutils.round(x, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(x * mult + 0.5) / mult
end

function mathutils.wrap(value, min, max)
    local range = max - min
    if range <= 0 then
        return min
    end
    
    local result = value
    while result < min do
        result = result + range
    end
    while result >= max do
        result = result - range
    end
    return result
end

function mathutils.smoothstep(edge0, edge1, x)
    local t = mathutils.clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)
end

function mathutils.approach(current, target, increment)
    increment = math.abs(increment)
    if current < target then
        return math.min(current + increment, target)
    else
        return math.max(current - increment, target)
    end
end

return mathutils