local json = require("json")
local facebook = require("facebook")
local fbCommand
local fbAppId
local isLoggedIn = false
local M = {}


local function fbListener( event )
    
    if ( "session" == event.type ) then
        print( "Session Status: " .. event.phase )
        if event.phase ~= "login" then
            print("facebook login error" , event.response)
            native.showAlert( "Facebook", "Login Fail" .. event.response )
            return
        else
            isLoggedIn = true
            native.showAlert( "Facebook", "Login Successfull" .. event.response )
        end
        
    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        
        if ( not event.isError ) then
            response = json.decode( event.response )
            
        native.showAlert( "Facebook", "Request " .. event.response )
            if fbCommand == GET_USER_INFO then
                --statusMessage.textObject.text = response.name
                print( "name", response.name )
                
                
            elseif fbCommand == SHARE_APP then
                
            else
                -- Unknown command response
                print( "Unknown command response" )
            end
            
        else
            -- Post Failed
            printTable( event.response, "Post Failed Response", 3 )
        end
        
    elseif ( "dialog" == event.type ) then
        native.showAlert( "Facebook", "Dialog " .. event.response )
        print( "dialog response:", event.response )
    end
end


M.login = function(appId)
    fbAppId = appId
    facebook.login( appId, fbListener, {"publish_actions"} )
end


M.showDialog  = function()
     local action = {name = "PLay Now",link = "https://play.google.com/store/apps/details?id=com.gaakapps.cocksmash"}
    facebook.showDialog( "feed", {app_id = "117188648491159",
        name = "Ant Smasher",
        caption = "dkgsabfa" ,
        description = "Hey friends I scored " .. " in Ant Smasher. You want to give it a try ?",
        picture="http://s5.postimg.org/evpp0t27r/cockroach_smasher.png",
        link = "https://play.google.com/store/apps/details?id=com.gaakapps.antsmasher",
        actions = json.encode(action)
    })
end

M.shareApp = function(data)
    if data == nil then
        data =  {
            name = "Ant Smasher",
            caption = "GAAK APPS" ,
            description = "A cool and really simple game for children and adults. Play for joy and have fun smashing ants and bugs.",
            picture="http://i61.tinypic.com/2n0lgqq.png",
            link = "https://play.google.com/store/apps/details?id=com.gaakapps.antsmasher"
        }
    end
    facebook.showDialog( "feed",data)
end

M.sendAppRequest = function(messageText,titleText,action)
    if action == nil then
        action = "send"
    end
    facebook.showDialog( "apprequests", { message = messageText, title = titleText, actionType = action } )
end

M.requestMe = function()
    if isLoggedIn then
        facebook.request( "me" )
    else
        M.login(fbAppId)
    end
end




return M
