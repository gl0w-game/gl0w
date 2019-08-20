require 'helpers/utils'
require 'helpers/colors'
require 'helpers/wave'
require 'helpers/player'
require 'helpers/background'

local score = 0
local highscore = 0
local isBonus = false
local waves = {}
local player = Player(300, Colors.GREEN, Colors.RED)
local diff = 1
local flicker = false
local flicker_timer = 0

maintimer = 0

waves[Colors.RED] = Wave(Colors.RED, 300, 0, 7, 0.02, 120)
waves[Colors.GREEN] = Wave(Colors.GREEN, 400, 0, 7, 0.02, 250)
waves[Colors.BLUE] = Wave(Colors.BLUE, 500, 0, 7, 0.02, 120)
highscore = gl0w.highscore.get()


function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        gl0w.audio.setTempo(120)
        gl0w.audio.setMelody(0)
        gl0w.highscore.set(highscore)
        state.switch("title")
    end

    if key == "space" and not isrepeat then
        gl0w.audio.playFX("switch")
        change_player_color()
    end
end

function love.update(dt)
    lovebird.update()
    maintimer = maintimer + dt
    alter_timer = alter_timer + dt
    gl0w.audio.run(dt)
    flicker_timer = flicker_timer + dt
    if flicker_timer > 0.1 then
        flicker_timer = 0
        flicker = not flicker
    end
    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1
        diff = diff + 0.0025
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

    if score > highscore then
        highscore = score
    end

    if player.pos_y < -18 or player.pos_y > height+18 then
        gl0w.audio.setTempo(120)
        gl0w.audio.setMelody(0)
        gl0w.audio.playFX("dead")
        gl0w.highscore.set(highscore)
        state.switch("gameover;"..score..";"..highscore)
    end
end

function drawEverythingElse()
    for pos_y = -200, 800 do
        for wave_color, wave in pairs(waves) do
            pos_x = wave_point(pos_y, wave.speed, wave.freq, wave.amplitude) -- pos_x = wave.pos_x --


            if wave_color ~= player.current_wave then
                set_color(wave.color.."20")
                if wave_color == player.color then
                    if flicker then
                        set_color(Colors.WHITE)
                    else
                        set_color(wave.color)
                    end
                end
            else
                set_color(wave.color)
            end


            love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 2)

            if pos_y == math.floor(player.pos_y) then
                wave.pos_x = math.floor(wave_point(pos_y-wave.offset_y, wave.speed, wave.freq, wave.amplitude)) + wave.offset_x
                if wave_color == player.current_wave then
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 18)
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 14)
                    set_color(Colors.WHITE)
                     love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 8)
                end
            end
        end
    end

    handleColission(Colors.RED,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.RED)
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
                    gl0w.audio.playFX("bonus")
                    gl0w.audio.setTempo(150)
                    isBonus = true
                end
                player.current_wave = player.color
                if player.color == Colors.GREEN then
                    gl0w.audio.setTempo(120)
                    isBonus = false
                end

                if player.color==Colors.RED then
                    gl0w.audio.setMelody(1)
                elseif player.color==Colors.GREEN then
                    gl0w.audio.setMelody(2)
                else
                    gl0w.audio.setMelody(3)
                end
                gl0w.audio.playFX("jump")
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

    gl0w.effects.oldtv.draw(function()

        love.graphics.setBlendMode("add") --Default blend mode
        -- highlight the active lane
        gl0w.effects.godsrayActive.draw(function()
            drawActiveLane()
        end)

        -- draw everything else with less FX
        gl0w.effects.godsray.draw(function()
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
        set_color(Colors.WHITE)
        love.graphics.print("SCORE",80,40)
        love.graphics.print(math.floor(score),80,60)
        love.graphics.print("HIGH",800-80-(bitfont:getWidth("HIGH")),40)
        love.graphics.print(math.floor(highscore),800-80-(bitfont:getWidth(math.floor(highscore))),60)

        love.graphics.print(maintimer,80,120)


        drawEverythingElse()
    end)

end
