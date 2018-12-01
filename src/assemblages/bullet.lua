local Concord = require("lib.concord")
local Vector  = require("lib.vector")

local C = require("src.components")

return Concord.assemblage(function(e, position, velocity)
   e:give(C.transform, position, 0)
    :give(C.sprite, love.graphics.newQuad(5, 243, 6, 10, 320, 384), "background")
    :give(C.speed, velocity, 0.99)
end)