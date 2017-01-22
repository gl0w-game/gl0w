local shine = require 'libs/shine'
require 'helpers/colors'

local timer = 0

local logo = love.graphics.newImage("assets/logo.png")
local spacebar = love.graphics.newImage("assets/spacebar.png")
local bitfont = love.graphics.newFont("assets/pressstart2p.ttf", 18)
love.graphics.setFont(bitfont)

if not love.filesystem.exists('highscore.txt') then
    love.filesystem.write('highscore.txt', 10000)
end
highscore = love.filesystem.read('highscore.txt')
highscore = tonumber(highscore)

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

        set_color(Colors.WHITE)
        love.graphics.print("CREDITS",80,40)
        love.graphics.print("FREE PLAY",80,60)
        love.graphics.print("HIGH",800-80-(bitfont:getWidth("HIGH")),40)
        love.graphics.print(math.floor(highscore),800-80-(bitfont:getWidth(math.floor(highscore))),60)

    end)
end