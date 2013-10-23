local storyboard = require("storyboard")
local physics = require "physics"
local widget = require( "widget" )
local levelicon = require("LevelIcon")
local levelSprites = require("levelSprites")

local levels = graphics.newImageSheet( "levelSprites.png", levelSprites:getSheet() )
local scene = storyboard.newScene()

audio.setVolume( 0.5, { channel = 1 } ) -- Sound Effects Channel Volume
audio.setVolume( 0.8, { channel = 2 } ) -- Sound Track Channel Volume

physics.start()
physics.setGravity( 0, 0 )

local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local scrollView
-- input controller commands and listeners
local inputDevices = system.getInputDevices()
local controllers = {}

-- local forward references should go here --


---------------------------------------------------------------------------------
-- BEGINNING OF IMPLEMENTATION
---------------------------------------------------------------------------------

function onKeyEvent( event )
    
end

function onInputdeviceStatusChanged( event )
    
end

function selected( event )
    if event.phase == "began" then
        print( event.target.name )
    elseif  event.phase == "moved" then
        local dy = math.abs( ( event.y - event.yStart ) )

        -- If our finger has moved more than the desired range
        if dy > 5 then
            -- Pass the focus back to the scrollView
            scrollView:takeFocus( event )
        end
    elseif event.phase == "ended" then
        
    end
    
    return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    
    -- 1. Create rendering layers (group)
    group.background = display.newGroup()
    group.levels = display.newGroup()
    group.controls = display.newGroup()
    
    -- Add rendering layers to diplay
    group:insert( group.background )
    group:insert( group.levels )
    group:insert( group.controls )
    
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
    
    -- Setup the main display components
    --local background = display.newImage( "Images/menuBackground" )
    scrollView =    widget.newScrollView
                                 {
                                    top = 100,
                                    left = 10,
                                    width = 320,
                                    height = 480,
                                    scrollWidth = 2000,
                                    scrollHeight = 400,
                                    hideBackground = true,
                                    listener = scrollListener,
                                }
                                
    for i = 1, 10 do
        local level1 = levelicon:new( nil, { 
                                    name = "", 
                                    imageSheet = levels, 
                                    data = levelSprites, 
                                    width = 200, 
                                    height = 220, 
                                    name = "area" .. i, 
                                    active = false, 
                                    onSelect = selected } )
        level1.level.x = 210 * ( i - 1 )
        level1.level.y = 0;
        scrollView:insert( level1.level )
    end
    

    group:insert( scrollView )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view
    
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




