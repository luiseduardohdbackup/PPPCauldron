local aspectRatio = display.pixelHeight / display.pixelWidth

application = 
{
  content = {
        width = 320,
        height = 480, 
        scale = "letterbox",
        imageSuffix =
        {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
        },
    }

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
