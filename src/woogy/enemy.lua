-- main box dude

local entity = require('src.entity')

local Enemy = entity:makeSubclass("Enemy")

--woogy components:
local woogyPhysics = require 'src.woogy.physics'

local function makeEnemyCanvas (w, h, x, y)
    local canvas_main = love.graphics.newCanvas ( w, h )
    canvas_main:clear (255,0,0)
    canvas_main:renderTo(function() love.graphics.rectangle('fill',x,y,w,h) end )
    local canvas_tmp = love.graphics.newCanvas( w, h )
    canvas_tmp:clear(0,255,0)
    return canvas_main, canvas_tmp
end

local function init(class, self, physworld, w, h, x, y)
    class.super:initWith(self)
    assert(physworld, 'a woogy needs a world. and a pizza.')
    
    self.x = x
    self.y = y
    
    w, h = w or 50,  h or 50
    self.w = w
    self.h = h
    
    self.elapsed = 0
    
    self.physics = woogyPhysics.buildEnemyBody (physworld, w, h)
    
    self.canvas_main, self.canvas_tmp = makeEnemyCanvas (w, h, x, y)
    
    self.keyspressed = {}
    
    return self
end
Enemy:makeInit(init)




--local function shrink(self)
--    --draw the 4 traingles in the corner of temp
--    self.canvas_tmp:renderTo( function()
--         love.graphics.draw(self.canvas_main,  0, 0,  math.pi/2,  1, 1,  self.w/2, self.h/2)
--     end )
--    local tmp = self.canvas_main
--    self.canvas_main = self.canvas_tmp
--    self.canvas_tmp = tmp
--end
--Enemy.shrink = Enemy:makeMethod(shrink)

local function draw (self)
    --love.graphics.draw(self.canvas_main)
    --love.graphics.draw(self.canvas_tmp, self.w)
    love.graphics.setColor(55, 86, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end
Enemy.draw = Enemy:makeMethod(draw)

local function handleInput (self, keyspressed)
    self.keyspressed = keyspressed
end
Enemy.handleInput = Enemy:makeMethod (handleInput)


local function update (self, dt)
  self.elapsed = dt + self.elapsed
  self.x = self.x + dt
end
Enemy.update = Enemy:makeMethod (update)



return Enemy
