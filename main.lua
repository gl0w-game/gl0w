maintimer = 0
local clock = os.clock

function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do
    end
end

width = love.graphics.getWidth()
height = love.graphics.getHeight()
offset_y={300,400,500}
amplitude={100,150,125}
speed = 2
freq = 0.05
colors = {red, green, blue}
altura = {100, 100, 100}

function love.update(dt)
    maintimer = maintimer + dt

    altura[1] = altura[1] + (freq * speed/4 * amplitude[1] * 20 * dt)
    altura[2] = altura[2] + (freq*2 * speed/4 * amplitude[2] * 20 * dt)
    altura[3] = altura[3] + (freq*3 * speed/4 * amplitude[3] * 20 * dt)

    altura[1] = altura[1] - (freq*2 * speed/4 * amplitude[2] * 20 * dt) * 0.5

    if love.keyboard.isDown("up") then
        altura[1] = altura[1] + (freq * speed * amplitude[1] * 20 * dt)
        altura[2] = altura[2] + (freq*2 * speed * amplitude[2] * 20 * dt)
        altura[3] = altura[3] + (freq*3 * speed * amplitude[3] * 20 * dt)
    end

    if love.keyboard.isDown("down") then
        altura[1] = altura[1] - (freq * speed * amplitude[1] * 20 * dt)
        altura[2] = altura[2] - (freq*2 * speed * amplitude[2] * 20 * dt)
        altura[3] = altura[3] - (freq*3 * speed * amplitude[3] * 20 * dt)
    end
end

function love.draw()
    for y=0,600 do

        if y == math.floor(altura[1]) then
            radius = 10
        else
            radius = 2
        end

        love.graphics.setColor(255,0,0,127)
        love.graphics.circle( "fill", (math.sin(maintimer*speed+freq*y)*amplitude[1])+offset_y[1], height-y,radius)

        if y == math.floor(altura[2]) then
            radius = 10
        else
            radius = 2
        end

        love.graphics.setColor(0,255,0,127)
        love.graphics.circle( "fill", (math.sin(4+maintimer*speed+freq/2*y)*amplitude[2])+offset_y[2], height-y,radius)
        -- love.graphics.circle( "fill", (math.sin(4+maintimer*speed+freq*y)*amplitude[2])+offset_y[2], height-y,radius)

        if y == math.floor(altura[3]) then
            radius = 10
        else
            radius = 2
        end

        love.graphics.setColor(0,0,255,255)
        love.graphics.circle( "fill", (math.sin(maintimer*speed+freq/3*y)*amplitude[3])+offset_y[3], height-y,radius)
        -- love.graphics.circle( "fill", (math.sin(maintimer*speed+freq*y)*amplitude[3])+offset_y[3], height-y,radius)
    end

    love.graphics.setColor(255,255,255,127)
    love.graphics.print("T:"..maintimer,0,0)
end
