#!/bin/bash

# Script to run demo games
# Usage: ./scripts/run-demos.sh [framework]

FRAMEWORK=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo -e "${YELLOW}Usage: $0 [framework]${NC}"
    echo -e ""
    echo -e "Available frameworks:"
    echo -e "  ${GREEN}love2d${NC}  - Run Asteroids 2D demo"
    echo -e "  ${GREEN}lovr${NC}    - Run Space Explorer 3D demo"
    echo -e "  ${GREEN}pico8${NC}   - Instructions for Snake Retro demo"
    echo -e "  ${GREEN}tic80${NC}   - Instructions for Platformer Mini demo"
    echo -e "  ${GREEN}all${NC}     - Show instructions for all demos"
    echo -e ""
    echo -e "If no framework is specified, shows this menu."
    exit 0
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

run_love2d() {
    echo -e "${BLUE}Running LÖVE 2D Demo: Asteroids 2D${NC}"
    echo -e ""
    
    if ! check_command "love"; then
        echo -e "${RED}Error: LÖVE not found in PATH${NC}"
        echo -e "Please install LÖVE from https://love2d.org/"
        echo -e ""
        echo -e "Manual run:"
        echo -e "  ${YELLOW}cd $ROOT_DIR/games/love2d/asteroids-2d${NC}"
        echo -e "  ${YELLOW}love .${NC}"
        return 1
    fi
    
    cd "$ROOT_DIR/games/love2d/asteroids-2d"
    echo -e "${GREEN}Starting Asteroids 2D...${NC}"
    echo -e "Controls: WASD/Arrows=Move, Space=Shoot, R=Restart, ESC=Quit"
    love .
}

run_lovr() {
    echo -e "${BLUE}Running LÖVR Demo: Space Explorer 3D${NC}"
    echo -e ""
    
    if ! check_command "lovr"; then
        echo -e "${RED}Error: LÖVR not found in PATH${NC}"
        echo -e "Please install LÖVR from https://lovr.org/"
        echo -e ""
        echo -e "Manual run:"
        echo -e "  ${YELLOW}cd $ROOT_DIR/games/lovr/space-explorer-3d${NC}"
        echo -e "  ${YELLOW}lovr .${NC}"
        return 1
    fi
    
    cd "$ROOT_DIR/games/lovr/space-explorer-3d"
    echo -e "${GREEN}Starting Space Explorer 3D...${NC}"
    echo -e "Controls: WASD=Move, Space=Thrust, VR Controllers supported"
    lovr .
}

show_pico8() {
    echo -e "${BLUE}PICO-8 Demo: Snake Retro${NC}"
    echo -e ""
    echo -e "To run this demo:"
    echo -e "  1. Open PICO-8"
    echo -e "  2. Type: ${YELLOW}load $ROOT_DIR/games/pico8/snake-retro/snake.p8${NC}"
    echo -e "  3. Type: ${YELLOW}run${NC}"
    echo -e ""
    echo -e "Controls: Arrow Keys=Move Snake, Z/X=Menu"
    echo -e ""
    echo -e "Note: PICO-8 is a commercial product. Purchase from:"
    echo -e "      https://www.lexaloffle.com/pico-8.php"
}

show_tic80() {
    echo -e "${BLUE}TIC-80 Demo: Platformer Mini${NC}"
    echo -e ""
    echo -e "To run this demo:"
    echo -e "  1. Open TIC-80"
    echo -e "  2. Type: ${YELLOW}load $ROOT_DIR/games/tic80/platformer-mini/platformer.lua${NC}"
    echo -e "  3. Type: ${YELLOW}run${NC}"
    echo -e ""
    echo -e "Controls: Arrow Keys=Move, Z=Jump, R=Restart"
    echo -e ""
    echo -e "Note: TIC-80 is free! Download from:"
    echo -e "      https://tic80.com/"
}

show_all() {
    echo -e "${GREEN}Lua Gaming Demo Games${NC}"
    echo -e "===================="
    echo -e ""
    
    echo -e "${BLUE}🎮 Available Demos:${NC}"
    echo -e ""
    
    echo -e "${GREEN}1. Asteroids 2D (LÖVE)${NC}"
    echo -e "   Classic space shooter with modern touches"
    echo -e "   Run: ${YELLOW}./scripts/run-demos.sh love2d${NC}"
    echo -e ""
    
    echo -e "${GREEN}2. Space Explorer 3D (LÖVR)${NC}"
    echo -e "   3D space exploration with VR support"
    echo -e "   Run: ${YELLOW}./scripts/run-demos.sh lovr${NC}"
    echo -e ""
    
    echo -e "${GREEN}3. Snake Retro (PICO-8)${NC}"
    echo -e "   Classic snake game with retro aesthetics"
    echo -e "   Run: ${YELLOW}./scripts/run-demos.sh pico8${NC}"
    echo -e ""
    
    echo -e "${GREEN}4. Platformer Mini (TIC-80)${NC}"
    echo -e "   Mini platformer with pixel-perfect controls"
    echo -e "   Run: ${YELLOW}./scripts/run-demos.sh tic80${NC}"
    echo -e ""
    
    echo -e "${BLUE}Prerequisites:${NC}"
    echo -e "• LÖVE - https://love2d.org/"
    echo -e "• LÖVR - https://lovr.org/"
    echo -e "• PICO-8 - https://www.lexaloffle.com/pico-8.php"
    echo -e "• TIC-80 - https://tic80.com/"
}

case $FRAMEWORK in
    love2d)
        run_love2d
        ;;
    lovr)
        run_lovr
        ;;
    pico8)
        show_pico8
        ;;
    tic80)
        show_tic80
        ;;
    all)
        show_all
        ;;
    "")
        usage
        ;;
    *)
        echo -e "${RED}Error: Unknown framework '$FRAMEWORK'${NC}"
        usage
        ;;
esac