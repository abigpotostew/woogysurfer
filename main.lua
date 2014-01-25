--main.lua
--require('mobdebug').start()

local Woogy = require "src.woogy.woogy"

local woogy = nil

local Level = require 'src.level'
local currentLevel

function love.load()
    currentLevel = Level:init()
    
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	love.window.setMode(700, 550) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, and no antialiasing
end

function love.update (dt)
	currentLevel:update (dt)
end

function love.draw()
    currentLevel:draw()
end
 
function love.mousepressed(x, y, button)
    currentLevel:handleInput ('mousepressed', { x=x, y=y, button=button })
end
 
function love.mousereleased(x, y, button)
    currentLevel.woogy:shrink()
    currentLevel:handleInput ('mousereleased', { x=x, y=y, button=button })
end
 
function love.keypressed (key, isrepeat)
    currentLevel:handleInput ( 'keypressed', {key=key, isrepeat=isrepeat} )
end
 
function love.keyreleased(key)
    currentLevel:handleInput ( 'keyreleased', {key=key} )
end
