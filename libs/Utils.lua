math.randomseed( os.time() )
local M = {}

M.shuffleTable = function( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function M.printTable ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end



M.isRectIntersect = function(r1, r2)
    
    return  not (r2.xMin > r1.xMax or 
           r2.xMax < r1.xMin or 
           r2.yMin > r1.yMax or
           r2.yMax < r1.yMin)
end

M.getRandom = function(from,to)
    math.randomseed(math.random(math.random(500)))
    
    if from == nil and to == nil then
        return math.random()
    elseif to == nil then 
        return math.random(from)
    else 
        return math.random(from,to)
    end
    
    
end

return M