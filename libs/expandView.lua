require("spriteAnim")
local PowerSprite = require("powerSprites")
local powers = require("powers")
local GameStore = require("gameStore")
local M = {}

M.expandingViews = {}

M.initView = function(gameGroup,powerGroup,viewData,x,y)
    --    M.controllerButton = PowerSprite.getPowerSack()
    --    M.controllerButton:setSequence(M.controllerButton.sequence3)
    --    M.controllerButton:play()
    --    M.controllerButton.x = x
    --    M.controllerButton.y = y
    --    M.controllerButton.isOpened = false
    --    M.controllerButton:scale(.75,.75)
    --    gameGroup:insert(M.controllerButton)
    for i=1,#viewData do
        M.expandingViews[i] = display.newGroup()
        M.expandingViews[i].x = x
        M.expandingViews[i].y = y
        M.expandingViews[i].targetGrp = viewData[i].targetGrp
        M.expandingViews[i].imagePath = viewData[i].image_path
        M.expandingViews[i].dragImagePath = viewData[i].drag_image_path
        M.expandingViews[i].name = viewData[i].name
        M.expandingViews[i].powerGroup = powerGroup
        M.expandingViews[i].availableCount = viewData[i].count
        M.expandingViews[i]:scale(1.15,1.15)
        M.expandingViews[i].image = display.newImage(M.expandingViews[i],M.expandingViews[i].imagePath)
        M.expandingViews[i].powerCountText = display.newText(M.expandingViews[i],"",0,0,native.systemFont, 25)
        local power = M.expandingViews[i].image
        local powerCount = M.expandingViews[i].powerCountText
        powerCount.x = power.x + 32
        powerCount.y = power.y - 32
        powerCount.text = GameStore.getPowerCount(M.expandingViews[i].name)
        gameGroup:insert(M.expandingViews[i])
    end
    --    M.controllerButton.tapListener = function(event)
    --        if not gamePause then
    --            event.target:removeEventListener("tap", M.controllerButton.tapListener)
    --            if M.controllerButton.isOpened then
    --                M.closeView(600)
    --            else
    --                M.openView(600)
    --            end
    --        end
    --    end
    --    
    --    M.controllerButton:addEventListener("tap", M.controllerButton.tapListener)
    M.openViewWithoutAnimation()
end

M.openViewWithoutAnimation = function()
    local size = #M.expandingViews
    for i=1,size do
        local object = M.expandingViews[i]
        object.y = object.y + 145 * i
        object:addEventListener("touch",M.powerListener)    
    end
end

M.openView = function(duration)
    M.controllerButton.isOpened = true
    local size = #M.expandingViews
    local segmentDuration = duration/size
    for i=1,size do
        local object = M.expandingViews[i]
        transition.to(object, {time = segmentDuration , delay = segmentDuration * (i-1), 
            y = object.y + 100 * i,onComplete = function()
                if i == size then
                    M.controllerButton:addEventListener("tap", M.controllerButton.tapListener)
                end
            end
        }) 
        
        object:addEventListener("touch",M.powerListener)    
    end
end

M.closeView = function(duration)
    M.controllerButton.isOpened = false
    local size = #M.expandingViews
    local segmentDuration = duration/size
    for i=size,1,-1 do
        local object = M.expandingViews[i]
        transition.to(object, {time = segmentDuration , delay = segmentDuration * math.abs(size - i), 
            y = object.y - (100 * i),onComplete = function()
                if i == 1 then
                    M.controllerButton:addEventListener("tap", M.controllerButton.tapListener)
                end
        end}) 
        
        object:removeEventListener("touch",M.powerListener)    
    end
end


M.powerListener =function(event)
    local target = event.target 
    if GameStore.getPowerCount(target.name)  > 0 and not gamePause then
        if event.phase == "began" then
            -- set touch focus
            display.getCurrentStage():setFocus( target )
            target.isFocus = true
            target.dragObj = display.newImage(target.dragImagePath)
            --            if target.name == powers.rolling then
            --                target.dragObj = PowerSprite.getBall()
            --                
            --            elseif target.name == powers.electric then
            --                target.dragObj = PowerSprite.getElectric()
            --                
            --            elseif target.name == powers.roaming then
            --                target.dragObj = SpriteAnim.roamingBomb()
            --                
            --            end
            target.parent:insert(target.dragObj)
            --                target.dragObj.x = event.x
            --                target.dragObj.y = event.y
            print("began")
            
        elseif target.isFocus then
            if event.phase == "moved" then
                target.dragObj.x = event.x
                target.dragObj.y = event.y
            elseif event.phase == "ended" or event.phase == "cancelled" then
                -- reset touch focus
                display.getCurrentStage():setFocus( nil )
                target.isFocus = nil
                target.dragObj:removeSelf()
                target.dragObj = nil
                local deltaX = math.abs(event.x - event.xStart)
                local deltaY = math.abs(event.y - event.yStart)
                if deltaX > 20 or deltaY > 20 then
                    local powerGroup = target.powerGroup
                    GameStore.usePower(target.name)
                    ice:saveBox("powerCount")
                    if target.name == powers.rolling then
                        powers.getRollingStone().startRoll(powerGroup,target.targetGrp,event.x,event.y)
                    elseif target.name == powers.electric then
                        powers.getThunder().start(powerGroup,target.targetGrp,event.y)
                    elseif target.name == powers.roaming then
                        local roamBomb = powers.getRoamingBomb()
                        roamBomb.start(powerGroup,target.targetGrp,event.x,event.y,"left")
                        roamBomb.startWalking({target = roamBomb.bomb})
                    end
                    target.powerCountText.text = GameStore.getPowerCount(target.name)
                end
            end
        end
    else
        -- power count is 0 do some animation
    end
    return true
end 



return M

