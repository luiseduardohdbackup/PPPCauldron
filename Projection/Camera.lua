module(..., package.seeall )

local point3D = require("Projection.Point3D")

local Camera = {}

--[[
    Class description
]]
function Camera:new( _p, argTable )
    _p = _p or {}
    setmetatable( _p, self )
    self.__index = self
    
    _p.to           = point3D.new( nil, {x=0, y=50, z=0} )
    _p.from      = point3D.new( nil, { x = 0, y = -50, z = 0 } )
    _p.up          = point3D.new( nil, { x = 0, y = 0, z = 1} )
    _p.angleh = 45.0
    _p.anglev = 45.0
    _p.zoom = 1.0
    _p.front = 1.0
    _p.back = 200.0
    _p.projection = 0
    
    return _p
end 

--[[ dummyMethod
        lorum ipsum
        
        @arg1 - arg1 description
        @arg2 - arg2 description
        
        @return - description of the returned data if any.
        ]]
function Camera:dummyMethod( arg1, arg2 )
    
end

-- Return the created class template
return Camera
