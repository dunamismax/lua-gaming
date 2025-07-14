# Getting Started with Lua Gaming

Welcome to the Lua Gaming monorepo! This guide will help you set up your development environment and start creating games.

## Prerequisites

Before you begin, make sure you have the following installed:

### Required
- **Lua** or **LuaJIT** - The Lua programming language
- **Git** - For version control

### Framework-Specific
- **LÖVE** - Download from [love2d.org](https://love2d.org/)
- **LÖVR** - Download from [lovr.org](https://lovr.org/)
- **PICO-8** - Purchase from [lexaloffle.com](https://www.lexaloffle.com/pico-8.php)
- **TIC-80** - Download from [tic80.com](https://tic80.com/)

### Optional
- **ZeroBrane Studio** - Recommended Lua IDE
- **LuaRocks** - Lua package manager

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/dunamismax/lua-gaming.git
   cd lua-gaming
   ```

2. **Verify framework installations:**
   ```bash
   # Test LÖVE
   love --version
   
   # Test LÖVR (if installed)
   lovr --version
   
   # Test Lua
   lua -v
   ```

## Running Demo Games

### LÖVE 2D - Asteroids
```bash
cd games/love2d/asteroids-2d
love .
```

**Controls:**
- WASD or Arrow Keys: Move
- Space: Shoot
- R: Restart (when game over)
- ESC: Quit

### LÖVR 3D - Space Explorer
```bash
cd games/lovr/space-explorer-3d
lovr .
```

**Controls:**
- WASD: Move
- Space: Thrust
- VR Controllers: Use hand controllers for movement and thrust

### PICO-8 - Snake Retro
1. Open PICO-8
2. Type: `load games/pico8/snake-retro/snake.p8`
3. Type: `run`

**Controls:**
- Arrow Keys: Move snake
- Z/X: Select menu options

### TIC-80 - Platformer Mini
1. Open TIC-80
2. Type: `load games/tic80/platformer-mini/platformer.lua`
3. Type: `run`

**Controls:**
- Arrow Keys: Move
- Z: Jump
- R: Restart (when complete)

## Creating Your First Game

### Choose Your Framework

1. **LÖVE 2D** - Great for 2D games, beginner-friendly
2. **LÖVR** - Perfect for 3D and VR experiences
3. **PICO-8** - Ideal for retro-style games with constraints
4. **TIC-80** - Open-source fantasy console alternative

### Using Templates

Each framework has a template to get you started:

```bash
# Copy a template
cp -r games/love2d/template games/love2d/my-new-game
cd games/love2d/my-new-game

# Edit the main.lua file
# Start developing!
```

### Project Structure

Your game should follow this structure:
```
my-new-game/
├── main.lua          # Main game file
├── conf.lua          # Configuration (LÖVE only)
├── assets/           # Game-specific assets
├── src/              # Source code modules
└── README.md         # Game documentation
```

## Using Shared Libraries

The monorepo includes useful libraries in the `shared/` directory:

```lua
-- In your game's main.lua
local lume = require("../../../shared/libs/lume")
local tween = require("../../../shared/libs/tween")
local mathutils = require("../../../shared/utils/math")

-- Use the libraries
local distance = mathutils.distance(x1, y1, x2, y2)
local tween = tween.new(1, player, {x = 100}, 'outQuad')
```

## Development Workflow

1. **Plan your game** - Sketch out core mechanics
2. **Start with a template** - Copy the appropriate framework template
3. **Implement core gameplay** - Focus on the main game loop
4. **Add polish** - Improve graphics, sound, and feel
5. **Test thoroughly** - Play-test on different devices
6. **Share your creation** - Add it to the monorepo!

## Common Patterns

### Game States
```lua
local gamestate = require("../../../shared/utils/gamestate")

local menu = gamestate.new()
local playing = gamestate.new()
local gameover = gamestate.new()

function menu:draw()
    love.graphics.print("Main Menu", 100, 100)
end

gamestate.register("menu", menu)
gamestate.switch("menu")
```

### Animation
```lua
local tween = require("../../../shared/libs/tween")

-- Create a tween
local playerTween = tween.new(1, player, {x = 200, y = 100}, 'outBounce')

-- Update in your game loop
function love.update(dt)
    playerTween:update(dt)
end
```

### Collision Detection
```lua
local collision = require("../../../shared/utils/collision")

if collision.rectRect(player.x, player.y, player.w, player.h,
                     enemy.x, enemy.y, enemy.w, enemy.h) then
    -- Handle collision
end
```

## Best Practices

1. **Keep it simple** - Start with basic functionality
2. **Use version control** - Commit your changes regularly
3. **Comment your code** - Explain complex logic
4. **Test frequently** - Run your game often during development
5. **Follow naming conventions** - Use clear, descriptive names
6. **Organize your code** - Split functionality into modules

## Next Steps

- Explore the [Framework Guides](frameworks/) for detailed tutorials
- Check out [Library Documentation](libraries/) for available tools
- Read [Best Practices](best-practices.md) for advanced tips
- Join the Lua gaming community for support and inspiration

## Getting Help

- Check the framework documentation
- Look at the demo games for examples
- Search online communities and forums
- Experiment and have fun!

Happy game development! 🎮