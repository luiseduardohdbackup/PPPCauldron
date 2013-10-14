local levelSprites = require("levelSprites")

local levelIcon = {}
local levels = graphics.newImageSheet( "levelSprites.png", sheetInfo:getSheet() )

function levelIcon:new( _p, imageName )
    _p = _p or {}
    setmetatable( _p, self )
    
    self.__index = self
    
    _p.background = display.newGroup()
    _p.icon = display.newGroup()
    _p.label = display.newGroup()
    
    _p.backgroundImage = display.newSprite( level, {frames = { level:getFrameIndex( imageName.."background")}} )    
    _p.iconImage = display.newSprite( level, {frames = { level:getFrameIndex( imageName.."Animation")}} )
  
    _p.background:insert( _p.backgroundImage )
    _p.icon:insert( _p.iconImage )
    _p.label:insert( _p.labelText )
    
    _p.level = display.newGroup( )
    
    _p.level:insert( _p.background )
    _p.level:insert( _p.icon )
    _p.level:insert( _p.label )
    
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
    
    if self.backgroundImage ~= nil then
        self.background:remove( self.backgroundImage )
        self.backgroundImage = nil;
    end
    
   self.backgroundImage = display.newImage( "Images/" .. image )

    self.background:insert( self.background ) 
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
