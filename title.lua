require "helpers/colors"

local timer = 0
local logo = love.graphics.newImage("assets/logo.png")
local spacebar = love.graphics.newImage("assets/spacebar.png")
local highscore = gl0w.highscore.get()

gl0w.audio.setPlaying(false)
function love.update(dt)
    lovebird.update()
    timer = timer + dt
    gl0w.audio.run(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        state.switch("splash")
    end
    if key == "space" and not isrepeat then
        state.switch("instructions")
    end
end
function love.joystickpressed( joystick, button )
    love.keypressed("space", 1, false)
end

function love.draw()
    gl0w.effects.oldtv.draw(
        function()
            -- draw slightly offset godrays
            gl0w.effects.godsray.draw(
                function()
                    -- red
                    love.graphics.setColor(1, 0, 0, 0.5)
                    love.graphics.draw(
                        logo,
                        (width / 2),
                        (height / 2),
                        0,
                        1.0 + (0.1 * math.sin(timer)),
                        1.1 + (0.1 * math.sin(timer)),
                        (width / 2),
                        (height / 2)
                    )
                    -- green
                    love.graphics.setColor(0, 1, 0, 0.5)
                    love.graphics.draw(
                        logo,
                        (width / 2),
                        (height / 2),
                        0,
                        1.2 + (0.1 * math.sin(timer)),
                        1.1 + (0.1 * math.sin(timer)),
                        (width / 2),
                        (height / 2)
                    )
                    -- blue
                    love.graphics.setColor(0, 0, 1, 0.5)
                    love.graphics.draw(
                        logo,
                        (width / 2),
                        (height / 2),
                        0,
                        1.1 + (0.1 * math.sin(timer)),
                        1.1 + (0.1 * math.sin(timer)),
                        (width / 2),
                        (height / 2)
                    )
                end
            )

            -- draw a red border around the logo, using the nastiest way possible
            scale = 1.1 + (0.1 * math.sin(timer))

            love.graphics.setColor(1, 0, 0, 0.5)
            love.graphics.draw(logo, (width / 2) - 1, (height / 2) - 1, 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2) - 1, (height / 2), 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2), (height / 2) - 1, 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2), (height / 2), 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2) + 1, (height / 2) + 1, 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2) + 1, (height / 2), 0, scale, scale, (width / 2), (height / 2))
            love.graphics.draw(logo, (width / 2), (height / 2) + 1, 0, scale, scale, (width / 2), (height / 2))

            -- actually draw the logo
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(logo, (width / 2), (height / 2), 0, scale, scale, (width / 2), (height / 2))

            -- blinking spacebar indicator
            love.graphics.setColor(1, 1, 1, math.floor(timer) % 2 == 1 and 0 or 1)
            love.graphics.draw(spacebar, (width / 2), (height / 2), 0, 1, 1, (width / 2), (height / 2))

            set_color(Colors.WHITE)
            love.graphics.print("CREDITS", 80, 40)
            love.graphics.print("FREE PLAY", 80, 60)
            love.graphics.print("HIGH", 800 - 80 - (bitfont:getWidth("HIGH")), 40)
            love.graphics.print(math.floor(highscore), 800 - 80 - (bitfont:getWidth(math.floor(highscore))), 60)
        end
    )
    if SHOW_FPS then
        love.graphics.setColor(0,1,0,1)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
        love.graphics.setColor(1,1,1,1)
    end
end
