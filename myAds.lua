local MyAds = {}

local ads = require("ads")
-- local chartboost = require( "plugin.chartboost" )

local ADMOB_BANNER = "ca-app-pub-7238691034583818/8541037885"
local ADMOB_INTERSTITIAL = "ca-app-pub-7238691034583818/2494504280"
local VUNGLE_APP_ID = "5526e29bd7a9db645b00002d";
local CHARTBOOST_APP_ID = "552707ee0d602565b7cb7837";
local CHARTBOOST_SIGNATURE_ID = "260aff912ffe646cbeee1d89cdace05ed94cf843";
local INNERACTIVE_APP_ID = "cappoapps_AntSmasher_Android"


local ADMOB_BANNER_PARAMS = { x=0, y=1170,interval=50,appId="ca-app-pub-7238691034583818/8541037885"}
local ADMOB_PARAMS = { x=0, y=1125,interval=40,appId="ca-app-pub-7238691034583818/8541037885"}
local ADMOB_INTERSTITIAL_PARAMS = { x=0, y=1125,interval=40,appId="ca-app-pub-7238691034583818/2494504280"}
local VUNGLE_PARAMS = { isAnimated=false, isBackButtonEnabled=true }
local INNERACTIVE_PARAMS =  { x=0, y=1170,interval=30}
local adType = nil

function MyAds.initVungle()
	local function adListener( event )
	    if ( event.type == "adStart" and event.isError ) then
	        --Cached video ad not available for display
	    end
	end

	adType = "vungle"
	ads.init(adType,VUNGLE_APP_ID,adListener)
end


function MyAds.initAdmob()
	adType = "admob"
	ads.init(adType,ADMOB_BANNER)
end

function MyAds.initInneractive()
	adType = "inneractive"
	ads.init( adType, INNERACTIVE_APP_ID, adListener )
end

function MyAds.show(type)
	print("type")
	if(adType == "vungle") then
		local val = ads.show( "interstitial", VUNGLE_PARAMS )		
	
	elseif (adType == "admob") then
		if (type == "interstitial") then
			ads.show(type,ADMOB_INTERSTITIAL_PARAMS)
		else
			if type == nil then 
				ads.show("banner",ADMOB_BANNER_PARAMS)
			else
				ads.show(type,ADMOB_BANNER_PARAMS)
			end
		end	
	-- elseif (adType == "chartboost") then
	-- 	 if not chartboost.hasCachedInterstitial() then
 --            native.showAlert( "No ad available", "Please cache an ad.", { "OK" })
 --        else
 --            chartboost.show( "interstitial" )
 --        end	
 	elseif (adType == "inneractive") then
		if type == nil then 
			ads.show("banner",INNERACTIVE_PARAMS)
 		else
 			ads.show( type, INNERACTIVE_PARAMS )
		end
	end
end


function MyAds.hide()
	ads.hide()
end

-- function MyAds.initChartboost()
-- 	adType = "chartboost"
-- 	-- The ChartBoost listener function
-- 	local function chartBoostListener( event )
-- 	    for k, v in pairs( event ) do
-- 	        print( tostring(k).. "=".. tostring(v) )
-- 	    end
-- 	end

-- 	-- Initialise ChartBoost
-- 	chartboost.init {
-- 	        appID        = CHARTBOOST_APP_ID,
-- 	        appSignature = CHARTBOOST_SIGNATURE_ID, 
-- 	        listener     = chartBoostListener
-- 	    }

-- 	local function systemEvent( event )
-- 	    local phase = event.phase

-- 	    if event.type == "applicationResume" then
-- 	        -- Start a ChartBoost session
-- 	        chartboost.startSession( CHARTBOOST_APP_ID, CHARTBOOST_SIGNATURE_ID )
-- 			native.showAlert( "Resumed", "Please cache an ad.", { "OK" })
-- 	    end
	    
-- 	    return true
-- 	end

-- 	Runtime:addEventListener( "system", systemEvent )
-- end


return MyAds