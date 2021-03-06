score=passvar[1]
score=tonumber(score)
highscore=passvar[2]
highscore=tonumber(highscore)
state.clear()

textstring = "THIS GAME WAS CREATED DURING #GGJ2017 ---------------- TEAM GL0W ---------------- CODE: MARIANO AQUINO (DRMAQUINO) & MATIAS NAHUEL CARBALLO (MNCARBALLO) ---------------- MUSIC: MATIAS BONTEMPO ---------------- IDEAS AND MORAL SUPPORT: FAYSAL NOUFOURI ---------------- SPECIAL THANKS TO GLOBANT - FOR THE GRUBS AND CAFFEINE THAT MADE THIS PROJECT POSSIBLE! ---------------- SEE YOU IN THE NEXT GLOBAL GAME JAM!"

local shine = require 'libs/shine'
require 'helpers/colors'

local timer = 0
local bitfont = love.graphics.newFont("assets/pressstart2p.ttf", 18)
love.graphics.setFont(bitfont)

scanlines = shine.scanlines({pixel_size=5})
crt = shine.crt()
oldtv = scanlines:chain(crt)
yBase = 500;
scrollerHeight = 30;
letterSize = 21;
angle = {};
x = {};
col = 150;
coldx = 100;


function initScroller()
	local w = width;
	for i = 1,textstring:len() do
		angle[i] = i*6;
		x[i] = w+i*letterSize;
	end	
end
initScroller();


function love.update(dt)
    timer = timer + dt
    runAudio(dt)
    for i = 1,textstring:len() do
        angle[i] = angle[i] + math.pi/1.5 * dt;		
        x[i] = x[i] - letterSize*9*dt;
        if x[textstring:len()-1] < -letterSize*2 then
            initScroller();
        end
    end
	if col > 254 and coldx > 0 or col < 1 and coldx < 0 then
		coldx = coldx *-1;
	end
	col = col + coldx*dt;
    
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and not isrepeat then
        state.switch("title")
    end
    if key == "space" and not isrepeat then
        state.switch("game")
    end
end





function love.draw()
    oldtv:draw(function()

        set_color(Colors.WHITE)
        love.graphics.print("SCORE",80,40)
        love.graphics.print(math.floor(score),80,60)
        love.graphics.print("HIGH",800-80-(bitfont:getWidth("HIGH")),40)
        love.graphics.print(math.floor(highscore),800-80-(bitfont:getWidth(math.floor(highscore))),60)

        love.graphics.print("G A M E   O V E R",(800-(bitfont:getWidth("G A M E   O V E R")))/2,140)

        love.graphics.print("YOU SCORED",(800-(bitfont:getWidth("YOU SCORED")))/2,200)
        love.graphics.print(math.floor(score).." POINTS",(800-(bitfont:getWidth(math.floor(score).." POINTS")))/2,240)

        if math.floor(score) == math.floor(highscore) then
            love.graphics.print("NEW RECORD",(800-(bitfont:getWidth("NEW RECORD")))/2,300)
        else
            love.graphics.print("TRY AGAIN",(800-(bitfont:getWidth("TRY AGAIN")))/2,300)
        end

        for i = 1,textstring:len() do	

            local yflip = yBase + 40 + scrollerHeight + math.sin(angle[i])*scrollerHeight/2;
            local y = yBase - scrollerHeight - math.sin(angle[i])*scrollerHeight;
            
            c = textstring:sub(i,i);
            if x[i] > 2*-letterSize and x[i] < width+50 then
                love.graphics.setColor(255, col, 255, 40);
                love.graphics.printf(c,math.floor(x[i]),math.floor(yflip),900,"left",0,1,-1);			

                love.graphics.setColor(255, 255, col, 255);
                love.graphics.print(c,math.floor(x[i]),math.floor(y));
            end		
        end


    end)
end
