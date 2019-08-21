require "helpers/utils"
require "helpers/colors"
require "helpers/wave"
require "helpers/player"
require "helpers/background"

local score = 0
local highscore = 0
local initial_highscore = 0
local isBonus = false
local waves = {}
local player = Player(300, Colors.RED, Colors.RED)
local diff = 1
local flicker = false
local flicker_timer = 0
local is_playing = false
local countdown = 3
local countdown_timer = 0
maintimer = love.math.random(0, 600)

waves[Colors.RED] = Wave(Colors.RED, 400, 0, 8, 0.018, 120)
waves[Colors.GREEN] = Wave(Colors.GREEN, 300, 0, 7, 0.02, 80)
waves[Colors.BLUE] = Wave(Colors.BLUE, 500, 0, 6, 0.025, 120)
highscore = gl0w.highscore.get()
initial_highscore = highscore

-- love.profiler = require('profile')
-- love.profiler.hookall("Lua")
-- love.profiler.start()
love.frame = 0
gl0w.audio.playFX("countdown")

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        gl0w.audio.setTempo(120)
        gl0w.audio.setMelody(0)
        gl0w.highscore.set(highscore)
        state.switch("title")
    end

    if key == "space" and not isrepeat then
        if is_playing then
            gl0w.audio.playFX("switch")
            change_player_color()
        end
    end
end
function love.joystickpressed( joystick, button )
    love.keypressed("space", 1, false)
end

