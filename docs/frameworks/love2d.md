# LÖVE 2D Framework Guide

LÖVE is a free, open-source 2D game framework for Lua. It provides a simple yet powerful API for creating 2D games across multiple platforms.

## Installation

Download LÖVE from [love2d.org](https://love2d.org) for your platform.

### Running Games
```bash
# Run from game directory
love .

# Run specific .love file
love mygame.love

# Run from any directory
love /path/to/game/directory
```

## Core Concepts

### Main Callbacks
```lua
function love.load()
    -- Initialize your game
end

function love.update(dt)
    -- Update game logic
    -- dt = delta time in seconds
end

function love.draw()
    -- Draw everything
end

function love.keypressed(key)
    -- Handle key press events
end
```

### Configuration
Create a `conf.lua` file to configure your game:
```lua
function love.conf(t)
    t.title = "My Game"
    t.version = "11.4"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
end
```

## Graphics

### Basic Drawing
```lua
function love.draw()
    -- Set color (red, green, blue, alpha) - values 0-1
    love.graphics.setColor(1, 0, 0, 1) -- Red
    
    -- Draw shapes
    love.graphics.rectangle("fill", 100, 100, 50, 30)
    love.graphics.circle("line", 200, 200, 25)
    love.graphics.line(0, 0, 100, 100)
    
    -- Draw text
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("Hello, World!", 10, 10)
end
```

### Images and Sprites
```lua
local playerImage

function love.load()
    playerImage = love.graphics.newImage("player.png")
end

function love.draw()
    -- Draw image at position
    love.graphics.draw(playerImage, 100, 100)
    
    -- Draw with rotation and scale
    love.graphics.draw(playerImage, 200, 200, math.pi/4, 2, 2)
end
```

### Transformations
```lua
function love.draw()
    love.graphics.push() -- Save current transformation
    
    love.graphics.translate(400, 300) -- Move origin
    love.graphics.rotate(love.timer.getTime()) -- Rotate
    love.graphics.scale(2, 2) -- Scale
    
    love.graphics.rectangle("fill", -25, -25, 50, 50)
    
    love.graphics.pop() -- Restore transformation
end
```

## Input

### Keyboard
```lua
function love.update(dt)
    if love.keyboard.isDown("space") then
        -- Space is held down
    end
    
    if love.keyboard.isDown("left", "a") then
        player.x = player.x - speed * dt
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
```

### Mouse
```lua
function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        print("Clicked at", x, y)
    end
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    -- Use mouse position
end
```

## Audio

### Sound Effects
```lua
local jumpSound

function love.load()
    jumpSound = love.audio.newSource("jump.wav", "static")
end

function jump()
    jumpSound:play()
end
```

### Music
```lua
local backgroundMusic

function love.load()
    backgroundMusic = love.audio.newSource("music.ogg", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()
end
```

## Physics (Box2D)

```lua
local world, ground, ball

function love.load()
    -- Create physics world with gravity
    world = love.physics.newWorld(0, 9.81*64, true)
    
    -- Create ground
    ground = {}
    ground.body = love.physics.newBody(world, 650/2, 650-50/2)
    ground.shape = love.physics.newRectangleShape(650, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    
    -- Create ball
    ball = {}
    ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    ball.shape = love.physics.newCircleShape(20)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(0.9) -- Bounciness
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.circle("line", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
    love.graphics.polygon("line", ground.body:getWorldPoints(ground.shape:getPoints()))
end
```

## Game Architecture Patterns

### Simple Game State
```lua
local gameState = "menu" -- menu, playing, paused, gameover

function love.update(dt)
    if gameState == "menu" then
        updateMenu(dt)
    elseif gameState == "playing" then
        updateGame(dt)
    end
end

function love.draw()
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "playing" then
        drawGame()
    end
end
```

### Object-Oriented Entities
```lua
local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.speed = 200
    self.image = love.graphics.newImage("player.png")
    return self
end

function Player:update(dt)
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

-- Usage
local player = Player.new(100, 100)
```

### Using Shared Libraries
```lua
-- Use the monorepo's shared libraries
local lume = require("../../../shared/libs/lume")
local tween = require("../../../shared/libs/tween")
local collision = require("../../../shared/utils/collision")

-- Create a tween animation
local playerTween = tween.new(1, player, {x = 200}, 'outBounce')

-- Use collision detection
if collision.rectRect(player.x, player.y, 32, 32, enemy.x, enemy.y, 32, 32) then
    -- Handle collision
end
```

## Performance Tips

### Efficient Drawing
```lua
-- Batch similar draw calls
love.graphics.setColor(1, 0, 0)
for _, enemy in ipairs(enemies) do
    love.graphics.draw(enemyImage, enemy.x, enemy.y)
end

-- Use Canvas for complex scenes
local canvas = love.graphics.newCanvas(800, 600)
love.graphics.setCanvas(canvas)
-- Draw complex background
love.graphics.setCanvas() -- Reset to screen

function love.draw()
    love.graphics.draw(canvas) -- Draw pre-rendered background
    -- Draw dynamic objects
end
```

### Memory Management
```lua
-- Reuse objects instead of creating new ones
local bulletPool = {}
for i = 1, 100 do
    bulletPool[i] = {x = 0, y = 0, active = false}
end

function spawnBullet(x, y)
    for _, bullet in ipairs(bulletPool) do
        if not bullet.active then
            bullet.x = x
            bullet.y = y
            bullet.active = true
            break
        end
    end
end
```

## Common Patterns

### Delta Time Movement
```lua
function love.update(dt)
    -- Always multiply movement by delta time
    player.x = player.x + player.velocity * dt
    
    -- For animations
    player.animationTimer = player.animationTimer + dt
    if player.animationTimer > 0.1 then
        player.animationTimer = 0
        player.frame = (player.frame + 1) % 4
    end
end
```

### Screen Boundaries
```lua
function keepOnScreen(object)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    object.x = math.max(0, math.min(width - object.width, object.x))
    object.y = math.max(0, math.min(height - object.height, object.y))
end
```

### Simple Camera
```lua
local camera = {x = 0, y = 0}

function updateCamera()
    camera.x = player.x - love.graphics.getWidth() / 2
    camera.y = player.y - love.graphics.getHeight() / 2
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    
    -- Draw world objects here
    
    love.graphics.pop()
    
    -- Draw UI elements here (unaffected by camera)
end
```

## Debugging

### Debug Information
```lua
function love.draw()
    -- Your game rendering
    
    -- Debug overlay
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("Player: " .. player.x .. ", " .. player.y, 10, 30)
end
```

### Console Output
```lua
function love.load()
    print("Game started!")
    io.stdout:setvbuf("no") -- Make print() work immediately
end
```

## Distribution

### Creating .love Files
```bash
# Zip your game directory (excluding .git, etc.)
zip -r mygame.love . -x "*.git*" "*.DS_Store*"
```

### Building Executables
Use tools like [love-release](https://github.com/MisterDA/love-release) or manual distribution methods described in the [LÖVE wiki](https://love2d.org/wiki/Game_Distribution).

## Resources

- [LÖVE Wiki](https://love2d.org/wiki/Main_Page) - Official documentation
- [LÖVE Forums](https://love2d.org/forums/) - Community support
- [Awesome LÖVE](https://github.com/love2d-community/awesome-love2d) - Curated list of libraries
- [LÖVE Tutorials](https://love2d.org/wiki/Category:Tutorials) - Learning resources

## Example: Complete Mini Game
See `games/love2d/asteroids-2d/` for a complete example of a LÖVE game using the patterns described in this guide.