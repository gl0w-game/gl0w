maintimer = 0
local clock = os.clock

local shine = require 'shine'

local function convertHex(hex)
    local splitToRGB = {}
    if # hex < 6 then hex = hex .. string.rep("F", 6 - # hex) end --flesh out bad hexes
    for x = 1, # hex - 1, 2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16)) --convert hexes to dec
        if splitToRGB[# splitToRGB] < 0 then slpitToRGB[# splitToRGB] = 0 end --prevents negative values
    end
    return unpack(splitToRGB)
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


alter_freq = 0.0001
alter_amplitude = 0.1
alter_timer=0

function set_color(color)
    love.graphics.setColor(convertHex(color))
end

--====================================
-- WAVES

waves = {}
waves["red"] = {}
waves["red"]["color"] = RED
waves["red"]["offset_x"] = 250
waves["red"]["offset_y"] = 0
waves["red"]["speed"] = 7
waves["red"]["freq"] = 0.015
waves["red"]["amplitude"] = 160
waves["red"]["estado"] = 0

waves["green"] = {}
waves["green"]["color"] = GREEN
waves["green"]["offset_x"] = 400
waves["green"]["offset_y"] = 60
waves["green"]["speed"] = 7
waves["green"]["freq"] = 0.020
waves["green"]["amplitude"] = 120
waves["green"]["estado"] = 0

waves["blue"] = {}
waves["blue"]["color"] = BLUE
waves["blue"]["offset_x"] = 550
waves["blue"]["offset_y"] = 0
waves["blue"]["speed"] = 7
waves["blue"]["freq"] = 0.025
waves["blue"]["amplitude"] = 180
waves["blue"]["estado"] = 0

background = love.graphics.newImage("gamebg.png")
foreground = love.graphics.newImage("screenoverlay.png")
background_y = 0
background_spd = 50 --speed of background scrolling in pixels-per-second


function wave_point(pos_y, speed, freq, amplitude)
    return math.sin(maintimer * -speed + freq * pos_y) * amplitude
end

function change_wave_offset_y(wave, inc)
    waves[wave]["offset_y"] = waves[wave]["offset_y"] + inc
end

--====================================

--PLAYER

LAST_STATE = 3

player = {}
player["pos_y"] = 300
player["color"] = "red"

function change_player_color()
    if player["color"] == "red" then
        player["color"] = "green"
    elseif player["color"] == "green" then
        player["color"] = "blue"
    elseif player["color"] == "blue" then
        player["color"] = "red"
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
    maintimer = maintimer + dt
    
    alter_timer = alter_timer+dt
    if alter_timer > 0.1 then
        alter_timer = alter_timer - 0.1
        rnd = love.math.random(1,9)
        if rnd == 1 then
            waves["red"]["estado"] = 1
        elseif rnd == 2 then
            waves["red"]["estado"] = 0
        elseif rnd == 3 then
            waves["red"]["estado"] = -1
        elseif rnd == 4 then
            waves["green"]["estado"] = 1
        elseif rnd == 5 then
            waves["green"]["estado"] = 0
        elseif rnd == 6 then
            waves["green"]["estado"] = -1
        elseif rnd == 7 then
            waves["blue"]["estado"] = 1
        elseif rnd == 8 then
            waves["blue"]["estado"] = 0
        elseif rnd == 9 then
            waves["blue"]["estado"] = -1
        end

        waves["red"]["freq"] = waves["red"]["freq"] + (alter_freq*waves["red"]["estado"]*dt*100)
        waves["green"]["freq"] = waves["green"]["freq"] + (alter_freq*waves["green"]["estado"]*dt*100)
        waves["blue"]["freq"] = waves["blue"]["freq"] + (alter_freq*waves["blue"]["estado"]*dt*100)
        waves["red"]["amplitude"] = waves["red"]["amplitude"] + (alter_amplitude*waves["red"]["estado"]*dt*100)
        waves["green"]["amplitude"] = waves["green"]["amplitude"] + (alter_amplitude*waves["green"]["estado"]*dt*100)
        waves["blue"]["amplitude"] = waves["blue"]["amplitude"] + (alter_amplitude*waves["blue"]["estado"]*dt*100)
        
    end

    if player["color"] == "red" then
        player["pos_y"] = player["pos_y"] - dt*4
    end

    if player["color"] == "blue" then
        player["pos_y"] = player["pos_y"] + dt*4
    end

    background_y = background_y + background_spd * dt
    if background_y > love.graphics.getHeight() then
        background_y = background_y - love.graphics.getHeight()
    end

    print(waves["blue"]["freq"].." - "..waves["blue"]["amplitude"])

end

--====================================


function love.load()
    -- love.window.setMode(800, 600, {resizable=false, vsync=true, fullscreentype="exclusive"})
    -- love.window.setFullscreen(true, "exclusive")

    -- you can also provide parameters on effect construction
    gr = shine.godsray({exposure=25, decay=0.95})
    gr2 = shine.godsray()

    scanlines = shine.scanlines({pixel_size=5})
    crt = shine.crt()
    oldtv = scanlines:chain(crt)
    -- more code here
end


function drawstuff()
    for pos_y = -200, 800 do       
        for wave_color, wave in pairs(waves) do
            pos_x = wave_point(pos_y, wave["speed"], wave["freq"], wave["amplitude"])
            set_color(wave["color"])
            love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 2)
            if pos_y == math.floor(player["pos_y"]) then
                if wave_color == player["color"] then
                        set_color(wave["color"])
                        love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 18)
                        love.graphics.setColor(255,255,255,255)
                        love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 14)
                        set_color(wave["color"])
                        love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 8)
                end
            end
        end
    end
    love.graphics.setColor(255,255,255,127)
    love.graphics.print("T:"..maintimer,0,0)
end
function drawactivelane()
    for pos_y = -200, 800 do
        for wave_color, wave in pairs(waves) do

            pos_x = wave_point(pos_y, wave["speed"], wave["freq"], wave["amplitude"])
            if wave_color == player["color"] then

            set_color(wave["color"])
            love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 2)
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
