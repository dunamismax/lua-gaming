-- title:  Platformer Mini
-- author: lua-gaming
-- desc:   A mini platformer demo for TIC-80
-- script: lua

local player = {
    x = 50,
    y = 100,
    w = 8,
    h = 8,
    vx = 0,
    vy = 0,
    grounded = false,
    facing = 1,
    anim_frame = 0,
    anim_timer = 0
}

local camera = {
    x = 0,
    y = 0
}

local coins = {}
local particles = {}
local game_state = "playing" -- playing, complete
local score = 0
local level_complete = false

-- Level data (simple tile-based)
local level = {
    "################################",
    "#                              #",
    "#  C     C          C          #",
    "#           ###                #",
    "#                        ###   #",
    "#    ###                       #",
    "#                   ###        #",
    "#           ###                #",
    "#                              #",
    "#                   ###   ###  #",
    "#         ###                  #",
    "#                         C    #",
    "#   ###              ###       #",
    "#                              #",
    "################################"
}

function init()
    -- Initialize coins from level data
    for y = 1, #level do
        for x = 1, #level[y] do
            local char = level[y]:sub(x, x)
            if char == "C" then
                table.insert(coins, {x = (x-1) * 8, y = (y-1) * 8, collected = false})
            end
        end
    end
end

function TIC()
    if game_state == "playing" then
        update_game()
        draw_game()
    else
        draw_complete()
    end
end

function update_game()
    -- Input
    local moving = false
    
    if btn(2) then -- Left
        player.vx = player.vx - 0.5
        player.facing = -1
        moving = true
    end
    
    if btn(3) then -- Right
        player.vx = player.vx + 0.5
        player.facing = 1
        moving = true
    end
    
    if btnp(0) and player.grounded then -- Jump (A button)
        player.vy = -4
        player.grounded = false
    end
    
    -- Animation
    if moving and player.grounded then
        player.anim_timer = player.anim_timer + 1
        if player.anim_timer > 10 then
            player.anim_frame = (player.anim_frame + 1) % 4
            player.anim_timer = 0
        end
    else
        player.anim_frame = 0
    end
    
    -- Physics
    player.vx = player.vx * 0.8 -- Friction
    player.vy = player.vy + 0.2 -- Gravity
    
    -- Limit velocities
    player.vx = math.max(-3, math.min(3, player.vx))
    player.vy = math.max(-5, math.min(5, player.vy))
    
    -- Collision detection and movement
    move_player()
    
    -- Coin collection
    collect_coins()
    
    -- Update camera
    update_camera()
    
    -- Update particles
    update_particles()
    
    -- Check win condition
    local all_collected = true
    for _, coin in ipairs(coins) do
        if not coin.collected then
            all_collected = false
            break
        end
    end
    
    if all_collected then
        game_state = "complete"
    end
end

function move_player()
    -- Horizontal movement
    player.x = player.x + player.vx
    
    -- Horizontal collision
    if check_collision(player.x, player.y) then
        if player.vx > 0 then
            player.x = math.floor(player.x / 8) * 8
        else
            player.x = math.ceil(player.x / 8) * 8
        end
        player.vx = 0
    end
    
    -- Vertical movement
    player.y = player.y + player.vy
    player.grounded = false
    
    -- Vertical collision
    if check_collision(player.x, player.y) then
        if player.vy > 0 then
            player.y = math.floor(player.y / 8) * 8
            player.grounded = true
        else
            player.y = math.ceil(player.y / 8) * 8
        end
        player.vy = 0
    end
end

function check_collision(x, y)
    local left = math.floor(x / 8) + 1
    local right = math.floor((x + player.w - 1) / 8) + 1
    local top = math.floor(y / 8) + 1
    local bottom = math.floor((y + player.h - 1) / 8) + 1
    
    for ty = top, bottom do
        for tx = left, right do
            if ty > 0 and ty <= #level and tx > 0 and tx <= #level[ty] then
                local char = level[ty]:sub(tx, tx)
                if char == "#" then
                    return true
                end
            end
        end
    end
    
    return false
