local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")

local C = require("src.components")

local function collisionCallback(eShape, otherShape, sepX, sepY)
   local e = eShape.entity
   local eTransform = e[C.transform]

   eShape:move(sepX, sepY)

   eTransform.position.x = eTransform.position.x + sepX
   eTransform.position.y = eTransform.position.y + sepY
end

return Concord.assemblage(function(e, position)
   e:give(C.transform, position, 0)
    :give(C.sprite, love.graphics.newQuad(0, 128, 16, 16, 320, 384), "main")
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 5), "game", collisionCallback)
    :give(C.playerControls,
      {"key:up",    "key:w", "axis:lefty-", "button:dpup"},
      {"key:down",  "key:s", "axis:lefty+", "button:dpdown"},
      {"key:left",  "key:a", "axis:leftx-", "button:dpleft"},
      {"key:right", "key:d", "axis:leftx+", "button:dpright"},
      {"key:space", "button:a"})
    :give(C.spells, 1)
    :give(C.team, true)
end)
