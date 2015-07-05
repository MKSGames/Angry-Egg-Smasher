local M = {}

M.pressed = "pressed"
M.normal = "normal"
M.shaking = "shaking"

M.getShakeEgg = function()
    local sequenceData =
    {
        {
            name = M.shaking,
            frames = {1,5,4,1,2,3},
            time = 750,
            loopCount = 0
        }
    }
    
    
    local sheetData = { width=250, height=400, numFrames=5, sheetContentWidth=1250, sheetContentHeight=400 }
    
    local spriteSheet = graphics.newImageSheet( "sprites/eggShake.png", sheetData )
    local spriteSet = display.newSprite( spriteSheet, sequenceData )
    return spriteSet
    
end

M.getPlayBtn = function()
    local sequenceData =
    {
        {
            name = M.normal,
            frames = {1},
        },{
            name = M.pressed,
            frames = {2},
        }
    }
    
    
    local sheetData = { width=100, height=50, numFrames=2, sheetContentWidth=200, sheetContentHeight=50 }
    
    local spriteSheet = graphics.newImageSheet( "sprites/playButton.png", sheetData )
    local spriteSet = display.newSprite( spriteSheet, sequenceData )
    return spriteSet
    
end


return M
