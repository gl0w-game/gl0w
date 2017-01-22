local shine = require 'libs/shine'

require 'helpers/utils'
require 'helpers/colors'
require 'helpers/wave'
require 'helpers/player'
require 'helpers/background'

maintimer = 0

score = 0
isBonus = false


waves = {}
gr = shine.godsray({exposure=25, decay=0.95})
gr2 = shine.godsray()

scanlines = shine.scanlines({pixel_size=5})
crt = shine.crt()
oldtv = scanlines:chain(crt)

player = Player(300, Colors.GREEN, Colors.RED)

waves[Colors.RED] = Wave(Colors.RED, 300, 0, 7, 0.02, 120)
waves[Colors.GREEN] = Wave(Colors.GREEN, 400, 0, 7, 0.02, 250)
waves[Colors.BLUE] = Wave(Colors.BLUE, 500, 0, 7, 0.02, 120)

diff = 1

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        state.switch("title")
    end

    if key == "space" and not isrepeat then
        change_player_color()
    end
end

function love.update(dt)
    if not RELEASE then
        require("libs/lovebird").update()
    end
    maintimer = maintimer + dt
    alter_timer = alter_timer + dt

    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1
        diff = diff + 0.0025

        print(diff)
        colors = {Colors.RED, Colors.GREEN, Colors.BLUE}
        waves[colors[love.math.random(1,3)]].estado=love.math.random(-1,1)

        waves[Colors.RED].offset_x = clamp(300,waves[Colors.RED].offset_x + (alter_offset*waves[Colors.RED].estado*dt*100),500)
        waves[Colors.BLUE].offset_x = clamp(300,waves[Colors.BLUE].offset_x + (alter_offset*waves[Colors.BLUE].estado*dt*100),500)

        waves[Colors.RED].freq = clamp(MIN_FREQ,waves[Colors.RED].freq + (alter_freq*waves[Colors.RED].estado*dt*100),MAX_FREQ)
        waves[Colors.GREEN].freq = clamp(MIN_FREQ,waves[Colors.GREEN].freq + (alter_freq*waves[Colors.GREEN].estado*dt*100),MAX_FREQ)
        waves[Colors.BLUE].freq = clamp(MIN_FREQ,waves[Colors.BLUE].freq + (alter_freq*waves[Colors.BLUE].estado*dt*100),MAX_FREQ)

        waves[Colors.RED].amplitude = clamp(MIN_AMP,waves[Colors.RED].amplitude + (alter_amplitude*waves[Colors.RED].estado*dt*100),MAX_AMP)
        waves[Colors.GREEN].amplitude = clamp(MIN_AMP,waves[Colors.GREEN].amplitude + (alter_amplitude*waves[Colors.GREEN].estado*dt*100),MAX_AMP)
        waves[Colors.BLUE].amplitude = clamp(MIN_AMP,waves[Colors.BLUE].amplitude + (alter_amplitude*waves[Colors.BLUE].estado*dt*100),MAX_AMP)

    end

    if player.current_wave == Colors.RED then
        player.pos_y = player.pos_y + (dt*35 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
        score = score + (3000*dt*diff)
        if isBonus then
            score = score + (3000*dt*diff)
        end
    end

    if player.current_wave == Colors.BLUE then
        player.pos_y = player.pos_y + (dt*30 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
        score = score + (1000*dt*diff)
        if isBonus then
            score = score + (1000*dt*diff)
        end
    end

    if player.current_wave == Colors.GREEN then
        player.pos_y = player.pos_y - (dt*45 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
        score = score + (200*dt*diff)
    end

    background.y = background.y + background.speed * dt
    if background.y > height then
        background.y = background.y - height
    end

    if player.pos_y < -18 then
        state.switch("gameover")
    elseif player.pos_y > height+18 then
        state.switch("gameover")
    end

end

function drawEverythingElse()
    for pos_y = -200, 800 do

        for wave_color, wave in pairs(waves) do
            pos_x = wave_point(pos_y, wave.speed, wave.freq, wave.amplitude) -- pos_x = wave.pos_x --
            set_color(wave.color)
            love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 2)

            if pos_y == math.floor(player.pos_y) then
                wave.pos_x = math.floor(wave_point(pos_y-wave.offset_y, wave.speed, wave.freq, wave.amplitude)) + wave.offset_x

                if wave_color == player.current_wave then
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 18)
                    set_color(Colors.WHITE)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 14)
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 8)
                end
            end
        end
    end

    handleColission(Colors.RED,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.RED)

    set_color(Colors.WHITE)
    love.graphics.print("T:"..maintimer,0,0)
    love.graphics.print("SCORE:".. math.floor(score),0,40)
end

function handleColission(color1, color2)
    if (player.current_wave==player.color) then
        -- nothing to do here, move along now
        return
    end
    if player.current_wave == color1 or player.current_wave == color2 then
        if math.abs(waves[color1].pos_x - waves[color2].pos_x) < colission_range then
            if player.color == color1 or player.color == color2 then
                if (color1 == Colors.RED and color2 == Colors.BLUE) then
                    isBonus = true
                end
                player.current_wave = player.color
                if player.color == Colors.GREEN then
                    isBonus = false
                end
            end
        end
    end
end

function drawActiveLane()
    for pos_y = -200, 800 do
        for wave_color, wave in pairs(waves) do
            pos_x = wave_point(pos_y, wave.speed, wave.freq, wave.amplitude)
            if wave_color == player.current_wave then
                set_color(wave.color)
                love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 2)
            end
        end
    end
end

function love.draw()

    oldtv:draw(function()

        love.graphics.setBlendMode("alpha") --Default blend mode
        love.graphics.setBlendMode("add") --Default blend mode
        -- highlight the active lane
        gr:draw(function()
            drawActiveLane()
        end)

        -- draw everything else with less FX
        gr2:draw(function()
            drawEverythingElse()
        end)

        -- overlay the BG and a clean copy of everything
        if (isBonus) then
            love.graphics.draw(background.bonus, 0, background.y)
            love.graphics.draw(background.bonus, 0, background.y - height)
        else
            love.graphics.draw(background.image, 0, background.y)
            love.graphics.draw(background.image, 0, background.y - height)
        end
        drawEverythingElse()
    end)
end
