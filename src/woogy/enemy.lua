-- enemy

local entity = require('src.entity')

local Enemy = entity:makeSubclass("Enemy")
local w = 100
local h = 100

-- TODO: Get init to intialize the enemy according to pos. 
-- TODO: Where should the pos info be stored?
-- TODO: You don't need to pass it width and height.
-- TODO: Draw a cooler enemy. Random colors?

local function init(class, self, position, direction)
    class.super:initWith(self)
   
    -- defining the initial position according to pos:
    self.x = 50
    self.y = 50
    self.h = h
    self.w = w

--    if pos == 1 then
--      x = 300 --love.graphics.getHeight()/2
--      y = 300 --love.graphics.getWidth()/2
--    end
    
    return self
end
Enemy:makeInit(init)



local function draw (self)
    --love.graphics.draw(self.canvas_main)
    --love.graphics.draw(self.canvas_tmp, self.w)
    love.graphics.setColor(55, 86, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end
Enemy.draw = Enemy:makeMethod(draw)

local function update (self, dt)
  self.y = self.y + 5
end

Enemy.update = Enemy:makeMethod (update)

return Enemy
