--main.lua
--require('mobdebug').start()

local Woogy = require "src.woogy.woogy"

local woogy = nil

local Level = require 'src.level'
local currentLevel

local keydown = false

function love.load()
    currentLevel = Level:init()
    
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	love.window.setMode(800, 800) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, and no antialiasing
    WIDTH = love.window.getWidth()
    HEIGHT = love.window.getHeight()
    HWIDTH = WIDTH/2
    HHEIGHT = HEIGHT/2
    
      --load sounds
  musicSoundFileName = love.sound.newSoundData("music.wav")
  musicSoundSource = love.audio.newSource(musicSoundFileName)
  musicSoundSource:setVolume(0.4)
  musicSoundSource:play()
  
--  musicSoundFileName = love.sound.newSoundData("music.wav")
--  musicSoundSource = love.audio.newSource(musicSoundFileName)
  

--  musicSoundSource:setPitch(1.0) -- one octave lower
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
    currentLevel:handleInput ('mousereleased', { x=x, y=y, button=button })
end
 
function love.keypressed (key, isrepeat)
    keydown = true
    currentLevel:handleInput ( 'keypressed', {key=key, isrepeat=isrepeat} )
end
 
function love.keyreleased(key)
    currentLevel:handleInput ( 'keyreleased', {key=key} )
end
