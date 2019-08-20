--           _|    _|                #ggj17
--   _|_|_|  _|  _|  _|  _|      _|      _|
-- _|    _|  _|  _|  _|  _|      _|      _|
-- _|    _|  _|  _|  _|    _|  _|  _|  _|
--   _|_|_|  _|    _|        _|      _|
--       _|
--   _|_|

-- 20190820 - updated for latest Löve version
--          - replaced shine with moonshine
--          - moved things into modules
--          - added sfx

if RELEASE then
    love.window.setMode(800, 600, {resizable=false, vsync=true, fullscreentype="exclusive"})
    love.window.setFullscreen(true, "exclusive")
    lovebird = {}
    lovebird.update = function() end
else
    lovebird = require("libs/lovebird/lovebird")
end

gl0w = {}

gl0w.highscore = require 'helpers/highscore'
gl0w.effects = require 'helpers/effects'
gl0w.audio = require 'helpers/audio'

state = require 'libs/stateswitcher'

bitfont = love.graphics.newFont("assets/pressstart2p.ttf", 18)
love.graphics.setFont(bitfont)

RELEASE = true -- you know it

width = love.graphics.getWidth()
height = love.graphics.getHeight()

state.switch("splash")