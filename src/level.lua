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
    
    self.collider = HC ( MAX_ENTITIES, on_collision, collision_stop)
    
    self.woogy = Woogy:init (self)
    
    self.keyspressed = {}
    self.woogy.keyspressed = self.keypressed --woogy has pointer to input array
    
    
    --determining the starting position and direction of enemies according to an int:
    self.positionMap = {}
    local sw = love.window.getWidth() - 200
    local sh = love.window.getHeight()
    
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
   
    self.bulletList = {}
    
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
local function spawnBullet( self, x, y, xdir, ydir, angle, size, color )
    --local x = polygonMaster.specialL
    --x, y, xDir, yDir,  size, speed, color
     table.insert (self.bulletList, Bullet:init (x, y, xdir, ydir, angle, size, bulletSpeed, color) )
end
Level.spawnBullet = Level:makeMethod (spawnBullet)
    
 local function on_collision (dt, shape_a, shape_b, mtv_x, mtv_y)
     print(text[#text+1] = string.format("Colliding. mtv = (%s,%s)", 
                                    mtv_x, mtv_y))
end
    
 -- this is called when two shapes stop colliding
local function collision_stop(dt, shape_a, shape_b)
    text[#text+1] = "Stopped colliding"
end
    
return Level