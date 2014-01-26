--level.lua
local entity = require('src.class')
local Level = entity:makeSubclass('Level')

local Woogy = require 'src.woogy.woogy'
local Bullet = require 'src.bullet'
local Enemy = require 'src.woogy.enemy'




HC = require 'src.hardoncollider'

local MAX_ENTITIES = 100
local bulletSpeed = 550

local currentLevel

local function init (class, self)
    class.super:initWith(self)
    currentLevel = self
    
    self.LevelData = require 'src.levelData'
    
    self.levelStepper = 1
    
    self.collider = HC ( MAX_ENTITIES, on_collision, collision_stop)
    
    self.woogy = Woogy:init (self)
    
    self.keyspressed = {}
    self.woogy.keyspressed = self.keypressed --woogy has pointer to input array
    
    
    --determining the starting position, direction, and rotation of enemies according to an int.
    local sw = love.window.getWidth() +5
    local sh = love.window.getHeight() +135
    self.positionMap = {}
    self.positionMap[1] = {-70, -70}
    self.positionMap[2] = {sw/2, -90}
    self.positionMap[3] = {sw+70, -70}
    self.positionMap[4] = {sw+90, sh/2}
    self.positionMap[5] = {sw+70, sh+70}
    self.positionMap[6] = {sw/2, sh+100}
    self.positionMap[7] = {-70, sh+70}
    self.positionMap[8] = {-90, sh/2}
    self.vectorMap = {}   
    self.vectorMap[1] = {-math.cos(THR_QTR_PI), math.sin(THR_QTR_PI)}
    self.vectorMap[2] = {-math.cos(HALF_PI), math.sin(HALF_PI)}
    self.vectorMap[3] = {-math.cos(QTR_PI), math.sin(QTR_PI)}
    self.vectorMap[4] = {-1, 0}
    self.vectorMap[5] = {-self.vectorMap[1][1], -self.vectorMap[1][2]}
    self.vectorMap[6] = {-self.vectorMap[2][1], -self.vectorMap[2][2]}
    self.vectorMap[7] = {-self.vectorMap[3][1], -self.vectorMap[3][2]}
    self.vectorMap[8] = {-self.vectorMap[4][1], -self.vectorMap[4][2]}
    self.rotationMap = {}
    self.rotationMap[1] = QTR_PI
    self.rotationMap[2] = HALF_PI
    self.rotationMap[3] = THR_QTR_PI
    self.rotationMap[4] = PI
    self.rotationMap[5] = 5*QTR_PI
    self.rotationMap[6] = 3*HALF_PI
    self.rotationMap[7] = 7*QTR_PI
    self.rotationMap[8] = 0
   
    self.enemyList = {}
   
    self.bulletList = {}

      initTime = love.timer.getTime()
      print (initTime)
      
      --run the init thread, then start it (paused by default)
--      self:threadSpawn()
--      coroutine.resume(self.newThread, self)

      self.elapsed = 0 -- total time elapsed
      self.onBeatTime = .5 -- the beat
    return self
end
Level:makeInit (init)

local function draw (self)
    self.woogy:draw()
    --Draw enemies!!
    for i = 1,#self.enemyList do self.enemyList[i]:draw() end
    
    --Draw bullets!!!
    for i = 1,#self.bulletList do self.bulletList[i]:draw() end
end
Level.draw = Level:makeMethod (draw)

local function update (self, dt)
    self.elapsed = self.elapsed + dt -- increment time since last update
    
    if self.elapsed >= self.onBeatTime then
        for k = 1, #self.LevelData[self.levelStepper] do
          self:spawnEnemy(self.LevelData[self.levelStepper][k])
          print (self.LevelData[self.levelStepper][k]) -- not printed
        end
        
      self.levelStepper = self.levelStepper + 1
      self.elapsed = self.elapsed-self.onBeatTime
      
      if self.levelStepper >#self.LevelData then 
        self.levelStepper=1
      end
    end
    
    self.woogy:update(dt, self.keyspressed)
    
    --Update enemies
    for i = 1,#self.enemyList do self.enemyList[i]:update(dt) end
    
    --Update bullets, loop backwards so we can safely remove while iterating
    for i=#self.bulletList, 1, -1 do
        if self.bulletList[i]:update(dt) then
            table.remove(self.bulletList, i)
        end
    end
    
end
Level.update = Level:makeMethod (update)

local function spawnEnemy(self, posID)
    if posID == 0 then return end
    local x = self.positionMap[posID][1]
    local y = self.positionMap[posID][2]
    local xDir = self.vectorMap[posID][1]
    local yDir = self.vectorMap[posID][2]
    local rotation = self.rotationMap[posID]
    local enemy = Enemy:init (x,y,xDir,yDir, rotation)
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
local function spawnBullet( self, x, y, xdir, ydir, angle, size, color )
    --local x = polygonMaster.specialL
    --x, y, xDir, yDir,  size, speed, color
     table.insert (self.bulletList, Bullet:init (x, y, xdir, ydir, angle, size, bulletSpeed, color) )
end
Level.spawnBullet = Level:makeMethod (spawnBullet)
    
 local function on_collision (dt, shape_a, shape_b, mtv_x, mtv_y)
     --print(string.format("Colliding. mtv = (%s,%s)", 
     --                               mtv_x, mtv_y))
end
    
 -- this is called when two shapes stop colliding
local function collision_stop(dt, shape_a, shape_b)
    --text[#text+1] = "Stopped colliding"
end
    
return Level