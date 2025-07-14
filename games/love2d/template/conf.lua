function love.conf(t)
    t.title = "LÖVE Game Template"
    t.version = "11.4"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.vsync = 1
    
    t.modules.joystick = true
    t.modules.physics = true
    t.modules.touch = false
    t.modules.video = false
end