local shine = require 'libs/shine'
local timer = 0
local splash = love.graphics.newImage("assets/splashggj.png")

gr = shine.godsray({exposure=25, decay=1})
scanlines = shine.scanlines({pixel_size=5})
crt = shine.crt()
oldtv = scanlines:chain(crt)

function love.update(dt)
    timer = timer + dt
    opacity = 255-(70*timer-3)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        love.event.quit()
    end
    if key == "space" and not isrepeat then
        state.switch("title")
    end
end

function love.draw()
    oldtv:draw(function()
        if opacity > 0 then
            love.graphics.setColor(255, 255, 255, timer<2 and 255 or opacity )
        else
            state.switch("title")
        end
        love.graphics.draw(splash, (width/2), (height/2), 0, timer<2 and 1 or timer-1, timer<2 and 1 or timer-1, (width/2), (height/2))
    end)
end