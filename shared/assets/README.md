# Shared Assets

This directory contains shared assets that can be used across multiple games in the monorepo.

## Directory Structure

```
assets/
├── images/          # Shared images, sprites, and textures
├── sounds/          # Shared sound effects and music
├── fonts/           # Shared font files
└── data/            # Shared data files (JSON, CSV, etc.)
```

## Guidelines

1. **Naming Convention**: Use descriptive, lowercase names with hyphens for separation (e.g., `coin-pickup.wav`, `player-sprite.png`)

2. **Organization**: Group related assets in subdirectories within each category

3. **Formats**: 
   - Images: PNG for sprites, JPG for backgrounds
   - Sounds: OGG or WAV formats recommended
   - Fonts: TTF or OTF formats

4. **Licensing**: Ensure all assets are either:
   - Created by you
   - Free to use (Creative Commons, Public Domain)
   - Properly licensed for your use case

## Usage Examples

### In LÖVE games:
```lua
local sprite = love.graphics.newImage("../../../shared/assets/images/player.png")
local sound = love.audio.newSource("../../../shared/assets/sounds/jump.wav", "static")
```

### In LÖVR games:
```lua
local texture = lovr.graphics.newTexture("../../../shared/assets/images/skybox.jpg")
local sound = lovr.audio.newSource("../../../shared/assets/sounds/ambient.ogg")
```