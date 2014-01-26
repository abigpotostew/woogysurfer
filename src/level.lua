--level.lua
local entity = require('src.class')
local Level = entity:makeSubclass('Level')

local Woogy = require 'src.woogy.woogy'
local Enemy = require 'src.woogy.enemy'

local function init (class, self)
    class.super:initWith(self)
    
    love.physics.setMeter (64)
    self.world = love.physics.newWorld (0, 0,  true)
    
    self.woogy = Woogy:init (self.world)
    self.enemy = Enemy:init (self.world, 1)
    
    self.keyspressed = {}
    self.woogy.keyspressed = self.keypressed --woogy has pointer to input array
    
    self.positionMap = {}
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    
    self.positionMap[1] = {-100, -100}
    self.positionMap[2] = {sw/2, -100}
    self.positionMap[3] = {sw+100, -100}
    self.positionMap[4] = {sw+100, sh/2}
    self.positionMap[5] = {sw+100, sh+100}
    self.positionMap[6] = {sw/2, sh+100}
    self.positionMap[7] = {0, sh+100}
    self.positionMap[8] = {0, sh/2}
    
    
   self.vectorMap = {}
    
    return self
end
Level:makeInit (init)

local function draw (self)
    
    self.woogy:draw()
    self.enemy:draw()
end
Level.draw = Level:makeMethod (draw)

local function update (self, dt)
    self.world:update(dt)
    self.woogy:update (dt, self.keyspressed)
    self.enemy:update(dt)
end
Level.update = Level:makeMethod (update)

local function spawnEnemy()
    
end

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