module(..., package.seeall )

local Point2D = {}

--[[
    Class description
]]
function Point2D:new( _p, argTable )
    _p = _p or {}
    setmetatable( _p, self )
    
    self.__index = self

    _p.x = argTable.x or 0
    _p.y = argTable.y or 0
    
    return _p
end 

--[[ dummyMethod
        lorum ipsum
        
        @arg1 - arg1 description
        @arg2 - arg2 description
        
        @return - description of the returned data if any.
        ]]
function Point2D:dummyMethod( arg1, arg2 )
    
end

-- Return the created class template
return Point2D