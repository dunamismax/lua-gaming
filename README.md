<p align="center">
  <a href="https://github.com/dunamismax/lua-gaming">
    <img src="https://readme-typing-svg.demolab.com/?font=Fira+Code&size=24&pause=1000&color=000080&center=true&vCenter=true&width=800&lines=Lua+Gaming+Monorepo;Complete+Game+Development+Stack;L%C3%96VE+%2B+L%C3%96VR+%2B+PICO-8+%2B+TIC-80;From+2D+to+VR+to+Fantasy+Consoles;Pure+Lua%2C+Maximum+Creativity." alt="Typing SVG" />
  </a>
</p>

<p align="center">
  <a href="https://www.lua.org/"><img src="https://img.shields.io/badge/Lua-5.4+-000080.svg?logo=lua" alt="Lua Version"></a>
  <a href="https://love2d.org/"><img src="https://img.shields.io/badge/L%C3%96VE-11.4-pink.svg?logo=love2d" alt="LÖVE Version"></a>
  <a href="https://lovr.org/"><img src="https://img.shields.io/badge/L%C3%96VR-0.17-purple.svg" alt="LÖVR Version"></a>
  <a href="https://www.lexaloffle.com/pico-8.php"><img src="https://img.shields.io/badge/PICO--8-0.2.5-orange.svg" alt="PICO-8"></a>
  <a href="https://tic80.com/"><img src="https://img.shields.io/badge/TIC--80-1.1-red.svg" alt="TIC-80"></a>
  <a href="https://img.shields.io/github/license/dunamismax/lua-gaming"><img src="https://img.shields.io/github/license/dunamismax/lua-gaming" alt="License"></a>
  <a href="https://github.com/dunamismax/lua-gaming/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
  <a href="https://github.com/dunamismax/lua-gaming/stargazers"><img src="https://img.shields.io/github/stars/dunamismax/lua-gaming" alt="GitHub Stars"></a>
</p>

---

## About This Project

A comprehensive, production-ready monorepo for game development using the complete Lua gaming ecosystem. This repository demonstrates modern game development workflows across multiple frameworks, from 2D indie games to VR experiences and fantasy console development.

**Key Features:**

- **Complete Framework Coverage** - LÖVE, LÖVR, PICO-8, and TIC-80 all in one place
- **Production-Grade Structure** - Shared libraries, utilities, and organized project templates
- **Working Demo Games** - Fully functional examples for each framework
- **Developer-Friendly Tools** - Scripts for creating, building, and running games
- **Comprehensive Documentation** - Guides, best practices, and framework-specific tutorials
- **Cross-Platform Ready** - Support for desktop, mobile, web, and VR platforms

---

## Use This Template

This repository serves as a GitHub template, providing game developers with a robust foundation for building Lua-based games across multiple frameworks. Rather than cloning, you can create your own repository instance with all essential infrastructure and demo games pre-configured.

**To get started:**

1. Click the green **"Use this template"** button at the top right of this repository
2. Choose "Create a new repository"
3. Name your repository and set it to public or private
4. Click "Create repository from template"

This will create a new repository in your GitHub account with all the code, structure, and configuration files needed to start building games immediately using the complete Lua gaming stack.

**Advantages of using the template:**

- Establishes a clean git history beginning with your initial commit
- Configures your repository as the primary origin (not a fork)
- Enables complete customization of repository name and description
- Provides full ownership and administrative control of the codebase

---

## Quick Start

### Prerequisites

