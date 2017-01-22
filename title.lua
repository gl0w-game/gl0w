local shine = require 'libs/shine'

local timer = 0

local logo = love.graphics.newImage("assets/logo.png")
local spacebar = love.graphics.newImage("assets/spacebar.png")


gr = shine.godsray({exposure=2, decay=0.91})
scanlines = shine.scanlines({pixel_size=5})
crt = shine.crt()
oldtv = scanlines:chain(crt)

function love.update(dt)
    timer = timer + dt
    runAudio(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        state.switch("splash")
    end
    if key == "space" and not isrepeat then
        state.switch("game")
    end
end


function love.draw()
    oldtv:draw(function()

        -- draw slightly offset godrays
        gr:draw(function()
            -- red
            love.graphics.setColor(255,0,0,127)
            love.graphics.draw(logo, (width/2), (height/2), 0, 1.0+(0.1*math.sin(timer)), 1.1+(0.1*math.sin(timer)), (width/2), (height/2))
            -- green
            love.graphics.setColor(0,255,0,127)
            love.graphics.draw(logo, (width/2), (height/2), 0, 1.2+(0.1*math.sin(timer)), 1.1+(0.1*math.sin(timer)), (width/2), (height/2))
            -- blue
            love.graphics.setColor(0,0,255,127)
            love.graphics.draw(logo, (width/2), (height/2), 0, 1.1+(0.1*math.sin(timer)), 1.1+(0.1*math.sin(timer)), (width/2), (height/2))
        end)
        
        -- draw a red border around the logo, using the nastiest way possible
        scale = 1.1+(0.1*math.sin(timer))

        love.graphics.setColor(255,0,0,127)
        love.graphics.draw(logo, (width/2)-1, (height/2)-1, 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2)-1, (height/2), 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2), (height/2)-1, 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2), (height/2), 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2)+1, (height/2)+1, 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2)+1, (height/2), 0, scale, scale, (width/2), (height/2))
        love.graphics.draw(logo, (width/2), (height/2)+1, 0, scale, scale, (width/2), (height/2))

        -- actually draw the logo
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(logo, (width/2), (height/2), 0, scale, scale, (width/2), (height/2))

        -- blinking spacebar indicator
        love.graphics.setColor(255,255,255,math.floor(timer)%2==1 and 0 or 255)
        love.graphics.draw(spacebar, (width/2), (height/2), 0, 1, 1, (width/2), (height/2))

    end)
end