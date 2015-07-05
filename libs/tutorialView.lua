local M = {}
local screenW = display.contentWidth
local screenH = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
M.imagesGrp = display.newGroup()
local viewGrp
local leftButton
local rightButton
local leftDirection = "left"
local rightDirection = "right"
local images = {}
local imgNum = 1
--functions
local moveImage
local nextImage
local prevImage

M.init = function(imageSet,leftImage,rightImage)
    imgNum = 1
    viewGrp = display.newGroup()
    local tutorialShadow = display.newRect(viewGrp, centerX, centerY, screenW, screenH)
    tutorialShadow:setFillColor(0, 0, 0)
    tutorialShadow.alpha = 0.6
    for i = 1,#imageSet do
        
        print(i,imageSet[i])
        local image = display.newImage(imageSet[i])
        if (i > 1) then
            image.x = screenW * 1.5
        else
            image.x = screenW * 0.5
        end   
        image.y = centerY
        images[i] = image
        viewGrp:insert(image)
    end
    leftButton = display.newImage(viewGrp,leftImage)
    leftButton.x = centerX - leftButton.contentWidth * 0.75
    leftButton.y = screenH - 200
    leftButton.name = leftDirection
    leftButton.isVisible = false
    rightButton = display.newImage(viewGrp,rightImage)
    rightButton.x = centerX + rightButton.contentWidth * 0.75
    rightButton.y = screenH - 200
    rightButton.name = rightDirection
    
    rightButton:addEventListener("tap", moveImage)
    leftButton:addEventListener("tap", moveImage)
    return viewGrp
end

M.destroy = function()
    if viewGrp ~= nil then
        viewGrp:removeSelf()
        viewGrp = nil
    end
end

moveImage = function(event)
    local target = event.target
    if target.name == leftDirection then
        prevImage()
    elseif target.name == rightDirection then
        nextImage()
    end
end

function nextImage()
    if imgNum < #images then
        transition.to( images[imgNum], {time=400, x =  - screenW * .5, transition=easing.outExpo } )
        transition.to( images[imgNum+1], {time=400, x = screenW * .5 , transition=easing.outExpo } )
        imgNum = imgNum + 1
        leftButton.isVisible = true
        if imgNum == #images then
            rightButton.isVisible = false
        end
    end
end

function prevImage()
    
    if imgNum > 1 then
        transition.to( images[imgNum-1], {time=400, x =  screenW * .5, transition=easing.outExpo } )
        transition.to( images[imgNum], {time=400, x = screenW * 1.5 , transition=easing.outExpo } )
        imgNum = imgNum - 1
        rightButton.isVisible = true
        if imgNum == 1 then
            leftButton.isVisible = false
        end
    end
end


return M
