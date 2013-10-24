--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:74321fb8d19f998c8d607d21e3d059cf:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 2_image001-1
            x=124,
            y=132,
            width=61,
            height=58,

        },
        {
            -- Untitled-1
            x=124,
            y=2,
            width=298,
            height=128,

            sourceX = 23,
            sourceY = 10,
            sourceWidth = 480,
            sourceHeight = 320
        },
        {
            -- background
            x=2,
            y=2,
            width=120,
            height=246,

            sourceX = 2,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 256
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["2_image001-1"] = 1,
    ["Untitled-1"] = 2,
    ["background"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
