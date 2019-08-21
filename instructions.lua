gl0w.audio.setPlaying(true)
function love.update(dt)
    lovebird.update()
    gl0w.audio.run(dt)
end

if not love.filesystem.getInfo("highscore.txt") then
    love.filesystem.write("highscore.txt", 10000)
end
local highscore = gl0w.highscore.get()

require "helpers/colors"

local timer = 0

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        state.switch("title")
    end
    if key == "space" and not isrepeat then
        state.switch("game")
    end
end
function love.joystickpressed( joystick, button )
    love.keypressed("space", 1, false)
end

function drawString(string, y)
    love.graphics.print(string, (800 - (bitfont:getWidth(string))) / 2, y)
end

function love.draw()
    gl0w.effects.oldtv.draw(
        function()
            set_color(Colors.WHITE)
            love.graphics.print("CREDITS", 80, 40)
            love.graphics.print("FREE PLAY", 80, 60)
            love.graphics.print("HIGH", 800 - 80 - (bitfont:getWidth("HIGH")), 40)
            love.graphics.print(math.floor(highscore), 800 - 80 - (bitfont:getWidth(math.floor(highscore))), 60)

            drawString("I N S T R U C T I O N S", 140)
            drawString(" - - - - - - - - - - - - - ", 160)
            drawString("YOUR ENERGY BALL WILL TRY TO RIDE", 200)
            drawString("THE WAVE THAT MATCHES ITS COLOR", 220)

            drawString("TO SWITCH TO ANOTHER WAVE, HIT THE BUTTON", 260) --o switch to another wave, hit the space bar to adjust your color and wait for the next intersection! ",260)
            drawString("TO ADJUST YOUR COLOR AND WAIT FOR THE", 280)
            drawString("NEXT INTERSECTION. DIFFERENT WAVES", 300)
            drawString("HAVE DIFFERENT SPEEDS AND GIVE YOU", 320)
            drawString("DIFFERENT SCORES AS WELL", 340)

            drawString("GO OFF SCREEN, YOU'RE DEAD.", 380)

            drawString("TRY TO MOVE WITHOUT TOUCHING", 420)
            drawString("THE GREEN WAVE FOR BONUS POINTS!", 440)

            drawString("PRESS THE ACTION BUTTON TO CONTINUE", 540)
        end
    )
end
