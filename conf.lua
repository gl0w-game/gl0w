function love.conf(t)
    t.identity = "org.globalgamejam.2017.gl0w"
    t.console = false
    t.accelerometerjoystick = false
    t.gammacorrect = true
    t.window.title = "gl0w"
    t.window.icon = "assets/icon.png"
    t.window.width = 800
    t.window.height = 600
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil
 
    t.modules.joystick = false
    t.modules.mouse = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
    t.modules.thread = false
end
