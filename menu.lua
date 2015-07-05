require("soundControl")
local scene = storyboard.newScene()
local promotionView = require("libs.promotionView")
local androidShare = require("libs.androidShare")
local spriteMenu = require("spriteMenu")
local rateApp = require("rateThisApp")

leaderboardId = "CgkI0b2V88cUEAIQBQ" -- Your leaderboard id here

storyboard.purgeOnSceneChange = true
local TXT_GAME = "game"
local TXT_OPTIONS = "options"


local bgImage
local bgTitle
local bgShakingEgg
local bgStart
local bgOptions
--local leaderBoard
local googleLeaderBoard
local shareGame
local moreApps
local bgGroup
local adBalloon
local adDress
local bgLogo
local ad2048
local adNum
local promoBanner
local promoYes
local promoNo
local promoGroup
local openApp
local onKeyEvent
local exitGame
local arcGrp
local xScaleMax = 1.25
local xScaleMin = 0.8
local yScaleMin = 0.8
local yScaleMax = 1.25



function onKeyEvent(event)
    
    local phase = event.phase
    
    if event.phase=="down" and event.keyName=="back" then
        --promoGroup.isVisible = true
        exitGame()
        return true
    end
    return false
end

function scene:createScene(event)
    if 	audio.isChannelPlaying( 1 ) == false then
        bgChannel = audio.play( mainMenuBgSound, { channel=1, loops=-1, fadein=3000 } )
    end
    -- Tries to automatically log in the user without displaying the login screen if the user doesn't want to login
    
    arcGrp = {}
    bgGroup = self.view
    promoGroup = display.newGroup()
    bgImage = display.newImage(bgGroup,"images/bg_image.jpg",display.contentCenterX,display.contentCenterY)
    --bgImage:scale(bufferWidthRatio,bufferHeightRatio)
    --    bgTitle = display.newImage(bgGroup,"images/title.png",display.contentCenterX, bufferHeight + 230)--bgImage:scale(bufferWidthRatio,bufferHeightRatio)
    bgTitle = display.newImage(bgGroup,"images/title.png",display.contentCenterX, bufferHeight + 230)
    bgTitle.x = CENTER_X
    bgTitle.y = bufferHeight + 230
    
    bgShakingEgg = spriteMenu.getShakeEgg()
    bgShakingEgg:scale(1.7, 1.7)
    bgShakingEgg.x = CENTER_X
    bgShakingEgg.y = CENTER_Y + 50
    bgShakingEgg:setSequence(spriteMenu.shaking)
    bgShakingEgg:play()
    bgGroup:insert(bgShakingEgg)
    
    bgStart = display.newImage(bgGroup,"images/play.png",display.contentCenterX,display.contentCenterY + 320)
    bgStart.name = TXT_GAME
    
    bgOptions = display.newImage(bgGroup,"images/options.png",TOTAL_WIDTH - 70 , display.viewableContentHeight - 200)
    bgOptions.name = TXT_OPTIONS
    
    googleLeaderBoard = display.newImage(bgGroup,"images/google_leaderboard.png",bufferWidth + 70 , display.viewableContentHeight - 400)
    
--    shareGame = display.newImage(bgGroup,"images/share.png",bufferWidth + 70 , display.viewableContentHeight - 200)
--    shareGame.name = "share"
    
    bgLogo = display.newImage(bgGroup,"images/rate.png",bufferWidth + 70 , display.viewableContentHeight - 200)
    bgLogo.name = "rate"
    
    moreApps = display.newImage(bgGroup,"images/more_apps.png", TOTAL_WIDTH - 70 , display.viewableContentHeight - 400)
    moreApps.name = "moreApps"
     --    leaderBoard = display.newImage(bgGroup,"images/standings.png",bufferWidth + 100 , display.viewableContentHeight - 200)
    
    promoBanner = display.newImage(promoGroup,"images/promo.jpg",display.contentCenterX, display.contentCenterY - 200 - bufferHeight)
    promoYes = display.newImage(promoGroup,"images/yes.png",display.contentCenterX - promoBanner.contentWidth / 2 , display.contentCenterY - 200  - promoBanner.contentHeight / 2 - bufferHeight)
    promoNo = display.newImage(promoGroup,"images/no.png",display.contentCenterX + promoBanner.contentWidth / 2, display.contentCenterY - 200 - promoBanner.contentHeight / 2 - bufferHeight)
    bgGroup:insert(promoGroup)
    promoGroup.isVisible = false
    
    adNum = math.random(1,3)
    adBalloon = display.newImage(bgGroup,"images/ad_CS_game.png",display.contentCenterX,display.contentHeight - bufferHeight - 50)
    adBalloon.isVisible = true
    adDress = display.newImage(bgGroup,"images/ad_dress.png",display.contentCenterX,display.contentHeight - bufferHeight - 50)
    adDress.isVisible = false
    ad2048 = display.newImage(bgGroup,"images/ad_AS_game.png",display.contentCenterX,display.contentHeight - bufferHeight - 50)
    ad2048.isVisible = false
    if adNum == 1 then
        adDress.isVisible = true
        adBalloon.isVisible = false
        ad2048.isVisible = false
    elseif adNum == 2 then 
        adDress.isVisible = false
        adBalloon.isVisible = false
        ad2048.isVisible = true
    end
    
