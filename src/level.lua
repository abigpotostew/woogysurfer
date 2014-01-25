--level.lua
local entity = require('src.class')
local Level = entity:makeSubclass('Level')

local Woogy = require 'src.woogy.woogy'

local function init (class, self)
    class.super:initWith(self)
    
    love.physics.setMeter (64)
    self.world = love.physics.newWorld (0, 0,  true)
    
    self.woogy = Woogy:init (self.world)
    
    self.keyspressed = {}
    self.woogy.keyspressed = self.keypressed --woogy has pointer to input array
    
    return self
end
Level:makeInit (init)

local function draw (self)
    
    self.woogy:draw()
end
Level.draw = Level:makeMethod (draw)

local function update (self, dt)
    self.world:update(dt)
    self.woogy:update (dt, self.keyspressed)
end
Level.update = Level:makeMethod (update)

local function handleInput ( self, inputType,  params )
    if inputType == 'keypressed' then
       self.keyspressed[params.key] = true
   elseif  inputType == 'keyreleased' then
       self.keyspressed[params.key] = nil
   end
   --self.woogy:handleInput (self.keyspressed)
end
Level.handleInput = Level:makeMethod (handleInput)

return Level