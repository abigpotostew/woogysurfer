-- enemy woah woah baby

local entity = require('src.entity')

local Enemy = entity:makeSubclass("Enemy")
local function init(class, self, x, y, xDir, yDir)
    class.super:initWith(self)
    self.x = x
    self.y = y
    self.xDir = xDir
    self.yDir = yDir
    return self
end
Enemy:makeInit(init)


local function draw (self)
    love.graphics.setColor(55, 86, 0)
    love.graphics.rectangle("fill", self.x, self.y, 70, 70)
end
Enemy.draw = Enemy:makeMethod(draw)


local function update (self, dt)
   self.x = self.x + self.xDir*5
   self.y = self.y + self.yDir*5
end
Enemy.update = Enemy:makeMethod (update)


return Enemy
