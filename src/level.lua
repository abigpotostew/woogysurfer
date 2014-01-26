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
    
    self.keyspressed = {}
    self.woogy.keyspressed = self.keypressed --woogy has pointer to input array
    
    
    --determining the starting position and direction of enemies according to an int:
    self.positionMap = {}
    local sw = love.window.getWidth()
    local sh = love.window.getHeight()
    
    self.positionMap[1] = {-100, -100}
    self.positionMap[2] = {sw/2, -100}
    self.positionMap[3] = {sw+100, -100}
    self.positionMap[4] = {sw+100, sh/2}
    self.positionMap[5] = {sw+100, sh+100}
    self.positionMap[6] = {sw/2, sh+100}
    self.positionMap[7] = {0, sh+100}
    self.positionMap[8] = {0, sh/2}
    self.vectorMap = {}   
    self.vectorMap[1] = {-math.cos(THR_QTR_PI), math.sin(THR_QTR_PI)}
    self.vectorMap[2] = {-math.cos(HALF_PI), math.sin(HALF_PI)}
    self.vectorMap[3] = {-math.cos(QTR_PI), math.sin(QTR_PI)}
    self.vectorMap[4] = {-1, 0}
    self.vectorMap[5] = {-self.vectorMap[1][1], -self.vectorMap[1][2]}
    self.vectorMap[6] = {-self.vectorMap[2][1], -self.vectorMap[2][2]}
    self.vectorMap[7] = {-self.vectorMap[3][1], -self.vectorMap[3][2]}
    self.vectorMap[8] = {-self.vectorMap[4][1], -self.vectorMap[4][2]}
   
    self.enemyList = {}
    
    self:spawnEnemy(1)
    self:spawnEnemy(2)
    self:spawnEnemy(3)
    self:spawnEnemy(4)
    self:spawnEnemy(5)
    self:spawnEnemy(6)
    self:spawnEnemy(7)
    self:spawnEnemy(8)
   
    
    
    return self
end
Level:makeInit (init)

local function draw (self)
    self.woogy:draw()
    for i = 1,#self.enemyList do self.enemyList[i]:draw(dt) end
end
Level.draw = Level:makeMethod (draw)

local function update (self, dt)
    self.world:update(dt)
    self.woogy:update(dt, self.keyspressed)
    for i = 1,#self.enemyList do self.enemyList[i]:update(dt) end
end
Level.update = Level:makeMethod (update)

local function spawnEnemy(self, posID)
    local x = self.positionMap[posID][1]
    local y = self.positionMap[posID][2]
    local xDir = self.vectorMap[posID][1]
    local yDir = self.vectorMap[posID][2]
    local enemy = Enemy:init (x,y,xDir,yDir)
    table.insert(self.enemyList,enemy)
end
Level.spawnEnemy = Level:makeMethod (spawnEnemy)

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