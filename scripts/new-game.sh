#!/bin/bash

# Script to create a new game from template
# Usage: ./scripts/new-game.sh <framework> <game-name>

set -e

FRAMEWORK=$1
GAME_NAME=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo -e "${YELLOW}Usage: $0 <framework> <game-name>${NC}"
    echo -e "Available frameworks:"
    echo -e "  ${GREEN}love2d${NC}  - LÖVE 2D games"
    echo -e "  ${GREEN}lovr${NC}    - LÖVR 3D/VR games"
    echo -e "  ${GREEN}pico8${NC}   - PICO-8 fantasy console"
    echo -e "  ${GREEN}tic80${NC}   - TIC-80 fantasy console"
    echo -e ""
    echo -e "Example: $0 love2d my-awesome-game"
    exit 1
}

if [ -z "$FRAMEWORK" ] || [ -z "$GAME_NAME" ]; then
    usage
fi

# Validate framework
case $FRAMEWORK in
    love2d|lovr|pico8|tic80)
        ;;
    *)
        echo -e "${RED}Error: Invalid framework '$FRAMEWORK'${NC}"
        usage
        ;;
esac

# Validate game name (no spaces, special chars)
if [[ ! $GAME_NAME =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo -e "${RED}Error: Game name must contain only letters, numbers, hyphens, and underscores${NC}"
    exit 1
fi

TEMPLATE_DIR="$ROOT_DIR/games/$FRAMEWORK/template"
GAME_DIR="$ROOT_DIR/games/$FRAMEWORK/$GAME_NAME"

# Check if template exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "${RED}Error: Template directory not found: $TEMPLATE_DIR${NC}"
    exit 1
fi

# Check if game directory already exists
if [ -d "$GAME_DIR" ]; then
    echo -e "${RED}Error: Game directory already exists: $GAME_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}Creating new $FRAMEWORK game: $GAME_NAME${NC}"

# Copy template
cp -r "$TEMPLATE_DIR" "$GAME_DIR"

# Create game-specific README
cat > "$GAME_DIR/README.md" << EOF
# $GAME_NAME

A $FRAMEWORK game created with the Lua Gaming monorepo.

## Running

\`\`\`bash
cd games/$FRAMEWORK/$GAME_NAME
EOF

case $FRAMEWORK in
    love2d)
        echo "love ." >> "$GAME_DIR/README.md"
        ;;
    lovr)
        echo "lovr ." >> "$GAME_DIR/README.md"
        ;;
    pico8)
        echo "# Open PICO-8 and load the cartridge" >> "$GAME_DIR/README.md"
        echo "pico8 $GAME_NAME.p8" >> "$GAME_DIR/README.md"
        # Rename template file
        if [ -f "$GAME_DIR/template.p8" ]; then
            mv "$GAME_DIR/template.p8" "$GAME_DIR/$GAME_NAME.p8"
        fi
        ;;
    tic80)
        echo "# Open TIC-80 and load the cartridge" >> "$GAME_DIR/README.md"
        echo "tic80 $GAME_NAME.lua" >> "$GAME_DIR/README.md"
        # Rename template file
        if [ -f "$GAME_DIR/template.lua" ]; then
            mv "$GAME_DIR/template.lua" "$GAME_DIR/$GAME_NAME.lua"
        fi
        ;;
esac

cat >> "$GAME_DIR/README.md" << EOF
\`\`\`

## Development

Edit the main game file and start developing!

## Assets

Place your game assets in the \`assets/\` directory (create it if needed).

## Shared Libraries

This game can use shared libraries from the monorepo:

\`\`\`lua
local lume = require("../../../shared/libs/lume")
local tween = require("../../../shared/libs/tween")
local mathutils = require("../../../shared/utils/math")
\`\`\`

## Controls

Add your game controls here.

## Credits

Created with the [Lua Gaming](https://github.com/dunamismax/lua-gaming) monorepo.
EOF

# Update main file title/name if needed
case $FRAMEWORK in
    love2d)
        if [ -f "$GAME_DIR/conf.lua" ]; then
            sed -i.bak "s/LÖVE Game Template/$GAME_NAME/g" "$GAME_DIR/conf.lua"
            rm "$GAME_DIR/conf.lua.bak"
        fi
        if [ -f "$GAME_DIR/main.lua" ]; then
            sed -i.bak "s/LÖVE Game Template/$GAME_NAME/g" "$GAME_DIR/main.lua"
            rm "$GAME_DIR/main.lua.bak"
        fi
        ;;
    lovr)
        if [ -f "$GAME_DIR/main.lua" ]; then
            sed -i.bak "s/LÖVR Template/$GAME_NAME/g" "$GAME_DIR/main.lua"
            rm "$GAME_DIR/main.lua.bak"
        fi
        ;;
    pico8)
        if [ -f "$GAME_DIR/$GAME_NAME.p8" ]; then
            sed -i.bak "s/pico-8 template/$GAME_NAME/g" "$GAME_DIR/$GAME_NAME.p8"
            rm "$GAME_DIR/$GAME_NAME.p8.bak"
        fi
        ;;
    tic80)
        if [ -f "$GAME_DIR/$GAME_NAME.lua" ]; then
            sed -i.bak "s/TIC-80 Template/$GAME_NAME/g" "$GAME_DIR/$GAME_NAME.lua"
            rm "$GAME_DIR/$GAME_NAME.lua.bak"
        fi
        ;;
esac

echo -e "${GREEN}✓ Game created successfully!${NC}"
echo -e ""
echo -e "Next steps:"
echo -e "  1. ${YELLOW}cd games/$FRAMEWORK/$GAME_NAME${NC}"
echo -e "  2. Edit the main game file"
echo -e "  3. Start developing your game!"
echo -e ""
echo -e "Happy game development! 🎮"