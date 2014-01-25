--main.lua
--require('mobdebug').start()

local Entity = require "src.entity"

local e = nil

function love.load()
	e = Entity:init("derp")
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	love.window.setMode(1280, 720) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, and no antialiasing
end

function love.update(dt)
	
end

function love.draw()
    e:draw()
end
 
function love.mousepressed(x, y, button)
 
    -- your code
end
 
function love.mousereleased(x, y, button)
 
end
 
function love.keypressed(key, unicode)
 
end
 
function love.keyreleased(key)
 
end