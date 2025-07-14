function lovr.load()
    lovr.graphics.setBackgroundColor(0.1, 0.1, 0.2)
    
    gameState = {
        time = 0,
        cubes = {}
    }
    
    for i = 1, 5 do
        table.insert(gameState.cubes, {
            x = math.random(-3, 3),
            y = math.random(0, 3),
            z = math.random(-3, 3),
            rotation = 0,
            color = {math.random(), math.random(), math.random()}
        })
    end
end

function lovr.update(dt)
    gameState.time = gameState.time + dt
    
    for _, cube in ipairs(gameState.cubes) do
        cube.rotation = cube.rotation + dt
    end
end

function lovr.draw(pass)
    for _, cube in ipairs(gameState.cubes) do
        pass:push()
        pass:translate(cube.x, cube.y, cube.z)
        pass:rotate(cube.rotation, 0, 1, 0)
        pass:setColor(cube.color[1], cube.color[2], cube.color[3])
        pass:box(0, 0, 0, 0.5, 0.5, 0.5)
        pass:pop()
    end
    
    pass:push()
    pass:translate(0, 2, -3)
    pass:setColor(1, 1, 1)
    pass:text("LÖVR Template", 0, 0, 0, 0.5)
    pass:text("Time: " .. string.format("%.1f", gameState.time), 0, -0.8, 0, 0.3)
    pass:pop()
end