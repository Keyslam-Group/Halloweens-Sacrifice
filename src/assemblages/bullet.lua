local Concord = require('lib.concord')
local Shapes = require('lib.hc.shapes')
local Quad = require('src.classes.quad')

local C = require('src.components')

local function collisionCallback(eShape, otherShape)
   local e = eShape.entity
   local other = otherShape.entity

   local shouldResolve = false

   if not other then
      shouldResolve = true
   else
      local otherCollider = other[C.collider]
      if otherCollider.isSolid then
         shouldResolve = true
      end
   end

   if shouldResolve then
      if other then
         local eCollider = e[C.collider]
         local otherCollider = other[C.collider]

         local eDamage = e[C.damage]
         local otherHealth = other[C.health]

         if eDamage and otherHealth then
            if eCollider.isFriendly ~= otherCollider.isFriendly then
               otherHealth.health = otherHealth.health - eDamage.damage

               if otherHealth.health <= 0 then
                  other:destroy()
               end

               e:destroy()
            end
         end
      else
         e:destroy()
      end
   end
end

return Concord.assemblage(
   function(e, position, velocity, damage, isFriendly)
      e:give(C.transform, position, 0)
       :give(C.sprite, Quad(5, 243, 6, 10, 320, 384), 'main')
       :give(C.speed, velocity)
       :give(C.collider, Shapes.CircleShape(position.x, position.y, 2), 'game', false, isFriendly, collisionCallback)
       :give(C.damage, damage)
    end
)
