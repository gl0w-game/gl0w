local shine = require 'libs/shine'

function love.load()
    if RELEASE == 1 then
        love.window.setMode(800, 600, {resizable=false, vsync=true, fullscreentype="exclusive"})
        love.window.setFullscreen(true, "exclusive")
    end
    
    gr = shine.godsray({exposure=25, decay=1})
    scanlines = shine.scanlines({pixel_size=5})
    crt = shine.crt()
    oldtv = scanlines:chain(crt)
end

function love.draw()

end