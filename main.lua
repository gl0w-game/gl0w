--           _|    _|                #ggj17
--   _|_|_|  _|  _|  _|  _|      _|      _|
-- _|    _|  _|  _|  _|  _|      _|      _|
-- _|    _|  _|  _|  _|    _|  _|  _|  _|
--   _|_|_|  _|    _|        _|      _|
--       _|
--   _|_|

state = require 'libs/stateswitcher'
require 'audio'
RELEASE = true -- you know it

if RELEASE then
    love.window.setMode(800, 600, {resizable=false, vsync=true, fullscreentype="exclusive"})
    love.window.setFullscreen(true, "exclusive")
end
width = love.graphics.getWidth()
height = love.graphics.getHeight()

state.switch("splash")
