-- title:  TIC-80 Template
-- author: lua-gaming
-- desc:   Basic template for TIC-80 games
-- script: lua

local game_time = 0
local player = {
    x = 120,
    y = 68,
    color = 6
}

local objects = {}

function init()
    -- Create some demo objects
    for i = 1, 10 do
        table.insert(objects, {
            x = math.random(0, 240),
            y = math.random(0, 136),
            vx = (math.random() - 0.5) * 2,
            vy = (math.random() - 0.5) * 2,
            color = math.random(1, 15),
            size = math.random(2, 6)
        })
    end
end

function TIC()
    update()
    draw()
end

function update()
    game_time = game_time + 1
    
    -- Player movement
    if btn(0) then player.y = player.y - 1 end -- Up
    if btn(1) then player.y = player.y + 1 end -- Down
    if btn(2) then player.x = player.x - 1 end -- Left
    if btn(3) then player.x = player.x + 1 end -- Right
    
    -- Keep player on screen
    player.x = math.max(0, math.min(240 - 8, player.x))
    player.y = math.max(0, math.min(136 - 8, player.y))
    
    -- Update objects
    for _, obj in ipairs(objects) do
        obj.x = obj.x + obj.vx
        obj.y = obj.y + obj.vy
        
        -- Bounce off edges
        if obj.x <= 0 or obj.x >= 240 then
            obj.vx = -obj.vx
        end
        if obj.y <= 0 or obj.y >= 136 then
            obj.vy = -obj.vy
        end
    end
end

function draw()
    cls(1) -- Dark blue background
    
    -- Draw objects
    for _, obj in ipairs(objects) do
        circ(obj.x, obj.y, obj.size, obj.color)
    end
    
    -- Draw player
    rect(player.x, player.y, 8, 8, player.color)
    
    -- UI
    print("TIC-80 Template", 5, 5, 15)
    print("Time: " .. math.floor(game_time / 60), 5, 15, 14)
    print("Arrow keys: Move", 5, 120, 12)
end

-- Initialize the game
init()