end

function scene:enterScene(event)
    --sort the scores
    SaveScore.scoreSort()
    rateApp.rateApp(false)
    
    local function goToPage(event)
        local target = event.target
        local bounds = target.contentBounds
        
        if event.phase == "began" then
            target.isExpanded = true
            target:scale(xScaleMax,yScaleMax)
            display.getCurrentStage():setFocus( target )
            self.isFocus = true
        elseif self.isFocus then
            if event.phase == "moved" then
            elseif event.phase == "ended" or event.phase == "cancelled" then
                if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                    if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                        audio.stop( bgChannel )
                        SoundControl.Menu()
                        storyboard.gotoScene( target.name, "fade", 250 )
                    end
                end
                if target.isExpanded ~= nil and target.isExpanded then
                    target:scale(xScaleMin,yScaleMin)
                    target.isExpanded = nil
                end
                display.getCurrentStage():setFocus( nil )
                target.isFocus = false
            end
        end
        
        return true
    end
    
    local function goBalloon(event)
        if event.phase == "began" then
            Analytics.logEvent("banner_ad",{name = "ballon"})
            system.openURL("market://details?id=com.gaakapps.cocksmash" )
        end
    end
    local function goDress(event)
        if event.phase == "began" then
            Analytics.logEvent("banner_ad",{name = "dress up"})
            system.openURL("market://details?id=com.gaakapps.dressupfree" )
        end	
    end
    local function go2048(event)
        if event.phase == "began" then
            Analytics.logEvent("banner_ad",{name = "2048"})
            system.openURL("market://details?id=com.gaakapps.antsmasher" )
        end	
    end
    
    local function highScore(event)
        
        local target = event.target
        local bounds = target.contentBounds
        
        if event.phase == "began" then
            
            target.isExpanded = true
            target:scale(xScaleMax,yScaleMax)
            display.getCurrentStage():setFocus( target )
            self.isFocus = true
        elseif self.isFocus then
            if event.phase == "moved" then
            elseif event.phase == "ended" or event.phase == "cancelled" then
                
                
                if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                    if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                        
                        
                        local function onKeyEvent(event)
                            
                            local phase = event.phase
                            
                            if event.phase=="up" and event.keyName=="back" then 
                                Bounce.pullUp(bgGroup)
                                Runtime:removeEventListener( "key", onKeyEvent )
                                return true
                            end
                            return false
                        end
                        
                        local function pullUp(event)
                            Bounce.pullUp(bgGroup)
                            Runtime:removeEventListener( "key", onKeyEvent )
                        end
                        
                        --local gp = display.newGroup()
                        local gp = self.view
                        local container = display.newImage(gp,"images/bg_image.jpg",display.contentCenterX, -display.contentCenterY)
                        local bgTitle = display.newText(gp,"Local Scores",display.contentCenterX ,- display.viewableContentHeight +  bufferHeight + 120, "Easter Sunrise",70)
                        local bgBack = display.newText(gp,"BACK",display.contentCenterX , -bufferHeight-150, "Easter Sunrise",80)
                        local tempName,tempScores = SaveScore.scoreSort()
                        SaveScore.print(tempName,tempScores,gp)
                        Bounce.new(gp)
                        
                        Runtime:addEventListener( "key", onKeyEvent )
                        bgBack:addEventListener("tap",pullUp)	
                        
                    end
                end
                
                if target.isExpanded ~= nil and target.isExpanded then
                    target:scale(xScaleMin,yScaleMin)
                    target.isExpanded = nil
                end
                display.getCurrentStage():setFocus( nil )
                target.isFocus = false
            end
        end
        return true
    end
    
    local function googleServiceLogin(event)
        
        
        local target = event.target
        local bounds = target.contentBounds
        
        if event.phase == "began" then
            target.isExpanded = true
            target:scale(xScaleMax,yScaleMax)
            display.getCurrentStage():setFocus( target )
            self.isFocus = true
        elseif self.isFocus then
            if event.phase == "moved" then
            elseif event.phase == "ended" or event.phase == "cancelled" then
                
                if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                    if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                        
                        if gameNetwork.request("isConnected") then
                            gameNetwork.request("logout")
                        else
                            -- Tries to login the user, if there is a problem then it will try to resolve it. eg. Show the log in screen.
                            gameNetwork.request("login",
                            {
                                userInitiated = true
                            })
                        end
                    end
                end
                
                if target.isExpanded ~= nil and target.isExpanded then
                    target:scale(xScaleMin,yScaleMin)
                    target.isExpanded = nil
                end
                display.getCurrentStage():setFocus( nil )
                target.isFocus = false
            end
        end
        return true
    end
    
    
    local function showLeaderboardListener(event)
        
        local target = event.target
        local bounds = target.contentBounds
        
        if event.phase == "began" then
            
            target.isExpanded = true
            target:scale(xScaleMax,yScaleMax)
            display.getCurrentStage():setFocus( target )
            self.isFocus = true
        elseif self.isFocus then
            if event.phase == "moved" then
            elseif event.phase == "ended" or event.phase == "cancelled" then
                
                if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                    if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                        if gameNetwork.request("isConnected") then
                            gameNetwork.show("leaderboards") -- Shows all the leaderboards.
                        else
                            -- Tries to login the user, if there is a problem then it will try to resolve it. eg. Show the log in screen.
                            gameNetwork.request("login",
                            {
                                userInitiated = true
                            })
                        end
                    end
                end
                
                if target.isExpanded ~= nil and target.isExpanded then
                    target:scale(xScaleMin,yScaleMin)
                    target.isExpanded = nil
                end
                display.getCurrentStage():setFocus( nil )
                target.isFocus = false
            end
        end
        return true
    end
    
    local function yes( event )
        native.requestExit()
        
    end
    
    local function no( event )
        promoGroup.isVisible = false
        
    end
    
    function openApp( event)
        local target = event.target
        if target.name == "rate" then
            
            Analytics.logEvent("rate_app_click")
            system.openURL("market://details?id=".. system.getInfo("androidAppPackageName") )
        elseif target.name == "promotion" then
            promoGroup.isVisible = false
            system.openURL("market://details?id=com.gaakapps.fruitshoot" )
        end
        
    end 
    
    local function onClickIcon(event)
        local target = event.target
        local bounds = target.contentBounds
        
        if event.phase == "began" then
            target.isExpanded = true
            target:scale(xScaleMax,yScaleMax)
            display.getCurrentStage():setFocus( target )
            self.isFocus = true
        elseif self.isFocus then
            if event.phase == "moved" then
            elseif event.phase == "ended" or event.phase == "cancelled" then
                if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                    if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                        if target.name == "share" then
                            androidShare.share("images/share_app.jpg", "Check out this cool new game i played.")
                            Analytics.logEvent("android_share")
                        elseif target.name == "moreApps" then
                            Analytics.logEvent("more_apps")
                            system.openURL("market://search?q=pub:mks@gaakapps" )
                        end
                    end
                end
                if target.isExpanded ~= nil and target.isExpanded then
                    target:scale(xScaleMin,yScaleMin)
                    target.isExpanded = nil
                end
                display.getCurrentStage():setFocus( nil )
                target.isFocus = false
            end
        end
        return true
    end
    
    promoBanner:addEventListener("tap",openApp)
    promoYes:addEventListener("tap",yes)
    promoNo:addEventListener("tap",no)
    bgStart:addEventListener("touch",goToPage)
    bgOptions:addEventListener("touch",goToPage)
    
    adDress:addEventListener("touch", goDress)
    adBalloon:addEventListener("touch", goBalloon)
    ad2048:addEventListener("touch", go2048)
    
    bgLogo:addEventListener("tap", openApp)
    --    leaderBoard:addEventListener("touch", highScore)
    googleLeaderBoard:addEventListener("touch", showLeaderboardListener)
--    shareGame:addEventListener("touch", onClickIcon)
    moreApps:addEventListener("touch",onClickIcon)
    Runtime:addEventListener( "key", onKeyEvent )
    
end



function scene:exitScene(event)
    bgLogo:removeEventListener("tap", openApp)
    Runtime:removeEventListener( "key", onKeyEvent )
    
end

function scene:destroyScene(event)
    print("destroy")
end

function exitGame()
    if promotionView.canShowPromotion() and promotionView.showPromotion() ~= nil then
        Analytics.logEvent("promotion_shown")
        promotionView.showPromotion()
    else
        print("exit game")
        native.requestExit()    
    end
end


scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )


return scene