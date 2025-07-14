# Lua Gaming Monorepo Makefile

.PHONY: help install demos new-game build-love clean test

# Default target
help:
	@echo "Lua Gaming Monorepo"
	@echo "==================="
	@echo ""
	@echo "Available targets:"
	@echo "  help        - Show this help message"
	@echo "  demos       - Show demo game instructions"
	@echo "  run-love2d  - Run LÖVE 2D demo (Asteroids)"
	@echo "  run-lovr    - Run LÖVR demo (Space Explorer 3D)"
	@echo "  new-game    - Create a new game (requires FRAMEWORK and NAME)"
	@echo "  build-love  - Build LÖVE game (requires GAME)"
	@echo "  clean       - Clean build artifacts"
	@echo "  test        - Run basic tests"
	@echo ""
	@echo "Examples:"
	@echo "  make demos"
	@echo "  make run-love2d"
	@echo "  make new-game FRAMEWORK=love2d NAME=my-game"
	@echo "  make build-love GAME=games/love2d/asteroids-2d"

# Show demo instructions
demos:
	@./scripts/run-demos.sh all

# Run specific demos
run-love2d:
	@./scripts/run-demos.sh love2d

run-lovr:
	@./scripts/run-demos.sh lovr

run-pico8:
	@./scripts/run-demos.sh pico8

run-tic80:
	@./scripts/run-demos.sh tic80

# Create new game
new-game:
ifndef FRAMEWORK
	$(error FRAMEWORK is required. Usage: make new-game FRAMEWORK=love2d NAME=my-game)
endif
ifndef NAME
	$(error NAME is required. Usage: make new-game FRAMEWORK=love2d NAME=my-game)
endif
	@./scripts/new-game.sh $(FRAMEWORK) $(NAME)

# Build LÖVE game
build-love:
ifndef GAME
	$(error GAME is required. Usage: make build-love GAME=games/love2d/my-game)
endif
	@./scripts/build-love.sh $(GAME)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf builds/
	@echo "✓ Clean complete"

# Basic tests
test:
	@echo "Running basic tests..."
	@echo "Testing Lua syntax in shared libraries..."
	@lua -e "require('shared/libs/lume')" && echo "✓ lume.lua syntax OK"
	@lua -e "require('shared/libs/tween')" && echo "✓ tween.lua syntax OK"
	@lua -e "require('shared/utils/math')" && echo "✓ math.lua syntax OK"
	@lua -e "require('shared/utils/collision')" && echo "✓ collision.lua syntax OK"
	@lua -e "require('shared/utils/gamestate')" && echo "✓ gamestate.lua syntax OK"
	@echo "✓ All tests passed"

# Development shortcuts
dev-love2d:
	@echo "Starting LÖVE 2D development environment..."
	@cd games/love2d/asteroids-2d && love .

dev-lovr:
	@echo "Starting LÖVR development environment..."
	@cd games/lovr/space-explorer-3d && lovr .

# Check prerequisites
check-prereqs:
	@echo "Checking prerequisites..."
	@command -v lua >/dev/null 2>&1 && echo "✓ Lua found" || echo "✗ Lua not found"
	@command -v love >/dev/null 2>&1 && echo "✓ LÖVE found" || echo "✗ LÖVE not found"
	@command -v lovr >/dev/null 2>&1 && echo "✓ LÖVR found" || echo "✗ LÖVR not found"
	@command -v pico8 >/dev/null 2>&1 && echo "✓ PICO-8 found" || echo "✗ PICO-8 not found"
	@command -v tic80 >/dev/null 2>&1 && echo "✓ TIC-80 found" || echo "✗ TIC-80 not found"

# Quick start guide
quickstart:
	@echo "Lua Gaming Quick Start"
	@echo "====================="
	@echo ""
	@echo "1. Install prerequisites:"
	@echo "   • LÖVE: https://love2d.org/"
	@echo "   • LÖVR: https://lovr.org/"
	@echo "   • PICO-8: https://www.lexaloffle.com/pico-8.php"
	@echo "   • TIC-80: https://tic80.com/"
	@echo ""
	@echo "2. Try the demos:"
	@echo "   make demos"
	@echo ""
	@echo "3. Create your first game:"
	@echo "   make new-game FRAMEWORK=love2d NAME=my-awesome-game"
	@echo ""
	@echo "4. Start developing!"
	@echo "   cd games/love2d/my-awesome-game"
	@echo "   # Edit main.lua"
	@echo "   love ."