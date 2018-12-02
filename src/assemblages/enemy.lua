local Concord = require("lib.concord")
local Shapes  = require("lib.hc.shapes")
local Quad = require("src.classes.quad")

local C = require("src.components")

local function collisionCallback(eShape, otherShape, sepX, sepY)
   local e = eShape.entity
   local eTransform = e[C.transform]

   local shouldResolve = false
   local other = otherShape.entity

   if not other then
      shouldResolve = true
   else
      local otherCollider = other[C.collider]
      if otherCollider.isSolid then
         shouldResolve = true
      end
   end

   if shouldResolve then
      eShape:move(sepX, sepY)

      eTransform.position.x = eTransform.position.x + sepX
      eTransform.position.y = eTransform.position.y + sepY
   end
end

return Concord.assemblage(function(e, position, target)
   e:give(C.transform, position, 0)
    :give(C.sprite, Quad(0, 128, 16, 16, 320, 384), "main")
    :give(C.collider, Shapes.CircleShape(position.x, position.y, 5), "game", true, false, collisionCallback)
    :give(C.health, 100)
    :give(C.enemyControls, target)
end)
