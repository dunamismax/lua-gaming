function love.load()
    love.window.setTitle("LÖVE Game Template")
    love.graphics.setBackgroundColor(0.2, 0.2, 0.3)
    
    gameState = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
        font = love.graphics.newFont(24)
    }
    
    love.graphics.setFont(gameState.font)
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    
    local text = "LÖVE Game Template"
    local textWidth = gameState.font:getWidth(text)
    local textHeight = gameState.font:getHeight()
    
    love.graphics.print(
        text, 
        (gameState.width - textWidth) / 2, 
        (gameState.height - textHeight) / 2
    )
    
    love.graphics.print("Press ESC to quit", 10, gameState.height - 30)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end