local FloatingView = require("libs.floatingView")
local DrawArcView = require("libs.drawArcView")
local AndroidShare = require("libs.androidShare")
local rateApp = require("rateThisApp")
local scene = storyboard.newScene()

storyboard.purgeOnSceneChange = true
local fbPageId = "1731917597035541"
local getBgIndex
local bg
local bgOverlay
local restart
local yourScore
local scoreBar
local highScore
local shareScore
local min_high_score
local shareScore
local tempFlag = true
local resetGroup
local googleLeaderBoard
local shareGame
local rateGame

--functions
local onKeyEvent
local onClickSocial
local showLeaderboardListener
local restartGame
local getHighScore
local showAds
local submitScoreListener

-- Values
local xScaleMax = 1.25
local xScaleMin = 0.8
local yScaleMin = 0.8
local yScaleMax = 1.25


function scene:createScene(event)
    resetGroup = self.view
    tempFlag = true
    getBgIndex = optionIce:retrieve("background")
    bg = display.newImage(resetGroup,"images/bg_game" .. getBgIndex .. ".jpg",display.contentCenterX,display.contentCenterY)
    bgOverlay = display.newImage(resetGroup,"images/game_over_background_overlay.png",display.contentCenterX,display.contentCenterY)
    scoreBar = display.newImage(resetGroup,"images/score_bar.png",display.contentCenterX,display.contentCenterY)
    yourScore = display.newText(resetGroup,score,bufferWidth + 465, bufferHeight + 420,"Base 02",40)
    highScore = display.newText(resetGroup,getHighScore(),bufferWidth + 465, bufferHeight + 520,"Base 02",40)
    
    restart = display.newImage(resetGroup,"images/start.png",display.contentCenterX,display.contentCenterY + 400)
    restart:scale(1.3, 1.3)
    restart.name = "game"
    local childY = display.contentCenterY + 160
    googleLeaderBoard = display.newImage(resetGroup,"images/google_leaderboard_new.png",bufferWidth + 100,childY)
    shareGame = display.newImage(resetGroup,"images/share_new.png",CENTER_X , childY)
    shareGame.name = "share"
    rateGame = display.newImage(resetGroup,"images/rate_new.png",bufferWidth + TOTAL_WIDTH - 100,childY)
    rateGame.name = "rate"
    
    function onKeyEvent(event)
	
        if event.phase=="down" and event.keyName=="back" then 
            storyboard.gotoScene("menu", "fade", 400 )
            Analytics.logEvent("return_main_menu")
            return true
        end
        return false
    end
    
    --SaveScore.new(900,resetGroup,playerName)
--    min_score()
    submitScoreListener(score)
    FloatingView.float(restart, 800)    
end

function scene:enterScene(event)
    restart:addEventListener("touch",restartGame)
    googleLeaderBoard:addEventListener("touch", showLeaderboardListener)
    shareGame:addEventListener("touch", onClickSocial)
    rateGame:addEventListener("touch", onClickSocial)
    Runtime:addEventListener( "key", onKeyEvent )
    showAds()
end

function scene:exitScene(event)
    myAds.hide()
    Runtime:removeEventListener( "key", onKeyEvent )
    if tempFlag then
        scoreIce:storeIfHigher( "No-Name", score )
        scoreIce:save()
    end
    transition.cancel()
    
end

function scene:destroyScene(event)
    print("destroy")
end




showAds = function()
    if score < 100 then
        myAds.show()
        else if score > 1500 then
            myAds.show("interstitial") 
        else
            if math.random(3) ~= 1 then
                myAds.show()
            else
                myAds.show("interstitial") 
            end	
        end
    end
end

getHighScore = function()
    local highScore = maxScore:retrieve("max")
    if score > highScore then
        if score > 500 then
            rateApp.rateApp(true)
        end
        maxScore:storeIfHigher("max",score)
        return score
    else
        return highScore
    end
end

restartGame = function(event)
    local target = event.target
    local bounds = target.contentBounds
    
    if event.phase == "began" then
        target.isExpanded = true
        target:scale(xScaleMax,yScaleMax)
        display.getCurrentStage():setFocus( target )
        target.isFocus = true
    elseif target.isFocus then
        if event.phase == "moved" then
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if target.isExpanded ~= nil and target.isExpanded then
                target:scale(xScaleMin,yScaleMin)
                target.isExpanded = nil
            end
            display.getCurrentStage():setFocus( nil )
            target.isFocus = false
            if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                    SoundControl.Menu()
                    storyboard.gotoScene( target.name, "fade", 250 )
                    Analytics.logEvent("restart_game")
                end
            end
            
        end
    end
    
    return true
end

onClickSocial = function(event)
    local target = event.target
    local bounds = target.contentBounds
    
    if event.phase == "began" then
        target.isExpanded = true
        target:scale(xScaleMax,yScaleMax)
        display.getCurrentStage():setFocus( target )
        target.isFocus = true
    elseif target.isFocus then
        if event.phase == "moved" then
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                    if target.name == "rate" then
                        Analytics.logEvent("rate_app_click")
                        system.openURL("market://details?id=".. system.getInfo("androidAppPackageName") )
                    elseif target.name == "share" then
                        AndroidShare.share("images/share_app.jpg", "Check out this cool new game I played.")
                        Analytics.logEvent("android_share")
                    elseif target.name == "fbLike" then
                        Analytics.logEvent("fb_like")
                        system.openURL("fb://page/" .. fbPageId )
                    elseif target.name == "buyApp" then
                        Analytics.logEvent("buy_click")
                        system.openURL("market://details?id=com.gaakapps.antsmasherpaid" )
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

showLeaderboardListener = function(event)
    
    local target = event.target
    local bounds = target.contentBounds
    
    if event.phase == "began" then
        target.isExpanded = true
        target:scale(xScaleMax,yScaleMax)
        display.getCurrentStage():setFocus( target )
        target.isFocus = true
    elseif target.isFocus then
        if event.phase == "moved" then
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if(event.x > bounds.xMin  and event.x < bounds.xMax) then
                if  (event.y > bounds.yMin  and event.y < bounds.yMax) then
                    if gameNetwork.request("isConnected") then
                        gameNetwork.show("leaderboards") -- Shows all the leaderboards.
                    else
                        --                        Tries to login the user, if there is a problem then it 
                        --                        will try to resolve it. eg. Show the log in screen.
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

submitScoreListener = function (val)
        gameNetwork.request("setHighScore", 
        {
            localPlayerScore = 
            {
                category = leaderboardId, -- Id of the leaderboard to submit the score into
                value = val -- The score to submit
            }
        })
    end
scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )


return scene