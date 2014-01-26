-- enemy

local entity = require('src.entity')
local polygonMaster = require 'src.polygonmaster'

local Enemy = entity:makeSubclass("Enemy")
local function init(class, self, x, y, xDir, yDir, rotation)
    class.super:initWith(self)
    self.enemyTriangle = polygonMaster.createEnemyTriangle()
    self.x = x
    self.y = y
    self.xDir = xDir
    self.yDir = yDir
    self.rotation = rotation
    return self
end
Enemy:makeInit(init)


local function draw (self, rotation)
    love.graphics.draw(self.enemyTriangle, self.x, self.y, self.rotation)
end
Enemy.draw = Enemy:makeMethod(draw)


local function update (self, dt)
  --TODO: Need to update update?
   self.x = self.x + self.xDir*4
   self.y = self.y + self.yDir*4
end
Enemy.update = Enemy:makeMethod (update)


return Enemy
