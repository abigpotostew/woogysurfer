-- main box dude

local entity = require('src.entity')
local Woogy = entity:makeSubclass("Woogy")

local Util = require 'src.util'

local polygonMaster = require 'src.polygonmaster'
local PM = polygonMaster

--CHANGE keys for input if needed here ----------
local keyMap = {}
keyMap.up = 'w'
keyMap.left = 'a'
keyMap.down = 's'
keyMap.right = 'd'

local angleOffset = {}
angleOffset.up = 0
angleOffset.left = -HALF_PI
angleOffset.down = -PI
angleOffset.right = -3*HALF_PI

local function init(class, self, level, w, h)
    class.super:initWith(self)
    assert(level, 'a woogy needs a level. and a pizza.')
    
    self.level = level
    
    --Regarding the rotating box
    w, h = w or 100,  h or 100
    self.w = w
    self.h = h
    self.hw = w/2
    self.hh = h/2
    
    self.angle = 0
    
    --self.canvas_main, self.canvas_tmp = makeWoogyCanvas (w, h)
    self.inputMap =  {}
    self.inputMap[keyMap.up] = 'up'
    self.inputMap[keyMap.left] =  'left'
    self.inputMap[keyMap.down] = 'down'
    self.inputMap[keyMap.right] = 'right'
 
     self.colorMap = { up = {255,34,212}, --pink
                                        left = {23,110,240}, --blue
                                        down = {0,153,0}, --GREEN
                                        right = {127,0,255} } --purps
    
    self.bullets = {}
    self.bullets.up = polygonMaster.createCornerTriangle()
    self.bullets.left = polygonMaster.createCornerTriangle()
    self.bullets.down = polygonMaster.createCornerTriangle()
    self.bullets.right = polygonMaster.createCornerTriangle()
    
    self.bulletSeq = {'up', 'left', 'down', 'right'}
    
    self.remainingBullets = 4
    
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
    
    love.graphics.push()
    love.graphics.translate ( HWIDTH, HHEIGHT )
        love.graphics.rotate ( self.angle ) --offset to get corner at mouse pt.
    
        --INNER WHITE SQUARE
         love.graphics.push()
            love.graphics.translate (  -polygonMaster.specialL*self.w, -polygonMaster.specialL*self.h )
            love.graphics.rectangle ('fill',0, 0, polygonMaster.specialL*2*self.w, polygonMaster.specialL*2*self.h)
        love.graphics.pop()
        
        love.graphics.push()
            
            --DRAW THE BODY BULLETS
            for i, bulletKey in ipairs(self.bulletSeq) do
                if self.bullets[bulletKey] then
                    love.graphics.setColor (self.colorMap[bulletKey][1],  --r
                                                                     self.colorMap[bulletKey][2],  --g
                                                                     self.colorMap[bulletKey][3] ) --b
                    love.graphics.draw (self.bullets[bulletKey], 0, 0, 0, self.w, self.h)
                end
                love.graphics.rotate ( -HALF_PI )
            end
            
        love.graphics.pop()
    love.graphics.pop()
end
Woogy.draw = Woogy:makeMethod(draw)



local function handleInput (self, inputType, params)
    if inputType == 'keypressed' then
        local k = params.key
        local bulletParams = nil
        
        --If user is pressing a key used for bullets
        local direction = self.inputMap[k]
        if direction then
            if self.bullets[direction] then
                bulletParams={ a = angleOffset[direction], color = self.colorMap[direction] }
            end
        end
        if bulletParams then
            --self.level:spawnBullet(
            --spawn a bullet
            --self.remainingBullets
            -- if not more bullets, re-up the bullets.
        end
    end
end
Woogy.handleInput = Woogy:makeMethod (handleInput)


local function update (self, dt)
    --self.physics:update( keyspressed ) --delegate physics to the physics component
    --rotate to point towards mouse.
    self.angle = Util.vecToAngle(  love.mouse.getX() - HWIDTH, love.mouse.getY() - HHEIGHT )
    
    -- grow it!
    local size = self.w + dt*10
    self.w = size
    self.h = size
    self.hw = size/2
    self.hh = self.hw
end
Woogy.update = Woogy:makeMethod (update)



return Woogy
