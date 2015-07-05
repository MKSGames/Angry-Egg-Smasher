require("spriteAnim")
require("smash")

CreateAntFast = {
    new = function(group,setSeq)
        
        local endTime = 2000
        local diffTime = 1000
        if (score < 1200 )then
            endTime = math.random(1900,2100)
            diffTime = 200
        elseif(score < 200 )then
            endTime = math.random(1800,1900)
            diffTime = 200
        elseif(score < 3500 )then
            endTime = math.random(1700,1800)
            diffTime = 200
        elseif(score < 5500 )then
            endTime = math.random(1600,1700)
            diffTime = 200
        else
            endTime = math.random(1400,1600)
            diffTime = math.random(200,300)
        end	
        
        endTime = endTime * settings.gameSpeed
        
        local ant = SpriteAnim.new()
        ant.taps = 0
        ant:scale(1.5, 1.5)
        ant:addEventListener("touch",Smash.new)
        ant:setSequence(setSeq)
        ant:play()
        ant.x = math.random(700)
        ant.y = 1280
        --ant.rotation = 180
        group:insert( ant )
        ant:addEventListener( "sprite", SpriteAnim.spriteListener )
        
        
            transition.to( ant, {  y = ant.y - math.random(200,300), time=endTime ,onComplete= function()  
                
                    transition.to( ant, { y = ant.y - math.random(200,500), time=endTime - 1200,onComplete= function() 
                        
                            transition.to( ant, {  y = 0 , time=endTime ,onComplete= function() 
                                
                                SpriteAnim.endLife(ant) ; ant:removeSelf(); ant = nil
                                
                                
                        end })
                        
                end})
                
        end})
        
        
        
    end
    
    
}