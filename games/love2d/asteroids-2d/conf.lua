function love.conf(t)
    t.title = "Asteroids 2D - LÖVE Demo"
    t.version = "11.4"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
    t.window.icon = nil
    
    t.modules.joystick = false
    t.modules.physics = true
    t.modules.touch = false
    t.modules.video = false
end