require("spriteAnim")
require("smash")
CreateAntTwin = {
    new = function(group,setSeq)
        
        
        local ant = SpriteAnim.new()
        ant.taps = 0
        ant:scale(1.5, 1.5)
        local endTime = 10000
        if (score < 200 )then
            endTime = 7500
        elseif 	(score < 500 )then
            endTime = 6500
        elseif 	(score < 800 )then
            endTime = 5000
        elseif 	(score < 1200 )then
            endTime = 4500
        elseif 	(score < 1500 )then
            endTime = 4000
        elseif 	(score < 2500 )then
            endTime = 3700
        else
            endTime = 3300
        end
        
        endTime = endTime * settings.gameSpeed
        
        ant:setSequence(setSeq)
        ant:play()
        ant.x = display.contentCenterX - 100
        group:insert( ant )
        ant:addEventListener( "sprite", SpriteAnim.spriteListener )
        ant:addEventListener("touch",Smash.new)
        
        local ant1
        --ant1.rotation = 180
        if math.random( 8 ) == 4 then 
                setSeq = "egg"
                ant1 = SpriteAnim.angel()
        else
            ant1 = SpriteAnim.new()
        end
        ant1.taps = 0
        ant1:addEventListener("touch",Smash.new)
        ant1:setSequence(setSeq)
        ant1:play()
        ant1.x = display.contentCenterX + 100
        group:insert( ant1 )
        ant1:addEventListener( "sprite", SpriteAnim.spriteListener )
        
        
        transition.from(ant,{y = 1280,time=endTime, onComplete = function() SpriteAnim.endLife(ant) ; ant:removeSelf(); ant = nil end })
        transition.from(ant1,{y = 1280,time=endTime, onComplete = function() SpriteAnim.endLife(ant1) ; ant1:removeSelf(); ant1 = nil end })
          
    end
    
    
}