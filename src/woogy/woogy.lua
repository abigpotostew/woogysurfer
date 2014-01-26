-- main box dude

local entity = require('src.entity')
local Woogy = entity:makeSubclass("Woogy")

local Util = require 'src.util'
local Vec2 = require 'src.vector2'

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

local function init(class, self, level, collider, w, h)
    class.super:initWith(self)
    assert(level, 'a woogy needs a level. and a pizza.')
    
    self.level = level
    self.collider = collider
    
    --Regarding the rotating box
    w, h = w or 100,  h or 100
    self:setSize (w)
    
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
    
    self.bulletSeq = {'up', 'left', 'down', 'right'}
    
    self.bullets = {}
    self:resetCornerBullets(self.w)
    
    
    self.remainingBullets = 4
    
  shootSoundFileName = love.sound.newSoundData("shoot.wav")
  shootSoundSource = love.audio.newSource(shootSoundFileName)
  shootSoundSource:setVolume(2.0)
    
    return self
end
Woogy:makeInit(init)

local function setSize(self, size)
    self.w = size
    self.h = size
    self.hw = size/2
    self.hh = size/2
end
Woogy.setSize = Woogy:makeMethod(setSize)

local function buildCornerPolygon(self, direction)
    local corner = self.collider:addPolygon (polygonMaster.getCornerVerts())
    corner.id = direction
    return corner
end
 Woogy.buildCornerPolygon = Woogy:makeMethod(buildCornerPolygon)

--Do this after changing size of square
local function alignCornerBullets(self)
    local w, h = self.w*PM.specialL, self.h*PM.specialL
    for i, dir in ipairs(self.bulletSeq) do
        if self.bullets[dir] then
            self.collider:remove (self.bullets[dir])
            self.bullets[dir] = nil
            self.bullets[dir] = self:buildCornerPolygon(dir)
            local b = self.bullets[dir]
            local a = self.angle +angleOffset[dir]
            local c, s = math.cos(a), math.sin(a)
            b:scale (self.w)
            b:moveTo (HWIDTH + w*(PM.specialL*4) , HHEIGHT)--local c, s = math.cos(a), math.sin(a)
            b:setRotation (a, HWIDTH, HHEIGHT)
        end
    end
end
 Woogy.alignCornerBullets = Woogy:makeMethod(alignCornerBullets)


-- prerequisite: all bullets are nil
local function resetCornerBullets(self)
    
    for i, direction in ipairs(self.bulletSeq) do
        self.bullets[direction] = self:buildCornerPolygon(direction)
        self.bullets[direction]:scale (self.w)
    end
    
    local size = self.w
    size = size * PM.specialL * 2
    self:setSize (size)
    self.remainingBullets = 4
 end
 Woogy.resetCornerBullets = Woogy:makeMethod(resetCornerBullets)
 
 local function removeCornerBullet(self, dir)
     if self.bullets[dir] then
         self.collider:remove (self.bullets[dir])
         self.bullets[dir] = nil
         self.remainingBullets = self.remainingBullets - 1
            -- if no more bullets, re-up the bullets.
            if self.remainingBullets == 0 then
                self:resetCornerBullets()
            end
     end
 end
Woogy.removeCornerBullet = Woogy:makeMethod (removeCornerBullet)

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
        love.graphics.pop()
       --love.graphics.pop()
            
            --DRAW THE BODY BULLETS
            for i, bulletKey in ipairs(self.bulletSeq) do
                if self.bullets[bulletKey] then
                    love.graphics.setColor (self.colorMap[bulletKey][1],  --r
                                                                     self.colorMap[bulletKey][2],  --g
                                                                     self.colorMap[bulletKey][3] ) --b
                    --love.graphics.draw (self.bullets[bulletKey], 0, 0, 0, self.w, self.h)
                    self.bullets[bulletKey]:draw('fill')
                end
                --love.graphics.rotate ( -HALF_PI )
            end
            
        --love.graphics.pop()
    
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
                bulletParams={ a = angleOffset[direction] + self.angle, color = self.colorMap[direction] }
            end
        end
        if bulletParams then
            --SHOOT
            self:removeCornerBullet (direction)
            
            local xdir = math.cos(bulletParams.a)
            local ydir = math.sin(bulletParams.a)
            local x, y = PM.specialL*xdir * self.w*1.5 + HWIDTH,  PM.specialL* ydir  * self.h * 1.5 + HHEIGHT
            self.level:spawnBullet ( x, y, xdir, ydir, bulletParams.a, self.w, bulletParams.color)
            
            shootSoundSource:stop()
            shootSoundSource:play()
            
        end
    end
end
Woogy.handleInput = Woogy:makeMethod (handleInput)


local function update (self, dt)
    --self.physics:update( keyspressed ) --delegate physics to the physics component
    --rotate to point towards mouse.
    self.angle = Util.vecToAngle(  love.mouse.getX() - HWIDTH, love.mouse.getY() - HHEIGHT )
    
    -- grow it!
    local size = self.w + dt*15
    self.prevSize = self.w
    --local scale = (size - prevSize)/prevSize+1
    self:setSize(size)
    self:alignCornerBullets()
    --[[for i, bulletKey in ipairs(self.bulletSeq) do
        local b = self.bullets[bulletKey]
        if b then
            b:moveTo(0,0)
            --b.setRotation(0)
            local a = self.angle +angleOffset[bulletKey]
            local c, s = math.cos(a), math.sin(a)
            b:setRotation (a, -prevSize/2, 0)
            b:scale(scale)
            b:moveTo (HWIDTH + c*self.w*PM.specialL, HHEIGHT + s*self.h*PM.specialL)
         end
     end--]]
    
end
Woogy.update = Woogy:makeMethod (update)



return Woogy
