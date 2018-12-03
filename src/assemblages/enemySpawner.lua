local Concord = require("lib.concord")

local C = require("src.components")

return Concord.assemblage(function(e, position)
   e:give(C.transform, position)
    :give(C.enemySpawner, love.math.random(80, 130) / 10)
end)
