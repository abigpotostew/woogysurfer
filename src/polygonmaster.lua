-- woogy polygon master
-- generates meshes

local pmaster = {}

local  specialL = math.sqrt(.125) --.353553391 --length from center of unit square to a vertice, also 2(a^2)=0.5^2
-- a unit square has sides length = 1 and center at origin.
pmaster.specialL = specialL

--[[function pmaster.createCornerTriangle ( verts, img  )
    verts = verts or { { specialL,  - specialL,  0, 0 },
                                      { specialL, specialL, 0, 1 },
                                      { specialL*2, 0, 1, 0 } }
    return love.graphics.newMesh (verts, img, 'fan')
end--]]

function pmaster.getCornerVerts( scale )
    scale = scale or 1.0
        return  specialL*scale,  - specialL*scale,
                        specialL*scale, specialL*scale,
                       specialL*2*scale, 0
end

--[[function pmaster.createBulletTriangle ( scale, img  )
    scale = scale or 1.0
    local verts = { { 0,  - specialL*scale,  0, 0 },
                                 { 0, specialL*scale, 0, 1 },
                                 { specialL*scale, 0, 1, 0 } }
    return love.graphics.newMesh (verts, img, 'fan')
end]]--

function pmaster.getBulletVerts (scale)
    scale = scale or 1.0
    return 0,  - specialL*scale,
                  0, specialL*scale ,
                 specialL*scale, 0 
end


--[[function pmaster.createEnemyTriangle (scale)
    scale = scale or 50
    verts = verts or { { scale,  -scale,  0, 0 },
                                      { scale, scale, 0, 1 },
                                      { 2*scale, 0, 1, 0 } }
    return love.graphics.newMesh (verts,img,'fan')
end--]]

function pmaster.createEnemyTriangleVerts (scale)
    scale = scale or 1.0
    return scale,  -scale, 
                  scale, scale, 
                  2*scale, 0
end

return pmaster