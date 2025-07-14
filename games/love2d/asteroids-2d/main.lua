-- Note: Shared libraries can be used like this:
-- local lume = require("../../../shared/libs/lume")
-- local tween = require("../../../shared/libs/tween")

local game = {
    width = 800,
    height = 600,
    player = {},
    asteroids = {},
    bullets = {},
    score = 0,
    lives = 3,
    gameState = "playing",
    particles = {},
    sounds = {},
    font = nil
}

function love.load()
    love.window.setTitle("Asteroids 2D - LÖVE Demo")
    love.window.setMode(game.width, game.height)
    love.graphics.setBackgroundColor(0, 0, 0.1)
    
    game.font = love.graphics.newFont(20)
    love.graphics.setFont(game.font)
    
    initPlayer()
    initAsteroids()
    
    love.audio.setVolume(0.7)
end

function initPlayer()
    game.player = {
        x = game.width / 2,
        y = game.height / 2,
        angle = 0,
        velocity = {x = 0, y = 0},
        size = 8,
        thrust = false,
        maxSpeed = 300,
        friction = 0.98,
        thrustPower = 400
    }
end

function initAsteroids()
    game.asteroids = {}
    for i = 1, 5 do
        createAsteroid(math.random(50, game.width - 50), math.random(50, game.height - 50), "large")
    end
end

function createAsteroid(x, y, size)
    local asteroid = {
        x = x,
        y = y,
        velocity = {
            x = math.random(-100, 100),
            y = math.random(-100, 100)
        },
        angle = math.random() * math.pi * 2,
        rotationSpeed = math.random(-3, 3),
        size = size,
        radius = size == "large" and 30 or size == "medium" and 20 or 10,
        points = {}
    }
    
    local numPoints = math.random(6, 10)
    for i = 1, numPoints do
        local angle = (i / numPoints) * math.pi * 2
        local variance = math.random(0.7, 1.3)
        table.insert(asteroid.points, {
            x = math.cos(angle) * asteroid.radius * variance,
            y = math.sin(angle) * asteroid.radius * variance
        })
    end
    
    table.insert(game.asteroids, asteroid)
end

function createBullet(x, y, angle)
    local bullet = {
        x = x,
        y = y,
        velocity = {
            x = math.cos(angle) * 400,
            y = math.sin(angle) * 400
        },
        life = 2.0
    }
    table.insert(game.bullets, bullet)
end

function createExplosion(x, y, size)
    for i = 1, size * 3 do
        local particle = {
            x = x,
            y = y,
            velocity = {
                x = math.random(-200, 200),
                y = math.random(-200, 200)
            },
            life = math.random(0.5, 1.5),
            maxLife = math.random(0.5, 1.5),
            size = math.random(2, 4)
        }
        particle.maxLife = particle.life
        table.insert(game.particles, particle)
    end
end

function love.update(dt)
    if game.gameState ~= "playing" then return end
    
    updatePlayer(dt)
    updateBullets(dt)
    updateAsteroids(dt)
    updateParticles(dt)
    checkCollisions()
    
    if #game.asteroids == 0 then
        initAsteroids()
        game.score = game.score + 1000
    end
    
    if game.lives <= 0 then
        game.gameState = "gameOver"
    end
end

function updatePlayer(dt)
    local player = game.player
    
    if love.keyboard.isDown("up", "w") then
        player.thrust = true
        local thrustX = math.cos(player.angle) * player.thrustPower * dt
        local thrustY = math.sin(player.angle) * player.thrustPower * dt
        
        player.velocity.x = player.velocity.x + thrustX
        player.velocity.y = player.velocity.y + thrustY
        
        local speed = math.sqrt(player.velocity.x^2 + player.velocity.y^2)
        if speed > player.maxSpeed then
            player.velocity.x = (player.velocity.x / speed) * player.maxSpeed
            player.velocity.y = (player.velocity.y / speed) * player.maxSpeed
        end
    else
        player.thrust = false
    end
    
    if love.keyboard.isDown("left", "a") then
        player.angle = player.angle - 4 * dt
    end
    
    if love.keyboard.isDown("right", "d") then
        player.angle = player.angle + 4 * dt
    end
    
    player.velocity.x = player.velocity.x * player.friction
    player.velocity.y = player.velocity.y * player.friction
    
    player.x = player.x + player.velocity.x * dt
    player.y = player.y + player.velocity.y * dt
    
    player.x = player.x % game.width
    player.y = player.y % game.height
    
    if player.x < 0 then player.x = game.width end
    if player.y < 0 then player.y = game.height end
end

function updateBullets(dt)
    for i = #game.bullets, 1, -1 do
        local bullet = game.bullets[i]
        
        bullet.x = bullet.x + bullet.velocity.x * dt
        bullet.y = bullet.y + bullet.velocity.y * dt
        bullet.life = bullet.life - dt
        
        bullet.x = bullet.x % game.width
        bullet.y = bullet.y % game.height
        
        if bullet.x < 0 then bullet.x = game.width end
        if bullet.y < 0 then bullet.y = game.height end
        
        if bullet.life <= 0 then
            table.remove(game.bullets, i)
        end
    end
end

