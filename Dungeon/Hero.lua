local luaclass = {}

--[[
    Class description
]]
function luaclass:new( _p, argTable )
    _p = _p or {}
    setmetatable( _p, self )
    
    self.__index = self

    return _p
end 

--[[ dummyMethod
        lorum ipsum
        
        @arg1 - arg1 description
        @arg2 - arg2 description
        
        @return - description of the returned data if any.
        ]]
function luaclass:dummyMethod( arg1, arg2 )
    
end

-- Return the created class template
return luaclass
