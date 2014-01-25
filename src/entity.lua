--an entity is drawable and updatable
local class = require "src.class"
local Vector2 = require "src.vector2"

local Entity = class:makeSubclass("Entity")

local function init(class, self, typeName, x, y)
    class.super:initWith(self)
    
    self.typeName = typeName
    x, y = x or 0, y or 0
    self.pos = Vector2:init(x,y)
    
    return self
end
Entity:makeInit(init)


local function typeName(self)
    return self.typeName
end
Entity.typeName = Entity:makeMethod(typeName)


local function typeOf(self, typeString)
    return self.typeName == typeString
end
Entity.typeOf = Entity:makeMethod(typeOf)


local function draw(self)
    local p = self.pos
    love.graphics.circle("fill", 0,0, 300,100)
end
Entity.draw = Entity:makeMethod(draw)

local function update (self, dt)
        --override me
end
Entity.update = Entity:makeMethod (update)


return Entity
