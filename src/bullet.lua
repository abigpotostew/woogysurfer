local entity = require('src.entity')
local Bullet = entity:makeSubclass("Bullet")

local Util = require 'src.util'

local polygonMaster = require 'src.polygonmaster'

local IM_DEAD = true
local IM_ALIVE = false

local function init (class, self, collider, x, y, xDir, yDir,  angle, size, speed, color)
    class.super:initWith(self)
    
    --self.triangle = polygonMaster.createBulletTriangle(size)
    self.triangle = collider:addPolygon (polygonMaster.getBulletVerts(size))
    self.triangle.id = 'bullet'
    self.triangle:rotate (angle, 0, 0)
    self.triangle:moveTo(x,y)
    
    self.x = x
    self.y = y
    
    self.xDir = xDir * speed
    self.yDir = yDir * speed
    
    self.color = color
    
    self.size = size
    
    --self.angle = angle
    self.outerLimit = { b = self.size*4,  w = self.size*4+ WIDTH, h=self.size*4+HEIGHT}
    
    return self
end
Bullet:makeInit(init)

local function update(self, dt)
    self.x, self.y = self.triangle:center()
    if self.x < -self.outerLimit.b or self.x > self.outerLimit.w  or
        self.y < -self.outerLimit.b or self.y > self.outerLimit.h then
        return IM_DEAD
    end
    --self.x = self.x + self.xDir * dt
    --self.y = self.y + self.yDir * dt
    
    self.triangle:move (self.xDir * dt, self.yDir * dt)
    return IM_ALIVE
end
Bullet.update = Bullet:makeMethod(update)

local function getCollidingShape(self)
    return self.triangle
end
Bullet.getCollidingShape = Bullet:makeMethod (getCollidingShape)

local function draw (self)
    love.graphics.setColor (self.color[1], self.color[2], self.color[3])
    --love.graphics.draw (self.triangle, self.x, self.y, self.angle)
    self.triangle:draw('fill')
end
Bullet.draw = Bullet:makeMethod (draw)

return Bullet