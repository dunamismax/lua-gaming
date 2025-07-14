# Best Practices for Lua Game Development

This document outlines best practices for developing games in the Lua Gaming monorepo.

## Code Organization

### Project Structure
```
my-game/
├── main.lua              # Entry point
├── conf.lua              # Configuration (LÖVE only)
├── src/                  # Source code
│   ├── entities/         # Game objects
│   ├── systems/          # Game systems
│   ├── states/           # Game states
│   └── utils/            # Utility functions
├── assets/               # Game assets
│   ├── images/
│   ├── sounds/
│   └── fonts/
└── README.md
```

### Module Organization
```lua
-- Good: Clear module structure
local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.health = 100
    return self
end

function Player:update(dt)
    -- Update logic here
end

function Player:draw()
    -- Drawing logic here
end

return Player
```

### Avoid Global Variables
```lua
-- Bad: Global variables
player_x = 100
enemy_count = 5

-- Good: Local variables and modules
local game = {
    player = {x = 100, y = 100},
    enemies = {},
    score = 0
}
```

## Performance Optimization

### Efficient Table Operations
```lua
-- Pre-allocate tables when possible
local particles = {}
for i = 1, 100 do
    particles[i] = {x = 0, y = 0, active = false}
end

-- Reuse objects instead of creating new ones
function spawnParticle()
    for i = 1, #particles do
        if not particles[i].active then
            particles[i].active = true
            particles[i].x = player.x
            particles[i].y = player.y
            break
        end
    end
end
```

### Local Variables
```lua
-- Good: Cache frequently used values
local sin, cos = math.sin, math.cos
local graphics = love.graphics

function love.draw()
    graphics.circle("fill", 100, 100, 50)
end
```

### Avoid String Concatenation in Loops
```lua
-- Bad: Creates many temporary strings
local result = ""
for i = 1, 1000 do
    result = result .. tostring(i)
end

-- Good: Use table.concat
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local result = table.concat(parts)
```

## Game Architecture

### Use Entity-Component-System (ECS)
```lua
-- Entity: Just an ID
local entity = {id = 1}

-- Components: Pure data
local Transform = {x = 0, y = 0, rotation = 0}
local Velocity = {dx = 0, dy = 0}
local Sprite = {image = nil, scale = 1}

-- Systems: Logic that operates on components
local MovementSystem = {}
function MovementSystem.update(entities, dt)
    for _, entity in ipairs(entities) do
        if entity.transform and entity.velocity then
            entity.transform.x = entity.transform.x + entity.velocity.dx * dt
            entity.transform.y = entity.transform.y + entity.velocity.dy * dt
        end
    end
end
```

### State Management
```lua
local gamestate = require("shared/utils/gamestate")

-- Define states clearly
local states = {
    menu = require("src/states/menu"),
    playing = require("src/states/playing"),
    paused = require("src/states/paused"),
    gameover = require("src/states/gameover")
}

-- Register all states
for name, state in pairs(states) do
    gamestate.register(name, state)
end
```

### Input Handling
```lua
-- Centralized input mapping
local input = {
    bindings = {
        move_left = {"a", "left"},
        move_right = {"d", "right"},
        jump = {"space", "up", "w"},
        pause = {"escape", "p"}
    },
    
    pressed = {},
    held = {},
    released = {}
}

function input.isPressed(action)
    for _, key in ipairs(input.bindings[action] or {}) do
        if input.pressed[key] then
            return true
        end
    end
    return false
end
```

## Asset Management

### Asset Loading
```lua
-- Centralized asset manager
local Assets = {}
local cache = {}

function Assets.load(type, name, path)
    local key = type .. ":" .. name
    if not cache[key] then
        if type == "image" then
            cache[key] = love.graphics.newImage(path)
        elseif type == "sound" then
            cache[key] = love.audio.newSource(path, "static")
        end
    end
    return cache[key]
end

function Assets.get(type, name)
    local key = type .. ":" .. name
    return cache[key]
end
```

