--io.output():setvbuf("no")
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require("storyboard")
local options =
{
    effect = "crossFade",
    time = 800,
    params = { var1 = "custom", myVar = "another" }
}

introComplete = function( event )
    storyboard.gotoScene("Scenes.MainMenu", options )
end

media.playVideo( "Video/Ladybird.mp4", false, introComplete )


