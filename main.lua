maintimer = 0
local clock = os.clock

--====================================

width = love.graphics.getWidth()
height = love.graphics.getHeight()

--====================================

--COLORS

colors = {}
colors["red"] = {}
colors["red"]["r"] = 255
colors["red"]["g"] = 0
colors["red"]["b"] = 0
colors["red"]["a"] = 127

colors["green"] = {}
colors["green"]["r"] = 0
colors["green"]["g"] = 255
colors["green"]["b"] = 0
colors["green"]["a"] = 127

colors["blue"] = {}
colors["blue"]["r"] = 0
colors["blue"]["g"] = 0
colors["blue"]["b"] = 255
colors["blue"]["a"] = 127

RED = colors["red"]
GREEN = colors["green"]
BLUE = colors["blue"]

function set_color(color)
    love.graphics.setColor(color["r"], color["g"], color["b"], color["a"])
end

--====================================

-- WAVES

waves = {}
waves["red"] = {}
waves["red"]["color"] = RED
waves["red"]["offset_x"] = 170
waves["red"]["offset_y"] = 0
waves["red"]["speed"] = 7
waves["red"]["freq"] = 0.05
waves["red"]["amplitude"] = 80

waves["green"] = {}
waves["green"]["color"] = GREEN
waves["green"]["offset_x"] = 300
waves["green"]["offset_y"] = 60
waves["green"]["speed"] = 7
waves["green"]["freq"] = 0.05
waves["green"]["amplitude"] = 120

waves["blue"] = {}
waves["blue"]["color"] = BLUE
waves["blue"]["offset_x"] = 520
waves["blue"]["offset_y"] = 0
waves["blue"]["speed"] = 7
waves["blue"]["freq"] = 0.05
waves["blue"]["amplitude"] = 180

function draw_wave_point(pos_y, offset_x, offset_y, speed, freq, amplitude, color, radius)
    set_color(color)
    pos_x = wave_point(pos_y, speed, freq, amplitude)
    love.graphics.circle( "fill", pos_x + offset_x, pos_y + offset_y, radius)
end

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

    if player["color"] == "red" then
        player["pos_y"] = player["pos_y"] - 1
    end

    if player["color"] == "green" then
        -- player["pos_y"] = player["pos_y"] + 0
    end

    if player["color"] == "blue" then
        player["pos_y"] = player["pos_y"] + 1
    end

end

--====================================

function love.draw()

    for pos_y = -200, 800 do

        for wave_color, wave in pairs(waves) do

            pos_x = wave_point(pos_y, wave["speed"], wave["freq"], wave["amplitude"])

            set_color(wave["color"])

            love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 2)

            if pos_y == player["pos_y"] then

                if wave_color == player["color"] then
                    love.graphics.circle( "fill", pos_x + wave["offset_x"], pos_y + wave["offset_y"], 10)
                end
            end
        end
    end

    love.graphics.setColor(255,255,255,127)
    love.graphics.print("T:"..maintimer,0,0)
end