function updateAsteroids(dt)
    for _, asteroid in ipairs(game.asteroids) do
        asteroid.x = asteroid.x + asteroid.velocity.x * dt
        asteroid.y = asteroid.y + asteroid.velocity.y * dt
        asteroid.angle = asteroid.angle + asteroid.rotationSpeed * dt
        
        asteroid.x = asteroid.x % game.width
        asteroid.y = asteroid.y % game.height
        
        if asteroid.x < 0 then asteroid.x = game.width end
        if asteroid.y < 0 then asteroid.y = game.height end
    end
end

function updateParticles(dt)
    for i = #game.particles, 1, -1 do
        local particle = game.particles[i]
        
        particle.x = particle.x + particle.velocity.x * dt
        particle.y = particle.y + particle.velocity.y * dt
        particle.life = particle.life - dt
        
        if particle.life <= 0 then
            table.remove(game.particles, i)
        end
    end
end

function checkCollisions()
    for i = #game.bullets, 1, -1 do
        local bullet = game.bullets[i]
        
        for j = #game.asteroids, 1, -1 do
            local asteroid = game.asteroids[j]
            local distance = math.sqrt((bullet.x - asteroid.x)^2 + (bullet.y - asteroid.y)^2)
            
            if distance < asteroid.radius then
                createExplosion(asteroid.x, asteroid.y, asteroid.radius)
                game.score = game.score + (asteroid.size == "large" and 20 or asteroid.size == "medium" and 50 or 100)
                
                if asteroid.size == "large" then
                    createAsteroid(asteroid.x - 10, asteroid.y - 10, "medium")
                    createAsteroid(asteroid.x + 10, asteroid.y + 10, "medium")
                elseif asteroid.size == "medium" then
                    createAsteroid(asteroid.x - 5, asteroid.y - 5, "small")
                    createAsteroid(asteroid.x + 5, asteroid.y + 5, "small")
                end
                
                table.remove(game.asteroids, j)
                table.remove(game.bullets, i)
                break
            end
        end
    end
    
    for _, asteroid in ipairs(game.asteroids) do
        local distance = math.sqrt((game.player.x - asteroid.x)^2 + (game.player.y - asteroid.y)^2)
        
        if distance < asteroid.radius + game.player.size then
            createExplosion(game.player.x, game.player.y, 20)
            game.lives = game.lives - 1
            initPlayer()
            break
        end
    end
end

function love.keypressed(key)
    if key == "space" and game.gameState == "playing" then
        createBullet(game.player.x, game.player.y, game.player.angle)
    elseif key == "r" and game.gameState == "gameOver" then
        game.score = 0
        game.lives = 3
        game.gameState = "playing"
        initPlayer()
        initAsteroids()
        game.bullets = {}
        game.particles = {}
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    drawStars()
    
    if game.gameState == "playing" then
        drawPlayer()
        drawAsteroids()
        drawBullets()
    end
    
    drawParticles()
    drawUI()
end

function drawStars()
    love.graphics.setColor(1, 1, 1, 0.3)
    for i = 1, 50 do
        local x = (i * 73) % game.width
        local y = (i * 137) % game.height
        love.graphics.circle("fill", x, y, 1)
    end
end

function drawPlayer()
    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(game.player.x, game.player.y)
    love.graphics.rotate(game.player.angle)
    
    love.graphics.polygon("line", 0, -game.player.size, -game.player.size/2, game.player.size, game.player.size/2, game.player.size)
    
    if game.player.thrust then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.polygon("fill", -3, game.player.size/2, 0, game.player.size + 5, 3, game.player.size/2)
    end
    
    love.graphics.pop()
end

function drawAsteroids()
    love.graphics.setColor(0.8, 0.8, 0.8)
    for _, asteroid in ipairs(game.asteroids) do
        love.graphics.push()
        love.graphics.translate(asteroid.x, asteroid.y)
        love.graphics.rotate(asteroid.angle)
        
        local vertices = {}
        for _, point in ipairs(asteroid.points) do
            table.insert(vertices, point.x)
            table.insert(vertices, point.y)
        end
        
        if #vertices >= 6 then
            love.graphics.polygon("line", vertices)
        end
        
        love.graphics.pop()
    end
end

function drawBullets()
    love.graphics.setColor(1, 1, 0)
    for _, bullet in ipairs(game.bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 2)
    end
end

function drawParticles()
    for _, particle in ipairs(game.particles) do
        local alpha = particle.life / particle.maxLife
        love.graphics.setColor(1, 0.5, 0, alpha)
        love.graphics.circle("fill", particle.x, particle.y, particle.size * alpha)
    end
end

function drawUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. game.score, 10, 10)
    love.graphics.print("Lives: " .. game.lives, 10, 35)
    love.graphics.print("WASD/Arrows: Move, Space: Shoot", 10, game.height - 60)
    love.graphics.print("R: Restart, ESC: Quit", 10, game.height - 35)
    
    if game.gameState == "gameOver" then
        love.graphics.setColor(1, 0, 0)
        local text = "GAME OVER - Press R to Restart"
        local textWidth = game.font:getWidth(text)
        love.graphics.print(text, (game.width - textWidth) / 2, game.height / 2)
    end
end