### Resource Cleanup
```lua
-- Clean up resources when changing states
function GameState:leave()
    -- Release large assets
    self.backgroundMusic:stop()
    self.backgroundMusic = nil
    
    -- Clear particle systems
    for i = #self.particles, 1, -1 do
        table.remove(self.particles, i)
    end
end
```

## Error Handling

### Defensive Programming
```lua
function player.takeDamage(amount)
    if not amount or amount < 0 then
        error("Invalid damage amount: " .. tostring(amount))
    end
    
    player.health = math.max(0, player.health - amount)
    
    if player.health <= 0 then
        player.die()
    end
end
```

### Graceful Degradation
```lua
function loadOptionalAsset(path)
    local success, result = pcall(love.graphics.newImage, path)
    if success then
        return result
    else
        print("Warning: Could not load " .. path .. ", using placeholder")
        return createPlaceholderImage()
    end
end
```

## Testing

### Unit Testing Pattern
```lua
-- Simple testing framework
local Test = {}

function Test.assert(condition, message)
    if not condition then
        error("Test failed: " .. (message or "assertion failed"))
    end
end

function Test.run()
    -- Test math utilities
    local mathutils = require("shared/utils/math")
    Test.assert(mathutils.clamp(5, 0, 10) == 5, "clamp should return input when in range")
    Test.assert(mathutils.clamp(-5, 0, 10) == 0, "clamp should return min when below range")
    Test.assert(mathutils.clamp(15, 0, 10) == 10, "clamp should return max when above range")
    
    print("All tests passed!")
end
```

## Documentation

### Code Comments
```lua
-- Good: Explain why, not what
function updateEnemyAI(enemy, dt)
    -- Use state machine to make AI behavior predictable and debuggable
    if enemy.state == "patrol" then
        -- Check if player is in detection range before switching to chase
        local distanceToPlayer = calculateDistance(enemy, player)
        if distanceToPlayer < enemy.detectionRange then
            enemy.state = "chase"
            enemy.chaseStartTime = love.timer.getTime()
        end
    end
end
```

### Function Documentation
```lua
---Calculates the distance between two points
---@param x1 number First point x coordinate
---@param y1 number First point y coordinate  
---@param x2 number Second point x coordinate
---@param y2 number Second point y coordinate
---@return number distance The distance between the points
function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
```

## Version Control

### Commit Messages
```
# Good commit messages
feat: add player dash ability
fix: resolve collision detection bug with moving platforms
refactor: extract enemy AI into separate module
docs: update installation instructions

# Bad commit messages
"update"
"fix bug"
"changes"
```

### File Organization
```gitignore
# .gitignore for game projects
*.love
*.exe
builds/
dist/
.vscode/
*.tmp
*.log
```

## Framework-Specific Tips

### LÖVE 2D
- Use `love.graphics.push()` and `love.graphics.pop()` for transformations
- Batch draw calls when possible
- Use `love.graphics.setCanvas()` for render-to-texture effects
- Profile with `love.graphics.getStats()`

### LÖVR
- Cache frequently used headset poses
- Use instanced rendering for repeated objects
- Optimize for VR framerates (90+ FPS)
- Test on multiple VR devices

### PICO-8
- Embrace the limitations as creative constraints
- Use token optimization techniques
- Leverage PICO-8's built-in map and sprite editors
- Keep code under the 8192 token limit

### TIC-80
- Use the built-in code editor and tools
- Optimize for the 64KB cartridge size
- Take advantage of multiple scripting languages
- Use the integrated development environment

## Common Pitfalls

1. **Premature optimization** - Focus on working code first
2. **Ignoring delta time** - Always use `dt` for time-based movement
3. **Memory leaks** - Clean up resources properly
4. **Hardcoded values** - Use configuration files or constants
5. **Coupling** - Keep systems independent and modular
6. **No error handling** - Plan for edge cases and failures

## Useful Resources

- [Lua Style Guide](https://github.com/Olivine-Labs/lua-style-guide)
- [Game Programming Patterns](https://gameprogrammingpatterns.com/)
- [LÖVE Wiki](https://love2d.org/wiki/Main_Page)
- [Lua Performance Tips](https://www.lua.org/gems/sample.pdf)

Remember: **Make it work, make it right, make it fast** - in that order!