require("spriteAnim")
require("smash")
CreateAntLine = {
    new = function(group,setSeq,posX)
        
        local endTime = 8000
        local toFro
        if (score < 400 )then
            endTime = math.random(6000,7000)
        elseif (score < 900 )then
            endTime = math.random(5000,6000)
        elseif (score < 1500 )then
            endTime = math.random(3500,5100)
        elseif (score < 2000 )then
            endTime = math.random(3000,4200)
        else
            endTime = math.random(2800,3500)
        end	
        
        endTime = endTime * settings.gameSpeed
        
        local ant
        if math.random( 8 ) == 4 then 
                setSeq = "egg"
                ant = SpriteAnim.angel()
        else
            ant = SpriteAnim.new()
        end
        ant:scale(1.5, 1.5)
        ant.taps = 0
        --ant.rotation = 180
        ant:setSequence(setSeq)
        ant:play()
        ant.x =  posX
        group:insert( ant )
        ant:addEventListener("touch",Smash.new)
        ant:addEventListener( "sprite", SpriteAnim.spriteListener )
        
        transition.from(ant,{y = 1280,time=endTime, onComplete = function() SpriteAnim.endLife(ant) ; ant:removeSelf(); ant = nil end })
                
    end
    
    
}