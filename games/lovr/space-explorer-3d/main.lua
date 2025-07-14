local spaceship = {
    position = {0, 1.7, -3},
    rotation = {0, 0, 0},
    velocity = {0, 0, 0},
    thrust = 0,
    size = 0.3
}

local asteroids = {}
local particles = {}
local camera = {
    position = {0, 2, 0},
    rotation = {0, 0, 0}
}

local score = 0
local gameTime = 0
local stars = {}

function lovr.load()
    lovr.headset.setClipDistance(0.1, 1000)
    
    initStars()
    initAsteroids()
    
    lovr.graphics.setBackgroundColor(0.02, 0.02, 0.1)
end

function initStars()
    stars = {}
    for i = 1, 200 do
        table.insert(stars, {
            x = math.random(-50, 50),
            y = math.random(-50, 50),
            z = math.random(-50, 50),
            brightness = math.random(0.3, 1.0)
        })
    end
end

function initAsteroids()
    asteroids = {}
    for i = 1, 15 do
        createAsteroid()
    end
end

function createAsteroid()
    local asteroid = {
        position = {
            math.random(-20, 20),
            math.random(-10, 10),
            math.random(-20, 5)
        },
        rotation = {
            math.random() * math.pi * 2,
            math.random() * math.pi * 2,
            math.random() * math.pi * 2
        },
        rotationSpeed = {
            math.random(-1, 1),
            math.random(-1, 1),
            math.random(-1, 1)
        },
        velocity = {
            math.random(-2, 2),
            math.random(-2, 2),
            math.random(-2, 2)
        },
        size = math.random(0.3, 1.2),
        health = 1
    }
    table.insert(asteroids, asteroid)
end

function createExplosion(x, y, z, count)
    for i = 1, count or 10 do
        local particle = {
            position = {x, y, z},
            velocity = {
                math.random(-5, 5),
                math.random(-5, 5),
                math.random(-5, 5)
            },
            life = math.random(1, 3),
            maxLife = math.random(1, 3),
            size = math.random(0.02, 0.1),
            color = {
                math.random(0.8, 1),
                math.random(0.3, 0.8),
                math.random(0, 0.3)
            }
        }
        particle.maxLife = particle.life
        table.insert(particles, particle)
    end
end

function lovr.update(dt)
    gameTime = gameTime + dt
    
    updateSpaceship(dt)
    updateAsteroids(dt)
    updateParticles(dt)
    updateCamera(dt)
    checkCollisions()
    
    if #asteroids < 10 then
        createAsteroid()
    end
end

function updateSpaceship(dt)
    local leftHand = lovr.headset.getPose('hand/left')
    local rightHand = lovr.headset.getPose('hand/right')
    
    if lovr.headset.isDown('hand/right', 'trigger') or lovr.system.isKeyDown('space') then
        spaceship.thrust = 8
        spaceship.velocity[3] = spaceship.velocity[3] + spaceship.thrust * dt
    else
        spaceship.thrust = 0
    end
    
    if lovr.headset.isDown('hand/left', 'trigger') or lovr.system.isKeyDown('w') then
        spaceship.velocity[2] = spaceship.velocity[2] + 5 * dt
    end
    
    if lovr.system.isKeyDown('a') then
        spaceship.velocity[1] = spaceship.velocity[1] - 5 * dt
    elseif lovr.system.isKeyDown('d') then
        spaceship.velocity[1] = spaceship.velocity[1] + 5 * dt
    end
    
    if lovr.system.isKeyDown('s') then
        spaceship.velocity[2] = spaceship.velocity[2] - 5 * dt
    end
    
    spaceship.velocity[1] = spaceship.velocity[1] * 0.95
    spaceship.velocity[2] = spaceship.velocity[2] * 0.95
    spaceship.velocity[3] = spaceship.velocity[3] * 0.98
    
    for i = 1, 3 do
        spaceship.position[i] = spaceship.position[i] + spaceship.velocity[i] * dt
    end
    
    spaceship.rotation[1] = spaceship.velocity[2] * 0.1
    spaceship.rotation[3] = -spaceship.velocity[1] * 0.1
    
    if spaceship.thrust > 0 then
        createEngineParticles()
    end
end

function createEngineParticles()
    if math.random() > 0.7 then
        local particle = {
            position = {
                spaceship.position[1] + math.random(-0.1, 0.1),
                spaceship.position[2] + math.random(-0.1, 0.1),
                spaceship.position[3] + 0.5
            },
            velocity = {
                math.random(-1, 1),
                math.random(-1, 1),
                math.random(2, 4)
            },
            life = 0.5,
            maxLife = 0.5,
            size = 0.05,
            color = {0.2, 0.5, 1}
        }
        table.insert(particles, particle)
    end
end

function updateAsteroids(dt)
    for i = #asteroids, 1, -1 do
        local asteroid = asteroids[i]
        
        for j = 1, 3 do
            asteroid.position[j] = asteroid.position[j] + asteroid.velocity[j] * dt
            asteroid.rotation[j] = asteroid.rotation[j] + asteroid.rotationSpeed[j] * dt
        end
        
        if asteroid.position[3] > 5 then
            asteroid.position[3] = -25
            asteroid.position[1] = math.random(-20, 20)
            asteroid.position[2] = math.random(-10, 10)
        end
        
        if asteroid.health <= 0 then
            createExplosion(asteroid.position[1], asteroid.position[2], asteroid.position[3], 15)
            score = score + 100
            table.remove(asteroids, i)
        end
    end
