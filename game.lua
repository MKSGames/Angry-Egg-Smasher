require("gameEngine")
local scene = storyboard.newScene()
storyboard.purgeOnSceneChange = true

group = nil

local menu
local bg
local getBgIndex
local scoreBar
local scoreText
local maxScoreText
local getMaxScore
local pauseButton
local pauseBar
--global
lives = {}
numLives = 3
score = 0
gameOver = false

local onKeyEvent
local scoreFront
local adGroup = display.newGroup()
local pauseGame
local pauseToggle
gamePause = false

local function getAds()
    local ads={}
    local iconAds = {"spelltheword","dressupfree","balloonpop"}
    local bannerAds = {"fruitshoot"}
    for i=1,1 do
        local pos = math.random(#bannerAds)
        table.insert( ads, i, bannerAds[pos] )
        table.remove( bannerAds, pos )
    end
    for i=1,2 do
        local pos = math.random(#iconAds)
        table.insert( ads, i+1, iconAds[pos] )
        table.remove( iconAds, pos )
    end
    return ads
end

local function adClick(event)
    local target = event.target
    
    system.openURL("market://details?id=com.gaakapps."..target.url )
end



local function showAds(target)
    if adGroup == nil then
        adGroup = display.newGroup()
    end
    target:removeEventListener("tap",pauseGame)
    local group = target.parent
    local image = getAds()
    group:insert(adGroup)
    adGroup.anchorChildren = true
    adGroup.x = display.contentCenterX
    adGroup.y = display.contentCenterY
    local bannerAd = display.newImage(adGroup,"ads/".. image[1] ..".jpg",display.contentCenterX, display.contentCenterY/2 + 50)
    bannerAd.url = image[1]
    local iconAdOne = display.newImage(adGroup,"ads/".. image[2] ..".png",display.contentCenterX-200, (3*display.contentCenterY)/2)
    iconAdOne.url = image[2]
    local iconAdTwo = display.newImage(adGroup,"ads/".. image[3] ..".png",display.contentCenterX+200, (3*display.contentCenterY)/2)
    iconAdTwo.url = image[3]
    bannerAd:addEventListener("tap", adClick)
    iconAdOne:addEventListener("tap", adClick)
    iconAdTwo:addEventListener("tap", adClick)
        transition.from(adGroup, {time = 200,xScale =0.01,yScale=0.01,onComplete = function() 
    target:addEventListener("tap",pauseGame) end })
end

local function hideAds(target)
    target:removeEventListener("tap",pauseGame)
        transition.to(adGroup, {time = 200,xScale =0.01,yScale=0.01,onComplete = function() 
            adGroup:removeSelf()
            adGroup=nil
            target:addEventListener("tap",pauseGame)
    end })
end
 function pauseGame( event )
    local target = event.target
   pauseToggle(target)
end

 function pauseToggle(target)
    if target.pauseState == false then
        GameEngine.pause(pauseBar)
        target.pauseState = true
        --        showAds(target)
    else
        GameEngine.resume(pauseBar)
        target.pauseState = false
        --        hideAds(target)
    end
end

function scene:createScene(event)
    group = self.view
    numLives = 3
    score = 0
    gamePause = false
    gameOver = false
    getBgIndex = optionIce:retrieve("background")
    getMaxScore = maxScore:retrieve("max")
    bg = display.newImage(group,"images/bg_game" .. getBgIndex .. ".jpg",display.contentCenterX,display.contentCenterY)
    scoreBar = display.newImage(group,"images/score-bar.png",display.contentCenterX, bufferHeight + 140)
    scoreText = display.newText(group,score , 140 , bufferHeight + 65 ,"Base 02",30)
    for i=1,numLives do 
        lives[i] = display.newImage(group,"images/life.png",display.contentCenterX - 90 + (50 * i) , bufferHeight + 65)
    end
    maxScoreText = display.newText(group,getMaxScore , display.viewableContentWidth - 135 , bufferHeight + 65 ,"Base 02",30)
    pauseButton = display.newImage(group,"images/pause.png",display.contentCenterX, bufferHeight + 140)
    pauseButton.pauseState = false
    pauseBar = display.newImage(group,"images/pause_bar.png",-display.contentCenterX, display.contentCenterY)
    
    --CreateAnt.new(group)
    --timer.performWithDelay(2500,aaa,10)
    --CreateAntOrbit.new(group)
    GameEngine.new(group)
    
    print("game mmm",gameOver)
    
    function scoreFront(event)
        scoreText.text = score
        if(score > getMaxScore ) then
            maxScoreText.text = score
        end
        scoreBar:toFront()
        scoreText:toFront()
        maxScoreText:toFront()
        if numLives > 0 then
            for i=1,numLives do 
                lives[i]:toFront()
            end
        else
            transition.cancel()
            gameOver = true
            storyboard.gotoScene( "restartView", "fade", 400 )
        end	
        
        if score % 50 == 40 then
        end
        if score % 300 == 250  then
            if isPower then
                if math.random(3) ~= 1 then
                    GainLife.gain(group)
                else	
--                    orbitFlag = true
--                    CreateAntOrbit.new(group,"bee")
                end	
                isPower = false
            end	
        else
            isPower = true
        end
	
    end
    
    function onKeyEvent(event)
	
        local phase = event.phase
        
        if event.phase=="down" and event.keyName=="back" then
            if pauseButton.pauseState then
                pauseToggle(pauseButton)
            else
                transition.cancel()
                gameOver = true
                storyboard.gotoScene( "menu", "fade", 400 )
            end
            return true
        end
        return false
    end
    
end


function scene:enterScene(event)
    myAds.show()
    Runtime:addEventListener( "enterFrame", scoreFront)
    Runtime:addEventListener( "key", onKeyEvent )
    pauseButton:addEventListener("tap",pauseGame)
    print("enter")
end


function scene:exitScene(event)
    myAds.hide()
    Runtime:removeEventListener( "enterFrame", scoreFront)
    Runtime:removeEventListener( "key", onKeyEvent )
    pauseButton:removeEventListener("tap",pauseGame)
    transition.cancel()
end

function scene:destroyScene(event)
    print("destroy")
end



scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )


return scene