--woogy physics!!

local physics = {}

physics.mt = {}
physics.prototype = {}
physics.mt.__index  = physics.prototype

local accelleration = 1.0
local maxVel = { x= 69.0, y = 61.0 }
local friction = 1.00

function physics.buildWoogyBody (world, w, h)
    local woogyPhysics = {}
    setmetatable(woogyPhysics, physics.mt)
    woogyPhysics.body = love.physics.newBody (world, 0, 0, "kinematic")
    woogyPhysics.shape = love.physics.newRectangleShape (0, 0, w, h)
    woogyPhysics.fixture = love.physics.newFixture (woogyPhysics.body, woogyPhysics.shape, 2) -- A higher density gives it more mass.
    return woogyPhysics
end

function physics.prototype.update (self, keyspressed)
    if keyspressed['up'] then
        self:moveUp(  )
    end
    if keyspressed['down'] then
        self:moveDown(  )
    end
    if keyspressed['left'] then
        self:moveLeft(  )
    end
    if keyspressed['right'] then
        self:moveRight(  )
    end
    
    --apply drag
    local vx, vy = self.body:getLinearVelocity()
    vx = vx*friction
    vy = vy*friction
    self.body:setLinearVelocity (vx, vy)
end

--called by 4 input functions below
local function doLinearMovement ( body, vx, vy )
    body:setLinearVelocity (vx, vy)
end

function physics.prototype.moveUp ( self  )
    local vx, vy = self.body:getLinearVelocity()
    if vy > -maxVel.y then --if not at max speed
         doLinearMovement( self.body, vx, vy-accelleration ) 
     end
end

function physics.prototype.moveDown ( self )
    local vx, vy = self.body:getLinearVelocity()
    if vy < maxVel.y then --if not at max speed
         doLinearMovement( self.body, vx, vy+accelleration ) 
     end
end

function physics.prototype.moveLeft ( self )
    local vx, vy = self.body:getLinearVelocity()
    if vx > -maxVel.x then --if not at max speed
         doLinearMovement( self.body, vx-accelleration, vy ) 
     end
end

function physics.prototype.moveRight ( self )
    local vx, vy = self.body:getLinearVelocity()
    if vx < maxVel.x then --if not at max speed
         doLinearMovement( self.body, vx+accelleration, vy ) 
     end
end



return physics