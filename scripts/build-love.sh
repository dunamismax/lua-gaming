#!/bin/bash

# Script to build LÖVE games
# Usage: ./scripts/build-love.sh <game-directory> [output-name]

set -e

GAME_DIR=$1
OUTPUT_NAME=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo -e "${YELLOW}Usage: $0 <game-directory> [output-name]${NC}"
    echo -e ""
    echo -e "Examples:"
    echo -e "  $0 games/love2d/my-game"
    echo -e "  $0 games/love2d/my-game my-awesome-game"
    echo -e ""
    echo -e "This will create a .love file that can be run with LÖVE or distributed."
    exit 1
}

if [ -z "$GAME_DIR" ]; then
    usage
fi

# Convert to absolute path
if [[ "$GAME_DIR" != /* ]]; then
    GAME_DIR="$ROOT_DIR/$GAME_DIR"
fi

# Check if game directory exists
if [ ! -d "$GAME_DIR" ]; then
    echo -e "${RED}Error: Game directory not found: $GAME_DIR${NC}"
    exit 1
fi

# Check if it's a LÖVE game (has main.lua)
if [ ! -f "$GAME_DIR/main.lua" ]; then
    echo -e "${RED}Error: Not a LÖVE game (main.lua not found): $GAME_DIR${NC}"
    exit 1
fi

# Determine output name
if [ -z "$OUTPUT_NAME" ]; then
    OUTPUT_NAME=$(basename "$GAME_DIR")
fi

BUILD_DIR="$ROOT_DIR/builds"
OUTPUT_FILE="$BUILD_DIR/${OUTPUT_NAME}.love"

# Create build directory
mkdir -p "$BUILD_DIR"

echo -e "${GREEN}Building LÖVE game: $OUTPUT_NAME${NC}"
echo -e "Source: $GAME_DIR"
echo -e "Output: $OUTPUT_FILE"

# Create temporary directory for build
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Copy game files to temp directory
cp -r "$GAME_DIR"/* "$TEMP_DIR/"

# Remove development files
rm -f "$TEMP_DIR"/*.md
rm -f "$TEMP_DIR"/.git*
rm -f "$TEMP_DIR"/.DS_Store
rm -rf "$TEMP_DIR"/.vscode

# Create .love file (zip archive)
cd "$TEMP_DIR"
zip -r "$OUTPUT_FILE" . -x "*.git*" "*.DS_Store*" "*.md*"

echo -e "${GREEN}✓ Build complete!${NC}"
echo -e ""
echo -e "Created: ${YELLOW}$OUTPUT_FILE${NC}"
echo -e ""
echo -e "To run:"
echo -e "  ${YELLOW}love \"$OUTPUT_FILE\"${NC}"
echo -e ""
echo -e "To distribute:"
echo -e "  Share the .love file - users can run it with LÖVE installed"
echo -e "  Or create platform-specific executables using love-release or similar tools"