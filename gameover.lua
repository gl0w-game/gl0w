function love.update(dt)
    runAudio(dt)
end

function love.draw()
    love.graphics.print("Perdiste.",0,0)
end