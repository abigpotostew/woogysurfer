-- main box dude

local entity = require('src.entity')
local Woogy = entity:makeSubclass("Woogy")

local Util = require 'src.util'

local polygonMaster = require 'src.polygonmaster'

--woogy components:
--local woogyPhysics = require 'src.woogy.physics'




local function init(class, self, physworld, w, h)
    class.super:initWith(self)
    assert(physworld, 'a woogy needs a world. and a pizza.')
    
    --Regarding the rotating box
    w, h = w or 100,  h or 100
    self.w = w
    self.h = h
    --self.physics = woogyPhysics.buildWoogyBody (physworld, w, h)
    self.hw = w/2
    self.hh = h/2
    
    
    --self.canvas_main, self.canvas_tmp = makeWoogyCanvas (w, h)
    
    
    
    self.keyspressed = {}
    
    self.bullets = {}
    self.bullets.up = polygonMaster.createTriangle()
    self.bullets.left = polygonMaster.createTriangle()
    self.bullets.down = polygonMaster.createTriangle()
    self.bullets.right = polygonMaster.createTriangle()
    
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
    love.graphics.setColor(255, 255, 255)
    
    local cx, cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.push()
    love.graphics.translate ( cy, cy )
        love.graphics.rotate ( Util.vecToAngle(  love.mouse.getX() - cx, love.mouse.getY() - cy ) ) --offset to get corner at mouse pt.
    
        --INNER WHITE SQUARE
         love.graphics.push()
            love.graphics.translate (  -polygonMaster.specialL*self.w, -polygonMaster.specialL*self.h )
            love.graphics.rectangle ('fill',0, 0, polygonMaster.specialL*2*self.w, polygonMaster.specialL*2*self.h)
        love.graphics.pop()
        
        love.graphics.push()
            
            love.graphics.setColor(255,34,212) --PINK
            love.graphics.draw( self.bullets.up, 0, 0,  0, self.w, self.h)
         
            love.graphics.rotate ( -HALF_PI )
            love.graphics.setColor (23,110,240) -- BLUE
            love.graphics.draw( self.bullets.left, 0, 0,  0, self.w, self.h  )
    
            love.graphics.rotate ( -HALF_PI )
            love.graphics.setColor(0,153,0) --green
            love.graphics.draw( self.bullets.down, 0, 0,  0, self.w, self.h )
    
            love.graphics.rotate ( -HALF_PI )
            love.graphics.setColor(127,0,255) --purps
            love.graphics.draw( self.bullets.right, 0, 0,  0, self.w, self.h)
        love.graphics.pop()
    love.graphics.pop()
end
Woogy.draw = Woogy:makeMethod(draw)

local function handleInput (inputType, params)
    
end
Woogy.handleInput = Woogy:makeMethod (handleInput)


local function update (self, dt)
    --self.physics:update( keyspressed ) --delegate physics to the physics component
    --rotate to point towards mouse.
    
    local size = self.w + dt*0
    self.w = size
    self.h = size
    self.hw = size/2
    self.hh = self.hw
end
Woogy.update = Woogy:makeMethod (update)



return Woogy