- **[Lua/LuaJIT](https://www.lua.org/)** - The Lua programming language
- **[LÖVE](https://love2d.org/)** - 2D game framework
- **[LÖVR](https://lovr.org/)** - 3D/VR game framework
- **[PICO-8](https://www.lexaloffle.com/pico-8.php)** - Fantasy console (commercial)
- **[TIC-80](https://tic80.com/)** - Open-source fantasy console

### Quick Setup

```bash
# 1. Clone and enter the repository
git clone https://github.com/dunamismax/lua-gaming.git
cd lua-gaming

# 2. Run demo games
make demos  # Show all available demos
make run-love2d  # Run LÖVE 2D Asteroids demo
make run-lovr    # Run LÖVR 3D Space Explorer demo

# 3. Create a new game
make new-game FRAMEWORK=love2d NAME=my-awesome-game
cd games/love2d/my-awesome-game
love .  # Start developing!
```

---

## Architecture

### Project Structure

```
lua-gaming/
├── games/                 # Game projects organized by framework
│   ├── love2d/           # LÖVE 2D games (Asteroids demo + template)
│   ├── lovr/             # LÖVR 3D/VR games (Space Explorer + template)
│   ├── pico8/            # PICO-8 fantasy console games (Snake + template)
│   └── tic80/            # TIC-80 fantasy console games (Platformer + template)
├── shared/               # Shared libraries and assets
│   ├── libs/             # Common Lua libraries (lume, tween)
│   ├── utils/            # Utility functions (math, collision, gamestate)
│   └── assets/           # Shared game assets
├── scripts/              # Development and build scripts
├── docs/                 # Comprehensive documentation
└── Makefile              # Build automation and shortcuts
```

---

<details>
<summary><strong>Click to expand: Framework Stack Details</strong></summary>

This monorepo encompasses the complete Lua gaming ecosystem, providing developers with a unified development environment across multiple specialized frameworks. Each framework targets different gaming contexts while maintaining the simplicity and power of Lua as the core programming language.

### **2D Game Development: LÖVE Framework**

The foundation for traditional 2D game development, from indie games to commercial releases.

- [**LÖVE (Love2D)**](https://love2d.org/)
  - **Role:** Cross-Platform 2D Game Framework
  - **Description:** A free, open-source framework for making 2D games in Lua. LÖVE provides a simple yet powerful API for graphics, audio, physics, and input, allowing developers to focus on game logic while handling cross-platform deployment automatically.
- **Integrated Physics:** Built-in Box2D physics engine for realistic 2D physics simulation
- **Audio System:** Complete audio pipeline with spatial audio, streaming, and effects
- **Cross-Platform:** Native support for Windows, macOS, Linux, Android, and iOS

### **3D and VR Development: LÖVR Framework**

Cutting-edge 3D and virtual reality game development with Lua simplicity.

- [**LÖVR**](https://lovr.org/)
  - **Role:** 3D and VR Game Framework
  - **Description:** A free, open-source framework for crafting 3D and Virtual Reality experiences with Lua. LÖVR simplifies 3D rendering, VR device management, and spatial audio, making immersive application development accessible to Lua developers.
- **VR Support:** Native integration with Oculus, Valve Index, Windows Mixed Reality, and more
- **3D Rendering:** Modern graphics pipeline with PBR materials, lighting, and post-processing
- **Hand Tracking:** Full support for VR controllers and hand tracking systems

### **Fantasy Console Development**

Retro-inspired game development with creative constraints and instant distribution.

- [**PICO-8**](https://www.lexaloffle.com/pico-8.php)
  - **Role:** Fantasy Game Console
  - **Description:** A self-contained environment for creating, sharing, and playing tiny retro-style games. PICO-8 enforces creative limitations (128x128 resolution, 16-color palette) that encourage focused game design and rapid prototyping.
- [**TIC-80**](https://tic80.com/)
  - **Role:** Open-Source Fantasy Console
  - **Description:** A free and open-source fantasy computer for making and sharing small games. TIC-80 offers a complete suite of built-in development tools and serves as an accessible entry point into game development.

### **Shared Development Libraries**

A curated collection of production-tested libraries for common game development tasks.

- [**lume**](https://github.com/rxi/lume)
  - **Role:** General-Purpose Utility Library
  - **Description:** Essential helper functions extending Lua's standard library with tools for math, table manipulation, functional programming, and game-specific utilities.
- [**tween.lua**](https://github.com/kikito/tween.lua)
  - **Role:** Animation and Easing Library
  - **Description:** Professional-grade tweening library supporting all standard easing functions for smooth animations, UI transitions, and visual effects.
- **Custom Utilities:** Math helpers, collision detection, game state management, and more

### **Development Tools and Workflow**

Modern development tooling designed for rapid iteration and professional game development.

- **Project Templates:** Pre-configured starting points for each framework
- **Build Scripts:** Automated building and packaging for distribution
- **Development Automation:** Makefile with shortcuts for common tasks
- **Documentation System:** Comprehensive guides and API references

</details>

---

## Demo Games

This monorepo includes four fully functional demo games showcasing each framework:

### 🚀 **Asteroids 2D** (LÖVE)
Classic space shooter with modern touches featuring particle effects, smooth controls, and progressive difficulty.

### 🌌 **Space Explorer 3D** (LÖVR)
Immersive 3D space exploration with full VR support, spatial audio, and hand controller integration.

### 🐍 **Snake Retro** (PICO-8)
Classic snake game with authentic retro aesthetics, smooth animations, and challenging gameplay.

### 🏃 **Platformer Mini** (TIC-80)
Tight platformer controls with pixel-perfect collision detection, collectibles, and level progression.

---

## Development

### Creating New Games

```bash
# Use the convenient script
./scripts/new-game.sh love2d my-platformer
./scripts/new-game.sh lovr my-vr-experience
./scripts/new-game.sh pico8 my-retro-game
./scripts/new-game.sh tic80 my-arcade-game

# Or use Make targets
make new-game FRAMEWORK=love2d NAME=my-game
```

### Building and Distribution

```bash
# Build LÖVE games for distribution
./scripts/build-love.sh games/love2d/my-game
make build-love GAME=games/love2d/my-game

# Run demo games
make run-love2d  # LÖVE 2D demo
make run-lovr    # LÖVR 3D demo
make demos       # Show all demos
```

### Quality Assurance

```bash
# Test Lua syntax in all shared libraries
make test

# Clean build artifacts
make clean

# Check installed prerequisites
make check-prereqs
```

---

## Shared Libraries Usage

The monorepo provides battle-tested libraries for common game development patterns:

```lua
-- Animation and tweening
local tween = require("../../../shared/libs/tween")
local playerTween = tween.new(1, player, {x = 200}, 'outBounce')

-- Utility functions
local lume = require("../../../shared/libs/lume")
local distance = lume.distance(x1, y1, x2, y2)

-- Math utilities
local mathutils = require("../../../shared/utils/math")
local clamped = mathutils.clamp(value, 0, 100)

-- Collision detection
local collision = require("../../../shared/utils/collision")
if collision.rectRect(player.x, player.y, 32, 32, enemy.x, enemy.y, 32, 32) then
    -- Handle collision
end

-- Game state management
local gamestate = require("../../../shared/utils/gamestate")
gamestate.switch("menu")
```

---

## Documentation

- **[Getting Started Guide](docs/getting-started.md)** - Complete setup and first game tutorial
- **[LÖVE Framework Guide](docs/frameworks/love2d.md)** - Comprehensive LÖVE development guide
- **[Best Practices](docs/best-practices.md)** - Professional game development patterns
- **[Library Documentation](docs/libraries/)** - API references for shared libraries

---

## Support This Project

If you find this project valuable for your game development journey, consider supporting its continued development:

<p align="center">
  <a href="https://www.buymeacoffee.com/dunamismax" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" />
  </a>
</p>

---

## Let's Connect

<p align="center">
  <a href="https://twitter.com/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Twitter-%231DA1F2.svg?&style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter"></a>
  <a href="https://bsky.app/profile/dunamismax.bsky.social" target="_blank"><img src="https://img.shields.io/badge/Bluesky-blue?style=for-the-badge&logo=bluesky&logoColor=white" alt="Bluesky"></a>
  <a href="https://reddit.com/user/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Reddit-%23FF4500.svg?&style=for-the-badge&logo=reddit&logoColor=white" alt="Reddit"></a>
  <a href="https://discord.com/users/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Discord-dunamismax-7289DA.svg?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
  <a href="https://signal.me/#p/+dunamismax.66" target="_blank"><img src="https://img.shields.io/badge/Signal-dunamismax.66-3A76F0.svg?style=for-the-badge&logo=signal&logoColor=white" alt="Signal"></a>
</p>

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with Lua</strong><br>
  <sub>A comprehensive foundation for game development across all platforms</sub>
</p>