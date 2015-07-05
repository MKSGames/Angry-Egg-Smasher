local M = {}
module( ..., package.seeall )
local json = require("json")
local votarandroid
local rateThis
local rateBox
function rateThis(isForceShow)
    rateBox = ice:loadBox( "myRate" );
    local time = rateBox:retrieve( "time" );
    local currentVersion = rateBox:retrieve( "popup_version" );
    local previousVersion = rateBox:retrieve( "popup_previous_version" );
    
    network.request( "http://gaak.atwebpages.com/rate_popup.php", "GET", function(event)
        print ( "call back"  )
        if ( event.isError ) then
            print( "Network error!")
        else
            local t = json.decode( event.response )
            if previousVersion == nil or t.popup_version > previousVersion then
                currentVersion = t.popup_version
                rateBox:store("popup_version",currentVersion);
                rateBox:save();
                print("version", currentVersion)
            end
            
        end
    end
    )
    
    if ((currentVersion ~= nil and previousVersion ~= nil and currentVersion ~= previousVersion) or isForceShow ) and time ~= 5  then
        Analytics.logEvent("rate_app_shown")
        native.showAlert("ENJOYING The Game!!" , "How would you rate Ant Smasher",
        { "Rate 5 stars", "Later" }, votarandroid )
        
    elseif time == nil  then
        -- FIRST TIME ENTERING YOUR APP
        time =1;
        rateBox:store("time",time);
        rateBox:save();
        return true;
    elseif time == 5 then
        -- THE USER DO NOT WANT TO RATE YOUR APP OR HE ALREADY MADE
        return true;
    elseif time < 4 then
        time = time+1
        print(time)
        rateBox:store("time",time);
        rateBox:save();
        return true; 
    elseif time == 4 then
        Analytics.logEvent("rate_app_shown")
        native.showAlert("ENJOYING The Game!!" , "How would you rate Ant Smasher",
        { "Rate 5 stars", "Later" }, votarandroid )
        
    end
    
end

function votarandroid( event )
        if "clicked" == event.action then
            local i = event.index
            if 1 == i then
                Analytics.logEvent("rate_app_click")
                time = 5
                rateBox:store("time",time);
                rateBox:save();
                system.openURL("market://details?id=" .. system.getInfo("androidAppPackageName") )
            elseif 2 == i then
                time = -2
                rateBox:store("popup_previous_version",currentVersion);
                rateBox:store("time",time);
                rateBox:save();
            end
        end
    end
    
    
M.rateApp = function(isForce)
    if isForce == nil then
        isForce = false
    end
    rateThis(isForce)
end

return M
