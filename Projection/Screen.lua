module(..., package.seeall )

local point2D = require("Projection.Point2D")

local Screen = {}

--[[
    Class description
]]
function Screen:new( _p, argTable )
    _p = _p or {}
    setmetatable( _p, self )
    self.__index = self

    _p.center = point2D:new( nil, { display.contentCenterX, display.contentCenterY } )
    _p.size = point2D:new( nil, { display.contentWidth, display.contentHeight } )

    return _p
end 

--[[ dummyMethod
        lorum ipsum
        
        @arg1 - arg1 description
        @arg2 - arg2 description
        
        @return - description of the returned data if any.
        ]]
function Screen:dummyMethod( arg1, arg2 )
    
end

-- Return the created class template
return Screen