end

function updateParticles(dt)
    for i = #particles, 1, -1 do
        local particle = particles[i]
        
        for j = 1, 3 do
            particle.position[j] = particle.position[j] + particle.velocity[j] * dt
        end
        
        particle.life = particle.life - dt
        
        if particle.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function updateCamera(dt)
    camera.position[1] = spaceship.position[1]
    camera.position[2] = spaceship.position[2] + 2
    camera.position[3] = spaceship.position[3] + 5
end

function checkCollisions()
    for i = #asteroids, 1, -1 do
        local asteroid = asteroids[i]
        local distance = math.sqrt(
            (spaceship.position[1] - asteroid.position[1])^2 +
            (spaceship.position[2] - asteroid.position[2])^2 +
            (spaceship.position[3] - asteroid.position[3])^2
        )
        
        if distance < (spaceship.size + asteroid.size) then
            createExplosion(asteroid.position[1], asteroid.position[2], asteroid.position[3], 20)
            asteroid.health = asteroid.health - 1
            
            spaceship.velocity[1] = spaceship.velocity[1] + (spaceship.position[1] - asteroid.position[1]) * 2
            spaceship.velocity[2] = spaceship.velocity[2] + (spaceship.position[2] - asteroid.position[2]) * 2
            spaceship.velocity[3] = spaceship.velocity[3] + (spaceship.position[3] - asteroid.position[3]) * 2
            
            score = score + 50
        end
    end
end

function lovr.draw(pass)
    drawStars(pass)
    drawSpaceship(pass)
    drawAsteroids(pass)
    drawParticles(pass)
    drawUI(pass)
end

function drawStars(pass)
    for _, star in ipairs(stars) do
        pass:setColor(1, 1, 1, star.brightness)
        pass:sphere(star.x, star.y, star.z, 0.02)
    end
end

function drawSpaceship(pass)
    pass:push()
    pass:translate(spaceship.position[1], spaceship.position[2], spaceship.position[3])
    pass:rotate(spaceship.rotation[1], spaceship.rotation[2], spaceship.rotation[3])
    
    pass:setColor(0.8, 0.8, 1)
    pass:box(0, 0, 0, spaceship.size, spaceship.size * 0.5, spaceship.size * 2)
    
    pass:setColor(0.6, 0.8, 1)
    pass:box(0.1, 0, 0.3, spaceship.size * 0.3, spaceship.size * 0.2, spaceship.size * 0.5)
    pass:box(-0.1, 0, 0.3, spaceship.size * 0.3, spaceship.size * 0.2, spaceship.size * 0.5)
    
    if spaceship.thrust > 0 then
        pass:setColor(0.2, 0.7, 1, 0.8)
        pass:box(0, 0, -spaceship.size, spaceship.size * 0.3, spaceship.size * 0.3, spaceship.size * 0.8)
    end
    
    pass:pop()
end

function drawAsteroids(pass)
    for _, asteroid in ipairs(asteroids) do
        pass:push()
        pass:translate(asteroid.position[1], asteroid.position[2], asteroid.position[3])
        pass:rotate(asteroid.rotation[1], asteroid.rotation[2], asteroid.rotation[3])
        
        pass:setColor(0.6, 0.5, 0.4)
        pass:sphere(0, 0, 0, asteroid.size)
        
        pass:setColor(0.4, 0.3, 0.2)
        pass:sphere(0.2, 0.1, 0.1, asteroid.size * 0.3)
        pass:sphere(-0.1, -0.2, 0.2, asteroid.size * 0.2)
        
        pass:pop()
    end
end

function drawParticles(pass)
    for _, particle in ipairs(particles) do
        local alpha = particle.life / particle.maxLife
        pass:setColor(particle.color[1], particle.color[2], particle.color[3], alpha)
        pass:sphere(particle.position[1], particle.position[2], particle.position[3], particle.size * alpha)
    end
end

function drawUI(pass)
    pass:push()
    pass:translate(camera.position[1] - 3, camera.position[2] + 2, camera.position[3] - 5)
    pass:rotate(-0.3, 0.5, 0)
    
    pass:setColor(0, 1, 0, 0.8)
    pass:plane(0, 0, 0, 2, 1.5, 'fill')
    
    pass:setColor(0, 0, 0)
    pass:text("Score: " .. score, 0, 0.3, 0, 0.2)
    pass:text("Time: " .. string.format("%.1f", gameTime), 0, 0, 0, 0.2)
    pass:text("Speed: " .. string.format("%.1f", math.abs(spaceship.velocity[3])), 0, -0.3, 0, 0.2)
    
    pass:pop()
    
    if not lovr.headset.isTracked() then
        pass:push()
        pass:translate(0, 10, -5)
        pass:setColor(1, 1, 1)
        pass:text("WASD: Move, Space: Thrust", 0, 0, 0, 0.5)
        pass:text("VR: Use hand controllers", 0, -1, 0, 0.5)
        pass:pop()
    end
end