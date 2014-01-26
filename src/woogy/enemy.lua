-- enemy

local entity = require('src.entity')
local polygonMaster = require 'src.polygonmaster'

local Enemy = entity:makeSubclass("Enemy")
local function init(class, self, collider, x, y, xDir, yDir, rotation, speed)
    class.super:initWith(self)
    self.enemyTriangle = collider:addPolygon( polygonMaster.createEnemyTriangleVerts() )
    self.enemyTriangle.id = 'enemy'
    
    self.enemyTriangle:setRotation(rotation)
    self.enemyTriangle:scale(50) --default size??
    self.enemyTriangle:moveTo (x, y)
    --self.x = x
    --self.y = y
    self.xDir = xDir
    self.yDir = yDir
    --self.rotation = rotation
    self.speed = speed or 100
    return self
end
Enemy:makeInit(init)


local function draw (self, rotation)
--    love.graphics.setColor(55, 86, 0) --??
    self.enemyTriangle:draw('fill')
    --love.graphics.draw(self.enemyTriangle, self.x, self.y, self.rotation)
end
Enemy.draw = Enemy:makeMethod(draw)


local function update (self, dt)
  --TODO: Need to update update?
   --self.x = self.x + self.xDir
   --self.y = self.y + self.yDir
   dt = dt * self.speed
   self.enemyTriangle:move (self.xDir * dt, self.yDir * dt)
end
Enemy.update = Enemy:makeMethod (update)


return Enemy
