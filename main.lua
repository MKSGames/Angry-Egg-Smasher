storyboard = require "storyboard"
require("antCreate")
require("antCreateZigZag")
require("antCreateCross")
require("antCreateOrbit")
require("ice")
require("saveScore")
--require("shareApp")
require("bounce")
require("beat")
local promotionView = require("libs.promotionView")
Analytics = require("analytics")
settings = require("gameSettings")
local loadsave = require("loadsave")
local json = require("json")
myAds = require("myAds")
gameNetwork = require "gameNetwork"
-- Init game network to use Google Play game services
gameNetwork.init("google")



local musicSound
local gameSound

score = 0
orbitFlag = true
timerId = nil

local serverSettings = nil--loadsave.loadTable("settings.json")
if serverSettings ~=nil then
    print("ffffffff",serverSettings.ad_type )
    if serverSettings.ad_type == "vungle" then
        myAds.initVungle()
	-- elseif serverSettings.adtype == "chartboost" then
	-- 	myAds.initChartboost()
    elseif serverSettings.ad_type == "inneractive" then
        myAds.initInneractive()
    else	
        myAds.initAdmob()
    end
else
    --myAds.initVungle()
    myAds.initAdmob()
    
end

TOTAL_WIDTH = display.viewableContentWidth
TOTAL_HEIGHT = display.viewableContentHeight
bufferWidth = (display.contentWidth - display.viewableContentWidth ) / 2
bufferWidthRatio = display.viewableContentWidth / display.contentWidth 
bufferHeight = (display.contentHeight - display.viewableContentHeight ) / 2
bufferHeightRatio = display.viewableContentHeight / display.contentHeight
CENTER_X = display.contentCenterX
CENTER_Y = display.contentCenterY

audio.reserveChannels(2)
mainMenuBgSound = audio.loadSound( "sounds/menu_bg.ogg" )
antSound = {}
for i = 1,8 do
    antSound[i] = audio.loadSound( "sounds/ant" .. i .. ".ogg" )
end
optionSound = audio.loadSound( "sounds/option.ogg" )
tickSound = audio.loadSound( "sounds/tick.mp3" )  -- change sound  in option menu
beeSmashSound = audio.loadSound( "sounds/ouch.ogg" ) 
beeSound = audio.loadSound( "sounds/bee.ogg" ) 
lifeLost = audio.loadSound( "sounds/life_lost.wav" ) 
lifeGain = audio.loadSound( "sounds/life_gain.ogg" )

--audio.setVolume( 0.15, { channel=2 } )


optionIce = ice:loadBox( "values" )
optionIce:storeIfNew( "background", 1 )
optionIce:storeIfNew( "musicSound", 1 )
optionIce:storeIfNew( "gameSound", 1 )


-- default scores
scoreIce = ice:loadBox( "scores" )
scoreIce:storeIfNew( "Player 1", 0 )

minScore = ice:loadBox( "minScore" )
maxScore = ice:loadBox( "maxScore" )
scoreIce:save()
optionIce:save()


musicSound = optionIce:retrieve("musicSound")
gameSound = optionIce:retrieve("gameSound")
if musicSound == 1 then 
    audio.setVolume(1,{channel = 1})
else
    audio.setVolume(0,{channel = 1})	
end
if gameSound == 1 then
    audio.setVolume(1,{channel = 2})	
else
    audio.setVolume(0,{channel = 2})	
end		

bgChannel = audio.play( mainMenuBgSound, { channel=1, loops=-1, fadein=3000 } )
storyboard.gotoScene( "menu", "fade", 1000 )

local function gameSettings( event )
    if ( event.isError ) then
        print( "Network error!")
    else
        print ( "game settings RESPONSE:"  )
        local t = json.decode( event.response )
        
        -- Go through the array in a loop
        if t.save_settings == true then
            print("settings saved")
            loadsave.saveTable( t, "settings.json" )
        end
        
    end
end

network.request( "http://gaak.atwebpages.com/game_settings.php", "GET", gameSettings )
promotionView.initDefaults()
network.request( "http://gaak.atwebpages.com/gamePromotion.php", "GET", promotionView.onApiComplete )
Analytics.init("XBKT9J549VB7SJNXM9SF")
timer.performWithDelay(500, function()
    gameNetwork.request("login",
    {
        userInitiated = true
    }) 
end)

print("buffer width",bufferWidth,bufferWidthRatio)
print("buffer height",bufferHeight,bufferHeightRatio)
print(display.viewableContentHeight,display.viewableContentWidth)
print(display.contentHeight,display.contentWidth)
print(display.actualContentHeight,display.actualContentWidth)