function love.update(dt)
    -- love.frame = love.frame + 1
    -- if love.frame%100 == 0 then
    --  love.report = love.profiler.report('time', 20)
    --  love.profiler.reset()
    -- end
    lovebird.update()
    maintimer = maintimer + dt

    if is_playing then
        alter_timer = alter_timer + dt
    else 
        countdown_timer = countdown_timer + dt
    end
    gl0w.audio.run(dt)
    flicker_timer = flicker_timer + dt

    if countdown_timer >= 1 and countdown > 0 then
        countdown_timer = countdown_timer - 1
        countdown = countdown - 1
        gl0w.audio.playFX("countdown")

        if countdown == 0 then
            is_playing = true
            gl0w.audio.playFX("gamestart")

        end
    end

    if flicker_timer > 0.1 then
        flicker_timer = 0
        flicker = not flicker
    end
    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1
        diff = diff + 0.0025
        colors = {Colors.RED, Colors.GREEN, Colors.BLUE}
        waves[colors[love.math.random(1, 3)]].status = love.math.random(-1, 1)

        waves[Colors.RED].offset_x =
            clamp(300, waves[Colors.RED].offset_x + (alter_offset * waves[Colors.RED].status * dt * 100), 500)
        waves[Colors.BLUE].offset_x =
            clamp(300, waves[Colors.BLUE].offset_x + (alter_offset * waves[Colors.BLUE].status * dt * 100), 500)

        waves[Colors.RED].freq =
            clamp(MIN_FREQ, waves[Colors.RED].freq + (alter_freq * waves[Colors.RED].status * dt * 100), MAX_FREQ)
        waves[Colors.GREEN].freq =
            clamp(MIN_FREQ, waves[Colors.GREEN].freq + (alter_freq * waves[Colors.GREEN].status * dt * 100), MAX_FREQ)
        waves[Colors.BLUE].freq =
            clamp(MIN_FREQ, waves[Colors.BLUE].freq + (alter_freq * waves[Colors.BLUE].status * dt * 100), MAX_FREQ)

        waves[Colors.RED].amplitude =
            clamp(
            MIN_AMP,
            waves[Colors.RED].amplitude + (alter_amplitude * waves[Colors.RED].status * dt * 100),
            MAX_AMP
        )
        waves[Colors.GREEN].amplitude =
            clamp(
            MIN_AMP,
            waves[Colors.GREEN].amplitude + (alter_amplitude * waves[Colors.GREEN].status * dt * 100),
            MAX_AMP
        )
        waves[Colors.BLUE].amplitude =
            clamp(
            MIN_AMP,
            waves[Colors.BLUE].amplitude + (alter_amplitude * waves[Colors.BLUE].status * dt * 100),
            MAX_AMP
        )
    end
    if is_playing then
        if player.current_wave == Colors.RED then
            player.pos_y =
                player.pos_y +
                math.floor(
                    0.5 + (dt * 40 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
                )
            score = score + (300 * dt * diff)
            if isBonus then
                score = score + (300 * dt * diff)
            end
        end

        if player.current_wave == Colors.BLUE then
            player.pos_y =
                player.pos_y -
                math.floor(
                    0.5 + (dt * 30 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
                )
            score = score + (1800 * dt * diff)
            if isBonus then
                score = score + (1800 * dt * diff)
            end
        end

        if player.current_wave == Colors.GREEN then
            player.pos_y =
                player.pos_y -
                math.floor(
                    0.5 + (dt * 45 * waves[player.current_wave].amplitude * waves[player.current_wave].freq) * diff
                )
            score = score + (900 * dt * diff)
            if isBonus then
                score = score + (900 * dt * diff)
            end
        end
    end
    background.y = background.y + background.speed * dt
    if background.y > height then
        background.y = background.y - height
    end

    if score > highscore then
        highscore = score
    end

    if player.pos_y < -18 or player.pos_y > height + 18 then
        gl0w.audio.setTempo(120)
        gl0w.audio.setMelody(0)
        gl0w.audio.playFX("dead")
        gl0w.highscore.set(highscore)
        state.switch("gameover;" .. score .. ";" .. highscore)
    end
    local wave_count = 4
    for wave_color, wave in pairs(waves) do
        wave_count = wave_count - 1
        waves[wave_color].offset_x =
            waves[wave_color].base_offset_x + (math.sin((maintimer + wave.freq) * wave_count) * 40)
    end
    for pos_y = 0, 600 do
        for wave_color, wave in pairs(waves) do
            waves[wave_color].pos_x[pos_y + 1] = math.sin(maintimer * -wave.speed + wave.freq * pos_y) * wave.amplitude
        end
    end
    handleColission(Colors.RED, Colors.BLUE, player.pos_y)
    handleColission(Colors.GREEN, Colors.BLUE, player.pos_y)
    handleColission(Colors.GREEN, Colors.RED, player.pos_y)
end

function drawEverythingElse()
    for wave_color, wave in pairs(waves) do
        if wave.color == player.current_wave then
            set_color(wave.color)
        else
            set_color(wave.color .. "20")
        end
        for pos_y = 0, 600 do
            -- wave_point(pos_y, wave.speed, wave.freq, wave.amplitude) -- pos_x = wave.pos_x --

            -- if wave_color ~= player.current_wave then
            --     set_color(wave.color.."20")
            --     if wave_color == player.color then
            --         if flicker then
            --             set_color(Colors.WHITE)
            --         else
            --             set_color(wave.color)
            --         end
            --     end
            -- else
            --     set_color(wave.color)
            -- end

            -- if wave_color == player.current_wave and pos_y == math.floor(player.pos_y) then
            -- love.graphics.circle( "fill", wave.pos_x + wave.offset_x, pos_y + wave.offset_y, 18)
            -- else
            love.graphics.circle("fill", wave.pos_x[pos_y + 1] + wave.offset_x, pos_y + wave.offset_y, 2)
            -- end

            -- if pos_y == math.floor(player.pos_y) then
            --     wave.pos_x = math.floor(wave_point(pos_y-wave.offset_y, wave.speed, wave.freq, wave.amplitude)) + wave.offset_x
            --     if wave_color == player.current_wave then
            --         set_color(player.color)
            --         love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 18)
            --         set_color(player.color)
            --         love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 14)
            --         set_color(Colors.WHITE)
            --          love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 8)
            --     end
            -- end
        end
    end
    love.graphics.setBlendMode("alpha")
    set_color(player.color .. "80")
    love.graphics.circle(
        "fill",
        (math.sin(maintimer * -waves[player.current_wave].speed + waves[player.current_wave].freq * player.pos_y) *
            waves[player.current_wave].amplitude) +
            waves[player.current_wave].offset_x,
        player.pos_y,
        18
    )
    set_color(Colors.WHITE)
    love.graphics.circle(
        "fill",
        (math.sin(maintimer * -waves[player.current_wave].speed + waves[player.current_wave].freq * player.pos_y) *
            waves[player.current_wave].amplitude) +
            waves[player.current_wave].offset_x,
        player.pos_y,
        4
    )
    love.graphics.setBlendMode("add")
