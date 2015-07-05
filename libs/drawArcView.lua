local FloatingView = require("libs.floatingView")
local M = {}
M.drawArc = function(tableObj,target,radius)
    local  size = #tableObj
    for i=1,size do
        
--          local sub_angel = (i/size) * math.rad(90);
--          local x = radius * (math.sin(sub_angel) * 1 + (1-math.cos(sub_angel)) *(1))
--          local y = target.y + radius * (math.sin(sub_angel) * 1.3 + (1-math.cos(sub_angel)) * (-1))
        --   now plot green point at (xi, yi)
--        180 / 
        local angel = math.rad(i * (360/size));
        local x = target.x + radius * math.cos(angel);
        local y = target.y + radius * math.sin(angel);
        tableObj[i].x = x
        tableObj[i].y = y
        
    end
end



return M
