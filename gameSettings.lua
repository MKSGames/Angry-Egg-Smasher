local GameSettings = {}

local GameSettings_mt = { __index = GameSettings }



--- Initiates a new GGFont object.
-- @return The new object.
function GameSettings:new()
    
    local self = {}
    
    setmetatable( self, GameSettings_mt )
    
	self.gameSpeed = 0.85
    
    return self
    
end

_G.gameSettings = GameSettings:new()
return _G.gameSettings