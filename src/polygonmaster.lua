-- woogy polygon master
-- generates meshes

local pmaster = {}

local  specialL = math.sqrt(.125) --.353553391 --length from center of unit square to a vertice, also 2(a^2)=0.5^2
-- a unit square has sides length = 1 and center at origin.
pmaster.specialL = specialL

function pmaster.createCornerTriangle ( verts, img  )
    verts = verts or { { specialL,  - specialL,  0, 0 },
                                      { specialL, specialL, 0, 1 },
                                      { specialL*2, 0, 1, 0 } }
    return love.graphics.newMesh (verts, img, 'fan')
end

function pmaster.createBulletTriangle ( scale, img  )
    scale = scale or 1.0
    local verts = { { 0,  - specialL*scale,  0, 0 },
                                 { 0, specialL*scale, 0, 1 },
                                 { specialL*scale, 0, 1, 0 } }
    return love.graphics.newMesh (verts, img, 'fan')
end

return pmaster