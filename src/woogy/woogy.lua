-- main box dude

local entity = require('src.entity')

local Woogy = entity:makeSubclass("Woogy")

--woogy components:
local woogyPhysics = require 'src.woogy.physics'

local function makeWoogyCanvas (w, h)
    local canvas_main = love.graphics.newCanvas ( w, h )
    canvas_main:clear (255,0,0)
    canvas_main:renderTo(function() love.graphics.rectangle('fill',0,0,w,h) end )
    local canvas_tmp = love.graphics.newCanvas( w, h )
    canvas_tmp:clear(0,255,0)
    return canvas_main, canvas_tmp
end

local function init(class, self, physworld, w, h)
    class.super:initWith(self)
    assert(physworld, 'a woogy needs a world. and a pizza.')
    
    w, h = w or 200,  h or 200
    self.w = w
    self.h = h
    self.physics = woogyPhysics.buildWoogyBody (physworld, w, h)
    
    self.canvas_main, self.canvas_tmp = makeWoogyCanvas (w, h)
    
    self.keyspressed = {}
    
    return self
end
Woogy:makeInit(init)




local function shrink(self)
    --draw the 4 traingles in the corner of temp
    self.canvas_tmp:renderTo( function()
         love.graphics.draw(self.canvas_main,  0, 0,  math.pi/2,  1, 1,  self.w/2, self.h/2)
     end )
    local tmp = self.canvas_main
    self.canvas_main = self.canvas_tmp
    self.canvas_tmp = tmp
end
Woogy.shrink = Woogy:makeMethod(shrink)

local function draw (self)
    --love.graphics.draw(self.canvas_main)
    --love.graphics.draw(self.canvas_tmp, self.w)
    love.graphics.setColor(12, 86, 123)
    love.graphics.polygon("fill", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
end
Woogy.draw = Woogy:makeMethod(draw)

local function handleInput (self, keyspressed)
    self.keyspressed = keyspressed
end
Woogy.handleInput = Woogy:makeMethod (handleInput)


local function update (self, dt, keyspressed)
    self.physics:update( keyspressed ) --delegate physics to the physics component
end
Woogy.update = Woogy:makeMethod (update)



return Woogy
