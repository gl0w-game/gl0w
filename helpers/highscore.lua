local highscore = {}
  highscore.get = function()
    local score = 0
    if not love.filesystem.getInfo('score.txt') then
        love.filesystem.write('score.txt', 10000)
    end
    score = love.filesystem.read('score.txt')
    score = tonumber(score)
    return score
  end
  highscore.set = function(score)
    love.filesystem.write('score.txt', score)
  end
return highscore