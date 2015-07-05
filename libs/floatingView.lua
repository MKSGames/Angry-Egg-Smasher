local Utils = require("libs.Utils")
local M = {}
M.previousDelay = 0
M.float = function(object,duration)
    local startX = object.x
    local startY = object.y
    local floatUp
    local floatDown
    
    function floatUp()
        transition.to( object, {time = duration,y = startY - 15,transition = easing.inOutQuad, onComplete = floatDown })
    end
    
    function floatDown()
        transition.to( object, {time = duration,y = startY + 15,transition = easing.inOutQuad, onComplete = floatUp })
    end
    
    math.randomseed( math.random(math.random(500)) )
    local delay = math.random(0, 800)
    local deltaDelay = delay - M.previousDelay
    if math.modf(deltaDelay) < 50  then
        math.randomseed( delay )
        delay = math.random(deltaDelay , 800)
    end
--    print("previous Delay  " .. M.previousDelay , "new delay  " ..delay)
    M.previousDelay = delay
    timer.performWithDelay(delay, function() floatUp() end)
    
end


M.endFloat = function(object)
    transition.cancel(object)
end


return M
