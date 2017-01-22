
maintimer = 0
local clock = os.clock

local shine = require 'libs/shine'

local function convertHex(hex)
    local splitToRGB = {}
    if # hex < 6 then hex = hex .. string.rep("F", 6 - # hex) end --flesh out bad hexes
    for x = 1, # hex - 1, 2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16)) --convert hexes to dec
        if splitToRGB[# splitToRGB] < 0 then slpitToRGB[# splitToRGB] = 0 end --prevents negative values
    end
    return unpack(splitToRGB)
end


function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do end
end


--====================================

width = love.graphics.getWidth()
height = love.graphics.getHeight()

--====================================

--COLORS

RED = "FF4136FF"
GREEN = "2ECC40FF"
BLUE = "0074D9FF"
YELLOW = "2ECCFFFF"
WHITE = "FFFFFFFF"

colission_range = 8
alter_freq = 0.0001
alter_amplitude = 0.1
alter_timer=0

function set_color(color)
    love.graphics.setColor(convertHex(color))
end

--====================================
-- WAVES

function Wave(color, offset_x, offset_y, speed, freq, amplitude)
    wave = {}
    wave.color = color
    wave.offset_x = offset_x
    wave.offset_y = offset_y
    wave.speed = speed
    wave.freq = freq
    wave.amplitude = amplitude
    wave.pos_player_x = 0
    wave.estado = 0
    -- waves[RED]["estado"] = 0
    return wave
end

waves = {}

waves[RED] = Wave(RED, 300, 0, 7, 0.02, 120)
waves[GREEN] = Wave(GREEN, 400, 0, 7, 0.02, 200)
waves[BLUE] = Wave(BLUE, 500, 0, 7, 0.02, 120)

background = love.graphics.newImage("gamebg.png")
foreground = love.graphics.newImage("screenoverlay.png")
background_y = 0
background_spd = 50 --speed of background scrolling in pixels-per-second


function wave_point(pos_y, speed, freq, amplitude)
    return math.sin(maintimer * -speed + freq * pos_y) * amplitude
end

function change_wave_offset_y(wave, inc)
    waves[wave].offset_y = waves[wave].offset_y + inc
end

--====================================

--PLAYER

LAST_STATE = 3

player = {}
player.pos_y = 300
player.color = GREEN
player.currentLane = RED

function change_player_color()
    if player.color == RED then
        player.color = GREEN
    elseif player.color == GREEN then
        player.color = BLUE
    elseif player.color == BLUE then
        player.color = RED
    end
end

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

    alter_timer = alter_timer+dt
    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1
        rnd = love.math.random(1,9)
        if rnd == 1 then
            waves[RED].estado = 1
        elseif rnd == 2 then
            waves[RED].estado = 0
        elseif rnd == 3 then
            waves[RED].estado = -1
        elseif rnd == 4 then
            waves[GREEN].estado = 1
        elseif rnd == 5 then
            waves[GREEN].estado = 0
        elseif rnd == 6 then
            waves[GREEN].estado = -1
        elseif rnd == 7 then
            waves[BLUE].estado = 1
        elseif rnd == 8 then
            waves[BLUE].estado = 0
        elseif rnd == 9 then
            waves[BLUE].estado = -1
        end

        waves[RED].freq = waves[RED].freq + (alter_freq*waves[RED].estado*dt*100)
        waves[GREEN].freq = waves[GREEN].freq + (alter_freq*waves[GREEN].estado*dt*100)
        waves[BLUE].freq = waves[BLUE].freq + (alter_freq*waves[BLUE].estado*dt*100)
        waves[RED].amplitude = waves[RED].amplitude + (alter_amplitude*waves[RED].estado*dt*100)
        waves[GREEN].amplitude = waves[GREEN].amplitude + (alter_amplitude*waves[GREEN].estado*dt*100)
        waves[BLUE].amplitude = waves[BLUE].amplitude + (alter_amplitude*waves[BLUE].estado*dt*100)

    end

    if player.currentLane == RED then
        player.pos_y = player.pos_y + dt*50
    end

    if player.currentLane == BLUE then
        player.pos_y = player.pos_y + dt*40
    end

    if player.currentLane == GREEN then
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
    love.window.setFullscreen(true, "exclusive")

    -- you can also provide parameters on effect construction

    gr = shine.godsray({exposure=25, decay=0.95})
    gr2 = shine.godsray()

    scanlines = shine.scanlines({pixel_size=5})
    crt = shine.crt()
    oldtv = scanlines:chain(crt)
end

function drawstuff()
    for pos_y = -200, 800 do

        for wave_color, wave in pairs(waves) do
            pos_x = wave_point(pos_y, wave.speed, wave.freq, wave.amplitude) -- pos_x = wave.pos_player_x --
            set_color(wave.color)
            love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 2)

            if pos_y == math.floor(player.pos_y) then
                wave.pos_player_x = math.floor(wave_point(pos_y-wave.offset_y, wave.speed, wave.freq, wave.amplitude)) + wave.offset_x 

                if wave_color == player.currentLane then
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 18)
                    set_color(WHITE)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 14)
                    set_color(player.color)
                    love.graphics.circle( "fill", pos_x + wave.offset_x, pos_y + wave.offset_y, 8)
                end
            end
        end
    end

    print( "RED:\t"..waves[RED].pos_player_x.."\tGRN:"..waves[GREEN].pos_player_x.."\t\tBLU:"..waves[BLUE].pos_player_x.."\tR-G:\t"..math.abs(waves[RED].pos_player_x - waves[GREEN].pos_player_x) .."\tR-B:".. math.abs(waves[RED].pos_player_x - waves[BLUE].pos_player_x) .."\t\tG-B:".. math.abs(waves[GREEN].pos_player_x - waves[BLUE].pos_player_x) )


    function handleColission(c1,c2)
        if player.currentLane == c1 or player.currentLane == c2 then
            if math.abs(waves[c1].pos_player_x - waves[c2].pos_player_x) < colission_range then
                if player.color == c1 or player.color == c2 then
                    player.currentLane = player.color
                end
            end
        end
    end

    handleColission(RED,BLUE)
    handleColission(GREEN,BLUE)
    handleColission(GREEN,RED)

    set_color(WHITE)
    love.graphics.print("T:"..maintimer,0,0)
end

function drawactivelane()
    for pos_y = -200, 800 do
        for wave_color, wave in pairs(waves) do

            pos_x = wave_point(pos_y, wave.speed, wave.freq, wave.amplitude)
            if wave_color == player.color then

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

        love.graphics.draw(background, 0, background_y)
        love.graphics.draw(background, 0, background_y - background:getHeight())

        gr2:draw(function()
            drawstuff()
        end)
        drawstuff()
    end)
end
