local gamestate = {}

local current_state = nil
local states = {}

function gamestate.new()
    return {
        init = function() end,
        enter = function(previous) end,
        leave = function() end,
        update = function(dt) end,
        draw = function() end,
        keypressed = function(key) end,
        keyreleased = function(key) end,
        mousepressed = function(x, y, button) end,
        mousereleased = function(x, y, button) end,
        mousemoved = function(x, y, dx, dy) end
    }
end

function gamestate.register(name, state)
    states[name] = state
    if state.init then
        state:init()
    end
end

function gamestate.switch(name, ...)
    local new_state = states[name]
    if not new_state then
        error("State '" .. name .. "' does not exist")
    end
    
    local previous = current_state
    
    if current_state and current_state.leave then
        current_state:leave()
    end
    
    current_state = new_state
    
    if current_state.enter then
        current_state:enter(previous, ...)
    end
end

function gamestate.current()
    return current_state
end

function gamestate.update(dt)
    if current_state and current_state.update then
        current_state:update(dt)
    end
end

function gamestate.draw()
    if current_state and current_state.draw then
        current_state:draw()
    end
end

function gamestate.keypressed(key)
    if current_state and current_state.keypressed then
        current_state:keypressed(key)
    end
end

function gamestate.keyreleased(key)
    if current_state and current_state.keyreleased then
        current_state:keyreleased(key)
    end
end

function gamestate.mousepressed(x, y, button)
    if current_state and current_state.mousepressed then
        current_state:mousepressed(x, y, button)
    end
end

function gamestate.mousereleased(x, y, button)
    if current_state and current_state.mousereleased then
        current_state:mousereleased(x, y, button)
    end
end

function gamestate.mousemoved(x, y, dx, dy)
    if current_state and current_state.mousemoved then
        current_state:mousemoved(x, y, dx, dy)
    end
end

return gamestate