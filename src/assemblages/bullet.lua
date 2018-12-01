local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")

local C = require("src.components")

return Concord.assemblage(function(e, position, velocity)
   e:give(C.transform, position, 0)
    :give(C.sprite, love.graphics.newQuad(5, 243, 6, 10, 320, 384), "main")
    :give(C.speed, velocity, 0.99)
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 2), "game", e)
end)
