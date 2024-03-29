local storyboard = require("storyboard")
local physics = require "physics"
local widget = require("widget")

local levelSprites = require("levelSprites")
local scene = storyboard.newScene()

local point3D = require("Projection.Point3D")
local projection = require("Projection.Projection")

-- file locations
local Images = "Images/"
local sounds = "Audio/"

audio.setVolume( 0.5, { channel = 1 } ) -- Sound Effects Channel Volume
audio.setVolume( 0.8, { channel = 2 } ) -- Sound Track Channel Volume

local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- input controller commands and listeners
local inputDevices = system.getInputDevices()
local controllers = {}

-- graphics and buttons
local title
local spriteSheet 

local playButton
local exitButton
local infoButton

-- local forward references should go here --
local enableUI
---------------------------------------------------------------------------------
-- BEGINNING OF IMPLEMENTATION
---------------------------------------------------------------------------------

function onKeyEvent( event )
    
end

function onInputdeviceStatusChanged( event )
    
end

function enableUI( event )
    playButton:addEventListener("touch", playPressed )
    infoButton:addEventListener("touch", infoPressed )
    exitButton:addEventListener("touch", exitPressed )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    
end

-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
    local group = self.view
    
    -- check which devices we have (if any)
    for deviceIndex = 1, #inputDevices do
        print( deviceIndex, "canVibrate", inputDevices[deviceIndex].canVibrate )
        print( deviceIndex, "connectionState", inputDevices[deviceIndex].connectionState )
        print( deviceIndex, "descriptor", inputDevices[deviceIndex].descriptor )
        print( deviceIndex, "displayName", inputDevices[deviceIndex].displayName )
        print( deviceIndex, "isConnected", inputDevices[deviceIndex].isConnected )
        print( deviceIndex, "type", inputDevices[deviceIndex].type )
        print( deviceIndex, "permenantid", tostring(inputDevices[deviceIndex].permanentId) )
        print( deviceIndex, "andoridDeviceid", inputDevices[deviceIndex].androidDeviceId ) 
        
        if inputDevices[deviceIndex].descriptor == "Joystick 1" then
            controllers[1] = inputDevices[deviceIndex]
        elseif inputDevices[deviceIndex].descriptor == "Joystick 2" then
            controllers[2] = inputDevices[deviceIndex]
        elseif inputDevices[deviceIndex].descriptor == "Joystick 3" then
            controllers[3] = inputDevices[deviceIndex]
        elseif inputDevices[deviceIndex].descriptor == "Joystick 4" then
            controllers[4] = inputDevices[deviceIndex]
        end    
    end
    
    spriteSheet = graphics.newImageSheet( "levelSprites.png", levelSprites:getSheet() )

    local proj = projection:new()
    
    local w1 = point3D:new( nil, { x = 100, y = 100, z = 5 } )
    local w2 = point3D:new( nil, { x = 100, y = 100, z = 4 } )
    
    print( "W1 is " .. w1.x .. " " .. w1.y .. " " .. w1.z ) 
    proj:Trans_Line(w1, w2)
    print( "W1 is now " .. w1.x .. " " .. w1.y .. " " .. w1.z )
    
    print( "W1 is " .. w1.x .. " " .. w1.y .. " " .. w1.z ) 
    proj:Trans_Line(w1, w2)
    print( "W1 is now " .. w1.x .. " " .. w1.y .. " " .. w1.z )
    
    print( "W1 is " .. w1.x .. " " .. w1.y .. " " .. w1.z ) 
    proj:Trans_Line(w1, w2)
    print( "W1 is now " .. w1.x .. " " .. w1.y .. " " .. w1.z )
    
    print( "W1 is " .. w1.x .. " " .. w1.y .. " " .. w1.z ) 
    proj:Trans_Line(w1, w2)
    print( "W1 is now " .. w1.x .. " " .. w1.y .. " " .. w1.z )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
    --transition.to(title, { time = 1000, y = 300, onComplete = enableUI })
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    
end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
    local group = self.view
    
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    
end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
    local group = self.view
    local overlay_name = event.sceneName  -- name of the overlay scene
    
end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
    local group = self.view
    local overlay_name = event.sceneName  -- name of the overlay scene
    
end

---------------------------------------------------------------------------------
-- END OF IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "inputDevicestatus", onInputdeviceStatusChanged )

return scene
