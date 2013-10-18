local levelIcon = {}

function levelIcon:new( _p, info )
    _p = _p or {}
    setmetatable( _p, self )
    
    self.__index = self
    
    _p.icon = display.newGroup()
    
    _p.backgroundImage = display.newSprite( info.imageSheet, {frames = { info.data:getFrameIndex( "background")}} )
    _p.iconImage = display.newSprite( info.imageSheet, {frames = { info.data:getFrameIndex( "background")}} )
  
    _p.icon:insert( _p.backgroundImage )
    _p.icon:insert( _p.iconImage )
   -- _p.icon:insert( _p.labelText )
    
    _p.level = display.newContainer( info.width, info.height )
    _p.level.anchorChildren = true
    
    _p.level:insert( _p.icon )

    return _p
end 

--[[ setbackground
        Set the background image for this level selector. If the background is already set then
        we delete the current one and replace it with the new one.
        
        @image image name of this background
        @width width of the image
        @height height of the icon
        ]]
function levelIcon:setBackground( image, width, height )
    
    -- Remove the current background image and delete it but, we also need to remove all
    -- of the other icon elements to preserve ordering.
    if self.backgroundImage ~= nil then
        self.icon:remove( self.iconImage )
        self.icon:remove( self.backgroundImage )
        self.icon:remove( self.labelText )
        
        self.backgroundImage = nil;
    end
    
    -- Set the new image
    self.backgroundImage = display.newImage( "Images/" .. image )

    -- Recreate the icon with the new image background
    self.icon:insert( self.background ) 
    self.icon:insert( self.iconImage )
    self.icon:insert( self.labelText )
end

--[[
       SetIcon
       Set the icon that will sit over the background. This is a sprite that can be animated or simply contain
       an over, down and up frame.
       
       @iconsprite the sprite used for the icon animated title
       @width sprite width
       @height sprite height
       @xOffset offset of sprite from the left of the level icon
       @yOffset offset of sprite from the top of the level icon
]]
function levelIcon:setIcon( iconSprite, width, height, xOffset, yOffset )
    if self.iconImage ~= nil then
        self.icon:remove( self.iconImage )
        self.iconImage = nil
    end
    
    self.iconImage = iconSprite
    self.icon:insert( self.iconImage )
end

return levelIcon
