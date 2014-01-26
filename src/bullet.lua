local entity = require('src.entity')
local Bullet = entity:makeSubclass("Bullet")

local Util = require 'src.util'

local polygonMaster = require 'src.polygonmaster'

local IM_DEAD = true
local IM_ALIVE = false

local function init (entity, self, x, y, angle,  scale, speed, color)
    class.super:initWith(self)
    
    self.triangle = polygonMaster.createBulletTriangle(scale)
    
    self.x = x
    self.y = y
    
    self.xDir = speed * math.cos (x)
    self.yDir = speed * math.sin (y)
    
    self.color = color
    
    return self
end
Bullet:makeInit(init)

local function update(self, dt)
    if self.x < 10 or self.x > love.window.getWidth() then
        return IM_DEAD
    end
    self.x = self.x + self.xDir * dt
    self.y = self.y + self.yDir * dt
    return IM_ALIVE
end
Bullet.update = Bullet:makeMethod(update)

local function draw (self)
    love.graphics.draw (self.triangle, self.x, self.y, self.angle)
end
Bullet.draw = Bullet:makeMethod (draw)

return Bullet