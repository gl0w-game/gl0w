local timer = 0
local splash = love.graphics.newImage("assets/splashggj.png")
local opacity = 0;

gl0w.audio.setPlaying(false)

function love.update(dt)
    lovebird.update()
    gl0w.audio.run(dt)
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
    gl0w.effects.oldtv.draw(function()
        if opacity > 0 then
            love.graphics.setColor(1, 1, 1, timer<2 and 1 or (opacity/255) )
        else
            state.switch("title")
        end
        love.graphics.draw(splash, (width/2), (height/2), 0, timer<2 and 1 or timer-1, timer<2 and 1 or timer-1, (width/2), (height/2))
    end)
end