end

function handleColission(color1, color2, pos_y)
    if (player.current_wave == player.color or pos_y < 0 or pos_y > 600) then
        -- nothing to do here, move along now
        return
    end
    if player.current_wave == color1 or player.current_wave == color2 then
        if player.color == color1 or player.color == color2 then
            if
                math.abs(
                    (waves[color1].pos_x[pos_y + 1] + waves[color1].offset_x) -
                        (waves[color2].pos_x[pos_y + 1] + waves[color2].offset_x)
                ) < colission_range
             then
                if (color1 == Colors.GREEN and color2 == Colors.BLUE) then
                    gl0w.audio.playFX("bonus")
                    gl0w.audio.setTempo(150)
                    isBonus = true
                end
                player.current_wave = player.color
                if player.color == Colors.RED then
                    gl0w.audio.setTempo(120)
                    isBonus = false
                end
                if player.color == Colors.RED then
                    gl0w.audio.setMelody(1)
                elseif player.color == Colors.GREEN then
                    gl0w.audio.setMelody(2)
                else
                    gl0w.audio.setMelody(3)
                end
                gl0w.audio.playFX("jump")
            end
        end
    end
end

function love.draw()
    gl0w.effects.oldtv.draw(
        function()
            love.graphics.setBlendMode("add") -- Default blend mode
            -- highlight the active lane
            -- gl0w.effects.godsrayActive.draw(function()
            --     drawActiveLane()
            -- end)

            -- draw everything else with less FX
            gl0w.effects.godsray.draw(
                function()
                    drawEverythingElse()
                end
            )

            -- overlay the BG and a clean copy of everything
            if (isBonus) then
                love.graphics.draw(background.bonus, 0, background.y)
                love.graphics.draw(background.bonus, 0, background.y - height)
            else
                love.graphics.draw(background.image, 0, background.y)
                love.graphics.draw(background.image, 0, background.y - height)
            end
            set_color(Colors.WHITE)
            local score_y = 0
            local highscore_y = 0
            if (score < highscore) then
                score_y = 60 + ((1 - (score / highscore)) * (600 - bitfont:getHeight("x") - 120))
            else
                score_y = 60
            end
            if (score > initial_highscore) then
                local highscore_multiplier = ((score - initial_highscore) / initial_highscore)
                if highscore_multiplier > 1 then
                    highscore_multiplier = 1
                end
                highscore_y = 60 + (highscore_multiplier * (600 - bitfont:getHeight("x") - 120))
            else
                highscore_y = 60
            end
            love.graphics.print("SCORE", 80, score_y - 20)
            love.graphics.print(math.floor(score), 80, score_y)
            love.graphics.print("HIGH", 800 - 80 - (bitfont:getWidth("HIGH")), highscore_y - 20)
            love.graphics.print(
                math.floor(highscore),
                800 - 80 - (bitfont:getWidth(math.floor(highscore))),
                highscore_y
            )
            -- love.graphics.print(diff, 80, 120)
            if countdown > 0 then
                love.graphics.print(
                    "G E T   R E A D Y",
                    400 - (bitfont:getWidth("G E T   R E A D Y") / 2),
                    300 - (bitfont:getHeight("G E T   R E A D Y") / 2)
                )
                love.graphics.setFont(largefont)
                love.graphics.print(
                    countdown,
                    400 - (largefont:getWidth(countdown) / 2),
                    400 - (largefont:getHeight(countdown) / 2)
                )
                love.graphics.setFont(bitfont)
            end
        end
    )
    if SHOW_FPS then
        love.graphics.setColor(0,1,0,1)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
        love.graphics.setColor(1,1,1,1)
    end
end
