--level.lua
local entity = require('src.class')
local Level = entity:makeSubclass('Level')

local Woogy = require 'src.woogy.woogy'
local Bullet = require 'src.bullet'
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
    local sh = love.window.getHeight() + 200
    
    self.positionMap[1] = {-70, -70}
    self.positionMap[2] = {sw/2, -70}
    self.positionMap[3] = {sw+70, -70}
    self.positionMap[4] = {sw+70, sh/2}
    self.positionMap[5] = {sw+70, sh+70}
    self.positionMap[6] = {sw/2, sh+70}
    self.positionMap[7] = {-70, sh+70}
    self.positionMap[8] = {-70, sh/2}
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
-- This was just testing the various enemy spawning positions.
-- Why is it still here? Why is anyone here?
--    self:spawnEnemy(1)
--    self:spawnEnemy(2)
--    self:spawnEnemy(3)
--    self:spawnEnemy(4)
--    self:spawnEnemy(5)
--    self:spawnEnemy(6)
--    self:spawnEnemy(7)
--    self:spawnEnemy(8)

      initTime = love.timer.getTime()
      print (initTime)
      
      --run the init thread, then start it (paused by default)
      self:threadSpawn()
      coroutine.resume(self.newThread, self)
    
      self.elapsed = 0
      self.counter = 1
    return self
end
Level:makeInit (init)

local function threadSpawn (self)

      self.newThread = coroutine.create(
        function(level)
           for i=self.counter,8 do
             print (i)
              level:spawnEnemy(i)
              coroutine.yield()
           end
      end)
end
Level.threadSpawn = Level:makeMethod (threadSpawn)

local function draw (self)
    self.woogy:draw()
    for i = 1,#self.enemyList do self.enemyList[i]:draw(dt) end
end
Level.draw = Level:makeMethod (draw)

local function update (self, dt)
--    self.elapsed = self.elapsed + dt
--    if self.elapsed == 10 then 
    local currentTime = love.timer.getTime()
    local timeDelta = math.floor(currentTime - initTime)
    if timeDelta == self.counter then
    
      self:threadSpawn(self) 
            if self.counter > 8 then
            self.counter = 1
            initTime = love.timer.getTime()

      end
      coroutine.resume(self.newThread, self)
      self.counter = self.counter + 1

    end
    
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
   self.woogy:handleInput (inputType, params)
end
Level.handleInput = Level:makeMethod (handleInput)

--id is up, right, down, left and size is the current woogy width
local function spawnBullet( x, y, size, color )
    --local x = polygonMaster.specialL
    --local bullet = Bullet:init(
end
Level.spawnBullet = Level:makeMethod (spawnBullet)
    
return Level