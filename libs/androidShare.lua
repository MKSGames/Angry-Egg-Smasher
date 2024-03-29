local M = {}

-- add dependencies plugin in build settings 


M.share = function(imageName,gameMessage)
    local popupName = "social"
    local isAvailable = native.canShowPopup( popupName, "share" )
    if isAvailable then
        local listener = {}
        function listener:popup( event )
            print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )			
        end
        
        -- Show the popup
        native.showPopup( popupName,
        {
            service = "share", -- The service key is ignored on Android.
            message = gameMessage,
            listener = listener,
            image = 
            {
                { filename = imageName, baseDir = system.ResourceDirectory },
            },
            url = 
            { 
                "https://play.google.com/store/apps/details?id=" .. system.getInfo( "androidAppPackageName" )
            }
        })
    else
        print("Android Share Error")
    end
end


return M

