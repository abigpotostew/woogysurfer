local entity = require('src.entity')
local Bullet = entity:makeSubclass("Bullet")

local Util = require 'src.util'

local polygonMaster = require 'src.polygonmaster'

local IM_DEAD = true
local IM_ALIVE = false

local function init (class, self, x, y, xDir, yDir,  angle, size, speed, color)
    class.super:initWith(self)
    
    self.triangle = polygonMaster.createBulletTriangle(size)
    
    self.x = x
    self.y = y
    
    self.xDir = xDir * speed
    self.yDir = yDir * speed
    
    self.color = color
    
    self.size = size
    
    self.angle = angle
    
    return self
end
Bullet:makeInit(init)

local function update(self, dt)
    if self.x < -self.size or self.x > love.window.getWidth() then
        return IM_DEAD
    end
    self.x = self.x + self.xDir * dt
    self.y = self.y + self.yDir * dt
    return IM_ALIVE
end
Bullet.update = Bullet:makeMethod(update)

local function draw (self)
    love.graphics.setColor (self.color[1], self.color[2], self.color[3])
    love.graphics.draw (self.triangle, self.x, self.y, self.angle)
end
Bullet.draw = Bullet:makeMethod (draw)

return Bullet