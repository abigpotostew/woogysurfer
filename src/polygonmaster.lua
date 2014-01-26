-- woogy polygon master
-- generates meshes

local pmaster = {}

local  specialL = .353553391 --length from center of unit square to a vertice
-- a unit square has sides length = 1 and center at origin.
pmaster.specialL = specialL

function pmaster.createTriangle ( verts, img  )
    verts = verts or { { specialL,  - specialL,  0, 0 },
                                      { specialL, specialL, 0, 1 },
                                      { specialL*2, 0, 1, 0 } }
    return love.graphics.newMesh (verts, img, 'fan')
end

function pmaster.createTriangleA (  )
    return pmaster.createTriangle({ { -0.5, -0.5,  0, 0 },
                                                                       { -0.5, 0, 0, 1 },
                                                                       { 0, -0.5, 1, 0 } } )
end

function pmaster.createTriangleB (  )
    return pmaster.createTriangle ({ { 0.5, -0.5,  0, 0 },
                                                                       { 0, -0.5, 0, 1 },
                                                                       { 0.5, 0, 1, 0 } } )
end

function pmaster.createTriangleC (  )
    return pmaster.createTriangle ({ { 0.5, 0.5,  0, 0 },
                                                                       { 0.5, 0, 0, 1 },
                                                                       { 0, 0.5, 1, 0 } } )
end

function pmaster.createTriangleD (  )
    return pmaster.createTriangle ({ { -0.5, 0.5,  0, 0 },
                                                                       { 0, 0.5, 0, 1 },
                                                                       { -0.5, 0, 1, 0 } } )
end

return pmaster