local clock = os.clock
local shine = require 'libs/shine'

require 'colors'
require 'wave'
require 'player'

--====================================

maintimer = 0

width = love.graphics.getWidth()
height = love.graphics.getHeight()

--====================================

background = love.graphics.newImage("gamebg.png")
foreground = love.graphics.newImage("screenoverlay.png")
background_y = 0
background_spd = 50 --speed of background scrolling in pixels-per-second

--========================================================

-- GAME UPDATE

-- para evitar inputs multiples cuando se mantiene apretada una tecla

keysdown = 0

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and keysdown == 0 then
        change_player_color()
        keysdown = keysdown + 1
    end
end

function love.keyreleased(key, scancode)
    keysdown = 0
end

function love.update(dt)
    require("libs/lovebird").update()
    --dt=0.005
    maintimer = maintimer + dt
    alter_timer = alter_timer + dt

    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1

        rnd = love.math.random(1,9)

        if rnd == 1 then
            waves[Colors.RED].estado = 1
        elseif rnd == 2 then
            waves[Colors.RED].estado = 0
        elseif rnd == 3 then
            waves[Colors.RED].estado = -1
        elseif rnd == 4 then
            waves[Colors.GREEN].estado = 1
        elseif rnd == 5 then
            waves[Colors.GREEN].estado = 0
        elseif rnd == 6 then
            waves[Colors.GREEN].estado = -1
        elseif rnd == 7 then
            waves[Colors.BLUE].estado = 1
        elseif rnd == 8 then
            waves[Colors.BLUE].estado = 0
        elseif rnd == 9 then
            waves[Colors.BLUE].estado = -1
        end

        waves[Colors.RED].freq = waves[Colors.RED].freq + (alter_freq*waves[Colors.RED].estado*dt*100)
        waves[Colors.GREEN].freq = waves[Colors.GREEN].freq + (alter_freq*waves[Colors.GREEN].estado*dt*100)
        waves[Colors.BLUE].freq = waves[Colors.BLUE].freq + (alter_freq*waves[Colors.BLUE].estado*dt*100)

        waves[Colors.RED].amplitude = waves[Colors.RED].amplitude + (alter_amplitude*waves[Colors.RED].estado*dt*100)
        waves[Colors.GREEN].amplitude = waves[Colors.GREEN].amplitude + (alter_amplitude*waves[Colors.GREEN].estado*dt*100)
        waves[Colors.BLUE].amplitude = waves[Colors.BLUE].amplitude + (alter_amplitude*waves[Colors.BLUE].estado*dt*100)

    end

    if player.current_wave == Colors.RED then
        player.pos_y = player.pos_y + dt*50
    end

    if player.current_wave == Colors.BLUE then
        player.pos_y = player.pos_y + dt*40
    end

    if player.current_wave == Colors.GREEN then
        player.pos_y = player.pos_y - dt*100
    end

    background_y = background_y + background_spd * dt
    if background_y > love.graphics.getHeight() then
        background_y = background_y - love.graphics.getHeight()
    end

end

--=============================================================

function love.load()
    love.window.setMode(800, 600, {resizable=false, vsync=true, fullscreentype="exclusive"})
    -- love.window.setFullscreen(true, "exclusive")

    -- you can also provide parameters on effect construction

    gr = shine.godsray({exposure=25, decay=0.95})
    gr2 = shine.godsray()

    scanlines = shine.scanlines({pixel_size=5})
    crt = shine.crt()
    oldtv = scanlines:chain(crt)

    -- GAME OBJECTS

    player = Player(300, Colors.GREEN, Colors.RED)

    waves = {}
    waves[Colors.RED] = Wave(Colors.RED, 300, 0, 7, 0.02, 120)
    waves[Colors.GREEN] = Wave(Colors.GREEN, 400, 0, 7, 0.02, 200)
    waves[Colors.BLUE] = Wave(Colors.BLUE, 500, 0, 7, 0.02, 120)

end

function drawstuff()
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

    -- io.write( "Colors.RED:\t"..waves[Colors.RED].pos_x.."\tGRN:"..waves[Colors.GREEN].pos_x.."\tBLU:"..waves[Colors.BLUE].pos_x)
    -- print( "\t\tR-G:\t"..math.abs(waves[Colors.RED].pos_x - waves[Colors.GREEN].pos_x) .."\tR-B:".. math.abs(waves[Colors.RED].pos_x - waves[Colors.BLUE].pos_x) .."\t\tG-B:".. math.abs(waves[Colors.GREEN].pos_x - waves[Colors.BLUE].pos_x) )

    handleColission(Colors.RED,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.BLUE)
    handleColission(Colors.GREEN,Colors.RED)

    set_color(Colors.WHITE)
    love.graphics.print("T:"..maintimer,0,0)
end

function handleColission(color1, color2)
    if player.current_wave == color1 or player.current_wave == color2 then
        if math.abs(waves[color1].pos_x - waves[color2].pos_x) < colission_range then
            if player.color == color1 or player.color == color2 then
                player.current_wave = player.color
            end
        end
    end
end

function drawactivelane()
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

        gr:draw(function()
            drawactivelane()
        end)

        gr2:draw(function()
            drawstuff()
        end)

        love.graphics.draw(background, 0, background_y)
        love.graphics.draw(background, 0, background_y - background:getHeight())
        drawstuff()
    end)
end
