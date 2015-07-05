local M = {}

local shakeEasing = function(currentTime, duration, startValue, targetDelta)
    print(currentTime,duration,startValue,targetDelta)
	local shakeAmplitude = 100 -- maximum shake in pixels, at start of shake
	local timeFactor = (duration-currentTime)/duration -- goes from 1 to 0 during the transition
	local scaledShake =( timeFactor*shakeAmplitude)+1 -- adding 1 prevents scaledShake from being less then 1 which would throw an error in the random code in the next line
	local randomShake = math.random(scaledShake)
	return startValue + randomShake - scaledShake*0.5 -- the last part detracts half the possible max shake value so the shake is "symmetrical" instead of always being added at the same side
end -- shakeEasing

 -- use the displayObjects current x and y as parameter
M.shake = function(object)
    transition.to(object, {time = 1000, x = object.x - 50, y = object.y, transition = easing.inBack})
end


return M