end

function collect_coins()
    for _, coin in ipairs(coins) do
        if not coin.collected then
            local dx = player.x + player.w/2 - (coin.x + 4)
            local dy = player.y + player.h/2 - (coin.y + 4)
            local distance = math.sqrt(dx*dx + dy*dy)
            
            if distance < 8 then
                coin.collected = true
                score = score + 10
                create_coin_particles(coin.x + 4, coin.y + 4)
            end
        end
    end
end

function create_coin_particles(x, y)
    for i = 1, 6 do
        table.insert(particles, {
            x = x,
            y = y,
            vx = (math.random() - 0.5) * 4,
            vy = (math.random() - 0.5) * 4 - 1,
            life = 30,
            color = 14
        })
    end
end

function update_particles()
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.vy = p.vy + 0.1
        p.life = p.life - 1
        
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function update_camera()
    camera.x = player.x - 120
    camera.y = player.y - 68
    
    -- Keep camera in bounds
    camera.x = math.max(0, math.min(camera.x, #level[1] * 8 - 240))
    camera.y = math.max(0, math.min(camera.y, #level * 8 - 136))
end

function draw_game()
    cls(12) -- Light blue background
    
    -- Draw level
    for y = 1, #level do
        for x = 1, #level[y] do
            local char = level[y]:sub(x, x)
            local screen_x = (x-1) * 8 - camera.x
            local screen_y = (y-1) * 8 - camera.y
            
            if char == "#" then
                rect(screen_x, screen_y, 8, 8, 5) -- Green blocks
            end
        end
    end
    
    -- Draw coins
    for _, coin in ipairs(coins) do
        if not coin.collected then
            local screen_x = coin.x - camera.x
            local screen_y = coin.y - camera.y
            local frame = math.floor(time() / 500) % 4
            
            -- Animated coin
            circ(screen_x + 4, screen_y + 4, 3 + math.sin(time() / 200), 14)
            circ(screen_x + 4, screen_y + 4, 2, 4)
        end
    end
    
    -- Draw particles
    for _, p in ipairs(particles) do
        local screen_x = p.x - camera.x
        local screen_y = p.y - camera.y
        local alpha = p.life / 30
        
        if alpha > 0 then
            pix(screen_x, screen_y, p.color)
        end
    end
    
    -- Draw player
    local screen_x = player.x - camera.x
    local screen_y = player.y - camera.y
    
    -- Simple player sprite
    rect(screen_x, screen_y, player.w, player.h, 6) -- Pink
    
    -- Eyes
    pix(screen_x + 2, screen_y + 2, 0)
    pix(screen_x + 5, screen_y + 2, 0)
    
    -- Animation effect
    if player.anim_frame > 0 and player.grounded then
        pix(screen_x + 1, screen_y + player.h, 6)
        pix(screen_x + 6, screen_y + player.h, 6)
    end
    
    -- UI
    print("Score: " .. score, 5, 5, 15)
    print("Coins: " .. count_coins_left(), 5, 15, 15)
    print("Arrow keys: Move, Z: Jump", 5, 125, 15)
end

function draw_complete()
    cls(0)
    
    local text = "Level Complete!"
    local text_width = print(text, 0, -10, 0) -- Get width
    print(text, 120 - text_width/2, 60, 14)
    
    print("Final Score: " .. score, 80, 80, 15)
    print("Press R to restart", 70, 100, 6)
    
    if btnp(6) then -- R key
        restart_game()
    end
end

function count_coins_left()
    local count = 0
    for _, coin in ipairs(coins) do
        if not coin.collected then
            count = count + 1
        end
    end
    return count
end

function restart_game()
    player.x = 50
    player.y = 100
    player.vx = 0
    player.vy = 0
    player.grounded = false
    
    score = 0
    game_state = "playing"
    
    -- Reset coins
    for _, coin in ipairs(coins) do
        coin.collected = false
    end
    
    particles = {}
end

-- Initialize the game
init()